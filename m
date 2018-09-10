From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] RDMA/hns: Fix an error code in hns_roce_v2_init_eq_table()
Date: Mon, 10 Sep 2018 11:35:11 +0300
Message-ID: <20180910083511.egoljxb5rr3do6ue@kili.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Lijun Ou <oulijun@huawei.com>
Cc: "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The error code isn't set on this path.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 0218c0f8c2a7..b84bfa48371d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5125,6 +5125,7 @@ static int hns_roce_v2_init_eq_table(struct hns_roce_dev *hr_dev)
 		create_singlethread_workqueue("hns_roce_irq_workqueue");
 	if (!hr_dev->irq_workq) {
 		dev_err(dev, "Create irq workqueue failed!\n");
+		ret = -ENOMEM;
 		goto err_request_irq_fail;
 	}
 
