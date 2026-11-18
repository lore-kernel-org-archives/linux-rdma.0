Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795001485;
	b=WCmp0EK887T/FAy5QrKmnWDc57lAdWsMLjszuABa7DUe3yHKdDpHMZBbSFrQYF4q8fGA
	 OMdYr7uidZtxODGW4+myspRyqWeX3S6iHXiRBkPHx1Zaxxfj6Cx2uzzSQat6HEYvBIEPv
	 4h/OWO0qsDNwZqAdIZYndlWG5TE74ctF65WriKp0aoCmbtS2p+gRICmx8jxyo9qm3qMay
	 7H9kmYOGRtyDZGnJjlOA3JkU+ajULDvdju9VcYuRlyUQk+nSjO6ECybJQlx9hXgSgILLa
	 6z17r/TsERDVgTecTb6lojHpwvomfekUE0szFcn5VL3N/GM4HzU+vMTMUsmSW3o5bcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795001485;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=awg5QPU7vXvHHD0f/e3t9xfqcZ9CWW58r3v94L1vXwg=;
	b=z4QIAGX8rpD37+zlhAYkpUVB8MKdfUl6m+oBsg2n1Cc3gENe2VBo2VakbuEJ4Q9il5L7
	 LKp1TA7FWG1//8s+VbQfjOVRO3IvIg+0hVS0q4KATEyLos8QvHkQFRdy3ATH80gGv36zM
	 GbWwS+gyInjVdFyULuc7L53QUorFX+TcUIW35347SGIJU3vvGOx1dgwQGY2y/gikeQQtk
	 pivWLmzvLcLkF+47g6IYryStsd2qC7nN+m+B/4Lw0ck5v0p8gL2V7Ca5KOwk7Eqm8Ojov
	 0GufgaKcuT+kFOvsmszu+14LJKGPNK+P5VN4tDaRRZlWU5bcPVLOkXukfkHz3/11zPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=rb2g+MjX;
	arc=none smtp.remote-ip=203.254.224.34
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CF1606A32A
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:31:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64CF1606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=rb2g+MjX
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261118113122epoutp042a817580847583927f0d4f0edf802cce~pIFZ-PfvW0935609356epoutp04_
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:31:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261118113122epoutp042a817580847583927f0d4f0edf802cce~pIFZ-PfvW0935609356epoutp04_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795001482;
	bh=awg5QPU7vXvHHD0f/e3t9xfqcZ9CWW58r3v94L1vXwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rb2g+MjXrypvPTEP4CwC0my0BbPfSdDP4nVFUqm8wCVBqi4JuboNg0xy+wjnzC96G
	 RIt1tHks83QeKe2nhWTh2maNfZYB4cnGTSgAeYk1IWrN8EjggJBJF6h9qz/rUPNXAu
	 gsXEY17BqM/rC1TBb1q0+D06r/9UoMpLX/iXUqiU=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20261118113121epcas5p436c075dc5f0f036052b0d07e616aef20~pIFY0R88h2687826878epcas5p4j;
	Wed, 18 Nov 2026 11:31:21 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.86]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jTzvD2n9tz2SSKX; Wed, 18 Nov
	2026 11:31:20 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20261118103455epcas5p22384b4ed044dbf65efe94d6a910e4325~pHUHfd2FN0491304913epcas5p2a;
	Wed, 18 Nov 2026 10:34:55 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261118103453epsmtip2fc6fdb19580aa329f96b44b3ceeef734~pHUF1-VdB0208902089epsmtip2E;
	Wed, 18 Nov 2026 10:34:53 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	jgg@ziepe.ca, leon@kernel.org, asml.silence@gmail.com
Cc: nj.shetty@samsung.com, joshi.k@samsung.com, anuj1072538@gmail.com,
	linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [RFC 3/4] RDMA/core: Add ib_dma_buf_dynamic_attach()
Date: Wed, 18 Nov 2026 16:03:26 +0530
Message-Id: <20261118103327.1788667-4-anuj20.g@samsung.com>
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
X-CMS-MailID: 20261118103455epcas5p22384b4ed044dbf65efe94d6a910e4325
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261118103455epcas5p22384b4ed044dbf65efe94d6a910e4325
References: <20261118103327.1788667-1-anuj20.g@samsung.com>
	<CGME20261118103455epcas5p22384b4ed044dbf65efe94d6a910e4325@epcas5p2.samsung.com>

ULPs must not use the DMA device of an ib_device directly, but a ULP
importing a dma-buf has to attach it to that device.

Add a helper that attaches a dma-buf to the DMA device of an ib_device.
Devices using virtual DMA, such as rxe and siw, have no DMA device and
are rejected with -EOPNOTSUPP.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/infiniband/core/verbs.c | 28 ++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h         |  7 +++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index c4eb1de44155..eb3036d6f7e1 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -38,6 +38,7 @@
 
 #include <linux/errno.h>
 #include <linux/err.h>
+#include <linux/dma-buf.h>
 #include <linux/export.h>
 #include <linux/string.h>
 #include <linux/slab.h>
@@ -3217,3 +3218,30 @@ void rdma_free_hw_stats_struct(struct rdma_hw_stats *stats)
 	kfree(stats);
 }
 EXPORT_SYMBOL(rdma_free_hw_stats_struct);
+
+/**
+ * ib_dma_buf_dynamic_attach - attach a dma-buf for DMA by an RDMA device
+ * @dev: RDMA device that will access the dma-buf
+ * @dmabuf: dma-buf to attach
+ * @importer_ops: importer callbacks, see dma_buf_dynamic_attach()
+ * @importer_priv: importer private data, see dma_buf_dynamic_attach()
+ *
+ * Attach @dmabuf to the device that does DMA for @dev. Devices using
+ * virtual DMA have no such device and are not supported.
+ *
+ * Return: the attachment, or an ERR_PTR() on failure.
+ */
+struct dma_buf_attachment *
+ib_dma_buf_dynamic_attach(struct ib_device *dev, struct dma_buf *dmabuf,
+			  const struct dma_buf_attach_ops *importer_ops,
+			  void *importer_priv)
+{
+	if (ib_uses_virt_dma(dev))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	return dma_buf_dynamic_attach(dmabuf, dev->dma_device, importer_ops,
+				      importer_priv);
+}
+EXPORT_SYMBOL_GPL(ib_dma_buf_dynamic_attach);
+
+MODULE_IMPORT_NS("DMA_BUF");
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d6eaa3fee66e..c287bee1dd09 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -4323,6 +4323,13 @@ static inline bool ib_dma_pci_p2p_dma_supported(struct ib_device *dev)
 	return dma_pci_p2pdma_supported(dev->dma_device);
 }
 
+struct dma_buf;
+struct dma_buf_attach_ops;
+struct dma_buf_attachment *
+ib_dma_buf_dynamic_attach(struct ib_device *dev, struct dma_buf *dmabuf,
+			  const struct dma_buf_attach_ops *importer_ops,
+			  void *importer_priv);
+
 /**
  * ib_virt_dma_to_ptr - Convert a dma_addr to a kernel pointer
  * @dma_addr: The DMA address
-- 
2.25.1

