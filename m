From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 for-rdma 5/5] IB/hns: Fix for checkpatch.pl comment style warnings
Date: Sat, 10 Jun 2017 18:49:25 +0800
Message-ID: <1497091765-10513-6-git-send-email-oulijun@huawei.com>
References: <1497091765-10513-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1497091765-10513-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch correct the comment style warnings caught by
checkpatch.pl script.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index fa30989..9980825 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -2196,7 +2196,7 @@ static int hns_roce_v1_poll_one(struct hns_roce_cq *hr_cq,
 		}
 		wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
 		++wq->tail;
-		} else {
+	} else {
 		/* RQ conrespond to CQE */
 		wc->byte_len = le32_to_cpu(cqe->byte_cnt);
 		opcode = roce_get_field(cqe->cqe_byte_4,
@@ -3548,10 +3548,12 @@ static int check_qp_db_process_status(struct hns_roce_dev *hr_dev,
 					old_cnt = roce_get_field(old_send,
 					ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_M,
 					ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_S);
-					if (cur_cnt - old_cnt > SDB_ST_CMP_VAL)
+					if (cur_cnt - old_cnt >
+					    SDB_ST_CMP_VAL) {
 						success_flags = 1;
-					else {
-					    send_ptr = roce_get_field(old_send,
+					} else {
+						send_ptr =
+							roce_get_field(old_send,
 					    ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_M,
 					    ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_S) +
 					    roce_get_field(sdb_retry_cnt,
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
