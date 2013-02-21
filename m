From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.9 2/3] IB/iser: Avoid error prints on EAGAIN registration failures
Date: Thu, 21 Feb 2013 16:50:09 +0200
Message-ID: <1361458210-856-3-git-send-email-ogerlitz@mellanox.com>
References: <1361458210-856-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361458210-856-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Under IO/CPU stress its possible that the FMR pool might not have free
FMR mapping element for iser to use as of incompleted background
unmapping processing. On that case we get -EAGAIN, the IO is pushed
back to the SCSI layer which soon retries it. No need to be so
verbose about that.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 2033a92..79c4f35 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -404,7 +404,7 @@ int iser_reg_rdma_mem(struct iscsi_iser_task *iser_task,
 	} else { /* use FMR for multiple dma entries */
 		iser_page_vec_build(mem, ib_conn->page_vec, ibdev);
 		err = iser_reg_page_vec(ib_conn, ib_conn->page_vec, &regd_buf->reg);
-		if (err) {
+		if (err && err != -EAGAIN) {
 			iser_data_buf_dump(mem, ibdev);
 			iser_err("mem->dma_nents = %d (dlength = 0x%x)\n",
 				 mem->dma_nents,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
