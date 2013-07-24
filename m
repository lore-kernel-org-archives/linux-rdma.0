From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH for-3.11 2/3] rdma/cm: Fix accessing invalid private data for UD
Date: Wed, 24 Jul 2013 15:06:08 -0700
Message-ID: <1374703569-16668-3-git-send-email-sean.hefty@intel.com>
References: <1374703569-16668-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1374703569-16668-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If a application is using AF_IB with a UD QP, but does not
provide any private data, we will end up accessing invalid
memory.  Check for this case and handle it appropriately.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 84487a2..4314655 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2676,29 +2676,32 @@ static int cma_resolve_ib_udp(struct rdma_id_private *id_priv,
 {
 	struct ib_cm_sidr_req_param req;
 	struct ib_cm_id	*id;
+	void *private_data;
 	int offset, ret;
 
+	memset(&req, 0, sizeof req);
 	offset = cma_user_data_offset(id_priv);
 	req.private_data_len = offset + conn_param->private_data_len;
 	if (req.private_data_len < conn_param->private_data_len)
 		return -EINVAL;
 
 	if (req.private_data_len) {
-		req.private_data = kzalloc(req.private_data_len, GFP_ATOMIC);
-		if (!req.private_data)
+		private_data = kzalloc(req.private_data_len, GFP_ATOMIC);
+		if (!private_data)
 			return -ENOMEM;
 	} else {
-		req.private_data = NULL;
+		private_data = NULL;
 	}
 
 	if (conn_param->private_data && conn_param->private_data_len)
-		memcpy((void *) req.private_data + offset,
-		       conn_param->private_data, conn_param->private_data_len);
+		memcpy(private_data + offset, conn_param->private_data,
+		       conn_param->private_data_len);
 
-	if (req.private_data) {
-		ret = cma_format_hdr((void *) req.private_data, id_priv);
+	if (private_data) {
+		ret = cma_format_hdr(private_data, id_priv);
 		if (ret)
 			goto out;
+		req.private_data = private_data;
 	}
 
 	id = ib_create_cm_id(id_priv->id.device, cma_sidr_rep_handler,
@@ -2720,7 +2723,7 @@ static int cma_resolve_ib_udp(struct rdma_id_private *id_priv,
 		id_priv->cm_id.ib = NULL;
 	}
 out:
-	kfree(req.private_data);
+	kfree(private_data);
 	return ret;
 }
 
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
