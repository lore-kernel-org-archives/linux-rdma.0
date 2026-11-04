Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.26
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793807837;
	b=q5pJirl5X5bqoDG5KsDeKOhR9jOhZ9U/03lx6QnIMBBDiUpFfjjUng3Y1qNKmL5gOeOd
	 eeDQFInWnx7BGhKmA+Of4M92oOWOO0SMUJ7hGEJvL+cy2WjWhvZG1tPRFzzuYTD/sICv1
	 hsOCOG4I3/4MjA7Kcm5RPVI3YcPOlmZmM7qacO53e4netHCWEp3fJxLouBZT1weLkJ3iO
	 z1p4ZUF6nKuT8aIWtNiTWNU4KXW1Z12qICmpm9idy7hp7dSkDBw+YDD1TMxSp4A4fR/39
	 3B6kQHkrBMWAv5s48dR5C8IP64Q32YKqGuDbWE4eC3szV0y1Qe4dJvKc0FpfSx9oPRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793807837;
	h=DMARC-Filter:DKIM-Signature:Mime-Version:X-Mailer:X-Lms-Return-Path:
	 X-Original-From:Subject:Message-Id:Received:Cc:From:References:To:
	 Date:Content-Type:In-Reply-To:Content-Transfer-Encoding;
	bh=bAsWaQfIFpffDo+m9zea2rKMAqKK54NOj9Omo8Yxiyc=;
	b=zlnlKo6NGTSK2PozVBgKhrrveeCnXeYpRO3vR2GUShCFzttZy4dsSKSASSwQsfWRD5b5
	 xPoht/FKBKw0g0PCIyK/VhC+wM3AEnrOArv6dRUJs6Kg4dzdQFpHqAcMPIKp09hMDH25s
	 0Vg7DRFKiKMFPdlYHIcUn7EYWWN0c0UO1V9ecZbNIfIVwSWQugZeFGVzdu0v6esrJ38CJ
	 +TTlcHsZ3M71ueh+Czk+xqZF/eQA66vmojKQGRImRfcQoPa4OZVIcSd+dPYUKNdl/ZZCV
	 GnaewGX/MEaq7gqVzVXPv+K7SxbNm9VKW8GBjlX7cr3wnJQBZJ/NyE5qDFhLmclG3kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=Eh6GrXnq;
	arc=none smtp.remote-ip=209.127.231.26
Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D95606A333
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 15:57:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77D95606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=Eh6GrXnq
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1793807824; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=bAsWaQfIFpffDo+m9zea2rKMAqKK54NOj9Omo8Yxiyc=;
 b=Eh6GrXnqgdMJFFVW5tg/yjOaZqWvOfECqqpkFAD8CTj1WRv6TJXtSW7mb8UCBfg2O6nd3l
 hXOWeN6lc7OVIU3mbXtjKeJ/pK+k0JZyr0ABybe5InjEsSH8RgWY49DiitNY4gWVitF2mD
 1cNWOb2ob8DAC8UXTHlp7KUudr/rPCulcgdx8Tewx0Vf8oCd1xe/epLhG3X7O5//GxEo+X
 imakRNBc+6LuT+JsjXOJ/lZQtulPT26SIs0B1209ZFloLoD6aM7+RyJ06LtXayezRnD/m7
 LOPmIfXrUTTxP1mQKUM6AZQ9Sa3js9QZyqpLCL8Pi4LK3CNZN4Zr6ACBtI0G1Q==
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1
X-Lms-Return-Path: <lba+26aeb55cf+e4a08c+vger.kernel.org+tianx@yunsilicon.com>
X-Original-From: Xin Tian <tianx@yunsilicon.com>
Subject: [PATCH v1 05/15] net/xsc: add event queues, interrupts and the
Message-Id: <20261104155701.37053-6-tianx@yunsilicon.com>
Received: from sw-dev-sha252.yunsilicon.com ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Wed, 04 Nov 2026 23:57:02 +0800
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
From: "Xin Tian" <tianx@yunsilicon.com>
References: <20261104155650.37053-1-tianx@yunsilicon.com>
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>
Date: Wed, 04 Nov 2026 23:57:02 +0800
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20261104155650.37053-1-tianx@yunsilicon.com>
Content-Transfer-Encoding: 7bit

auxiliary bus

Add the event queue mechanism and split the core device into
function drivers over the auxiliary bus.

EQs are DMA-coherent rings whose entries carry an event type, a
sub-type and a 15-bit queue id.  The async EQ is bound to vector 0,
the command interfaces to vectors 1 and 2, and completion EQs are
spread over the remaining MSI-X vectors, allocated from 4 up to the
firmware-reported maximum with the firmware-visible vector computed
from a base offset.  Events that need process context are queued to
a singlethread workqueue, which queries the event type from firmware
and dispatches link-change notifications to registered handlers and
temperature warnings.  Per-completion-vector IRQ affinity hints use
cpumask_local_spread.

Add the DMA allocation helpers used throughout the driver: a
coherent buffer abstraction that falls back from one large
allocation to page-chained fragments with vmap, and NUMA-local
fragment allocation driven by temporarily retargeting the device's
NUMA node.

Finally, register one auxiliary device per function, named
xsc_pci.eth and xsc_pci.ib, so the ethernet and RDMA drivers can
bind to their function independently of the PCI core.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 .../net/ethernet/yunsilicon/xsc/pci/Makefile  |   2 +-
 .../net/ethernet/yunsilicon/xsc/pci/adev.c    | 142 +++++
 .../net/ethernet/yunsilicon/xsc/pci/adev.h    |  17 +
 .../net/ethernet/yunsilicon/xsc/pci/alloc.c   | 237 +++++++++
 .../net/ethernet/yunsilicon/xsc/pci/alloc.h   |  17 +
 drivers/net/ethernet/yunsilicon/xsc/pci/cq.h  |  17 +
 drivers/net/ethernet/yunsilicon/xsc/pci/eq.c  | 266 ++++++++++
 drivers/net/ethernet/yunsilicon/xsc/pci/eq.h  |  39 ++
 .../net/ethernet/yunsilicon/xsc/pci/main.c    |  25 +
 .../net/ethernet/yunsilicon/xsc/pci/pci_irq.c | 494 ++++++++++++++++++
 .../net/ethernet/yunsilicon/xsc/pci/pci_irq.h |  18 +
 drivers/net/ethernet/yunsilicon/xsc/pci/qp.h  |  28 +
 12 files changed, 1301 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/adev.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/adev.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/alloc.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/cq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/eq.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/eq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/qp.h

diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
index 656cdffa1..e264990f9 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
@@ -6,4 +6,4 @@ ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
 
 obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc_pci.o
 
-xsc_pci-y := main.o cmdq.o hw.o hal/andes_impl.o
+xsc_pci-y := main.o cmdq.o hw.o alloc.o eq.o pci_irq.o adev.o hal/andes_impl.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/adev.c b/drivers/net/ethernet/yunsilicon/xsc/pci/adev.c
new file mode 100644
index 000000000..c8e8f1a9f
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/adev.c
@@ -0,0 +1,142 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/auxiliary_bus.h>
+#include <linux/idr.h>
+
+#include "adev.h"
+
+static DEFINE_IDA(xsc_adev_ida);
+
+static const char * const xsc_adev_name[] = {
+	[XSC_ADEV_IDX_ETH] = XSC_ETH_ADEV_NAME,
+	[XSC_ADEV_IDX_IB]  = XSC_IB_ADEV_NAME,
+};
+
+static void xsc_release_adev(struct device *dev)
+{
+	struct xsc_adev *xsc_adev =
+		container_of(dev, struct xsc_adev, adev.dev);
+
+	kfree(xsc_adev);
+}
+
+int xsc_adev_add(struct xsc_core_device *xdev, int idx)
+{
+	struct auxiliary_device	*adev;
+	struct xsc_adev *xsc_adev;
+	int ret;
+
+	if (!xdev->xsc_adev_list)
+		return -ENODEV;
+
+	if (xdev->xsc_adev_list[idx])
+		return 0;
+
+	xsc_adev = kzalloc_obj(*xsc_adev, GFP_KERNEL);
+	if (!xsc_adev)
+		return -ENOMEM;
+
+	adev = &xsc_adev->adev;
+	adev->name = xsc_adev_name[idx];
+	adev->id = xdev->adev_id;
+	adev->dev.parent = &xdev->pdev->dev;
+	adev->dev.release = xsc_release_adev;
+	xsc_adev->xdev = xdev;
+	xsc_adev->idx = idx;
+
+	ret = auxiliary_device_init(adev);
+	if (ret) {
+		kfree(xsc_adev);
+		return ret;
+	}
+
+	ret = auxiliary_device_add(adev);
+	if (ret) {
+		auxiliary_device_uninit(adev);
+		return ret;
+	}
+
+	xdev->xsc_adev_list[idx] = xsc_adev;
+
+	return 0;
+}
+
+void xsc_adev_del(struct xsc_core_device *xdev, int idx)
+{
+	struct xsc_adev *xsc_adev;
+	struct auxiliary_device *adev;
+
+	if (!xdev->xsc_adev_list)
+		return;
+
+	xsc_adev = xdev->xsc_adev_list[idx];
+	if (!xsc_adev)
+		return;
+
+	/* Clear the slot before teardown: the driver's remove callback runs
+	 * synchronously inside auxiliary_device_delete() and may re-enter
+	 * xsc_adev_add() for this index.
+	 */
+	xdev->xsc_adev_list[idx] = NULL;
+
+	adev = &xsc_adev->adev;
+	auxiliary_device_delete(adev);
+	auxiliary_device_uninit(adev);
+}
+
+int xsc_adev_init(struct xsc_core_device *xdev)
+{
+	struct xsc_adev **xsc_adev_list;
+	int adev_id;
+	int ret;
+
+	xsc_adev_list = kcalloc(ARRAY_SIZE(xsc_adev_name),
+				sizeof(struct xsc_adev *),
+				GFP_KERNEL);
+	if (!xsc_adev_list)
+		return -ENOMEM;
+	xdev->xsc_adev_list = xsc_adev_list;
+
+	adev_id = ida_alloc(&xsc_adev_ida, GFP_KERNEL);
+	if (adev_id < 0) {
+		ret = adev_id;
+		goto err_free_adev_list;
+	}
+	xdev->adev_id = adev_id;
+
+	ret = xsc_adev_add(xdev, XSC_ADEV_IDX_ETH);
+	if (ret)
+		goto err_dalloc_adev_id;
+
+	ret = xsc_adev_add(xdev, XSC_ADEV_IDX_IB);
+	if (ret)
+		goto err_unreg_eth_adev;
+
+	return 0;
+
+err_unreg_eth_adev:
+	xsc_adev_del(xdev, XSC_ADEV_IDX_ETH);
+err_dalloc_adev_id:
+	ida_free(&xsc_adev_ida, xdev->adev_id);
+err_free_adev_list:
+	kfree(xsc_adev_list);
+	xdev->xsc_adev_list = NULL;
+
+	return ret;
+}
+
+void xsc_adev_uninit(struct xsc_core_device *xdev)
+{
+	if (!xdev->xsc_adev_list)
+		return;
+
+	xsc_adev_del(xdev, XSC_ADEV_IDX_IB);
+	xsc_adev_del(xdev, XSC_ADEV_IDX_ETH);
+	ida_free(&xsc_adev_ida, xdev->adev_id);
+	kfree(xdev->xsc_adev_list);
+	xdev->xsc_adev_list = NULL;
+}
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/adev.h b/drivers/net/ethernet/yunsilicon/xsc/pci/adev.h
new file mode 100644
index 000000000..fb5789ec4
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/adev.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_ADEV_H
+#define __XSC_ADEV_H
+
+#include "common/xsc_core.h"
+
+int xsc_adev_init(struct xsc_core_device *xdev);
+void xsc_adev_uninit(struct xsc_core_device *xdev);
+
+int xsc_adev_add(struct xsc_core_device *xdev, int idx);
+void xsc_adev_del(struct xsc_core_device *xdev, int idx);
+
+#endif
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c b/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c
new file mode 100644
index 000000000..b9d7f8a14
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c
@@ -0,0 +1,237 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+#include <linux/export.h>
+#include <linux/bitmap.h>
+#include <linux/dma-mapping.h>
+#include <linux/vmalloc.h>
+
+#include "alloc.h"
+
+/* Handling for queue buffers -- we allocate a bunch of memory and
+ * register it in a memory region at HCA virtual address 0.  If the
+ * requested size is > max_direct, we split the allocation into
+ * multiple pages, so we don't require too much contiguous memory.
+ */
+int xsc_buf_alloc(struct xsc_core_device *xdev,
+		  unsigned long size,
+		  unsigned long max_direct,
+		  struct xsc_buf *buf)
+{
+	dma_addr_t t;
+
+	buf->size = size;
+	if (size <= max_direct) {
+		buf->nbufs        = 1;
+		buf->npages       = 1;
+		buf->page_shift   = get_order(size) + PAGE_SHIFT;
+		buf->direct.buf   = dma_alloc_coherent(&xdev->pdev->dev,
+						       size,
+						       &t,
+						       GFP_KERNEL);
+		if (!buf->direct.buf)
+			return -ENOMEM;
+
+		buf->direct.map = t;
+
+		while (t & GENMASK(buf->page_shift - 1, 0)) {
+			--buf->page_shift;
+			buf->npages *= 2;
+		}
+	} else {
+		struct page **pages;
+		int i;
+
+		buf->direct.buf  = NULL;
+		buf->nbufs       = DIV_ROUND_UP(size, PAGE_SIZE);
+		buf->npages      = buf->nbufs;
+		buf->page_shift  = PAGE_SHIFT;
+		buf->page_list   = kcalloc(buf->nbufs, sizeof(*buf->page_list),
+					   GFP_KERNEL);
+		if (!buf->page_list)
+			return -ENOMEM;
+
+		for (i = 0; i < buf->nbufs; i++) {
+			buf->page_list[i].buf =
+				dma_alloc_coherent(&xdev->pdev->dev, PAGE_SIZE,
+						   &t, GFP_KERNEL);
+			if (!buf->page_list[i].buf)
+				goto err_free;
+
+			buf->page_list[i].map = t;
+		}
+
+		pages = kmalloc_array(buf->nbufs, sizeof(*pages), GFP_KERNEL);
+		if (!pages)
+			goto err_free;
+		for (i = 0; i < buf->nbufs; i++) {
+			void *addr = buf->page_list[i].buf;
+
+			if (is_vmalloc_addr(addr))
+				pages[i] = vmalloc_to_page(addr);
+			else
+				pages[i] = virt_to_page(addr);
+		}
+		buf->direct.buf = vmap(pages, buf->nbufs, VM_MAP, PAGE_KERNEL);
+		kfree(pages);
+		if (!buf->direct.buf)
+			goto err_free;
+	}
+
+	return 0;
+
+err_free:
+	xsc_buf_free(xdev, buf);
+
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(xsc_buf_alloc);
+
+void xsc_buf_free(struct xsc_core_device *xdev, struct xsc_buf *buf)
+{
+	int i;
+
+	if (buf->nbufs == 1) {
+		dma_free_coherent(&xdev->pdev->dev, buf->size, buf->direct.buf,
+				  buf->direct.map);
+	} else {
+		if (buf->direct.buf)
+			vunmap(buf->direct.buf);
+
+		for (i = 0; i < buf->nbufs; i++)
+			if (buf->page_list[i].buf)
+				dma_free_coherent(&xdev->pdev->dev, PAGE_SIZE,
+						  buf->page_list[i].buf,
+						  buf->page_list[i].map);
+		kfree(buf->page_list);
+	}
+}
+EXPORT_SYMBOL_GPL(xsc_buf_free);
+
+void xsc_fill_page_array(struct xsc_buf *buf, __be64 *pas, unsigned int npages)
+{
+	unsigned int shift = PAGE_SHIFT - XSC_PAGE_SHIFT_4K;
+	unsigned int mask = (1 << shift) - 1;
+	u64 addr;
+	int i;
+
+	for (i = 0; i < npages; i++) {
+		if (buf->nbufs == 1)
+			addr = buf->direct.map + (i << XSC_PAGE_SHIFT_4K);
+		else
+			addr = buf->page_list[i >> shift].map +
+			       ((i & mask) << XSC_PAGE_SHIFT_4K);
+
+		pas[i] = cpu_to_be64(addr);
+	}
+}
+EXPORT_SYMBOL_GPL(xsc_fill_page_array);
+
+void xsc_core_fill_page_frag_array(struct xsc_frag_buf *buf,
+				   __be64 *pas,
+				   unsigned int npages)
+{
+	int i;
+	dma_addr_t addr;
+	unsigned int shift = PAGE_SHIFT - XSC_PAGE_SHIFT_4K;
+	unsigned int mask = (1 << shift) - 1;
+
+	for (i = 0; i < npages; i++) {
+		addr = buf->frags[i >> shift].map +
+			((i & mask) << XSC_PAGE_SHIFT_4K);
+		pas[i] = cpu_to_be64(addr);
+	}
+}
+EXPORT_SYMBOL_GPL(xsc_core_fill_page_frag_array);
+
+static void *xsc_dma_zalloc_coherent_node(struct xsc_core_device *xdev,
+					  size_t size, dma_addr_t *dma_handle,
+					  int node)
+{
+	struct xsc_dev_resource *dev_res = xdev->dev_res;
+	struct device *device = &xdev->pdev->dev;
+	int original_node;
+	void *cpu_handle;
+
+	/* WA for kernels that don't use numa_mem_id in alloc_pages_node */
+	if (node == NUMA_NO_NODE)
+		node = numa_mem_id();
+
+	mutex_lock(&dev_res->alloc_mutex);
+	original_node = dev_to_node(device);
+	set_dev_node(device, node);
+	cpu_handle = dma_alloc_coherent(device, size, dma_handle,
+					GFP_KERNEL);
+	set_dev_node(device, original_node);
+	mutex_unlock(&dev_res->alloc_mutex);
+	return cpu_handle;
+}
+
+int xsc_core_frag_buf_alloc_node(struct xsc_core_device *xdev,
+				 unsigned long size,
+				 struct xsc_frag_buf *buf,
+				 int node)
+{
+	int i;
+
+	buf->size = size;
+	buf->npages = DIV_ROUND_UP(size, PAGE_SIZE);
+	buf->page_shift = PAGE_SHIFT;
+	buf->frags = kcalloc(buf->npages, sizeof(struct xsc_buf_list),
+			     GFP_KERNEL);
+	if (!buf->frags)
+		goto err_out;
+
+	for (i = 0; i < buf->npages; i++) {
+		unsigned long frag_sz = min_t(unsigned long, size, PAGE_SIZE);
+		struct xsc_buf_list *frag = &buf->frags[i];
+
+		frag->buf = xsc_dma_zalloc_coherent_node(xdev, frag_sz,
+							 &frag->map, node);
+		if (!frag->buf)
+			goto err_free_buf;
+		if (frag->map & ((1 << buf->page_shift) - 1)) {
+			dma_free_coherent(&xdev->pdev->dev, frag_sz,
+					  buf->frags[i].buf, buf->frags[i].map);
+			pci_err(xdev->pdev, "unexpected map alignment: %pad, page_shift=%d\n",
+				&frag->map, buf->page_shift);
+			goto err_free_buf;
+		}
+		size -= frag_sz;
+	}
+
+	return 0;
+
+err_free_buf:
+	while (i--)
+		dma_free_coherent(&xdev->pdev->dev,
+				  PAGE_SIZE,
+				  buf->frags[i].buf,
+				  buf->frags[i].map);
+	kfree(buf->frags);
+err_out:
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(xsc_core_frag_buf_alloc_node);
+
+void xsc_core_frag_buf_free(struct xsc_core_device *xdev,
+			    struct xsc_frag_buf *buf)
+{
+	unsigned long size = buf->size;
+	int i;
+
+	for (i = 0; i < buf->npages; i++) {
+		unsigned long frag_sz = min_t(unsigned long, size, PAGE_SIZE);
+
+		dma_free_coherent(&xdev->pdev->dev, frag_sz, buf->frags[i].buf,
+				  buf->frags[i].map);
+		size -= frag_sz;
+	}
+	kfree(buf->frags);
+}
+EXPORT_SYMBOL_GPL(xsc_core_frag_buf_free);
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.h b/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.h
new file mode 100644
index 000000000..aef39e632
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_ALLOC_H
+#define __XSC_ALLOC_H
+
+#include "common/xsc_core.h"
+
+int xsc_buf_alloc(struct xsc_core_device *xdev,
+		  unsigned long size,
+		  unsigned long max_direct,
+		  struct xsc_buf *buf);
+void xsc_buf_free(struct xsc_core_device *xdev, struct xsc_buf *buf);
+void xsc_fill_page_array(struct xsc_buf *buf, __be64 *pas, unsigned int npages);
+#endif
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/cq.h b/drivers/net/ethernet/yunsilicon/xsc/pci/cq.h
new file mode 100644
index 000000000..afe6cbb0d
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/cq.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_CQ_H
+#define __XSC_CQ_H
+
+#include "common/xsc_core.h"
+
+void xsc_init_cq_table(struct xsc_core_device *xdev);
+
+int xsc_core_create_cq(struct xsc_core_device *xdev, struct xsc_core_cq *cq,
+		       struct xsc_create_cq_ex_mbox_in *in, int inlen);
+int xsc_core_destroy_cq(struct xsc_core_device *xdev, struct xsc_core_cq *cq);
+
+#endif /* __XSC_CQ_H */
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c b/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c
new file mode 100644
index 000000000..63e5bb29f
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c
@@ -0,0 +1,266 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+
+#include "common/xsc_cmd_api.h"
+#include "common/xsc_core.h"
+#include "qp.h"
+#include "alloc.h"
+#include "eq.h"
+#include "hal/xsc_hal.h"
+
+enum {
+	XSC_EQE_SIZE		= sizeof(struct xsc_eqe),
+};
+
+enum {
+	XSC_NUM_SPARE_EQE	= 0x80,
+	XSC_NUM_ASYNC_EQE	= 0x100,
+};
+
+static int xsc_cmd_destroy_eq(struct xsc_core_device *xdev, u32 eqn)
+{
+	struct xsc_destroy_eq_mbox_out out = {0};
+	struct xsc_destroy_eq_mbox_in in = {0};
+
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_DESTROY_EQ);
+	in.eqn = cpu_to_be32(eqn);
+
+	return xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+}
+
+static struct xsc_eqe *get_eqe(struct xsc_eq *eq, u32 entry)
+{
+	return xsc_buf_offset(&eq->buf, entry * XSC_EQE_SIZE);
+}
+
+static struct xsc_eqe *next_eqe_sw(struct xsc_eq *eq)
+{
+	struct xsc_eqe *eqe = get_eqe(eq, eq->cons_index & (eq->nent - 1));
+
+	return (!!(eqe->owner_data & XSC_EQE_OWNER) ^
+		!!(eq->cons_index & eq->nent)) ? NULL : eqe;
+}
+
+static void eq_update_ci(struct xsc_eq *eq, int arm)
+{
+	xsc_update_eq_ci(eq->dev, eq->eqn, eq->cons_index, arm);
+}
+
+static void xsc_cq_completion(struct xsc_core_device *xdev, u32 cqn)
+{
+}
+
+static void xsc_eq_cq_event(struct xsc_core_device *xdev,
+			    u32 cqn, int event_type)
+{
+}
+
+static int xsc_eq_int(struct xsc_core_device *xdev, struct xsc_eq *eq)
+{
+	u32 cqn, queue_id;
+	struct xsc_eqe *eqe;
+	int eqes_found = 0;
+	int set_ci = 0;
+
+	while ((eqe = next_eqe_sw(eq))) {
+		/* Make sure we read EQ entry contents after we've
+		 * checked the ownership bit.
+		 */
+		rmb();
+		switch (eqe->type) {
+		case XSC_EVENT_TYPE_COMP:
+		case XSC_EVENT_TYPE_INTERNAL_ERROR:
+			/* eqe is changing */
+			queue_id = FIELD_GET(XSC_EQE_QUEUE_ID_MASK,
+					     le16_to_cpu(eqe->queue_id_data));
+			cqn = queue_id;
+			xsc_cq_completion(xdev, cqn);
+			break;
+
+		case XSC_EVENT_TYPE_CQ_ERROR:
+			queue_id = FIELD_GET(XSC_EQE_QUEUE_ID_MASK,
+					     le16_to_cpu(eqe->queue_id_data));
+			cqn = queue_id;
+			xsc_eq_cq_event(xdev, cqn, eqe->type);
+			break;
+		default:
+			break;
+		}
+
+		++eq->cons_index;
+		eqes_found = 1;
+		++set_ci;
+
+		/* The HCA will think the queue has overflowed if we
+		 * don't tell it we've been processing events.  We
+		 * create our EQs with XSC_NUM_SPARE_EQE extra
+		 * entries, so we must update our consumer index at
+		 * least that often.
+		 */
+		if (unlikely(set_ci >= XSC_NUM_SPARE_EQE)) {
+			eq_update_ci(eq, 0);
+			set_ci = 0;
+		}
+	}
+
+	eq_update_ci(eq, 1);
+
+	return eqes_found;
+}
+
+static irqreturn_t xsc_msix_handler(int irq, void *eq_ptr)
+{
+	struct xsc_core_device *xdev;
+	struct xsc_eq *eq = eq_ptr;
+
+	xdev = eq->dev;
+	xsc_eq_int(xdev, eq);
+
+	/* MSI-X vectors always belong to us */
+	return IRQ_HANDLED;
+}
+
+static void init_eq_buf(struct xsc_eq *eq)
+{
+	struct xsc_eqe *eqe;
+	int i;
+
+	for (i = 0; i < eq->nent; i++) {
+		eqe = get_eqe(eq, i);
+		eqe->owner_data |= XSC_EQE_OWNER;
+	}
+}
+
+int xsc_create_map_eq(struct xsc_core_device *xdev,
+		      struct xsc_eq *eq, u16 vecidx,
+		      u32 nent, const char *name)
+{
+	u16 msix_vec_offset = xdev->msix_vec_base + vecidx;
+	struct xsc_dev_resource *dev_res = xdev->dev_res;
+	struct xsc_create_eq_mbox_out out;
+	struct xsc_create_eq_mbox_in *in;
+	unsigned int hw_npages;
+	u32 inlen;
+	int err;
+
+	eq->nent = roundup_pow_of_two(roundup(nent, XSC_NUM_SPARE_EQE));
+	err = xsc_buf_alloc(xdev, eq->nent * XSC_EQE_SIZE, PAGE_SIZE, &eq->buf);
+	if (err)
+		return err;
+
+	init_eq_buf(eq);
+
+	hw_npages = DIV_ROUND_UP(eq->nent * XSC_EQE_SIZE, XSC_PAGE_SIZE_4K);
+	inlen = sizeof(*in) + sizeof(in->pas[0]) * hw_npages;
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in) {
+		err = -ENOMEM;
+		goto err_free_eq_buf;
+	}
+	memset(&out, 0, sizeof(out));
+
+	xsc_fill_page_array(&eq->buf, in->pas, hw_npages);
+
+	in->hdr.opcode = cpu_to_be16(XSC_CMD_OP_CREATE_EQ);
+	in->ctx.log_eq_sz = ilog2(eq->nent);
+	in->ctx.vecidx = cpu_to_be16(msix_vec_offset);
+	in->ctx.pa_num = cpu_to_be16(hw_npages);
+	in->ctx.glb_func_id = cpu_to_be16(xdev->glb_func_id);
+	in->ctx.is_async_eq = (vecidx == XSC_EQ_VEC_ASYNC ? 1 : 0);
+
+	err = xsc_cmd_exec(xdev, in, inlen, &out, sizeof(out));
+	if (err)
+		goto err_free_in;
+
+	snprintf(dev_res->irq_info[vecidx].name, XSC_MAX_IRQ_NAME, "%s@pci:%s",
+		 name, pci_name(xdev->pdev));
+
+	eq->eqn = be32_to_cpu(out.eqn);
+	eq->irqn = pci_irq_vector(xdev->pdev, vecidx);
+	eq->dev = xdev;
+	eq->index = vecidx;
+
+	err = request_irq(eq->irqn, xsc_msix_handler, 0,
+			  dev_res->irq_info[vecidx].name, eq);
+	if (err)
+		goto err_destroy_eq;
+
+	/* EQs are created in ARMED state
+	 */
+	eq_update_ci(eq, 1);
+	kvfree(in);
+	return 0;
+
+err_destroy_eq:
+	xsc_cmd_destroy_eq(xdev, eq->eqn);
+
+err_free_in:
+	kvfree(in);
+
+err_free_eq_buf:
+	xsc_buf_free(xdev, &eq->buf);
+	return err;
+}
+
+int xsc_destroy_unmap_eq(struct xsc_core_device *xdev, struct xsc_eq *eq)
+{
+	int err;
+
+	free_irq(eq->irqn, eq);
+	err = xsc_cmd_destroy_eq(xdev, eq->eqn);
+	if (err)
+		pci_err(xdev->pdev, "failed to destroy a previously created eq: eqn %d\n",
+			eq->eqn);
+	xsc_buf_free(xdev, &eq->buf);
+
+	return err;
+}
+
+void xsc_eq_init(struct xsc_core_device *xdev)
+{
+	spin_lock_init(&xdev->dev_res->eq_table.lock);
+}
+
+int xsc_start_eqs(struct xsc_core_device *xdev)
+{
+	struct xsc_eq_table *table = &xdev->dev_res->eq_table;
+	int err;
+
+	err = xsc_create_map_eq(xdev, &table->async_eq, XSC_EQ_VEC_ASYNC,
+				XSC_NUM_ASYNC_EQE, "xsc_async_eq");
+	if (err)
+		pci_err(xdev->pdev, "failed to create async EQ %d\n", err);
+
+	return err;
+}
+
+void xsc_stop_eqs(struct xsc_core_device *xdev)
+{
+	struct xsc_eq_table *table = &xdev->dev_res->eq_table;
+
+	xsc_destroy_unmap_eq(xdev, &table->async_eq);
+}
+
+struct xsc_eq *xsc_core_eq_get(struct xsc_core_device *xdev, int i)
+{
+	struct xsc_eq_table *table = &xdev->dev_res->eq_table;
+	struct xsc_eq *eq_ret = NULL;
+	struct xsc_eq *eq, *n;
+
+	spin_lock(&table->lock);
+	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
+		if (eq->index == i) {
+			eq_ret = eq;
+			break;
+		}
+	}
+	spin_unlock(&table->lock);
+
+	return eq_ret;
+}
+EXPORT_SYMBOL_GPL(xsc_core_eq_get);
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/eq.h b/drivers/net/ethernet/yunsilicon/xsc/pci/eq.h
new file mode 100644
index 000000000..3e7869e12
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/eq.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __EQ_H
+#define __EQ_H
+
+#include "common/xsc_core.h"
+
+enum {
+	XSC_EQ_VEC_ASYNC		= 0,
+	XSC_VEC_CMD			= 1,
+	XSC_VEC_CMD_EVENT		= 2,
+	XSC_DMA_READ_DONE_VEC		= 3,
+	XSC_EQ_VEC_COMP_BASE,
+};
+
+struct xsc_eqe {
+	u8 type;
+	u8 sub_type;
+	__le16 queue_id_data;
+#define XSC_EQE_QUEUE_ID_MASK	GENMASK(14, 0)
+
+	u8 err_code;
+	u8 rsvd[2];
+	u8 owner_data;
+#define XSC_EQE_OWNER		BIT(7)
+};
+
+int xsc_create_map_eq(struct xsc_core_device *xdev,
+		      struct xsc_eq *eq, u16 vecidx,
+		      u32 nent, const char *name);
+int xsc_destroy_unmap_eq(struct xsc_core_device *xdev, struct xsc_eq *eq);
+void xsc_eq_init(struct xsc_core_device *xdev);
+int xsc_start_eqs(struct xsc_core_device *xdev);
+void xsc_stop_eqs(struct xsc_core_device *xdev);
+
+#endif
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
index 53dd8fdf1..9548cb953 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
@@ -6,6 +6,11 @@
 #include "common/xsc_core.h"
 #include "common/xsc_cmd_api.h"
 #include "hw.h"
+#include "qp.h"
+#include "cq.h"
+#include "eq.h"
+#include "pci_irq.h"
+#include "adev.h"
 #include "hal/xsc_hal.h"
 
 static const struct pci_device_id xsc_pci_id_table[] = {
@@ -190,6 +195,8 @@ static int xsc_hw_setup(struct xsc_core_device *xdev)
 		goto err_cmd_cleanup;
 	}
 
+	xsc_eq_init(xdev);
+
 	return 0;
 err_cmd_cleanup:
 	xsc_cmd_cleanup(xdev);
@@ -212,13 +219,31 @@ static int xsc_load(struct xsc_core_device *xdev)
 		goto err_out;
 	}
 
+	err = xsc_irq_eq_create(xdev);
+	if (err) {
+		pci_err(xdev->pdev, "xsc_irq_eq_create failed %d\n", err);
+		goto err_hw_cleanup;
+	}
+
+	err = xsc_adev_init(xdev);
+	if (err) {
+		pci_err(xdev->pdev, "xsc_adev_init failed %d\n", err);
+		goto err_irq_eq_destroy;
+	}
+
 	return 0;
+err_irq_eq_destroy:
+	xsc_irq_eq_destroy(xdev);
+err_hw_cleanup:
+	xsc_hw_cleanup(xdev);
 err_out:
 	return err;
 }
 
 static void xsc_unload(struct xsc_core_device *xdev)
 {
+	xsc_adev_uninit(xdev);
+	xsc_irq_eq_destroy(xdev);
 	xsc_hw_cleanup(xdev);
 }
 
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.c b/drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.c
new file mode 100644
index 000000000..d83f13f38
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.c
@@ -0,0 +1,494 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/irqdomain.h>
+#include <linux/msi.h>
+#include <linux/interrupt.h>
+#include <linux/notifier.h>
+#include <linux/module.h>
+
+#include "common/xsc_cmd_api.h"
+#include "common/xsc_core.h"
+#include "eq.h"
+#include "pci_irq.h"
+#include "hal/xsc_hal.h"
+
+enum {
+	XSC_COMP_EQ_SIZE = 1024,
+};
+
+static void xsc_free_irq(struct xsc_core_device *xdev, unsigned int vector)
+{
+	unsigned int irqn = 0;
+
+	irqn = pci_irq_vector(xdev->pdev, vector);
+	disable_irq(irqn);
+	free_irq(irqn, xdev);
+}
+
+static int set_comp_irq_affinity_hint(struct xsc_core_device *xdev, int i)
+{
+	struct xsc_eq_table *table = &xdev->dev_res->eq_table;
+	struct xsc_eq *eq = xsc_core_eq_get(xdev, i);
+	int vecidx = table->eq_vec_comp_base + i;
+	unsigned int irqn;
+
+	irqn = pci_irq_vector(xdev->pdev, vecidx);
+	if (!zalloc_cpumask_var(&eq->mask, GFP_KERNEL)) {
+		pci_err(xdev->pdev, "zalloc_cpumask_var rx cpumask failed");
+		return -ENOMEM;
+	}
+
+	cpumask_set_cpu(cpumask_local_spread(i, xdev->numa_node), eq->mask);
+	if (irq_set_affinity_hint(irqn, eq->mask))
+		pci_warn(xdev->pdev, "failed to set affinity hint for irq %u\n",
+			 irqn);
+
+	return 0;
+}
+
+static void clear_comp_irq_affinity_hint(struct xsc_core_device *xdev, int i)
+{
+	struct xsc_eq_table *table = &xdev->dev_res->eq_table;
+	struct xsc_eq *eq = xsc_core_eq_get(xdev, i);
+	int vecidx = table->eq_vec_comp_base + i;
+	int irqn;
+
+	irqn = pci_irq_vector(xdev->pdev, vecidx);
+	irq_set_affinity_hint(irqn, NULL);
+	free_cpumask_var(eq->mask);
+}
+
+static int set_comp_irq_affinity_hints(struct xsc_core_device *xdev)
+{
+	struct xsc_eq_table *table = &xdev->dev_res->eq_table;
+	int nvec = table->num_comp_vectors;
+	int err;
+	int i;
+
+	if (!zalloc_cpumask_var(&xdev->xps_cpumask, GFP_KERNEL))
+		return -ENOMEM;
+
+	for (i = 0; i < nvec; i++) {
+		err = set_comp_irq_affinity_hint(xdev, i);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static void clear_comp_irq_affinity_hints(struct xsc_core_device *xdev)
+{
+	struct xsc_eq_table *table = &xdev->dev_res->eq_table;
+	int nvec = table->num_comp_vectors;
+	int i;
+
+	for (i = 0; i < nvec; i++)
+		clear_comp_irq_affinity_hint(xdev, i);
+	free_cpumask_var(xdev->xps_cpumask);
+}
+
+static int xsc_alloc_irq_vectors(struct xsc_core_device *xdev)
+{
+	struct xsc_dev_resource *dev_res = xdev->dev_res;
+	struct xsc_eq_table *table = &dev_res->eq_table;
+	int nvec = xdev->caps.msix_num;
+	int nvec_base;
+	int err;
+
+	nvec_base = XSC_EQ_VEC_COMP_BASE;
+	if (nvec <= nvec_base) {
+		pci_err(xdev->pdev, "failed to alloc irq vector(%d)\n", nvec);
+		return -ENOMEM;
+	}
+
+	dev_res->irq_info = kcalloc(nvec, sizeof(*dev_res->irq_info),
+				    GFP_KERNEL);
+	if (!dev_res->irq_info)
+		return -ENOMEM;
+
+	nvec = pci_alloc_irq_vectors(xdev->pdev, nvec_base + 1, nvec,
+				     PCI_IRQ_MSIX);
+	if (nvec < 0) {
+		err = nvec;
+		goto err_free_irq_info;
+	}
+
+	table->eq_vec_comp_base = nvec_base;
+	table->num_comp_vectors = nvec - nvec_base;
+	/*
+	 * caps.msix_base is the start of this function's slice in the
+	 * firmware's own vector numbering space.  EQ and cmdq setup
+	 * report msix_vec_base + vecidx to the firmware, while the host
+	 * IRQ is requested on MSI-X table entry vecidx; the firmware
+	 * translates back to the host table entry.
+	 */
+	xdev->msix_vec_base = xdev->caps.msix_base;
+
+	return 0;
+
+err_free_irq_info:
+	kfree(dev_res->irq_info);
+	return err;
+}
+
+static void xsc_free_irq_vectors(struct xsc_core_device *xdev)
+{
+	struct xsc_dev_resource *dev_res = xdev->dev_res;
+
+	pci_free_irq_vectors(xdev->pdev);
+	kfree(dev_res->irq_info);
+}
+
+int xsc_core_vector2eqn(struct xsc_core_device *xdev, int vector, u32 *eqn,
+			unsigned int *irqn)
+{
+	struct xsc_eq_table *table = &xdev->dev_res->eq_table;
+	struct xsc_eq *eq, *n;
+	int err = -ENOENT;
+
+	spin_lock(&table->lock);
+	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
+		if (eq->index == vector) {
+			*eqn = eq->eqn;
+			*irqn = eq->irqn;
+			err = 0;
+			break;
+		}
+	}
+	spin_unlock(&table->lock);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(xsc_core_vector2eqn);
+
+int xsc_vector2eqn(struct xsc_core_device *xdev, int vector, int *eqn,
+		   unsigned int *irqn)
+{
+	u32 cqn = 0;
+	int err;
+
+	err = xsc_core_vector2eqn(xdev, vector, &cqn, irqn);
+	if (!err)
+		*eqn = (int)cqn;
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(xsc_vector2eqn);
+
+static void free_comp_eqs(struct xsc_core_device *xdev)
+{
+	struct xsc_eq_table *table = &xdev->dev_res->eq_table;
+	struct xsc_eq *eq, *n;
+
+	spin_lock(&table->lock);
+	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
+		list_del(&eq->list);
+		spin_unlock(&table->lock);
+		if (xsc_destroy_unmap_eq(xdev, eq))
+			pci_err(xdev->pdev, "failed to destroy EQ 0x%x\n",
+				eq->eqn);
+		kfree(eq);
+		spin_lock(&table->lock);
+	}
+	spin_unlock(&table->lock);
+}
+
+static int alloc_comp_eqs(struct xsc_core_device *xdev)
+{
+	struct xsc_eq_table *table = &xdev->dev_res->eq_table;
+	char name[XSC_MAX_IRQ_NAME];
+	struct xsc_eq *eq;
+	int ncomp_vec;
+	u32 nent;
+	int err;
+	int i;
+
+	INIT_LIST_HEAD(&table->comp_eqs_list);
+	ncomp_vec = table->num_comp_vectors;
+	nent = XSC_COMP_EQ_SIZE;
+
+	for (i = 0; i < ncomp_vec; i++) {
+		eq = kzalloc_obj(*eq, GFP_KERNEL);
+		if (!eq) {
+			err = -ENOMEM;
+			goto err_free;
+		}
+
+		snprintf(name, XSC_MAX_IRQ_NAME, "xsc_comp%d", i);
+		err = xsc_create_map_eq(xdev, eq,
+					i + table->eq_vec_comp_base,
+					nent, name);
+		if (err) {
+			kfree(eq);
+			goto err_free;
+		}
+
+		eq->index = i;
+		spin_lock(&table->lock);
+		list_add_tail(&eq->list, &table->comp_eqs_list);
+		spin_unlock(&table->lock);
+	}
+
+	return 0;
+
+err_free:
+	free_comp_eqs(xdev);
+	return err;
+}
+
+static irqreturn_t xsc_cmd_handler(int irq, void *arg)
+{
+	struct xsc_core_device *xdev = (struct xsc_core_device *)arg;
+	int err;
+
+	/* outside events mode the polling kthread owns the command cq */
+	if (xdev->cmd.mode != XSC_CMD_MODE_EVENTS)
+		return IRQ_HANDLED;
+
+	disable_irq_nosync(xdev->cmd.irqn);
+	err = xsc_cmd_err_handler(xdev);
+	if (!err)
+		xsc_cmd_resp_handler(xdev);
+	enable_irq(xdev->cmd.irqn);
+
+	return IRQ_HANDLED;
+}
+
+static int xsc_request_irq_for_cmdq(struct xsc_core_device *xdev, u8 vecidx)
+{
+	struct xsc_dev_resource *dev_res = xdev->dev_res;
+
+	xsc_set_cmdq_msix_vector(xdev, xdev->msix_vec_base + vecidx);
+
+	snprintf(dev_res->irq_info[vecidx].name, XSC_MAX_IRQ_NAME, "%s@pci:%s",
+		 "xsc_cmd", pci_name(xdev->pdev));
+	xdev->cmd.irqn = pci_irq_vector(xdev->pdev, vecidx);
+	return request_irq(xdev->cmd.irqn, xsc_cmd_handler, 0,
+		dev_res->irq_info[vecidx].name, xdev);
+}
+
+static void xsc_free_irq_for_cmdq(struct xsc_core_device *xdev)
+{
+	xsc_free_irq(xdev, XSC_VEC_CMD);
+}
+
+/*
+ * Handle an asynchronous event. This runs on the PCI layer's own workqueue,
+ * so it outlives any auxiliary driver: the driver only ever registers a
+ * callback here, and the memory this touches belongs to xsc_core_device
+ * rather than to the eth or RDMA private area.
+ */
+static void xsc_event_work(struct work_struct *work)
+{
+	struct xsc_core_device *xdev = container_of(work, struct xsc_core_device,
+						    event_work);
+	struct xsc_event_query_type_mbox_out out = {};
+	struct xsc_event_query_type_mbox_in in = {};
+	u8 event;
+	int err;
+
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_QUERY_EVENT_TYPE);
+
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+	if (err || out.hdr.status) {
+		pci_err(xdev->pdev, "failed to query event type, err=%d, status=%d\n",
+			err, out.hdr.status);
+		return;
+	}
+
+	event = out.ctx.resp_cmd_type;
+	while (event) {
+		if (event & XSC_CMD_EVENT_RESP_CHANGE_LINK) {
+			void (*handler)(void *xdev);
+
+			handler = READ_ONCE(xdev->link_event_handler);
+			if (handler)
+				handler(xdev);
+			event &= ~XSC_CMD_EVENT_RESP_CHANGE_LINK;
+		} else if (event & XSC_CMD_EVENT_RESP_TEMP_WARN) {
+			pci_warn(xdev->pdev, "[Minor]nic chip temperature high warning\n");
+			event &= ~XSC_CMD_EVENT_RESP_TEMP_WARN;
+		} else if (event & XSC_CMD_EVENT_RESP_OVER_TEMP_PROTECTION) {
+			pci_warn(xdev->pdev, "[Critical]nic chip was over-temperature\n");
+			event &= ~XSC_CMD_EVENT_RESP_OVER_TEMP_PROTECTION;
+		} else {
+			pci_dbg(xdev->pdev, "unknown event cmdtype=0x%x\n",
+				out.ctx.resp_cmd_type);
+			event = 0;
+		}
+	}
+}
+
+static irqreturn_t xsc_event_handler(int irq, void *arg)
+{
+	struct xsc_core_device *xdev = (struct xsc_core_device *)arg;
+
+	queue_work(xdev->event_wq, &xdev->event_work);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * Register the link event callback.
+ *
+ * The events are dispatched from the PCI layer's own workqueue, whose
+ * contents are not the client's business (it also carries the temperature
+ * warnings, which are logged here), so the client must not touch
+ * xdev->event_wq itself.
+ */
+void xsc_irq_event_register(struct xsc_core_device *xdev,
+			    void (*handler)(void *xdev))
+{
+	WRITE_ONCE(xdev->link_event_handler, handler);
+}
+EXPORT_SYMBOL_GPL(xsc_irq_event_register);
+
+/*
+ * Detach the callback and wait for an event that is already in flight to
+ * finish with it, in the same way free_irq() both unregisters and waits.
+ * Must be called before the caller frees whatever its handler dereferences.
+ * Safe to call when no handler is registered.
+ */
+void xsc_irq_event_unregister(struct xsc_core_device *xdev)
+{
+	WRITE_ONCE(xdev->link_event_handler, NULL);
+
+	/* Only exists once MSI-X, which requests the event IRQ, is up. */
+	if (xdev->event_wq)
+		flush_workqueue(xdev->event_wq);
+}
+EXPORT_SYMBOL_GPL(xsc_irq_event_unregister);
+
+static int xsc_request_irq_for_event(struct xsc_core_device *xdev)
+{
+	struct xsc_dev_resource *dev_res = xdev->dev_res;
+
+	snprintf(dev_res->irq_info[XSC_VEC_CMD_EVENT].name,
+		 XSC_MAX_IRQ_NAME, "%s@pci:%s",
+		 "xsc_eth_event", pci_name(xdev->pdev));
+	return request_irq(pci_irq_vector(xdev->pdev, XSC_VEC_CMD_EVENT),
+			   xsc_event_handler, 0,
+			   dev_res->irq_info[XSC_VEC_CMD_EVENT].name, xdev);
+}
+
+static void xsc_free_irq_for_event(struct xsc_core_device *xdev)
+{
+	xsc_free_irq(xdev, XSC_VEC_CMD_EVENT);
+}
+
+static int xsc_cmd_enable_msix(struct xsc_core_device *xdev)
+{
+	struct xsc_msix_table_info_mbox_out out;
+	struct xsc_msix_table_info_mbox_in in;
+	int err;
+
+	memset(&in, 0, sizeof(in));
+	memset(&out, 0, sizeof(out));
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_ENABLE_MSIX);
+
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+	if (err) {
+		pci_err(xdev->pdev, "xsc_cmd_exec enable msix failed %d\n",
+			err);
+		return err;
+	}
+
+	return 0;
+}
+
+int xsc_irq_eq_create(struct xsc_core_device *xdev)
+{
+	int err;
+
+	err = xsc_alloc_irq_vectors(xdev);
+	if (err) {
+		pci_err(xdev->pdev, "enable msix failed, err=%d\n", err);
+		goto err_out;
+	}
+
+	err = xsc_start_eqs(xdev);
+	if (err) {
+		pci_err(xdev->pdev, "failed to start EQs, err=%d\n", err);
+		goto err_free_irq_vectors;
+	}
+
+	err = alloc_comp_eqs(xdev);
+	if (err) {
+		pci_err(xdev->pdev, "failed to alloc comp EQs, err=%d\n", err);
+		goto err_stop_eqs;
+	}
+
+	err = xsc_request_irq_for_cmdq(xdev, XSC_VEC_CMD);
+	if (err) {
+		pci_err(xdev->pdev, "failed to request irq for cmdq, err=%d\n",
+			err);
+		goto err_free_comp_eqs;
+	}
+
+	xdev->event_wq = create_singlethread_workqueue("xsc_event");
+	if (!xdev->event_wq) {
+		pci_err(xdev->pdev, "failed to create event workqueue\n");
+		err = -ENOMEM;
+		goto err_free_irq_cmdq;
+	}
+	INIT_WORK(&xdev->event_work, xsc_event_work);
+
+	err = xsc_request_irq_for_event(xdev);
+	if (err) {
+		pci_err(xdev->pdev, "failed to request irq for event, err=%d\n",
+			err);
+		goto err_destroy_event_wq;
+	}
+
+	err = set_comp_irq_affinity_hints(xdev);
+	if (err) {
+		pci_err(xdev->pdev, "failed to alloc affinity hint cpumask, err=%d\n",
+			err);
+		goto err_clear_hints;
+	}
+
+	xsc_cmd_use_events(xdev);
+	err = xsc_cmd_enable_msix(xdev);
+	if (err) {
+		pci_err(xdev->pdev, "xsc_cmd_enable_msix failed %d.\n", err);
+		xsc_cmd_use_polling(xdev);
+		goto err_clear_hints;
+	}
+	return 0;
+
+err_clear_hints:
+	clear_comp_irq_affinity_hints(xdev);
+	xsc_free_irq_for_event(xdev);
+err_destroy_event_wq:
+	destroy_workqueue(xdev->event_wq);
+err_free_irq_cmdq:
+	xsc_free_irq_for_cmdq(xdev);
+err_free_comp_eqs:
+	free_comp_eqs(xdev);
+err_stop_eqs:
+	xsc_stop_eqs(xdev);
+err_free_irq_vectors:
+	xsc_free_irq_vectors(xdev);
+err_out:
+	return err;
+}
+
+void xsc_irq_eq_destroy(struct xsc_core_device *xdev)
+{
+	xsc_stop_eqs(xdev);
+	clear_comp_irq_affinity_hints(xdev);
+	free_comp_eqs(xdev);
+
+	/* xsc_free_irq() disables and synchronises the event IRQ, so no new
+	 * work can be queued once this returns.
+	 */
+	xsc_free_irq_for_event(xdev);
+	destroy_workqueue(xdev->event_wq);
+	xdev->event_wq = NULL;
+	xsc_free_irq_for_cmdq(xdev);
+	xsc_free_irq_vectors(xdev);
+}
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.h b/drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.h
new file mode 100644
index 000000000..750251d1b
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_PCI_IRQ_H
+#define __XSC_PCI_IRQ_H
+
+#include "common/xsc_core.h"
+
+int xsc_irq_eq_create(struct xsc_core_device *xdev);
+void xsc_irq_eq_destroy(struct xsc_core_device *xdev);
+int xsc_core_vector2eqn(struct xsc_core_device *xdev, int vector, u32 *eqn,
+			unsigned int *irqn);
+int xsc_vector2eqn(struct xsc_core_device *xdev, int vector, int *eqn,
+		   unsigned int *irqn);
+
+#endif
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/qp.h b/drivers/net/ethernet/yunsilicon/xsc/pci/qp.h
new file mode 100644
index 000000000..08af2008a
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/qp.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_QP_H
+#define __XSC_QP_H
+
+#include "common/xsc_core.h"
+#include "common/xsc_hsi.h"
+
+void xsc_init_qp_table(struct xsc_core_device *xdev);
+void xsc_qp_event(struct xsc_core_device *xdev, u32 qpn, int event_type);
+
+int xsc_core_create_qp(struct xsc_core_device *xdev,
+		       struct xsc_core_qp *qp,
+		       struct xsc_create_qp_mbox_in *in,
+		       int inlen);
+int xsc_core_destroy_qp(struct xsc_core_device *xdev,
+			struct xsc_core_qp *qp);
+int xsc_core_qp_modify(struct xsc_core_device *xdev, enum xsc_qp_state cur_state,
+		       enum xsc_qp_state new_state,
+		       struct xsc_modify_qp_mbox_in *in, int sqd_event,
+		       struct xsc_core_qp *qp);
+int xsc_core_qp_query(struct xsc_core_device *xdev, struct xsc_core_qp *qp,
+		      struct xsc_query_qp_mbox_out *out, int outlen);
+
+#endif /* __XSC_QP_H */
-- 
2.18.4
