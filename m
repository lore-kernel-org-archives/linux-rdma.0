Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711284;
	b=oFBeLqmSslyVkEIILcHR8yqlCp8k1sJM886ddB7aNKVHvAcD8o06Wv6UF/W/PmUjit3D
	 ev2+H62Xla7919nHftSAhKX8wGG33XL5XggRu6rI5gX/06CSaRMgU6ramIR0sg2p7AZEU
	 Pq7RC7+Z0auVIEiG/iZEUwVaLymtUnX3X/r1c5mGZ9Fq+KP2J9NDnkbHPgr7c2WjuvBGa
	 PW3w3HL+w+6ezi3njLDTEFbWivUQ0UHu6oZcmOvPdYZdcZz8+tlrtFqUe0ecQu3Glm6sy
	 Mj2IJrMDa/vvnN0F6dZ+CndnYSTqcJoAbM8pWLECwQosnZsILEiPbV83q4lJGYvj3cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711284;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:
	 X-Zmail-LocalSMTP:X-Zmail-RealSender:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-ZMAIL-USEORIGINALEMLTOOUTBOUND:Content-Transfer-Encoding:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=7zXRfF4wJXPp5P+Anib/73xcpnWgr/niAS6lVeuc7eo=;
	b=ehqKijpERNLLEsM9eE/e/eyF0/NwrBgLaN5S49P0zEJqMzRLTVeBmIYUU6hMo9aJWgyY
	 kF5Czi+yAQ3KD7qDJ7HdooU56k+292ZqQbtkUro3UPdOEBWMPTKurAJq+xhnIBNdfWffs
	 7rXM/yKQBAA9tIrltuXxu9GZZSqUPDou/PRVLpzG3B3ifJonWEKZjp4wFd6UHsqzcJXgM
	 7pC+MDW7l9CEMP9OuXIw9e68mhUBcruPHaqne9wbgWtnVE77EOhIwrddTjDNGNKZG3y0b
	 cEcsE23in8d3y2DKZ5iAkkUQ92GUmI+fJlCSEMfOO4w6sHYMGoiCMAc1xANVqDSnuEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.35
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EDC6082BEC;
	Tue,  3 Nov 2026 13:08:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7EDC6082BEC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jJplj4rllz8Xrr9;
	Tue, 03 Nov 2026 21:08:01 +0800 (CST)
Received: from szxl2zmapp06.zte.com.cn ([10.1.32.108])
	by mse-fl2.zte.com.cn with SMTP id 6A3D7kZr057799;
	Tue, 3 Nov 2026 21:07:46 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Tue, 3 Nov 2026 21:07:49 +0800
X-Zmail-TransId: 3e816ae9dca5029-7ee08
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev
Cc: Markus.Elfring@web.de, lkp@intel.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, wei.quan@zte.com.cn,
        han.junyang@zte.com.cn, ran.ming@zte.com.cn, han.chengfei@zte.com.cn,
        zhang.yanze@zte.com.cn
Subject: [PATCH rdma v9 6/7] RDMA/zrdma: Add device probe and remove logic
Date: Tue,  3 Nov 2026 20:56:53 +0800
Message-ID: <20261103125654.2707069-7-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103125654.2707069-1-zhang.yanze@zte.com.cn>
References: <20261103125654.2707069-1-zhang.yanze@zte.com.cn>
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
X-MAIL:mse-fl2.zte.com.cn 6A3D7kZr057799
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 03 Nov 2026 21:08:01 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE9DCB1.001/4jJplj4rllz8Xrr9

Implement the auxiliary bus probe and remove functions, including device
initialization, hardware resource setup, and IB device registration.
This replaces the stub probe from the initial skeleton patch. The file
is modified rather than deleted, so every commit of the series builds on
its own.

The device ops are installed right after ib_alloc_device(), so that the
dealloc_driver hook is in place before any resource is taken. The hook
releases the hardware resources and the address handle list lock, and it
only destroys the lock when it was actually initialised. The pci device
is owned by the PF driver, so the driver does not release it.

The netdev is bound to the IB device and the DMA capable device is
handed to the core before the device is registered, so that the port
queries read the netdev the auxiliary device belongs to and the core
does not have to fall back to the kernel virtual address of the
scatterlists.

Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>
---
 drivers/infiniband/hw/zrdma/zrdma_main.c  | 172 +++++++++++++++++++++-
 drivers/infiniband/hw/zrdma/zrdma_verbs.c |  56 +++++++
 2 files changed, 225 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/zrdma/zrdma_main.c b/drivers/infiniband/hw/zrdma/zrdma_main.c
index 80856c7ff6b2a..c320513c13879 100644
--- a/drivers/infiniband/hw/zrdma/zrdma_main.c
+++ b/drivers/infiniband/hw/zrdma/zrdma_main.c
@@ -6,11 +6,96 @@
 
 #include <linux/module.h>
 #include <linux/auxiliary_bus.h>
+#include <linux/types.h>
+#include <linux/netdevice.h>
+#include <rdma/ib_verbs.h>
+
+#include "zrdma_main.h"
+#include "zrdma_verbs.h"
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Yanze Zhang <zhang.yanze@zte.com.cn>");
 MODULE_DESCRIPTION("ZTE Ethernet Protocol Driver for RDMA");
 
+/* Must be called after zxdh_get_common_func_num_max(). */
+/* The firmware supports the interrupt request and the interrupt free
+ * opcodes when the highest opcode it reports is beyond the free one.
+ */
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
+	/* The number of completion vectors is reported to the core as
+	 * ib_device.num_comp_vectors. The core divides by it and
+	 * rejects every uverbs CQ creation when it is zero, so the count
+	 * is never allowed to drop below one.
+	 */
+	rf->ceqs_count = rf->sc_dev.max_ceqs ? rf->sc_dev.max_ceqs : 1;
+	rf->rdma_ver = ZXDH_GEN_2;
+	rf->rst_to = ZXDH_RST_TIMEOUT_HZ;
+	rf->qp_index = 0;
+	rf->gen_ops.zxdh_common_func = NULL;
+	rf->net_irq_cap = false;
+	rf->dh_dev = NULL;
+	if (FIELD_GET(ZXDH_RDMA_COMM_FUNC, zdev_info->ver.support) ==
+	    ZXDH_RDMA_COMMON_FUNC_CAP) {
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
 /* The name has to match the auxiliary device that the DingHai PF
  * driver creates.
  */
@@ -26,14 +111,95 @@ MODULE_DEVICE_TABLE(auxiliary, zxdh_auxiliary_id_table);
 static int zxdh_probe(struct auxiliary_device *aux_dev,
 		      const struct auxiliary_device_id *id)
 {
-	/* Placeholder: Real probe logic will be added in subsequent patches */
-	dev_info(&aux_dev->dev, "ZTE DingHai RDMA device detected (stub)\n");
+	struct zxdh_auxiliary_dev *zxdh_adev =
+		container_of(aux_dev, struct zxdh_auxiliary_dev, adev);
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
+	/* The pci device is the DMA capable device of the IB device and
+	 * the source of the vendor id, so it has to be there.
+	 */
+	if (!zxdh_adev->zxdh_info->pdev) {
+		pr_err("zrdma: pci device is NULL\n");
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
+	rf = zdev->rf;
+	err = zxdh_ctrl_init_hw(rf);
+	if (err)
+		goto err_dealloc;
+
+	err = zxdh_ib_register_device(zdev);
+	if (err)
+		goto err_dealloc;
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
+
+	if (!zdev) {
+		dev_err(&aux_dev->dev, "%s: zdev is NULL\n", __func__);
+		return;
+	}
+
+	/* Clear the drvdata before the device is freed, so that it does
+	 * not point to the released ib_device any more.
+	 */
+	dev_set_drvdata(&aux_dev->dev, NULL);
+
+	/* No 'get' on the ib_device, so the _and_put variant would
+	 * underflow ib_device.refcount; see cover letter.
+	 */
+	ib_unregister_device(&zdev->ibdev);
 }
 
 static struct auxiliary_driver zxdh_auxiliary_drv = {
diff --git a/drivers/infiniband/hw/zrdma/zrdma_verbs.c b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
index b5322a8e129bb..a410ef4521ad5 100644
--- a/drivers/infiniband/hw/zrdma/zrdma_verbs.c
+++ b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
@@ -11,6 +11,31 @@
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 
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
+}
+
 /* Fetch the driver info for @zdev->netdev, or for its first lower device
  * when it is a bond. The lower device list is protected by rtnl_lock.
  *
@@ -317,6 +342,17 @@ static int zxdh_init_rdma_device(struct zxdh_device *zdev)
 	return 0;
 }
 
+static void zxdh_port_ibevent(struct zxdh_device *zdev)
+{
+	struct ib_event event;
+
+	event.device = &zdev->ibdev;
+	event.element.port_num = 1;
+	event.event = zdev->ibdev_status ? IB_EVENT_PORT_ACTIVE :
+						 IB_EVENT_PORT_ERR;
+	ib_dispatch_event(&event);
+}
+
 int zxdh_ib_register_device(struct zxdh_device *zdev)
 {
 	int ret;
@@ -325,13 +361,32 @@ int zxdh_ib_register_device(struct zxdh_device *zdev)
 	if (ret)
 		return ret;
 
+	ret = ib_device_set_netdev(&zdev->ibdev, zdev->netdev, 1);
+	if (ret)
+		goto error;
+
+	zdev->rf->hw.device = &zdev->rf->pcidev->dev;
+	dma_set_max_seg_size(zdev->rf->hw.device, SZ_1G);
+
+	/* Publish the link state before the device becomes visible to
+	 * userspace, so a racing ULP never observes a stale status.
+	 */
+	zdev->ibdev_status = 1;
+
 	ret = ib_register_device(&zdev->ibdev, "zrdma%d", zdev->rf->hw.device);
 	if (ret)
 		goto error;
 
+	zxdh_port_ibevent(zdev);
+
 	return 0;
 
 error:
+	/* There is nothing to undo here: ib_device_set_netdev() only fails
+	 * before it takes the netdev reference, and the reference it takes
+	 * on success is released by free_netdevs() when the device is
+	 * deallocated.
+	 */
 	pr_err("zrdma: Register RDMA device fail, ret=%d\n", ret);
 
 	return ret;
@@ -341,6 +396,7 @@ const struct ib_device_ops zxdh_dev_ops = {
 	.owner = THIS_MODULE,
 	.driver_id = RDMA_DRIVER_ZRDMA,
 	.uverbs_abi_ver = ZXDH_ABI_VER,
+	.dealloc_driver = zxdh_ib_dealloc_device,
 	.query_device = zxdh_query_device,
 	.query_port = zxdh_query_port,
 	.query_pkey = zxdh_query_pkey,
-- 
2.43.5

