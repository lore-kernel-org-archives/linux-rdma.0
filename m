Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.38
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793807851;
	b=FCxLG103iETzBCGKdTPIB223D4/pFA9ssfA0CcIYtlYL4XXuCGEtLjJLD3oOqOV/dMYQ
	 QZpcRfSf7qeJB1pgcV5DB8wV1PoOEMdRNXAWznkws7PScm5XMmrZlE4jqDXtoNJl3sN87
	 nwK6Xaq9323IkT5NZzA+U5TrrEHtgoYLQC0eus3uPG9aIw0DhWnsD+eOK4BgwkizhOxF+
	 QFkPTAu4nnNC2xue/bsH4f9EVdJsNg40cEjHHx/iVf10jBO18LaegJNRC2TNcW3V5AX2I
	 2WyPogKE8immB2JKFUvRaB9zxW0X4CaQh2qkawNnqsAVKtCNom1+D9wTigcRDB0Iw8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793807851;
	h=DMARC-Filter:DKIM-Signature:Received:X-Original-From:
	 Content-Transfer-Encoding:From:Date:References:X-Mailer:In-Reply-To:
	 Cc:Subject:Mime-Version:X-Lms-Return-Path:Message-Id:To:Content-Type;
	bh=KwvE1Rtfvx8RtmOkLLUMIr1l0rwVHpeAIy8EjVg92uA=;
	b=254/LplKfLjVTZ1jay86BnZHpY++JXwhKEA202evFQcIt/R8jEzS/AKpi8UduV0n5x8v
	 UQ/8GSIdNk1Vblpqh8HdjsvcRNlp+IJfP6vUd+xsSKKIogCLZgpP362zIA9G1SityM+jX
	 gg96deT2mTgJ7BeJDlX0pn5ELKb72tJsWvkNLDwec6l3fIWjzsQT5jPFhJyiNVornlOdg
	 SDM+H84fCPS3y56MCoQWjXgTut00owkxsZ5q9i3Ptf/S7K7gxWKdyeuBqvpDgRMWMJABs
	 Wgi+jsepPKm1eepKPD5c9N8yTlzZ0Zji33BuOWbyDOW5BSCo0SecoxoxuMK5KiYqqZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=Su5O73Dc;
	arc=none smtp.remote-ip=209.127.231.38
Received: from va-2-38.ptr.blmpb.com (va-2-38.ptr.blmpb.com [209.127.231.38])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4EB606A32D
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 15:57:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B4EB606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=Su5O73Dc
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1793807839; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=KwvE1Rtfvx8RtmOkLLUMIr1l0rwVHpeAIy8EjVg92uA=;
 b=Su5O73DcxTG/n3p3crQBe+E7sBc1vCHS+y4r70IeAMj1j/S6ERujekIT6Q14d+cw4VNmrx
 6+WRoRe+6JiFhT1uvDkzt08oQ46EGA5FWXB4N0WMkrmiSCHBykcjr8tlxVxghHmEAE7z1l
 sn6xxbeMtrCYVX/2RvoVPWznZHOBAPuplh2iROSG1FZnOCXFjrf69QWDrYQZ3OaiqxxsG9
 gGXbpKAdiM+JlqSmsnTuehrFuuOhh4SWnKGZpD6Wgdom8jGe3XiYu3RgaNGHEoZnnaSUqw
 l60qx5Pog65IqSs9gaamoQ8DaFB/Kc+lg6wcR0WwIWPoSQYjMKlC8uXKdyLWzg==
Received: from sw-dev-sha252.yunsilicon.com ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Wed, 04 Nov 2026 23:57:16 +0800
X-Original-From: Xin Tian <tianx@yunsilicon.com>
Content-Transfer-Encoding: 7bit
From: "Xin Tian" <tianx@yunsilicon.com>
Date: Wed, 04 Nov 2026 23:57:17 +0800
References: <20261104155650.37053-1-tianx@yunsilicon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261104155650.37053-1-tianx@yunsilicon.com>
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Subject: [PATCH v1 11/15] RDMA/xsc: add RDMA PD/MR
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26aeb55dd+51f9fa+vger.kernel.org+tianx@yunsilicon.com>
Message-Id: <20261104155715.37053-12-tianx@yunsilicon.com>
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>
Content-Type: text/plain; charset=UTF-8

Implement the protection domain and memory region verbs.

alloc_pd allocates a PD through firmware and returns its number to
userspace.  Before ib_register_device(), register the implicit local
DMA MR with mkey 0xFF covering the whole device: the MAD agent posts
QP1 traffic the moment registration returns and assumes lkey 0xFF is
valid, so it must exist by then.

User MRs are registered by building a firmware mailbox with the DMA
address list from the umem.  The page size is selected with
ib_umem_find_best_pgsz() among the 4K/64K/2M/1G sizes the device
supports, the page list is bounded by the firmware MTT capacity, and
the variable-length mailbox size is checked for overflow before
allocation.  dmabuf-backed MRs use ib_umem_dmabuf_get_pinned() and
share the same registration path.  get_dma_mr registers a whole-
device implicitly mapped MR for kernel callers.  Deregistration
releases the MPT/MTT and destroys the mkey.

On the core side, add the PD and MR firmware commands: mkey values
are allocated under a lock as a key byte combined with a hardware
index, and registration programs the MPT then writes the page
address list in chunks bounded by the maximum command payload,
rolling back the registration if a chunk fails.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 drivers/infiniband/hw/xsc/Makefile            |   2 +-
 drivers/infiniband/hw/xsc/main.c              |  45 +++
 drivers/infiniband/hw/xsc/mem.c               | 160 +++++++++
 drivers/infiniband/hw/xsc/mr.c                | 335 ++++++++++++++++++
 drivers/infiniband/hw/xsc/xsc_ib.h            |   2 +-
 .../ethernet/yunsilicon/xsc/common/driver.h   |   1 +
 .../net/ethernet/yunsilicon/xsc/pci/Makefile  |   2 +-
 drivers/net/ethernet/yunsilicon/xsc/pci/cq.c  |   8 +-
 drivers/net/ethernet/yunsilicon/xsc/pci/mr.c  | 202 +++++++++++
 drivers/net/ethernet/yunsilicon/xsc/pci/mr.h  |  18 +
 drivers/net/ethernet/yunsilicon/xsc/pci/pd.c  |  49 +++
 drivers/net/ethernet/yunsilicon/xsc/pci/pd.h  |  14 +
 12 files changed, 831 insertions(+), 7 deletions(-)
 create mode 100644 drivers/infiniband/hw/xsc/mem.c
 create mode 100644 drivers/infiniband/hw/xsc/mr.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/mr.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/mr.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/pd.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/pd.h

diff --git a/drivers/infiniband/hw/xsc/Makefile b/drivers/infiniband/hw/xsc/Makefile
index 6c4ec1ca0..b535a6653 100644
--- a/drivers/infiniband/hw/xsc/Makefile
+++ b/drivers/infiniband/hw/xsc/Makefile
@@ -6,4 +6,4 @@ ccflags-y := -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
 
 obj-$(CONFIG_INFINIBAND_XSC) += xsc_ib.o
 
-xsc_ib-y := main.o
+xsc_ib-y := main.o mem.o mr.o
diff --git a/drivers/infiniband/hw/xsc/main.c b/drivers/infiniband/hw/xsc/main.c
index 322fad38b..a212a5888 100644
--- a/drivers/infiniband/hw/xsc/main.c
+++ b/drivers/infiniband/hw/xsc/main.c
@@ -391,6 +391,40 @@ static int xsc_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vma
 				 NULL);
 }
 
+int xsc_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
+{
+	struct ib_device *ibdev = ibpd->device;
+	struct xsc_ib_alloc_pd_resp resp;
+	struct xsc_ib_pd *pd;
+	int err;
+
+	pd = to_xpd(ibpd);
+
+	err = xsc_core_alloc_pd(to_xdev(ibdev)->xdev, &pd->pdn);
+	if (err)
+		return err;
+
+	if (udata) {
+		resp.pdn = pd->pdn;
+		if (ib_copy_to_udata(udata, &resp, sizeof(resp))) {
+			xsc_core_dealloc_pd(to_xdev(ibdev)->xdev, pd->pdn);
+			return -EFAULT;
+		}
+	} else {
+		pd->pa_lkey = 0;
+	}
+
+	return 0;
+}
+
+int xsc_ib_dealloc_pd(struct ib_pd *pd, struct ib_udata *udata)
+{
+	struct xsc_ib_dev *dev = to_xdev(pd->device);
+	struct xsc_ib_pd *xpd = to_xpd(pd);
+
+	return xsc_core_dealloc_pd(dev->xdev, xpd->pdn);
+}
+
 static int xsc_port_immutable(struct ib_device *ibdev, u32 port_num,
 			      struct ib_port_immutable *immutable)
 {
@@ -475,15 +509,22 @@ static void xsc_ib_dev_setting(struct xsc_ib_dev *dev)
 	dev->ib_dev.ops.dealloc_ucontext = xsc_ib_dealloc_ucontext;
 	dev->ib_dev.ops.mmap		= xsc_ib_mmap;
 
+	dev->ib_dev.ops.alloc_pd		= xsc_ib_alloc_pd;
+	dev->ib_dev.ops.dealloc_pd		= xsc_ib_dealloc_pd;
 
 	dev->ib_dev.ops.get_link_layer	= xsc_ib_port_link_layer;
 
+	dev->ib_dev.ops.get_dma_mr		= xsc_ib_get_dma_mr;
+	dev->ib_dev.ops.reg_user_mr		= xsc_ib_reg_user_mr; /* optional */
+	dev->ib_dev.ops.reg_user_mr_dmabuf	= xsc_ib_reg_user_mr_dmabuf;
+	dev->ib_dev.ops.dereg_mr		= xsc_ib_dereg_mr;
 
 	dev->ib_dev.ops.get_port_immutable		= xsc_port_immutable;
 
 	dev->ib_dev.ops.get_dev_fw_str	= xsc_ib_get_dev_fw_str;
 
 	dev->ib_dev.ops INIT_RDMA_OBJ_SIZE(ib_ucontext, xsc_ib_ucontext, ibucontext);
+	dev->ib_dev.ops INIT_RDMA_OBJ_SIZE(ib_pd, xsc_ib_pd, ibpd);
 }
 
 /*
@@ -616,6 +657,10 @@ static int init_one(struct xsc_core_device *xdev,
 	if (err)
 		goto err_free;
 
+	err = xsc_reg_local_dma_mr(xdev);
+	if (err)
+		goto err_free;
+
 	init_iommu_state(dev, xdev->device);
 	err = ib_register_device(&dev->ib_dev, dev->ib_dev.name,
 				 dev->xdev->device);
diff --git a/drivers/infiniband/hw/xsc/mem.c b/drivers/infiniband/hw/xsc/mem.c
new file mode 100644
index 000000000..cb1376648
--- /dev/null
+++ b/drivers/infiniband/hw/xsc/mem.c
@@ -0,0 +1,160 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/module.h>
+#include <rdma/ib_umem.h>
+#include "xsc_ib.h"
+
+/**
+ * __xsc_ib_cont_pages - scan a umem for compound pages
+ * @umem: umem object to scan
+ * @addr: ib virtual address requested by the user
+ * @max_page_shift: upper limit for the detected page shift, 0 for none
+ * @count: number of PAGE_SIZE pages covered by umem
+ * @shift: page shift for the compound pages found in the region
+ * @ncont: number of compound pages
+ */
+static void __xsc_ib_cont_pages(struct ib_umem *umem, u64 addr,
+				unsigned long max_page_shift,
+				int *count, int *shift, int *ncont)
+{
+	unsigned long tmp;
+	unsigned long m;
+	u64 base = ~0, p = 0;
+	u64 len, pfn;
+	int i = 0;
+	struct scatterlist *sg;
+	int entry;
+	/* TODO: need peer mem support */
+	unsigned long page_shift = PAGE_SHIFT;
+
+	addr = addr >> page_shift;
+	tmp = (unsigned long)addr;
+	m = find_first_bit(&tmp, BITS_PER_LONG);
+	if (max_page_shift)
+		m = min_t(unsigned long, max_page_shift - page_shift, m);
+	for_each_sgtable_dma_sg(&umem->sgt_append.sgt, sg, entry) {
+		len = sg_dma_len(sg) >> page_shift;
+		pfn = sg_dma_address(sg) >> page_shift;
+		if (base + p != pfn) {
+			/* If either the offset or the new
+			 * base are unaligned update m
+			 */
+			tmp = (unsigned long)(pfn | p);
+			if (!IS_ALIGNED(tmp, 1UL << m))
+				m = find_first_bit(&tmp, BITS_PER_LONG);
+
+			base = pfn;
+			p = 0;
+		}
+
+		p += len;
+		i += len;
+	}
+
+	if (i) {
+		m = min_t(unsigned long, ilog2(roundup_pow_of_two(i)), m);
+		*ncont = DIV_ROUND_UP(i, (1 << m));
+	} else {
+		m = 0;
+		*ncont = 0;
+	}
+	*shift = page_shift + m;
+	*count = i;
+}
+
+void xsc_ib_cont_pages(struct ib_umem *umem, u64 addr,
+		       int *count, int *shift, int *ncont)
+{
+	/* no limit for page_shift */
+	__xsc_ib_cont_pages(umem, addr, 0, count, shift, ncont);
+}
+
+static void __xsc_ib_populate_pas(struct xsc_ib_dev *dev, struct ib_umem *umem,
+				  int page_shift, size_t offset, size_t num_pages,
+				  __be64 *pas, int access_flags, bool need_to_devide)
+{
+	unsigned long umem_page_shift = PAGE_SHIFT;
+	int shift = page_shift - umem_page_shift;
+	int mask = (1 << shift) - 1;
+	int i = 0;
+	int k, idx;
+	u64 cur = 0;
+	u64 base;
+	int len;
+	struct scatterlist *sg;
+	int entry;
+
+	for_each_sgtable_dma_sg(&umem->sgt_append.sgt, sg, entry) {
+		if (need_to_devide)
+			len = sg_dma_len(sg) >> XSC_PAGE_SHIFT_4K;
+		else
+			len = sg_dma_len(sg) >> umem_page_shift;
+		base = sg_dma_address(sg);
+
+		/* Skip elements below offset */
+		if (i + len < offset << shift) {
+			i += len;
+			continue;
+		}
+
+		/* Skip pages below offset */
+		if (i < offset << shift) {
+			k = (offset << shift) - i;
+			i = offset << shift;
+		} else {
+			k = 0;
+		}
+
+		for (; k < len; k++) {
+			if (!(i & mask)) {
+				if (need_to_devide)
+					cur = base + (k << XSC_PAGE_SHIFT_4K);
+				else
+					cur = base + (k << umem_page_shift);
+				cur |= access_flags;
+				idx = (i >> shift) - offset;
+
+				pas[idx] = cpu_to_be64(cur);
+				ibdev_dbg(&dev->ib_dev, "pas[%d] 0x%llx\n",
+					  i >> shift, be64_to_cpu(pas[idx]));
+			}
+			i++;
+
+			/* Stop after num_pages reached */
+			if (i >> shift >= offset + num_pages)
+				return;
+		}
+	}
+}
+
+void xsc_ib_populate_pas(struct xsc_ib_dev *dev, struct ib_umem *umem,
+			 int page_shift, __be64 *pas, int npages, bool need_to_devide)
+{
+	return __xsc_ib_populate_pas(dev, umem, page_shift, 0,
+				     npages, pas, 0, need_to_devide);
+}
+
+int xsc_ib_get_buf_offset(u64 addr, int page_shift, u32 *offset)
+{
+	u64 page_size;
+	u64 page_mask;
+	u64 off_size;
+	u64 off_mask;
+	u64 buf_off;
+
+	page_size = 1ULL << page_shift;
+	page_mask = page_size - 1;
+	buf_off = addr & page_mask;
+	off_size = page_size >> 6;
+	off_mask = off_size - 1;
+
+	if (buf_off & off_mask)
+		return -EINVAL;
+
+	*offset = buf_off >> ilog2(off_size);
+	return 0;
+}
diff --git a/drivers/infiniband/hw/xsc/mr.c b/drivers/infiniband/hw/xsc/mr.c
new file mode 100644
index 000000000..b5dc088fc
--- /dev/null
+++ b/drivers/infiniband/hw/xsc/mr.c
@@ -0,0 +1,335 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/kref.h>
+#include <linux/random.h>
+#include <linux/debugfs.h>
+#include <linux/export.h>
+#include <linux/dma-buf.h>
+#include <linux/dma-resv.h>
+#include <rdma/ib_umem.h>
+#include <rdma/iter.h>
+#include "common/xsc_cmd.h"
+#include <linux/dma-direct.h>
+#include "xsc_ib.h"
+
+enum {
+	DEF_CACHE_SIZE	= 10,
+};
+
+struct ib_mr *xsc_ib_get_dma_mr(struct ib_pd *pd, int acc)
+{
+	struct xsc_ib_dev *dev = to_xdev(pd->device);
+	struct xsc_core_device *xdev = dev->xdev;
+	struct xsc_register_mr_mbox_in *in;
+	struct xsc_register_mr_request *req;
+	struct xsc_ib_mr *mr;
+	int err;
+
+	mr = kzalloc_obj(*mr, GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
+	in = kzalloc_obj(*in, GFP_KERNEL);
+	if (!in) {
+		err = -ENOMEM;
+		goto err_free;
+	}
+
+	req = &in->req;
+	req->pdn = cpu_to_be32(to_xpd(pd)->pdn);
+	req->acc = convert_access(acc);
+	req->va_base = 0;
+	req->map_en = !(XSC_MPT_MAP_EN);
+
+	err = xsc_core_create_mkey(xdev, &mr->xmr);
+	if (err)
+		goto err_in;
+	req->mkey = cpu_to_be32(mr->xmr.key);
+	err = xsc_core_register_mr(xdev, &mr->xmr, in, sizeof(*in));
+	if (err)
+		goto err_reg_mr;
+	kfree(in);
+	mr->ibmr.lkey = mr->xmr.key;
+	mr->ibmr.rkey = mr->xmr.key;
+	mr->umem = NULL;
+
+	return &mr->ibmr;
+err_reg_mr:
+	xsc_core_destroy_mkey(xdev, &mr->xmr);
+err_in:
+	kfree(in);
+
+err_free:
+	kfree(mr);
+
+	return ERR_PTR(err);
+}
+
+static struct xsc_ib_mr *reg_create(struct ib_pd *pd, u64 virt_addr,
+				    u64 length, struct ib_umem *umem,
+				    size_t npages, int page_shift,
+				    int access_flags)
+{
+	struct xsc_ib_dev *dev = to_xdev(pd->device);
+	struct xsc_register_mr_mbox_in *in;
+	struct xsc_ib_mr *mr;
+	struct ib_block_iter biter;
+	__be64 *pas;
+	size_t pas_size;
+	size_t inlen;
+	int err;
+
+	mr = kzalloc_obj(*mr, GFP_KERNEL);
+	if (!mr) {
+		err = -ENOMEM;
+		goto err_0;
+	}
+
+	if (npages > dev->xdev->caps.max_mtt) {
+		ibdev_err(&dev->ib_dev, "npages(%zu) exceeded.\n", npages);
+		err = -EINVAL;
+		goto err_1;
+	}
+
+	if (check_mul_overflow(npages, sizeof(*in->req.pas), &pas_size) ||
+	    check_add_overflow(pas_size, sizeof(*in), &inlen) ||
+	    inlen > INT_MAX) {
+		err = -EINVAL;
+		goto err_1;
+	}
+	in = xsc_vzalloc(inlen);
+	if (!in) {
+		err = -ENOMEM;
+		goto err_1;
+	}
+	err = xsc_core_create_mkey(dev->xdev, &mr->xmr);
+	if (err) {
+		ibdev_warn(&dev->ib_dev, "create mkey failed\n");
+		goto err_2;
+	}
+
+	pas = in->req.pas;
+	rdma_umem_for_each_dma_block(umem, &biter, 1UL << page_shift) {
+		*pas = cpu_to_be64(rdma_block_iter_dma_address(&biter));
+		pas++;
+	}
+
+	in->req.acc = convert_access(access_flags);
+	in->req.pa_num = cpu_to_be32((u32)npages);
+	in->req.pdn = cpu_to_be32(to_xpd(pd)->pdn);
+	in->req.va_base = cpu_to_be64(virt_addr);
+	in->req.map_en = XSC_MPT_MAP_EN;
+	in->req.len = cpu_to_be64(length);
+	in->req.page_mode = xsc_get_mr_page_mode(dev->xdev, page_shift);
+	ibdev_dbg(&dev->ib_dev, "read_flush hwconfig %s\n",
+		  dev->xdev->read_flush ? "enable" : "disable");
+	in->req.is_gpu = 0;
+	in->req.mkey = cpu_to_be32(mr->xmr.key);
+	err = xsc_core_register_mr(dev->xdev, &mr->xmr, in, inlen);
+	if (err) {
+		ibdev_warn(&dev->ib_dev, "register mr failed, err = %d\n", err);
+		goto err_reg_mr;
+	}
+	mr->umem = umem;
+	xsc_vfree(in);
+
+	ibdev_dbg(&dev->ib_dev, "mkey = 0x%x\n", mr->xmr.key);
+
+	return mr;
+err_reg_mr:
+	xsc_core_destroy_mkey(dev->xdev, &mr->xmr);
+err_2:
+	xsc_vfree(in);
+err_1:
+	kfree(mr);
+err_0:
+	return ERR_PTR(err);
+}
+
+struct ib_mr *xsc_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
+				 u64 virt_addr, int access_flags,
+				 struct ib_dmah *dmah,
+				 struct ib_udata *udata)
+{
+	struct xsc_ib_dev *dev = to_xdev(pd->device);
+	struct xsc_ib_mr *mr = NULL;
+	struct ib_umem *umem;
+	unsigned long pgsz;
+	int page_shift;
+	size_t npages;
+	int err;
+
+	if (dmah)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	if (length > dev->xdev->caps.max_mr_size) {
+		ibdev_err(&dev->ib_dev, "reg user mr length(%llu) exceeded.\n", length);
+		return ERR_PTR(-EINVAL);
+	}
+
+	ibdev_dbg(&dev->ib_dev, "start 0x%llx, virt_addr 0x%llx, length 0x%llx\n",
+		  start, virt_addr, length);
+
+	umem = ib_umem_get_va(&dev->ib_dev, start, length, access_flags);
+	if (IS_ERR(umem)) {
+		ibdev_dbg(&dev->ib_dev, "umem get failed\n");
+		return (void *)umem;
+	}
+
+	pgsz = ib_umem_find_best_pgsz(umem, XSC_MR_PAGE_CAP_MASK, virt_addr);
+	if (!pgsz) {
+		ibdev_warn(&dev->ib_dev, "find best page size failed\n");
+		err = -EINVAL;
+		goto error;
+	}
+
+	page_shift = order_base_2(pgsz);
+	npages = ib_umem_num_dma_blocks(umem, pgsz);
+
+	ibdev_dbg(&dev->ib_dev, "npages %zu, page_shift %d\n", npages, page_shift);
+
+	mr = reg_create(pd, virt_addr, length, umem, npages, page_shift,
+			access_flags);
+	if (IS_ERR(mr)) {
+		err = PTR_ERR(mr);
+		goto error;
+	}
+
+	ibdev_dbg(&dev->ib_dev, "mkey 0x%x\n", mr->xmr.key);
+
+	mr->umem = umem;
+	mr->npages = npages;
+	mr->ibmr.lkey = mr->xmr.key;
+	mr->ibmr.rkey = mr->xmr.key;
+	mr->ibmr.length = length;
+	return &mr->ibmr;
+
+error:
+	ib_umem_release(umem);
+	return ERR_PTR(err);
+}
+
+struct ib_mr *xsc_ib_reg_user_mr_dmabuf(struct ib_pd *pd, u64 offset,
+					u64 length, u64 virt_addr,
+					int fd, int access_flags,
+					struct ib_dmah *dmah,
+					struct uverbs_attr_bundle *attrs)
+{
+	struct xsc_ib_dev *dev = to_xdev(pd->device);
+	struct ib_umem_dmabuf *umem_dmabuf;
+	struct ib_umem *umem;
+	struct xsc_ib_mr *mr;
+	unsigned long pgsz;
+	int page_shift;
+	size_t npages;
+	int err;
+
+	if (!IS_ENABLED(CONFIG_INFINIBAND_USER_MEM))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	if (dmah)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	if (length > dev->xdev->caps.max_mr_size) {
+		ibdev_err(&dev->ib_dev, "reg user dmabuf mr length(%llu) exceeded.\n",
+			  length);
+		return ERR_PTR(-EINVAL);
+	}
+
+	umem_dmabuf = ib_umem_dmabuf_get_pinned(&dev->ib_dev,
+						offset, length,
+						fd, access_flags);
+	if (IS_ERR(umem_dmabuf)) {
+		ibdev_dbg(&dev->ib_dev, "umem_dmabuf get failed (%ld)\n",
+			  PTR_ERR(umem_dmabuf));
+		return ERR_CAST(umem_dmabuf);
+	}
+	umem = &umem_dmabuf->umem;
+
+	pgsz = ib_umem_find_best_pgsz(umem, XSC_MR_PAGE_CAP_MASK, virt_addr);
+	if (!pgsz) {
+		ibdev_warn(&dev->ib_dev, "find best page size failed\n");
+		err = -EINVAL;
+		goto err_release;
+	}
+
+	page_shift = order_base_2(pgsz);
+	npages = ib_umem_num_dma_blocks(umem, pgsz);
+
+	mr = reg_create(pd, virt_addr, length, umem, npages, page_shift,
+			access_flags);
+	if (IS_ERR(mr)) {
+		err = PTR_ERR(mr);
+		goto err_release;
+	}
+
+	mr->umem = umem;
+	mr->npages = npages;
+	mr->ibmr.lkey = mr->xmr.key;
+	mr->ibmr.rkey = mr->xmr.key;
+	mr->ibmr.length = length;
+
+	return &mr->ibmr;
+err_release:
+	ib_umem_release(umem);
+	return ERR_PTR(err);
+}
+
+int xsc_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
+{
+	struct xsc_ib_dev *dev = to_xdev(ibmr->device);
+	struct xsc_ib_mr *mr = to_xmr(ibmr);
+	struct ib_umem *umem = mr->umem;
+	int err;
+
+	ibdev_dbg(&dev->ib_dev, "dereg mkey = 0x%x\n", mr->xmr.key);
+
+	if (mr->npages) {
+		err = xsc_core_dereg_mr(dev->xdev, &mr->xmr);
+		if (err) {
+			ibdev_warn(&dev->ib_dev, "failed to dereg mr 0x%x (%d)\n",
+				   mr->xmr.key, err);
+			return err;
+		}
+	}
+	err = xsc_core_destroy_mkey(dev->xdev, &mr->xmr);
+	if (err) {
+		ibdev_warn(&dev->ib_dev, "failed to destroy mkey 0x%x (%d)\n",
+			   mr->xmr.key, err);
+		return err;
+	}
+
+	if (umem)
+		ib_umem_release(umem);
+
+	kfree(mr);
+
+	return 0;
+}
+
+int xsc_reg_local_dma_mr(struct xsc_core_device *dev)
+{
+	struct xsc_register_mr_mbox_in in;
+	int err = 0;
+
+	in.req.pdn = 0;
+	in.req.pa_num = 0;
+	in.req.len = 0;
+	in.req.mkey = cpu_to_be32(0xFF);
+	in.req.acc = XSC_PERM_LOCAL_WRITE | XSC_PERM_LOCAL_READ;
+	in.req.page_mode = xsc_get_mr_page_mode(dev, XSC_PAGE_SHIFT_4K);
+	in.req.is_gpu = 0;
+	in.req.map_en = !(XSC_MPT_MAP_EN);
+	in.req.va_base = 0;
+
+	err = xsc_core_register_mr(dev, NULL, &in, sizeof(in));
+	if (err)
+		dev_err(&dev->pdev->dev,
+			"failed to register the local dma mkey 0xFF (%d)\n", err);
+
+	return err;
+}
diff --git a/drivers/infiniband/hw/xsc/xsc_ib.h b/drivers/infiniband/hw/xsc/xsc_ib.h
index b91d4aa37..eb4d9e630 100644
--- a/drivers/infiniband/hw/xsc/xsc_ib.h
+++ b/drivers/infiniband/hw/xsc/xsc_ib.h
@@ -207,7 +207,7 @@ struct xsc_ib_mr {
 	struct ib_mr		ibmr;
 	struct xsc_core_mr	xmr;
 	struct ib_umem	       *umem;
-	int			npages;
+	u32			npages;
 };
 
 struct xsc_ib_dev {
diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/driver.h b/drivers/net/ethernet/yunsilicon/xsc/common/driver.h
index 362099a7c..0c91574d6 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/common/driver.h
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/driver.h
@@ -63,6 +63,7 @@ int xsc_core_destroy_mkey(struct xsc_core_device *xdev, struct xsc_core_mr *mr);
 int xsc_core_register_mr(struct xsc_core_device *xdev, struct xsc_core_mr *mr,
 			 struct xsc_register_mr_mbox_in *in, int inlen);
 int xsc_core_dereg_mr(struct xsc_core_device *xdev, struct xsc_core_mr *mr);
+int xsc_reg_local_dma_mr(struct xsc_core_device *xdev);
 
 int xsc_core_alloc_pd(struct xsc_core_device *xdev, u32 *pdn);
 int xsc_core_dealloc_pd(struct xsc_core_device *xdev, u32 pdn);
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
index 87481db3f..065d52ebf 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
@@ -6,4 +6,4 @@ ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
 
 obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc_pci.o
 
-xsc_pci-y := main.o cmdq.o hw.o qp.o cq.o link.o alloc.o eq.o pci_irq.o adev.o vport.o hal/andes_impl.o
+xsc_pci-y := main.o cmdq.o hw.o qp.o cq.o pd.o mr.o link.o alloc.o eq.o pci_irq.o adev.o vport.o hal/andes_impl.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/cq.c b/drivers/net/ethernet/yunsilicon/xsc/pci/cq.c
index e3e13ef53..a964236bd 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/cq.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/cq.c
@@ -143,9 +143,9 @@ static int xsc_set_cq_context(struct xsc_core_device *xdev,
 
 	memset(&out, 0, sizeof(out));
 	err = xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
-	if (err || out.hdr.status) {
+	if (err) {
 		pci_err(xdev->pdev, "failed to set cq context\n");
-		return -EIO;
+		return err;
 	}
 
 	*pa_list_base = be32_to_cpu(out.cq_pa_list_base);
@@ -193,9 +193,9 @@ static int xsc_set_cq_buf_pa(struct xsc_core_device *xdev,
 		err = xsc_cmd_exec(xdev, in, in_len, &out, sizeof(out));
 		kvfree(in);
 
-		if (err || out.hdr.status) {
+		if (err) {
 			pci_err(xdev->pdev, "failed to set cq buf pa, cqn=%d\n", cqn);
-			return -EINVAL;
+			return err;
 		}
 	}
 
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/mr.c b/drivers/net/ethernet/yunsilicon/xsc/pci/mr.c
new file mode 100644
index 000000000..b07e8743f
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/mr.c
@@ -0,0 +1,202 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include "common/xsc_core.h"
+#include "common/xsc_cmd_api.h"
+#include "hal/xsc_hal.h"
+#include "mr.h"
+
+int xsc_core_create_mkey(struct xsc_core_device *xdev, struct xsc_core_mr *mr)
+{
+	struct xsc_create_mkey_mbox_in in;
+	struct xsc_create_mkey_mbox_out out;
+	u8 key;
+	int err;
+
+	memset(&in, 0, sizeof(in));
+	memset(&out, 0, sizeof(out));
+
+	spin_lock(&xdev->dev_res->mkey_lock);
+	key = 0x80 + xdev->dev_res->mkey_key++;
+	spin_unlock(&xdev->dev_res->mkey_lock);
+
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_CREATE_MKEY);
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+	if (err) {
+		pci_err(xdev->pdev, "failed to create mkey, err = %d\n", err);
+		return err;
+	}
+
+	mr->key = xsc_idx_to_mkey(xdev, be32_to_cpu(out.mkey) & 0xffffff) | key;
+	pci_dbg(xdev->pdev, "out 0x%x, key 0x%x, mkey 0x%x\n",
+		be32_to_cpu(out.mkey), key, mr->key);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xsc_core_create_mkey);
+
+int xsc_core_destroy_mkey(struct xsc_core_device *xdev, struct xsc_core_mr *mr)
+{
+	struct xsc_destroy_mkey_mbox_in in;
+	struct xsc_destroy_mkey_mbox_out out;
+	int err;
+
+	memset(&in, 0, sizeof(in));
+	memset(&out, 0, sizeof(out));
+
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_DESTROY_MKEY);
+	in.mkey = cpu_to_be32(mr->key);
+
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xsc_core_destroy_mkey);
+
+static int xsc_set_mpt_via_cmdq(struct xsc_core_device *xdev,
+				struct xsc_register_mr_mbox_in *in_cmd,
+				u32 *mtt_base)
+{
+	struct xsc_register_mr_request *req = &in_cmd->req;
+	struct xsc_set_mpt_mbox_in *in;
+	struct xsc_set_mpt_mbox_out out;
+	u64 mem_size;
+	int err;
+
+	in = kzalloc_obj(*in, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	mem_size = be64_to_cpu(req->len);
+	in->mpt_item.pdn = req->pdn;
+	in->mpt_item.pa_num = req->pa_num;
+	in->mpt_item.len = cpu_to_be32((u32)mem_size);
+	in->mpt_item.len_h = cpu_to_be32((u32)(mem_size >> 32));
+	in->mpt_item.mkey = req->mkey;
+	in->mpt_item.is_gpu = req->is_gpu;
+	in->mpt_item.acc = req->acc;
+	in->mpt_item.page_mode = req->page_mode;
+	in->mpt_item.map_en = req->map_en;
+	in->mpt_item.va_base = req->va_base;
+	in->hdr.opcode = cpu_to_be16(XSC_CMD_OP_SET_MPT);
+
+	memset(&out, 0, sizeof(out));
+	err = xsc_cmd_exec(xdev, in, sizeof(*in), &out, sizeof(out));
+	kfree(in);
+	if (err) {
+		pci_err(xdev->pdev, "failed to set mpt, err = %d\n", err);
+		return err;
+	}
+
+	*mtt_base = be32_to_cpu(out.mtt_base);
+	return 0;
+}
+
+#define PA_NUM_PER_CMD 1024
+
+static int xsc_set_mtt_via_cmdq(struct xsc_core_device *xdev,
+				struct xsc_register_mr_mbox_in *in_cmd,
+				u32 mtt_base)
+{
+	struct xsc_register_mr_request *req = &in_cmd->req;
+	struct xsc_set_mtt_mbox_in *seg_in;
+	struct xsc_set_mtt_mbox_out seg_out;
+	int tot_pg_num = be32_to_cpu(req->pa_num);
+	int tot_seg_num, seg_pa_num, seg_idx;
+	int pa_idx_base = 0;
+	int in_len, err, i;
+
+	tot_seg_num = (tot_pg_num & (PA_NUM_PER_CMD - 1)) ?
+		      ((tot_pg_num >> 10) + 1) : (tot_pg_num >> 10);
+
+	for (seg_idx = 0; seg_idx < tot_seg_num; seg_idx++) {
+		seg_pa_num = (seg_idx != tot_seg_num - 1) ? PA_NUM_PER_CMD :
+			     (tot_pg_num - ((tot_seg_num - 1) << 10));
+		in_len = (seg_pa_num << 3) + sizeof(*seg_in);
+		seg_in = kzalloc(in_len, GFP_KERNEL);
+		if (!seg_in)
+			return -ENOMEM;
+
+		seg_in->mtt_setting.mtt_base = cpu_to_be32(mtt_base);
+		seg_in->mtt_setting.pa_num = cpu_to_be32(seg_pa_num);
+		for (i = 0; i < seg_pa_num; i++)
+			seg_in->mtt_setting.pas[i] = req->pas[pa_idx_base + i];
+		seg_in->hdr.opcode = cpu_to_be16(XSC_CMD_OP_SET_MTT);
+
+		memset(&seg_out, 0, sizeof(seg_out));
+		pci_dbg(xdev->pdev,
+			"set mtt seg %d, pa_num %d, pa_idx_base %d, tot_seg %d\n",
+			seg_idx, seg_pa_num, pa_idx_base, tot_seg_num);
+		err = xsc_cmd_exec(xdev, seg_in, in_len, &seg_out, sizeof(seg_out));
+		kfree(seg_in);
+		if (err) {
+			pci_err(xdev->pdev, "failed to set mtt seg %d, err = %d\n",
+				seg_idx, err);
+			return err;
+		}
+
+		pa_idx_base += seg_pa_num;
+		mtt_base += seg_pa_num;
+	}
+
+	return 0;
+}
+
+static int xsc_dereg_mr_via_cmdq(struct xsc_core_device *xdev, u32 mkey)
+{
+	struct xsc_unregister_mr_mbox_in in;
+	struct xsc_unregister_mr_mbox_out out;
+	int err;
+
+	memset(&in, 0, sizeof(in));
+	memset(&out, 0, sizeof(out));
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_DEREG_MR);
+	in.mkey = cpu_to_be32(xsc_mkey_to_idx(xdev, mkey));
+
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+	if (err) {
+		pci_err(xdev->pdev, "failed to dereg mr, err = %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+int xsc_core_register_mr(struct xsc_core_device *xdev, struct xsc_core_mr *mr,
+			 struct xsc_register_mr_mbox_in *in, int inlen)
+{
+	u32 mtt_base;
+	int err;
+
+	in->hdr.opcode = cpu_to_be16(XSC_CMD_OP_REG_MR);
+
+	err = xsc_set_mpt_via_cmdq(xdev, in, &mtt_base);
+	if (err) {
+		pci_err(xdev->pdev, "failed to set mpt via cmdq\n");
+		return err;
+	}
+
+	err = xsc_set_mtt_via_cmdq(xdev, in, mtt_base);
+	if (err) {
+		pci_err(xdev->pdev, "failed to set mtt via cmdq\n");
+		xsc_dereg_mr_via_cmdq(xdev, be32_to_cpu(in->req.mkey));
+		return err;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xsc_core_register_mr);
+
+int xsc_core_dereg_mr(struct xsc_core_device *xdev, struct xsc_core_mr *mr)
+{
+	return xsc_dereg_mr_via_cmdq(xdev, mr->key);
+}
+EXPORT_SYMBOL_GPL(xsc_core_dereg_mr);
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/mr.h b/drivers/net/ethernet/yunsilicon/xsc/pci/mr.h
new file mode 100644
index 000000000..edafecda6
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/mr.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_MR_H
+#define __XSC_MR_H
+
+#include "common/xsc_core.h"
+#include "common/xsc_cmd.h"
+
+int xsc_core_create_mkey(struct xsc_core_device *xdev, struct xsc_core_mr *mr);
+int xsc_core_destroy_mkey(struct xsc_core_device *xdev, struct xsc_core_mr *mr);
+int xsc_core_register_mr(struct xsc_core_device *xdev, struct xsc_core_mr *mr,
+			 struct xsc_register_mr_mbox_in *in, int inlen);
+int xsc_core_dereg_mr(struct xsc_core_device *xdev, struct xsc_core_mr *mr);
+
+#endif /* __XSC_MR_H */
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/pd.c b/drivers/net/ethernet/yunsilicon/xsc/pci/pd.c
new file mode 100644
index 000000000..e8e55bc4c
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/pd.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "common/xsc_core.h"
+#include "common/xsc_cmd_api.h"
+#include "pd.h"
+
+int xsc_core_alloc_pd(struct xsc_core_device *xdev, u32 *pdn)
+{
+	struct xsc_alloc_pd_mbox_in in;
+	struct xsc_alloc_pd_mbox_out out;
+	int err;
+
+	memset(&in, 0, sizeof(in));
+	memset(&out, 0, sizeof(out));
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_ALLOC_PD);
+
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+	if (err)
+		return err;
+
+	*pdn = be32_to_cpu(out.pdn) & 0xffffff;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xsc_core_alloc_pd);
+
+int xsc_core_dealloc_pd(struct xsc_core_device *xdev, u32 pdn)
+{
+	struct xsc_dealloc_pd_mbox_in in;
+	struct xsc_dealloc_pd_mbox_out out;
+	int err;
+
+	memset(&in, 0, sizeof(in));
+	memset(&out, 0, sizeof(out));
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_DEALLOC_PD);
+	in.pdn = cpu_to_be32(pdn);
+
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xsc_core_dealloc_pd);
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/pd.h b/drivers/net/ethernet/yunsilicon/xsc/pci/pd.h
new file mode 100644
index 000000000..d9a99baea
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/pd.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_PD_H
+#define __XSC_PD_H
+
+#include "common/xsc_core.h"
+
+int xsc_core_alloc_pd(struct xsc_core_device *xdev, u32 *pdn);
+int xsc_core_dealloc_pd(struct xsc_core_device *xdev, u32 pdn);
+
+#endif /* __XSC_PD_H */
-- 
2.18.4
