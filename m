From: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 rdma-core 2/2] libhns: Support cq record doorbell
Date: Sun, 11 Feb 2018 20:40:34 +0800
Message-ID: <1518352834-80200-3-git-send-email-liuyixian@huawei.com>
References: <1518352834-80200-1-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1518352834-80200-1-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch updates to support cq record doorbell in
user space driver.

Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/hns/hns_roce_u.h       |  1 +
 providers/hns/hns_roce_u_abi.h   |  2 ++
 providers/hns/hns_roce_u_hw_v2.c |  6 +++++-
 providers/hns/hns_roce_u_hw_v2.h |  4 ++++
 providers/hns/hns_roce_u_verbs.c | 26 +++++++++++++++++++++-----
 5 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/providers/hns/hns_roce_u.h b/providers/hns/hns_roce_u.h
index 95440e9..5fd9a50 100644
--- a/providers/hns/hns_roce_u.h
+++ b/providers/hns/hns_roce_u.h
@@ -154,6 +154,7 @@ struct hns_roce_cq {
 	unsigned int			*set_ci_db;
 	unsigned int			*arm_db;
 	int				arm_sn;
+	unsigned int			flags;
 };
 
 struct hns_roce_srq {
diff --git a/providers/hns/hns_roce_u_abi.h b/providers/hns/hns_roce_u_abi.h
index fafd052..d6b92fa 100644
--- a/providers/hns/hns_roce_u_abi.h
+++ b/providers/hns/hns_roce_u_abi.h
@@ -57,6 +57,8 @@ struct hns_roce_create_cq_resp {
 	struct ib_uverbs_create_cq_resp	ibv_resp;
 	__u32				cqn;
 	__u32				reserved;
+	__u32				cap_flags;
+	__u32				reserved1;
 };
 
 struct hns_roce_create_qp {
diff --git a/providers/hns/hns_roce_u_hw_v2.c b/providers/hns/hns_roce_u_hw_v2.c
index 12558ff..f1398eb 100644
--- a/providers/hns/hns_roce_u_hw_v2.c
+++ b/providers/hns/hns_roce_u_hw_v2.c
@@ -476,7 +476,11 @@ static int hns_roce_u_v2_poll_cq(struct ibv_cq *ibvcq, int ne,
 	if (npolled) {
 		mmio_ordered_writes_hack();
 
-		hns_roce_v2_update_cq_cons_index(ctx, cq);
+		if (cq->flags & HNS_ROCE_SUPPORT_CQ_RECORD_DB)
+			*cq->set_ci_db = (unsigned short)(cq->cons_index &
+						((cq->cq_depth << 1) - 1));
+		else
+			hns_roce_v2_update_cq_cons_index(ctx, cq);
 	}
 
 	pthread_spin_unlock(&cq->lock);
diff --git a/providers/hns/hns_roce_u_hw_v2.h b/providers/hns/hns_roce_u_hw_v2.h
index 15ac0ca..84a7726 100644
--- a/providers/hns/hns_roce_u_hw_v2.h
+++ b/providers/hns/hns_roce_u_hw_v2.h
@@ -44,6 +44,10 @@ enum {
 	HNS_ROCE_SUPPORT_RQ_RECORD_DB = 1 << 0,
 };
 
+enum {
+	HNS_ROCE_SUPPORT_CQ_RECORD_DB = 1 << 0,
+};
+
 /* V2 REG DEFINITION */
 #define ROCEE_VF_DB_CFG0_OFFSET			0x0230
 
diff --git a/providers/hns/hns_roce_u_verbs.c b/providers/hns/hns_roce_u_verbs.c
index 221841f..a3d3f28 100644
--- a/providers/hns/hns_roce_u_verbs.c
+++ b/providers/hns/hns_roce_u_verbs.c
@@ -253,8 +253,8 @@ struct ibv_cq *hns_roce_u_create_cq(struct ibv_context *context, int cqe,
 				    struct ibv_comp_channel *channel,
 				    int comp_vector)
 {
-	struct hns_roce_create_cq	cmd;
-	struct hns_roce_create_cq_resp	resp;
+	struct hns_roce_create_cq	cmd = {};
+	struct hns_roce_create_cq_resp	resp = {};
 	struct hns_roce_cq		*cq;
 	int				ret;
 
@@ -277,6 +277,16 @@ struct ibv_cq *hns_roce_u_create_cq(struct ibv_context *context, int cqe,
 
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
@@ -285,12 +295,10 @@ struct ibv_cq *hns_roce_u_create_cq(struct ibv_context *context, int cqe,
 
 	cq->cqn = resp.cqn;
 	cq->cq_depth = cqe;
+	cq->flags = resp.cap_flags;
 
 	if (to_hr_dev(context->device)->hw_version == HNS_ROCE_HW_VER1)
 		cq->set_ci_db = to_hr_ctx(context)->cq_tptr_base + cq->cqn * 2;
-	else
-		cq->set_ci_db = to_hr_ctx(context)->uar +
-				ROCEE_VF_DB_CFG0_OFFSET;
 
 	cq->arm_db    = cq->set_ci_db;
 	cq->arm_sn    = 1;
@@ -300,6 +308,11 @@ struct ibv_cq *hns_roce_u_create_cq(struct ibv_context *context, int cqe,
 	return &cq->ibv_cq;
 
 err_db:
+	if (to_hr_dev(context->device)->hw_version != HNS_ROCE_HW_VER1)
+		hns_roce_free_db(to_hr_ctx(context), cq->set_ci_db,
+				 HNS_ROCE_CQ_TYPE_DB);
+
+err_buf:
 	hns_roce_free_buf(&cq->buf);
 
 err:
@@ -321,6 +334,9 @@ int hns_roce_u_destroy_cq(struct ibv_cq *cq)
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
