From: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 2/2] libhns: Support cq record doorbell
Date: Thu, 18 Jan 2018 10:36:01 +0800
Message-ID: <1516242961-154453-3-git-send-email-liuyixian@huawei.com>
References: <1516242961-154453-1-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516242961-154453-1-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch updates to support cq record doorbell in
user space driver.

Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 providers/hns/hns_roce_u_hw_v2.c | 27 +++++----------------------
 providers/hns/hns_roce_u_verbs.c | 21 ++++++++++++++++++---
 2 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/providers/hns/hns_roce_u_hw_v2.c b/providers/hns/hns_roce_u_hw_v2.c
index c0e0f26..f009839 100644
--- a/providers/hns/hns_roce_u_hw_v2.c
+++ b/providers/hns/hns_roce_u_hw_v2.c
@@ -182,25 +182,10 @@ static void hns_roce_update_sq_db(struct hns_roce_context *ctx,
 	hns_roce_write64((uint32_t *)&sq_db, ctx, ROCEE_VF_DB_CFG0_OFFSET);
 }
 
-static void hns_roce_v2_update_cq_cons_index(struct hns_roce_context *ctx,
-					     struct hns_roce_cq *cq)
+static void hns_roce_v2_update_cq_cons_index(struct hns_roce_cq *cq)
 {
-	struct hns_roce_v2_cq_db cq_db;
-
-	cq_db.byte_4 = 0;
-	cq_db.parameter = 0;
-
-	roce_set_field(cq_db.byte_4, DB_BYTE_4_TAG_M, DB_BYTE_4_TAG_S, cq->cqn);
-	roce_set_field(cq_db.byte_4, DB_BYTE_4_CMD_M, DB_BYTE_4_CMD_S, 0x3);
-
-	roce_set_field(cq_db.parameter, CQ_DB_PARAMETER_CQ_CONSUMER_IDX_M,
-		       CQ_DB_PARAMETER_CQ_CONSUMER_IDX_S,
-		       cq->cons_index & ((cq->cq_depth << 1) - 1));
-	roce_set_field(cq_db.parameter, CQ_DB_PARAMETER_CMD_SN_M,
-		       CQ_DB_PARAMETER_CMD_SN_S, 1);
-	roce_set_bit(cq_db.parameter, CQ_DB_PARAMETER_NOTIFY_S, 0);
-
-	hns_roce_write64((uint32_t *)&cq_db, ctx, ROCEE_VF_DB_CFG0_OFFSET);
+	*cq->set_ci_db = (unsigned short)(cq->cons_index &
+					  ((cq->cq_depth << 1) - 1));
 }
 
 static struct hns_roce_qp *hns_roce_v2_find_qp(struct hns_roce_context *ctx,
@@ -450,7 +435,6 @@ static int hns_roce_u_v2_poll_cq(struct ibv_cq *ibvcq, int ne,
 	int err = V2_CQ_OK;
 	struct hns_roce_qp *qp = NULL;
 	struct hns_roce_cq *cq = to_hr_cq(ibvcq);
-	struct hns_roce_context *ctx = to_hr_ctx(ibvcq->context);
 
 	pthread_spin_lock(&cq->lock);
 
@@ -463,7 +447,7 @@ static int hns_roce_u_v2_poll_cq(struct ibv_cq *ibvcq, int ne,
 	if (npolled) {
 		mmio_ordered_writes_hack();
 
-		hns_roce_v2_update_cq_cons_index(ctx, cq);
+		hns_roce_v2_update_cq_cons_index(cq);
 	}
 
 	pthread_spin_unlock(&cq->lock);
@@ -830,7 +814,6 @@ static void __hns_roce_v2_cq_clean(struct hns_roce_cq *cq, uint32_t qpn,
 	uint32_t prod_index;
 	uint8_t owner_bit = 0;
 	struct hns_roce_v2_cqe *cqe, *dest;
-	struct hns_roce_context *ctx = to_hr_ctx(cq->ibv_cq.context);
 
 	for (prod_index = cq->cons_index; get_sw_cqe_v2(cq, prod_index);
 	     ++prod_index)
@@ -856,7 +839,7 @@ static void __hns_roce_v2_cq_clean(struct hns_roce_cq *cq, uint32_t qpn,
 	if (nfreed) {
 		cq->cons_index += nfreed;
 		udma_to_device_barrier();
-		hns_roce_v2_update_cq_cons_index(ctx, cq);
+		hns_roce_v2_update_cq_cons_index(cq);
 	}
 }
 
diff --git a/providers/hns/hns_roce_u_verbs.c b/providers/hns/hns_roce_u_verbs.c
index cde8568..7037a1c 100644
--- a/providers/hns/hns_roce_u_verbs.c
+++ b/providers/hns/hns_roce_u_verbs.c
@@ -276,6 +276,16 @@ struct ibv_cq *hns_roce_u_create_cq(struct ibv_context *context, int cqe,
 
 	cmd.buf_addr = (uintptr_t) cq->buf.buf;
 
+	if (to_hr_dev(context->device)->hw_version != HNS_ROCE_HW_VER1) {
+		cq->set_ci_db = hns_roce_alloc_db(to_hr_ctx(context),
+						  HNS_ROCE_CQ_TYPE_DB);
+		if (!cq->set_ci_db) {
+			fprintf(stderr, "alloc cq db buffer failed!\n");
+			goto err_buf;
+		}
+		cmd.db_addr  = (uintptr_t) cq->set_ci_db;
+	}
+
 	ret = ibv_cmd_create_cq(context, cqe, channel, comp_vector,
 				&cq->ibv_cq, &cmd.ibv_cmd, sizeof(cmd),
 				&resp.ibv_resp, sizeof(resp));
@@ -287,9 +297,6 @@ struct ibv_cq *hns_roce_u_create_cq(struct ibv_context *context, int cqe,
 
 	if (to_hr_dev(context->device)->hw_version == HNS_ROCE_HW_VER1)
 		cq->set_ci_db = to_hr_ctx(context)->cq_tptr_base + cq->cqn * 2;
-	else
-		cq->set_ci_db = to_hr_ctx(context)->uar +
-				ROCEE_VF_DB_CFG0_OFFSET;
 
 	cq->arm_db    = cq->set_ci_db;
 	cq->arm_sn    = 1;
@@ -299,6 +306,11 @@ struct ibv_cq *hns_roce_u_create_cq(struct ibv_context *context, int cqe,
 	return &cq->ibv_cq;
 
 err_db:
+	if (to_hr_dev(context->device)->hw_version != HNS_ROCE_HW_VER1)
+		hns_roce_free_db(to_hr_ctx(context), cq->set_ci_db,
+				 HNS_ROCE_CQ_TYPE_DB);
+
+err_buf:
 	hns_roce_free_buf(&cq->buf);
 
 err:
@@ -320,6 +332,9 @@ int hns_roce_u_destroy_cq(struct ibv_cq *cq)
 	if (ret)
 		return ret;
 
+	if (to_hr_dev(cq->context->device)->hw_version != HNS_ROCE_HW_VER1)
+		hns_roce_free_db(to_hr_ctx(cq->context),
+				 to_hr_cq(cq)->set_ci_db, HNS_ROCE_CQ_TYPE_DB);
 	hns_roce_free_buf(&to_hr_cq(cq)->buf);
 	free(to_hr_cq(cq));
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
