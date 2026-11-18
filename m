Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795001479;
	b=IKgtAMerRJKN4fzU6ZAQgv6M/itBPEP7pbieb6G0Yd8NocRgWz5qHhVpjL8SxiL119IT
	 7keeMoutI4RRfsljdp9NAfetOXL1UBBPWH49YaiU359omp44AlLppvJh7SVjoUG5Dw2jW
	 ErGBdJ45dtsCFEapaJ4Xsmiw7shpDzzejTjPQtnZYRJsGYDZ+IxGWNpYkGZ38oZXNuhrI
	 n4Xh+xpSNMdm6RJtVR/sQk9AZ+mHgvmWDWytxkq+dqKVXQCSPAR3frdTmaCPP4gMPPVHf
	 pjFXLZH0235FLnmbMw98g+VW28SnZgNSKS3clWkyDkXxa1NKE2tG1QmAbSUr/WDaELA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795001479;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=T3daSxkgAGvb1vCXOWepnq81pQTvWxCWULJCs5IHq+c=;
	b=CLxOCd9u71xzNDEA4NR8OjN4JrCphQzpZ8x/Buzfy/7xQ1uIQV2g3pEim9mU6lkyj4nB
	 kESgVd42nADVYAWr7hGe0ieCojt7IcZ4ukizOwIaXk9xVBuGF9hPCCRkQC3qOc55Cj76x
	 2bAuEe3aVzX3CZOd1O65PNRqGz62kr6oQqoPLCcl2D+SOvzyRq4X5RKwtW0RYg8zzQx2g
	 kPGT/ijTPQT2wiRYNv4hMDfwfl0dPkc/xPvJlQwznFHj7zOTJyqrnLU7mWanHkHL1P3xR
	 NddJkfWob5JzNhw1A8MhjZ3bNuFfoOAFi7OxYkXF/CgjG0ybueXIsvgVCFhGrz2urPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=i+Wvcaq0;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E832606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:31:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E832606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=i+Wvcaq0
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261118113116epoutp03a3af2feb3b85161600ed80e43d0e6247~pIFUGZTGi1562915629epoutp03T
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:31:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261118113116epoutp03a3af2feb3b85161600ed80e43d0e6247~pIFUGZTGi1562915629epoutp03T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795001476;
	bh=T3daSxkgAGvb1vCXOWepnq81pQTvWxCWULJCs5IHq+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+Wvcaq0maZisIyleHnNlUbx7BHgEVfwALhuZUS9Qkxfs7FL+8LKGfXOOFBbKuR88
	 sy66GIN+fz88wQnUa9iVkIpMF6/NqZqTnCQI2F560UPFPKMjBl9vEADOkst262pMxu
	 /f3+0sqJdvZQDjVSwTvm4/RJG9uLakPKUQGHFsms=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20261118113115epcas5p34bb7d4ceb03b480da96e2740ac7efa9b~pIFThexG92136821368epcas5p3v;
	Wed, 18 Nov 2026 11:31:15 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.88]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4jTzv62Mxsz3hhT3; Wed, 18 Nov
	2026 11:31:14 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20261118103450epcas5p1163c0878f3f2da3357146301143047a0~pHUDfJ_xg0474604746epcas5p1r;
	Wed, 18 Nov 2026 10:34:50 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261118103448epsmtip26199ebf8f9dc8da5d1948b0397c1f9e7~pHUBZ54Ny0245402454epsmtip2J;
	Wed, 18 Nov 2026 10:34:48 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	jgg@ziepe.ca, leon@kernel.org, asml.silence@gmail.com
Cc: nj.shetty@samsung.com, joshi.k@samsung.com, anuj1072538@gmail.com,
	linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [RFC 1/4] nvme: move dma-buf I/O context handling to nvme-core
Date: Wed, 18 Nov 2026 16:03:24 +0530
Message-Id: <20261118103327.1788667-2-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261118103327.1788667-1-anuj20.g@samsung.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261118103450epcas5p1163c0878f3f2da3357146301143047a0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261118103450epcas5p1163c0878f3f2da3357146301143047a0
References: <20261118103327.1788667-1-anuj20.g@samsung.com>
	<CGME20261118103450epcas5p1163c0878f3f2da3357146301143047a0@epcas5p1.samsung.com>

From: Nitesh Shetty <nj.shetty@samsung.com>

The dma-buf I/O context handling in pci-dmabuf.c is not specific to
PCI. Move it to nvme-core so it can be shared by other transports.

Keep the PCI-specific PRP and SGL construction in pci.c.

No functional change.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/Makefile                   |  2 +-
 drivers/nvme/host/{pci-dmabuf.c => dmabuf.c} | 12 ++++++++----
 drivers/nvme/host/{pci-dmabuf.h => dmabuf.h} | 12 ++++++------
 drivers/nvme/host/pci.c                      |  5 ++---
 4 files changed, 17 insertions(+), 14 deletions(-)
 rename drivers/nvme/host/{pci-dmabuf.c => dmabuf.c} (92%)
 rename drivers/nvme/host/{pci-dmabuf.h => dmabuf.h} (85%)

diff --git a/drivers/nvme/host/Makefile b/drivers/nvme/host/Makefile
index 8288b986d713..5082a2788b31 100644
--- a/drivers/nvme/host/Makefile
+++ b/drivers/nvme/host/Makefile
@@ -19,9 +19,9 @@ nvme-core-$(CONFIG_BLK_DEV_ZONED)	+= zns.o
 nvme-core-$(CONFIG_FAULT_INJECTION_DEBUG_FS)	+= fault_inject.o
 nvme-core-$(CONFIG_NVME_HWMON)		+= hwmon.o
 nvme-core-$(CONFIG_NVME_HOST_AUTH)	+= auth.o
+nvme-core-$(CONFIG_DMA_SHARED_BUFFER)	+= dmabuf.o
 
 nvme-y					+= pci.o
-nvme-$(CONFIG_DMA_SHARED_BUFFER)	+= pci-dmabuf.o
 
 nvme-fabrics-y				+= fabrics.o
 
diff --git a/drivers/nvme/host/pci-dmabuf.c b/drivers/nvme/host/dmabuf.c
similarity index 92%
rename from drivers/nvme/host/pci-dmabuf.c
rename to drivers/nvme/host/dmabuf.c
index 161e4ffa6919..1f9104a5d75e 100644
--- a/drivers/nvme/host/pci-dmabuf.c
+++ b/drivers/nvme/host/dmabuf.c
@@ -1,12 +1,12 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Code for supporting dma-buf I/O maps in the NVMe driver.
+ * Code for supporting dma-buf I/O maps in the NVMe host drivers.
  * Copyright (C) 2026 Pavel Begunkov <asml.silence@gmail.com>
  */
 
 #include <linux/dma-resv.h>
 
-#include "pci-dmabuf.h"
+#include "dmabuf.h"
 
 static void nvme_dmabuf_invalidate_mappings(struct dma_buf_attachment *attach)
 {
@@ -104,7 +104,7 @@ static void nvme_dma_buf_io_release(struct dma_buf_io_ctx *base_ctx)
 	kfree(ctx);
 }
 
-void __nvme_pci_remove_dmabuf(struct nvme_dma_buf_list *list)
+void __nvme_remove_dmabufs(struct nvme_dma_buf_list *list)
 {
 	struct nvme_dma_buf_io_ctx *ctx, *tmp;
 
@@ -117,8 +117,9 @@ void __nvme_pci_remove_dmabuf(struct nvme_dma_buf_list *list)
 	}
 	mutex_unlock(&list->lock);
 }
+EXPORT_SYMBOL_GPL(__nvme_remove_dmabufs);
 
-const struct dma_buf_io_ops nvme_dma_buf_io_ops = {
+static const struct dma_buf_io_ops nvme_dma_buf_io_ops = {
 	.map		= nvme_dma_buf_io_map,
 	.unmap		= nvme_dma_buf_io_unmap,
 	.release	= nvme_dma_buf_io_release,
@@ -167,3 +168,6 @@ int __nvme_init_dma_buf_io_ctx(struct nvme_ctrl *ctrl,
 	mutex_unlock(&buf_list->lock);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(__nvme_init_dma_buf_io_ctx);
+
+MODULE_IMPORT_NS("DMA_BUF");
diff --git a/drivers/nvme/host/pci-dmabuf.h b/drivers/nvme/host/dmabuf.h
similarity index 85%
rename from drivers/nvme/host/pci-dmabuf.h
rename to drivers/nvme/host/dmabuf.h
index b3c9fd485878..08a5b8e5d771 100644
--- a/drivers/nvme/host/pci-dmabuf.h
+++ b/drivers/nvme/host/dmabuf.h
@@ -3,8 +3,8 @@
  * Copyright (C) 2026 Pavel Begunkov <asml.silence@gmail.com>
  */
 
-#ifndef _NVME_PCI_DMABUF_H
-#define _NVME_PCI_DMABUF_H
+#ifndef _NVME_DMABUF_H
+#define _NVME_DMABUF_H
 
 #include <linux/dma-buf-io.h>
 
@@ -44,15 +44,15 @@ static inline struct nvme_dmabuf_map *nvme_req_to_map(struct request *req)
 	return to_nvme_dmabuf_map(map);
 }
 
-void __nvme_pci_remove_dmabuf(struct nvme_dma_buf_list *list);
+void __nvme_remove_dmabufs(struct nvme_dma_buf_list *list);
 int __nvme_init_dma_buf_io_ctx(struct nvme_ctrl *ctrl,
 		struct nvme_dma_buf_list *buf_list,
 		struct dma_buf_io_ctx *ctx);
 
-static inline void nvme_pci_remove_dmabuf(struct nvme_dma_buf_list *list)
+static inline void nvme_remove_dmabufs(struct nvme_dma_buf_list *list)
 {
 	if (IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
-		__nvme_pci_remove_dmabuf(list);
+		__nvme_remove_dmabufs(list);
 }
 
 static inline int nvme_init_dma_buf_io_ctx(struct nvme_ctrl *ctrl,
@@ -72,4 +72,4 @@ static inline void nvme_init_buf_list(struct nvme_dma_buf_list *buf_list)
 }
 
 
-#endif /* _NVME_PCI_DMABUF_H */
\ No newline at end of file
+#endif /* _NVME_DMABUF_H */
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 076603df01ab..1af356abde0b 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -30,7 +30,7 @@
 
 #include "trace.h"
 #include "nvme.h"
-#include "pci-dmabuf.h"
+#include "dmabuf.h"
 
 #define SQ_SIZE(q)	((q)->q_depth << (q)->sqes)
 #define CQ_SIZE(q)	((q)->q_depth * sizeof(struct nvme_completion))
@@ -4129,7 +4129,7 @@ static void nvme_remove(struct pci_dev *pdev)
 	nvme_stop_ctrl(&dev->ctrl);
 	nvme_remove_namespaces(&dev->ctrl);
 	nvme_dev_disable(dev, true);
-	nvme_pci_remove_dmabuf(&dev->dmabufs);
+	nvme_remove_dmabufs(&dev->dmabufs);
 	nvme_free_host_mem(dev);
 	nvme_dev_remove_admin(dev);
 	nvme_dbbuf_dma_free(dev);
@@ -4571,6 +4571,5 @@ MODULE_AUTHOR("Matthew Wilcox <willy@linux.intel.com>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("1.0");
 MODULE_DESCRIPTION("NVMe host PCIe transport driver");
-MODULE_IMPORT_NS("DMA_BUF");
 module_init(nvme_init);
 module_exit(nvme_exit);
-- 
2.25.1

