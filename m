From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v4 17/19] IB/mad: Implement support for Intel Omni-Path Architecture base version MADs in ib_create_send_mad
Date: Wed,  4 Feb 2015 18:29:43 -0500
Message-ID: <1423092585-26692-18-git-send-email-ira.weiny@intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423092585-26692-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If the device supports OPA MADs process the OPA base version.
	Set MAD size and sg lengths as appropriate
	Split RMPP MADs as appropriate

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
 drivers/infiniband/core/mad.c | 38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 316b4b2..5aefe4c 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -857,11 +857,11 @@ out:
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
@@ -880,14 +880,14 @@ static void free_send_rmpp_list(struct ib_mad_send_wr_private *mad_send_wr)
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
 
@@ -937,20 +937,31 @@ struct ib_mad_send_buf * ib_create_send_mad(struct ib_mad_agent *mad_agent,
 	struct ib_mad_send_wr_private *mad_send_wr;
 	int pad, message_size, ret, size;
 	void *buf;
+	size_t mad_size;
+	int opa;
 
 	mad_agent_priv = container_of(mad_agent, struct ib_mad_agent_private,
 				      agent);
-	pad = get_pad_size(hdr_len, data_len);
+
+	opa = mad_agent_priv->agent.device->cached_dev_attrs.device_cap_flags2 &
+	      IB_DEVICE_OPA_MAD_SUPPORT;
+
+	if (opa && base_version == OPA_MGMT_BASE_VERSION)
+		mad_size = sizeof(struct jumbo_mad);
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
@@ -965,7 +976,14 @@ struct ib_mad_send_buf * ib_create_send_mad(struct ib_mad_agent *mad_agent,
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
@@ -978,7 +996,7 @@ struct ib_mad_send_buf * ib_create_send_mad(struct ib_mad_agent *mad_agent,
 	mad_send_wr->send_wr.wr.ud.pkey_index = pkey_index;
 
 	if (rmpp_active) {
-		ret = alloc_send_rmpp_list(mad_send_wr, gfp_mask);
+		ret = alloc_send_rmpp_list(mad_send_wr, mad_size, gfp_mask);
 		if (ret) {
 			kfree(buf);
 			return ERR_PTR(ret);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
