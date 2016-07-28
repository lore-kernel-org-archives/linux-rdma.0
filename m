From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 10/13] IB/hfi1: Make iovec loop index easy to understand
Date: Thu, 28 Jul 2016 12:27:34 -0400
Message-ID: <1469723257-27317-11-git-send-email-ira.weiny@intel.com>
References: <1469723257-27317-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469723257-27317-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 54640c31b6bb..586f07807b27 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -520,7 +520,7 @@ static u8 dlid_to_selector(u16 dlid)
 int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 				   unsigned long dim, unsigned long *count)
 {
-	int ret = 0, i = 0;
+	int ret = 0, i;
 	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_user_sdma_pkt_q *pq = fd->pq;
@@ -657,7 +657,7 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	idx++;
 
 	/* Save all the IO vector structures */
-	while (i < req->data_iovs) {
+	for (i = 0; i < req->data_iovs; i++) {
 		INIT_LIST_HEAD(&req->iovs[i].list);
 		memcpy(&req->iovs[i].iov, iovec + idx++, sizeof(struct iovec));
 		ret = pin_vector_pages(req, &req->iovs[i]);
@@ -665,7 +665,7 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 			req->status = ret;
 			goto free_req;
 		}
-		req->data_len += req->iovs[i++].iov.iov_len;
+		req->data_len += req->iovs[i].iov.iov_len;
 	}
 	SDMA_DBG(req, "total data length %u", req->data_len);
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
