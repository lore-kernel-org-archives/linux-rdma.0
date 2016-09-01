From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 03/10] IB/hns: Add & initialize "node_guid" parameter for RDMA CM
Date: Fri, 2 Sep 2016 05:37:18 +0800
Message-ID: <1472765845-118972-4-git-send-email-salil.mehta@huawei.com>
References: <1472765845-118972-1-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472765845-118972-1-git-send-email-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

According to the Infiniband spec, NodeGUID uniquely identifies a
node. This must be initialized to some unique value. This patch
adds the support to the HNS RoCE driver to fetch the NodeGUID
value from DT or ACPI and then use this value to initialize the
node_guid parameter of IB device. This value shall be used by
RDMA CM.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |    1 +
 drivers/infiniband/hw/hns/hns_roce_main.c   |    7 +++++++
 2 files changed, 8 insertions(+)

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
index 4e93120..ec27f0c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -812,6 +812,13 @@ static int hns_roce_get_cfg(struct hns_roce_dev *hr_dev)
 	if (IS_ERR(hr_dev->reg_base))
 		return PTR_ERR(hr_dev->reg_base);
 
+	/* read the node_guid of IB device from the DT or ACPI */
+	ret = device_property_read_u8_array(dev, "node-guid",
+					    (u8 *)&hr_dev->ib_dev.node_guid,
+					    GUID_LEN);
+	if (ret)
+		dev_err(dev, "couldn't get node_guid from DT or ACPI!\n");
+
 	/* get the RoCE associated ethernet ports or netdevices */
 	for (i = 0; i < HNS_ROCE_MAX_PORTS; i++) {
 		if (dev_of_node(dev)) {
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
