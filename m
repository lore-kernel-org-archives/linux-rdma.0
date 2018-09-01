From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] infiniband: hw: hns: Fix a sleep-in-atomic-context bug in hns_roce_set_hem()
Date: Sat,  1 Sep 2018 19:39:48 +0800
Message-ID: <20180901113948.28967-1-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: oulijun@huawei.com, xavier.huwei@huawei.com, dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-rdma@vger.kernel.org

The driver may sleep with holding a spinlock.

The function call paths (from bottom to top) in Linux-4.16 are:

drivers/infiniband/hw/hns/hns_roce_hem.c, 345: 
	msleep in hns_roce_set_hem
drivers/infiniband/hw/hns/hns_roce_hem.c, 330: 
	_raw_spin_lock_irqsave in hns_roce_set_hem

To fix this bug, msleep() is replaced with mdelay().

This bug is found by my static analysis tool DSAC.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 63b5b3edabcb..8c142676c589 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -342,7 +342,7 @@ static int hns_roce_set_hem(struct hns_roce_dev *hr_dev,
 			} else {
 				break;
 			}
-			msleep(HW_SYNC_SLEEP_TIME_INTERVAL);
+			mdelay(HW_SYNC_SLEEP_TIME_INTERVAL);
 		}
 
 		bt_cmd_l = (u32)bt_ba;
-- 
2.17.0
