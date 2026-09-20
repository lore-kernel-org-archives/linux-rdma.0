Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215AB41DDFF;
	Sun, 20 Sep 2026 11:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789904561; cv=none; b=Hy4uZkUxaZV9ifwspNWlDyiXJxRlIGc0YUnWQSwEIicIGnxsmJC0K0nqYH16S9kd23ACbyPtARwI69bN75EKprdBGG1l7vW4y2jrfCKYZ9Zx0LsvQPztRkSX70VDksyd6Jx1P2CwZiziv9hy2H5HOZZJLfqBfzXCfCvtWUi6uAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789904561; c=relaxed/simple;
	bh=Soqbec9vVVKuXYZxvaud05V1gsviiQEyuDFMVwYcy0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SjRKr5Skp397kyyXtnFdr7JFYd+EAadkOB3axNzL2132yeLcNkzPzQRSTZ7qsTBx0mhGDIwJaOmuw2zZ4mlRC9riBpLu4l0OC68vY74f0N6zlKCP1np8xGQmN1/VkD48N5jVr2sNefkGfSaA5qWZaSzGutp2bh0a1/R5ECEDSds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e62EDnrb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e62EDnrb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD851F000FF;
	Sun, 20 Sep 2026 11:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789904559;
	bh=/mrSoLPBT5WDIMN7g2Yzlv7di4OqO/Z3hH8lrqqJWsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e62EDnrbydiZttmQe/8HcgDk1JM8eLmneCt3lGsITqpPb8jj9x+hiZhfnh5HM2fsz
	 3FiQx/pxf35ygHXRwt1HUOp83kwboKzESeHvdFMcSEObramm8pj9lpKM7SQSJHeuBh
	 U1j5DhrQak4DHoKzFSuGJCh7P88Z9ZZfKq59C24WMIJLZY8UPC4qUG9DAN174njq+b
	 BDAJy6fALd3AFl946DZXWAbvxcLN0t8r5xNkqCeXO3EGwZ2xudk6nuT7CIku7OnuoZ
	 knWxAdDDuDDnneNLGIeeC55nVZBTpIKQsGpA4Z68lJDAuFHamiJNxy+7o9t2/LzcFA
	 GTcIOV1qKqRlA==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Alex Williamson <alex@shazbot.org>,
	Leon Romanovsky <leon@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 16/19] dma-buf: Let importers ask how peer-to-peer traffic is routed
Date: Sun, 20 Sep 2026 14:41:28 +0300
Message-ID: <20260920-fix-p2p-acs-v4-0-v7-16-ca0828ab697c@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260920-fix-p2p-acs-v4-0-v7-0-ca0828ab697c@nvidia.com>
References: <20260920-fix-p2p-acs-v4-0-v7-0-ca0828ab697c@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Exporters keep the &struct p2pdma_provider backing a buffer in their own
private data. An importer cannot reach it, so it has no way to learn how
its own peer-to-peer traffic would be routed before it programs its
hardware.

Add an optional @p2pdma_provider callback for an exporter to hand that
provider out, and dma_buf_p2pdma_map_type() for an importer to ask by TLP
class. Exporters keep the provider where it already lives, so this adds an
operation rather than changing any existing signature or structure.

Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/dma-buf/dma-buf-mapping.c | 39 +++++++++++++++++++++++++++++++++++++++
 include/linux/dma-buf-mapping.h   |  3 +++
 include/linux/dma-buf.h           | 19 +++++++++++++++++++
 3 files changed, 61 insertions(+)

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index 794acff2546a..41702045f803 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -6,6 +6,45 @@
 #include <linux/dma-buf-mapping.h>
 #include <linux/dma-resv.h>
 
+/**
+ * dma_buf_p2pdma_map_type - How peer-to-peer traffic to a buffer is routed
+ * @attach:	attachment of the importer that will issue the traffic
+ * @tlp_flags:	&enum pci_p2pdma_tlp_flags describing the TLPs it will issue
+ *
+ * Reports how the PCIe fabric routes @tlp_flags traffic between the buffer
+ * behind @attach and the importer attached to it, so that an importer can
+ * choose the TLP attributes that earn it a direct route before it programs
+ * its hardware.
+ *
+ * The caller must hold the reservation lock. The provider is owned by the
+ * exporter's driver binding, and exporters revoke under that lock before
+ * letting an unbind proceed, so dropping it any earlier would leave this
+ * racing a teardown that frees the provider.
+ *
+ * Return: the mapping type for @tlp_flags traffic, or PCI_P2PDMA_MAP_NONE
+ * when the exporter names no &struct p2pdma_provider and nothing is known
+ * about the route.
+ */
+enum pci_p2pdma_map_type
+dma_buf_p2pdma_map_type(struct dma_buf_attachment *attach,
+			unsigned int tlp_flags)
+{
+	struct dma_buf *dmabuf = attach->dmabuf;
+	struct p2pdma_provider *provider;
+
+	dma_resv_assert_held(dmabuf->resv);
+
+	if (!dmabuf->ops->p2pdma_provider)
+		return PCI_P2PDMA_MAP_NONE;
+
+	provider = dmabuf->ops->p2pdma_provider(dmabuf);
+	if (!provider)
+		return PCI_P2PDMA_MAP_NONE;
+
+	return pci_p2pdma_map_type_tlp(provider, attach->dev, tlp_flags);
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_p2pdma_map_type, "DMA_BUF");
+
 static struct scatterlist *fill_sg_entry(struct scatterlist *sgl, size_t length,
 					 dma_addr_t addr)
 {
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index 09bde3f748e4..37b3da10b17a 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -7,6 +7,9 @@
 #define __DMA_BUF_MAPPING_H__
 #include <linux/dma-buf.h>
 
+enum pci_p2pdma_map_type
+dma_buf_p2pdma_map_type(struct dma_buf_attachment *attach,
+			unsigned int tlp_flags);
 struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 					 struct p2pdma_provider *provider,
 					 struct phys_vec *phys_vec,
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index d1203da56fc5..d56a48d41215 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -186,6 +186,25 @@ struct dma_buf_ops {
 	 * if the call would block.
 	 */
 
+	/**
+	 * @p2pdma_provider:
+	 *
+	 * Returns the &struct p2pdma_provider backing this buffer, so that an
+	 * importer can ask how its peer-to-peer traffic would be routed before
+	 * it programs its hardware. Importers reach this through
+	 * dma_buf_p2pdma_map_type() rather than calling it directly.
+	 *
+	 * Exporters of MMIO memory that is reachable peer-to-peer should
+	 * implement this. Called with the &dma_buf.resv reservation lock held,
+	 * which is what lets an exporter refuse once it has revoked the buffer
+	 * and started tearing the provider down. This callback is optional.
+	 *
+	 * Returns:
+	 *
+	 * The provider backing the buffer.
+	 */
+	struct p2pdma_provider *(*p2pdma_provider)(struct dma_buf *dmabuf);
+
 	/**
 	 * @release:
 	 *

-- 
2.55.0

