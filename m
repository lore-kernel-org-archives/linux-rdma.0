From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 for-next 2/8] RDMA/hns: Factor out the code for checking sdb status into a new function
Date: Fri, 29 Sep 2017 23:10:08 +0800
Message-ID: <1506697814-98432-3-git-send-email-xavier.huwei@huawei.com>
References: <1506697814-98432-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1506697814-98432-1-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaobohsu-9Onoh4P/yGk@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

It mainly places the lines for checking send doorbell status
into a special functions. As a result, we can directly call it in
check_qp_db_process_status function and keep consistent indenting
style.

It fixes the warning from static checker:
drivers/infiniband/hw/hns/hns_roce_hw_v1.c:3562 check_qp_db_process_status()
warn: inconsistent indenting.

Fixes: 5f110ac4bed8 ("IB/hns: Fix for checkpatch.pl comment style)

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
Patch V2:
1.modify the fixes to Fixes, and put it before signed-off-by at
  Leon's comment. The related link as below:
    https://lkml.org/lkml/2017/9/28/437

Patch V1: Initial  Submit
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 95 ++++++++++++++++--------------
 1 file changed, 51 insertions(+), 44 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 6e9acfd..95f5c88 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -3532,6 +3532,53 @@ int hns_roce_v1_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 		hns_roce_v1_q_qp(ibqp, qp_attr, qp_attr_mask, qp_init_attr);
 }
 
+static void hns_roce_check_sdb_status(struct hns_roce_dev *hr_dev,
+				      u32 *old_send, u32 *old_retry,
+				      u32 *tsp_st, u32 *success_flags)
+{
+	u32 sdb_retry_cnt;
+	u32 sdb_send_ptr;
+	u32 cur_cnt, old_cnt;
+	u32 send_ptr;
+
+	sdb_send_ptr = roce_read(hr_dev, ROCEE_SDB_SEND_PTR_REG);
+	sdb_retry_cnt =	roce_read(hr_dev, ROCEE_SDB_RETRY_CNT_REG);
+	cur_cnt = roce_get_field(sdb_send_ptr,
+				 ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_M,
+				 ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_S) +
+		  roce_get_field(sdb_retry_cnt,
+				 ROCEE_SDB_RETRY_CNT_SDB_RETRY_CT_M,
+				 ROCEE_SDB_RETRY_CNT_SDB_RETRY_CT_S);
+	if (!roce_get_bit(*tsp_st, ROCEE_CNT_CLR_CE_CNT_CLR_CE_S)) {
+		old_cnt = roce_get_field(*old_send,
+					 ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_M,
+					 ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_S) +
+			  roce_get_field(*old_retry,
+					 ROCEE_SDB_RETRY_CNT_SDB_RETRY_CT_M,
+					 ROCEE_SDB_RETRY_CNT_SDB_RETRY_CT_S);
+		if (cur_cnt - old_cnt > SDB_ST_CMP_VAL)
+			*success_flags = 1;
+	} else {
+		old_cnt = roce_get_field(*old_send,
+					 ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_M,
+					 ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_S);
+		if (cur_cnt - old_cnt > SDB_ST_CMP_VAL) {
+			*success_flags = 1;
+		} else {
+			send_ptr = roce_get_field(*old_send,
+					    ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_M,
+					    ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_S) +
+				   roce_get_field(sdb_retry_cnt,
+					    ROCEE_SDB_RETRY_CNT_SDB_RETRY_CT_M,
+					    ROCEE_SDB_RETRY_CNT_SDB_RETRY_CT_S);
+			roce_set_field(*old_send,
+				       ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_M,
+				       ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_S,
+				       send_ptr);
+		}
+	}
+}
+
 static int check_qp_db_process_status(struct hns_roce_dev *hr_dev,
 				      struct hns_roce_qp *hr_qp,
 				      u32 sdb_issue_ptr,
@@ -3539,12 +3586,10 @@ static int check_qp_db_process_status(struct hns_roce_dev *hr_dev,
 				      u32 *wait_stage)
 {
 	struct device *dev = &hr_dev->pdev->dev;
-	u32 sdb_retry_cnt, old_retry;
 	u32 sdb_send_ptr, old_send;
 	u32 success_flags = 0;
-	u32 cur_cnt, old_cnt;
 	unsigned long end;
-	u32 send_ptr;
+	u32 old_retry;
 	u32 inv_cnt;
 	u32 tsp_st;
 
@@ -3602,47 +3647,9 @@ static int check_qp_db_process_status(struct hns_roce_dev *hr_dev,
 
 				msleep(HNS_ROCE_V1_CHECK_DB_SLEEP_MSECS);
 
-				sdb_send_ptr = roce_read(hr_dev,
-							ROCEE_SDB_SEND_PTR_REG);
-				sdb_retry_cnt =	roce_read(hr_dev,
-						       ROCEE_SDB_RETRY_CNT_REG);
-				cur_cnt = roce_get_field(sdb_send_ptr,
-					ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_M,
-					ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_S) +
-					roce_get_field(sdb_retry_cnt,
-					ROCEE_SDB_RETRY_CNT_SDB_RETRY_CT_M,
-					ROCEE_SDB_RETRY_CNT_SDB_RETRY_CT_S);
-				if (!roce_get_bit(tsp_st,
-					ROCEE_CNT_CLR_CE_CNT_CLR_CE_S)) {
-					old_cnt = roce_get_field(old_send,
-					ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_M,
-					ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_S) +
-					roce_get_field(old_retry,
-					ROCEE_SDB_RETRY_CNT_SDB_RETRY_CT_M,
-					ROCEE_SDB_RETRY_CNT_SDB_RETRY_CT_S);
-					if (cur_cnt - old_cnt > SDB_ST_CMP_VAL)
-						success_flags = 1;
-				} else {
-					old_cnt = roce_get_field(old_send,
-					ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_M,
-					ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_S);
-					if (cur_cnt - old_cnt >
-					    SDB_ST_CMP_VAL) {
-						success_flags = 1;
-					} else {
-						send_ptr =
-							roce_get_field(old_send,
-					    ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_M,
-					    ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_S) +
-					    roce_get_field(sdb_retry_cnt,
-					    ROCEE_SDB_RETRY_CNT_SDB_RETRY_CT_M,
-					    ROCEE_SDB_RETRY_CNT_SDB_RETRY_CT_S);
-					    roce_set_field(old_send,
-					    ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_M,
-					    ROCEE_SDB_SEND_PTR_SDB_SEND_PTR_S,
-						send_ptr);
-					}
-				}
+				hns_roce_check_sdb_status(hr_dev, &old_send,
+							  &old_retry, &tsp_st,
+							  &success_flags);
 			} while (!success_flags);
 		}
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
