Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182B54AE107;
	Mon, 28 Sep 2026 11:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790594441; cv=none; b=EDyV4W6hS1ibcwu+RJRW9MUZeAKTCTSBrbLLnmJO6HBCvhfms/jz9CEWK3lVxank/24YDvhAL03tWp3UafA4aq5wGNqPWJeB8631rXyyqPDhp7k0Doa18WwN2iloXIPqaGPsOwFWtIEQrQTptUrOx9kt1Y7RYM4OyZp/eKaW6kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790594441; c=relaxed/simple;
	bh=Soqbec9vVVKuXYZxvaud05V1gsviiQEyuDFMVwYcy0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pQbNi3q2TFcqrEDSpP6rKX4YolzQgrIytZieAubPFnXsUL9vkLcWVZZTk1CCnx+s2IjDN1z8bF/XRojHuYjsYU+XukVV4iFXqN2Jzg51g8TU20lKNJfXrvi+p+PKsJx+8LnyenIoI4++Fj6FxrXNd+vshm4/ujtS0sdz9Yii7Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aI/H2HqZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aI/H2HqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEC41F00899;
	Mon, 28 Sep 2026 11:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790594440;
	bh=/mrSoLPBT5WDIMN7g2Yzlv7di4OqO/Z3hH8lrqqJWsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aI/H2HqZ4TOtyzW+rDdhwY5BP1tnqnxNGs2CQRKrhRz8Br0vzXbY23xa2aR7Zal0O
	 InUAS15rnPFE9ce6ZEf35cgUp14Fxt+T55j/gkhHTt3j3QTxOihfmy/2arg8C80rdp
	 enyiWNiVAoHpSs6ld5G+XqI2AA7LMmwv8RWUreFi6HK3aWbMlfgKdYXCgXKnwOPvhk
	 qpGWXk6zPsdQ/TIFFmk2myaTQ1RE+g7IP9pfWQ6dNQU7uvA4R8JVUNxxRTJuyPetCw
	 KsJkDMd0n//ajNwDAnGqdYzf05Uez5Gi5GVPUw7ogm8hCPNSud3e67MAPgHdU2E+BV
	 Q/t0tO6rEY6ew==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	=?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	kvm@vger.kernel.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v8 16/23] dma-buf: Let importers ask how peer-to-peer traffic is routed
Date: Mon, 28 Sep 2026 14:19:20 +0300
Message-ID: <20260928-fix-p2p-acs-v4-0-v8-16-404453b9c435@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928-fix-p2p-acs-v4-0-v8-0-404453b9c435@nvidia.com>
References: <20260928-fix-p2p-acs-v4-0-v8-0-404453b9c435@nvidia.com>
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

