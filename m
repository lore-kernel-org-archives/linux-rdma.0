From: Colin King <colin.king@canonical.com>
Subject: [PATCH][rdma-next] RDMA/hns: remove redundant assignment to variable j
Date: Fri, 29 Sep 2017 14:52:27 +0100
Message-ID: <20170929135227.8343-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Lijun Ou <oulijun@huawei.com>, Wei Hu <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variable j is being assigned to loop_j and then later being
assigned to a new value in for loops. The first initialization
is therefore redundant and can be removed.

Cleans up clang warning:
warning: Value stored to 'j' is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/hns/hns_roce_mr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 7e6ce76b32df..452136d98ad5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -272,7 +272,6 @@ static void hns_roce_loop_free(struct hns_roce_dev *hr_dev,
 	mhop_num = hr_dev->caps.pbl_hop_num;
 
 	i = loop_i;
-	j = loop_j;
 	if (mhop_num == 3 && err_loop_index == 2) {
 		for (; i >= 0; i--) {
 			dma_free_coherent(dev, pbl_bt_sz, mr->pbl_bt_l1[i],
-- 
2.14.1
