From: Salil Mehta <salil.mehta@huawei.com>
Subject: [RFC PATCH 10/10] net: hns3: Add "qos buffer" config info query function
Date: Fri, 9 Nov 2018 22:07:43 +0000
Message-ID: <20181109220743.10264-11-salil.mehta@huawei.com>
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

This patch prints qos buffer config information.

debugfs command:
echo dump qos buf cfg > cmd

Sample Command:
root@(none)# echo dump qos buf cfg > cmd
hns3 0000:7d:00.0: dump qos buf cfg
hns3 0000:7d:00.0: tx_packet_buf_tc_0: 0x1aa
hns3 0000:7d:00.0: tx_packet_buf_tc_1: 0x0
hns3 0000:7d:00.0: tx_packet_buf_tc_2: 0x0
hns3 0000:7d:00.0: tx_packet_buf_tc_3: 0x0
hns3 0000:7d:00.0: tx_packet_buf_tc_4: 0x0
hns3 0000:7d:00.0: tx_packet_buf_tc_5: 0x0
hns3 0000:7d:00.0: tx_packet_buf_tc_6: 0x0
hns3 0000:7d:00.0: tx_packet_buf_tc_7: 0x0
hns3 0000:7d:00.0:
hns3 0000:7d:00.0: rx_packet_buf_tc_0: 0x130
hns3 0000:7d:00.0: rx_packet_buf_tc_1: 0x0
hns3 0000:7d:00.0: rx_packet_buf_tc_2: 0x0
hns3 0000:7d:00.0: rx_packet_buf_tc_3: 0x0
hns3 0000:7d:00.0: rx_packet_buf_tc_4: 0x0
hns3 0000:7d:00.0: rx_packet_buf_tc_5: 0x0
hns3 0000:7d:00.0: rx_packet_buf_tc_6: 0x0
hns3 0000:7d:00.0: rx_packet_buf_tc_7: 0x0
hns3 0000:7d:00.0: rx_share_buf: 0x1e0e
root@(none)#

Signed-off-by: liuzhongzhu <liuzhongzhu@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 115 +++++++++++++++++++++
 2 files changed, 116 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 6c0d237..7c218cf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -135,6 +135,7 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "dump checksum\n");
 	dev_info(&h->pdev->dev, "dump qos pause cfg\n");
 	dev_info(&h->pdev->dev, "dump qos pri map\n");
+	dev_info(&h->pdev->dev, "dump qos buf cfg\n");
 }
 
 static ssize_t hns3_dbg_cmd_read(struct file *filp, char __user *buffer,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index b8921a8..a5f7741 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -392,6 +392,119 @@ static void hclge_dbg_dump_qos_pri_map(struct hclge_dev *hdev)
 	dev_info(&hdev->pdev->dev, "pri_7_to_tc: 0x%x\n", pri_map->pri7_tc);
 }
 
+static void hclge_dbg_dump_qos_buf_cfg(struct hclge_dev *hdev)
+{
+	struct hclge_tx_buff_alloc_cmd *tx_buf_cmd;
+	struct hclge_rx_priv_buff_cmd *rx_buf_cmd;
+	struct hclge_rx_priv_wl_buf *rx_priv_wl;
+	struct hclge_rx_com_wl *rx_packet_cnt;
+	struct hclge_rx_com_thrd *rx_com_thrd;
+	struct hclge_rx_com_wl *rx_com_wl;
+	enum hclge_opcode_type cmd;
+	struct hclge_desc desc[2];
+	int i, ret;
+
+	cmd = HCLGE_OPC_TX_BUFF_ALLOC;
+	hclge_cmd_setup_basic_desc(desc, cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, desc, 1);
+	if (ret)
+		goto err_qos_cmd_send;
+
+	dev_info(&hdev->pdev->dev, "dump qos buf cfg\n");
+
+	tx_buf_cmd = (struct hclge_tx_buff_alloc_cmd *)desc[0].data;
+	for (i = 0; i < HCLGE_TC_NUM; i++)
+		dev_info(&hdev->pdev->dev, "tx_packet_buf_tc_%d: 0x%x\n", i,
+			 tx_buf_cmd->tx_pkt_buff[i]);
+
+	cmd = HCLGE_OPC_RX_PRIV_BUFF_ALLOC;
+	hclge_cmd_setup_basic_desc(desc, cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, desc, 1);
+	if (ret)
+		goto err_qos_cmd_send;
+
+	dev_info(&hdev->pdev->dev, "\n");
+	rx_buf_cmd = (struct hclge_rx_priv_buff_cmd *)desc[0].data;
+	for (i = 0; i < HCLGE_TC_NUM; i++)
+		dev_info(&hdev->pdev->dev, "rx_packet_buf_tc_%d: 0x%x\n", i,
+			 rx_buf_cmd->buf_num[i]);
+
+	dev_info(&hdev->pdev->dev, "rx_share_buf: 0x%x\n",
+		 rx_buf_cmd->shared_buf);
+
+	cmd = HCLGE_OPC_RX_PRIV_WL_ALLOC;
+	hclge_cmd_setup_basic_desc(&desc[0], cmd, true);
+	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	hclge_cmd_setup_basic_desc(&desc[1], cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, desc, 2);
+	if (ret)
+		goto err_qos_cmd_send;
+
+	dev_info(&hdev->pdev->dev, "\n");
+	rx_priv_wl = (struct hclge_rx_priv_wl_buf *)desc[0].data;
+	for (i = 0; i < HCLGE_TC_NUM_ONE_DESC; i++)
+		dev_info(&hdev->pdev->dev,
+			 "rx_priv_wl_tc_%d: high: 0x%x, low: 0x%x\n", i,
+			 rx_priv_wl->tc_wl[i].high, rx_priv_wl->tc_wl[i].low);
+
+	rx_priv_wl = (struct hclge_rx_priv_wl_buf *)desc[1].data;
+	for (i = 0; i < HCLGE_TC_NUM_ONE_DESC; i++)
+		dev_info(&hdev->pdev->dev,
+			 "rx_priv_wl_tc_%d: high: 0x%x, low: 0x%x\n", i + 4,
+			 rx_priv_wl->tc_wl[i].high, rx_priv_wl->tc_wl[i].low);
+
+	cmd = HCLGE_OPC_RX_COM_THRD_ALLOC;
+	hclge_cmd_setup_basic_desc(&desc[0], cmd, true);
+	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	hclge_cmd_setup_basic_desc(&desc[1], cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, desc, 2);
+	if (ret)
+		goto err_qos_cmd_send;
+
+	dev_info(&hdev->pdev->dev, "\n");
+	rx_com_thrd = (struct hclge_rx_com_thrd *)desc[0].data;
+	for (i = 0; i < HCLGE_TC_NUM_ONE_DESC; i++)
+		dev_info(&hdev->pdev->dev,
+			 "rx_com_thrd_tc_%d: high: 0x%x, low: 0x%x\n", i,
+			 rx_com_thrd->com_thrd[i].high,
+			 rx_com_thrd->com_thrd[i].low);
+
+	rx_com_thrd = (struct hclge_rx_com_thrd *)desc[1].data;
+	for (i = 0; i < HCLGE_TC_NUM_ONE_DESC; i++)
+		dev_info(&hdev->pdev->dev,
+			 "rx_com_thrd_tc_%d: high: 0x%x, low: 0x%x\n", i + 4,
+			 rx_com_thrd->com_thrd[i].high,
+			 rx_com_thrd->com_thrd[i].low);
+
+	cmd = HCLGE_OPC_RX_COM_WL_ALLOC;
+	hclge_cmd_setup_basic_desc(desc, cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, desc, 1);
+	if (ret)
+		goto err_qos_cmd_send;
+
+	rx_com_wl = (struct hclge_rx_com_wl *)desc[0].data;
+	dev_info(&hdev->pdev->dev, "\n");
+	dev_info(&hdev->pdev->dev, "rx_com_wl: high: 0x%x, low: 0x%x\n",
+		 rx_com_wl->com_wl.high, rx_com_wl->com_wl.low);
+
+	cmd = HCLGE_OPC_RX_GBL_PKT_CNT;
+	hclge_cmd_setup_basic_desc(desc, cmd, true);
+	ret = hclge_cmd_send(&hdev->hw, desc, 1);
+	if (ret)
+		goto err_qos_cmd_send;
+
+	rx_packet_cnt = (struct hclge_rx_com_wl *)desc[0].data;
+	dev_info(&hdev->pdev->dev,
+		 "rx_global_packet_cnt: high: 0x%x, low: 0x%x\n",
+		 rx_packet_cnt->com_wl.high, rx_packet_cnt->com_wl.low);
+
+	return;
+
+err_qos_cmd_send:
+	dev_err(&hdev->pdev->dev,
+		"dump qos buf cfg fail(0x%x), status is %d\n", cmd, ret);
+}
+
 static void hclge_dbg_fd_tcam_read(struct hclge_dev *hdev, u8 stage,
 				   bool sel_x, u32 loc)
 {
@@ -465,6 +578,8 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, char *cmd_buf)
 		hclge_dbg_dump_qos_pause_cfg(hdev);
 	} else if (strncmp(cmd_buf, "dump qos pri map", 16) == 0) {
 		hclge_dbg_dump_qos_pri_map(hdev);
+	} else if (strncmp(cmd_buf, "dump qos buf cfg", 16) == 0) {
+		hclge_dbg_dump_qos_buf_cfg(hdev);
 	} else {
 		dev_info(&hdev->pdev->dev, "unknown command\n");
 		return -EINVAL;
-- 
2.7.4
