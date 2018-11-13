From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH net-next 1/5] net: hns3: Enable HW GRO for Rev B(=0x21) HNS3 hardware
Date: Tue, 13 Nov 2018 10:13:03 +0000
Message-ID: <20181113101307.6020-2-salil.mehta@huawei.com>
References: <20181113101307.6020-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181113101307.6020-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net
Cc: salil.mehta@huawei.com, yisen.zhuang@huawei.com, lipeng321@huawei.com, mehta.salil@opnsrc.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

HNS3 hardware Revision B(=0x21) supports Hardware GRO feature. This
patch enables this feature in the HNS3 PF/VF driver.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  4 ++
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  4 +-
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  7 ++++
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 36 ++++++++++++++++++
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.h       |  8 ++++
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 37 +++++++++++++++++++
 6 files changed, 95 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index f69d39f17bdd..21d934b7a2a3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -52,6 +52,7 @@
 #define HNAE3_UNIC_CLIENT_INITED_B		0x4
 #define HNAE3_ROCE_CLIENT_INITED_B		0x5
 #define HNAE3_DEV_SUPPORT_FD_B			0x6
+#define HNAE3_DEV_SUPPORT_GRO_B			0x7
 
 #define HNAE3_DEV_SUPPORT_ROCE_DCB_BITS (BIT(HNAE3_DEV_SUPPORT_DCB_B) |\
 		BIT(HNAE3_DEV_SUPPORT_ROCE_B))
@@ -65,6 +66,9 @@
 #define hnae3_dev_fd_supported(hdev) \
 	hnae3_get_bit((hdev)->ae_dev->flag, HNAE3_DEV_SUPPORT_FD_B)
 
+#define hnae3_dev_gro_supported(hdev) \
+	hnae3_get_bit((hdev)->ae_dev->flag, HNAE3_DEV_SUPPORT_GRO_B)
+
 #define ring_ptr_move_fw(ring, p) \
 	((ring)->p = ((ring)->p + 1) % (ring)->desc_num)
 #define ring_ptr_move_bw(ring, p) \
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 8d07ec668d5d..a510ddfd45a5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1714,8 +1714,10 @@ static void hns3_disable_sriov(struct pci_dev *pdev)
 static void hns3_get_dev_capability(struct pci_dev *pdev,
 				    struct hnae3_ae_dev *ae_dev)
 {
-	if (pdev->revision >= 0x21)
+	if (pdev->revision >= 0x21) {
 		hnae3_set_bit(ae_dev->flag, HNAE3_DEV_SUPPORT_FD_B, 1);
+		hnae3_set_bit(ae_dev->flag, HNAE3_DEV_SUPPORT_GRO_B, 1);
+	}
 }
 
 /* hns3_probe - Device initialization routine
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 872cd4bdd70d..aef044d08b11 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -152,6 +152,7 @@ enum hclge_opcode_type {
 
 	/* TSO command */
 	HCLGE_OPC_TSO_GENERIC_CONFIG	= 0x0C01,
+	HCLGE_OPC_GRO_GENERIC_CONFIG    = 0x0C10,
 
 	/* RSS commands */
 	HCLGE_OPC_RSS_GENERIC_CONFIG	= 0x0D01,
@@ -758,6 +759,12 @@ struct hclge_cfg_tso_status_cmd {
 	u8 rsv[20];
 };
 
+#define HCLGE_GRO_EN_B		0
+struct hclge_cfg_gro_status_cmd {
+	__le16 gro_en;
+	u8 rsv[22];
+};
+
 #define HCLGE_TSO_MSS_MIN	256
 #define HCLGE_TSO_MSS_MAX	9668
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 43bfc730a62d..d02712446d50 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -921,6 +921,28 @@ static int hclge_config_tso(struct hclge_dev *hdev, int tso_mss_min,
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
 }
 
+static int hclge_config_gro(struct hclge_dev *hdev, bool en)
+{
+	struct hclge_cfg_gro_status_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	if (!hnae3_dev_gro_supported(hdev))
+		return 0;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_GRO_GENERIC_CONFIG, false);
+	req = (struct hclge_cfg_gro_status_cmd *)desc.data;
+
+	req->gro_en = cpu_to_le16(en ? 1 : 0);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"GRO hardware config cmd failed, ret = %d\n", ret);
+
+	return ret;
+}
+
 static int hclge_alloc_tqps(struct hclge_dev *hdev)
 {
 	struct hclge_tqp *tqp;
@@ -7090,6 +7112,13 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 		goto err_mdiobus_unreg;
 	}
 
+	ret = hclge_config_gro(hdev, true);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Failed to enable GRO in hardware, ret =%d\n", ret);
+		goto err_mdiobus_unreg;
+	}
+
 	ret = hclge_init_vlan_config(hdev);
 	if (ret) {
 		dev_err(&pdev->dev, "VLAN init fail, ret =%d\n", ret);
@@ -7221,6 +7250,13 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
 		return ret;
 	}
 
+	ret = hclge_config_gro(hdev, true);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Failed to enable GRO in hardware, ret =%d\n", ret);
+		return ret;
+	}
+
 	ret = hclge_init_vlan_config(hdev);
 	if (ret) {
 		dev_err(&pdev->dev, "VLAN init fail, ret =%d\n", ret);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index 090541de0c7d..47030b42341f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -87,6 +87,8 @@ enum hclgevf_opcode_type {
 	HCLGEVF_OPC_QUERY_TX_STATUS	= 0x0B03,
 	HCLGEVF_OPC_QUERY_RX_STATUS	= 0x0B13,
 	HCLGEVF_OPC_CFG_COM_TQP_QUEUE	= 0x0B20,
+	/* GRO command */
+	HCLGEVF_OPC_GRO_GENERIC_CONFIG  = 0x0C10,
 	/* RSS cmd */
 	HCLGEVF_OPC_RSS_GENERIC_CONFIG	= 0x0D01,
 	HCLGEVF_OPC_RSS_INPUT_TUPLE     = 0x0D02,
@@ -149,6 +151,12 @@ struct hclgevf_query_res_cmd {
 	__le16 rsv[7];
 };
 
+#define HCLGEVF_GRO_EN_B               0
+struct hclgevf_cfg_gro_status_cmd {
+	__le16 gro_en;
+	u8 rsv[22];
+};
+
 #define HCLGEVF_RSS_DEFAULT_OUTPORT_B	4
 #define HCLGEVF_RSS_HASH_KEY_OFFSET_B	4
 #define HCLGEVF_RSS_HASH_KEY_NUM	16
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 6b4d1477055f..3f256414fbe4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1655,6 +1655,29 @@ static int hclgevf_init_roce_base_info(struct hclgevf_dev *hdev)
 	return 0;
 }
 
+static int hclgevf_config_gro(struct hclgevf_dev *hdev, bool en)
+{
+	struct hclgevf_cfg_gro_status_cmd *req;
+	struct hclgevf_desc desc;
+	int ret;
+
+	if (!hnae3_dev_gro_supported(hdev))
+		return 0;
+
+	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_GRO_GENERIC_CONFIG,
+				     false);
+	req = (struct hclgevf_cfg_gro_status_cmd *)desc.data;
+
+	req->gro_en = cpu_to_le16(en ? 1 : 0);
+
+	ret = hclgevf_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"VF GRO hardware config cmd failed, ret = %d.\n", ret);
+
+	return ret;
+}
+
 static int hclgevf_rss_init_hw(struct hclgevf_dev *hdev)
 {
 	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
@@ -2122,6 +2145,13 @@ static int hclgevf_reset_hdev(struct hclgevf_dev *hdev)
 		return ret;
 	}
 
+	ret = hclgevf_config_gro(hdev, true);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"failed to enable VF GRO in hardware, ret =%d\n", ret);
+		return ret;
+	}
+
 	ret = hclgevf_init_vlan_config(hdev);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
@@ -2199,6 +2229,13 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 		goto err_config;
 	}
 
+	ret = hclgevf_config_gro(hdev, true);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Failed to enable VF GRO in hardware, ret =%d\n", ret);
+		goto err_config;
+	}
+
 	/* Initialize RSS for this VF */
 	ret = hclgevf_rss_init_hw(hdev);
 	if (ret) {
-- 
2.17.1
