From: Salil Mehta <salil.mehta@huawei.com>
Subject: [RFC PATCH 03/10] net: hns3: Add "FD flow table" info query function
Date: Fri, 9 Nov 2018 22:07:36 +0000
Message-ID: <20181109220743.10264-4-salil.mehta@huawei.com>
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

All the Flow Director rules are stored in tcam blocks.
For each bit of tcam entry, the match value
depends on two input value(x, y).

debugfs command:
echo dump fd tcam > cmd

Sample output:
root@(none)# echo dump fd tcam > cmd
hns3 0000:7d:00.0: read result tcam key x(31):
hns3 0000:7d:00.0: 00000000
hns3 0000:7d:00.0: 00000000
hns3 0000:7d:00.0: 00000000
hns3 0000:7d:00.0: 08000000
hns3 0000:7d:00.0: 00000600
hns3 0000:7d:00.0: 00000000
hns3 0000:7d:00.0: 00000000
hns3 0000:7d:00.0: 00000000
hns3 0000:7d:00.0: 00000000
hns3 0000:7d:00.0: 00000000
hns3 0000:7d:00.0: 00000000
hns3 0000:7d:00.0: 00000000
hns3 0000:7d:00.0: 00000000
hns3 0000:7d:00.0: read result tcam key y(31):
hns3 0000:7d:00.0: 00000000
hns3 0000:7d:00.0: 00000000
hns3 0000:7d:00.0: 00000000
hns3 0000:7d:00.0: f7ff0000
hns3 0000:7d:00.0: 0000f900
hns3 0000:7d:00.0: 00000000
hns3 0000:7d:00.0: 00000000
hns3 0000:7d:00.0: 00000000
hns3 0000:7d:00.0: 00000000
hns3 0000:7d:00.0: 00000000
hns3 0000:7d:00.0: 00000000
hns3 0000:7d:00.0: 00000000
hns3 0000:7d:00.0: 0000fff8
root@(none)#

Signed-off-by: liuzhongzhu <liuzhongzhu@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/Makefile    |  2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 77 ++++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  1 +
 6 files changed, 83 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 994aee1..e7a6361 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -432,6 +432,7 @@ struct hnae3_ae_ops {
 				struct ethtool_rxnfc *cmd, u32 *rule_locs);
 	int (*restore_fd_rules)(struct hnae3_handle *handle);
 	void (*enable_fd)(struct hnae3_handle *handle, bool enable);
+	int (*dbg_run_cmd)(struct hnae3_handle *handle, char *cmd_buf);
 	pci_ers_result_t (*process_hw_error)(struct hnae3_ae_dev *ae_dev);
 	bool (*get_hw_reset_stat)(struct hnae3_handle *handle);
 	bool (*ae_dev_resetting)(struct hnae3_handle *handle);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index ac6a072..0bc2f59 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -197,6 +197,8 @@ static ssize_t hns3_dbg_cmd_write(struct file *filp, const char __user *buffer,
 
 	if (strncmp(cmd_buf, "queue info", 10) == 0)
 		ret = hns3_dbg_queue_info(handle, cmd_buf);
+	else if (handle->ae_algo->ops->dbg_run_cmd)
+		ret = handle->ae_algo->ops->dbg_run_cmd(handle, cmd_buf);
 
 	if (ret)
 		hns3_dbg_help(handle);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile b/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
index 580e817..fffe8c1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
@@ -6,6 +6,6 @@
 ccflags-y := -Idrivers/net/ethernet/hisilicon/hns3
 
 obj-$(CONFIG_HNS3_HCLGE) += hclge.o
-hclge-objs = hclge_main.o hclge_cmd.o hclge_mdio.o hclge_tm.o hclge_mbx.o hclge_err.o
+hclge-objs = hclge_main.o hclge_cmd.o hclge_mdio.o hclge_tm.o hclge_mbx.o hclge_err.o  hclge_debugfs.o
 
 hclge-$(CONFIG_HNS3_DCB) += hclge_dcb.o
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
new file mode 100644
index 0000000..feaf332
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0+
+// Copyright (c) 2018-2019 Hisilicon Limited.
+
+#include <linux/device.h>
+
+#include "hclge_cmd.h"
+#include "hclge_main.h"
+#include "hnae3.h"
+
+static void hclge_dbg_fd_tcam_read(struct hclge_dev *hdev, u8 stage,
+				   bool sel_x, u32 loc)
+{
+	struct hclge_fd_tcam_config_1_cmd *req1;
+	struct hclge_fd_tcam_config_2_cmd *req2;
+	struct hclge_fd_tcam_config_3_cmd *req3;
+	struct hclge_desc desc[3];
+	int ret, i;
+	u32 *req;
+
+	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_FD_TCAM_OP, true);
+	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_OPC_FD_TCAM_OP, true);
+	desc[1].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	hclge_cmd_setup_basic_desc(&desc[2], HCLGE_OPC_FD_TCAM_OP, true);
+
+	req1 = (struct hclge_fd_tcam_config_1_cmd *)desc[0].data;
+	req2 = (struct hclge_fd_tcam_config_2_cmd *)desc[1].data;
+	req3 = (struct hclge_fd_tcam_config_3_cmd *)desc[2].data;
+
+	req1->stage  = stage;
+	req1->xy_sel = sel_x ? 1 : 0;
+	req1->index  = cpu_to_le32(loc);
+
+	ret = hclge_cmd_send(&hdev->hw, desc, 3);
+	if (ret)
+		return;
+
+	dev_info(&hdev->pdev->dev, " read result tcam key %s(%u):\n",
+		 sel_x ? "x" : "y", loc);
+
+	req = (u32 *)req1->tcam_data;
+	for (i = 0; i < 2; i++)
+		dev_info(&hdev->pdev->dev, "%08x\n", *req++);
+
+	req = (u32 *)req2->tcam_data;
+	for (i = 0; i < 6; i++)
+		dev_info(&hdev->pdev->dev, "%08x\n", *req++);
+
+	req = (u32 *)req3->tcam_data;
+	for (i = 0; i < 5; i++)
+		dev_info(&hdev->pdev->dev, "%08x\n", *req++);
+}
+
+static void hclge_dbg_fd_tcam(struct hclge_dev *hdev)
+{
+	u32 i;
+
+	for (i = 0; i < hdev->fd_cfg.rule_num[0]; i++) {
+		hclge_dbg_fd_tcam_read(hdev, 0, true, i);
+		hclge_dbg_fd_tcam_read(hdev, 0, false, i);
+	}
+}
+
+int hclge_dbg_run_cmd(struct hnae3_handle *handle, char *cmd_buf)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+
+	if (strncmp(cmd_buf, "dump fd tcam", 12) == 0) {
+		hclge_dbg_fd_tcam(hdev);
+	} else {
+		dev_info(&hdev->pdev->dev, "unknown command\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 77980e5..13cebcd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7535,6 +7535,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.get_fd_all_rules = hclge_get_all_rules,
 	.restore_fd_rules = hclge_restore_fd_entries,
 	.enable_fd = hclge_enable_fd,
+	.dbg_run_cmd = hclge_dbg_run_cmd,
 	.process_hw_error = hclge_process_ras_hw_error,
 	.get_hw_reset_stat = hclge_get_hw_reset_stat,
 	.ae_dev_resetting = hclge_ae_dev_resetting,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 36f3413..5008d8a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -789,4 +789,5 @@ int hclge_reset_tqp(struct hnae3_handle *handle, u16 queue_id);
 void hclge_reset_vf_queue(struct hclge_vport *vport, u16 queue_id);
 int hclge_cfg_flowctrl(struct hclge_dev *hdev);
 int hclge_func_reset_cmd(struct hclge_dev *hdev, int func_id);
+int hclge_dbg_run_cmd(struct hnae3_handle *handle, char *cmd_buf);
 #endif
-- 
2.7.4
