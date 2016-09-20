From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 for-next 05/19] IB/hns: Remove unused parameter named qp_type
Date: Tue, 20 Sep 2016 17:06:58 +0100
Message-ID: <20160920160712.1190216-6-salil.mehta@huawei.com>
References: <20160920160712.1190216-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160920160712.1190216-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, xuwei5@hisilicon.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, Ping Zhang <zhangping5@huawei.com>
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

This patch removes the qp_type parameter in
hns_roce_set_kernel_sq_size().

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Ping Zhang <zhangping5@huawei.com>
Reviewed-by: Wei Hu <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 73de1d3..177f48f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -336,12 +336,10 @@ static int hns_roce_set_user_sq_size(struct hns_roce_dev *hr_dev,
 
 static int hns_roce_set_kernel_sq_size(struct hns_roce_dev *hr_dev,
 				       struct ib_qp_cap *cap,
-				       enum ib_qp_type type,
 				       struct hns_roce_qp *hr_qp)
 {
 	struct device *dev = &hr_dev->pdev->dev;
 	u32 max_cnt;
-	(void)type;
 
 	if (cap->max_send_wr  > hr_dev->caps.max_wqes  ||
 	    cap->max_send_sge > hr_dev->caps.max_sq_sg ||
@@ -467,7 +465,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 
 		/* Set SQ size */
 		ret = hns_roce_set_kernel_sq_size(hr_dev, &init_attr->cap,
-						  init_attr->qp_type, hr_qp);
+						  hr_qp);
 		if (ret) {
 			dev_err(dev, "hns_roce_set_kernel_sq_size error!\n");
 			goto err_out;
-- 
1.9.1
