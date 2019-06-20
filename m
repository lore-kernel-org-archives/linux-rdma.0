From: Logan Gunthorpe <logang@deltatee.com>
Subject: [RFC PATCH 10/28] block: Create generic vec_split_segs() from bvec_split_segs()
Date: Thu, 20 Jun 2019 10:12:22 -0600
Message-ID: <20190620161240.22738-11-logang@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190620161240.22738-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>, Logan Gunthorpe <logang@deltatee.com>
List-Id: linux-rdma@vger.kernel.org

bvec_split_segs() only requires the address and length of the
vector. In order to generalize it to work with dma_vecs, we just
take the address and length directly instead of the bio_vec.

The function is renamed to vec_split_segs() and a helper is added
to avoid having to adjust the existing callsites.

Note: the new bvec_split_segs() helper will be removed in a subsequent
patch.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 block/blk-merge.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 17713d7d98d5..3581c7ac3c1b 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -158,13 +158,13 @@ static unsigned get_max_segment_size(struct request_queue *q,
 }
 
 /*
- * Split the bvec @bv into segments, and update all kinds of
- * variables.
+ * Split the an address/offset and length into segments, and
+ * update all kinds of variables.
  */
-static bool bvec_split_segs(struct request_queue *q, struct bio_vec *bv,
-		unsigned *nsegs, unsigned *sectors, unsigned max_segs)
+static bool vec_split_segs(struct request_queue *q, unsigned offset,
+			   unsigned len, unsigned *nsegs, unsigned *sectors,
+			   unsigned max_segs)
 {
-	unsigned len = bv->bv_len;
 	unsigned total_len = 0;
 	unsigned new_nsegs = 0, seg_size = 0;
 
@@ -173,14 +173,14 @@ static bool bvec_split_segs(struct request_queue *q, struct bio_vec *bv,
 	 * current bvec has to be splitted as multiple segments.
 	 */
 	while (len && new_nsegs + *nsegs < max_segs) {
-		seg_size = get_max_segment_size(q, bv->bv_offset + total_len);
+		seg_size = get_max_segment_size(q, offset + total_len);
 		seg_size = min(seg_size, len);
 
 		new_nsegs++;
 		total_len += seg_size;
 		len -= seg_size;
 
-		if ((bv->bv_offset + total_len) & queue_virt_boundary(q))
+		if ((offset + total_len) & queue_virt_boundary(q))
 			break;
 	}
 
@@ -194,6 +194,13 @@ static bool bvec_split_segs(struct request_queue *q, struct bio_vec *bv,
 	return !!len;
 }
 
+static bool bvec_split_segs(struct request_queue *q, struct bio_vec *bv,
+		unsigned *nsegs, unsigned *sectors, unsigned max_segs)
+{
+	return vec_split_segs(q, bv->bv_offset, bv->bv_len, nsegs,
+			      sectors, max_segs);
+}
+
 static struct bio *blk_bio_segment_split(struct request_queue *q,
 					 struct bio *bio,
 					 struct bio_set *bs,
-- 
2.20.1
