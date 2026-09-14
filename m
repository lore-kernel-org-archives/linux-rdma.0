Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DB645C6F0;
	Mon, 14 Sep 2026 11:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789385029; cv=none; b=ccH3/vNVpc7fLi+n8N/mhW9vK0UTCE5/bsjOOVzvwlcRQypYsaMsQBGILM3s7drOfvPaszltnKUlSkEQCL2F2/svphaXNo9It/NEvmXysKOu9OrlWAWj+dP10jExEwaXi2HwBJbuZHxXES7Lu7mPWLn4wFTmarWhFRbHSytTa6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789385029; c=relaxed/simple;
	bh=rnozbo6WPNXEUp1nGqmyJYJm2RHYtPXRxYfEE7dCTQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oYf+qqJI6lOpyk4LgBOonPSECpasvTyfAAJV4Qkr1/3hmRzpZbY50lzGvH7lUlhIq6iEei1ziJ7tK59oxqBzAxywK3yQgjCbGnX5svQSpvVnCjWGQDd9As6NvMglvhhwjouPtjzvnb8L/UAQQFcldtoVKnYtbAzH5JFjW1XRGb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a26S/jc9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a26S/jc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DB61F000FF;
	Mon, 14 Sep 2026 11:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789385026;
	bh=MokxU+jbZ05FjPz9z/JZ/TnUqRIqBMJqRRb9uIlLdik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a26S/jc9xervkXoxclAywYyGHUutmvHhPsfl1nIMjFXvP9MDwTJdtFcm+8QujaWfX
	 T2i5/rM3wu5hGfwYM8rKDcZ5kk9kiUThmxP1/zdt4CNFb5Aq5ieahZbkzfLH0MR+Ga
	 JHkhtSGjxbBkq+V0xMku0f/FhFaYuo65vlvczCsGQF9l0CL24tV/7o4iR4IXHRCDMF
	 5IQW0iDmd7s1QVkQQzVia5rNgTGbjxuaYEmROzVDNK2Ac4Iit2FOak+phDXyZQrAVV
	 VXLp20DI/8Ua1iWdfATyd45FIieqNc/wL9Ec5XRKAQ+S/74uRDCrzK0l5KnGx1Wmtt
	 U8qbQeLzpw9Mw==
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
Subject: [PATCH v6 17/18] dma-buf: Let importers ask how peer-to-peer traffic is routed
Date: Mon, 14 Sep 2026 14:22:50 +0300
Message-ID: <20260914-fix-p2p-acs-v4-0-v6-17-5ef07ec9ef06@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
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

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/dma-buf/dma-buf-mapping.c                 | 32 +++++++++++++++++++++++
 drivers/infiniband/core/uverbs_std_types_dmabuf.c | 12 +++++++++
 drivers/vfio/pci/vfio_pci_dmabuf.c                | 12 +++++++++
 include/linux/dma-buf-mapping.h                   |  3 +++
 include/linux/dma-buf.h                           | 17 ++++++++++++
 5 files changed, 76 insertions(+)

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index 794acff2546a..fb03a698b381 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -6,6 +6,38 @@
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
diff --git a/drivers/infiniband/core/uverbs_std_types_dmabuf.c b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
index 2411ebee69e2..5a6a1ee430a7 100644
--- a/drivers/infiniband/core/uverbs_std_types_dmabuf.c
+++ b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
@@ -76,6 +76,17 @@ static void uverbs_dmabuf_release(struct dma_buf *dmabuf)
 	uverbs_uobject_release(&priv->uobj);
 }
 
+static struct p2pdma_provider *
+uverbs_dmabuf_provider(struct dma_buf *dmabuf)
+{
+	struct ib_uverbs_dmabuf_file *priv = dmabuf->priv;
+
+	if (priv->revoked)
+		return NULL;
+
+	return priv->provider;
+}
+
 static const struct dma_buf_ops uverbs_dmabuf_ops = {
 	.attach = uverbs_dmabuf_attach,
 	.map_dma_buf = uverbs_dmabuf_map,
@@ -83,6 +94,7 @@ static const struct dma_buf_ops uverbs_dmabuf_ops = {
 	.pin = uverbs_dmabuf_pin,
 	.unpin = uverbs_dmabuf_unpin,
 	.release = uverbs_dmabuf_release,
+	.p2pdma_provider = uverbs_dmabuf_provider,
 };
 
 static int UVERBS_HANDLER(UVERBS_METHOD_DMABUF_ALLOC)(
diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index c16f460c01d6..fcf392cfc3c5 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -99,11 +99,23 @@ static void vfio_pci_dma_buf_release(struct dma_buf *dmabuf)
 	kfree(priv);
 }
 
+static struct p2pdma_provider *
+vfio_pci_dma_buf_provider(struct dma_buf *dmabuf)
+{
+	struct vfio_pci_dma_buf *priv = dmabuf->priv;
+
+	if (priv->revoked)
+		return NULL;
+
+	return priv->provider;
+}
+
 static const struct dma_buf_ops vfio_pci_dmabuf_ops = {
 	.attach = vfio_pci_dma_buf_attach,
 	.map_dma_buf = vfio_pci_dma_buf_map,
 	.unmap_dma_buf = vfio_pci_dma_buf_unmap,
 	.release = vfio_pci_dma_buf_release,
+	.p2pdma_provider = vfio_pci_dma_buf_provider,
 };
 
 /*
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
index d1203da56fc5..cff1ee0838f0 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -186,6 +186,23 @@ struct dma_buf_ops {
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
+	 * implement this. This callback is optional.
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

