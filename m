Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795001481;
	b=2HutDUGgH9iLB9+aMGUc5TTT7fT5r96acfZEmX17epspdKiqXTs5jNPBg/XYpaoc8sZg
	 Y1oDdtBhyPl7UbXA+FiUcup/YkeS27ohYlZrDd20SSy3zm/31c64LJQR4BPMY3LtqkFp8
	 kqs//O1OGpQh3aW1ntpCeIbr046sgwd5VT/2hCA6XkHnn1DF1VV6WbPu5S4sXf7tYHa9M
	 HcgUTZSRwDmQZ4MnfMMkMa0Ujg6/AHAwpyfICia4pXX0irzDowSP0pd/KSDjw8qBIgn99
	 x6u7asdVE5lVOqfdUD+05bmy8QaHDBLe0pMnm9rW3IGZbrrkQ5cnrrZ8QNs01HUlIsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795001481;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=eheZv0Bqqe1P3/H2B3k9R4/IG4AFsFlcH3JrS6tN1+c=;
	b=VKNOs4gVTvPwb+Pkd938sgLWESHHypfJvxZDXYzuTclDwr/BoJqHQ/nu/B/RLtqr1DOz
	 YR7OlxjszdJorX+XroJR6GopSLRUPStfRageXYsIs1iT+EHcZvhKenP6nCyQL7jA2x4Jj
	 mIRLk00fZik+r0dRWLnND7zWBP71vtEM1MMkCKuSzhLxb0PvaT0VrEvLujgxmHKU1NQfp
	 hOS0KN2osYMz/e828Xvm0aKtEF7qMeV2piNZmp0GjB8XrDeONqJnhfXN5G2BfqG02jBNG
	 c0TtOM8Q2pTOs7emfcx+y6qlrV8hmW3cuJ6Jkm0EV57A66y+CS1uA+FKz3SbrrNUDuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=N+posujH;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DA4606A32C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:31:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51DA4606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=N+posujH
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261118113118epoutp03320d79444d2d1274b6781bae8e938a7b~pIFWddkVx1562915629epoutp03V
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:31:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261118113118epoutp03320d79444d2d1274b6781bae8e938a7b~pIFWddkVx1562915629epoutp03V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795001478;
	bh=eheZv0Bqqe1P3/H2B3k9R4/IG4AFsFlcH3JrS6tN1+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+posujHDr5gHJVLD3opNPDnlmK9uGN4DW6mu8Lf5XAmnfp8DEGvbD5sLW2d8+5Rf
	 VmSsyAY4OC/uxJ9mr+vm5oUb7v5y4EHjVnCdX6fILJFoMk+CECFQoKF569kmnqwOjs
	 TrI4xCqOcMK7wc/hRxSmxiwxVMcc8IHAUf1A1MEw=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20261118113118epcas5p2dc5d04351992108aed2a219b2c1a27d5~pIFV-NmX00429904299epcas5p2N;
	Wed, 18 Nov 2026 11:31:18 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.91]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4jTzv90pl2z3hhT8; Wed, 18 Nov
	2026 11:31:17 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20261118103453epcas5p38649877d029a06c4b519578f5cfccc4d~pHUGDpfpI0683606836epcas5p3r;
	Wed, 18 Nov 2026 10:34:53 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261118103451epsmtip226a49e820d488726cec48d3042c9d1fb~pHUDvJ_Yo2865628656epsmtip21;
	Wed, 18 Nov 2026 10:34:51 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	jgg@ziepe.ca, leon@kernel.org, asml.silence@gmail.com
Cc: nj.shetty@samsung.com, joshi.k@samsung.com, anuj1072538@gmail.com,
	linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [RFC 2/4] nvme: let transports provide the dma-buf attachment
Date: Wed, 18 Nov 2026 16:03:25 +0530
Message-Id: <20261118103327.1788667-3-anuj20.g@samsung.com>
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
X-CMS-MailID: 20261118103453epcas5p38649877d029a06c4b519578f5cfccc4d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261118103453epcas5p38649877d029a06c4b519578f5cfccc4d
References: <20261118103327.1788667-1-anuj20.g@samsung.com>
	<CGME20261118103453epcas5p38649877d029a06c4b519578f5cfccc4d@epcas5p3.samsung.com>

From: Nitesh Shetty <nj.shetty@samsung.com>

dma-bufs are currently attached to ctrl->dev by nvme-core. This works
for nvme-pci, but fabrics transports can use a different device for
data DMA.

Let transports create the attachment and pass it to nvme-core, which
takes ownership of it. nvme-pci continues to attach to its PCI device.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/dmabuf.c | 35 ++++++++++++++++++++++-------------
 drivers/nvme/host/dmabuf.h |  6 +++++-
 drivers/nvme/host/pci.c    | 11 ++++++++++-
 3 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/drivers/nvme/host/dmabuf.c b/drivers/nvme/host/dmabuf.c
index 1f9104a5d75e..f68ffa89e56f 100644
--- a/drivers/nvme/host/dmabuf.c
+++ b/drivers/nvme/host/dmabuf.c
@@ -15,10 +15,11 @@ static void nvme_dmabuf_invalidate_mappings(struct dma_buf_attachment *attach)
 	dma_buf_io_invalidate_mappings(ctx);
 }
 
-static const struct dma_buf_attach_ops nvme_dmabuf_importer_ops = {
+const struct dma_buf_attach_ops nvme_dmabuf_importer_ops = {
 	.invalidate_mappings	= nvme_dmabuf_invalidate_mappings,
 	.allow_peer2peer	= true,
 };
+EXPORT_SYMBOL_GPL(nvme_dmabuf_importer_ops);
 
 static struct dma_buf_io_map *nvme_dma_buf_io_map(struct dma_buf_io_ctx *ctx)
 {
@@ -127,23 +128,21 @@ static const struct dma_buf_io_ops nvme_dma_buf_io_ops = {
 
 static int nvme_init_io_ctx_locked(struct nvme_ctrl *ctrl,
 		struct nvme_dma_buf_list *buf_list,
+		struct dma_buf_attachment *attach,
 		struct dma_buf_io_ctx *ctx)
 {
 	struct nvme_dma_buf_io_ctx *nvme_ctx;
-	struct dma_buf_attachment *attach;
+	int ret;
 
-	if (buf_list->dead)
-		return -ENODEV;
+	if (buf_list->dead) {
+		ret = -ENODEV;
+		goto err_detach;
+	}
 
 	nvme_ctx = kzalloc_obj(*nvme_ctx);
-	if (!nvme_ctx)
-		return -ENOMEM;
-
-	attach = dma_buf_dynamic_attach(ctx->dmabuf, ctrl->dev,
-					&nvme_dmabuf_importer_ops, ctx);
-	if (IS_ERR(attach)) {
-		kfree(nvme_ctx);
-		return PTR_ERR(attach);
+	if (!nvme_ctx) {
+		ret = -ENOMEM;
+		goto err_detach;
 	}
 
 	nvme_get_ctrl(ctrl);
@@ -155,16 +154,26 @@ static int nvme_init_io_ctx_locked(struct nvme_ctrl *ctrl,
 	ctx->dev_priv = nvme_ctx;
 	ctx->dev_ops = &nvme_dma_buf_io_ops;
 	return 0;
+
+err_detach:
+	dma_buf_detach(ctx->dmabuf, attach);
+	return ret;
 }
 
+/*
+ * @attach must have been created with nvme_dmabuf_importer_ops and @ctx as
+ * the importer private data. The context takes ownership of it, and it is
+ * detached on failure or when the context is released.
+ */
 int __nvme_init_dma_buf_io_ctx(struct nvme_ctrl *ctrl,
 		struct nvme_dma_buf_list *buf_list,
+		struct dma_buf_attachment *attach,
 		struct dma_buf_io_ctx *ctx)
 {
 	int ret;
 
 	mutex_lock(&buf_list->lock);
-	ret = nvme_init_io_ctx_locked(ctrl, buf_list, ctx);
+	ret = nvme_init_io_ctx_locked(ctrl, buf_list, attach, ctx);
 	mutex_unlock(&buf_list->lock);
 	return ret;
 }
diff --git a/drivers/nvme/host/dmabuf.h b/drivers/nvme/host/dmabuf.h
index 08a5b8e5d771..0c12ee6d3584 100644
--- a/drivers/nvme/host/dmabuf.h
+++ b/drivers/nvme/host/dmabuf.h
@@ -44,9 +44,12 @@ static inline struct nvme_dmabuf_map *nvme_req_to_map(struct request *req)
 	return to_nvme_dmabuf_map(map);
 }
 
+extern const struct dma_buf_attach_ops nvme_dmabuf_importer_ops;
+
 void __nvme_remove_dmabufs(struct nvme_dma_buf_list *list);
 int __nvme_init_dma_buf_io_ctx(struct nvme_ctrl *ctrl,
 		struct nvme_dma_buf_list *buf_list,
+		struct dma_buf_attachment *attach,
 		struct dma_buf_io_ctx *ctx);
 
 static inline void nvme_remove_dmabufs(struct nvme_dma_buf_list *list)
@@ -57,11 +60,12 @@ static inline void nvme_remove_dmabufs(struct nvme_dma_buf_list *list)
 
 static inline int nvme_init_dma_buf_io_ctx(struct nvme_ctrl *ctrl,
 		struct nvme_dma_buf_list *buf_list,
+		struct dma_buf_attachment *attach,
 		struct dma_buf_io_ctx *ctx)
 {
 	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
 		return -EOPNOTSUPP;
-	return __nvme_init_dma_buf_io_ctx(ctrl, buf_list, ctx);
+	return __nvme_init_dma_buf_io_ctx(ctrl, buf_list, attach, ctx);
 }
 
 static inline void nvme_init_buf_list(struct nvme_dma_buf_list *buf_list)
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 1af356abde0b..412fbc3d9544 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3771,8 +3771,16 @@ static int nvme_pci_init_dma_buf_io_ctx(struct nvme_ctrl *ctrl,
 		struct dma_buf_io_ctx *ctx)
 {
 	struct nvme_dev *dev = to_nvme_dev(ctrl);
+	struct dma_buf_attachment *attach;
 
-	return nvme_init_dma_buf_io_ctx(ctrl, &dev->dmabufs, ctx);
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return -EOPNOTSUPP;
+
+	attach = dma_buf_dynamic_attach(ctx->dmabuf, dev->dev,
+					&nvme_dmabuf_importer_ops, ctx);
+	if (IS_ERR(attach))
+		return PTR_ERR(attach);
+	return nvme_init_dma_buf_io_ctx(ctrl, &dev->dmabufs, attach, ctx);
 }
 
 static const struct nvme_ctrl_ops nvme_pci_ctrl_ops = {
@@ -4571,5 +4579,6 @@ MODULE_AUTHOR("Matthew Wilcox <willy@linux.intel.com>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("1.0");
 MODULE_DESCRIPTION("NVMe host PCIe transport driver");
+MODULE_IMPORT_NS("DMA_BUF");
 module_init(nvme_init);
 module_exit(nvme_exit);
-- 
2.25.1

