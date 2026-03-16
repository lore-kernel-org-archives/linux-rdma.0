Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086563E717B;
	Mon, 16 Mar 2026 19:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773688046; cv=none; b=u35+0kXM8x/hxvf4sPSL/P8GGTD8gp5m9MjbRIsD8YCWiPOrpGKc0xiqtSxjeOFdhBI+X4rGKnoZV74sK+x7AUYQd9xxPqlgEQQtrEwc/37uVqCAKQcOOFQ65xYWBb2uEN80vQi3TGypm4eWIdp9vNR0PwLKt9f8QvAzUXlLFqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773688046; c=relaxed/simple;
	bh=M+wL0ybsphtwzmN54IoSxHDbpmj04d4gwnhHVj/1g/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fufVuZgsJnPNuqJLPxT9ZlkoYtS4dDUXEydpo0OZ6dY9ibStLEdlrsF3Qlv5DiiBhEXEDMtJS1jQPjJ2DNUMn/iyHpaKryUkN/y/S0qxUBT3xMZ5dYmrdCsmMr7gpUmsM7rMC7dmQOmyJOQD9aWUm+w8rojrpgpTXDUIaUiPDN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=piNXWAT4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="piNXWAT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FB5C19421;
	Mon, 16 Mar 2026 19:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773688045;
	bh=M+wL0ybsphtwzmN54IoSxHDbpmj04d4gwnhHVj/1g/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=piNXWAT4bj5lHmsG6nZ0L9AfMzMyIu7j2YPi2hOtfCWMUcwEijjdxEepFlWw7a6fq
	 WVLBOPlhICTEuRhZYSVM0D5V3rQ0oUf9AcB04xuR+8KAmo2jHx35vNPo8wRdM9hGSj
	 N4y54lJWEpOjKWXIYdeYeURJx8IlG8n28lYz7s65YBXe4IbWpiBAI555h08euJPfha
	 rVCCP9FsjuH2LmZ/DWXZtj4tZGwBH/oh3HZrRLc0HEFANm62GBtJi3cReOqJFmMDuF
	 Ib/ySREM9Emz+Uly5rjb/07TARzrR0FuutOU8ynwypkMADPP1BFqB3INoz56VB3UlB
	 rONpqoDT/xo2A==
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
	Leon Romanovsky <leon@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-rdma@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 3/8] dma-mapping: Clarify valid conditions for CPU cache line overlap
Date: Mon, 16 Mar 2026 21:06:47 +0200
Message-ID: <20260316-dma-debug-overlap-v3-3-1dde90a7f08b@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
References: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
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

Rename the DMA_ATTR_CPU_CACHE_CLEAN attribute to better reflect that it
is debugging aid to inform DMA core code that CPU cache line overlaps are
allowed, and refine the documentation describing its use.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/core-api/dma-attributes.rst | 22 ++++++++++++++--------
 drivers/virtio/virtio_ring.c              | 10 +++++-----
 include/linux/dma-mapping.h               |  8 ++++----
 include/trace/events/dma.h                |  2 +-
 kernel/dma/debug.c                        |  2 +-
 5 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
index 1d7bfad73b1c7..48cfe86cc06d7 100644
--- a/Documentation/core-api/dma-attributes.rst
+++ b/Documentation/core-api/dma-attributes.rst
@@ -149,11 +149,17 @@ For architectures that require cache flushing for DMA coherence
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
+DMA_ATTR_DEBUGGING_IGNORE_CACHELINES
+------------------------------------
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
+All mappings that share a cache line must set this attribute to suppress DMA
+debug warnings about overlapping mappings.
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 335692d41617a..fbca7ce1c6bf0 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2912,10 +2912,10 @@ EXPORT_SYMBOL_GPL(virtqueue_add_inbuf);
  * @data: the token identifying the buffer.
  * @gfp: how to do memory allocations (if necessary).
  *
- * Same as virtqueue_add_inbuf but passes DMA_ATTR_CPU_CACHE_CLEAN to indicate
- * that the CPU will not dirty any cacheline overlapping this buffer while it
- * is available, and to suppress overlapping cacheline warnings in DMA debug
- * builds.
+ * Same as virtqueue_add_inbuf but passes DMA_ATTR_DEBUGGING_IGNORE_CACHELINES
+ * to indicate that the CPU will not dirty any cacheline overlapping this buffer
+ * while it is available, and to suppress overlapping cacheline warnings in DMA
+ * debug builds.
  *
  * Caller must ensure we don't call this with other virtqueue operations
  * at the same time (except where noted).
@@ -2928,7 +2928,7 @@ int virtqueue_add_inbuf_cache_clean(struct virtqueue *vq,
 				    gfp_t gfp)
 {
 	return virtqueue_add(vq, &sg, num, 0, 1, data, NULL, false, gfp,
-			     DMA_ATTR_CPU_CACHE_CLEAN);
+			     DMA_ATTR_DEBUGGING_IGNORE_CACHELINES);
 }
 EXPORT_SYMBOL_GPL(virtqueue_add_inbuf_cache_clean);
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 29973baa05816..da44394b3a1a7 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -80,11 +80,11 @@
 #define DMA_ATTR_MMIO		(1UL << 10)
 
 /*
- * DMA_ATTR_CPU_CACHE_CLEAN: Indicates the CPU will not dirty any cacheline
- * overlapping this buffer while it is mapped for DMA. All mappings sharing
- * a cacheline must have this attribute for this to be considered safe.
+ * DMA_ATTR_DEBUGGING_IGNORE_CACHELINES: Indicates the CPU cache line can be
+ * overlapped. All mappings sharing a cacheline must have this attribute for
+ * this to be considered safe.
  */
-#define DMA_ATTR_CPU_CACHE_CLEAN	(1UL << 11)
+#define DMA_ATTR_DEBUGGING_IGNORE_CACHELINES	(1UL << 11)
 
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.  It can
diff --git a/include/trace/events/dma.h b/include/trace/events/dma.h
index 69cb3805ee81c..8c64bc0721fe4 100644
--- a/include/trace/events/dma.h
+++ b/include/trace/events/dma.h
@@ -33,7 +33,7 @@ TRACE_DEFINE_ENUM(DMA_NONE);
 		{ DMA_ATTR_NO_WARN, "NO_WARN" }, \
 		{ DMA_ATTR_PRIVILEGED, "PRIVILEGED" }, \
 		{ DMA_ATTR_MMIO, "MMIO" }, \
-		{ DMA_ATTR_CPU_CACHE_CLEAN, "CACHE_CLEAN" })
+		{ DMA_ATTR_DEBUGGING_IGNORE_CACHELINES, "CACHELINES_OVERLAP" })
 
 DECLARE_EVENT_CLASS(dma_map,
 	TP_PROTO(struct device *dev, phys_addr_t phys_addr, dma_addr_t dma_addr,
diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index be207be749968..83e1cfe05f08d 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -601,7 +601,7 @@ static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
 	unsigned long flags;
 	int rc;
 
-	entry->is_cache_clean = !!(attrs & DMA_ATTR_CPU_CACHE_CLEAN);
+	entry->is_cache_clean = attrs & DMA_ATTR_DEBUGGING_IGNORE_CACHELINES;
 
 	bucket = get_hash_bucket(entry, &flags);
 	hash_bucket_add(bucket, entry);

-- 
2.53.0

