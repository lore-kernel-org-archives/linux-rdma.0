From: Logan Gunthorpe <logang@deltatee.com>
Subject: [RFC PATCH 14/28] block: Support splitting dma-direct bios
Date: Thu, 20 Jun 2019 10:12:26 -0600
Message-ID: <20190620161240.22738-15-logang@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190620161240.22738-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>, Logan Gunthorpe <logang@deltatee.com>
List-Id: linux-rdma@vger.kernel.org

If the bio is a dma-direct bio, loop through the dma_vecs instead
of the bio_vecs when calling vec_should_split().

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 block/blk-merge.c | 45 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 8 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 32653fca53ce..c4c016f994f6 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -257,14 +257,44 @@ static bool vec_should_split(struct request_queue *q, unsigned offset,
 	return false;
 }
 
+static bool bio_should_split(struct request_queue *q, struct bio *bio,
+			     struct blk_segment_split_ctx *ctx)
+{
+	struct bvec_iter iter;
+	struct bio_vec bv;
+	bool ret;
+
+	bio_for_each_bvec(bv, bio, iter) {
+		ret = vec_should_split(q, bv.bv_offset, bv.bv_len, ctx);
+		if (ret)
+			return true;
+	}
+
+	return false;
+}
+
+static bool bio_dma_should_split(struct request_queue *q, struct bio *bio,
+				 struct blk_segment_split_ctx *ctx)
+{
+	struct bvec_iter iter;
+	struct dma_vec dv;
+	bool ret;
+
+	bio_for_each_dvec(dv, bio, iter) {
+		ret = vec_should_split(q, dv.dv_addr, dv.dv_len, ctx);
+		if (ret)
+			return true;
+	}
+
+	return false;
+}
+
 static struct bio *blk_bio_segment_split(struct request_queue *q,
 					 struct bio *bio,
 					 struct bio_set *bs,
 					 unsigned *segs)
 {
-	struct bio_vec bv;
-	struct bvec_iter iter;
-	bool do_split = false;
+	bool do_split;
 	struct bio *new = NULL;
 
 	struct blk_segment_split_ctx ctx = {
@@ -272,11 +302,10 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
 		.max_segs = queue_max_segments(q),
 	};
 
-	bio_for_each_bvec(bv, bio, iter) {
-		do_split = vec_should_split(q, bv.bv_offset, bv.bv_len, &ctx);
-		if (do_split)
-			break;
-	}
+	if (bio_is_dma_direct(bio))
+		do_split = bio_dma_should_split(q, bio, &ctx);
+	else
+		do_split = bio_should_split(q, bio, &ctx);
 
 	*segs = ctx.nsegs;
 
-- 
2.20.1
