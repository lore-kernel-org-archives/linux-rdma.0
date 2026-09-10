Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A714825CD;
	Thu, 10 Sep 2026 11:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789040001; cv=none; b=U8WoIYUImaazPXnuSD29Drv5nq/XaNk4ORd3zo1GPPJiqMXLDalPtjPy+63ZWAf1PBtLr4Indr/gtGxEmLwAQqNbkIiE4JMjMo0ENW8YsmnpJPxWEi0GIGa9R7O4JQNGYBDxljWfQttIjK1jLPCgQ/6U16S2iJOktK6ykUdrD6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789040001; c=relaxed/simple;
	bh=HnOE7KxRMQDSoSWzdw0jEvJl+vqEH71USKekBD/2CmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g7kg4U8wbHXes+3nJ7phPogiOiVgTZXORRg3xQ4w4UPnsca6UF2DrBG2Al8IMSwc4aJHo8sBJwGDEmaPA9rSXmw6H4G51cmFs6eTuHFTDvDPavYr2ucbkBiyA8bTx1D2rOcjlO9OvkfGOX+j0SjQDjmuQMm7Hpq5Eq+szr1PRdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L2DWUUe3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L2DWUUe3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5DD1F00898;
	Thu, 10 Sep 2026 11:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789039999;
	bh=tVEndtM1ZMkTnl3oy8jWZNBW5Ka8c12aDzrffOz7F7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L2DWUUe36TRIQVb7AMqWGmMpNntSEztZ0qry9hebj42vUWTDSaF9MS6n34PaQ4fyW
	 DM+TFYDAVsOJaQx3QfWDxaq+BC4XZATCAMO18311no75oSZV+WJJpqEHS3a9s78hu8
	 cOJF4/J7tlNNUVHYFr3e97shW8aifqWEfL6YBTjQaUUw1pskfaIg2VK0K2vx0O26wT
	 ASy/sRXS/fBTx3orHKl8ZHvUvsLkXBLQ6HlKVtpztJoSiguowdmqebRUdvaY/o4Ass
	 YaRX5Fng3uGUE555P19PJ7EXWQO2I/57eS0MCsO/b7FONX5rtdHtevKIHUYMfK9cQh
	 muqwvD3GleIoA==
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
Subject: [PATCH v5 17/18] dma-buf: Let importers ask how peer-to-peer traffic is routed
Date: Thu, 10 Sep 2026 14:32:12 +0300
Message-ID: <20260910-fix-p2p-acs-v4-0-v5-17-856087f63c0d@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910-fix-p2p-acs-v4-0-v5-0-856087f63c0d@nvidia.com>
References: <20260910-fix-p2p-acs-v4-0-v5-0-856087f63c0d@nvidia.com>
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

Exporters keep the &struct p2pdma_provider in their own private data and
hand it to dma_buf_phys_vec_to_sgt() on every map. An importer cannot reach
it, so it has no way to learn how its own peer-to-peer traffic would be
routed before it programs its hardware.

Publish the provider through &struct dma_buf_export_info instead, and add
dma_buf_p2pdma_map_type() for importers to query it by TLP class. It is
fixed at export time, so dma_buf_phys_vec_to_sgt() no longer needs it as an
argument and the two exporters no longer need a copy of it.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/dma-buf/dma-buf-mapping.c                 | 41 +++++++++++++++++++----
 drivers/dma-buf/dma-buf.c                         |  1 +
 drivers/infiniband/core/uverbs.h                  |  1 -
 drivers/infiniband/core/uverbs_std_types_dmabuf.c |  7 ++--
 drivers/vfio/pci/vfio_pci_dmabuf.c                |  8 ++---
 include/linux/dma-buf-mapping.h                   |  4 ++-
 include/linux/dma-buf.h                           |  5 +++
 7 files changed, 49 insertions(+), 18 deletions(-)

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index 794acff2546a..8b431000e906 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -6,6 +6,32 @@
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
+ * when the exporter named no &struct p2pdma_provider and nothing is known
+ * about the route.
+ */
+enum pci_p2pdma_map_type
+dma_buf_p2pdma_map_type(struct dma_buf_attachment *attach,
+			unsigned int tlp_flags)
+{
+	if (!attach->dmabuf->provider)
+		return PCI_P2PDMA_MAP_NONE;
+
+	return pci_p2pdma_map_type_tlp(attach->dmabuf->provider, attach->dev,
+				       tlp_flags);
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_p2pdma_map_type, "DMA_BUF");
+
 static struct scatterlist *fill_sg_entry(struct scatterlist *sgl, size_t length,
 					 dma_addr_t addr)
 {
@@ -71,7 +97,6 @@ struct dma_buf_dma {
  * from arrays of physical vectors. This funciton is intended for MMIO memory
  * only.
  * @attach:	[in]	attachment whose scatterlist is to be returned
- * @provider:	[in]	p2pdma provider
  * @phys_vec:	[in]	array of physical vectors
  * @nr_ranges:	[in]	number of entries in phys_vec array
  * @size:	[in]	total size of phys_vec
@@ -85,16 +110,17 @@ struct dma_buf_dma {
  *
  * A mapping must be unmapped by using dma_buf_free_sgt().
  *
- * NOTE: This function is intended for exporters. If direct traffic routing is
- * mandatory exporter should call routing pci_p2pdma_map_type() before calling
- * this function.
+ * NOTE: This function is intended for exporters, and works on MMIO memory
+ * only, so &dma_buf.provider must have been set at export time. If direct
+ * traffic routing is mandatory the exporter should call
+ * pci_p2pdma_map_type() before calling this function.
  */
 struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
-					 struct p2pdma_provider *provider,
 					 struct phys_vec *phys_vec,
 					 size_t nr_ranges, size_t size,
 					 enum dma_data_direction dir)
 {
+	struct p2pdma_provider *provider;
 	unsigned int nents, mapped_len = 0;
 	struct dma_buf_dma *dma;
 	struct scatterlist *sgl;
@@ -104,10 +130,11 @@ struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 
 	dma_resv_assert_held(attach->dmabuf->resv);
 
-	if (WARN_ON(!attach || !attach->dmabuf || !provider))
-		/* This function is supposed to work on MMIO memory only */
+	if (WARN_ON(!attach || !attach->dmabuf || !attach->dmabuf->provider))
 		return ERR_PTR(-EINVAL);
 
+	provider = attach->dmabuf->provider;
+
 	dma = kzalloc_obj(*dma);
 	if (!dma)
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index d504c636dc29..c2b9944e9659 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -747,6 +747,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	dmabuf->size = exp_info->size;
 	dmabuf->exp_name = exp_info->exp_name;
 	dmabuf->owner = exp_info->owner;
+	dmabuf->provider = exp_info->provider;
 	spin_lock_init(&dmabuf->name_lock);
 	init_waitqueue_head(&dmabuf->poll);
 	dmabuf->cb_in.poll = dmabuf->cb_out.poll = &dmabuf->poll;
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index c64dd6b94e10..fbdac18b69ca 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -139,7 +139,6 @@ struct ib_uverbs_dmabuf_file {
 	struct list_head dmabufs_elm;
 	struct rdma_user_mmap_entry *mmap_entry;
 	struct phys_vec phys_vec;
-	struct p2pdma_provider *provider;
 	struct kref kref;
 	struct completion comp;
 	u8 revoked :1;
diff --git a/drivers/infiniband/core/uverbs_std_types_dmabuf.c b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
index 2411ebee69e2..94d3719a34da 100644
--- a/drivers/infiniband/core/uverbs_std_types_dmabuf.c
+++ b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
@@ -33,9 +33,8 @@ uverbs_dmabuf_map(struct dma_buf_attachment *attachment,
 	if (priv->revoked)
 		return ERR_PTR(-ENODEV);
 
-	ret = dma_buf_phys_vec_to_sgt(attachment, priv->provider,
-				      &priv->phys_vec, 1, priv->phys_vec.len,
-				      dir);
+	ret = dma_buf_phys_vec_to_sgt(attachment, &priv->phys_vec, 1,
+				      priv->phys_vec.len, dir);
 	if (IS_ERR(ret))
 		return ret;
 
@@ -108,7 +107,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_DMABUF_ALLOC)(
 		return -EINVAL;
 
 	ret = ib_dev->ops.mmap_get_pfns(mmap_entry, &uverbs_dmabuf->phys_vec,
-					&uverbs_dmabuf->provider);
+					&exp_info.provider);
 	if (ret)
 		goto err;
 
diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index c16f460c01d6..10f47992e7f5 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -15,7 +15,6 @@ struct vfio_pci_dma_buf {
 	struct list_head dmabufs_elm;
 	size_t size;
 	struct phys_vec *phys_vec;
-	struct p2pdma_provider *provider;
 	u32 nr_ranges;
 	struct kref kref;
 	struct completion comp;
@@ -59,9 +58,8 @@ vfio_pci_dma_buf_map(struct dma_buf_attachment *attachment,
 	if (priv->revoked)
 		return ERR_PTR(-ENODEV);
 
-	ret = dma_buf_phys_vec_to_sgt(attachment, priv->provider,
-				      priv->phys_vec, priv->nr_ranges,
-				      priv->size, dir);
+	ret = dma_buf_phys_vec_to_sgt(attachment, priv->phys_vec,
+				      priv->nr_ranges, priv->size, dir);
 	if (IS_ERR(ret))
 		return ret;
 
@@ -274,7 +272,7 @@ int vfio_pci_core_feature_dma_buf(struct vfio_pci_core_device *vdev, u32 flags,
 	priv->vdev = vdev;
 	priv->nr_ranges = get_dma_buf.nr_ranges;
 	priv->size = length;
-	ret = vdev->pci_ops->get_dmabuf_phys(vdev, &priv->provider,
+	ret = vdev->pci_ops->get_dmabuf_phys(vdev, &exp_info.provider,
 					     get_dma_buf.region_index,
 					     priv->phys_vec, dma_ranges,
 					     priv->nr_ranges);
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index 09bde3f748e4..d63ac4d52aa5 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -7,8 +7,10 @@
 #define __DMA_BUF_MAPPING_H__
 #include <linux/dma-buf.h>
 
+enum pci_p2pdma_map_type
+dma_buf_p2pdma_map_type(struct dma_buf_attachment *attach,
+			unsigned int tlp_flags);
 struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
-					 struct p2pdma_provider *provider,
 					 struct phys_vec *phys_vec,
 					 size_t nr_ranges, size_t size,
 					 enum dma_data_direction dir);
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index d1203da56fc5..81c136fcee6e 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -368,6 +368,9 @@ struct dma_buf {
 	/** @priv: exporter specific private data for this buffer object. */
 	void *priv;
 
+	/** @provider: The peer-to-peer provider backing this buffer. */
+	struct p2pdma_provider *provider;
+
 	/**
 	 * @resv:
 	 *
@@ -501,6 +504,7 @@ struct dma_buf_attachment {
  * @flags:	mode flags for the file
  * @resv:	reservation-object, NULL to allocate default one
  * @priv:	Attach private data of allocator to this buffer
+ * @provider:	Peer-to-peer provider backing the buffer
  *
  * This structure holds the information required to export the buffer. Used
  * with dma_buf_export() only.
@@ -512,6 +516,7 @@ struct dma_buf_export_info {
 	size_t size;
 	int flags;
 	struct dma_resv *resv;
+	struct p2pdma_provider *provider;
 	void *priv;
 };
 

-- 
2.55.0

