From: Logan Gunthorpe <logang@deltatee.com>
Subject: [RFC PATCH 15/28] block: Support counting dma-direct bio segments
Date: Thu, 20 Jun 2019 10:12:27 -0600
Message-ID: <20190620161240.22738-16-logang@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190620161240.22738-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>, Logan Gunthorpe <logang@deltatee.com>
List-Id: linux-rdma@vger.kernel.org

Change __blk_recalc_rq_segments() to loop through dma_vecs when
appropriate. It calls vec_split_segs() for each dma_vec or bio_vec.

Once this is done the bvec_split_segs() helper is no longer used.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 block/blk-merge.c | 41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index c4c016f994f6..a7a5453987f9 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -194,13 +194,6 @@ static bool vec_split_segs(struct request_queue *q, unsigned offset,
 	return !!len;
 }
 
-static bool bvec_split_segs(struct request_queue *q, struct bio_vec *bv,
-		unsigned *nsegs, unsigned *sectors, unsigned max_segs)
-{
-	return vec_split_segs(q, bv->bv_offset, bv->bv_len, nsegs,
-			      sectors, max_segs);
-}
-
 struct blk_segment_split_ctx {
 	unsigned nsegs;
 	unsigned sectors;
@@ -366,12 +359,36 @@ void blk_queue_split(struct request_queue *q, struct bio **bio)
 }
 EXPORT_SYMBOL(blk_queue_split);
 
+static unsigned int bio_calc_segs(struct request_queue *q, struct bio *bio)
+{
+	unsigned int nsegs = 0;
+	struct bvec_iter iter;
+	struct bio_vec bv;
+
+	bio_for_each_bvec(bv, bio, iter)
+		vec_split_segs(q, bv.bv_offset, bv.bv_len, &nsegs,
+			       NULL, UINT_MAX);
+
+	return nsegs;
+}
+
+static unsigned int bio_dma_calc_segs(struct request_queue *q, struct bio *bio)
+{
+	unsigned int nsegs = 0;
+	struct bvec_iter iter;
+	struct dma_vec dv;
+
+	bio_for_each_dvec(dv, bio, iter)
+		vec_split_segs(q, dv.dv_addr, dv.dv_len, &nsegs,
+			       NULL, UINT_MAX);
+
+	return nsegs;
+}
+
 static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 					     struct bio *bio)
 {
 	unsigned int nr_phys_segs = 0;
-	struct bvec_iter iter;
-	struct bio_vec bv;
 
 	if (!bio)
 		return 0;
@@ -386,8 +403,10 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 	}
 
 	for_each_bio(bio) {
-		bio_for_each_bvec(bv, bio, iter)
-			bvec_split_segs(q, &bv, &nr_phys_segs, NULL, UINT_MAX);
+		if (bio_is_dma_direct(bio))
+			nr_phys_segs += bio_calc_segs(q, bio);
+		else
+			nr_phys_segs += bio_dma_calc_segs(q, bio);
 	}
 
 	return nr_phys_segs;
-- 
2.20.1
