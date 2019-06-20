From: Logan Gunthorpe <logang@deltatee.com>
Subject: [RFC PATCH 11/28] block: Create blk_segment_split_ctx
Date: Thu, 20 Jun 2019 10:12:23 -0600
Message-ID: <20190620161240.22738-12-logang@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190620161240.22738-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>, Logan Gunthorpe <logang@deltatee.com>
List-Id: linux-rdma@vger.kernel.org

In order to support dma-direct bios, blk_bio_segment_split() will
need to operate on both bio_vecs and dma_vecs. In order to do
this the code inside bio_for_each_bvec() needs to be moved into
a generic helper. Step one to do this is to put some of the
variables used inside the loop into a context structure so we
don't need to pass a dozen variables to this new function.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 block/blk-merge.c | 55 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 20 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 3581c7ac3c1b..414e61a714bf 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -201,63 +201,78 @@ static bool bvec_split_segs(struct request_queue *q, struct bio_vec *bv,
 			      sectors, max_segs);
 }
 
+struct blk_segment_split_ctx {
+	unsigned nsegs;
+	unsigned sectors;
+
+	bool prv_valid;
+	struct bio_vec bvprv;
+
+	const unsigned max_sectors;
+	const unsigned max_segs;
+};
+
 static struct bio *blk_bio_segment_split(struct request_queue *q,
 					 struct bio *bio,
 					 struct bio_set *bs,
 					 unsigned *segs)
 {
-	struct bio_vec bv, bvprv, *bvprvp = NULL;
+	struct bio_vec bv;
 	struct bvec_iter iter;
-	unsigned nsegs = 0, sectors = 0;
 	bool do_split = true;
 	struct bio *new = NULL;
-	const unsigned max_sectors = get_max_io_size(q, bio);
-	const unsigned max_segs = queue_max_segments(q);
+
+	struct blk_segment_split_ctx ctx = {
+		.max_sectors = get_max_io_size(q, bio),
+		.max_segs = queue_max_segments(q),
+	};
 
 	bio_for_each_bvec(bv, bio, iter) {
 		/*
 		 * If the queue doesn't support SG gaps and adding this
 		 * offset would create a gap, disallow it.
 		 */
-		if (bvprvp && bvec_gap_to_prev(q, bvprvp, bv.bv_offset))
+		if (ctx.prv_valid && bvec_gap_to_prev(q, &ctx.bvprv,
+						      bv.bv_offset))
 			goto split;
 
-		if (sectors + (bv.bv_len >> 9) > max_sectors) {
+		if (ctx.sectors + (bv.bv_len >> 9) > ctx.max_sectors) {
 			/*
 			 * Consider this a new segment if we're splitting in
 			 * the middle of this vector.
 			 */
-			if (nsegs < max_segs &&
-			    sectors < max_sectors) {
+			if (ctx.nsegs < ctx.max_segs &&
+			    ctx.sectors < ctx.max_sectors) {
 				/* split in the middle of bvec */
-				bv.bv_len = (max_sectors - sectors) << 9;
-				bvec_split_segs(q, &bv, &nsegs,
-						&sectors, max_segs);
+				bv.bv_len =
+					(ctx.max_sectors - ctx.sectors) << 9;
+				bvec_split_segs(q, &bv, &ctx.nsegs,
+						&ctx.sectors, ctx.max_segs);
 			}
 			goto split;
 		}
 
-		if (nsegs == max_segs)
+		if (ctx.nsegs == ctx.max_segs)
 			goto split;
 
-		bvprv = bv;
-		bvprvp = &bvprv;
+		ctx.bvprv = bv;
+		ctx.prv_valid = true;
 
 		if (bv.bv_offset + bv.bv_len <= PAGE_SIZE) {
-			nsegs++;
-			sectors += bv.bv_len >> 9;
-		} else if (bvec_split_segs(q, &bv, &nsegs, &sectors,
-				max_segs)) {
+			ctx.nsegs++;
+			ctx.sectors += bv.bv_len >> 9;
+		} else if (bvec_split_segs(q, &bv, &ctx.nsegs, &ctx.sectors,
+				ctx.max_segs)) {
 			goto split;
 		}
 	}
 
 	do_split = false;
 split:
-	*segs = nsegs;
+	*segs = ctx.nsegs;
 
 	if (do_split) {
-		new = bio_split(bio, sectors, GFP_NOIO, bs);
+		new = bio_split(bio, ctx.sectors, GFP_NOIO, bs);
 		if (new)
 			bio = new;
 	}
-- 
2.20.1
