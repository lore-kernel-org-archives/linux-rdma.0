From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH v2] lib/scatterlist: Provide a DMA page iterator
Date: Thu, 7 Feb 2019 22:26:52 +0000
Message-ID: <20190207222647.GA30974@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <7158A6D674FEAA4692D9F442D86369D9@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Stone <daniel@fooishbar.org>, "hch@lst.de" <hch@lst.de>, "Koenig, Christian" <Christian.Koenig@amd.com>, Thomas Hellstrom <thellstrom@vmware.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "yong.zhi@intel.com" <yong.zhi@intel.com>, "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "bingbu.cao@intel.com" <bingbu.cao@intel.com>, "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>, "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>, "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
List-Id: linux-rdma@vger.kernel.org

Commit 2db76d7c3c6d ("lib/scatterlist: sg_page_iter: support sg lists w/o
backing pages") introduced the sg_page_iter_dma_address() function without
providing a way to use it in the general case. If the sg_dma_len() is not
equal to the sg length callers cannot safely use the
for_each_sg_page/sg_page_iter_dma_address combination.

Resolve this API mistake by providing a DMA specific iterator,
for_each_sg_dma_page(), that uses the right length so
sg_page_iter_dma_address() works as expected with all sglists.

A new iterator type is introduced to provide compile-time safety against
wrongly mixing accessors and iterators.

Acked-by: Christoph Hellwig <hch@lst.de> (for scatterlist)
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 .clang-format                              |  1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c |  8 +++-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c   |  4 +-
 include/linux/scatterlist.h                | 49 ++++++++++++++++++----
 lib/scatterlist.c                          | 26 ++++++++++++
 5 files changed, 76 insertions(+), 12 deletions(-)

v2:
- Drop the vmwgfx fix in favor of keeping it unchanged as there is no
  reviewer. Use an ugly case with a comment instead.

I'd like to apply this to the RDMA tree next week, a large series from
Shiraz is waiting on it:

https://patchwork.kernel.org/project/linux-rdma/list/?series=3D71841&state=
=3D*

Regards,
Jason

diff --git a/.clang-format b/.clang-format
index bc2ffb2a0b5366..335ce29ab8132c 100644
--- a/.clang-format
+++ b/.clang-format
@@ -240,6 +240,7 @@ ForEachMacros:
   - 'for_each_set_bit'
   - 'for_each_set_bit_from'
   - 'for_each_sg'
+  - 'for_each_sg_dma_page'
   - 'for_each_sg_page'
   - 'for_each_sibling_event'
   - '__for_each_thread'
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c b/drivers/gpu/drm/v=
mwgfx/vmwgfx_ttm_buffer.c
index 31786b200afc47..e84f6aaee778f0 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
@@ -311,7 +311,13 @@ static dma_addr_t __vmw_piter_dma_addr(struct vmw_pite=
r *viter)
=20
 static dma_addr_t __vmw_piter_sg_addr(struct vmw_piter *viter)
 {
-	return sg_page_iter_dma_address(&viter->iter);
+	/*
+	 * FIXME: This driver wrongly mixes DMA and CPU SG list iteration and
+	 * needs revision. See
+	 * https://lore.kernel.org/lkml/20190104223531.GA1705@ziepe.ca/
+	 */
+	return sg_page_iter_dma_address(
+		(struct sg_dma_page_iter *)&viter->iter);
 }
=20
=20
diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/i=
ntel/ipu3/ipu3-cio2.c
index cdb79ae2d8dc72..c0a5ce1d13b0bc 100644
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
index b96f0d0b5b8f30..b4be960c7e5dba 100644
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
index 9ba349e775ef08..739dc9fe2c55ec 100644
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
+EXPORT_SYMBOL(__sg_page_iter_dma_next);
+
 /**
  * sg_miter_start - start mapping iteration over a sg list
  * @miter: sg mapping iter to be started
--=20
2.20.1
