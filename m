From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH net-next 5/8] net: hns3: Unified HNS3 {VF|PF} Ethernet Driver for hip08 SoC
Date: Sun, 3 Dec 2017 12:33:04 +0000
Message-ID: <20171203123307.19820-6-salil.mehta@huawei.com>
References: <20171203123307.19820-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171203123307.19820-1-salil.mehta@huawei.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: salil.mehta@huawei.com, yisen.zhuang@huawei.com, lipeng321@huawei.com, mehta.salil.lnk@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

Most of the NAPI handling interface, skb buffer management,
management of the RX/TX descriptors, ethool interface etc.
has quite a bit of code which is common to VF and PF driver.

This patch makes the exisitng PF's HNS3 ENET driver as the
common ENET driver for both Virtual & Physical Function. This
will help in reduction of redundancy and better management of
code.

Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: lipeng <lipeng321@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/Makefile       |  6 +++++-
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        | 14 ++++++++++++--
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  7 ++++---
 .../hisilicon/hns3/{hns3pf => }/hns3_dcbnl.c       |  2 +-
 .../hisilicon/hns3/{hns3pf => }/hns3_enet.c        |  2 ++
 .../hisilicon/hns3/{hns3pf => }/hns3_enet.h        |  0
 .../hisilicon/hns3/{hns3pf => }/hns3_ethtool.c     | 22 +++++++++++++++++++++-
 .../net/ethernet/hisilicon/hns3/hns3pf/Makefile    |  5 -----
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  1 +
 9 files changed, 46 insertions(+), 13 deletions(-)
 rename drivers/net/ethernet/hisilicon/hns3/{hns3pf => }/hns3_dcbnl.c (97%)
 rename drivers/net/ethernet/hisilicon/hns3/{hns3pf => }/hns3_enet.c (99%)
 rename drivers/net/ethernet/hisilicon/hns3/{hns3pf => }/hns3_enet.h (100%)
 rename drivers/net/ethernet/hisilicon/hns3/{hns3pf => }/hns3_ethtool.c (97%)

diff --git a/drivers/net/ethernet/hisilicon/hns3/Makefile b/drivers/net/ethernet/hisilicon/hns3/Makefile
index 244664b5f24f..48af9b1717f3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/Makefile
+++ b/drivers/net/ethernet/hisilicon/hns3/Makefile
@@ -1,8 +1,12 @@
 #
 # Makefile for the HISILICON network device drivers.
 #
-
 obj-$(CONFIG_HNS3) += hns3pf/
 obj-$(CONFIG_HNS3) += hns3vf/
 
 obj-$(CONFIG_HNS3) += hnae3.o
+
+obj-$(CONFIG_HNS3_ENET) += hns3.o
+hns3-objs = hns3_enet.o hns3_ethtool.o
+
+hns3-$(CONFIG_HNS3_DCB) += hns3_dcbnl.o
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.c b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
index 5bcb2238acb2..02145f2de820 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
@@ -196,9 +196,18 @@ int hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev)
 	const struct pci_device_id *id;
 	struct hnae3_ae_algo *ae_algo;
 	struct hnae3_client *client;
-	int ret = 0;
+	int ret = 0, lock_acquired;
+
+	/* we can get deadlocked if SRIOV is being enabled in context to probe
+	 * and probe gets called again in same context. This can happen when
+	 * pci_enable_sriov() is called to create VFs from PF probes context.
+	 * Therefore, for simplicity uniformly defering further probing in all
+	 * cases where we detect contention.
+	 */
+	lock_acquired = mutex_trylock(&hnae3_common_lock);
+	if (!lock_acquired)
+		return -EPROBE_DEFER;
 
-	mutex_lock(&hnae3_common_lock);
 	list_add_tail(&ae_dev->node, &hnae3_ae_dev_list);
 
 	/* Check if there are matched ae_algo */
@@ -211,6 +220,7 @@ int hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 		if (!ae_dev->ops) {
 			dev_err(&ae_dev->pdev->dev, "ae_dev ops are null\n");
+			ret = -EOPNOTSUPP;
 			goto out_err;
 		}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 67c59e1039f2..a9e2b32834c5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -452,9 +452,10 @@ struct hnae3_unic_private_info {
 	struct hnae3_queue **tqp;  /* array base of all TQPs of this instance */
 };
 
-#define HNAE3_SUPPORT_MAC_LOOPBACK    1
-#define HNAE3_SUPPORT_PHY_LOOPBACK    2
-#define HNAE3_SUPPORT_SERDES_LOOPBACK 4
+#define HNAE3_SUPPORT_MAC_LOOPBACK    BIT(0)
+#define HNAE3_SUPPORT_PHY_LOOPBACK    BIT(1)
+#define HNAE3_SUPPORT_SERDES_LOOPBACK BIT(2)
+#define HNAE3_SUPPORT_VF	      BIT(3)
 
 struct hnae3_handle {
 	struct hnae3_client *client;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_dcbnl.c b/drivers/net/ethernet/hisilicon/hns3/hns3_dcbnl.c
similarity index 97%
rename from drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_dcbnl.c
rename to drivers/net/ethernet/hisilicon/hns3/hns3_dcbnl.c
index 925619a7c50a..eb82700da7d0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_dcbnl.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_dcbnl.c
@@ -93,7 +93,7 @@ void hns3_dcbnl_setup(struct hnae3_handle *handle)
 {
 	struct net_device *dev = handle->kinfo.netdev;
 
-	if (!handle->kinfo.dcb_ops)
+	if ((!handle->kinfo.dcb_ops) || (handle->flags & HNAE3_SUPPORT_VF))
 		return;
 
 	dev->dcbnl_ops = &hns3_dcbnl_ops;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
similarity index 99%
rename from drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_enet.c
rename to drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 59415090ff0f..c2c13238db52 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -52,6 +52,8 @@ static const struct pci_device_id hns3_pci_tbl[] = {
 	 HNAE3_DEV_SUPPORT_ROCE_DCB_BITS},
 	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_100G_RDMA_MACSEC),
 	 HNAE3_DEV_SUPPORT_ROCE_DCB_BITS},
+	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_100G_VF), 0},
+	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_100G_RDMA_DCB_PFC_VF), 0},
 	/* required last entry */
 	{0, }
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
similarity index 100%
rename from drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_enet.h
rename to drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
similarity index 97%
rename from drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_ethtool.c
rename to drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index a21470c72da3..65a69b439457 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -849,6 +849,21 @@ static int hns3_nway_reset(struct net_device *netdev)
 	return genphy_restart_aneg(phy);
 }
 
+static const struct ethtool_ops hns3vf_ethtool_ops = {
+	.get_drvinfo = hns3_get_drvinfo,
+	.get_ringparam = hns3_get_ringparam,
+	.set_ringparam = hns3_set_ringparam,
+	.get_strings = hns3_get_strings,
+	.get_ethtool_stats = hns3_get_stats,
+	.get_sset_count = hns3_get_sset_count,
+	.get_rxnfc = hns3_get_rxnfc,
+	.get_rxfh_key_size = hns3_get_rss_key_size,
+	.get_rxfh_indir_size = hns3_get_rss_indir_size,
+	.get_rxfh = hns3_get_rss,
+	.set_rxfh = hns3_set_rss,
+	.get_link_ksettings = hns3_get_link_ksettings,
+};
+
 static const struct ethtool_ops hns3_ethtool_ops = {
 	.self_test = hns3_self_test,
 	.get_drvinfo = hns3_get_drvinfo,
@@ -872,5 +887,10 @@ static const struct ethtool_ops hns3_ethtool_ops = {
 
 void hns3_ethtool_set_ops(struct net_device *netdev)
 {
-	netdev->ethtool_ops = &hns3_ethtool_ops;
+	struct hnae3_handle *h = hns3_get_handle(netdev);
+
+	if (h->flags & HNAE3_SUPPORT_VF)
+		netdev->ethtool_ops = &hns3vf_ethtool_ops;
+	else
+		netdev->ethtool_ops = &hns3_ethtool_ops;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile b/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
index d2b20d01a58c..d077fa02b66e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
@@ -8,8 +8,3 @@ obj-$(CONFIG_HNS3_HCLGE) += hclge.o
 hclge-objs = hclge_main.o hclge_cmd.o hclge_mdio.o hclge_tm.o
 
 hclge-$(CONFIG_HNS3_DCB) += hclge_dcb.o
-
-obj-$(CONFIG_HNS3_ENET) += hns3.o
-hns3-objs = hns3_enet.o hns3_ethtool.o
-
-hns3-$(CONFIG_HNS3_DCB) += hns3_dcbnl.o
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index dd721a0dae3c..1f88ae21f495 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -314,6 +314,7 @@ static int hclgevf_set_handle_info(struct hclgevf_dev *hdev)
 	nic->ae_algo = &ae_algovf;
 	nic->pdev = hdev->pdev;
 	nic->numa_node_mask = hdev->numa_node_mask;
+	nic->flags |= HNAE3_SUPPORT_VF;
 
 	if (hdev->ae_dev->dev_type != HNAE3_DEV_KNIC) {
 		dev_err(&hdev->pdev->dev, "unsupported device type %d\n",
-- 
2.11.0
