From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 for-next 2/9] IB/hns: Add & initialize "node_guid" parameter for RDMA CM
Date: Tue, 13 Sep 2016 20:49:23 +0100
Message-ID: <20160913194930.273964-3-salil.mehta@huawei.com>
References: <20160913194930.273964-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160913194930.273964-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, xuwei5@hisilicon.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

According to the Infiniband spec, NodeGUID uniquely identifies a
node. This must be initialized to some unique value. This patch
adds the support to the HNS RoCE driver to fetch the NodeGUID
value from DT or ACPI and then use this value to initialize the
node_guid parameter of IB device. This value shall be used by
RDMA CM.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Reviewed-by: Wei Hu <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
PATCH V2: Addressed the comment by Leon Romanovsky
          * Link: https://lkml.org/lkml/2016/9/12/309
PATCH V1: Initial Patch
---
 drivers/infiniband/hw/hns/hns_roce_device.h | 1 +
 drivers/infiniband/hw/hns/hns_roce_main.c   | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index ea73580..e943b98 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -74,6 +74,7 @@
 #define MR_TYPE_DMA				0x03
 
 #define PKEY_ID					0xffff
+#define GUID_LEN				8
 #define NODE_DESC_SIZE				64
 
 #define SERV_TYPE_RC				0
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 39e69c3..f0700f4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -797,6 +797,15 @@ static int hns_roce_get_cfg(struct hns_roce_dev *hr_dev)
 	if (IS_ERR(hr_dev->reg_base))
 		return PTR_ERR(hr_dev->reg_base);
 
+	/* read the node_guid of IB device from the DT or ACPI */
+	ret = device_property_read_u8_array(dev, "node-guid",
+					    (u8 *)&hr_dev->ib_dev.node_guid,
+					    GUID_LEN);
+	if (ret) {
+		dev_err(dev, "couldn't get node_guid from DT or ACPI!\n");
+		return ret;
+	}
+
 	/* get the RoCE associated ethernet ports or netdevices */
 	for (i = 0; i < HNS_ROCE_MAX_PORTS; i++) {
 		if (dev_of_node(dev)) {
-- 
1.9.1
