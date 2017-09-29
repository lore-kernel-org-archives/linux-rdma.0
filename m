From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH V2 for-next 7/8] RDMA/hns: Remove unnecessarily calling unregister_inetaddr_notifier function
Date: Fri, 29 Sep 2017 23:10:13 +0800
Message-ID: <1506697814-98432-8-git-send-email-xavier.huwei@huawei.com>
References: <1506697814-98432-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1506697814-98432-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, xavier.huwei@huawei.com, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, xushaobo2@huawei.com, zhangxiping3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, shaobohsu@163.com
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

When the driver doesn't call register_inetaddr_notifier function, it need
not call unregister_inetaddr_notifier to unregister inet addr. This patch
fixes it.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Shaobo Xu <xushaobo2@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_device.h | 1 -
 drivers/infiniband/hw/hns/hns_roce_main.c   | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 4d9d5d7..b314ac0 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -474,7 +474,6 @@ struct hns_roce_ib_iboe {
 	spinlock_t		lock;
 	struct net_device      *netdevs[HNS_ROCE_MAX_PORTS];
 	struct notifier_block	nb;
-	struct notifier_block	nb_inet;
 	u8			phy_port[HNS_ROCE_MAX_PORTS];
 };
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 6f2d572..3dcb2df 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -424,7 +424,6 @@ static void hns_roce_unregister_device(struct hns_roce_dev *hr_dev)
 {
 	struct hns_roce_ib_iboe *iboe = &hr_dev->iboe;
 
-	unregister_inetaddr_notifier(&iboe->nb_inet);
 	unregister_netdevice_notifier(&iboe->nb);
 	ib_unregister_device(&hr_dev->ib_dev);
 }
-- 
1.9.1
