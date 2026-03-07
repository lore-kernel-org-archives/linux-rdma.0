Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED3A3126B9;
	Sat,  7 Mar 2026 16:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772902217; cv=none; b=fgpBCxCIFyPw1UY4CcSY9qMz308RgtYrjNh/wTcvBqUFOu0EJbXsQHkFuZHDrkoRuTDz9JF9IYNXlBRozHbqZYSBaaLvnLTg3JUjbwkGOggbilm8jy5dQjdSlde6e/JpeF8ly4v3QL/ThCzdesgZnf/HwLmcmcPxwZDwxl25P2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772902217; c=relaxed/simple;
	bh=+np5iOOqktMdnsPjtJMq7wRZ0OVJ8pTuP3tHO2f6YKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gf8tbWqCupdgV8fbRSkzQNUJmbfsPVT2NbO2ZVKKd6XEQSZglC1xCfwoneVZVPEynSjiS+3uPJM+q6BHrcsTA79QPxZWmOi0Sg3IQ2pjPa2F7tyytWPSVUQKO5ISaXNiP+gkLamEXLLhT/h8W2h6pEv2mzIHhLWGza49vRxgRZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VHoxlU8I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VHoxlU8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36265C2BC87;
	Sat,  7 Mar 2026 16:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772902216;
	bh=+np5iOOqktMdnsPjtJMq7wRZ0OVJ8pTuP3tHO2f6YKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHoxlU8IHwNFA65SC7u7n6bKu5lC9mOMaZXCHE+abZN2Niba6YHRs9isYcsV45tB3
	 ZyQ6VS0AkW20MqNLYjLmG/7+hMSWUVdezHFRW0SuUwTueH942Zcn6j/TUZ8XmIUYS3
	 7kkt0PGgeeFNNFxJs7L9CLTkVjNbSf3CF52h1AhmS0ZB3afa2BXJM4D5qU2hn8Mplj
	 AKhNHbDUMbYHu4w/Md11wytq1qksjJoNW6rwAMpVXffWKJAbwA5gLbauKxrz7KVCiM
	 qgj0IN6PKz+EXd06qzgQvUVoda2gJmZ8I10cQ95CYutdM7tZQJq4+qiEJETLbAPzZP
	 Zp9PUsrj4Vfjg==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Petr Tesarik <ptesarik@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-rdma@vger.kernel.org
Subject: [PATCH 2/3] dma-mapping: Clarify valid conditions for CPU cache line overlap
Date: Sat,  7 Mar 2026 18:49:56 +0200
Message-ID: <20260307-dma-debug-overlap-v1-2-c034c38872af@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260307-dma-debug-overlap-v1-0-c034c38872af@nvidia.com>
References: <20260307-dma-debug-overlap-v1-0-c034c38872af@nvidia.com>
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

Rename the DMA_ATTR_CPU_CACHE_CLEAN attribute to reflect that it allows
CPU cache overlaps to exist, and document a slightly different but still
valid use case involving overlapping CPU cache lines.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/core-api/dma-attributes.rst | 26 ++++++++++++++++++--------
 drivers/virtio/virtio_ring.c              |  4 ++--
 include/linux/dma-mapping.h               |  8 ++++----
 kernel/dma/debug.c                        |  2 +-
 4 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
index 1d7bfad73b1c7..6b73d92c62721 100644
--- a/Documentation/core-api/dma-attributes.rst
+++ b/Documentation/core-api/dma-attributes.rst
@@ -149,11 +149,21 @@ For architectures that require cache flushing for DMA coherence
 DMA_ATTR_MMIO will not perform any cache flushing. The address
 provided must never be mapped cacheable into the CPU.
 
-DMA_ATTR_CPU_CACHE_CLEAN
-------------------------
-
-This attribute indicates the CPU will not dirty any cacheline overlapping this
-DMA_FROM_DEVICE/DMA_BIDIRECTIONAL buffer while it is mapped. This allows
-multiple small buffers to safely share a cacheline without risk of data
-corruption, suppressing DMA debug warnings about overlapping mappings.
-All mappings sharing a cacheline should have this attribute.
+DMA_ATTR_CPU_CACHE_OVERLAP
+--------------------------
+
+This attribute indicates that CPU cache lines may overlap for buffers mapped
+with DMA_FROM_DEVICE or DMA_BIDIRECTIONAL.
+
+Such overlap may occur when callers map multiple small buffers that reside
+within the same cache line. In this case, callers must guarantee that the CPU
+will not dirty these cache lines after the mappings are established. When this
+condition is met, multiple buffers can safely share a cache line without risking
+data corruption.
+
+Another valid use case is on systems that are CPU-coherent and do not use
+SWIOTLB, where the caller can guarantee that no cache maintenance operations
+(such as flushes) will be performed that could overwrite shared cache lines.
+
+All mappings that share a cache line must set this attribute to suppress DMA
+debug warnings about overlapping mappings.
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 335692d41617a..bf51ae9a39169 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2912,7 +2912,7 @@ EXPORT_SYMBOL_GPL(virtqueue_add_inbuf);
  * @data: the token identifying the buffer.
  * @gfp: how to do memory allocations (if necessary).
  *
- * Same as virtqueue_add_inbuf but passes DMA_ATTR_CPU_CACHE_CLEAN to indicate
+ * Same as virtqueue_add_inbuf but passes DMA_ATTR_CPU_CACHE_OVERLAP to indicate
  * that the CPU will not dirty any cacheline overlapping this buffer while it
  * is available, and to suppress overlapping cacheline warnings in DMA debug
  * builds.
@@ -2928,7 +2928,7 @@ int virtqueue_add_inbuf_cache_clean(struct virtqueue *vq,
 				    gfp_t gfp)
 {
 	return virtqueue_add(vq, &sg, num, 0, 1, data, NULL, false, gfp,
-			     DMA_ATTR_CPU_CACHE_CLEAN);
+			     DMA_ATTR_CPU_CACHE_OVERLAP);
 }
 EXPORT_SYMBOL_GPL(virtqueue_add_inbuf_cache_clean);
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 29973baa05816..45efede1a6cce 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -80,11 +80,11 @@
 #define DMA_ATTR_MMIO		(1UL << 10)
 
 /*
- * DMA_ATTR_CPU_CACHE_CLEAN: Indicates the CPU will not dirty any cacheline
- * overlapping this buffer while it is mapped for DMA. All mappings sharing
- * a cacheline must have this attribute for this to be considered safe.
+ * DMA_ATTR_CPU_CACHE_OVERLAP: Indicates the CPU cache line can be overlapped.
+ * All mappings sharing a cacheline must have this attribute for this
+ * to be considered safe.
  */
-#define DMA_ATTR_CPU_CACHE_CLEAN	(1UL << 11)
+#define DMA_ATTR_CPU_CACHE_OVERLAP	(1UL << 11)
 
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.  It can
diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index be207be749968..603be342063f1 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -601,7 +601,7 @@ static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
 	unsigned long flags;
 	int rc;
 
-	entry->is_cache_clean = !!(attrs & DMA_ATTR_CPU_CACHE_CLEAN);
+	entry->is_cache_clean = attrs & DMA_ATTR_CPU_CACHE_OVERLAP;
 
 	bucket = get_hash_bucket(entry, &flags);
 	hash_bucket_add(bucket, entry);

-- 
2.53.0

