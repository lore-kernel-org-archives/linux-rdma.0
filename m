From: Colin King <colin.king@canonical.com>
Subject: [PATCH] RDMA/hns: ensure for-loop actually iterates and free's buffers
Date: Mon, 26 Mar 2018 16:10:18 +0100
Message-ID: <20180326151018.21066-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Lijun Ou <oulijun@huawei.com>, Wei Hu <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The current for-loop zeros variable i and only loops once, hence
not all the buffers are free'd.  Fix this by setting i correctly.

Detected by CoverityScan, CID#1463415 ("Operands don't affect result")

Fixes: a5073d6054f7 ("RDMA/hns: Add eq support of hip08")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 684c2d1a0ed0..8b84ab7800d8 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4391,7 +4391,7 @@ static int hns_roce_mhop_alloc_eq(struct hns_roce_dev *hr_dev,
 	eq->l0_dma = 0;
 
 	if (mhop_num == 1)
-		for (i -= i; i >= 0; i--)
+		for (i -= 1; i >= 0; i--)
 			dma_free_coherent(dev, buf_chk_sz, eq->buf[i],
 					  eq->buf_dma[i]);
 	else if (mhop_num == 2) {
-- 
2.15.1
