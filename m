From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH for-next 2/4] RDMA/hns: Add IOMMU enable support in hip08
Date: Sat, 30 Sep 2017 17:28:59 +0800
Message-ID: <1506763741-81429-3-git-send-email-xavier.huwei@huawei.com>
References: <1506763741-81429-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1506763741-81429-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, xavier.huwei@huawei.com, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, xushaobo2@huawei.com, zhangxiping3@huawei.com, xavier.huwei@tom.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, shaobohsu@163.com, shaoboxu@tom.com
List-Id: linux-rdma@vger.kernel.org

If the IOMMU is enabled, the length of sg obtained from
__iommu_map_sg_attrs is not 4kB. When the IOVA is set with the sg
dma address, the IOVA will not be page continuous. and the VA
returned from dma_alloc_coherent is a vmalloc address. However,
the VA obtained by the page_address is a discontinuous VA. Under
these circumstances, the IOVA should be calculated based on the
sg length, and record the VA returned from dma_alloc_coherent
in the struct of hem.

Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Shaobo Xu <xushaobo2@huawei.com>
Signed-off-by: Lijun Ou <oulijun@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_alloc.c |  5 ++++-
 drivers/infiniband/hw/hns/hns_roce_hem.c   | 30 +++++++++++++++++++++++++++---
 drivers/infiniband/hw/hns/hns_roce_hem.h   |  6 ++++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 22 +++++++++++++++-------
 4 files changed, 52 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_alloc.c b/drivers/infiniband/hw/hns/hns_roce_alloc.c
index 3e4c525..a69cd4b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_alloc.c
+++ b/drivers/infiniband/hw/hns/hns_roce_alloc.c
@@ -243,7 +243,10 @@ int hns_roce_buf_alloc(struct hns_roce_dev *hr_dev, u32 size, u32 max_direct,
 				goto err_free;
 
 			for (i = 0; i < buf->nbufs; ++i)
-				pages[i] = virt_to_page(buf->page_list[i].buf);
+				pages[i] =
+					is_vmalloc_addr(buf->page_list[i].buf) ?
+					vmalloc_to_page(buf->page_list[i].buf) :
+					virt_to_page(buf->page_list[i].buf);
 
 			buf->direct.buf = vmap(pages, buf->nbufs, VM_MAP,
 					       PAGE_KERNEL);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 8388ae2..4a3d1d4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -200,6 +200,7 @@ static struct hns_roce_hem *hns_roce_alloc_hem(struct hns_roce_dev *hr_dev,
 					       gfp_t gfp_mask)
 {
 	struct hns_roce_hem_chunk *chunk = NULL;
+	struct hns_roce_vmalloc *vmalloc;
 	struct hns_roce_hem *hem;
 	struct scatterlist *mem;
 	int order;
@@ -227,6 +228,7 @@ static struct hns_roce_hem *hns_roce_alloc_hem(struct hns_roce_dev *hr_dev,
 			sg_init_table(chunk->mem, HNS_ROCE_HEM_CHUNK_LEN);
 			chunk->npages = 0;
 			chunk->nsg = 0;
+			memset(chunk->vmalloc, 0, sizeof(chunk->vmalloc));
 			list_add_tail(&chunk->list, &hem->chunk_list);
 		}
 
@@ -243,7 +245,15 @@ static struct hns_roce_hem *hns_roce_alloc_hem(struct hns_roce_dev *hr_dev,
 		if (!buf)
 			goto fail;
 
-		sg_set_buf(mem, buf, PAGE_SIZE << order);
+		if (is_vmalloc_addr(buf)) {
+			vmalloc = &chunk->vmalloc[chunk->npages];
+			vmalloc->is_vmalloc_addr = true;
+			vmalloc->vmalloc_addr = buf;
+			sg_set_page(mem, vmalloc_to_page(buf),
+				    PAGE_SIZE << order, offset_in_page(buf));
+		} else {
+			sg_set_buf(mem, buf, PAGE_SIZE << order);
+		}
 		WARN_ON(mem->offset);
 		sg_dma_len(mem) = PAGE_SIZE << order;
 
@@ -262,17 +272,25 @@ static struct hns_roce_hem *hns_roce_alloc_hem(struct hns_roce_dev *hr_dev,
 void hns_roce_free_hem(struct hns_roce_dev *hr_dev, struct hns_roce_hem *hem)
 {
 	struct hns_roce_hem_chunk *chunk, *tmp;
+	void *cpu_addr;
 	int i;
 
 	if (!hem)
 		return;
 
 	list_for_each_entry_safe(chunk, tmp, &hem->chunk_list, list) {
-		for (i = 0; i < chunk->npages; ++i)
+		for (i = 0; i < chunk->npages; ++i) {
+			if (chunk->vmalloc[i].is_vmalloc_addr)
+				cpu_addr = chunk->vmalloc[i].vmalloc_addr;
+			else
+				cpu_addr =
+				   lowmem_page_address(sg_page(&chunk->mem[i]));
+
 			dma_free_coherent(hr_dev->dev,
 				   chunk->mem[i].length,
-				   lowmem_page_address(sg_page(&chunk->mem[i])),
+				   cpu_addr,
 				   sg_dma_address(&chunk->mem[i]));
+		}
 		kfree(chunk);
 	}
 
@@ -774,6 +792,12 @@ void *hns_roce_table_find(struct hns_roce_dev *hr_dev,
 
 			if (chunk->mem[i].length > (u32)offset) {
 				page = sg_page(&chunk->mem[i]);
+				if (chunk->vmalloc[i].is_vmalloc_addr) {
+					mutex_unlock(&table->mutex);
+					return page ?
+						chunk->vmalloc[i].vmalloc_addr
+						+ offset : NULL;
+				}
 				goto out;
 			}
 			offset -= chunk->mem[i].length;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.h b/drivers/infiniband/hw/hns/hns_roce_hem.h
index af28bbf..62d712a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.h
@@ -72,11 +72,17 @@ enum {
 	 HNS_ROCE_HEM_PAGE_SIZE  = 1 << HNS_ROCE_HEM_PAGE_SHIFT,
 };
 
+struct hns_roce_vmalloc {
+	bool	is_vmalloc_addr;
+	void	*vmalloc_addr;
+};
+
 struct hns_roce_hem_chunk {
 	struct list_head	 list;
 	int			 npages;
 	int			 nsg;
 	struct scatterlist	 mem[HNS_ROCE_HEM_CHUNK_LEN];
+	struct hns_roce_vmalloc	 vmalloc[HNS_ROCE_HEM_CHUNK_LEN];
 };
 
 struct hns_roce_hem {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index b99d70a..9e19bf1 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1093,9 +1093,11 @@ static int hns_roce_v2_write_mtpt(void *mb_buf, struct hns_roce_mr *mr,
 {
 	struct hns_roce_v2_mpt_entry *mpt_entry;
 	struct scatterlist *sg;
+	u64 page_addr = 0;
 	u64 *pages;
+	int i = 0, j = 0;
+	int len = 0;
 	int entry;
-	int i;
 
 	mpt_entry = mb_buf;
 	memset(mpt_entry, 0, sizeof(*mpt_entry));
@@ -1153,14 +1155,20 @@ static int hns_roce_v2_write_mtpt(void *mb_buf, struct hns_roce_mr *mr,
 
 	i = 0;
 	for_each_sg(mr->umem->sg_head.sgl, sg, mr->umem->nmap, entry) {
-		pages[i] = ((u64)sg_dma_address(sg)) >> 6;
-
-		/* Record the first 2 entry directly to MTPT table */
-		if (i >= HNS_ROCE_V2_MAX_INNER_MTPT_NUM - 1)
-			break;
-		i++;
+		len = sg_dma_len(sg) >> PAGE_SHIFT;
+		for (j = 0; j < len; ++j) {
+			page_addr = sg_dma_address(sg) +
+				    (j << mr->umem->page_shift);
+			pages[i] = page_addr >> 6;
+
+			/* Record the first 2 entry directly to MTPT table */
+			if (i >= HNS_ROCE_V2_MAX_INNER_MTPT_NUM - 1)
+				goto found;
+			i++;
+		}
 	}
 
+found:
 	mpt_entry->pa0_l = cpu_to_le32(lower_32_bits(pages[0]));
 	roce_set_field(mpt_entry->byte_56_pa0_h, V2_MPT_BYTE_56_PA0_H_M,
 		       V2_MPT_BYTE_56_PA0_H_S,
-- 
1.9.1
