Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792826762;
	b=zldfYzGDh9Q1fAzzTkw1mbJLcWU5WYirRn18kGByrhYcbntsshGc6WvgAQRVpX+fE+HZ
	 MAsHI22irLViHYTkuK28248d7EhDFW56TZF67B9XJ/I11JTfu4PqmNU/dxCDrSH09R7lr
	 jR3dKb2rluQq4CqD7gQt/m0HcmdwMzxA7/zTEdtTleeILLVxEqnjAYWYG1LbA6uh1rNRo
	 h7WYuacqr7ytgmPO/QmHcwE5GBRLWd0nO39x/4jeg5NY9W0T70YMLQoJdSZQdtzHhkHT6
	 R7zlKUSMK/udYmc7ELVN5MMy4fCy58LUhwgddQIr179IPoEvG56vzVGPjIDc21XxZOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792826762;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:
	 X-Zmail-LocalSMTP:X-Zmail-RealSender:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-ZMAIL-USEORIGINALEMLTOOUTBOUND:Content-Transfer-Encoding:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=8OX2L3KNr6+/ZONd4VIawy1koiNom/7rML5csNyPw8Q=;
	b=0HPVgVQ0tTWSd+TBn8G/dLdF/XRlQM3UspvBqyFllwv0NVqkjS71fXIZhaza8M2R0YFx
	 UOKIvy77OIEs5u/vY22Z4xjkjvJLk9nSntqca5LZH1ajdu0HTW3MtaiU/Gotmj78Vxn3t
	 TMub49OfXGNBJXmTDFob8WGV9AYqPcpxRPW+uWRKyWtJfXLaUnN8zS1ljWNLA1Mb0FRbP
	 tdLbrWwwx/dhpMsweWuS6NtZYgyWMDzbSKXRRJGVal5kzpY0J30UBUNEBsXBCnL8EbNIg
	 vUe+HDmQWMeZm34Vnirx9ET4QyEgR0/IhDEDkwnfKy7rJsj3IjYMZXmKQSGjf7kOIKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6FF606A31D;
	Sat, 24 Oct 2026 07:26:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A6FF606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jBWdY19dqz5B109;
	Sat, 24 Oct 2026 15:25:53 +0800 (CST)
Received: from szxl2zmapp07.zte.com.cn ([10.1.32.52])
	by mse-fl2.zte.com.cn with SMTP id 69O7PkIS094826;
	Sat, 24 Oct 2026 15:25:46 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Sat, 24 Oct 2026 15:25:48 +0800
X-Zmail-TransId: 3e816adc5d7b026-b7ba1
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev, lkp@intel.com
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        wei.quan@zte.com.cn, han.junyang@zte.com.cn, ran.ming@zte.com.cn,
        han.chengfei@zte.com.cn, zhang.yanze@zte.com.cn
Subject: [PATCH 5/7] RDMA/zrdma: Add device probe and remove logic
Date: Sat, 24 Oct 2026 15:15:37 +0800
Message-ID: <20261024071539.2182864-6-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261024071539.2182864-1-zhang.yanze@zte.com.cn>
References: <20261024071539.2182864-1-zhang.yanze@zte.com.cn>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ZMAIL-USEORIGINALEMLTOOUTBOUND: 1
Content-Transfer-Encoding: 8bit
X-MAIL:mse-fl2.zte.com.cn 69O7PkIS094826
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Sat, 24 Oct 2026 15:25:53 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6ADC5D81.000/4jBWdY19dqz5B109

Implement the auxiliary bus probe and remove functions, including device
initialization, hardware resource setup, and IB device registration.
This replaces the stub probe from the initial skeleton patch.

Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>
---
 drivers/infiniband/hw/zrdma/zrdma_main.c | 294 +++++++++++++++++++++++
 1 file changed, 294 insertions(+)
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_main.c

diff --git a/drivers/infiniband/hw/zrdma/zrdma_main.c b/drivers/infiniband/hw/zrdma/zrdma_main.c
new file mode 100644
index 000000000000..5127e56fd164
--- /dev/null
+++ b/drivers/infiniband/hw/zrdma/zrdma_main.c
@@ -0,0 +1,294 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * ZTE DingHai Rdma driver
+ * Copyright (c) 2022-2026, ZTE Corporation
+ */
+
+#include <linux/module.h>
+#include <linux/auxiliary_bus.h>
+#include <linux/types.h>
+#include <linux/netdevice.h>
+#include <linux/workqueue.h>
+#include <rdma/ib_verbs.h>
+
+#include "zrdma_main.h"
+
+MODULE_ALIAS("zrdma");
+MODULE_AUTHOR("Yanze Zhang <zhang.yanze@zte.com.cn>");
+MODULE_DESCRIPTION("ZTE Ethernet Protocol Driver for RDMA");
+MODULE_LICENSE("Dual BSD/GPL");
+
+LIST_HEAD(zxdh_handlers);
+DEFINE_SPINLOCK(zxdh_handler_lock);
+
+static struct mutex rdma_name_lock;
+static struct list_head zxdh_rdma_list;
+
+static void zxdh_add_handler(struct zxdh_handler *hdl)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&zxdh_handler_lock, flags);
+	list_add(&hdl->list, &zxdh_handlers);
+	spin_unlock_irqrestore(&zxdh_handler_lock, flags);
+}
+
+void zxdh_del_handler(struct zxdh_handler *hdl)
+{
+	unsigned long flags;
+
+	if (!hdl)
+		return;
+
+	spin_lock_irqsave(&zxdh_handler_lock, flags);
+	list_del(&hdl->list);
+	spin_unlock_irqrestore(&zxdh_handler_lock, flags);
+}
+
+int zxdh_get_del_rdma_name(const char *sbdf, char *name, size_t name_len)
+{
+	struct zxdh_rdma_node *pos, *tmp;
+	u8 len = 0;
+
+	if (!sbdf || !name || !name_len)
+		return -EINVAL;
+
+	if (name_len > IB_DEVICE_NAME_MAX) {
+		pr_err("zrdma: name buffer too large\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&rdma_name_lock);
+	list_for_each_entry_safe(pos, tmp, &zxdh_rdma_list, list) {
+		len = strlen(pos->sbdf);
+		if (strlen(sbdf) == len) {
+			if (strncasecmp(sbdf, pos->sbdf, len) == 0) {
+				snprintf(name, name_len, "%s", pos->name);
+				list_del(&pos->list);
+				kfree(pos);
+				mutex_unlock(&rdma_name_lock);
+				return 0;
+			}
+		}
+	}
+	mutex_unlock(&rdma_name_lock);
+	return -ENOENT;
+}
+
+/* Must be called after zxdh_get_common_func_num_max(). */
+static void zxdh_get_net_irq_cap(struct zxdh_pci_f *rf)
+{
+	if (rf->common_func_num_max > ZXDH_FUNC_IRQ_FREE &&
+	    rf->common_func_num_max != 0xFF)
+		rf->net_irq_cap = true;
+}
+
+static void zxdh_get_common_func_num_max(struct zxdh_pci_f *rf)
+{
+	int num_max;
+
+	if (rf->gen_ops.zxdh_common_func) {
+		num_max = rf->gen_ops.zxdh_common_func(NULL, NULL,
+						       ZXDH_FUNC_NUM_REQUIRE);
+		if (num_max >= 0 && num_max != 0xFF) {
+			rf->common_func_num_max = num_max;
+			return;
+		}
+	}
+	rf->common_func_num_max = -1;
+}
+
+static void zxdh_fill_device_info(struct zxdh_device *zdev,
+				  struct zxdh_rdma_core_dev *zdev_info)
+{
+	struct zxdh_pci_f *rf = zdev->rf;
+
+	rf->ftype = ZXDH_FUNC_TYPE(zdev_info->vport_id);
+	rf->pf_id = ZXDH_PF_ID(zdev_info->vport_id);
+	rf->sc_dev.ep_id = ZXDH_EP_ID(zdev_info->vport_id);
+	rf->ep_id = rf->sc_dev.ep_id;
+	rf->sc_dev.driver_load = true;
+
+	rf->zdev_info = zdev_info;
+	rf->pcidev = zdev_info->pdev;
+
+	rf->msix_count = zdev_info->msix_count;
+	rf->msix_entries = zdev_info->msix_entries;
+	if (rf->msix_count)
+		rf->sc_dev.max_ceqs = (rf->msix_count - 1);
+	else
+		rf->sc_dev.max_ceqs = 0;
+	rf->rdma_ver = ZXDH_GEN_2;
+	rf->rst_to = ZXDH_RST_TIMEOUT_HZ;
+	rf->qp_index = 0;
+	rf->gen_ops.zxdh_common_func = NULL;
+	rf->net_irq_cap = false;
+	rf->dh_dev = NULL;
+	rf->drv_np_cap =
+		(bool)FIELD_GET(ZXDH_RDMA_COMM_FUNC, zdev_info->ver.support);
+	if (rf->drv_np_cap == ZXDH_RDMA_COMMON_FUNC_CAP) {
+		if (zdev_info->ops && zdev_info->ops->zxdh_common_func)
+			rf->gen_ops.zxdh_common_func =
+				zdev_info->ops->zxdh_common_func;
+	}
+
+	zxdh_get_common_func_num_max(rf);
+	zxdh_get_net_irq_cap(rf);
+
+	rf->zdev = zdev;
+
+	atomic_set(&zdev->tx_port_affinity, 0);
+	atomic_set(&zdev->sport_counter, 0);
+
+	INIT_LIST_HEAD(&zdev->ah_list);
+	mutex_init(&zdev->ah_list_lock);
+	zdev->init_state = INITIAL_STATE;
+	zdev->roce_mode = true;
+}
+
+static int zxdh_probe(struct auxiliary_device *aux_dev,
+		      const struct auxiliary_device_id *id)
+{
+	struct zxdh_auxiliary_dev *zxdh_adev =
+		container_of(aux_dev, struct zxdh_auxiliary_dev, adev);
+	struct zxdh_handler *hdl;
+	struct zxdh_device *zdev;
+	struct zxdh_pci_f *rf;
+	struct net_device *netdev;
+	int err;
+
+	if (!zxdh_adev->rdma_ops || !zxdh_adev->rdma_ops->get_rdma_netdev) {
+		pr_err("zrdma: rdma_ops or get_rdma_netdev is NULL\n");
+		return -EINVAL;
+	}
+
+	netdev = zxdh_adev->rdma_ops->get_rdma_netdev(zxdh_adev->parent);
+	if (!netdev) {
+		pr_err("zrdma: failed to get netdev\n");
+		return -ENODEV;
+	}
+
+	zdev = ib_alloc_device(zxdh_device, ibdev);
+	if (!zdev)
+		return -ENOMEM;
+
+	zdev->zxdh_adev = zxdh_adev;
+	zdev->netdev = netdev;
+
+	zdev->rf = kzalloc_obj(*zdev->rf);
+	if (!zdev->rf) {
+		ib_dealloc_device(&zdev->ibdev);
+		return -ENOMEM;
+	}
+
+	zxdh_fill_device_info(zdev, zxdh_adev->zxdh_info);
+
+	hdl = kzalloc_obj(*hdl);
+	if (!hdl) {
+		ib_dealloc_device(&zdev->ibdev);
+		return -ENOMEM;
+	}
+
+	hdl->zdev = zdev;
+	zdev->hdl = hdl;
+	zdev->netdev_speed = SPEED_UNKNOWN;
+
+	rf = zdev->rf;
+	err = zxdh_ctrl_init_hw(rf);
+	if (err)
+		goto err_ctrl_init;
+
+	err = zxdh_ib_register_device(zdev);
+	if (err)
+		goto err_ib_reg;
+
+	/* Publish the handler only after the device is registered, so a
+	 * failed probe cannot leave a freed handler on the global list.
+	 */
+	zxdh_add_handler(hdl);
+
+	dev_set_drvdata(&aux_dev->dev, zdev);
+
+	return 0;
+
+err_ib_reg:
+err_ctrl_init:
+	ib_dealloc_device(&zdev->ibdev);
+
+	return err;
+}
+
+static void zxdh_remove(struct auxiliary_device *aux_dev)
+{
+	struct zxdh_device *zdev = dev_get_drvdata(&aux_dev->dev);
+	struct zxdh_handler *hdl;
+
+	if (!zdev) {
+		dev_err(&aux_dev->dev, "%s: zdev is NULL\n", __func__);
+		return;
+	}
+
+	/* Detach the handler before ib_unregister_device() so it is not
+	 * visible to new callers during unregister.
+	 */
+	hdl = zdev->hdl;
+	zdev->hdl = NULL;
+	zxdh_del_handler(hdl);
+	kfree(hdl);
+
+	/* No 'get' on the ib_device, so the _and_put variant would
+	 * underflow ib_device.refcount; see cover letter.
+	 */
+	ib_unregister_device(&zdev->ibdev);
+}
+
+static const struct auxiliary_device_id zxdh_auxiliary_id_table[] = {
+	{
+		.name = ZXDH_PF_NAME "." ZXDH_RDMA_DEV_NAME,
+	},
+	{},
+};
+
+MODULE_DEVICE_TABLE(auxiliary, zxdh_auxiliary_id_table);
+
+static struct auxiliary_driver zxdh_auxiliary_drv = {
+	.name = ZXDH_RDMA_DEV_NAME,
+	.id_table = zxdh_auxiliary_id_table,
+	.probe = zxdh_probe,
+	.remove = zxdh_remove,
+};
+
+static int __init zrdma_module_init(void)
+{
+	int ret;
+
+	INIT_LIST_HEAD(&zxdh_rdma_list);
+	mutex_init(&rdma_name_lock);
+
+	ret = auxiliary_driver_register(&zxdh_auxiliary_drv);
+	if (ret) {
+		pr_err("zrdma: failed to register auxiliary driver\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __exit zrdma_module_exit(void)
+{
+	struct zxdh_rdma_node *pos, *tmp;
+
+	auxiliary_driver_unregister(&zxdh_auxiliary_drv);
+
+	mutex_lock(&rdma_name_lock);
+	list_for_each_entry_safe(pos, tmp, &zxdh_rdma_list, list) {
+		list_del(&pos->list);
+		kfree(pos);
+	}
+	mutex_unlock(&rdma_name_lock);
+
+	mutex_destroy(&rdma_name_lock);
+}
+
+module_init(zrdma_module_init);
+module_exit(zrdma_module_exit);
-- 
2.27.0

