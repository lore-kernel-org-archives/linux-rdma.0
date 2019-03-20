From: Yue Haibing <yuehaibing@huawei.com>
Subject: [PATCH -next] RDMA/hns: Make hns_roce_cmq_send static
Date: Wed, 20 Mar 2019 21:50:47 +0800
Message-ID: <20190320135047.23184-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: oulijun@huawei.com, xavier.huwei@huawei.com, dledford@redhat.com, jgg@ziepe.ca
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-rdma@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Fix sparse warning:

drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1089:5:
 warning: symbol 'hns_roce_cmq_send' was not declared. Should it be static?

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 1c54390..b13436e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1086,7 +1086,7 @@ static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 	return ret;
 }
 
-int hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
+static int hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 			     struct hns_roce_cmq_desc *desc, int num)
 {
 	int retval;
-- 
2.7.0
