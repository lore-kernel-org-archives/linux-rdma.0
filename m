From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 4/9] Do not use IBV_CMD_(REG_MR|RESIZE_CQ)_HAS_RESP_PARAMS
Date: Thu, 29 Sep 2016 14:47:51 -0600
Message-ID: <1475182076-5411-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475182076-5411-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "open list:HF1 USERSPACE PROVIDER for hf1.ko" <intel-opa-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

These were used to support building provider plugins against old
versions of libibverbs. Since libibverbs is now included together
with the provider that is no longer possible or supported.

The define is kept as it is in a public header.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libhfi1verbs/src/verbs.c    | 15 +++------------
 libi40iw/src/i40iw_uverbs.c | 26 --------------------------
 libipathverbs/src/verbs.c   | 16 +++-------------
 libmlx5/src/verbs.c         | 18 ++++--------------
 libmthca/src/verbs.c        | 26 ++++++--------------------
 libnes/src/nes_uverbs.c     | 35 -----------------------------------
 librxe/src/rxe.c            | 16 +++-------------
 7 files changed, 19 insertions(+), 133 deletions(-)

diff --git a/libhfi1verbs/src/verbs.c b/libhfi1verbs/src/verbs.c
index 20d4352094af..06ddbb712857 100644
--- a/libhfi1verbs/src/verbs.c
+++ b/libhfi1verbs/src/verbs.c
@@ -135,24 +135,15 @@ struct ibv_mr *hfi1_reg_mr(struct ibv_pd *pd, void *addr,
 {
 	struct ibv_mr *mr;
 	struct ibv_reg_mr cmd;
+	struct ibv_reg_mr_resp resp;
 	int ret;
 
 	mr = malloc(sizeof *mr);
 	if (!mr)
 		return NULL;
 
-#ifdef IBV_CMD_REG_MR_HAS_RESP_PARAMS
-	{
-		struct ibv_reg_mr_resp resp;
-
-		ret = ibv_cmd_reg_mr(pd, addr, length, (uintptr_t) addr,
-				     access, mr, &cmd, sizeof cmd,
-                                     &resp, sizeof resp);
-	}
-#else
-	ret = ibv_cmd_reg_mr(pd, addr, length, (uintptr_t)addr,
-			     access, mr, &cmd, sizeof cmd);
-#endif
+	ret = ibv_cmd_reg_mr(pd, addr, length, (uintptr_t)addr, access, mr,
+			     &cmd, sizeof cmd, &resp, sizeof resp);
 
 	if (ret) {
 		free(mr);
diff --git a/libi40iw/src/i40iw_uverbs.c b/libi40iw/src/i40iw_uverbs.c
index 3a6799a9b50f..a117b534f533 100644
--- a/libi40iw/src/i40iw_uverbs.c
+++ b/libi40iw/src/i40iw_uverbs.c
@@ -154,9 +154,7 @@ struct ibv_mr *i40iw_ureg_mr(struct ibv_pd *pd, void *addr, size_t length, int a
 {
 	struct ibv_mr *mr;
 	struct i40iw_ureg_mr cmd;
-#ifdef IBV_CMD_REG_MR_HAS_RESP_PARAMS
 	struct ibv_reg_mr_resp resp;
-#endif
 
 	mr = malloc(sizeof(*mr));
 	if (!mr)
@@ -164,14 +162,9 @@ struct ibv_mr *i40iw_ureg_mr(struct ibv_pd *pd, void *addr, size_t length, int a
 
 	cmd.reg_type = I40IW_UMEMREG_TYPE_MEM;
 
-#ifdef IBV_CMD_REG_MR_HAS_RESP_PARAMS
 	if (ibv_cmd_reg_mr(pd, addr, length, (uintptr_t)addr,
 			   access, mr, &cmd.ibv_cmd, sizeof(cmd),
 			   &resp, sizeof(resp))) {
-#else
-	if (ibv_cmd_reg_mr(pd, addr, length, (uintptr_t)addr,
-			   access, mr, &cmd.ibv_cmd, sizeof(cmd))) {
-#endif
 		fprintf(stderr, PFX "%s: Failed to register memory\n", __func__);
 		free(mr);
 		return NULL;
@@ -226,9 +219,7 @@ struct ibv_cq *i40iw_ucreate_cq(struct ibv_context *context, int cqe,
 
 	struct i40iw_ureg_mr reg_mr_cmd;
 
-#ifdef IBV_CMD_REG_MR_HAS_RESP_PARAMS
 	struct ibv_reg_mr_resp reg_mr_resp;
-#endif
 
 	if (cqe > I40IW_MAX_CQ_SIZE)
 		return NULL;
@@ -268,18 +259,10 @@ struct ibv_cq *i40iw_ucreate_cq(struct ibv_context *context, int cqe,
 
 	reg_mr_cmd.cq_pages = cq_pages;
 
-#ifdef IBV_CMD_REG_MR_HAS_RESP_PARAMS
 	ret = ibv_cmd_reg_mr(&iwvctx->iwupd->ibv_pd, (void *)info.cq_base, totalsize,
 			     (uintptr_t)info.cq_base, IBV_ACCESS_LOCAL_WRITE,
 			     &iwucq->mr, &reg_mr_cmd.ibv_cmd, sizeof(reg_mr_cmd), &reg_mr_resp,
 			     sizeof(reg_mr_resp));
-#else
-	ret = ibv_cmd_reg_mr(&iwvctx->iwupd->ibv_pd, (void *)info.sq, totalsize,
-			     (uintptr_t)info.cq_base, IBV_ACCESS_LOCAL_WRITE,
-			     &iwucq->mr, &reg_mr_cmd.ibv_cmd,
-			     sizeof(reg_mr_cmd));
-#endif
-
 	if (ret) {
 		fprintf(stderr, PFX "%s: failed to pin memory for CQ\n", __func__);
 		goto err;
@@ -509,10 +492,7 @@ static int i40iw_vmapped_qp(struct i40iw_uqp *iwuqp, struct ibv_pd *pd,
 	int ret;
 	struct i40iw_ureg_mr reg_mr_cmd;
 	u32 sq_pages, rq_pages;
-
-#ifdef IBV_CMD_REG_MR_HAS_RESP_PARAMS
 	struct ibv_reg_mr_resp reg_mr_resp;
-#endif
 
 	memset(&reg_mr_cmd, 0, sizeof(reg_mr_cmd));
 	if ((sqdepth % I40IWQP_SW_WQSIZE_1024))
@@ -540,15 +520,9 @@ static int i40iw_vmapped_qp(struct i40iw_uqp *iwuqp, struct ibv_pd *pd,
 	reg_mr_cmd.sq_pages = sq_pages;
 	reg_mr_cmd.rq_pages = rq_pages;
 
-#ifdef IBV_CMD_REG_MR_HAS_RESP_PARAMS
 	ret = ibv_cmd_reg_mr(pd, (void *)info->sq, totalqpsize, (uintptr_t)info->sq,
 			     IBV_ACCESS_LOCAL_WRITE, &iwuqp->mr, &reg_mr_cmd.ibv_cmd,
 			     sizeof(reg_mr_cmd), &reg_mr_resp, sizeof(reg_mr_resp));
-#else
-	ret = ibv_cmd_reg_mr(pd, (void *)info->sq, totalqpsize, (uintptr_t)info->sq,
-			     IBV_ACCESS_LOCAL_WRITE, &iwuqp->mr, &reg_mr_cmd.ibv_cmd,
-			     sizeof(reg_mr_cmd));
-#endif
 	if (ret) {
 		fprintf(stderr, PFX "%s: failed to pin memory for SQ\n", __func__);
 		free(info->sq);
diff --git a/libipathverbs/src/verbs.c b/libipathverbs/src/verbs.c
index 12ca35f32189..35b2162a84f0 100644
--- a/libipathverbs/src/verbs.c
+++ b/libipathverbs/src/verbs.c
@@ -115,25 +115,15 @@ struct ibv_mr *ipath_reg_mr(struct ibv_pd *pd, void *addr,
 {
 	struct ibv_mr *mr;
 	struct ibv_reg_mr cmd;
+	struct ibv_reg_mr_resp resp;
 	int ret;
 
 	mr = malloc(sizeof *mr);
 	if (!mr)
 		return NULL;
 
-#ifdef IBV_CMD_REG_MR_HAS_RESP_PARAMS
-	{
-		struct ibv_reg_mr_resp resp;
-
-		ret = ibv_cmd_reg_mr(pd, addr, length, (uintptr_t) addr,
-				     access, mr, &cmd, sizeof cmd,
-                                     &resp, sizeof resp);
-	}
-#else
-	ret = ibv_cmd_reg_mr(pd, addr, length, (uintptr_t)addr,
-			     access, mr, &cmd, sizeof cmd);
-#endif
-
+	ret = ibv_cmd_reg_mr(pd, addr, length, (uintptr_t)addr, access, mr,
+			     &cmd, sizeof cmd, &resp, sizeof resp);
 	if (ret) {
 		free(mr);
 		return NULL;
diff --git a/libmlx5/src/verbs.c b/libmlx5/src/verbs.c
index acbabc814621..ef85a63637c9 100644
--- a/libmlx5/src/verbs.c
+++ b/libmlx5/src/verbs.c
@@ -171,25 +171,15 @@ struct ibv_mr *mlx5_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 	struct ibv_reg_mr cmd;
 	int ret;
 	enum ibv_access_flags access = (enum ibv_access_flags)acc;
+	struct ibv_reg_mr_resp resp;
 
 	mr = calloc(1, sizeof(*mr));
 	if (!mr)
 		return NULL;
 
-#ifdef IBV_CMD_REG_MR_HAS_RESP_PARAMS
-	{
-		struct ibv_reg_mr_resp resp;
-
-		ret = ibv_cmd_reg_mr(pd, addr, length, (uintptr_t) addr,
-				     access, &(mr->ibv_mr),
-				     &cmd, sizeof(cmd),
-				     &resp, sizeof resp);
-	}
-#else
-	ret = ibv_cmd_reg_mr(pd, addr, length, (uintptr_t) addr, access,
-			      &(mr->ibv_mr),
-			     &cmd, sizeof cmd);
-#endif
+	ret = ibv_cmd_reg_mr(pd, addr, length, (uintptr_t)addr, access,
+			     &(mr->ibv_mr), &cmd, sizeof(cmd), &resp,
+			     sizeof resp);
 	if (ret) {
 		mlx5_free_buf(&(mr->buf));
 		free(mr);
diff --git a/libmthca/src/verbs.c b/libmthca/src/verbs.c
index b3bce82affae..60dd44002ea3 100644
--- a/libmthca/src/verbs.c
+++ b/libmthca/src/verbs.c
@@ -120,6 +120,7 @@ static struct ibv_mr *__mthca_reg_mr(struct ibv_pd *pd, void *addr,
 {
 	struct ibv_mr *mr;
 	struct mthca_reg_mr cmd;
+	struct ibv_reg_mr_resp resp;
 	int ret;
 
 	/*
@@ -135,17 +136,8 @@ static struct ibv_mr *__mthca_reg_mr(struct ibv_pd *pd, void *addr,
 	if (!mr)
 		return NULL;
 
-#ifdef IBV_CMD_REG_MR_HAS_RESP_PARAMS
-	{
-		struct ibv_reg_mr_resp resp;
-
-		ret = ibv_cmd_reg_mr(pd, addr, length, hca_va, access, mr,
-				     &cmd.ibv_cmd, sizeof cmd, &resp, sizeof resp);
-	}
-#else
-	ret = ibv_cmd_reg_mr(pd, addr, length, hca_va, access, mr,
-			     &cmd.ibv_cmd, sizeof cmd);
-#endif
+	ret = ibv_cmd_reg_mr(pd, addr, length, hca_va, access, mr, &cmd.ibv_cmd,
+			     sizeof cmd, &resp, sizeof resp);
 	if (ret) {
 		free(mr);
 		return NULL;
@@ -284,6 +276,7 @@ int mthca_resize_cq(struct ibv_cq *ibcq, int cqe)
 	struct mthca_resize_cq cmd;
 	struct ibv_mr *mr;
 	struct mthca_buf buf;
+	struct ibv_resize_cq_resp resp;
 	int old_cqe;
 	int ret;
 
@@ -317,15 +310,8 @@ int mthca_resize_cq(struct ibv_cq *ibcq, int cqe)
 	old_cqe = ibcq->cqe;
 
 	cmd.lkey = mr->lkey;
-#ifdef IBV_CMD_RESIZE_CQ_HAS_RESP_PARAMS
-	{
-		struct ibv_resize_cq_resp resp;
-		ret = ibv_cmd_resize_cq(ibcq, cqe - 1, &cmd.ibv_cmd, sizeof cmd,
-					&resp, sizeof resp);
-	}
-#else
-	ret = ibv_cmd_resize_cq(ibcq, cqe - 1, &cmd.ibv_cmd, sizeof cmd);
-#endif
+	ret = ibv_cmd_resize_cq(ibcq, cqe - 1, &cmd.ibv_cmd, sizeof cmd, &resp,
+				sizeof resp);
 	if (ret) {
 		mthca_dereg_mr(mr);
 		mthca_free_buf(&buf);
diff --git a/libnes/src/nes_uverbs.c b/libnes/src/nes_uverbs.c
index 7c2454e7f55a..141f769bf14b 100644
--- a/libnes/src/nes_uverbs.c
+++ b/libnes/src/nes_uverbs.c
@@ -172,23 +172,16 @@ struct ibv_mr *nes_ureg_mr(struct ibv_pd *pd, void *addr,
 {
 	struct ibv_mr *mr;
 	struct nes_ureg_mr cmd;
-#ifdef IBV_CMD_REG_MR_HAS_RESP_PARAMS
 	struct ibv_reg_mr_resp resp;
-#endif
 
 	mr = malloc(sizeof *mr);
 	if (!mr)
 		return NULL;
 
 	cmd.reg_type = NES_UMEMREG_TYPE_MEM;
-#ifdef IBV_CMD_REG_MR_HAS_RESP_PARAMS
 	if (ibv_cmd_reg_mr(pd, addr, length, (uintptr_t) addr,
 			access, mr, &cmd.ibv_cmd, sizeof cmd,
 			&resp, sizeof resp)) {
-#else
-	if (ibv_cmd_reg_mr(pd, addr, length, (uintptr_t) addr,
-			access, mr, &cmd.ibv_cmd, sizeof cmd)) {
-#endif
 		free(mr);
 
 		return NULL;
@@ -225,9 +218,7 @@ int nes_ima_ureplace_cq(struct ibv_cq *cq,
 	struct nes_ucreate_cq_resp resp;
 	int comp_vector = nesucq->comp_vector;
 	struct nes_ureg_mr reg_mr_cmd;
-#ifdef IBV_CMD_REG_MR_HAS_RESP_PARAMS
 	struct ibv_reg_mr_resp reg_mr_resp;
-#endif
 	struct nes_uvcontext *nesvctx = to_nes_uctx(cq->context);
 
 	ret = ibv_cmd_destroy_cq(cq);
@@ -248,20 +239,12 @@ int nes_ima_ureplace_cq(struct ibv_cq *cq,
 
 	reg_mr_cmd.reg_type = NES_UMEMREG_TYPE_CQ;
 
-#ifdef IBV_CMD_REG_MR_HAS_RESP_PARAMS
 	ret = ibv_cmd_reg_mr(&nesvctx->nesupd->ibv_pd, (void *)nesucq->cqes,
 			(nesucq->size*sizeof(struct nes_hw_cqe)),
 			(uintptr_t)nesucq->cqes,
 			IBV_ACCESS_LOCAL_WRITE, &nesucq->mr,
 			&reg_mr_cmd.ibv_cmd, sizeof reg_mr_cmd,
 			&reg_mr_resp, sizeof reg_mr_resp);
-#else
-	ret = ibv_cmd_reg_mr(&nesvctx->nesupd->ibv_pd, (void *)nesucq->cqes,
-			(nesucq->size*sizeof(struct nes_hw_cqe)),
-			(uintptr_t)nesucq->cqes,
-			IBV_ACCESS_LOCAL_WRITE, &nesucq->mr,
-			&reg_mr_cmd.ibv_cmd, sizeof reg_mr_cmd);
-#endif
 	if (ret) {
 		free((struct nes_hw_cqe *)nesucq->cqes);
 		goto err;
@@ -305,9 +288,7 @@ struct ibv_cq *nes_ucreate_cq(struct ibv_context *context, int cqe,
 {
 	struct nes_ucq *nesucq;
 	struct nes_ureg_mr reg_mr_cmd;
-#ifdef IBV_CMD_REG_MR_HAS_RESP_PARAMS
 	struct ibv_reg_mr_resp reg_mr_resp;
-#endif
 	struct nes_ucreate_cq cmd;
 	struct nes_ucreate_cq_resp resp;
 	int ret;
@@ -336,18 +317,11 @@ struct ibv_cq *nes_ucreate_cq(struct ibv_context *context, int cqe,
 	/* Register the memory for the CQ */
 	reg_mr_cmd.reg_type = NES_UMEMREG_TYPE_CQ;
 
-#ifdef IBV_CMD_REG_MR_HAS_RESP_PARAMS
 	ret = ibv_cmd_reg_mr(&nesvctx->nesupd->ibv_pd, (void *)nesucq->cqes,
 			(nesucq->size*sizeof(struct nes_hw_cqe)),
 			(uintptr_t)nesucq->cqes, IBV_ACCESS_LOCAL_WRITE, &nesucq->mr,
 			&reg_mr_cmd.ibv_cmd, sizeof reg_mr_cmd,
 			&reg_mr_resp, sizeof reg_mr_resp);
-#else
-	ret = ibv_cmd_reg_mr(&nesvctx->nesupd->ibv_pd, (void *)nesucq->cqes,
-			(nesucq->size*sizeof(struct nes_hw_cqe)),
-			(uintptr_t)nesucq->cqes, IBV_ACCESS_LOCAL_WRITE, &nesucq->mr,
-			&reg_mr_cmd.ibv_cmd, sizeof reg_mr_cmd);
-#endif
 	if (ret) {
 		/* fprintf(stderr, "ibv_cmd_reg_mr failed (ret = %d).\n", ret); */
 		free((struct nes_hw_cqe *)nesucq->cqes);
@@ -1039,9 +1013,7 @@ static int nes_vmapped_qp(struct nes_uqp *nesuqp, struct ibv_pd *pd, struct ibv_
 {
 	struct nes_ucreate_qp cmd;
 	struct nes_ureg_mr reg_mr_cmd;
-#ifdef IBV_CMD_REG_MR_HAS_RESP_PARAMS
         struct ibv_reg_mr_resp reg_mr_resp;
-#endif
 	int totalqpsize;
 	int ret;
 
@@ -1060,17 +1032,10 @@ static int nes_vmapped_qp(struct nes_uqp *nesuqp, struct ibv_pd *pd, struct ibv_
 	//fprintf(stderr, PFX "qp_rq_vbase = %p qp_sq_vbase=%p reg_mr = %p\n",
 	//		nesuqp->rq_vbase, nesuqp->sq_vbase, &nesuqp->mr);
 
-#ifdef IBV_CMD_REG_MR_HAS_RESP_PARAMS
         ret = ibv_cmd_reg_mr(pd, (void *)nesuqp->sq_vbase,totalqpsize,
 			     (uintptr_t) nesuqp->sq_vbase, IBV_ACCESS_LOCAL_WRITE,
 			     &nesuqp->mr, &reg_mr_cmd.ibv_cmd, sizeof reg_mr_cmd,
 			     &reg_mr_resp, sizeof reg_mr_resp);
-#else
-        ret = ibv_cmd_reg_mr(pd, (void *)nesuqp->sq_vbase,totalqpsize,
-			     (uintptr_t) nesuqp->sq_vbase, IBV_ACCESS_LOCAL_WRITE,
-			     &nesuqp->mr, &reg_mr_cmd.ibv_cmd, sizeof reg_mr_cmd);
-#endif
-
         if (ret) {
                 // fprintf(stderr, PFX "%s ibv_cmd_reg_mr failed (ret = %d).\n", __FUNCTION__, ret);
 		free((void *) nesuqp->sq_vbase);
diff --git a/librxe/src/rxe.c b/librxe/src/rxe.c
index ef7434e1d506..8f8cc91052e5 100644
--- a/librxe/src/rxe.c
+++ b/librxe/src/rxe.c
@@ -127,6 +127,7 @@ static struct ibv_mr *rxe_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 {
 	struct ibv_mr *mr;
 	struct ibv_reg_mr cmd;
+	struct ibv_reg_mr_resp resp;
 	int ret;
 
 	mr = malloc(sizeof *mr);
@@ -134,19 +135,8 @@ static struct ibv_mr *rxe_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 		return NULL;
 	}
 
-#ifdef IBV_CMD_REG_MR_HAS_RESP_PARAMS
-	{
-		struct ibv_reg_mr_resp resp;
-
-		ret = ibv_cmd_reg_mr(pd, addr, length, (uintptr_t) addr,
-				     access, mr, &cmd, sizeof cmd,
-				     &resp, sizeof resp);
-	}
-#else
-	ret = ibv_cmd_reg_mr(pd, addr, length, (uintptr_t) addr,
-			     access, mr, &cmd, sizeof cmd);
-#endif
-
+	ret = ibv_cmd_reg_mr(pd, addr, length, (uintptr_t)addr, access, mr,
+			     &cmd, sizeof cmd, &resp, sizeof resp);
 	if (ret) {
 		free(mr);
 		return NULL;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
