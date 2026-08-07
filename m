Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33A1C4189AD;
	Fri,  7 Aug 2026 21:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786136436; cv=none; b=OKMaQJZ3LSuuLAXt3WSplN5g6dgA99f4U04eh1pG0LtXCKSL6RU15t1N8+PUxCsKgAJa0o7u0i6s2tHVArb3K/tJ3j82e2ve2Ww3zo/NLLgFVETLE+rjEHpVVANnY/nHJaZqzSU8JWGhg2uDDSDmvLhfZv1NHQxjcBjJdO41t78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786136436; c=relaxed/simple;
	bh=hRjzgAP6bgykKlpHdNBgWkw43kjWQJtHnyO/LvtxsSs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YeRJF9zfk49zu/DAMMXFxN8tFiXaHQsKkoTxDdle+58aCOZr0BfRPR8fx7Qw+4MXVVPyikfMmaLo88ULbanUMw5gfPVjHSw6y8fruiesoaqk1kUnKmsRSCXzVTqrRKOIeatf/tPy/AaJyTz1EUoHuJgiOz1Mje/RC6/65BNTF3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=b2TXM+41; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="b2TXM+41"
Received: by linux.microsoft.com (Postfix, from userid 1231)
	id 40EF220B712D; Fri,  7 Aug 2026 14:00:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 40EF220B712D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1786136407;
	bh=AnhTGTPY1pgfTeDYo0pSHkNDZsSwBu7UzDyImSBMQ+I=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=b2TXM+41QoR+OiYslemxXuyyGQ7zSTjHIMw1wpi3wpCe7ZxJQIUszoyQpmP8y6L7Y
	 zf7rYj0p/XYGjBDOPP6QlpIcCzGL5KNq0VSyqI+iz4PHZ3qfBB+KPFom5ougUE7y0n
	 vAfkzM5f0kOqmzJr/nmTyY0e9qjrhXyCxh2skWuk=
From: Aditya Garg <gargaditya@linux.microsoft.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kotaranov@microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	dipayanroy@linux.microsoft.com,
	shradhagupta@linux.microsoft.com,
	kees@kernel.org,
	sgeorgejohn@microsoft.com,
	ssengar@linux.microsoft.com,
	gargaditya@linux.microsoft.com,
	gargaditya@microsoft.com,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH net-next 2/2] net: mana: Fall back to scattered pages for GDMA queues
Date: Fri,  7 Aug 2026 13:56:36 -0700
Message-ID: <20260807210002.1695263-3-gargaditya@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260807210002.1695263-1-gargaditya@linux.microsoft.com>
References: <20260807210002.1695263-1-gargaditya@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Each GDMA queue ring is one dma_alloc_coherent() of the whole ring size.
Such high-order allocations fail first under memory fragmentation, so
queue setup can fail with memory still free.

The hardware does not need the ring physically contiguous:
mana_gd_create_dma_region() already maps it as a list of MANA_PAGE_SIZE
(4K) device addresses. Only the driver's linear CPU view needs
contiguity, and it goes through mana_gd_ring_ptr() and
mana_gd_ring_contig_avail(); change both to map offsets onto
scattered pages.

Add a fallback in mana_gd_alloc_memory(): data-path queues pass
allow_scatter=true, so when the contiguous allocation fails the ring is
backed by a vector of scattered PAGE_SIZE (order-0) coherent pages,
presenting the same DMA page-list layout to the device. The HW channel
bootstrap keeps allow_scatter=false, and the debugfs ring dumper reads
scattered rings through the same helpers.

Signed-off-by: Aditya Garg <gargaditya@linux.microsoft.com>
---
 .../net/ethernet/microsoft/mana/gdma_main.c   | 160 ++++++++++++++++--
 .../net/ethernet/microsoft/mana/hw_channel.c  |   2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c |   3 +
 include/net/mana/gdma.h                       |  19 ++-
 4 files changed, 168 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 31a79693db07..ed9af314e4ed 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -11,6 +11,7 @@
 #include <linux/msi.h>
 #include <linux/irqdomain.h>
 #include <linux/export.h>
+#include <linux/uaccess.h>
 
 #include <net/mana/mana.h>
 #include <net/mana/hw_channel.h>
@@ -374,28 +375,96 @@ int mana_gd_send_request(struct gdma_context *gc, u32 req_len, const void *req,
 EXPORT_SYMBOL_NS(mana_gd_send_request, "NET_MANA");
 
 int mana_gd_alloc_memory(struct gdma_context *gc, unsigned int length,
-			 struct gdma_mem_info *gmi)
+			 struct gdma_mem_info *gmi, bool allow_scatter)
 {
+	unsigned int npages, i;
 	dma_addr_t dma_handle;
+	bool can_fallback;
 	void *buf;
 
 	if (length < MANA_PAGE_SIZE || !is_power_of_2(length))
 		return -EINVAL;
 
 	gmi->dev = gc->dev;
-	buf = dma_alloc_coherent(gmi->dev, length, &dma_handle, GFP_KERNEL);
-	if (!buf)
+
+	/* An allocation that fits in one page does not benefit from
+	 * fallback.
+	 */
+	can_fallback = allow_scatter && length > PAGE_SIZE;
+
+	/* Warn only when there is no fallback to rescue the failure. */
+	buf = dma_alloc_coherent(gmi->dev, length, &dma_handle,
+				 GFP_KERNEL |
+				 (can_fallback ? __GFP_NOWARN : 0));
+	if (buf) {
+		gmi->dma_handle = dma_handle;
+		gmi->virt_addr = buf;
+		gmi->length = length;
+		gmi->nr_pages = 0;
+		return 0;
+	}
+
+	if (!can_fallback)
 		return -ENOMEM;
 
-	gmi->dma_handle = dma_handle;
-	gmi->virt_addr = buf;
+	/* length is a power of 2 above PAGE_SIZE, so this divides exactly. */
+	npages = length / PAGE_SIZE;
+
+	gmi->pages_va = kvcalloc(npages, sizeof(*gmi->pages_va), GFP_KERNEL);
+	if (!gmi->pages_va)
+		return -ENOMEM;
+
+	gmi->pages_dma = kvcalloc(npages, sizeof(*gmi->pages_dma), GFP_KERNEL);
+	if (!gmi->pages_dma)
+		goto free_va;
+
+	for (i = 0; i < npages; i++) {
+		gmi->pages_va[i] = dma_alloc_coherent(gmi->dev, PAGE_SIZE,
+						      &gmi->pages_dma[i],
+						      GFP_KERNEL);
+		if (!gmi->pages_va[i])
+			goto free_pages;
+	}
+
+	dev_info_ratelimited(gmi->dev,
+			     "contiguous %u-byte DMA alloc failed; using %u scattered pages\n",
+			     length, npages);
+
+	gmi->virt_addr = NULL;
+	gmi->dma_handle = 0;
 	gmi->length = length;
+	gmi->nr_pages = npages;
 
 	return 0;
+
+free_pages:
+	while (i--)
+		dma_free_coherent(gmi->dev, PAGE_SIZE, gmi->pages_va[i],
+				  gmi->pages_dma[i]);
+	kvfree(gmi->pages_dma);
+	gmi->pages_dma = NULL;
+free_va:
+	kvfree(gmi->pages_va);
+	gmi->pages_va = NULL;
+	return -ENOMEM;
 }
 
 void mana_gd_free_memory(struct gdma_mem_info *gmi)
 {
+	unsigned int i;
+
+	if (gmi->nr_pages > 0) {
+		for (i = 0; i < gmi->nr_pages; i++)
+			dma_free_coherent(gmi->dev, PAGE_SIZE, gmi->pages_va[i],
+					  gmi->pages_dma[i]);
+		kvfree(gmi->pages_va);
+		kvfree(gmi->pages_dma);
+		gmi->pages_va = NULL;
+		gmi->pages_dma = NULL;
+		gmi->nr_pages = 0;
+		return;
+	}
+
 	dma_free_coherent(gmi->dev, gmi->length, gmi->virt_addr,
 			  gmi->dma_handle);
 }
@@ -756,17 +825,66 @@ int mana_schedule_serv_work(struct gdma_context *gc, enum gdma_eqe_type type)
 /* Return the CPU address of byte @offset within a queue's ring buffer. */
 static void *mana_gd_ring_ptr(const struct gdma_queue *q, u32 offset)
 {
+	const struct gdma_mem_info *gmi = &q->mem_info;
+
+	if (gmi->nr_pages > 0)
+		return (u8 *)gmi->pages_va[offset / PAGE_SIZE] +
+		       (offset & (PAGE_SIZE - 1));
+
 	return q->queue_mem_ptr + offset;
 }
 
-/* Number of bytes from @offset to the end of the ring buffer, i.e. the point
- * at which ring access wraps back to the start.
+/* Number of bytes from @offset to the end of the CPU-contiguous region: the
+ * rest of the ring, or the rest of the current page when scattered.
  */
 static u32 mana_gd_ring_contig_avail(const struct gdma_queue *q, u32 offset)
 {
+	if (q->mem_info.nr_pages > 0)
+		return PAGE_SIZE - (offset & (PAGE_SIZE - 1));
+
 	return q->queue_size - offset;
 }
 
+/* Copy up to @count bytes from ring offset *@pos of @q into user buffer @buf,
+ * so a scattered ring reads back as if it were contiguous. Returns bytes
+ * copied, 0 at end of ring, or a negative errno.
+ */
+ssize_t mana_gd_read_ring(struct gdma_queue *q, char __user *buf,
+			  size_t count, loff_t *pos)
+{
+	u32 size = q->queue_size;
+	loff_t off = *pos;
+	size_t copied = 0;
+
+	if (off < 0)
+		return -EINVAL;
+	if (off >= size || !count)
+		return 0;
+	count = min_t(size_t, count, size - off);
+
+	while (count) {
+		u32 offset = off;
+		u32 avail = mana_gd_ring_contig_avail(q, offset);
+		size_t chunk = min_t(size_t, count, avail);
+		size_t left = copy_to_user(buf, mana_gd_ring_ptr(q, offset),
+					   chunk);
+
+		chunk -= left;
+		buf += chunk;
+		off += chunk;
+		copied += chunk;
+		count -= chunk;
+		if (left)
+			break;
+	}
+
+	if (!copied)
+		return -EFAULT;
+
+	*pos = off;
+	return copied;
+}
+
 static void mana_gd_process_eqe(struct gdma_queue *eq)
 {
 	u32 head = eq->head % (eq->queue_size / GDMA_EQE_SIZE);
@@ -1118,7 +1236,7 @@ int mana_gd_create_hwc_queue(struct gdma_dev *gd,
 		return -ENOMEM;
 
 	gmi = &queue->mem_info;
-	err = mana_gd_alloc_memory(gc, spec->queue_size, gmi);
+	err = mana_gd_alloc_memory(gc, spec->queue_size, gmi, false);
 	if (err) {
 		dev_err(gc->dev, "GDMA queue type: %d, size: %u, gdma memory allocation err: %d\n",
 			spec->type, spec->queue_size, err);
@@ -1193,7 +1311,7 @@ static int mana_gd_create_dma_region(struct gdma_dev *gd,
 	if (length < MANA_PAGE_SIZE || !is_power_of_2(length))
 		return -EINVAL;
 
-	if (!MANA_PAGE_ALIGNED(gmi->virt_addr))
+	if (gmi->nr_pages == 0 && !MANA_PAGE_ALIGNED(gmi->virt_addr))
 		return -EINVAL;
 
 	hwc = gc->hwc.driver_data;
@@ -1213,8 +1331,24 @@ static int mana_gd_create_dma_region(struct gdma_dev *gd,
 	req->page_count = num_page;
 	req->page_addr_list_len = num_page;
 
-	for (i = 0; i < num_page; i++)
-		req->page_addr_list[i] = gmi->dma_handle +  i * MANA_PAGE_SIZE;
+	if (gmi->nr_pages > 0) {
+		unsigned int subpages = PAGE_SIZE / MANA_PAGE_SIZE;
+		unsigned int idx = 0;
+		unsigned int pg, sub;
+
+		/* Each PAGE_SIZE chunk is physically contiguous and contains
+		 * PAGE_SIZE / MANA_PAGE_SIZE consecutive device pages.
+		 */
+		for (pg = 0; pg < gmi->nr_pages; pg++)
+			for (sub = 0; sub < subpages; sub++)
+				req->page_addr_list[idx++] =
+					gmi->pages_dma[pg] +
+					sub * MANA_PAGE_SIZE;
+	} else {
+		for (i = 0; i < num_page; i++)
+			req->page_addr_list[i] =
+				gmi->dma_handle + i * MANA_PAGE_SIZE;
+	}
 
 	err = mana_gd_send_request(gc, req_msg_size, req, sizeof(resp), &resp);
 	if (err)
@@ -1257,7 +1391,7 @@ int mana_gd_create_mana_eq(struct gdma_dev *gd,
 		return -ENOMEM;
 
 	gmi = &queue->mem_info;
-	err = mana_gd_alloc_memory(gc, spec->queue_size, gmi);
+	err = mana_gd_alloc_memory(gc, spec->queue_size, gmi, true);
 	if (err) {
 		dev_err(gc->dev, "GDMA queue type: %d, size: %u, gdma memory allocation err: %d\n",
 			spec->type, spec->queue_size, err);
@@ -1312,7 +1446,7 @@ int mana_gd_create_mana_wq_cq(struct gdma_dev *gd,
 	queue->id = INVALID_QUEUE_ID;
 
 	gmi = &queue->mem_info;
-	err = mana_gd_alloc_memory(gc, spec->queue_size, gmi);
+	err = mana_gd_alloc_memory(gc, spec->queue_size, gmi, true);
 	if (err) {
 		dev_err(gc->dev, "GDMA queue type: %d, size: %u, memory allocation err: %d\n",
 			spec->type, spec->queue_size, err);
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index e3c24d50dad0..263e7c4e2934 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -479,7 +479,7 @@ static int mana_hwc_alloc_dma_buf(struct hw_channel_context *hwc, u16 q_depth,
 	buf_size = MANA_PAGE_ALIGN(q_depth * max_msg_size);
 
 	gmi = &dma_buf->mem_info;
-	err = mana_gd_alloc_memory(gc, buf_size, gmi);
+	err = mana_gd_alloc_memory(gc, buf_size, gmi, false);
 	if (err) {
 		dev_err(hwc->dev, "Failed to allocate DMA buffer size: %u, err %d\n",
 			buf_size, err);
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 2519a98ad00b..b80371196804 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -40,6 +40,9 @@ static ssize_t mana_dbg_q_read(struct file *filp, char __user *buf, size_t count
 {
 	struct gdma_queue *gdma_q = filp->private_data;
 
+	if (gdma_q->mem_info.nr_pages)
+		return mana_gd_read_ring(gdma_q, buf, count, pos);
+
 	return simple_read_from_buffer(buf, count, pos, gdma_q->queue_mem_ptr,
 				       gdma_q->queue_size);
 }
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 8529cef0d7c4..b0b322a80b62 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -240,6 +240,14 @@ struct gdma_mem_info {
 	void *virt_addr;
 	u64 length;
 
+	/* Scattered fallback: when @nr_pages > 0 the ring is that many
+	 * PAGE_SIZE coherent allocations in @pages_va/@pages_dma, not
+	 * @virt_addr/@dma_handle.
+	 */
+	void **pages_va;
+	dma_addr_t *pages_dma;
+	unsigned int nr_pages;
+
 	/* Allocated by the PF driver */
 	u64 dma_region_handle;
 };
@@ -512,6 +520,9 @@ int mana_gd_poll_cq(struct gdma_queue *cq, struct gdma_comp *comp, int num_cqe);
 
 void mana_gd_ring_cq(struct gdma_queue *cq, u8 arm_bit);
 
+ssize_t mana_gd_read_ring(struct gdma_queue *q, char __user *buf,
+			  size_t count, loff_t *pos);
+
 int mana_schedule_serv_work(struct gdma_context *gc, enum gdma_eqe_type type);
 
 void mana_gd_ring_dim(struct gdma_queue *cq, u32 mod_usec, bool mod_usec_vld,
@@ -668,6 +679,9 @@ enum {
 /* Driver supports dynamic interrupt moderation - DIM */
 #define GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION BIT(28)
 
+/* Driver supports non-contiguous queue buffers */
+#define GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS BIT(30)
+
 #define GDMA_DRV_CAP_FLAGS1 \
 	(GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT | \
 	 GDMA_DRV_CAP_FLAG_1_NAPI_WKDONE_FIX | \
@@ -684,7 +698,8 @@ enum {
 	 GDMA_DRV_CAP_FLAG_1_HANDLE_STALL_SQ_RECOVERY | \
 	 GDMA_DRV_CAP_FLAG_1_HWC_TIMEOUT_RECOVERY | \
 	 GDMA_DRV_CAP_FLAG_1_EQ_MSI_UNSHARE_MULTI_VPORT | \
-	 GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION)
+	 GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION | \
+	 GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS)
 
 #define GDMA_DRV_CAP_FLAGS2 0
 
@@ -1045,7 +1060,7 @@ void mana_gd_wq_ring_doorbell(struct gdma_context *gc,
 			      struct gdma_queue *queue);
 
 int mana_gd_alloc_memory(struct gdma_context *gc, unsigned int length,
-			 struct gdma_mem_info *gmi);
+			 struct gdma_mem_info *gmi, bool allow_scatter);
 
 void mana_gd_free_memory(struct gdma_mem_info *gmi);
 
-- 
2.43.0

