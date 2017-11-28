From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH V2 rdma-rc 2/3] RDMA/hns: Get rid of virt_to_page and vmap calls after dma_alloc_coherent
Date: Tue, 28 Nov 2017 15:10:27 +0800
Message-ID: <1511853028-35191-3-git-send-email-xavier.huwei@huawei.com>
References: <1511853028-35191-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1511853028-35191-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, shaobo.xu@intel.com, xavier.huwei@tom.com, zhangxiping3@huawei.com
List-Id: linux-rdma@vger.kernel.org

In general dma_alloc_coherent() return a CPU virtual address and
a DMA address, and we have no guarantee that the virtual address
is either in the linear map or vmalloc, and not some other special
place. we have no guarantee that the underlying memory even has
an associated struct page at all.

In current code, there are incorrect usage as below:
dma_alloc_coherent + virt_to_page + vmap. There will probably
introduce coherency problem. This patch fixes it to get rid of
virt_to_page and vmap calls at Leon's suggestion. The related
link: https://lkml.org/lkml/2017/11/7/34

Fixes: 9a44353("IB/hns: Add driver files for hns RoCE driver")
Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Shaobo Xu <xushaobo2@huawei.com>
Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Yixian Liu <liuyixian@huawei.com>
Signed-off-by: Xiping Zhang (Francis) <zhangxiping3@huawei.com>
---
changelog:
 v1 -> v2: Revise the commit message and add Fixes line at Jason's
    comment. The related link: https://lkml.org/lkml/2017/11/27/841
---
 drivers/infiniband/hw/hns/hns_roce_alloc.c  | 23 -----------------------
 drivers/infiniband/hw/hns/hns_roce_device.h |  4 +---
 2 files changed, 1 insertion(+), 26 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_alloc.c b/drivers/infiniband/hw/hns/hns_roce_alloc.c
index 3e4c525..a40ec93 100644
--- a/drivers/infiniband/hw/hns/hns_roce_alloc.c
+++ b/drivers/infiniband/hw/hns/hns_roce_alloc.c
@@ -162,14 +162,10 @@ void hns_roce_buf_free(struct hns_roce_dev *hr_dev, u32 size,
 {
 	int i;
 	struct device *dev = hr_dev->dev;
-	u32 bits_per_long = BITS_PER_LONG;
 
 	if (buf->nbufs == 1) {
 		dma_free_coherent(dev, size, buf->direct.buf, buf->direct.map);
 	} else {
-		if (bits_per_long == 64 && buf->page_shift == PAGE_SHIFT)
-			vunmap(buf->direct.buf);
-
 		for (i = 0; i < buf->nbufs; ++i)
 			if (buf->page_list[i].buf)
 				dma_free_coherent(dev, 1 << buf->page_shift,
@@ -185,9 +181,7 @@ int hns_roce_buf_alloc(struct hns_roce_dev *hr_dev, u32 size, u32 max_direct,
 {
 	int i = 0;
 	dma_addr_t t;
-	struct page **pages;
 	struct device *dev = hr_dev->dev;
-	u32 bits_per_long = BITS_PER_LONG;
 	u32 page_size = 1 << page_shift;
 	u32 order;
 
@@ -236,23 +230,6 @@ int hns_roce_buf_alloc(struct hns_roce_dev *hr_dev, u32 size, u32 max_direct,
 			buf->page_list[i].map = t;
 			memset(buf->page_list[i].buf, 0, page_size);
 		}
-		if (bits_per_long == 64 && page_shift == PAGE_SHIFT) {
-			pages = kmalloc_array(buf->nbufs, sizeof(*pages),
-					      GFP_KERNEL);
-			if (!pages)
-				goto err_free;
-
-			for (i = 0; i < buf->nbufs; ++i)
-				pages[i] = virt_to_page(buf->page_list[i].buf);
-
-			buf->direct.buf = vmap(pages, buf->nbufs, VM_MAP,
-					       PAGE_KERNEL);
-			kfree(pages);
-			if (!buf->direct.buf)
-				goto err_free;
-		} else {
-			buf->direct.buf = NULL;
-		}
 	}
 
 	return 0;
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index dde5178..dcfd209 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -795,11 +795,9 @@ static inline void hns_roce_write64_k(__be32 val[2], void __iomem *dest)
 
 static inline void *hns_roce_buf_offset(struct hns_roce_buf *buf, int offset)
 {
-	u32 bits_per_long_val = BITS_PER_LONG;
 	u32 page_size = 1 << buf->page_shift;
 
-	if ((bits_per_long_val == 64 && buf->page_shift == PAGE_SHIFT) ||
-	    buf->nbufs == 1)
+	if (buf->nbufs == 1)
 		return (char *)(buf->direct.buf) + offset;
 	else
 		return (char *)(buf->page_list[offset >> buf->page_shift].buf) +
-- 
1.9.1
