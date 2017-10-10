From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] RDMA/hns: fix spelling mistake: "Reseved" -> "Reserved"
Date: Tue, 10 Oct 2017 16:14:51 +0100
Message-ID: <20171010151451.19001-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Lijun Ou <oulijun@huawei.com>, Wei Hu <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in dev_err error message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 852db18ec128..f664e3407fdb 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -1005,7 +1005,7 @@ static void hns_roce_v1_mr_free_work_fn(struct work_struct *work)
 	}
 
 	if (!ne) {
-		dev_err(dev, "Reseved loop qp is absent!\n");
+		dev_err(dev, "Reserved loop qp is absent!\n");
 		goto free_work;
 	}
 
-- 
2.14.1
