Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793067763;
	b=Kisyuf77zqFdgCtJXEncFdYDEXMcUpYCpdQCywyNh6hzvGu/HDymjNRHnEAFcyBoxYmm
	 quHthjnlNougQoDTSSfeHuDMiORd5IUVvYGI+NHBWn/rAPAXHiBikLmFONvEJW2Tzy/gM
	 OUVvU6Zl8vN0byYb2byaZYFLKR7XFe/Aes7nmPYSnIyrHacfLkt/9GBHfQO4BZ9l1HldF
	 6y8eWGv/P+bbWyvTCS0x0ShRtOul1MIf/SOLB/Xmz1aQJt4d0vQINU9XJ+anfF1csulzs
	 FDZDEPO9KbJYW9tvE+WiNHqKbP+Yk9TBWFy03cqD1gu3GdA2tsT/cQgCNKCsRr2Ilmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793067763;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:
	 X-Zmail-LocalSMTP:X-Zmail-RealSender:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-ZMAIL-USEORIGINALEMLTOOUTBOUND:Content-Transfer-Encoding:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=S1r0Drbej2H0BDUCGks/+Fe4R2biyo3h7klRZmvWKCY=;
	b=1qErc8vFi6kqEzSTMB4NEREU/4vMN8ILfpznb9G5Jj2+JaihhiqyOGV/5gmGJwdDPONZ
	 z3XDPxb0x5DYN4s6QkxKI56grijtHTpkseSnJilSy/+TyNO+o3VTnKWMQTMCiNUevMwA+
	 cV+tf6UUWxlWdsTUY0JaW0f9Oy0Ya4BgZH8MUfK3gzIx7SBfUnCDuNmrEDQYlX6I/zYBq
	 TvHumQ4kjXf+TI5hiSYy71laa76Bltn17eDt21h1Uei9xRGHGTRBkC1tTHpGnGSGlLBGM
	 D6YeTYND9xbfdtHZyx2kjnaq1AW9zOFl+mty+Vdkrvwtl/1sbAUXRmV3A6CFXf4O3pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DDB60A2608;
	Tue, 27 Oct 2026 02:22:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4DDB60A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jDDmH3gmJz5B7RP;
	Tue, 27 Oct 2026 10:22:39 +0800 (CST)
Received: from szxl2zmapp07.zte.com.cn ([10.1.32.52])
	by mse-fl2.zte.com.cn with SMTP id 69R2MSQh099745;
	Tue, 27 Oct 2026 10:22:28 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Tue, 27 Oct 2026 10:22:30 +0800
X-Zmail-TransId: 3e816ae00ae5027-4be6a
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev
Cc: Markus.Elfring@web.de, lkp@intel.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, wei.quan@zte.com.cn,
        han.junyang@zte.com.cn, ran.ming@zte.com.cn, han.chengfei@zte.com.cn,
        zhang.yanze@zte.com.cn
Subject: [PATCH rdma v7 5/7] RDMA/zrdma: Add device probe and remove logic
Date: Tue, 27 Oct 2026 10:11:17 +0800
Message-ID: <20261027021119.2325798-6-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261027021119.2325798-1-zhang.yanze@zte.com.cn>
References: <20261027021119.2325798-1-zhang.yanze@zte.com.cn>
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
X-MAIL:mse-fl2.zte.com.cn 69R2MSQh099745
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 27 Oct 2026 10:22:39 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE00AEF.000/4jDDmH3gmJz5B7RP

Implement the auxiliary bus probe and remove functions, including device
initialization, hardware resource setup, and IB device registration.
This replaces the stub probe from the initial skeleton patch. The file
is modified rather than deleted, so every commit of the series builds on
its own.

The device ops are installed right after ib_alloc_device(), so the
dealloc_driver hook is in place before any resource is allocated and
every error path releases what it has taken. The hook itself is NULL
safe and only destroys the ah_list_lock when it was actually
initialised.

Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>
---
 drivers/infiniband/hw/zrdma/zrdma_main.c  | 276 ++++++++++++++++++++--
 drivers/infiniband/hw/zrdma/zrdma_verbs.c |  29 +++
 2 files changed, 291 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/zrdma/zrdma_main.c b/drivers/infiniband/hw/zrdma/zrdma_main.c
index af1d37be6336..14c36531cc45 100644
--- a/drivers/infiniband/hw/zrdma/zrdma_main.c
+++ b/drivers/infiniband/hw/zrdma/zrdma_main.c
@@ -6,36 +6,262 @@
 
 #include <linux/module.h>
 #include <linux/auxiliary_bus.h>
+#include <linux/types.h>
+#include <linux/netdevice.h>
+#include <linux/workqueue.h>
+#include <rdma/ib_verbs.h>
 
-#define ZXDH_PF_NAME "dinghai10e"
-#define ZXDH_RDMA_DEV_NAME "rdma_aux"
+#include "zrdma_main.h"
+#include "zrdma_verbs.h"
 
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
+	size_t len, sbdf_len;
+
+	if (!sbdf || !name || !name_len)
+		return -EINVAL;
+
+	if (name_len > IB_DEVICE_NAME_MAX) {
+		pr_err("zrdma: name buffer too large\n");
+		return -EINVAL;
+	}
+
+	sbdf_len = strlen(sbdf);
+
+	mutex_lock(&rdma_name_lock);
+	list_for_each_entry_safe(pos, tmp, &zxdh_rdma_list, list) {
+		len = strlen(pos->sbdf);
+		if (sbdf_len == len &&
+		    strncasecmp(sbdf, pos->sbdf, len) == 0) {
+			snprintf(name, name_len, "%s", pos->name);
+			list_del(&pos->list);
+			kfree(pos);
+			mutex_unlock(&rdma_name_lock);
+			return 0;
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
+	if (!zxdh_adev->zxdh_info) {
+		pr_err("zrdma: zxdh_info is NULL\n");
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
+	/* Install the device ops before anything can fail, so that every
+	 * ib_dealloc_device() below runs the dealloc_driver hook and the
+	 * resources allocated so far are released.
+	 */
+	ib_set_device_ops(&zdev->ibdev, &zxdh_dev_ops);
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
+
+	rf = zdev->rf;
+	err = zxdh_ctrl_init_hw(rf);
+	if (err)
+		goto err_dealloc;
+
+	err = zxdh_ib_register_device(zdev);
+	if (err)
+		goto err_dealloc;
+
+	/* Publish the handler only after the device is registered, so a
+	 * failed probe cannot leave a freed handler on the global list.
+	 */
+	zxdh_add_handler(hdl);
+
+	dev_set_drvdata(&aux_dev->dev, zdev);
+
 	return 0;
+
+err_dealloc:
+	ib_dealloc_device(&zdev->ibdev);
+
+	return err;
 }
 
 static void zxdh_remove(struct auxiliary_device *aux_dev)
 {
-	dev_info(&aux_dev->dev, "ZTE DingHai RDMA device removed (stub)\n");
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
 	.name = ZXDH_RDMA_DEV_NAME,
 	.id_table = zxdh_auxiliary_id_table,
@@ -45,12 +271,34 @@ static struct auxiliary_driver zxdh_auxiliary_drv = {
 
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
+	struct zxdh_rdma_node *pos, *tmp;
+
 	auxiliary_driver_unregister(&zxdh_auxiliary_drv);
+
+	mutex_lock(&rdma_name_lock);
+	list_for_each_entry_safe(pos, tmp, &zxdh_rdma_list, list) {
+		list_del(&pos->list);
+		kfree(pos);
+	}
+	mutex_unlock(&rdma_name_lock);
+
+	mutex_destroy(&rdma_name_lock);
 }
 
 module_init(zrdma_module_init);
diff --git a/drivers/infiniband/hw/zrdma/zrdma_verbs.c b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
index 90ff9a826491..d47dfafa717a 100644
--- a/drivers/infiniband/hw/zrdma/zrdma_verbs.c
+++ b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
@@ -12,8 +12,37 @@ const struct ib_device_ops zxdh_dev_ops = {
 	.owner = THIS_MODULE,
 	.driver_id = RDMA_DRIVER_ZRDMA,
 	.uverbs_abi_ver = ZXDH_ABI_VER,
+	.dealloc_driver = zxdh_ib_dealloc_device,
 };
 
+/* Release everything the probe path may have allocated. The hook is
+ * called from ib_dealloc_device(), so it must tolerate a partially
+ * initialised device.
+ */
+void zxdh_ib_dealloc_device(struct ib_device *ibdev)
+{
+	struct zxdh_device *zdev = to_zdev(ibdev);
+
+	if (!zdev)
+		return;
+
+	if (zdev->rf) {
+		kvfree(zdev->rf->qp_cnt_8k_idxs);
+		kvfree(zdev->rf->mem_rsrc);
+		kfree(zdev->rf);
+		zdev->rf = NULL;
+	}
+
+	/* ah_list_lock is only initialised by zxdh_fill_device_info(),
+	 * which is skipped when the probe fails earlier.
+	 */
+	if (zdev->init_state != INVALID_STATE)
+		mutex_destroy(&zdev->ah_list_lock);
+
+	kfree(zdev->hdl);
+	zdev->hdl = NULL;
+}
+
 static int zxdh_init_rdma_device(struct zxdh_device *zdev)
 {
 	zdev->ibdev.phys_port_cnt = 1;
-- 
2.27.0

