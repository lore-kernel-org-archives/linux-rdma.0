Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C26430CC6;
	Tue, 11 Aug 2026 09:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=160.30.148.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786441385; cv=none; b=RpBoLx2XzZO4NBx2xy37q19aNy2y17wvnCnABOqnp6TG62mrKxfh7PzjRP7NOWh2syDIJ/W02Dl8gaxatxQEXPUBIMSdTU0SWXJXDLDhAF+fgGN2VTwFJMsDbQ8NOZqrikKYP2Inietd8ciAjmw2xygelw4/VUYksBjw4l7M6rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786441385; c=relaxed/simple;
	bh=Zj8jkL4ub/Q9AuvAUCux4beVmXq4h282KwUMZVI3vQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5ONr35Jak+z4YlxPwXPcWBfPW+d27JVsQzUnDLgXsV5rBy+b05xYmCNkURW76ma343jI2O1WckKiNx56J2+d/kscFpLyC66z7jYCLvJPZz0/GPtWclc4s974m4ezs975CZj5fcFoRfxNCMe003w/72U64mUrL7WXsVr4zi2YxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=160.30.148.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4hK69r0j3Pz8Xrrd;
	Tue, 11 Aug 2026 17:42:56 +0800 (CST)
Received: from szxl2zmapp05.zte.com.cn ([10.1.32.37])
	by mse-fl1.zte.com.cn with SMTP id 67B9ggub089568;
	Tue, 11 Aug 2026 17:42:42 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Tue, 11 Aug 2026 17:42:45 +0800
X-Zmail-TransId: 3e816a7aee94013-4449e
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev, lkp@intel.com
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        wei.quan@zte.com.cn, han.junyang@zte.com.cn, ran.ming@zte.com.cn,
        han.chengfei@zte.com.cn, zhang.yanze@zte.com.cn
Subject: [PATCH rdma v5 5/7] RDMA/zrdma: Add device probe and remove logic
Date: Tue, 11 Aug 2026 17:37:38 +0800
Message-ID: <20260811093740.2607476-6-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811093740.2607476-1-zhang.yanze@zte.com.cn>
References: <20260811093740.2607476-1-zhang.yanze@zte.com.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ZMAIL-USEORIGINALEMLTOOUTBOUND: 1
Content-Transfer-Encoding: 8bit
X-MAIL:mse-fl1.zte.com.cn 67B9ggub089568
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 11 Aug 2026 17:42:56 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A7AEEA0.000/4hK69r0j3Pz8Xrrd

Implement the auxiliary bus probe and remove functions, including device
initialization, hardware resource setup, and IB device registration.
This replaces the stub probe from the initial skeleton patch.

Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>
---
 drivers/infiniband/hw/zrdma/zrdma_main.c | 251 +++++++++++++++++++++--
 1 file changed, 237 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/zrdma/zrdma_main.c b/drivers/infiniband/hw/zrdma/zrdma_main.c
index 7954d86573e2..c181736a9641 100644
--- a/drivers/infiniband/hw/zrdma/zrdma_main.c
+++ b/drivers/infiniband/hw/zrdma/zrdma_main.c
@@ -6,36 +6,246 @@
 
 #include <linux/module.h>
 #include <linux/auxiliary_bus.h>
+#include <linux/types.h>
+#include <linux/netdevice.h>
+#include <linux/workqueue.h>
+#include <rdma/ib_verbs.h>
 
-#define ZXDH_PF_NAME "dinghai10e"
-#define ZXDH_RDMA_DEV_NAME "rdma_aux"
+#include "zrdma_main.h"
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_ALIAS("zrdma");
 MODULE_AUTHOR("Yanze Zhang <zhang.yanze@zte.com.cn>");
 MODULE_DESCRIPTION("ZTE Ethernet Protocol Driver for RDMA");
+MODULE_LICENSE("Dual BSD/GPL");
 
-static const struct auxiliary_device_id zxdh_auxiliary_id_table[] = {
-	{
-		.name = ZXDH_PF_NAME "." ZXDH_RDMA_DEV_NAME,
-	},
-	{},
-};
+LIST_HEAD(zxdh_handlers);
+DEFINE_SPINLOCK(zxdh_handler_lock);
 
-MODULE_DEVICE_TABLE(auxiliary, zxdh_auxiliary_id_table);
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
+	spin_lock_irqsave(&zxdh_handler_lock, flags);
+	list_del(&hdl->list);
+	spin_unlock_irqrestore(&zxdh_handler_lock, flags);
+}
+
+int zxdh_get_del_rdma_name(const char *sbdf, char *name)
+{
+	struct zxdh_rdma_node *pos, *tmp;
+	u8 len = 0;
+
+	if (!sbdf || !name)
+		return -EINVAL;
+
+	if (strlen(name) > IB_DEVICE_NAME_MAX) {
+		pr_err("zrdma: name len out of range\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&rdma_name_lock);
+	list_for_each_entry_safe(pos, tmp, &zxdh_rdma_list, list) {
+		len = strlen(pos->sbdf);
+		if (strlen(sbdf) == len) {
+			if (strncasecmp(sbdf, pos->sbdf, len) == 0) {
+				snprintf(name, IB_DEVICE_NAME_MAX, "%s",
+					 pos->name);
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
+static void zxdh_get_net_irq_cap(struct zxdh_pci_f *rf)
+{
+	u32 opcode = 0;
+
+	if (rf->gen_ops.zxdh_common_func) {
+		opcode = rf->gen_ops.zxdh_common_func(NULL, NULL,
+						      ZXDH_FUNC_NUM_REQUIRE);
+		if (opcode > ZXDH_FUNC_IRQ_FREE && opcode != 0xFF)
+			rf->net_irq_cap = true;
+	}
+}
+
+static void zxdh_get_common_func_num_max(struct zxdh_pci_f *rf)
+{
+	u32 num_max = 0;
+
+	if (rf->gen_ops.zxdh_common_func) {
+		num_max = rf->gen_ops.zxdh_common_func(NULL, NULL,
+						       ZXDH_FUNC_NUM_REQUIRE);
+		if (num_max != 0xFF) {
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
+	rf->sc_dev.max_ceqs = (rf->msix_count - 1);
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
+	zxdh_get_net_irq_cap(rf);
+	zxdh_get_common_func_num_max(rf);
+
+	rf->zdev = zdev;
+
+	INIT_LIST_HEAD(&zdev->ah_list);
+	mutex_init(&zdev->ah_list_lock);
+	zdev->init_state = INITIAL_STATE;
+	zdev->roce_mode = true;
+}
 
 static int zxdh_probe(struct auxiliary_device *aux_dev,
 		      const struct auxiliary_device_id *id)
 {
-	/* Placeholder: Real probe logic will be added in subsequent patches */
-	dev_info(&aux_dev->dev, "ZTE DingHai RDMA device detected (stub)\n");
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
+		kfree(zdev->rf);
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
+	zxdh_add_handler(hdl);
+
+	err = zxdh_ib_register_device(zdev);
+	if (err)
+		goto err_ib_reg;
+
+	dev_set_drvdata(&aux_dev->dev, zdev);
+
 	return 0;
+
+err_ib_reg:
+	zxdh_del_handler(hdl);
+err_ctrl_init:
+	kfree(zdev->rf);
+	kfree(hdl);
+	ib_dealloc_device(&zdev->ibdev);
+
+	return err;
 }
 
 static void zxdh_remove(struct auxiliary_device *aux_dev)
 {
-	dev_info(&aux_dev->dev, "ZTE DingHai RDMA device removed (stub)\n");
+	struct zxdh_device *zdev = dev_get_drvdata(&aux_dev->dev);
+
+	if (!zdev) {
+		dev_err(&aux_dev->dev, "%s: zdev is NULL\n", __func__);
+		return;
+	}
+
+	ib_unregister_device(&zdev->ibdev);
+	zxdh_del_handler(zdev->hdl);
+
+	kfree(zdev->rf);
+	kfree(zdev->hdl);
+	ib_dealloc_device(&zdev->ibdev);
+}
+
+static void zxdh_shutdown(struct auxiliary_device *aux_dev)
+{
+	zxdh_remove(aux_dev);
 }
 
+static const struct auxiliary_device_id zxdh_auxiliary_id_table[] = {
+	{
+		.name = ZXDH_PF_NAME "." ZXDH_RDMA_DEV_NAME,
+	},
+	{},
+};
+
+MODULE_DEVICE_TABLE(auxiliary, zxdh_auxiliary_id_table);
+
 static struct auxiliary_driver zxdh_auxiliary_drv = {
 	.driver = {
 		.name = ZXDH_RDMA_DEV_NAME,
@@ -43,16 +253,29 @@ static struct auxiliary_driver zxdh_auxiliary_drv = {
 	.id_table = zxdh_auxiliary_id_table,
 	.probe = zxdh_probe,
 	.remove = zxdh_remove,
+	.shutdown = zxdh_shutdown,
 };
 
 static int __init zrdma_module_init(void)
 {
-	return auxiliary_driver_register(&zxdh_auxiliary_drv);
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
 }
 
 static void __exit zrdma_module_exit(void)
 {
 	auxiliary_driver_unregister(&zxdh_auxiliary_drv);
+	mutex_destroy(&rdma_name_lock);
 }
 
 module_init(zrdma_module_init);
-- 
2.27.0

