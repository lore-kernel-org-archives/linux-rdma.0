From: Ram Amrani <Ram.Amrani-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/5] qedr: mark three functions as static
Date: Mon, 23 Jan 2017 17:28:35 +0200
Message-ID: <1485185319-18771-2-git-send-email-Ram.Amrani@qlogic.com>
References: <1485185319-18771-1-git-send-email-Ram.Amrani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485185319-18771-1-git-send-email-Ram.Amrani-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

mark qedr_get_state_from_ibqp(), __qedr_alloc_mr() and __qedr_post_send()
as static since they are only used in the same file.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 189f9bd..2d55597 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1600,7 +1600,7 @@ struct ib_qp *qedr_create_qp(struct ib_pd *ibpd,
 	return ERR_PTR(-EFAULT);
 }
 
-enum ib_qp_state qedr_get_ibqp_state(enum qed_roce_qp_state qp_state)
+static enum ib_qp_state qedr_get_ibqp_state(enum qed_roce_qp_state qp_state)
 {
 	switch (qp_state) {
 	case QED_ROCE_QP_STATE_RESET:
@@ -1621,7 +1621,8 @@ enum ib_qp_state qedr_get_ibqp_state(enum qed_roce_qp_state qp_state)
 	return IB_QPS_ERR;
 }
 
-enum qed_roce_qp_state qedr_get_state_from_ibqp(enum ib_qp_state qp_state)
+static enum qed_roce_qp_state qedr_get_state_from_ibqp(
+					enum ib_qp_state qp_state)
 {
 	switch (qp_state) {
 	case IB_QPS_RESET:
@@ -2310,7 +2311,8 @@ int qedr_dereg_mr(struct ib_mr *ib_mr)
 	return rc;
 }
 
-struct qedr_mr *__qedr_alloc_mr(struct ib_pd *ibpd, int max_page_list_len)
+static struct qedr_mr *__qedr_alloc_mr(struct ib_pd *ibpd,
+				       int max_page_list_len)
 {
 	struct qedr_pd *pd = get_qedr_pd(ibpd);
 	struct qedr_dev *dev = get_qedr_dev(ibpd->device);
@@ -2712,7 +2714,7 @@ static int qedr_prepare_reg(struct qedr_qp *qp,
 	return 0;
 }
 
-enum ib_wc_opcode qedr_ib_to_wc_opcode(enum ib_wr_opcode opcode)
+static enum ib_wc_opcode qedr_ib_to_wc_opcode(enum ib_wr_opcode opcode)
 {
 	switch (opcode) {
 	case IB_WR_RDMA_WRITE:
@@ -2737,7 +2739,7 @@ enum ib_wc_opcode qedr_ib_to_wc_opcode(enum ib_wr_opcode opcode)
 	}
 }
 
-inline bool qedr_can_post_send(struct qedr_qp *qp, struct ib_send_wr *wr)
+static inline bool qedr_can_post_send(struct qedr_qp *qp, struct ib_send_wr *wr)
 {
 	int wq_is_full, err_wr, pbl_is_full;
 	struct qedr_dev *dev = qp->dev;
@@ -2774,7 +2776,7 @@ inline bool qedr_can_post_send(struct qedr_qp *qp, struct ib_send_wr *wr)
 	return true;
 }
 
-int __qedr_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
+static int __qedr_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		     struct ib_send_wr **bad_wr)
 {
 	struct qedr_dev *dev = get_qedr_dev(ibqp->device);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
