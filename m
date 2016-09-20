From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 for-next 09/19] IB/hns: Modify the init of iboe lock
Date: Tue, 20 Sep 2016 17:07:02 +0100
Message-ID: <20160920160712.1190216-10-salil.mehta@huawei.com>
References: <20160920160712.1190216-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160920160712.1190216-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, xuwei5@hisilicon.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, Dongdong Huang <hdd.huang@huawei.com>
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

This lock will be used in query port interface, and will be called
while IB device was registered to OFED framework/IB Core. So, the
lock of iboe must be initiated before IB device was registered.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Dongdong Huang(Donald) <hdd.huang@huawei.com>
Reviewed-by:  Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
PATCH V2: Addressed Leon Romanovsky's comments
          Link: https://lkml.org/lkml/2016/9/13/51
PATCH V1: Initial patch
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 4b44998..764e35a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -602,6 +602,7 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 	struct device *dev = &hr_dev->pdev->dev;
 
 	iboe = &hr_dev->iboe;
+	spin_lock_init(&iboe->lock);
 
 	ib_dev = &hr_dev->ib_dev;
 	strlcpy(ib_dev->name, "hisi_%d", IB_DEVICE_NAME_MAX);
@@ -686,8 +687,6 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 		goto error_failed_setup_mtu_gids;
 	}
 
-	spin_lock_init(&iboe->lock);
-
 	iboe->nb.notifier_call = hns_roce_netdev_event;
 	ret = register_netdevice_notifier(&iboe->nb);
 	if (ret) {
-- 
1.9.1
