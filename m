From: Salil Mehta <salil.mehta@huawei.com>
Subject: [RFC PATCH 05/10] net: hns3: Add "tc config" info query function
Date: Fri, 9 Nov 2018 22:07:38 +0000
Message-ID: <20181109220743.10264-6-salil.mehta@huawei.com>
References: <20181109220743.10264-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181109220743.10264-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net
Cc: salil.mehta@huawei.com, andrew@lunn.ch, yuvalm@mellanox.com, leon@kernel.org, yisen.zhuang@huawei.com, lipeng321@huawei.com, mehta.salil@opnsrc.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linuxarm@huawei.com, liuzhongzhu <liuzhongzhu@huawei.com>
List-Id: linux-rdma@vger.kernel.org

From: liuzhongzhu <liuzhongzhu@huawei.com>

This patch prints tc config information.

debugfs command:
echo dump tc > cmd

Sample Output:
root@(none)# echo dump tc > cmd
hns3 0000:7d:00.0: weight_offset: 14
hns3 0000:7d:00.0: tc(0): no sp mode
hns3 0000:7d:00.0: tc(1): no sp mode
hns3 0000:7d:00.0: tc(2): no sp mode
hns3 0000:7d:00.0: tc(3): no sp mode
hns3 0000:7d:00.0: tc(4): no sp mode
hns3 0000:7d:00.0: tc(5): no sp mode
hns3 0000:7d:00.0: tc(6): no sp mode
hns3 0000:7d:00.0: tc(7): no sp mode
root@(none)#

Signed-off-by: liuzhongzhu <liuzhongzhu@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 40 ++++++++++++++++++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |  6 ++++
 4 files changed, 48 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 47afdcd..da009f8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -130,6 +130,7 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "queue info [number]\n");
 	dev_info(&h->pdev->dev, "dump fd tcam\n");
 	dev_info(&h->pdev->dev, "dump promisc [vf id]\n");
+	dev_info(&h->pdev->dev, "dump tc\n");
 }
 
 static ssize_t hns3_dbg_cmd_read(struct file *filp, char __user *buffer,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 872cd4b..cc0f214 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -126,6 +126,7 @@ enum hclge_opcode_type {
 	HCLGE_OPC_TM_PRI_SCH_MODE_CFG   = 0x0813,
 	HCLGE_OPC_TM_QS_SCH_MODE_CFG    = 0x0814,
 	HCLGE_OPC_TM_BP_TO_QSET_MAPPING = 0x0815,
+	HCLGE_OPC_ETS_TC_WEIGHT		= 0x0843,
 
 	/* Packet buffer allocate commands */
 	HCLGE_OPC_TX_BUFF_ALLOC		= 0x0901,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 0a12473..901dc41 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -5,6 +5,7 @@
 
 #include "hclge_cmd.h"
 #include "hclge_main.h"
+#include "hclge_tm.h"
 #include "hnae3.h"
 
 static void hclge_print(struct hclge_dev *hdev, bool flag, char *true_buf,
@@ -16,6 +17,18 @@ static void hclge_print(struct hclge_dev *hdev, bool flag, char *true_buf,
 		dev_info(&hdev->pdev->dev, "%s\n", false_buf);
 }
 
+static void hclge_title_idx_print(struct hclge_dev *hdev, bool flag, int index,
+				  char *title_buf, char *true_buf,
+				  char *false_buf)
+{
+	if (flag)
+		dev_info(&hdev->pdev->dev, "%s(%d): %s\n", title_buf, index,
+			 true_buf);
+	else
+		dev_info(&hdev->pdev->dev, "%s(%d): %s\n", title_buf, index,
+			 false_buf);
+}
+
 static void hclge_dbg_dump_promisc_cfg(struct hclge_dev *hdev, char *cmd_buf)
 {
 #define HCLGE_DBG_UC_MODE_B BIT(1)
@@ -58,6 +71,31 @@ static void hclge_dbg_dump_promisc_cfg(struct hclge_dev *hdev, char *cmd_buf)
 		    "bc: enable", "bc: disable");
 }
 
+static void hclge_dbg_dump_tc(struct hclge_dev *hdev)
+{
+	struct hclge_ets_tc_weight_cmd *ets_weight;
+	struct hclge_desc desc;
+	int i, ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_ETS_TC_WEIGHT, true);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev, "dump tc fail, status is %d.\n", ret);
+		return;
+	}
+
+	ets_weight = (struct hclge_ets_tc_weight_cmd *)desc.data;
+
+	dev_info(&hdev->pdev->dev, "dump tc\n");
+	dev_info(&hdev->pdev->dev, "weight_offset: %u\n",
+		 ets_weight->weight_offset);
+
+	for (i = 0; i < HNAE3_MAX_TC; i++)
+		hclge_title_idx_print(hdev, ets_weight->tc_weight[i], i,
+				      "tc", "no sp mode", "sp mode");
+}
+
 static void hclge_dbg_fd_tcam_read(struct hclge_dev *hdev, u8 stage,
 				   bool sel_x, u32 loc)
 {
@@ -121,6 +159,8 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, char *cmd_buf)
 		hclge_dbg_fd_tcam(hdev);
 	} else if (strncmp(cmd_buf, "dump promisc", 12) == 0) {
 		hclge_dbg_dump_promisc_cfg(hdev, cmd_buf);
+	} else if (strncmp(cmd_buf, "dump tc", 7) == 0) {
+		hclge_dbg_dump_tc(hdev);
 	} else {
 		dev_info(&hdev->pdev->dev, "unknown command\n");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index 25eef13..03474d5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -55,6 +55,12 @@ struct hclge_qs_weight_cmd {
 	u8 dwrr;
 };
 
+struct hclge_ets_tc_weight_cmd {
+	u8 tc_weight[HNAE3_MAX_TC];
+	u8 weight_offset;
+	u8 rsvd[15];
+};
+
 #define HCLGE_TM_SHAP_IR_B_MSK  GENMASK(7, 0)
 #define HCLGE_TM_SHAP_IR_B_LSH	0
 #define HCLGE_TM_SHAP_IR_U_MSK  GENMASK(11, 8)
-- 
2.7.4
