From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V3 for-next 2/9] IB/hns: Add & initialize "node_guid" parameter for RDMA CM
Date: Thu, 15 Sep 2016 23:48:07 +0100
Message-ID: <20160915224814.656184-3-salil.mehta@huawei.com>
References: <20160915224814.656184-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160915224814.656184-1-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
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


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
