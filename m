From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH for-next 10/20] IB/hns: Modify the init of iboe lock
Date: Fri, 9 Sep 2016 18:30:41 +0800
Message-ID: <1473417051-99560-11-git-send-email-salil.mehta@huawei.com>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, xuwei5@hisilicon.com, mehta.salil.lnk@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, "Dongdong Huang(Donald)" <hdd.huang@huawei.com>
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

This lock will be used in query port interface, and will be called
while IB device was registered to OFED frame. So, the lock of iboe
must be initiated before IB device was registered.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Dongdong Huang(Donald) <hdd.huang@huawei.com>
Reviewed-by:  Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 2704076..4721c0c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -615,6 +615,7 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 	struct device *dev = &hr_dev->pdev->dev;
 
 	iboe = &hr_dev->iboe;
+	spin_lock_init(&iboe->lock);
 
 	ib_dev = &hr_dev->ib_dev;
 	strlcpy(ib_dev->name, "hisi_%d", IB_DEVICE_NAME_MAX);
@@ -701,8 +702,6 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 		goto error_failed_setup_mtu_gids;
 	}
 
-	spin_lock_init(&iboe->lock);
-
 	iboe->nb.notifier_call = hns_roce_netdev_event;
 	ret = register_netdevice_notifier(&iboe->nb);
 	if (ret) {
-- 
1.7.9.5
