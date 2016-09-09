From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH for-next 08/20] IB/hns: Delete the sqp_start from the structure hns_roce_caps
Date: Fri, 9 Sep 2016 18:30:39 +0800
Message-ID: <1473417051-99560-9-git-send-email-salil.mehta@huawei.com>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, xuwei5@hisilicon.com, mehta.salil.lnk@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>

This patch deleted the sqp_start from the structure hns_roce_caps, and
modified the calculation of the qp number.

Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |    1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |    1 -
 drivers/infiniband/hw/hns/hns_roce_qp.c     |   10 ++++------
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index f01cc2f..7643716 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -464,7 +464,6 @@ struct hns_roce_caps {
 	u32		max_rq_desc_sz;	/* 64 */
 	int		max_qp_init_rdma;
 	int		max_qp_dest_rdma;
-	int		sqp_start;
 	int		num_cqs;
 	int		max_cqes;
 	int		reserved_cqs;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index f6bb88c..f4d2515 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -942,7 +942,6 @@ void hns_roce_v1_profile(struct hns_roce_dev *hr_dev)
 	caps->mtt_entry_sz	= HNS_ROCE_V1_MTT_ENTRY_SIZE;
 	caps->cq_entry_sz	= HNS_ROCE_V1_CQE_ENTRY_SIZE;
 	caps->page_size_cap	= HNS_ROCE_V1_PAGE_SIZE_SUPPORT;
-	caps->sqp_start		= 0;
 	caps->reserved_lkey	= 0;
 	caps->reserved_pds	= 0;
 	caps->reserved_mrws	= 1;
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 755a4b8..51fefbf 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -39,7 +39,7 @@
 #include "hns_roce_user.h"
 
 #define DB_REG_OFFSET			0x1000
-#define SQP_NUM				12
+#define SQP_NUM				(2 * HNS_ROCE_MAX_PORTS)
 
 void hns_roce_qp_event(struct hns_roce_dev *hr_dev, u32 qpn, int event_type)
 {
@@ -247,7 +247,7 @@ void hns_roce_release_range_qp(struct hns_roce_dev *hr_dev, int base_qpn,
 {
 	struct hns_roce_qp_table *qp_table = &hr_dev->qp_table;
 
-	if (base_qpn < (hr_dev->caps.sqp_start + 2 * hr_dev->caps.num_ports))
+	if (base_qpn < SQP_NUM)
 		return;
 
 	hns_roce_bitmap_free_range(&qp_table->bitmap, base_qpn, cnt);
@@ -609,8 +609,7 @@ struct ib_qp *hns_roce_create_qp(struct ib_pd *pd,
 		hr_qp = &hr_sqp->hr_qp;
 		hr_qp->port = init_attr->port_num - 1;
 		hr_qp->phy_port = hr_dev->iboe.phy_port[hr_qp->port];
-		hr_qp->ibqp.qp_num = hr_dev->caps.sqp_start +
-				     HNS_ROCE_MAX_PORTS +
+		hr_qp->ibqp.qp_num = HNS_ROCE_MAX_PORTS +
 				     hr_dev->iboe.phy_port[hr_qp->port];
 
 		ret = hns_roce_create_qp_common(hr_dev, pd, init_attr, udata,
@@ -826,8 +825,7 @@ int hns_roce_init_qp_table(struct hns_roce_dev *hr_dev)
 
 	/* A port include two SQP, six port total 12 */
 	ret = hns_roce_bitmap_init(&qp_table->bitmap, hr_dev->caps.num_qps,
-				   hr_dev->caps.num_qps - 1,
-				   hr_dev->caps.sqp_start + SQP_NUM,
+				   hr_dev->caps.num_qps - 1, SQP_NUM,
 				   reserved_from_top);
 	if (ret) {
 		dev_err(&hr_dev->pdev->dev, "qp bitmap init failed!error=%d\n",
-- 
1.7.9.5
