From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.9 3/3] IB/iser: Enable iser to work when FMRs are not supported
Date: Thu, 21 Feb 2013 16:50:10 +0200
Message-ID: <1361458210-856-4-git-send-email-ogerlitz@mellanox.com>
References: <1361458210-856-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361458210-856-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Tabachnik <alext-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Reuse the SG unaligned for FMR driver flow to make the initiator
functional when running over driver instance which doesn't support
FMRs such as mlx4 VF.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Tabachnik <alext-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c |    7 ++++---
 drivers/infiniband/ulp/iser/iser_verbs.c  |    8 ++++++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 79c4f35..be1edb0 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -369,10 +369,11 @@ int iser_reg_rdma_mem(struct iscsi_iser_task *iser_task,
 	regd_buf = &iser_task->rdma_regd[cmd_dir];
 
 	aligned_len = iser_data_buf_aligned_len(mem, ibdev);
-	if (aligned_len != mem->dma_nents) {
+	if (aligned_len != mem->dma_nents ||
+	    (!ib_conn->fmr_pool && mem->dma_nents > 1)) {
 		iscsi_conn->fmr_unalign_cnt++;
-		iser_warn("rdma alignment violation %d/%d aligned\n",
-			 aligned_len, mem->size);
+		iser_warn("rdma alignment violation (%d/%d aligned) or FMR not supported\n",
+			  aligned_len, mem->size);
 		iser_data_buf_dump(mem, ibdev);
 
 		/* unmap the command data before accessing it */
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 95a49af..4debadc 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -242,10 +242,14 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 				    IB_ACCESS_REMOTE_READ);
 
 	ib_conn->fmr_pool = ib_create_fmr_pool(device->pd, &params);
-	if (IS_ERR(ib_conn->fmr_pool)) {
-		ret = PTR_ERR(ib_conn->fmr_pool);
+	ret = PTR_ERR(ib_conn->fmr_pool);
+	if (IS_ERR(ib_conn->fmr_pool) && ret != -ENOSYS) {
 		ib_conn->fmr_pool = NULL;
 		goto out_err;
+	} else if (ret == -ENOSYS) {
+		ib_conn->fmr_pool = NULL;
+		iser_warn("FMRs are not supported, using unaligned mode\n");
+		ret = 0;
 	}
 
 	memset(&init_attr, 0, sizeof init_attr);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
