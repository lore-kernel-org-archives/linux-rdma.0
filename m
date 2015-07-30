From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 19/22] IB/iser: Pass registration pool a size parameter
Date: Thu, 30 Jul 2015 11:06:32 +0300
Message-ID: <1438243595-32288-20-git-send-email-sagig@mellanox.com>
References: <1438243595-32288-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438243595-32288-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hard coded for now. This will allow to allocate different
sized MRs depending on the IO size needed (and device
capabilities).

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     | 11 +++++--
 drivers/infiniband/ulp/iser/iser_initiator.c |  3 +-
 drivers/infiniband/ulp/iser/iser_verbs.c     | 47 +++++++++++++++-------------
 3 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index e6105d2..e9ebe0b 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -339,7 +339,8 @@ struct iser_comp {
  */
 struct iser_reg_ops {
 	int            (*alloc_reg_res)(struct ib_conn *ib_conn,
-					unsigned cmds_max);
+					unsigned cmds_max,
+					unsigned int size);
 	void           (*free_reg_res)(struct ib_conn *ib_conn);
 	int            (*reg_mem)(struct iscsi_iser_task *iser_task,
 				  struct iser_data_buf *mem,
@@ -658,9 +659,13 @@ int  iser_initialize_task_headers(struct iscsi_task *task,
 			struct iser_tx_desc *tx_desc);
 int iser_alloc_rx_descriptors(struct iser_conn *iser_conn,
 			      struct iscsi_session *session);
-int iser_alloc_fmr_pool(struct ib_conn *ib_conn, unsigned cmds_max);
+int iser_alloc_fmr_pool(struct ib_conn *ib_conn,
+			unsigned cmds_max,
+			unsigned int size);
 void iser_free_fmr_pool(struct ib_conn *ib_conn);
-int iser_alloc_fastreg_pool(struct ib_conn *ib_conn, unsigned cmds_max);
+int iser_alloc_fastreg_pool(struct ib_conn *ib_conn,
+			    unsigned cmds_max,
+			    unsigned int size);
 void iser_free_fastreg_pool(struct ib_conn *ib_conn);
 u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
 			     enum iser_data_dir cmd_dir, sector_t *sector);
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index cef6c82..268a3d6 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -258,7 +258,8 @@ int iser_alloc_rx_descriptors(struct iser_conn *iser_conn,
 	iser_conn->qp_max_recv_dtos_mask = session->cmds_max - 1; /* cmds_max is 2^N */
 	iser_conn->min_posted_rx = iser_conn->qp_max_recv_dtos >> 2;
 
-	if (device->reg_ops->alloc_reg_res(ib_conn, session->scsi_cmds_max))
+	if (device->reg_ops->alloc_reg_res(ib_conn, session->scsi_cmds_max,
+					   ISCSI_ISER_SG_TABLESIZE + 1))
 		goto create_rdma_reg_res_failed;
 
 	if (iser_alloc_login_buf(iser_conn))
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 6b464e6..fa778ba 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -199,7 +199,9 @@ static void iser_free_device_ib_res(struct iser_device *device)
  *
  * returns 0 on success, or errno code on failure
  */
-int iser_alloc_fmr_pool(struct ib_conn *ib_conn, unsigned cmds_max)
+int iser_alloc_fmr_pool(struct ib_conn *ib_conn,
+			unsigned cmds_max,
+			unsigned int size)
 {
 	struct iser_device *device = ib_conn->device;
 	struct iser_fr_pool *fr_pool = &ib_conn->fr_pool;
@@ -216,8 +218,7 @@ int iser_alloc_fmr_pool(struct ib_conn *ib_conn, unsigned cmds_max)
 	if (!desc)
 		return -ENOMEM;
 
-	page_vec = kmalloc(sizeof(*page_vec) +
-			   (sizeof(u64) * (ISCSI_ISER_SG_TABLESIZE + 1)),
+	page_vec = kmalloc(sizeof(*page_vec) + (sizeof(u64) * size),
 			   GFP_KERNEL);
 	if (!page_vec) {
 		ret = -ENOMEM;
@@ -227,9 +228,7 @@ int iser_alloc_fmr_pool(struct ib_conn *ib_conn, unsigned cmds_max)
 	page_vec->pages = (u64 *)(page_vec + 1);
 
 	params.page_shift        = SHIFT_4K;
-	/* when the first/last SG element are not start/end *
-	 * page aligned, the map whould be of N+1 pages     */
-	params.max_pages_per_fmr = ISCSI_ISER_SG_TABLESIZE + 1;
+	params.max_pages_per_fmr = size;
 	/* make the pool size twice the max number of SCSI commands *
 	 * the ML is expected to queue, watermark for unmap at 50%  */
 	params.pool_size	 = cmds_max * 2;
@@ -282,13 +281,14 @@ void iser_free_fmr_pool(struct ib_conn *ib_conn)
 }
 
 static int
-iser_alloc_reg_res(struct ib_device *ib_device, struct ib_pd *pd,
-		   struct iser_reg_resources *res)
+iser_alloc_reg_res(struct ib_device *ib_device,
+		   struct ib_pd *pd,
+		   struct iser_reg_resources *res,
+		   unsigned int size)
 {
 	int ret;
 
-	res->frpl = ib_alloc_fast_reg_page_list(ib_device,
-						ISCSI_ISER_SG_TABLESIZE + 1);
+	res->frpl = ib_alloc_fast_reg_page_list(ib_device, size);
 	if (IS_ERR(res->frpl)) {
 		ret = PTR_ERR(res->frpl);
 		iser_err("Failed to allocate ib_fast_reg_page_list err=%d\n",
@@ -296,8 +296,7 @@ iser_alloc_reg_res(struct ib_device *ib_device, struct ib_pd *pd,
 		return PTR_ERR(res->frpl);
 	}
 
-	res->mr = ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG,
-			      ISCSI_ISER_SG_TABLESIZE + 1);
+	res->mr = ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG, size);
 	if (IS_ERR(res->mr)) {
 		ret = PTR_ERR(res->mr);
 		iser_err("Failed to allocate ib_fast_reg_mr err=%d\n", ret);
@@ -321,8 +320,10 @@ iser_free_reg_res(struct iser_reg_resources *rsc)
 }
 
 static int
-iser_alloc_pi_ctx(struct ib_device *ib_device, struct ib_pd *pd,
-		  struct iser_fr_desc *desc)
+iser_alloc_pi_ctx(struct ib_device *ib_device,
+		  struct ib_pd *pd,
+		  struct iser_fr_desc *desc,
+		  unsigned int size)
 {
 	struct iser_pi_context *pi_ctx = NULL;
 	int ret;
@@ -333,7 +334,7 @@ iser_alloc_pi_ctx(struct ib_device *ib_device, struct ib_pd *pd,
 
 	pi_ctx = desc->pi_ctx;
 
-	ret = iser_alloc_reg_res(ib_device, pd, &pi_ctx->rsc);
+	ret = iser_alloc_reg_res(ib_device, pd, &pi_ctx->rsc, size);
 	if (ret) {
 		iser_err("failed to allocate reg_resources\n");
 		goto alloc_reg_res_err;
@@ -366,8 +367,10 @@ iser_free_pi_ctx(struct iser_pi_context *pi_ctx)
 }
 
 static struct iser_fr_desc *
-iser_create_fastreg_desc(struct ib_device *ib_device, struct ib_pd *pd,
-			 bool pi_enable)
+iser_create_fastreg_desc(struct ib_device *ib_device,
+			 struct ib_pd *pd,
+			 bool pi_enable,
+			 unsigned int size)
 {
 	struct iser_fr_desc *desc;
 	int ret;
@@ -376,12 +379,12 @@ iser_create_fastreg_desc(struct ib_device *ib_device, struct ib_pd *pd,
 	if (!desc)
 		return ERR_PTR(-ENOMEM);
 
-	ret = iser_alloc_reg_res(ib_device, pd, &desc->rsc);
+	ret = iser_alloc_reg_res(ib_device, pd, &desc->rsc, size);
 	if (ret)
 		goto reg_res_alloc_failure;
 
 	if (pi_enable) {
-		ret = iser_alloc_pi_ctx(ib_device, pd, desc);
+		ret = iser_alloc_pi_ctx(ib_device, pd, desc, size);
 		if (ret)
 			goto pi_ctx_alloc_failure;
 	}
@@ -401,7 +404,9 @@ reg_res_alloc_failure:
  * for fast registration work requests.
  * returns 0 on success, or errno code on failure
  */
-int iser_alloc_fastreg_pool(struct ib_conn *ib_conn, unsigned cmds_max)
+int iser_alloc_fastreg_pool(struct ib_conn *ib_conn,
+			    unsigned cmds_max,
+			    unsigned int size)
 {
 	struct iser_device *device = ib_conn->device;
 	struct iser_fr_pool *fr_pool = &ib_conn->fr_pool;
@@ -413,7 +418,7 @@ int iser_alloc_fastreg_pool(struct ib_conn *ib_conn, unsigned cmds_max)
 	fr_pool->size = 0;
 	for (i = 0; i < cmds_max; i++) {
 		desc = iser_create_fastreg_desc(device->ib_device, device->pd,
-						ib_conn->pi_support);
+						ib_conn->pi_support, size);
 		if (IS_ERR(desc)) {
 			ret = PTR_ERR(desc);
 			goto err;
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
