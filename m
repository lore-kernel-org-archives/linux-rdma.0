From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Wed, 22 Jul 2015 09:55:28 +0300
Message-ID: <1437548143-24893-29-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The new fast registration is receiving a struct
scatterlist and converts it to a page list under
the verbs API. The user is provided with a new
verb ib_map_mr_sg, and a helper to set the send work
request structure.

The drivers are handed with a generic helper that
converts a scatterlist into a vector of pages.
Given that some drivers have a shadow mapped page list,
I expect that drivers might use their own routines to
avoid the extra copies.

The new registration API is added with fast_reg for
now, but once all drivers and ULPs will be ported, we
can drop the old registration API.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 123 ++++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h         |  37 ++++++++++++
 2 files changed, 160 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index beed431..9875163 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1481,3 +1481,126 @@ int ib_check_mr_status(struct ib_mr *mr, u32 check_mask,
 		mr->device->check_mr_status(mr, check_mask, mr_status) : -ENOSYS;
 }
 EXPORT_SYMBOL(ib_check_mr_status);
+
+
+/**
+ * ib_map_mr_sg() - Populates MR with a dma mapped SG list
+ * @mr:            memory region
+ * @sg:            dma mapped scatterlist
+ * @sg_nents:      number of entries in sg
+ * @access:        access permissions
+ *
+ * After this completes successfully, the memory region is ready
+ * for fast registration.
+ */
+int ib_map_mr_sg(struct ib_mr *mr,
+		 struct scatterlist *sg,
+		 unsigned short sg_nents,
+		 unsigned int access)
+{
+	int rc;
+
+	if (!mr->device->map_mr_sg)
+		return -ENOSYS;
+
+	rc = mr->device->map_mr_sg(mr, sg, sg_nents);
+	if (!rc)
+		mr->access = access;
+
+	return rc;
+}
+EXPORT_SYMBOL(ib_map_mr_sg);
+
+/**
+ * ib_sg_to_pages() - Convert a sg list to a page vector
+ * @dev:           ib device
+ * @sgl:           dma mapped scatterlist
+ * @sg_nents:      number of entries in sg
+ * @max_pages:     maximum pages allowed
+ * @pages:         output page vector
+ * @npages:        output number of mapped pages
+ * @length:        output total byte length
+ * @offset:        output first byte offset
+ *
+ * Core service helper for drivers to convert a scatter
+ * list to a page vector. The assumption is that the
+ * sg must meet the following conditions:
+ * - Only the first sg is allowed to have an offset
+ * - All the elements are of the same size - PAGE_SIZE
+ * - The last element is allowed to have length less than
+ *   PAGE_SIZE
+ *
+ * If any of those conditions is not met, the routine will
+ * fail with EINVAL.
+ */
+int ib_sg_to_pages(struct scatterlist *sgl,
+		   unsigned short sg_nents,
+		   unsigned short max_pages,
+		   u64 *pages, u32 *npages,
+		   u32 *length, u64 *offset)
+{
+	struct scatterlist *sg;
+	u64 last_end_dma_addr = 0, last_page_addr = 0;
+	unsigned int last_page_off = 0;
+	int i, j = 0;
+
+	/* TODO: We can do better with huge pages */
+
+	*offset = sg_dma_address(&sgl[0]);
+	*length = 0;
+
+	for_each_sg(sgl, sg, sg_nents, i) {
+		u64 dma_addr = sg_dma_address(sg);
+		unsigned int dma_len = sg_dma_len(sg);
+		u64 end_dma_addr = dma_addr + dma_len;
+		u64 page_addr = dma_addr & PAGE_MASK;
+
+		*length += dma_len;
+
+		/* Fail we ran out of pages */
+		if (unlikely(j > max_pages))
+			return -EINVAL;
+
+		if (i && sg->offset) {
+			if (unlikely((last_end_dma_addr) != dma_addr)) {
+				/* gap - fail */
+				goto err;
+			}
+			if (last_page_off + dma_len < PAGE_SIZE) {
+				/* chunk this fragment with the last */
+				last_end_dma_addr += dma_len;
+				last_page_off += dma_len;
+				continue;
+			} else {
+				/* map starting from the next page */
+				page_addr = last_page_addr + PAGE_SIZE;
+				dma_len -= PAGE_SIZE - last_page_off;
+			}
+		}
+
+		do {
+			pages[j++] = page_addr;
+			page_addr += PAGE_SIZE;
+		} while (page_addr < end_dma_addr);
+
+		last_end_dma_addr = end_dma_addr;
+		last_page_addr = end_dma_addr & PAGE_MASK;
+		last_page_off = end_dma_addr & ~PAGE_MASK;
+	}
+
+	*npages = j;
+
+	return 0;
+err:
+	pr_err("RDMA alignment violation\n");
+	for_each_sg(sgl, sg, sg_nents, i) {
+		u64 dma_addr = sg_dma_address(sg);
+		unsigned int dma_len = sg_dma_len(sg);
+
+		pr_err("sg[%d]: offset=0x%x, dma_addr=0x%llx, dma_len=0x%x\n",
+			i, sg->offset, dma_addr, dma_len);
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(ib_sg_to_pages);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 7a93e2d..d543fee 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1013,6 +1013,7 @@ enum ib_wr_opcode {
 	IB_WR_RDMA_READ_WITH_INV,
 	IB_WR_LOCAL_INV,
 	IB_WR_FAST_REG_MR,
+	IB_WR_FASTREG_MR,
 	IB_WR_MASKED_ATOMIC_CMP_AND_SWP,
 	IB_WR_MASKED_ATOMIC_FETCH_AND_ADD,
 	IB_WR_BIND_MW,
@@ -1117,6 +1118,10 @@ struct ib_send_wr {
 			u32				rkey;
 		} fast_reg;
 		struct {
+			struct ib_mr *mr;
+			u32          key;
+		} fastreg;
+		struct {
 			struct ib_mw            *mw;
 			/* The new rkey for the memory window. */
 			u32                      rkey;
@@ -1316,6 +1321,9 @@ struct ib_mr {
 	struct ib_uobject *uobject;
 	u32		   lkey;
 	u32		   rkey;
+	int		   access;
+	u64		   iova;
+	u32		   length;
 	atomic_t	   usecnt; /* count number of MWs */
 };
 
@@ -1661,6 +1669,9 @@ struct ib_device {
 					       enum ib_mr_type mr_type,
 					       u32 max_entries,
 					       u32 flags);
+	int                        (*map_mr_sg)(struct ib_mr *mr,
+						struct scatterlist *sg,
+						unsigned short sg_nents);
 	struct ib_fast_reg_page_list * (*alloc_fast_reg_page_list)(struct ib_device *device,
 								   int page_list_len);
 	void			   (*free_fast_reg_page_list)(struct ib_fast_reg_page_list *page_list);
@@ -2991,4 +3002,30 @@ static inline int ib_check_mr_access(int flags)
 int ib_check_mr_status(struct ib_mr *mr, u32 check_mask,
 		       struct ib_mr_status *mr_status);
 
+int ib_map_mr_sg(struct ib_mr *mr,
+		 struct scatterlist *sg,
+		 unsigned short sg_nents,
+		 unsigned int access);
+
+int ib_sg_to_pages(struct scatterlist *sgl,
+		   unsigned short sg_nents,
+		   unsigned short max_pages,
+		   u64 *pages, u32 *npages,
+		   u32 *length, u64 *offset);
+
+static inline void
+ib_set_fastreg_wr(struct ib_mr *mr,
+		  u32 key,
+		  uintptr_t wr_id,
+		  bool signaled,
+		  struct ib_send_wr *wr)
+{
+	wr->opcode = IB_WR_FASTREG_MR;
+	wr->wr_id = wr_id;
+	wr->send_flags = signaled ? IB_SEND_SIGNALED : 0;
+	wr->num_sge = 0;
+	wr->wr.fastreg.mr = mr;
+	wr->wr.fastreg.key = key;
+}
+
 #endif /* IB_VERBS_H */
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
