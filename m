From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 06/16] IB/hfi1: Fix error condition that needs to clean up
Date: Thu, 28 Jul 2016 15:21:17 -0400
Message-ID: <1469733687-31738-7-git-send-email-ira.weiny@intel.com>
References: <1469733687-31738-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469733687-31738-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If input validation fails, properly free the request before returning.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index ff03e1dad5b9..5c1322428065 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -617,7 +617,8 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	if (!info.npkts || req->data_iovs > MAX_VECTORS_PER_REQ) {
 		SDMA_DBG(req, "Too many vectors (%u/%u)", req->data_iovs,
 			 MAX_VECTORS_PER_REQ);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto free_req;
 	}
 	/* Copy the header from the user buffer */
 	ret = copy_from_user(&req->hdr, iovec[idx].iov_base + sizeof(info),
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
