From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH for-next 2/9] RDMA/hns: Factor out the code for checking sdb status into a new function
Date: Thu, 28 Sep 2017 12:57:27 +0800
Message-ID: <1506574654-56699-3-git-send-email-xavier.huwei@huawei.com>
References: <1506574654-56699-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1506574654-56699-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, xavier.huwei@huawei.com, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, xushaobo2@huawei.com, zhangxiping3@huawei.com, xavier.huwei@tom.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, shaobohsu@163.com
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

It mainly places the lines for checking send doorbell status
into a special functions. As a result, we can directly call it in
check_qp_db_process_status function and keep consistent indenting
style.

It fixes: 5f110ac4bed8 ("IB/hns: Fix for checkpatch.pl comment style)
The warning from static checker:
drivers/infiniband/hw/hns/hns_roce_hw_v1.c:3562 check_qp_db_process_status()
warn: inconsistent indenting

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Shaobo Xu <xushaobo2@huawei.com>
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
