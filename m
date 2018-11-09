From: Salil Mehta <salil.mehta@huawei.com>
Subject: [RFC PATCH 01/10] net: hns3: Add debugfs framework registration
Date: Fri, 9 Nov 2018 22:07:34 +0000
Message-ID: <20181109220743.10264-2-salil.mehta@huawei.com>
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

Add the debugfs framework to the driver and create a debugfs
command interface for each device.

example command:
"echo queue info > cmd" Query the packet forwarding queue information.

Signed-off-by: liuzhongzhu <liuzhongzhu@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/Makefile       |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 133 +++++++++++++++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  17 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   4 +
 5 files changed, 154 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c

diff --git a/drivers/net/ethernet/hisilicon/hns3/Makefile b/drivers/net/ethernet/hisilicon/hns3/Makefile
index 002534f..d01bf53 100644
--- a/drivers/net/ethernet/hisilicon/hns3/Makefile
+++ b/drivers/net/ethernet/hisilicon/hns3/Makefile
@@ -9,6 +9,6 @@ obj-$(CONFIG_HNS3) += hns3vf/
 obj-$(CONFIG_HNS3) += hnae3.o
 
 obj-$(CONFIG_HNS3_ENET) += hns3.o
-hns3-objs = hns3_enet.o hns3_ethtool.o
+hns3-objs = hns3_enet.o hns3_ethtool.o hns3_debugfs.o
 
 hns3-$(CONFIG_HNS3_DCB) += hns3_dcbnl.o
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 5b3b104..994aee1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -544,6 +544,7 @@ struct hnae3_handle {
 	u32 numa_node_mask;	/* for multi-chip support */
 
 	u8 netdev_flags;
+	struct dentry *hnae3_dbgfs;
 };
 
 #define hnae3_set_field(origin, mask, shift, val) \
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
new file mode 100644
index 0000000..954e204
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -0,0 +1,133 @@
+// SPDX-License-Identifier: GPL-2.0+
+// Copyright (c) 2018-2019 Hisilicon Limited.
+
+#include <linux/debugfs.h>
+#include <linux/device.h>
+
+#include "hnae3.h"
+#include "hns3_enet.h"
+
+#define HNS3_DBG_READ_LEN 256
+
+static struct dentry *hns3_dbgfs_root;
+
+static void hns3_dbg_help(struct hnae3_handle *h)
+{
+	dev_info(&h->pdev->dev, "available commands\n");
+	dev_info(&h->pdev->dev, "queue info [number]\n");
+	dev_info(&h->pdev->dev, "dump fd tcam\n");
+}
+
+static ssize_t hns3_dbg_cmd_read(struct file *filp, char __user *buffer,
+				 size_t count, loff_t *ppos)
+{
+	int uncopy_bytes;
+	char *buf;
+	int len;
+
+	if (*ppos != 0)
+		return 0;
+
+	if (count < HNS3_DBG_READ_LEN)
+		return -ENOSPC;
+
+	buf = kzalloc(HNS3_DBG_READ_LEN, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	len = snprintf(buf, HNS3_DBG_READ_LEN, "%s\n",
+		       "Please echo help to cmd to get help information");
+	uncopy_bytes = copy_to_user(buffer, buf, len);
+
+	kfree(buf);
+
+	if (uncopy_bytes)
+		return -EFAULT;
+
+	return (*ppos = len);
+}
+
+static ssize_t hns3_dbg_cmd_write(struct file *filp, const char __user *buffer,
+				  size_t count, loff_t *ppos)
+{
+	struct hnae3_handle *handle = filp->private_data;
+	char *cmd_buf, *cmd_buf_tmp;
+	int uncopied_bytes;
+	int ret = 0;
+
+	if (*ppos != 0)
+		return 0;
+
+	cmd_buf = kzalloc(count + 1, GFP_KERNEL);
+	if (!cmd_buf)
+		return count;
+
+	uncopied_bytes = copy_from_user(cmd_buf, buffer, count);
+	if (uncopied_bytes) {
+		kfree(cmd_buf);
+		return -EFAULT;
+	}
+
+	cmd_buf[count] = '\0';
+
+	cmd_buf_tmp = strchr(cmd_buf, '\n');
+	if (cmd_buf_tmp) {
+		*cmd_buf_tmp = '\0';
+		count = cmd_buf_tmp - cmd_buf + 1;
+	}
+
+	if (ret)
+		hns3_dbg_help(handle);
+
+	kfree(cmd_buf);
+	cmd_buf = NULL;
+
+	return count;
+}
+
+static const struct file_operations hns3_dbg_cmd_fops = {
+	.owner = THIS_MODULE,
+	.open  = simple_open,
+	.read  = hns3_dbg_cmd_read,
+	.write = hns3_dbg_cmd_write,
+};
+
+void hns3_dbg_init(struct hnae3_handle *handle)
+{
+	const char *name = pci_name(handle->pdev);
+	struct dentry *pfile;
+
+	handle->hnae3_dbgfs = debugfs_create_dir(name, hns3_dbgfs_root);
+	if (!handle->hnae3_dbgfs)
+		return;
+
+	pfile = debugfs_create_file("cmd", 0600, handle->hnae3_dbgfs, handle,
+				    &hns3_dbg_cmd_fops);
+	if (!pfile) {
+		debugfs_remove_recursive(handle->hnae3_dbgfs);
+		handle->hnae3_dbgfs = NULL;
+		dev_warn(&handle->pdev->dev, "create file for %s fail\n",
+			 name);
+	}
+}
+
+void hns3_dbg_uninit(struct hnae3_handle *handle)
+{
+	debugfs_remove_recursive(handle->hnae3_dbgfs);
+	handle->hnae3_dbgfs = NULL;
+}
+
+void hns3_dbg_register_debugfs(const char *debugfs_dir_name)
+{
+	hns3_dbgfs_root = debugfs_create_dir(debugfs_dir_name, NULL);
+	if (!hns3_dbgfs_root) {
+		pr_warn("Register debugfs for %s fail\n", debugfs_dir_name);
+		return;
+	}
+}
+
+void hns3_dbg_unregister_debugfs(void)
+{
+	debugfs_remove_recursive(hns3_dbgfs_root);
+	hns3_dbgfs_root = NULL;
+}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 183fd83..7183c3b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3418,6 +3418,8 @@ static int hns3_client_init(struct hnae3_handle *handle)
 
 	hns3_dcbnl_setup(handle);
 
+	hns3_dbg_init(handle);
+
 	/* MTU range: (ETH_MIN_MTU(kernel default) - 9706) */
 	netdev->max_mtu = HNS3_MAX_MTU - (ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN);
 
@@ -3472,6 +3474,8 @@ static void hns3_client_uninit(struct hnae3_handle *handle, bool reset)
 
 	hns3_put_ring_config(priv);
 
+	hns3_dbg_uninit(handle);
+
 	priv->ring_data = NULL;
 
 out_netdev_free:
@@ -4026,15 +4030,23 @@ static int __init hns3_init_module(void)
 
 	INIT_LIST_HEAD(&client.node);
 
+	hns3_dbg_register_debugfs(hns3_driver_name);
+
 	ret = hnae3_register_client(&client);
 	if (ret)
-		return ret;
+		goto err_reg_client;
 
 	ret = pci_register_driver(&hns3_driver);
 	if (ret)
-		hnae3_unregister_client(&client);
+		goto err_reg_driver;
 
 	return ret;
+
+err_reg_driver:
+	hnae3_unregister_client(&client);
+err_reg_client:
+	hns3_dbg_unregister_debugfs();
+	return ret;
 }
 module_init(hns3_init_module);
 
@@ -4046,6 +4058,7 @@ static void __exit hns3_exit_module(void)
 {
 	pci_unregister_driver(&hns3_driver);
 	hnae3_unregister_client(&client);
+	hns3_dbg_unregister_debugfs();
 }
 module_exit(hns3_exit_module);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index cfd6a71..bf520a2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -665,4 +665,8 @@ void hns3_dcbnl_setup(struct hnae3_handle *handle);
 static inline void hns3_dcbnl_setup(struct hnae3_handle *handle) {}
 #endif
 
+void hns3_dbg_init(struct hnae3_handle *handle);
+void hns3_dbg_uninit(struct hnae3_handle *handle);
+void hns3_dbg_register_debugfs(const char *debugfs_dir_name);
+void hns3_dbg_unregister_debugfs(void);
 #endif
-- 
2.7.4
