From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] RDMA/hns: Make some function static
Date: Fri, 1 Feb 2019 11:11:04 +0800
Message-ID: <20190201031104.15064-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: oulijun@huawei.com, xavier.huwei@huawei.com, dledford@redhat.com, jgg@ziepe.ca
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-rdma@vger.kernel.org

Fixes the following sparse warnings:

drivers/infiniband/hw/hns/hns_roce_hw_v2.c:5822:5: warning:
 symbol 'hns_roce_v2_query_srq' was not declared. Should it be static?
drivers/infiniband/hw/hns/hns_roce_srq.c:158:6: warning:
 symbol 'hns_roce_srq_free' was not declared. Should it be static?
drivers/infiniband/hw/hns/hns_roce_srq.c:81:5: warning:
 symbol 'hns_roce_srq_alloc' was not declared. Should it be static?

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c   | 9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 5c483b4..58271d2 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5819,7 +5819,7 @@ static int hns_roce_v2_modify_srq(struct ib_srq *ibsrq,
 	return 0;
 }
 
-int hns_roce_v2_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr)
+static int hns_roce_v2_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr)
 {
 	struct hns_roce_dev *hr_dev = to_hr_dev(ibsrq->device);
 	struct hns_roce_srq *srq = to_hr_srq(ibsrq);
diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index 11be2db..a8ee2f6 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -78,9 +78,9 @@ static int hns_roce_hw2sw_srq(struct hns_roce_dev *dev,
 				 HNS_ROCE_CMD_TIMEOUT_MSECS);
 }
 
-int hns_roce_srq_alloc(struct hns_roce_dev *hr_dev, u32 pdn, u32 cqn, u16 xrcd,
-		       struct hns_roce_mtt *hr_mtt, u64 db_rec_addr,
-		       struct hns_roce_srq *srq)
+static int hns_roce_srq_alloc(struct hns_roce_dev *hr_dev, u32 pdn, u32 cqn,
+			      u16 xrcd, struct hns_roce_mtt *hr_mtt,
+			      u64 db_rec_addr, struct hns_roce_srq *srq)
 {
 	struct hns_roce_srq_table *srq_table = &hr_dev->srq_table;
 	struct hns_roce_cmd_mailbox *mailbox;
@@ -155,7 +155,8 @@ int hns_roce_srq_alloc(struct hns_roce_dev *hr_dev, u32 pdn, u32 cqn, u16 xrcd,
 	return ret;
 }
 
-void hns_roce_srq_free(struct hns_roce_dev *hr_dev, struct hns_roce_srq *srq)
+static void hns_roce_srq_free(struct hns_roce_dev *hr_dev,
+			      struct hns_roce_srq *srq)
 {
 	struct hns_roce_srq_table *srq_table = &hr_dev->srq_table;
 	int ret;
-- 
2.7.0
