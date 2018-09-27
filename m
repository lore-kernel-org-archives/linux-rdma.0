From: Colin King <colin.king@canonical.com>
Subject: [PATCH] RDMA/hns: fix spelling mistake "reseved" -> "reserved"
Date: Thu, 27 Sep 2018 14:24:30 +0100
Message-ID: <20180927132430.25172-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Lijun Ou <oulijun@huawei.com>, Wei Hu <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in dev_err error message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 081aa91fc162..ca05810c92dc 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -731,7 +731,7 @@ static int hns_roce_v1_rsv_lp_qp(struct hns_roce_dev *hr_dev)
 	cq_init_attr.comp_vector	= 0;
 	cq = hns_roce_ib_create_cq(&hr_dev->ib_dev, &cq_init_attr, NULL, NULL);
 	if (IS_ERR(cq)) {
-		dev_err(dev, "Create cq for reseved loop qp failed!");
+		dev_err(dev, "Create cq for reserved loop qp failed!");
 		return -ENOMEM;
 	}
 	free_mr->mr_free_cq = to_hr_cq(cq);
@@ -744,7 +744,7 @@ static int hns_roce_v1_rsv_lp_qp(struct hns_roce_dev *hr_dev)
 
 	pd = hns_roce_alloc_pd(&hr_dev->ib_dev, NULL, NULL);
 	if (IS_ERR(pd)) {
-		dev_err(dev, "Create pd for reseved loop qp failed!");
+		dev_err(dev, "Create pd for reserved loop qp failed!");
 		ret = -ENOMEM;
 		goto alloc_pd_failed;
 	}
-- 
2.17.1
