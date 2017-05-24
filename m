From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH 13/16] block: bio: introduce bio_add_pfn
Date: Wed, 24 May 2017 15:42:24 -0600
Message-ID: <1495662147-18277-14-git-send-email-logang@deltatee.com>
References: <1495662147-18277-1-git-send-email-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1495662147-18277-1-git-send-email-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Berg <johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We introduce bio_add_pfn which is the same as bio_add_page but expects a
pfn_t instead of a page pointer. bio_add_page is then converted to be
an inline call to bio_add_pfn.

Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Signed-off-by: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
---
 block/bio.c           | 16 ++++++++--------
 include/linux/bio.h   | 19 ++++++++++++++++++-
 include/linux/pfn_t.h |  5 +++++
 3 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index e785f50..d8b6aeb 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -810,17 +810,17 @@ int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page
 EXPORT_SYMBOL(bio_add_pc_page);
 
 /**
- *	bio_add_page	-	attempt to add page to bio
+ *	bio_add_pfn	-	attempt to add pfn to bio
  *	@bio: destination bio
- *	@page: page to add
+ *	@pfn: pfn to add
  *	@len: vec entry length
  *	@offset: vec entry offset
  *
- *	Attempt to add a page to the bio_vec maplist. This will only fail
+ *	Attempt to add a pfn to the bio_vec maplist. This will only fail
  *	if either bio->bi_vcnt == bio->bi_max_vecs or it's a cloned bio.
  */
-int bio_add_page(struct bio *bio, struct page *page,
-		 unsigned int len, unsigned int offset)
+int bio_add_pfn(struct bio *bio, pfn_t pfn, unsigned int len,
+		unsigned int offset)
 {
 	struct bio_vec *bv;
 
@@ -838,7 +838,7 @@ int bio_add_page(struct bio *bio, struct page *page,
 	if (bio->bi_vcnt > 0) {
 		bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
-		if (page == bvec_page(bv) &&
+		if (pfn_t_equal(pfn, bv->bv_pfn) &&
 		    offset == bv->bv_offset + bv->bv_len) {
 			bv->bv_len += len;
 			goto done;
@@ -849,7 +849,7 @@ int bio_add_page(struct bio *bio, struct page *page,
 		return 0;
 
 	bv		= &bio->bi_io_vec[bio->bi_vcnt];
-	bvec_set_page(bv, page);
+	bv->bv_pfn	= pfn;
 	bv->bv_len	= len;
 	bv->bv_offset	= offset;
 
@@ -858,7 +858,7 @@ int bio_add_page(struct bio *bio, struct page *page,
 	bio->bi_iter.bi_size += len;
 	return len;
 }
-EXPORT_SYMBOL(bio_add_page);
+EXPORT_SYMBOL(bio_add_pfn);
 
 /**
  * bio_iov_iter_get_pages - pin user or kernel pages and add them to a bio
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 16c0b02..bc5f5d3 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -429,7 +429,24 @@ extern void bio_init(struct bio *bio, struct bio_vec *table,
 extern void bio_reset(struct bio *);
 void bio_chain(struct bio *, struct bio *);
 
-extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
+extern int bio_add_pfn(struct bio *bio, pfn_t, unsigned int, unsigned int);
+
+/**
+ *	bio_add_page	-	attempt to add page to bio
+ *	@bio: destination bio
+ *	@page: page to add
+ *	@len: vec entry length
+ *	@offset: vec entry offset
+ *
+ *	Attempt to add a pfn to the bio_vec maplist. This will only fail
+ *	if either bio->bi_vcnt == bio->bi_max_vecs or it's a cloned bio.
+ */
+static inline int bio_add_page(struct bio *bio, struct page *page,
+			       unsigned int len, unsigned int offset)
+{
+	return bio_add_pfn(bio, page_to_pfn_t(page), len, offset);
+}
+
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter);
diff --git a/include/linux/pfn_t.h b/include/linux/pfn_t.h
index 07bd5ba..9612c87 100644
--- a/include/linux/pfn_t.h
+++ b/include/linux/pfn_t.h
@@ -48,6 +48,11 @@ static inline pfn_t phys_to_pfn_t(phys_addr_t addr, u64 flags)
 	return __pfn_to_pfn_t(addr >> PAGE_SHIFT, flags);
 }
 
+static inline bool pfn_t_equal(pfn_t a, pfn_t b)
+{
+	return a.val == b.val;
+}
+
 static inline bool pfn_t_has_page(pfn_t pfn)
 {
 	return (pfn.val & PFN_MAP) == PFN_MAP || (pfn.val & PFN_DEV) == 0;
-- 
2.1.4
