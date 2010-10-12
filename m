From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC 2/2] IB/umad: Export mad snooping capability to userspace
Date: Tue, 12 Oct 2010 12:13:00 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7DAA129@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Export the mad snooping capability to user space clients
through the existing umad interface.  This will allow
users to capture MAD data for debugging, plus it allows
for services to act on MAD traffic that occurs.  For example,
a daemon could snoop SA queries and CM messages as part of
providing a path record caching service.  (It could cached
snooped path records, record the average time needed for the
SA to respond to queries, use CM timeouts as an indication
that cached data may be stale, etc.)

Because such services may become crucial to support large
clusters, mad snooping capabilities are not limited to
a debugging interface.

Backwards compatibility is maintained by using the upper bit
of the QPN to indicate if a user is registering to send/receive
MADs or only wishes to snoop traffic.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/user_mad.c |  134 ++++++++++++++++++++++++++++++------
 include/rdma/ib_user_mad.h         |   33 ++++++++-
 2 files changed, 143 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 5fa8569..e666038 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -252,6 +252,80 @@ err1:
 	ib_free_recv_mad(mad_recv_wc);
 }
 
+static void snoop_send_handler(struct ib_mad_agent *agent,
+			       struct ib_mad_send_wc *send_wc)
+{
+	struct ib_umad_file *file = agent->context;
+	struct ib_umad_packet *packet;
+	struct ib_mad_send_buf *msg = send_wc->send_buf;
+	struct ib_rmpp_mad *rmpp_mad;
+	int data_len;
+	u32 seg_num;
+
+	data_len = msg->seg_count ? msg->seg_size : msg->data_len;
+	packet = kzalloc(sizeof *packet + msg->hdr_len + data_len, GFP_KERNEL);
+	if (!packet)
+		return;
+
+	packet->length = msg->hdr_len + data_len;
+	packet->mad.hdr.status = send_wc->status;
+	packet->mad.hdr.timeout_ms = msg->timeout_ms;
+	packet->mad.hdr.retries = msg->retries;
+	packet->mad.hdr.length = hdr_size(file) + packet->length;
+
+	if (msg->seg_count) {
+		rmpp_mad = msg->mad;
+		seg_num = be32_to_cpu(rmpp_mad->rmpp_hdr.seg_num);
+		memcpy(packet->mad.data, msg->mad, msg->hdr_len);
+		memcpy(((u8 *) packet->mad.data) + msg->hdr_len,
+		       ib_get_rmpp_segment(msg, seg_num), data_len);
+	} else {
+		memcpy(packet->mad.data, msg->mad, packet->length);
+	}
+
+	if (queue_packet(file, agent, packet))
+		kfree(packet);
+}
+
+static void snoop_recv_handler(struct ib_mad_agent *agent,
+			       struct ib_mad_recv_wc *mad_recv_wc)
+{
+	struct ib_umad_file *file = agent->context;
+	struct ib_umad_packet *packet;
+	struct ib_mad_recv_buf *recv_buf = &mad_recv_wc->recv_buf;
+
+	packet = kzalloc(sizeof *packet + sizeof *recv_buf->mad, GFP_KERNEL);
+	if (!packet)
+		return;
+
+	packet->length = sizeof *recv_buf->mad;
+	packet->mad.hdr.length = hdr_size(file) + packet->length;
+	packet->mad.hdr.qpn = cpu_to_be32(mad_recv_wc->wc->src_qp);
+	packet->mad.hdr.lid = cpu_to_be16(mad_recv_wc->wc->slid);
+	packet->mad.hdr.sl = mad_recv_wc->wc->sl;
+	packet->mad.hdr.path_bits = mad_recv_wc->wc->dlid_path_bits;
+	packet->mad.hdr.pkey_index = mad_recv_wc->wc->pkey_index;
+	packet->mad.hdr.grh_present = !!(mad_recv_wc->wc->wc_flags & IB_WC_GRH);
+	if (packet->mad.hdr.grh_present) {
+		struct ib_ah_attr ah_attr;
+
+		ib_init_ah_from_wc(agent->device, agent->port_num,
+				   mad_recv_wc->wc, mad_recv_wc->recv_buf.grh,
+				   &ah_attr);
+
+		packet->mad.hdr.gid_index = ah_attr.grh.sgid_index;
+		packet->mad.hdr.hop_limit = ah_attr.grh.hop_limit;
+		packet->mad.hdr.traffic_class = ah_attr.grh.traffic_class;
+		memcpy(packet->mad.hdr.gid, &ah_attr.grh.dgid, 16);
+		packet->mad.hdr.flow_label = cpu_to_be32(ah_attr.grh.flow_label);
+	}
+
+	memcpy(packet->mad.data, recv_buf->mad, packet->length);
+
+	if (queue_packet(file, agent, packet))
+		kfree(packet);
+}
+
 static ssize_t copy_recv_mad(struct ib_umad_file *file, char __user *buf,
 			     struct ib_umad_packet *packet, size_t count)
 {
@@ -603,8 +677,9 @@ static int ib_umad_reg_agent(struct ib_umad_file *file, void __user *arg,
 {
 	struct ib_user_mad_reg_req ureq;
 	struct ib_mad_reg_req req;
+	struct ib_mad_snoop_reg_req snoop_req;
 	struct ib_mad_agent *agent = NULL;
-	int agent_id;
+	int agent_id, snoop;
 	int ret;
 
 	mutex_lock(&file->port->file_mutex);
@@ -620,6 +695,8 @@ static int ib_umad_reg_agent(struct ib_umad_file *file, void __user *arg,
 		goto out;
 	}
 
+	snoop = ureq.qpn & IB_UMAD_SNOOP;
+	ureq.qpn &= ~IB_UMAD_SNOOP;
 	if (ureq.qpn != 0 && ureq.qpn != 1) {
 		ret = -EINVAL;
 		goto out;
@@ -633,28 +710,41 @@ static int ib_umad_reg_agent(struct ib_umad_file *file, void __user *arg,
 	goto out;
 
 found:
-	if (ureq.mgmt_class) {
-		req.mgmt_class         = ureq.mgmt_class;
-		req.mgmt_class_version = ureq.mgmt_class_version;
-		memcpy(req.oui, ureq.oui, sizeof req.oui);
-
-		if (compat_method_mask) {
-			u32 *umm = (u32 *) ureq.method_mask;
-			int i;
-
-			for (i = 0; i < BITS_TO_LONGS(IB_MGMT_MAX_METHODS); ++i)
-				req.method_mask[i] =
-					umm[i * 2] | ((u64) umm[i * 2 + 1] << 32);
-		} else
-			memcpy(req.method_mask, ureq.method_mask,
-			       sizeof req.method_mask);
-	}
+	if (snoop) {
+		snoop_req.mgmt_class = ureq.mgmt_class;
+		snoop_req.mgmt_class_version = ureq.mgmt_class_version;
+		memcpy(snoop_req.oui, ureq.oui, sizeof snoop_req.oui);
+		snoop_req.errors = ureq.filter.errors;
+		snoop_req.attr_id = ureq.filter.attr_id;
+
+		agent = ib_register_mad_snoop(file->port->ib_dev, file->port->port_num,
+					      ureq.qpn ? IB_QPT_GSI : IB_QPT_SMI,
+					      &snoop_req, snoop_send_handler,
+					      snoop_recv_handler, file);
+	} else {
+		if (ureq.mgmt_class) {
+			req.mgmt_class         = ureq.mgmt_class;
+			req.mgmt_class_version = ureq.mgmt_class_version;
+			memcpy(req.oui, ureq.oui, sizeof req.oui);
+
+			if (compat_method_mask) {
+				u32 *umm = (u32 *) ureq.method_mask;
+				int i;
+
+				for (i = 0; i < BITS_TO_LONGS(IB_MGMT_MAX_METHODS); ++i)
+					req.method_mask[i] =
+						umm[i * 2] | ((u64) umm[i * 2 + 1] << 32);
+			} else
+				memcpy(req.method_mask, ureq.method_mask,
+				       sizeof req.method_mask);
+		}
 
-	agent = ib_register_mad_agent(file->port->ib_dev, file->port->port_num,
-				      ureq.qpn ? IB_QPT_GSI : IB_QPT_SMI,
-				      ureq.mgmt_class ? &req : NULL,
-				      ureq.rmpp_version,
-				      send_handler, recv_handler, file);
+		agent = ib_register_mad_agent(file->port->ib_dev, file->port->port_num,
+					      ureq.qpn ? IB_QPT_GSI : IB_QPT_SMI,
+					      ureq.mgmt_class ? &req : NULL,
+					      ureq.rmpp_version,
+					      send_handler, recv_handler, file);
+	}
 	if (IS_ERR(agent)) {
 		ret = PTR_ERR(agent);
 		agent = NULL;
diff --git a/include/rdma/ib_user_mad.h b/include/rdma/ib_user_mad.h
index d6fce1c..0c40861 100644
--- a/include/rdma/ib_user_mad.h
+++ b/include/rdma/ib_user_mad.h
@@ -165,10 +165,36 @@ struct ib_user_mad {
 typedef unsigned long __attribute__((aligned(4))) packed_ulong;
 #define IB_USER_MAD_LONGS_PER_METHOD_MASK (128 / (8 * sizeof (long)))
 
+enum {
+	IB_UMAD_QP0,
+	IB_UMAD_QP1,
+	IB_UMAD_SNOOP = 0x80,
+	IB_UMAD_SNOOP_QP0 = IB_UMAD_SNOOP & IB_UMAD_QP0,
+	IB_UMAD_SNOOP_QP1 = IB_UMAD_SNOOP & IB_UMAD_QP1
+};
+
+/**
+ * ib_user_mad_snoop_filter - additional filter applied to snooped MADs
+ * @attr_id: If non-zero, specifies that the reported MADs must
+ *   reference the indicated attribute identifier.
+ * @errors: If non-zero, indicates that the caller only wishes to
+ *   view sent MADs which complete in error, or received responses
+ *   which contain a non-zero status value.  MADs that complete as
+ *   canceled are not reported if errors is non-zero.
+ * @reserved: Must be set to 0.
+ */
+struct ib_user_mad_snoop_filter {
+	u16	attr_id;
+	u8	errors;
+	u8	reserved[13];
+};
+
 /**
  * ib_user_mad_reg_req - MAD registration request
  * @id - Set by the kernel; used to identify agent in future requests.
- * @qpn - Queue pair number; must be 0 or 1.
+ * @qpn - Queue pair number; must be 0 or 1.  If the upper bit of the qpn
+ *   is set to 1, then the registration will be set to snoop traffic
+ *   over that QP.
  * @method_mask - The caller will receive unsolicited MADs for any method
  *   where @method_mask = 1.
  * @mgmt_class - Indicates which management class of MADs should be receive
@@ -183,7 +209,10 @@ typedef unsigned long __attribute__((aligned(4))) packed_ulong;
  */
 struct ib_user_mad_reg_req {
 	__u32	id;
-	packed_ulong method_mask[IB_USER_MAD_LONGS_PER_METHOD_MASK];
+	union {
+		packed_ulong method_mask[IB_USER_MAD_LONGS_PER_METHOD_MASK];
+		struct ib_user_mad_snoop_filter filter;
+	};
 	__u8	qpn;
 	__u8	mgmt_class;
 	__u8	mgmt_class_version;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
