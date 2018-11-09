From: Salil Mehta <salil.mehta@huawei.com>
Subject: [RFC PATCH 08/10] net: hns3: Add PFC config info query function
Date: Fri, 9 Nov 2018 22:07:41 +0000
Message-ID: <20181109220743.10264-9-salil.mehta@huawei.com>
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

This patch prints qos pause config information.

debugfs command:
echo dump qos pause cfg > cmd

Sample Command:
root@(none)# echo dump qos pause cfg > cmd
hns3 0000:7d:00.0: dump qos pause cfg
hns3 0000:7d:00.0: pause_trans_gap: 0xff
hns3 0000:7d:00.0: pause_trans_time: 0xffff
root@(none)#

Signed-off-by: liuzhongzhu <liuzhongzhu@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 25 ++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 27757be..8edb4e9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -133,6 +133,7 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "dump tc\n");
 	dev_info(&h->pdev->dev, "dump tm\n");
 	dev_info(&h->pdev->dev, "dump checksum\n");
+	dev_info(&h->pdev->dev, "dump qos pause cfg\n");
 }
 
 static ssize_t hns3_dbg_cmd_read(struct file *filp, char __user *buffer,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 4fa546f..a71e9d0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -341,6 +341,29 @@ static void hclge_dbg_dump_checksum(struct hclge_dev *hdev)
 			  "inner_sctp", "enable", "disable");
 }
 
+static void hclge_dbg_dump_qos_pause_cfg(struct hclge_dev *hdev)
+{
+	struct hclge_cfg_pause_param_cmd *pause_param;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CFG_MAC_PARA, true);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev, "dump checksum fail, status is %d.\n",
+			ret);
+		return;
+	}
+
+	pause_param = (struct hclge_cfg_pause_param_cmd *)desc.data;
+	dev_info(&hdev->pdev->dev, "dump qos pause cfg\n");
+	dev_info(&hdev->pdev->dev, "pause_trans_gap: 0x%x\n",
+		 pause_param->pause_trans_gap);
+	dev_info(&hdev->pdev->dev, "pause_trans_time: 0x%x\n",
+		 pause_param->pause_trans_time);
+}
+
 static void hclge_dbg_fd_tcam_read(struct hclge_dev *hdev, u8 stage,
 				   bool sel_x, u32 loc)
 {
@@ -410,6 +433,8 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, char *cmd_buf)
 		hclge_dbg_dump_tm(hdev);
 	} else if (strncmp(cmd_buf, "dump checksum", 13) == 0) {
 		hclge_dbg_dump_checksum(hdev);
+	} else if (strncmp(cmd_buf, "dump qos pause cfg", 18) == 0) {
+		hclge_dbg_dump_qos_pause_cfg(hdev);
 	} else {
 		dev_info(&hdev->pdev->dev, "unknown command\n");
 		return -EINVAL;
-- 
2.7.4
