From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 net-next 3/5] net: hns3: Add support for ethtool -K to enable/disable HW GRO
Date: Thu, 15 Nov 2018 09:29:23 +0000
Message-ID: <20181115092925.11812-4-salil.mehta@huawei.com>
References: <20181115092925.11812-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181115092925.11812-1-salil.mehta@huawei.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: salil.mehta@huawei.com, yisen.zhuang@huawei.com, lipeng321@huawei.com, mehta.salil@opnsrc.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

This patch adds support of ethtool -K to enable/disable
hardware GRO in HNS3 PF/VF driver.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h         |  3 +++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c     | 13 ++++++++++++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |  9 +++++++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c   |  8 ++++++++
 4 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 21d934b7a2a3..1746172ffbf7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -305,6 +305,8 @@ struct hnae3_ae_dev {
  *   Set vlan filter config of vf
  * enable_hw_strip_rxvtag()
  *   Enable/disable hardware strip vlan tag of packets received
+ * set_gro_en
+ *   Enable/disable HW GRO
  */
 struct hnae3_ae_ops {
 	int (*init_ae_dev)(struct hnae3_ae_dev *ae_dev);
@@ -449,6 +451,7 @@ struct hnae3_ae_ops {
 	bool (*get_hw_reset_stat)(struct hnae3_handle *handle);
 	bool (*ae_dev_resetting)(struct hnae3_handle *handle);
 	unsigned long (*ae_dev_reset_cnt)(struct hnae3_handle *handle);
+	int (*set_gro_en)(struct hnae3_handle *handle, int enable);
 };
 
 struct hnae3_dcb_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index d8c5e1198670..860067898471 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1345,6 +1345,15 @@ static int hns3_nic_set_features(struct net_device *netdev,
 			priv->ops.maybe_stop_tx = hns3_nic_maybe_stop_tx;
 	}
 
+	if (changed & (NETIF_F_GRO_HW) && h->ae_algo->ops->set_gro_en) {
+		if (features & NETIF_F_GRO_HW)
+			ret = h->ae_algo->ops->set_gro_en(h, true);
+		else
+			ret = h->ae_algo->ops->set_gro_en(h, false);
+		if (ret)
+			return ret;
+	}
+
 	if ((changed & NETIF_F_HW_VLAN_CTAG_FILTER) &&
 	    h->ae_algo->ops->enable_vlan_filter) {
 		if (features & NETIF_F_HW_VLAN_CTAG_FILTER)
@@ -1929,7 +1938,9 @@ static void hns3_set_default_feature(struct net_device *netdev)
 		NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_SCTP_CRC;
 
 	if (pdev->revision >= 0x21) {
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER |
+			NETIF_F_GRO_HW;
+		netdev->features |= NETIF_F_GRO_HW;
 
 		if (!(h->flags & HNAE3_SUPPORT_VF)) {
 			netdev->hw_features |= NETIF_F_NTUPLE;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 3f8bd11d0824..eb6b6a5f744f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7667,6 +7667,14 @@ static void hclge_get_link_mode(struct hnae3_handle *handle,
 	}
 }
 
+static int hclge_gro_en(struct hnae3_handle *handle, int enable)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+
+	return hclge_config_gro(hdev, enable);
+}
+
 static const struct hnae3_ae_ops hclge_ops = {
 	.init_ae_dev = hclge_init_ae_dev,
 	.uninit_ae_dev = hclge_uninit_ae_dev,
@@ -7738,6 +7746,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.get_hw_reset_stat = hclge_get_hw_reset_stat,
 	.ae_dev_resetting = hclge_ae_dev_resetting,
 	.ae_dev_reset_cnt = hclge_ae_dev_reset_cnt,
+	.set_gro_en = hclge_gro_en,
 };
 
 static struct hnae3_ae_algo ae_algo = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 2e889b829976..e27d6fa85a74 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2368,6 +2368,13 @@ void hclgevf_update_speed_duplex(struct hclgevf_dev *hdev, u32 speed,
 	hdev->hw.mac.duplex = duplex;
 }
 
+static int hclgevf_gro_en(struct hnae3_handle *handle, int enable)
+{
+	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+
+	return hclgevf_config_gro(hdev, enable);
+}
+
 static void hclgevf_get_media_type(struct hnae3_handle *handle,
 				  u8 *media_type)
 {
@@ -2442,6 +2449,7 @@ static const struct hnae3_ae_ops hclgevf_ops = {
 	.get_hw_reset_stat = hclgevf_get_hw_reset_stat,
 	.ae_dev_resetting = hclgevf_ae_dev_resetting,
 	.ae_dev_reset_cnt = hclgevf_ae_dev_reset_cnt,
+	.set_gro_en = hclgevf_gro_en,
 };
 
 static struct hnae3_ae_algo ae_algovf = {
-- 
2.17.1
