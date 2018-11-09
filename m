From: Salil Mehta <salil.mehta@huawei.com>
Subject: [RFC PATCH 06/10] net: hns3: Add "tm config" info query function
Date: Fri, 9 Nov 2018 22:07:39 +0000
Message-ID: <20181109220743.10264-7-salil.mehta@huawei.com>
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

This patch prints Transmit Module's Traffic sched
related config information.

debugfs command:
echo dump tm > cmd

Sample output:
root@(none)# echo dump tm > cmd
hns3 0000:7d:00.0: dump tm
hns3 0000:7d:00.0: PG_TO_PRI gp_id: 0
hns3 0000:7d:00.0: PG_TO_PRI map: 0x1
hns3 0000:7d:00.0: QS_TO_PRI qs_id: 0
hns3 0000:7d:00.0: QS_TO_PRI priority: 0
hns3 0000:7d:00.0: QS_TO_PRI link_vld: 1
hns3 0000:7d:00.0: NQ_TO_QS nq_id: 0
hns3 0000:7d:00.0: NQ_TO_QS qset_id: 1024
hns3 0000:7d:00.0: PG pg_id: 0
hns3 0000:7d:00.0: PG dwrr: 100
hns3 0000:7d:00.0: QS qs_id: 0
hns3 0000:7d:00.0: QS dwrr: 100
hns3 0000:7d:00.0: PRI pri_id: 0
hns3 0000:7d:00.0: PRI dwrr: 100
hns3 0000:7d:00.0: PRI_C pri_id: 0
hns3 0000:7d:00.0: PRI_C pri_shapping: 0x2850000
hns3 0000:7d:00.0: PRI_P pri_id: 0
hns3 0000:7d:00.0: PRI_P pri_shapping: 0x2850796
hns3 0000:7d:00.0: PG_C pg_id: 0
hns3 0000:7d:00.0: PG_C pg_shapping: 0x2850000
hns3 0000:7d:00.0: PG_P pg_id: 0
hns3 0000:7d:00.0: PG_P pg_shapping: 0x2850496
hns3 0000:7d:00.0: PORT port_shapping: 0x2850296
hns3 0000:7d:00.0: PG_SCH pg_id: 0
hns3 0000:7d:00.0: PRI_SCH pg_id: 0
hns3 0000:7d:00.0: QS_SCH pg_id: 0
hns3 0000:7d:00.0: BP_TO_QSET pg_id: 0
hns3 0000:7d:00.0: BP_TO_QSET pg_shapping: 0x0
hns3 0000:7d:00.0: BP_TO_QSET qs_bit_map: 0x0
root@(none)#

Signed-off-by: liuzhongzhu <liuzhongzhu@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 199 +++++++++++++++++++++
 2 files changed, 200 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index da009f8..4d7be38 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -131,6 +131,7 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "dump fd tcam\n");
 	dev_info(&h->pdev->dev, "dump promisc [vf id]\n");
 	dev_info(&h->pdev->dev, "dump tc\n");
+	dev_info(&h->pdev->dev, "dump tm\n");
 }
 
 static ssize_t hns3_dbg_cmd_read(struct file *filp, char __user *buffer,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 901dc41..4ada773 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -96,6 +96,203 @@ static void hclge_dbg_dump_tc(struct hclge_dev *hdev)
 				      "tc", "no sp mode", "sp mode");
 }
 
+static void hclge_dbg_dump_tm_pg(struct hclge_dev *hdev)
+{
+	struct hclge_port_shapping_cmd *port_shap_cfg_cmd;
+	struct hclge_bp_to_qs_map_cmd *bp_to_qs_map_cmd;
+	struct hclge_pg_shapping_cmd *pg_shap_cfg_cmd;
+	enum hclge_opcode_type cmd;
+	struct hclge_desc desc;
+	int ret;
+
+	pg_shap_cfg_cmd = (struct hclge_pg_shapping_cmd *)desc.data;
+	dev_info(&hdev->pdev->dev, "PG_C pg_id: %u\n", pg_shap_cfg_cmd->pg_id);
+	dev_info(&hdev->pdev->dev, "PG_C pg_shapping: 0x%x\n",
+		 pg_shap_cfg_cmd->pg_shapping_para);
+
+	cmd = HCLGE_OPC_TM_PG_P_SHAPPING;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_pg_cmd_send;
+
+	pg_shap_cfg_cmd = (struct hclge_pg_shapping_cmd *)desc.data;
+	dev_info(&hdev->pdev->dev, "PG_P pg_id: %u\n", pg_shap_cfg_cmd->pg_id);
+	dev_info(&hdev->pdev->dev, "PG_P pg_shapping: 0x%x\n",
+		 pg_shap_cfg_cmd->pg_shapping_para);
+
+	cmd = HCLGE_OPC_TM_PORT_SHAPPING;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_pg_cmd_send;
+
+	port_shap_cfg_cmd = (struct hclge_port_shapping_cmd *)desc.data;
+	dev_info(&hdev->pdev->dev, "PORT port_shapping: 0x%x\n",
+		 port_shap_cfg_cmd->port_shapping_para);
+
+	cmd = HCLGE_OPC_TM_PG_SCH_MODE_CFG;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_pg_cmd_send;
+
+	dev_info(&hdev->pdev->dev, "PG_SCH pg_id: %u\n", desc.data[0]);
+
+	cmd = HCLGE_OPC_TM_PRI_SCH_MODE_CFG;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_pg_cmd_send;
+
+	dev_info(&hdev->pdev->dev, "PRI_SCH pg_id: %u\n", desc.data[0]);
+
+	cmd = HCLGE_OPC_TM_QS_SCH_MODE_CFG;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_pg_cmd_send;
+
+	dev_info(&hdev->pdev->dev, "QS_SCH pg_id: %u\n", desc.data[0]);
+
+	cmd = HCLGE_OPC_TM_BP_TO_QSET_MAPPING;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_pg_cmd_send;
+
+	bp_to_qs_map_cmd = (struct hclge_bp_to_qs_map_cmd *)desc.data;
+	dev_info(&hdev->pdev->dev, "BP_TO_QSET pg_id: %u\n",
+		 bp_to_qs_map_cmd->tc_id);
+	dev_info(&hdev->pdev->dev, "BP_TO_QSET pg_shapping: 0x%x\n",
+		 bp_to_qs_map_cmd->qs_group_id);
+	dev_info(&hdev->pdev->dev, "BP_TO_QSET qs_bit_map: 0x%x\n",
+		 bp_to_qs_map_cmd->qs_bit_map);
+	return;
+
+err_tm_pg_cmd_send:
+	dev_err(&hdev->pdev->dev, "dump tm_pg fail(0x%x), status is %d\n",
+		cmd, ret);
+}
+
+static void hclge_dbg_dump_tm(struct hclge_dev *hdev)
+{
+	struct hclge_priority_weight_cmd *priority_weight;
+	struct hclge_pg_to_pri_link_cmd *pg_to_pri_map;
+	struct hclge_qs_to_pri_link_cmd *qs_to_pri_map;
+	struct hclge_nq_to_qs_link_cmd *nq_to_qs_map;
+	struct hclge_pri_shapping_cmd *shap_cfg_cmd;
+	struct hclge_pg_weight_cmd *pg_weight;
+	struct hclge_qs_weight_cmd *qs_weight;
+	enum hclge_opcode_type cmd;
+	struct hclge_desc desc;
+	int ret;
+
+	cmd = HCLGE_OPC_TM_PG_TO_PRI_LINK;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_cmd_send;
+
+	pg_to_pri_map = (struct hclge_pg_to_pri_link_cmd *)desc.data;
+	dev_info(&hdev->pdev->dev, "dump tm\n");
+	dev_info(&hdev->pdev->dev, "PG_TO_PRI gp_id: %u\n",
+		 pg_to_pri_map->pg_id);
+	dev_info(&hdev->pdev->dev, "PG_TO_PRI map: 0x%x\n",
+		 pg_to_pri_map->pri_bit_map);
+
+	cmd = HCLGE_OPC_TM_QS_TO_PRI_LINK;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_cmd_send;
+
+	qs_to_pri_map = (struct hclge_qs_to_pri_link_cmd *)desc.data;
+	dev_info(&hdev->pdev->dev, "QS_TO_PRI qs_id: %u\n",
+		 qs_to_pri_map->qs_id);
+	dev_info(&hdev->pdev->dev, "QS_TO_PRI priority: %u\n",
+		 qs_to_pri_map->priority);
+	dev_info(&hdev->pdev->dev, "QS_TO_PRI link_vld: %u\n",
+		 qs_to_pri_map->link_vld);
+
+	cmd = HCLGE_OPC_TM_NQ_TO_QS_LINK;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_cmd_send;
+
+	nq_to_qs_map = (struct hclge_nq_to_qs_link_cmd *)desc.data;
+	dev_info(&hdev->pdev->dev, "NQ_TO_QS nq_id: %u\n", nq_to_qs_map->nq_id);
+	dev_info(&hdev->pdev->dev, "NQ_TO_QS qset_id: %u\n",
+		 nq_to_qs_map->qset_id);
+
+	cmd = HCLGE_OPC_TM_PG_WEIGHT;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_cmd_send;
+
+	pg_weight = (struct hclge_pg_weight_cmd *)desc.data;
+	dev_info(&hdev->pdev->dev, "PG pg_id: %u\n", pg_weight->pg_id);
+	dev_info(&hdev->pdev->dev, "PG dwrr: %u\n", pg_weight->dwrr);
+
+	cmd = HCLGE_OPC_TM_QS_WEIGHT;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_cmd_send;
+
+	qs_weight = (struct hclge_qs_weight_cmd *)desc.data;
+	dev_info(&hdev->pdev->dev, "QS qs_id: %u\n", qs_weight->qs_id);
+	dev_info(&hdev->pdev->dev, "QS dwrr: %u\n", qs_weight->dwrr);
+
+	cmd = HCLGE_OPC_TM_PRI_WEIGHT;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_cmd_send;
+
+	priority_weight = (struct hclge_priority_weight_cmd *)desc.data;
+	dev_info(&hdev->pdev->dev, "PRI pri_id: %u\n", priority_weight->pri_id);
+	dev_info(&hdev->pdev->dev, "PRI dwrr: %u\n", priority_weight->dwrr);
+
+	cmd = HCLGE_OPC_TM_PRI_C_SHAPPING;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_cmd_send;
+
+	shap_cfg_cmd = (struct hclge_pri_shapping_cmd *)desc.data;
+	dev_info(&hdev->pdev->dev, "PRI_C pri_id: %u\n", shap_cfg_cmd->pri_id);
+	dev_info(&hdev->pdev->dev, "PRI_C pri_shapping: 0x%x\n",
+		 shap_cfg_cmd->pri_shapping_para);
+
+	cmd = HCLGE_OPC_TM_PRI_P_SHAPPING;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_cmd_send;
+
+	shap_cfg_cmd = (struct hclge_pri_shapping_cmd *)desc.data;
+	dev_info(&hdev->pdev->dev, "PRI_P pri_id: %u\n", shap_cfg_cmd->pri_id);
+	dev_info(&hdev->pdev->dev, "PRI_P pri_shapping: 0x%x\n",
+		 shap_cfg_cmd->pri_shapping_para);
+
+	cmd = HCLGE_OPC_TM_PG_C_SHAPPING;
+	hclge_cmd_setup_basic_desc(&desc, cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		goto err_tm_cmd_send;
+
+	hclge_dbg_dump_tm_pg(hdev);
+
+	return;
+
+err_tm_cmd_send:
+	dev_err(&hdev->pdev->dev, "dump tm fail(0x%x), status is %d\n",
+		cmd, ret);
+}
+
 static void hclge_dbg_fd_tcam_read(struct hclge_dev *hdev, u8 stage,
 				   bool sel_x, u32 loc)
 {
@@ -161,6 +358,8 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, char *cmd_buf)
 		hclge_dbg_dump_promisc_cfg(hdev, cmd_buf);
 	} else if (strncmp(cmd_buf, "dump tc", 7) == 0) {
 		hclge_dbg_dump_tc(hdev);
+	} else if (strncmp(cmd_buf, "dump tm", 7) == 0) {
+		hclge_dbg_dump_tm(hdev);
 	} else {
 		dev_info(&hdev->pdev->dev, "unknown command\n");
 		return -EINVAL;
-- 
2.7.4
