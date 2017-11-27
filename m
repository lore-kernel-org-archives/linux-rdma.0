From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH 3/3] RDMA/hns: Get rid of page operation after dma_alloc_coherent
Date: Mon, 27 Nov 2017 10:41:24 +0800
Message-ID: <1511750484-102395-4-git-send-email-xavier.huwei@huawei.com>
References: <1511750484-102395-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1511750484-102395-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: xavier.huwei@huawei.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, xavier.huwei@tom.com, xavier_huwei@163.com, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

In general dma_alloc_coherent() return a CPU virtual address and
a DMA address, and we have no guarantee that the underlying memory
even has an associated struct page at all.

This patch gets rid of the page operation after dma_alloc_coherent,
and records the VA returned form dma_alloc_coherent in the struct
of hem.

Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Shaobo Xu <xushaobo2@huawei.com>
Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Yixian Liu <liuyixian@huawei.com>
Signed-off-by: Xiping Zhang (Francis) <zhangxiping3@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c | 25 +++++++++++++------------
 drivers/infiniband/hw/hns/hns_roce_hem.h |  1 +
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 8b733a6..0eeabfb 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -224,6 +224,7 @@ static struct hns_roce_hem *hns_roce_alloc_hem(struct hns_roce_dev *hr_dev,
 			sg_init_table(chunk->mem, HNS_ROCE_HEM_CHUNK_LEN);
 			chunk->npages = 0;
 			chunk->nsg = 0;
+			memset(chunk->buf, 0, sizeof(chunk->buf));
 			list_add_tail(&chunk->list, &hem->chunk_list);
 		}
 
@@ -240,8 +241,7 @@ static struct hns_roce_hem *hns_roce_alloc_hem(struct hns_roce_dev *hr_dev,
 		if (!buf)
 			goto fail;
 
-		sg_set_buf(mem, buf, PAGE_SIZE << order);
-		WARN_ON(mem->offset);
+		chunk->buf[chunk->npages] = buf;
 		sg_dma_len(mem) = PAGE_SIZE << order;
 
 		++chunk->npages;
@@ -267,8 +267,8 @@ void hns_roce_free_hem(struct hns_roce_dev *hr_dev, struct hns_roce_hem *hem)
 	list_for_each_entry_safe(chunk, tmp, &hem->chunk_list, list) {
 		for (i = 0; i < chunk->npages; ++i)
 			dma_free_coherent(hr_dev->dev,
-				   chunk->mem[i].length,
-				   lowmem_page_address(sg_page(&chunk->mem[i])),
+				   sg_dma_len(&chunk->mem[i]),
+				   chunk->buf[i],
 				   sg_dma_address(&chunk->mem[i]));
 		kfree(chunk);
 	}
@@ -722,11 +722,12 @@ void *hns_roce_table_find(struct hns_roce_dev *hr_dev,
 	struct hns_roce_hem_chunk *chunk;
 	struct hns_roce_hem_mhop mhop;
 	struct hns_roce_hem *hem;
-	struct page *page = NULL;
+	void *addr = NULL;
 	unsigned long mhop_obj = obj;
 	unsigned long obj_per_chunk;
 	unsigned long idx_offset;
 	int offset, dma_offset;
+	int length;
 	int i, j;
 	u32 hem_idx = 0;
 
@@ -763,25 +764,25 @@ void *hns_roce_table_find(struct hns_roce_dev *hr_dev,
 
 	list_for_each_entry(chunk, &hem->chunk_list, list) {
 		for (i = 0; i < chunk->npages; ++i) {
+			length = sg_dma_len(&chunk->mem[i]);
 			if (dma_handle && dma_offset >= 0) {
-				if (sg_dma_len(&chunk->mem[i]) >
-				    (u32)dma_offset)
+				if (length > (u32)dma_offset)
 					*dma_handle = sg_dma_address(
 						&chunk->mem[i]) + dma_offset;
-				dma_offset -= sg_dma_len(&chunk->mem[i]);
+				dma_offset -= length;
 			}
 
-			if (chunk->mem[i].length > (u32)offset) {
-				page = sg_page(&chunk->mem[i]);
+			if (length > (u32)offset) {
+				addr = chunk->buf[i] + offset;
 				goto out;
 			}
-			offset -= chunk->mem[i].length;
+			offset -= length;
 		}
 	}
 
 out:
 	mutex_unlock(&table->mutex);
-	return page ? lowmem_page_address(page) + offset : NULL;
+	return addr;
 }
 EXPORT_SYMBOL_GPL(hns_roce_table_find);
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.h b/drivers/infiniband/hw/hns/hns_roce_hem.h
index db66db1..e8850d5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.h
@@ -78,6 +78,7 @@ struct hns_roce_hem_chunk {
 	int			 npages;
 	int			 nsg;
 	struct scatterlist	 mem[HNS_ROCE_HEM_CHUNK_LEN];
+	void			 *buf[HNS_ROCE_HEM_CHUNK_LEN];
 };
 
 struct hns_roce_hem {
-- 
1.9.1
