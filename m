From: Logan Gunthorpe <logang@deltatee.com>
Subject: [RFC PATCH 13/28] block: Generalize bvec_should_split()
Date: Thu, 20 Jun 2019 10:12:25 -0600
Message-ID: <20190620161240.22738-14-logang@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190620161240.22738-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>, Logan Gunthorpe <logang@deltatee.com>
List-Id: linux-rdma@vger.kernel.org

bvec_should_split() will need to also operate on dma_vecs so
generalize it to take an offset and length instead of a bio_vec.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 block/blk-merge.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index d9e89c0ad40d..32653fca53ce 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -206,23 +206,25 @@ struct blk_segment_split_ctx {
 	unsigned sectors;
 
 	bool prv_valid;
-	struct bio_vec bvprv;
+	unsigned prv_offset;
+	unsigned prv_len;
 
 	const unsigned max_sectors;
 	const unsigned max_segs;
 };
 
-static bool bvec_should_split(struct request_queue *q, struct bio_vec *bv,
-			      struct blk_segment_split_ctx *ctx)
+static bool vec_should_split(struct request_queue *q, unsigned offset,
+			     unsigned len, struct blk_segment_split_ctx *ctx)
 {
 	/*
 	 * If the queue doesn't support SG gaps and adding this
 	 * offset would create a gap, disallow it.
 	 */
-	if (ctx->prv_valid && bvec_gap_to_prev(q, &ctx->bvprv, bv->bv_offset))
+	if (ctx->prv_valid &&
+	    vec_gap_to_prev(q, ctx->prv_offset, ctx->prv_len, offset))
 		return true;
 
-	if (ctx->sectors + (bv->bv_len >> 9) > ctx->max_sectors) {
+	if (ctx->sectors + (len >> 9) > ctx->max_sectors) {
 		/*
 		 * Consider this a new segment if we're splitting in
 		 * the middle of this vector.
@@ -230,9 +232,9 @@ static bool bvec_should_split(struct request_queue *q, struct bio_vec *bv,
 		if (ctx->nsegs < ctx->max_segs &&
 		    ctx->sectors < ctx->max_sectors) {
 			/* split in the middle of bvec */
-			bv->bv_len = (ctx->max_sectors - ctx->sectors) << 9;
-			bvec_split_segs(q, bv, &ctx->nsegs,
-					&ctx->sectors, ctx->max_segs);
+			len = (ctx->max_sectors - ctx->sectors) << 9;
+			vec_split_segs(q, offset, len, &ctx->nsegs,
+				       &ctx->sectors, ctx->max_segs);
 		}
 		return true;
 	}
@@ -240,14 +242,15 @@ static bool bvec_should_split(struct request_queue *q, struct bio_vec *bv,
 	if (ctx->nsegs == ctx->max_segs)
 		return true;
 
-	ctx->bvprv = *bv;
+	ctx->prv_offset = offset;
+	ctx->prv_len = len;
 	ctx->prv_valid = true;
 
-	if (bv->bv_offset + bv->bv_len <= PAGE_SIZE) {
+	if (offset + len <= PAGE_SIZE) {
 		ctx->nsegs++;
-		ctx->sectors += bv->bv_len >> 9;
-	} else if (bvec_split_segs(q, bv, &ctx->nsegs, &ctx->sectors,
-				   ctx->max_segs)) {
+		ctx->sectors += len >> 9;
+	} else if (vec_split_segs(q, offset, len, &ctx->nsegs, &ctx->sectors,
+				  ctx->max_segs)) {
 		return true;
 	}
 
@@ -270,7 +273,7 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
 	};
 
 	bio_for_each_bvec(bv, bio, iter) {
-		do_split = bvec_should_split(q, &bv, &ctx);
+		do_split = vec_should_split(q, bv.bv_offset, bv.bv_len, &ctx);
 		if (do_split)
 			break;
 	}
-- 
2.20.1
