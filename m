From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 12/14] IB/mad: Add partial Intel OPA MAD support
Date: Sat,  6 Jun 2015 14:38:33 -0400
Message-ID: <1433615915-24591-13-git-send-email-ira.weiny@intel.com>
References: <1433615915-24591-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433615915-24591-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch is the first of 3 which adds processing of OPA MADs

1) Add Intel Omni-Path Architecture defines
2) Increase max management version to accommodate OPA
3) update ib_create_send_mad
	If the device supports OPA MADs and the MAD being sent is the OPA base
	version alter the MAD size and sg lengths as appropriate

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Chagnes from V1:
	Update commit message
	Add check for OPA_MGMT_MAD_SIZE on a device which specifies OPA support

 drivers/infiniband/core/mad.c      | 42 +++++++++++++++++++++++++++++---------
 drivers/infiniband/core/mad_priv.h |  2 +-
 drivers/infiniband/core/mad_rmpp.c |  7 ++++---
 include/rdma/ib_mad.h              | 24 +++++++++++++++++++---
 4 files changed, 58 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index e072d2a94690..81acde8b5e90 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -874,11 +874,11 @@ out:
 	return ret;
 }
 
-static int get_pad_size(int hdr_len, int data_len)
+static int get_pad_size(int hdr_len, int data_len, size_t mad_size)
 {
 	int seg_size, pad;
 
-	seg_size = sizeof(struct ib_mad) - hdr_len;
+	seg_size = mad_size - hdr_len;
 	if (data_len && seg_size) {
 		pad = seg_size - data_len % seg_size;
 		return pad == seg_size ? 0 : pad;
@@ -897,14 +897,15 @@ static void free_send_rmpp_list(struct ib_mad_send_wr_private *mad_send_wr)
 }
 
 static int alloc_send_rmpp_list(struct ib_mad_send_wr_private *send_wr,
-				gfp_t gfp_mask)
+				size_t mad_size, gfp_t gfp_mask)
 {
 	struct ib_mad_send_buf *send_buf = &send_wr->send_buf;
 	struct ib_rmpp_mad *rmpp_mad = send_buf->mad;
 	struct ib_rmpp_segment *seg = NULL;
 	int left, seg_size, pad;
 
-	send_buf->seg_size = sizeof(struct ib_mad) - send_buf->hdr_len;
+	send_buf->seg_size = mad_size - send_buf->hdr_len;
+	send_buf->seg_rmpp_size = mad_size - IB_MGMT_RMPP_HDR;
 	seg_size = send_buf->seg_size;
 	pad = send_wr->pad;
 
@@ -954,20 +955,30 @@ struct ib_mad_send_buf * ib_create_send_mad(struct ib_mad_agent *mad_agent,
 	struct ib_mad_send_wr_private *mad_send_wr;
 	int pad, message_size, ret, size;
 	void *buf;
+	size_t mad_size;
+	bool opa;
 
 	mad_agent_priv = container_of(mad_agent, struct ib_mad_agent_private,
 				      agent);
-	pad = get_pad_size(hdr_len, data_len);
+
+	opa = rdma_cap_opa_mad(mad_agent->device, mad_agent->port_num);
+
+	if (opa && base_version == OPA_MGMT_BASE_VERSION)
+		mad_size = sizeof(struct opa_mad);
+	else
+		mad_size = sizeof(struct ib_mad);
+
+	pad = get_pad_size(hdr_len, data_len, mad_size);
 	message_size = hdr_len + data_len + pad;
 
 	if (ib_mad_kernel_rmpp_agent(mad_agent)) {
-		if (!rmpp_active && message_size > sizeof(struct ib_mad))
+		if (!rmpp_active && message_size > mad_size)
 			return ERR_PTR(-EINVAL);
 	} else
-		if (rmpp_active || message_size > sizeof(struct ib_mad))
+		if (rmpp_active || message_size > mad_size)
 			return ERR_PTR(-EINVAL);
 
-	size = rmpp_active ? hdr_len : sizeof(struct ib_mad);
+	size = rmpp_active ? hdr_len : mad_size;
 	buf = kzalloc(sizeof *mad_send_wr + size, gfp_mask);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
@@ -982,7 +993,14 @@ struct ib_mad_send_buf * ib_create_send_mad(struct ib_mad_agent *mad_agent,
 	mad_send_wr->mad_agent_priv = mad_agent_priv;
 	mad_send_wr->sg_list[0].length = hdr_len;
 	mad_send_wr->sg_list[0].lkey = mad_agent->mr->lkey;
-	mad_send_wr->sg_list[1].length = sizeof(struct ib_mad) - hdr_len;
+
+	/* OPA MADs don't have to be the full 2048 bytes */
+	if (opa && base_version == OPA_MGMT_BASE_VERSION &&
+	    data_len < mad_size - hdr_len)
+		mad_send_wr->sg_list[1].length = data_len;
+	else
+		mad_send_wr->sg_list[1].length = mad_size - hdr_len;
+
 	mad_send_wr->sg_list[1].lkey = mad_agent->mr->lkey;
 
 	mad_send_wr->send_wr.wr_id = (unsigned long) mad_send_wr;
@@ -995,7 +1013,7 @@ struct ib_mad_send_buf * ib_create_send_mad(struct ib_mad_agent *mad_agent,
 	mad_send_wr->send_wr.wr.ud.pkey_index = pkey_index;
 
 	if (rmpp_active) {
-		ret = alloc_send_rmpp_list(mad_send_wr, gfp_mask);
+		ret = alloc_send_rmpp_list(mad_send_wr, mad_size, gfp_mask);
 		if (ret) {
 			kfree(buf);
 			return ERR_PTR(ret);
@@ -2975,6 +2993,10 @@ static int ib_mad_port_open(struct ib_device *device,
 	if (WARN_ON(rdma_max_mad_size(device, port_num) < IB_MGMT_MAD_SIZE))
 		return -EFAULT;
 
+	if (WARN_ON(rdma_cap_opa_mad(device, port_num) &&
+		    rdma_max_mad_size(device, port_num) < OPA_MGMT_MAD_SIZE))
+		return -EFAULT;
+
 	/* Create new device info */
 	port_priv = kzalloc(sizeof *port_priv, GFP_KERNEL);
 	if (!port_priv) {
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index 44c0a7842a70..e8852be0c3f8 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -56,7 +56,7 @@
 
 /* Registration table sizes */
 #define MAX_MGMT_CLASS		80
-#define MAX_MGMT_VERSION	8
+#define MAX_MGMT_VERSION	0x83
 #define MAX_MGMT_OUI		8
 #define MAX_MGMT_VENDOR_RANGE2	(IB_MGMT_CLASS_VENDOR_RANGE2_END - \
 				IB_MGMT_CLASS_VENDOR_RANGE2_START + 1)
diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index 2379e2dfa400..f4e4fe609e95 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -572,13 +572,14 @@ static int send_next_seg(struct ib_mad_send_wr_private *mad_send_wr)
 
 	if (mad_send_wr->seg_num == 1) {
 		rmpp_mad->rmpp_hdr.rmpp_rtime_flags |= IB_MGMT_RMPP_FLAG_FIRST;
-		paylen = mad_send_wr->send_buf.seg_count * IB_MGMT_RMPP_DATA -
-			 mad_send_wr->pad;
+		paylen = (mad_send_wr->send_buf.seg_count *
+			  mad_send_wr->send_buf.seg_rmpp_size) -
+			  mad_send_wr->pad;
 	}
 
 	if (mad_send_wr->seg_num == mad_send_wr->send_buf.seg_count) {
 		rmpp_mad->rmpp_hdr.rmpp_rtime_flags |= IB_MGMT_RMPP_FLAG_LAST;
-		paylen = IB_MGMT_RMPP_DATA - mad_send_wr->pad;
+		paylen = mad_send_wr->send_buf.seg_rmpp_size - mad_send_wr->pad;
 	}
 	rmpp_mad->rmpp_hdr.paylen_newwin = cpu_to_be32(paylen);
 
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 349880696abc..eaa8c5dc472b 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -42,8 +42,11 @@
 #include <rdma/ib_verbs.h>
 #include <uapi/rdma/ib_user_mad.h>
 
-/* Management base version */
+/* Management base versions */
 #define IB_MGMT_BASE_VERSION			1
+#define OPA_MGMT_BASE_VERSION			0x80
+
+#define OPA_SMP_CLASS_VERSION			0x80
 
 /* Management classes */
 #define IB_MGMT_CLASS_SUBN_LID_ROUTED		0x01
@@ -136,6 +139,9 @@ enum {
 	IB_MGMT_DEVICE_HDR = 64,
 	IB_MGMT_DEVICE_DATA = 192,
 	IB_MGMT_MAD_SIZE = IB_MGMT_MAD_HDR + IB_MGMT_MAD_DATA,
+	OPA_MGMT_MAD_DATA = 2024,
+	OPA_MGMT_RMPP_DATA = 2012,
+	OPA_MGMT_MAD_SIZE = IB_MGMT_MAD_HDR + OPA_MGMT_MAD_DATA,
 };
 
 struct ib_mad_hdr {
@@ -182,6 +188,11 @@ struct ib_mad {
 	u8			data[IB_MGMT_MAD_DATA];
 };
 
+struct opa_mad {
+	struct ib_mad_hdr	mad_hdr;
+	u8			data[OPA_MGMT_MAD_DATA];
+};
+
 struct ib_rmpp_mad {
 	struct ib_mad_hdr	mad_hdr;
 	struct ib_rmpp_hdr	rmpp_hdr;
@@ -236,7 +247,10 @@ struct ib_class_port_info {
  *   includes the common MAD, RMPP, and class specific headers.
  * @data_len: Indicates the total size of user-transferred data.
  * @seg_count: The number of RMPP segments allocated for this send.
- * @seg_size: Size of each RMPP segment.
+ * @seg_size: Size of the data in each RMPP segment.  This does not include
+ *   class specific headers.
+ * @seg_rmpp_size: Size of each RMPP segment including the class specific
+ *   headers.
  * @timeout_ms: Time to wait for a response.
  * @retries: Number of times to retry a request for a response.  For MADs
  *   using RMPP, this applies per window.  On completion, returns the number
@@ -256,6 +270,7 @@ struct ib_mad_send_buf {
 	int			data_len;
 	int			seg_count;
 	int			seg_size;
+	int			seg_rmpp_size;
 	int			timeout_ms;
 	int			retries;
 };
@@ -402,7 +417,10 @@ struct ib_mad_send_wc {
 struct ib_mad_recv_buf {
 	struct list_head	list;
 	struct ib_grh		*grh;
-	struct ib_mad		*mad;
+	union {
+		struct ib_mad	*mad;
+		struct opa_mad	*opa_mad;
+	};
 };
 
 /**
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
