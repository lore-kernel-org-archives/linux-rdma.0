Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.57
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705053;
	b=riv8XtU6jpkcEWmfMWCg66vS79yE9h3PWqJB1gSHQO+MvX3udL/AW3ShcS2BxZiy611o
	 8Xl8KQcWzqsJVlqRBYbrEauNrM3S3DzciWkPjluCI0OJ7Fyha1xU7U4hXC4rCivDslxBP
	 ScvKnplynwuiW/H3SQQ0vWDBTreBPMf35W3zXGkBl754UURr/spTeK4sDEOSqwAq4tX5E
	 aUyT77pIrvDNJiaslBsrPAFFI1jRzNCITyob+W84Zg3e+kZ3aMN2F2fqQ16Po6woW0Trv
	 ZPLviy4zvIS8tSx7wnKhtyLqTbsVykx0vFn627quiOoZw1Hd7rLfeD/LBK0qrMl0XXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705053;
	h=DMARC-Filter:DKIM-Signature:Message-Id:Content-Type:In-Reply-To:
	 X-Mailer:X-Original-From:To:Subject:Received:X-Lms-Return-Path:
	 Content-Transfer-Encoding:Date:Mime-Version:From:Cc:References;
	bh=9W1YFPm4ul6NqIOlj0vTONYWZ6D0k+XbCBjuYTz/MFI=;
	b=gb44arhn4MUE2o63I5uczx3gjs2w3usJc+jfXS7IqPM23AR2tJnIlyMN8XaghUQJxzu1
	 aR7V52e9kwMglxxgpmetBEPdjq1LPrQLkQwHqtJBPeDooqopGSeqrIfXEf1dYaqlY2b3G
	 DE13ZveUXH8uekWz0/sbQH8XrnTgyeDQIBXvZnJxD8o71wsgaF4LFBBemF905jhfqH7dT
	 jHi5SXmxmoDBOzn8P3w2/I+PiqmemLdgakppDZqsl+sVV5pq97dW06CNM9U0JWqZcwvz9
	 yk+IidmFG2Z6wfaCV9+dSzDkTNmkesw0xLamNUP4JhEexISri6Vk9p+L5fgCGQR3G4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=BwYDg1HS;
	arc=none smtp.remote-ip=209.127.231.57
Received: from va-2-57.ptr.blmpb.com (va-2-57.ptr.blmpb.com [209.127.231.57])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38AC606A33E
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 14:57:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B38AC606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=BwYDg1HS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1795705048; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=9W1YFPm4ul6NqIOlj0vTONYWZ6D0k+XbCBjuYTz/MFI=;
 b=BwYDg1HSlIK+KCPfJmnnotQneYUdzy5LVpBBfooDqmkWVcXB7si8ywvy58JMt1DLFuXtZE
 mAZ1NVmtUctlOEFK3fY37olEKkWY6fno64y568cINd/8sI1oWz71oys2MHWlFFSFO5nRC3
 bneGczxH7jwQAK/OoqEB5XReMFGV91X/z9gBF9wZVvmQLFf4l0zHl0Qqgi5mGq2S8OFSgy
 3FXirGzJeezp9xUogB+zb3MoQUYLiBpcpbzouPW7EmFU0/dGK7ZjstbwtJ5sAakmt4pYEe
 dFCIZyxOarVFA9NIcSGQJdpiNmJo+rls3GuAPBU5EnOOHYoijzi3eE4dcC0lRg==
Message-Id: <20261126145724.70868-6-tianx@yunsilicon.com>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20261126145711.70868-1-tianx@yunsilicon.com>
X-Mailer: git-send-email 2.25.1
X-Original-From: Xin Tian <tianx@yunsilicon.com>
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>
Subject: [PATCH v2 05/11] net/xsc: add event queues and MSI-X
Received: from DESKTOP-TGBQGEC.localdomain ([183.193.56.110]) by smtp.feishu.cn with ESMTPS; Thu, 26 Nov 2026 22:57:26 +0800
X-Lms-Return-Path: <lba+26b0848d6+865440+vger.kernel.org+tianx@yunsilicon.com>
Content-Transfer-Encoding: 7bit
Date: Thu, 26 Nov 2026 22:57:26 +0800
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
From: "Xin Tian" <tianx@yunsilicon.com>
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>, 
	<kerneljasonxing@gmail.com>
References: <20261126145711.70868-1-tianx@yunsilicon.com>

Create the asynchronous and completion event queues, allocate MSI-X
vectors, and dispatch link events from a workqueue. The command queue
remains polling-only in this series.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 .../ethernet/yunsilicon/xsc/common/xsc_core.h |  77 ++++
 .../net/ethernet/yunsilicon/xsc/pci/Makefile  |   2 +-
 .../net/ethernet/yunsilicon/xsc/pci/alloc.c   | 123 +++++++
 .../net/ethernet/yunsilicon/xsc/pci/alloc.h   |  18 +
 drivers/net/ethernet/yunsilicon/xsc/pci/eq.c  | 217 +++++++++++
 drivers/net/ethernet/yunsilicon/xsc/pci/eq.h  |  38 ++
 .../net/ethernet/yunsilicon/xsc/pci/main.c    |   9 +
 .../net/ethernet/yunsilicon/xsc/pci/pci_irq.c | 345 ++++++++++++++++++
 .../net/ethernet/yunsilicon/xsc/pci/pci_irq.h |  16 +
 9 files changed, 844 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/alloc.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/eq.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/eq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.h

diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
index 1ffbc2daa..212cb2f9c 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
@@ -8,6 +8,9 @@
 
 #include <linux/pci.h>
 #include <linux/bitfield.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/workqueue.h>
 
 #define XSC_PCI_VENDOR_ID		0x1f67
 
@@ -36,12 +39,62 @@ struct xsc_caps {
 
 #define XSC_CAP_MAC_PORT_MASK			GENMASK(15, 8)
 
+enum {
+	XSC_MAX_IRQ_NAME	= 32
+};
+
+/* alloc */
+struct xsc_buf_list {
+	void			*buf;
+	dma_addr_t		map;
+};
+
+struct xsc_buf {
+	struct xsc_buf_list	direct;
+	struct xsc_buf_list	*page_list;
+	unsigned long		nbufs;
+	unsigned long		npages;
+	unsigned long		page_shift;
+	unsigned long		size;
+};
+
+/* eq */
+struct xsc_eq {
+	struct xsc_core_device	*dev;
+	u32			cons_index;
+	struct xsc_buf		buf;
+	unsigned int		irqn;
+	u32			eqn;
+	u32			nent;
+	struct list_head	list;
+	u16			index;
+};
+
+struct xsc_eq_table {
+	struct list_head	comp_eqs_list;
+	struct xsc_eq		async_eq;
+	int			num_comp_vectors;
+	int			eq_vec_comp_base;
+	/* protect EQs list */
+	spinlock_t		lock;
+};
+
+/* irq */
+struct xsc_irq_info {
+	char			name[XSC_MAX_IRQ_NAME];
+};
+
 struct xsc_cmd;
 
 struct xsc_core_device {
 	struct pci_dev		*pdev;
 	struct device		*device;
 
+	/* async event plumbing, owned by the PCI layer */
+	struct work_struct	event_work;
+	struct workqueue_struct	*event_wq;
+	void (*link_event_handler)(void *xdev);
+
 	void __iomem		*bar;
 	int			bar_num;
 
@@ -49,9 +102,12 @@ struct xsc_core_device {
 	u8			pcie_no;
 	u8			pf_id;
 	u16			glb_func_id;
+	u16			msix_vec_base;
 
 	struct xsc_caps		caps;
 	struct xsc_cmd		*cmd;
+	struct xsc_eq_table	eq_table;
+	struct xsc_irq_info	*irq_info;
 };
 
 void xsc_update_tx_db(struct xsc_core_device *xdev, u32 sqn, u32 next_pid);
@@ -69,4 +125,25 @@ void xsc_set_cmdq_rsp_buf_addr(struct xsc_core_device *xdev, u32 haddr, u32 ladd
 u32 xsc_read_cmdq_err_status(struct xsc_core_device *xdev);
 void xsc_clear_cmdq_err_status(struct xsc_core_device *xdev, u32 status);
 
+int xsc_core_vector2eqn(struct xsc_core_device *xdev, int vector, u32 *eqn,
+			unsigned int *irqn);
+
+/*
+ * Link event callback registration. The events are dispatched from the PCI
+ * layer's own workqueue; unregister detaches the callback and waits for one
+ * already in flight, so it must precede freeing what the handler touches.
+ */
+void xsc_irq_event_register(struct xsc_core_device *xdev,
+			    void (*handler)(void *xdev));
+void xsc_irq_event_unregister(struct xsc_core_device *xdev);
+
+static inline void *xsc_buf_offset(struct xsc_buf *buf, unsigned long offset)
+{
+	if (likely(buf->nbufs == 1))
+		return buf->direct.buf + offset;
+	else
+		return buf->page_list[offset >> PAGE_SHIFT].buf +
+			(offset & (PAGE_SIZE - 1));
+}
+
 #endif
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
index e17a10cc1..7a32e0320 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
@@ -6,4 +6,4 @@ ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
 
 obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc_pci.o
 
-xsc_pci-y := main.o cmd.o doorbell.o
+xsc_pci-y := main.o cmd.o eq.o pci_irq.o alloc.o doorbell.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c b/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c
new file mode 100644
index 000000000..46eb0b031
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.c
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ * Copyright (c) 2013-2016, Mellanox Technologies. All rights reserved.
+ */
+
+#include <linux/dma-mapping.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+
+#include "alloc.h"
+
+int xsc_buf_alloc(struct xsc_core_device *xdev,
+		  unsigned long size,
+		  unsigned long max_direct,
+		  struct xsc_buf *buf)
+{
+	dma_addr_t t;
+
+	buf->size = size;
+	if (size <= max_direct) {
+		buf->nbufs      = 1;
+		buf->npages     = 1;
+		buf->page_shift = get_order(size) + PAGE_SHIFT;
+		buf->direct.buf = dma_alloc_coherent(&xdev->pdev->dev, size, &t,
+						     GFP_KERNEL);
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
+		unsigned int i;
+
+		buf->direct.buf = NULL;
+		buf->nbufs      = DIV_ROUND_UP(size, PAGE_SIZE);
+		buf->npages     = buf->nbufs;
+		buf->page_shift = PAGE_SHIFT;
+		buf->page_list  = kcalloc(buf->nbufs, sizeof(*buf->page_list),
+					  GFP_KERNEL);
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
+
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
+
+void xsc_buf_free(struct xsc_core_device *xdev, struct xsc_buf *buf)
+{
+	unsigned int i;
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
+
+void xsc_fill_page_array(struct xsc_buf *buf, __be64 *pas, unsigned int npages)
+{
+	unsigned int shift = PAGE_SHIFT - XSC_PAGE_SHIFT_4K;
+	unsigned int mask = (1 << shift) - 1;
+	unsigned int i;
+	u64 addr;
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
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.h b/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.h
new file mode 100644
index 000000000..c8d65e2fa
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/alloc.h
@@ -0,0 +1,18 @@
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
+
+#endif
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c b/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c
new file mode 100644
index 000000000..875a277a8
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/eq.c
@@ -0,0 +1,217 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ * Copyright (c) 2013-2016, Mellanox Technologies. All rights reserved.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+
+#include "common/xsc_cmd.h"
+#include "common/xsc_core.h"
+#include "alloc.h"
+#include "eq.h"
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
+	struct xsc_destroy_eq_mbox_out out = {};
+	struct xsc_destroy_eq_mbox_in in = {};
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
+static int xsc_eq_int(struct xsc_eq *eq)
+{
+	struct xsc_eqe *eqe;
+	int eqes_found = 0;
+	int set_ci = 0;
+
+	while ((eqe = next_eqe_sw(eq))) {
+		/* Make sure we read EQ entry contents after we've
+		 * checked the ownership bit.
+		 */
+		rmb();
+
+		++eq->cons_index;
+		eqes_found = 1;
+		++set_ci;
+
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
+	struct xsc_eq *eq = eq_ptr;
+
+	xsc_eq_int(eq);
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
+	struct xsc_create_eq_mbox_out out;
+	struct xsc_create_eq_mbox_in *in;
+	unsigned int hw_npages;
+	u32 inlen;
+	int err;
+
+	eq->nent = roundup_pow_of_two(nent + XSC_NUM_SPARE_EQE);
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
+	snprintf(xdev->irq_info[vecidx].name, XSC_MAX_IRQ_NAME, "%s@pci:%s",
+		 name, pci_name(xdev->pdev));
+
+	eq->eqn = be32_to_cpu(out.eqn);
+	eq->irqn = pci_irq_vector(xdev->pdev, vecidx);
+	eq->dev = xdev;
+	eq->index = vecidx;
+
+	err = request_irq(eq->irqn, xsc_msix_handler, 0,
+			  xdev->irq_info[vecidx].name, eq);
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
+	/* CREATE_EQ already reached the firmware; if the rollback DESTROY_EQ
+	 * fails the EQ is still armed and DMAing, so leak its buffer rather
+	 * than free pages the device can still write to.
+	 */
+	if (xsc_cmd_destroy_eq(xdev, eq->eqn)) {
+		kvfree(in);
+		return err;
+	}
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
+	if (err) {
+		pci_err(xdev->pdev, "failed to destroy a previously created eq: eqn %d\n",
+			eq->eqn);
+		/* DESTROY_EQ failed: the EQ is still armed in the firmware and
+		 * keeps DMAing events into this buffer, so leak it instead of
+		 * handing the pages back while the device can still write them.
+		 */
+		return err;
+	}
+	xsc_buf_free(xdev, &eq->buf);
+
+	return 0;
+}
+
+int xsc_start_eqs(struct xsc_core_device *xdev)
+{
+	struct xsc_eq_table *table = &xdev->eq_table;
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
+	struct xsc_eq_table *table = &xdev->eq_table;
+
+	xsc_destroy_unmap_eq(xdev, &table->async_eq);
+}
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/eq.h b/drivers/net/ethernet/yunsilicon/xsc/pci/eq.h
new file mode 100644
index 000000000..e8c4741cf
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/eq.h
@@ -0,0 +1,38 @@
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
+int xsc_start_eqs(struct xsc_core_device *xdev);
+void xsc_stop_eqs(struct xsc_core_device *xdev);
+
+#endif
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
index 42c5a1bae..315f212c1 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
@@ -7,6 +7,8 @@
 
 #include "common/xsc_cmd.h"
 #include "common/xsc_core.h"
+#include "eq.h"
+#include "pci_irq.h"
 
 static const struct pci_device_id xsc_pci_id_table[] = {
 	{ PCI_DEVICE(XSC_PCI_VENDOR_ID, XSC_MC_PF_DEV_ID) },
@@ -160,6 +162,12 @@ static int xsc_pci_init(struct xsc_core_device *xdev,
 		goto err_cmd_cleanup;
 	}
 
+	err = xsc_irq_eq_create(xdev);
+	if (err) {
+		pci_err(pdev, "failed to create irq/eq: err=%d\n", err);
+		goto err_cmd_cleanup;
+	}
+
 	return 0;
 
 err_cmd_cleanup:
@@ -179,6 +187,7 @@ static void xsc_pci_fini(struct xsc_core_device *xdev)
 {
 	struct pci_dev *pdev = xdev->pdev;
 
+	xsc_irq_eq_destroy(xdev);
 	xsc_cmd_cleanup(xdev);
 	pci_iounmap(pdev, xdev->bar);
 	pci_clear_master(pdev);
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.c b/drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.c
new file mode 100644
index 000000000..accc3e56b
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.c
@@ -0,0 +1,345 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ * Copyright (c) 2013-2016, Mellanox Technologies. All rights reserved.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/irqdomain.h>
+#include <linux/module.h>
+#include <linux/msi.h>
+#include <linux/slab.h>
+
+#include "common/xsc_cmd.h"
+#include "common/xsc_core.h"
+#include "eq.h"
+#include "pci_irq.h"
+
+enum {
+	XSC_COMP_EQ_SIZE = 1024,
+};
+
+static void xsc_free_irq(struct xsc_core_device *xdev, unsigned int vector)
+{
+	unsigned int irqn = pci_irq_vector(xdev->pdev, vector);
+
+	disable_irq(irqn);
+	free_irq(irqn, xdev);
+}
+
+static int xsc_alloc_irq_vectors(struct xsc_core_device *xdev)
+{
+	struct xsc_eq_table *table = &xdev->eq_table;
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
+	xdev->irq_info = kcalloc(nvec, sizeof(*xdev->irq_info), GFP_KERNEL);
+	if (!xdev->irq_info)
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
+	 * firmware's own vector numbering space.  EQ setup reports
+	 * msix_vec_base + vecidx to the firmware, while the host IRQ is
+	 * requested on MSI-X table entry vecidx; the firmware translates
+	 * back to the host table entry.
+	 */
+	xdev->msix_vec_base = xdev->caps.msix_base;
+
+	return 0;
+
+err_free_irq_info:
+	kfree(xdev->irq_info);
+	xdev->irq_info = NULL;
+	return err;
+}
+
+static void xsc_free_irq_vectors(struct xsc_core_device *xdev)
+{
+	pci_free_irq_vectors(xdev->pdev);
+	kfree(xdev->irq_info);
+	xdev->irq_info = NULL;
+}
+
+int xsc_core_vector2eqn(struct xsc_core_device *xdev, int vector, u32 *eqn,
+			unsigned int *irqn)
+{
+	struct xsc_eq_table *table = &xdev->eq_table;
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
+static void free_comp_eqs(struct xsc_core_device *xdev)
+{
+	struct xsc_eq_table *table = &xdev->eq_table;
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
+	struct xsc_eq_table *table = &xdev->eq_table;
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
+/*
+ * Handle an asynchronous event. This runs on the PCI layer's own workqueue,
+ * so it outlives any auxiliary driver: the driver only ever registers a
+ * callback here, and the memory this touches belongs to xsc_core_device
+ * rather than to the eth private area.
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
+	if (err) {
+		pci_err(xdev->pdev, "failed to query event type, err=%d\n", err);
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
+	struct xsc_core_device *xdev = arg;
+
+	queue_work(xdev->event_wq, &xdev->event_work);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * Register the link event callback.
+ *
+ * The events are dispatched from the PCI layer's own workqueue, so the
+ * client must not touch xdev->event_wq itself.
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
+	flush_workqueue(xdev->event_wq);
+}
+EXPORT_SYMBOL_GPL(xsc_irq_event_unregister);
+
+static int xsc_request_irq_for_event(struct xsc_core_device *xdev)
+{
+	snprintf(xdev->irq_info[XSC_VEC_CMD_EVENT].name, XSC_MAX_IRQ_NAME,
+		 "%s@pci:%s", "xsc_eth_event", pci_name(xdev->pdev));
+	return request_irq(pci_irq_vector(xdev->pdev, XSC_VEC_CMD_EVENT),
+			   xsc_event_handler, 0,
+			   xdev->irq_info[XSC_VEC_CMD_EVENT].name, xdev);
+}
+
+static void xsc_free_irq_for_event(struct xsc_core_device *xdev)
+{
+	xsc_free_irq(xdev, XSC_VEC_CMD_EVENT);
+}
+
+static int xsc_cmd_enable_msix(struct xsc_core_device *xdev)
+{
+	struct xsc_msix_table_info_mbox_out out = {};
+	struct xsc_msix_table_info_mbox_in in = {};
+	int err;
+
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
+	spin_lock_init(&xdev->eq_table.lock);
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
+	xdev->event_wq = create_singlethread_workqueue("xsc_event");
+	if (!xdev->event_wq) {
+		pci_err(xdev->pdev, "failed to create event workqueue\n");
+		err = -ENOMEM;
+		goto err_free_comp_eqs;
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
+	err = xsc_cmd_enable_msix(xdev);
+	if (err) {
+		pci_err(xdev->pdev, "xsc_cmd_enable_msix failed %d.\n", err);
+		goto err_free_irq_event;
+	}
+	return 0;
+
+err_free_irq_event:
+	xsc_free_irq_for_event(xdev);
+err_destroy_event_wq:
+	destroy_workqueue(xdev->event_wq);
+	xdev->event_wq = NULL;
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
+	free_comp_eqs(xdev);
+
+	/* xsc_free_irq() disables and synchronises the event IRQ, so no new
+	 * work can be queued once this returns.
+	 */
+	xsc_free_irq_for_event(xdev);
+	destroy_workqueue(xdev->event_wq);
+	xdev->event_wq = NULL;
+	xsc_free_irq_vectors(xdev);
+}
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.h b/drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.h
new file mode 100644
index 000000000..293269b6c
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/pci_irq.h
@@ -0,0 +1,16 @@
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
+
+#endif
-- 
2.43.0
