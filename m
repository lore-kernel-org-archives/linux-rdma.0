From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 6/6] RDMA/hns: Set the guid for hip08 RoCE device
Date: Thu, 4 Jan 2018 12:19:23 +0800
Message-ID: <1515039563-73084-7-git-send-email-oulijun@huawei.com>
References: <1515039563-73084-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515039563-73084-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch assgin a guid(Global Unique identifer)
value to the hip08 device.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 6b4474d..6a6f355 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4658,6 +4658,22 @@ static void hns_roce_v2_cleanup_eq_table(struct hns_roce_dev *hr_dev)
 	{0, }
 };
 
+static void hns_roce_get_guid(u8 *dev_addr, u8 *guid)
+{
+	u8 mac[ETH_ALEN];
+
+	/* MAC-48 to EUI-64 mapping */
+	memcpy(mac, dev_addr, ETH_ALEN);
+	guid[0] = mac[0] ^ 2;
+	guid[1] = mac[1];
+	guid[2] = mac[2];
+	guid[3] = 0xff;
+	guid[4] = 0xfe;
+	guid[5] = mac[3];
+	guid[6] = mac[4];
+	guid[7] = mac[5];
+}
+
 static int hns_roce_hw_v2_get_cfg(struct hns_roce_dev *hr_dev,
 				  struct hnae3_handle *handle)
 {
@@ -4680,6 +4696,9 @@ static int hns_roce_hw_v2_get_cfg(struct hns_roce_dev *hr_dev,
 	hr_dev->iboe.netdevs[0] = handle->rinfo.netdev;
 	hr_dev->iboe.phy_port[0] = 0;
 
+	hns_roce_get_guid(hr_dev->iboe.netdevs[0]->dev_addr,
+			  (u8 *)&hr_dev->ib_dev.node_guid);
+
 	for (i = 0; i < HNS_ROCE_V2_MAX_IRQ_NUM; i++)
 		hr_dev->irq[i] = pci_irq_vector(handle->pdev,
 						i + handle->rinfo.base_vector);
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
