From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 12/14] IB/mad: Add partial Intel OPA MAD support
Date: Wed, 20 May 2015 04:13:33 -0400
Message-ID: <1432109615-19564-13-git-send-email-ira.weiny@intel.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432109615-19564-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch adds processing of OPA MADs to ib_create_send_mad.

1) Create opa_mad and opa_rmpp_mad data structures.

OPA MADs are 2K derivatives of the ib_mad and ib_rmpp_mad structures.
Therefore they share the same common headers and much of the same processing
code as IB MADs.

2) Add Intel Omni-Path Architecture defines
3) Increase max management version to accommodate OPA

4) If the device supports OPA MADs process the OPA base version.
	Set MAD size and sg lengths as appropriate
	Split RMPP MADs as appropriate

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c      | 37 +++++++++++++++++++++++++++----------
 drivers/infiniband/core/mad_priv.h |  4 +++-
 include/rdma/ib_mad.h              | 23 +++++++++++++++++++++--
 3 files changed, 51 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index a8ea6137771b..50a63247f6f9 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -861,11 +861,11 @@ out:
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
@@ -884,14 +884,14 @@ static void free_send_rmpp_list(struct ib_mad_send_wr_private *mad_send_wr)
 }
 
 static int alloc_send_rmpp_list(struct ib_mad_send_wr_private *send_wr,
-				gfp_t gfp_mask)
+				size_t mad_size, gfp_t gfp_mask)
 {
 	struct ib_mad_send_buf *send_buf = &send_wr->send_buf;
 	struct ib_rmpp_base *rmpp_base = send_buf->mad;
 	struct ib_rmpp_segment *seg = NULL;
 	int left, seg_size, pad;
 
-	send_buf->seg_size = sizeof (struct ib_mad) - send_buf->hdr_len;
+	send_buf->seg_size = mad_size - send_buf->hdr_len;
 	seg_size = send_buf->seg_size;
 	pad = send_wr->pad;
 
@@ -941,20 +941,30 @@ struct ib_mad_send_buf * ib_create_send_mad(struct ib_mad_agent *mad_agent,
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
@@ -969,7 +979,14 @@ struct ib_mad_send_buf * ib_create_send_mad(struct ib_mad_agent *mad_agent,
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
@@ -982,7 +999,7 @@ struct ib_mad_send_buf * ib_create_send_mad(struct ib_mad_agent *mad_agent,
 	mad_send_wr->send_wr.wr.ud.pkey_index = pkey_index;
 
 	if (rmpp_active) {
-		ret = alloc_send_rmpp_list(mad_send_wr, gfp_mask);
+		ret = alloc_send_rmpp_list(mad_send_wr, mad_size, gfp_mask);
 		if (ret) {
 			kfree(buf);
 			return ERR_PTR(ret);
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index 7b19cba2adf0..b93e9a958725 100644
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
@@ -80,6 +80,8 @@ struct ib_mad_private {
 		struct ib_mad mad;
 		struct ib_rmpp_mad rmpp_mad;
 		struct ib_smp smp;
+		struct opa_mad opa_mad;
+		struct opa_rmpp_mad opa_rmpp_mad;
 	} mad;
 } __attribute__ ((packed));
 
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 20ed361a9224..a8a6e9d2485e 100644
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
 struct ib_rmpp_base {
 	struct ib_mad_hdr	mad_hdr;
 	struct ib_rmpp_hdr	rmpp_hdr;
@@ -192,6 +203,11 @@ struct ib_rmpp_mad {
 	u8			data[IB_MGMT_RMPP_DATA];
 };
 
+struct opa_rmpp_mad {
+	struct ib_rmpp_base	base;
+	u8			data[OPA_MGMT_RMPP_DATA];
+};
+
 struct ib_sa_mad {
 	struct ib_mad_hdr	mad_hdr;
 	struct ib_rmpp_hdr	rmpp_hdr;
@@ -406,7 +422,10 @@ struct ib_mad_send_wc {
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
