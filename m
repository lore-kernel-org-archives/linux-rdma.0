From: Logan Gunthorpe <logang@deltatee.com>
Subject: [RFC PATCH 08/28] block: Introduce dmavec_phys_mergeable()
Date: Thu, 20 Jun 2019 10:12:20 -0600
Message-ID: <20190620161240.22738-9-logang@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190620161240.22738-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>, Logan Gunthorpe <logang@deltatee.com>
List-Id: linux-rdma@vger.kernel.org

Introduce a new helper which is an analog of biovec_phys_mergeable()
for dma-direct vectors.

This also provides a common helper vec_phys_mergeable() for use in
code that's general to both bio_vecs and dma_vecs.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 block/blk.h | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 7814aa207153..4142383eed7a 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -66,20 +66,36 @@ static inline void blk_queue_enter_live(struct request_queue *q)
 	percpu_ref_get(&q->q_usage_counter);
 }
 
+static inline bool vec_phys_mergeable(struct request_queue *q,
+				      unsigned long addr1, unsigned int len1,
+				      unsigned long addr2, unsigned int len2)
+{
+	unsigned long mask = queue_segment_boundary(q);
+
+	if (addr1 + len1 != addr2)
+		return false;
+	if ((addr1 | mask) != ((addr2 + len2 - 1) | mask))
+		return false;
+	return true;
+}
+
 static inline bool biovec_phys_mergeable(struct request_queue *q,
 		struct bio_vec *vec1, struct bio_vec *vec2)
 {
-	unsigned long mask = queue_segment_boundary(q);
 	phys_addr_t addr1 = page_to_phys(vec1->bv_page) + vec1->bv_offset;
 	phys_addr_t addr2 = page_to_phys(vec2->bv_page) + vec2->bv_offset;
 
-	if (addr1 + vec1->bv_len != addr2)
-		return false;
 	if (xen_domain() && !xen_biovec_phys_mergeable(vec1, vec2->bv_page))
 		return false;
-	if ((addr1 | mask) != ((addr2 + vec2->bv_len - 1) | mask))
-		return false;
-	return true;
+
+	return vec_phys_mergeable(q, addr1, vec1->bv_len, addr2, vec2->bv_len);
+}
+
+static inline bool dmavec_phys_mergeable(struct request_queue *q,
+		struct dma_vec *vec1, struct dma_vec *vec2)
+{
+	return vec_phys_mergeable(q, vec1->dv_addr, vec1->dv_len,
+				  vec2->dv_addr, vec2->dv_len);
 }
 
 static inline bool __bvec_gap_to_prev(struct request_queue *q,
-- 
2.20.1
