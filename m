From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Fri, 4 Jan 2019 22:35:43 +0000
Message-ID: <20190104223531.GA1705@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <F99263AB32E56543B99CB6F9EEB8B483@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Shiraz Saleem <shiraz.saleem@intel.com>, Imre Deak <imre.deak@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, Yong Zhi <yong.zhi@intel.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, Bingbu Cao <bingbu.cao@intel.com>, Tian Shu Qiu <tian.shu.qiu@intel.com>, Jian Xu Zheng <jian.xu.zheng@intel.com>, Sinclair Yeh <syeh@vmware.com>, Thomas Hellstrom <thellstrom@vmware.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
List-Id: linux-rdma@vger.kernel.org

Commit 2db76d7c3c6d ("lib/scatterlist: sg_page_iter: support sg lists w/o
backing pages") introduced the sg_page_iter_dma_address() function without
providing a way to use it in the general case. If the sg_dma_len is not
equal to the dma_length callers cannot safely use the
for_each_sg_page/sg_page_iter_dma_address combination.

Resolve this API mistake by providing a DMA specific iterator,
for_each_sg_dma_page(), that uses the right length so
sg_page_iter_dma_address() works as expected with all sglists. A new
iterator type is introduced to provide compile-time safety against wrongly
mixing accessors and iterators.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h        | 26 ++++++++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_mob.c        | 26 +++++++-----
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c | 42 +++++++++++++------
 drivers/media/pci/intel/ipu3/ipu3-cio2.c   |  4 +-
 include/linux/scatterlist.h                | 49 ++++++++++++++++++----
 lib/scatterlist.c                          | 26 ++++++++++++
 6 files changed, 134 insertions(+), 39 deletions(-)

I'd like to run this patch through the RDMA tree as we have another
series in the works that wants to use the for_each_sg_dma_page() API.

The changes to vmwgfx make me nervous, it would be great if someone
could test and ack them?

Changes since the RFC:
- Rework vmwgfx too [CH]
- Use a distinct type for the DMA page iterator [CH]
- Do not have a #ifdef [CH]

Thanks,
Jason

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h b/drivers/gpu/drm/vmwgfx/v=
mwgfx_drv.h
index 59f614225bcd72..3c6d71e13a9342 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -297,7 +297,10 @@ struct vmw_sg_table {
 struct vmw_piter {
 	struct page **pages;
 	const dma_addr_t *addrs;
-	struct sg_page_iter iter;
+	union {
+		struct sg_page_iter iter;
+		struct sg_dma_page_iter dma_iter;
+	};
 	unsigned long i;
 	unsigned long num_pages;
 	bool (*next)(struct vmw_piter *);
@@ -869,9 +872,24 @@ extern int vmw_bo_map_dma(struct ttm_buffer_object *bo=
);
 extern void vmw_bo_unmap_dma(struct ttm_buffer_object *bo);
 extern const struct vmw_sg_table *
 vmw_bo_sg_table(struct ttm_buffer_object *bo);
-extern void vmw_piter_start(struct vmw_piter *viter,
-			    const struct vmw_sg_table *vsgt,
-			    unsigned long p_offs);
+void _vmw_piter_start(struct vmw_piter *viter, const struct vmw_sg_table *=
vsgt,
+		      unsigned long p_offs, bool for_dma);
+
+/* Create a piter that can call vmw_piter_dma_addr() */
+static inline void vmw_piter_start(struct vmw_piter *viter,
+				   const struct vmw_sg_table *vsgt,
+				   unsigned long p_offs)
+{
+	_vmw_piter_start(viter, vsgt, p_offs, true);
+}
+
+/* Create a piter that can call vmw_piter_page() */
+static inline void vmw_piter_cpu_start(struct vmw_piter *viter,
+				   const struct vmw_sg_table *vsgt,
+				   unsigned long p_offs)
+{
+	_vmw_piter_start(viter, vsgt, p_offs, false);
+}
=20
 /**
  * vmw_piter_next - Advance the iterator one page.
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c b/drivers/gpu/drm/vmwgfx/v=
mwgfx_mob.c
index 7ed179d30ec51f..a13788017ad608 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
@@ -503,7 +503,8 @@ static void vmw_mob_assign_ppn(u32 **addr, dma_addr_t v=
al)
  */
 static unsigned long vmw_mob_build_pt(struct vmw_piter *data_iter,
 				      unsigned long num_data_pages,
-				      struct vmw_piter *pt_iter)
+				      struct vmw_piter *pt_iter_cpu,
+				      struct vmw_piter *pt_iter_dma)
 {
 	unsigned long pt_size =3D num_data_pages * VMW_PPN_SIZE;
 	unsigned long num_pt_pages =3D DIV_ROUND_UP(pt_size, PAGE_SIZE);
@@ -513,7 +514,7 @@ static unsigned long vmw_mob_build_pt(struct vmw_piter =
*data_iter,
 	struct page *page;
=20
 	for (pt_page =3D 0; pt_page < num_pt_pages; ++pt_page) {
-		page =3D vmw_piter_page(pt_iter);
+		page =3D vmw_piter_page(pt_iter_cpu);
=20
 		save_addr =3D addr =3D kmap_atomic(page);
=20
@@ -525,7 +526,8 @@ static unsigned long vmw_mob_build_pt(struct vmw_piter =
*data_iter,
 			WARN_ON(!vmw_piter_next(data_iter));
 		}
 		kunmap_atomic(save_addr);
-		vmw_piter_next(pt_iter);
+		vmw_piter_next(pt_iter_cpu);
+		vmw_piter_next(pt_iter_dma);
 	}
=20
 	return num_pt_pages;
@@ -547,29 +549,31 @@ static void vmw_mob_pt_setup(struct vmw_mob *mob,
 {
 	unsigned long num_pt_pages =3D 0;
 	struct ttm_buffer_object *bo =3D mob->pt_bo;
-	struct vmw_piter save_pt_iter;
-	struct vmw_piter pt_iter;
+	struct vmw_piter pt_iter_cpu, pt_iter_dma;
 	const struct vmw_sg_table *vsgt;
+	dma_addr_t root_page =3D 0;
 	int ret;
=20
 	ret =3D ttm_bo_reserve(bo, false, true, NULL);
 	BUG_ON(ret !=3D 0);
=20
 	vsgt =3D vmw_bo_sg_table(bo);
-	vmw_piter_start(&pt_iter, vsgt, 0);
-	BUG_ON(!vmw_piter_next(&pt_iter));
+	vmw_piter_start(&pt_iter_dma, vsgt, 0);
+	vmw_piter_cpu_start(&pt_iter_cpu, vsgt, 0);
+	BUG_ON(!vmw_piter_next(&pt_iter_cpu));
+	BUG_ON(!vmw_piter_next(&pt_iter_dma));
 	mob->pt_level =3D 0;
 	while (likely(num_data_pages > 1)) {
 		++mob->pt_level;
 		BUG_ON(mob->pt_level > 2);
-		save_pt_iter =3D pt_iter;
+		root_page =3D vmw_piter_dma_addr(&pt_iter_dma);
 		num_pt_pages =3D vmw_mob_build_pt(&data_iter, num_data_pages,
-						&pt_iter);
-		data_iter =3D save_pt_iter;
+						&pt_iter_cpu, &pt_iter_dma);
+		vmw_piter_start(&data_iter, vsgt, 0);
 		num_data_pages =3D num_pt_pages;
 	}
=20
-	mob->pt_root_page =3D vmw_piter_dma_addr(&save_pt_iter);
+	mob->pt_root_page =3D root_page;
 	ttm_bo_unreserve(bo);
 }
=20
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c b/drivers/gpu/drm/v=
mwgfx/vmwgfx_ttm_buffer.c
index 31786b200afc47..db8f3e40a4facb 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
@@ -269,6 +269,11 @@ static bool __vmw_piter_sg_next(struct vmw_piter *vite=
r)
 	return __sg_page_iter_next(&viter->iter);
 }
=20
+static bool __vmw_piter_sg_dma_next(struct vmw_piter *viter)
+{
+	return __sg_page_iter_dma_next(&viter->dma_iter);
+}
+
=20
 /**
  * Helper functions to return a pointer to the current page.
@@ -309,9 +314,9 @@ static dma_addr_t __vmw_piter_dma_addr(struct vmw_piter=
 *viter)
 	return viter->addrs[viter->i];
 }
=20
-static dma_addr_t __vmw_piter_sg_addr(struct vmw_piter *viter)
+static dma_addr_t __vmw_piter_sg_dma_addr(struct vmw_piter *viter)
 {
-	return sg_page_iter_dma_address(&viter->iter);
+	return sg_page_iter_dma_address(&viter->dma_iter);
 }
=20
=20
@@ -325,32 +330,43 @@ static dma_addr_t __vmw_piter_sg_addr(struct vmw_pite=
r *viter)
  * the iterator doesn't point to a valid page after initialization; it has
  * to be advanced one step first.
  */
-void vmw_piter_start(struct vmw_piter *viter, const struct vmw_sg_table *v=
sgt,
-		     unsigned long p_offset)
+void _vmw_piter_start(struct vmw_piter *viter, const struct vmw_sg_table *=
vsgt,
+		      unsigned long p_offset, bool for_dma)
 {
 	viter->i =3D p_offset - 1;
 	viter->num_pages =3D vsgt->num_pages;
 	switch (vsgt->mode) {
 	case vmw_dma_phys:
 		viter->next =3D &__vmw_piter_non_sg_next;
-		viter->dma_address =3D &__vmw_piter_phys_addr;
-		viter->page =3D &__vmw_piter_non_sg_page;
+		if (for_dma)
+			viter->dma_address =3D &__vmw_piter_phys_addr;
+		else
+			viter->page =3D &__vmw_piter_non_sg_page;
 		viter->pages =3D vsgt->pages;
 		break;
 	case vmw_dma_alloc_coherent:
 		viter->next =3D &__vmw_piter_non_sg_next;
-		viter->dma_address =3D &__vmw_piter_dma_addr;
-		viter->page =3D &__vmw_piter_non_sg_page;
+		if (for_dma)
+			viter->dma_address =3D &__vmw_piter_dma_addr;
+		else
+			viter->page =3D &__vmw_piter_non_sg_page;
 		viter->addrs =3D vsgt->addrs;
 		viter->pages =3D vsgt->pages;
 		break;
 	case vmw_dma_map_populate:
 	case vmw_dma_map_bind:
-		viter->next =3D &__vmw_piter_sg_next;
-		viter->dma_address =3D &__vmw_piter_sg_addr;
-		viter->page =3D &__vmw_piter_sg_page;
-		__sg_page_iter_start(&viter->iter, vsgt->sgt->sgl,
-				     vsgt->sgt->orig_nents, p_offset);
+		if (for_dma) {
+			viter->next =3D &__vmw_piter_sg_dma_next;
+			viter->dma_address =3D &__vmw_piter_sg_dma_addr;
+			__sg_page_iter_start(&viter->dma_iter.base,
+					     vsgt->sgt->sgl,
+					     vsgt->sgt->orig_nents, p_offset);
+		} else {
+			viter->next =3D &__vmw_piter_sg_next;
+			viter->page =3D &__vmw_piter_sg_page;
+			__sg_page_iter_start(&viter->iter, vsgt->sgt->sgl,
+					     vsgt->sgt->orig_nents, p_offset);
+		}
 		break;
 	default:
 		BUG();
diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/i=
ntel/ipu3/ipu3-cio2.c
index 447baaebca4486..32b6c6c217a46c 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -846,7 +846,7 @@ static int cio2_vb2_buf_init(struct vb2_buffer *vb)
 	unsigned int pages =3D DIV_ROUND_UP(vb->planes[0].length, CIO2_PAGE_SIZE)=
;
 	unsigned int lops =3D DIV_ROUND_UP(pages + 1, entries_per_page);
 	struct sg_table *sg;
-	struct sg_page_iter sg_iter;
+	struct sg_dma_page_iter sg_iter;
 	int i, j;
=20
 	if (lops <=3D 0 || lops > CIO2_MAX_LOPS) {
@@ -873,7 +873,7 @@ static int cio2_vb2_buf_init(struct vb2_buffer *vb)
 		b->offset =3D sg->sgl->offset;
=20
 	i =3D j =3D 0;
-	for_each_sg_page(sg->sgl, &sg_iter, sg->nents, 0) {
+	for_each_sg_dma_page(sg->sgl, &sg_iter, sg->nents, 0) {
 		if (!pages--)
 			break;
 		b->lop[i][j] =3D sg_page_iter_dma_address(&sg_iter) >> PAGE_SHIFT;
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 093aa57120b0cf..c0592284e18b97 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -339,12 +339,12 @@ int sg_alloc_table_chained(struct sg_table *table, in=
t nents,
 /*
  * sg page iterator
  *
- * Iterates over sg entries page-by-page.  On each successful iteration,
- * you can call sg_page_iter_page(@piter) and sg_page_iter_dma_address(@pi=
ter)
- * to get the current page and its dma address. @piter->sg will point to t=
he
- * sg holding this page and @piter->sg_pgoffset to the page's page offset
- * within the sg. The iteration will stop either when a maximum number of =
sg
- * entries was reached or a terminating sg (sg_last(sg) =3D=3D true) was r=
eached.
+ * Iterates over sg entries page-by-page.  On each successful iteration, y=
ou
+ * can call sg_page_iter_page(@piter) to get the current page and its dma
+ * address. @piter->sg will point to the sg holding this page and
+ * @piter->sg_pgoffset to the page's page offset within the sg. The iterat=
ion
+ * will stop either when a maximum number of sg entries was reached or a
+ * terminating sg (sg_last(sg) =3D=3D true) was reached.
  */
 struct sg_page_iter {
 	struct scatterlist	*sg;		/* sg holding the page */
@@ -356,7 +356,19 @@ struct sg_page_iter {
 						 * next step */
 };
=20
+/*
+ * sg page iterator for DMA addresses
+ *
+ * This is the same as sg_page_iter however you can call
+ * sg_page_iter_dma_address(@dma_iter) to get the page's DMA
+ * address. sg_page_iter_page() cannot be called on this iterator.
+ */
+struct sg_dma_page_iter {
+	struct sg_page_iter base;
+};
+
 bool __sg_page_iter_next(struct sg_page_iter *piter);
+bool __sg_page_iter_dma_next(struct sg_dma_page_iter *dma_iter);
 void __sg_page_iter_start(struct sg_page_iter *piter,
 			  struct scatterlist *sglist, unsigned int nents,
 			  unsigned long pgoffset);
@@ -372,11 +384,13 @@ static inline struct page *sg_page_iter_page(struct s=
g_page_iter *piter)
 /**
  * sg_page_iter_dma_address - get the dma address of the current page held=
 by
  * the page iterator.
- * @piter:	page iterator holding the page
+ * @dma_iter:	page iterator holding the page
  */
-static inline dma_addr_t sg_page_iter_dma_address(struct sg_page_iter *pit=
er)
+static inline dma_addr_t
+sg_page_iter_dma_address(struct sg_dma_page_iter *dma_iter)
 {
-	return sg_dma_address(piter->sg) + (piter->sg_pgoffset << PAGE_SHIFT);
+	return sg_dma_address(dma_iter->base.sg) +
+	       (dma_iter->base.sg_pgoffset << PAGE_SHIFT);
 }
=20
 /**
@@ -385,11 +399,28 @@ static inline dma_addr_t sg_page_iter_dma_address(str=
uct sg_page_iter *piter)
  * @piter:	page iterator to hold current page, sg, sg_pgoffset
  * @nents:	maximum number of sg entries to iterate over
  * @pgoffset:	starting page offset
+ *
+ * Callers may use sg_page_iter_page() to get each page pointer.
  */
 #define for_each_sg_page(sglist, piter, nents, pgoffset)		   \
 	for (__sg_page_iter_start((piter), (sglist), (nents), (pgoffset)); \
 	     __sg_page_iter_next(piter);)
=20
+/**
+ * for_each_sg_dma_page - iterate over the pages of the given sg list
+ * @sglist:	sglist to iterate over
+ * @dma_iter:	page iterator to hold current page
+ * @dma_nents:	maximum number of sg entries to iterate over, this is the v=
alue
+ *              returned from dma_map_sg
+ * @pgoffset:	starting page offset
+ *
+ * Callers may use sg_page_iter_dma_address() to get each page's DMA addre=
ss.
+ */
+#define for_each_sg_dma_page(sglist, dma_iter, dma_nents, pgoffset)       =
     \
+	for (__sg_page_iter_start(&(dma_iter)->base, sglist, dma_nents,        \
+				  pgoffset);                                   \
+	     __sg_page_iter_dma_next(dma_iter);)
+
 /*
  * Mapping sg iterator
  *
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 7c6096a7170486..716a751be67357 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -625,6 +625,32 @@ bool __sg_page_iter_next(struct sg_page_iter *piter)
 }
 EXPORT_SYMBOL(__sg_page_iter_next);
=20
+static int sg_dma_page_count(struct scatterlist *sg)
+{
+	return PAGE_ALIGN(sg->offset + sg_dma_len(sg)) >> PAGE_SHIFT;
+}
+
+bool __sg_page_iter_dma_next(struct sg_dma_page_iter *dma_iter)
+{
+	struct sg_page_iter *piter =3D &dma_iter->base;
+
+	if (!piter->__nents || !piter->sg)
+		return false;
+
+	piter->sg_pgoffset +=3D piter->__pg_advance;
+	piter->__pg_advance =3D 1;
+
+	while (piter->sg_pgoffset >=3D sg_dma_page_count(piter->sg)) {
+		piter->sg_pgoffset -=3D sg_dma_page_count(piter->sg);
+		piter->sg =3D sg_next(piter->sg);
+		if (!--piter->__nents || !piter->sg)
+			return false;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(__sg_page_iter_next);
+
 /**
  * sg_miter_start - start mapping iteration over a sg list
  * @miter: sg mapping iter to be started
--=20
2.20.1
