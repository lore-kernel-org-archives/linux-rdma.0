From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RFC PATCH 07/11] IB/mad: Change slid in RMPP recv from 16 to 32 bits
Date: Fri, 23 Sep 2016 13:44:30 -0400
Message-ID: <1474652674-13110-8-git-send-email-ira.weiny@intel.com>
References: <1474652674-13110-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474652674-13110-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

OPA devices will contain larger lids in the wc.slid
which is now 32 bits. This change ensures RMPP handler
is able to retrieve the correct lid.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad_rmpp.c | 22 ++++++++++++++++++----
 include/rdma/ib_addr.h             | 12 ++++++++++++
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index 1fc9469b5e66..1cc452c2e03d 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -33,6 +33,7 @@
  */
 
 #include <linux/slab.h>
+#include <rdma/ib_addr.h>
 
 #include "mad_priv.h"
 #include "mad_rmpp.h"
@@ -64,7 +65,7 @@ struct mad_rmpp_recv {
 
 	__be64 tid;
 	u32 src_qp;
-	u16 slid;
+	u32 slid;
 	u8 mgmt_class;
 	u8 class_version;
 	u8 method;
@@ -316,7 +317,7 @@ create_rmpp_recv(struct ib_mad_agent_private *agent,
 	mad_hdr = &mad_recv_wc->recv_buf.mad->mad_hdr;
 	rmpp_recv->tid = mad_hdr->tid;
 	rmpp_recv->src_qp = mad_recv_wc->wc->src_qp;
-	rmpp_recv->slid = (u16)mad_recv_wc->wc->slid;
+	rmpp_recv->slid = mad_recv_wc->wc->slid;
 	rmpp_recv->mgmt_class = mad_hdr->mgmt_class;
 	rmpp_recv->class_version = mad_hdr->class_version;
 	rmpp_recv->method  = mad_hdr->method;
@@ -337,7 +338,7 @@ find_rmpp_recv(struct ib_mad_agent_private *agent,
 	list_for_each_entry(rmpp_recv, &agent->rmpp_list, list) {
 		if (rmpp_recv->tid == mad_hdr->tid &&
 		    rmpp_recv->src_qp == mad_recv_wc->wc->src_qp &&
-		    rmpp_recv->slid == (u16)mad_recv_wc->wc->slid &&
+		    rmpp_recv->slid == mad_recv_wc->wc->slid &&
 		    rmpp_recv->mgmt_class == mad_hdr->mgmt_class &&
 		    rmpp_recv->class_version == mad_hdr->class_version &&
 		    rmpp_recv->method == mad_hdr->method)
@@ -850,11 +851,14 @@ out:
 static int init_newwin(struct ib_mad_send_wr_private *mad_send_wr)
 {
 	struct ib_mad_agent_private *agent = mad_send_wr->mad_agent_priv;
+	struct ib_device *ib_dev = agent->qp_info->port_priv->device;
+	u8 port = agent->qp_info->port_priv->port_num;
 	struct ib_mad_hdr *mad_hdr = mad_send_wr->send_buf.mad;
 	struct mad_rmpp_recv *rmpp_recv;
 	struct ib_ah_attr ah_attr;
 	unsigned long flags;
 	int newwin = 1;
+	u32 dlid;
 
 	if (!(mad_hdr->method & IB_MGMT_METHOD_RESP))
 		goto out;
@@ -870,7 +874,17 @@ static int init_newwin(struct ib_mad_send_wr_private *mad_send_wr)
 		if (ib_query_ah(mad_send_wr->send_buf.ah, &ah_attr))
 			continue;
 
-		if (rmpp_recv->slid == ah_attr.dlid) {
+		if (rdma_cap_opa_ah(ib_dev, port)) {
+			if ((ah_attr.ah_flags & IB_AH_GRH) &&
+			    (ib_is_opa_gid(&ah_attr.grh.dgid)))
+				dlid = opa_get_lid_from_gid(&ah_attr.grh.dgid);
+			else
+				dlid = OPA_TO_IB_UCAST_LID(ah_attr.dlid);
+		} else {
+			dlid = ah_attr.dlid;
+		}
+
+		if (rmpp_recv->slid == dlid) {
 			newwin = rmpp_recv->repwin;
 			break;
 		}
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 0d4fa0cdf0ab..fbd532652655 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -347,4 +347,16 @@ static inline bool ib_is_opa_gid(union ib_gid *gid)
 		OPA_STL_OUI);
 }
 
+/**
+ * opa_get_lid_from_gid: Returns the last 32 bits of the gid.
+ * OPA devices use one of the gids in the gid table to also
+ * store the lid.
+ *
+ * @gid: The Global identifier
+ */
+static inline u32 opa_get_lid_from_gid(union ib_gid *gid)
+{
+	return be64_to_cpu(gid->global.interface_id) & 0xFFFFFFFF;
+}
+
 #endif /* IB_ADDR_H */
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
