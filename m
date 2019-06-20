From: Logan Gunthorpe <logang@deltatee.com>
Subject: [RFC PATCH 01/28] block: Introduce DMA direct request type
Date: Thu, 20 Jun 2019 10:12:13 -0600
Message-ID: <20190620161240.22738-2-logang@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190620161240.22738-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>, Logan Gunthorpe <logang@deltatee.com>
List-Id: linux-rdma@vger.kernel.org

A DMA direct request allows passing DMA addresses directly through
the block layer, instead of struct pages. This allows the calling
layer to take care of the mapping and unmapping and also creates
a path to doing peer-to-peer transactions without using struct pages.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 include/linux/blk_types.h |  9 ++++++++-
 include/linux/blkdev.h    | 10 ++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 95202f80676c..f3cabfdb6774 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -322,6 +322,7 @@ enum req_flag_bits {
 	__REQ_NOUNMAP,		/* do not free blocks when zeroing */
 
 	__REQ_HIPRI,
+	__REQ_DMA_DIRECT,	/* DMA address direct request */
 
 	/* for driver use */
 	__REQ_DRV,
@@ -345,6 +346,7 @@ enum req_flag_bits {
 #define REQ_NOWAIT		(1ULL << __REQ_NOWAIT)
 #define REQ_NOUNMAP		(1ULL << __REQ_NOUNMAP)
 #define REQ_HIPRI		(1ULL << __REQ_HIPRI)
+#define REQ_DMA_DIRECT		(1ULL << __REQ_DMA_DIRECT)
 
 #define REQ_DRV			(1ULL << __REQ_DRV)
 #define REQ_SWAP		(1ULL << __REQ_SWAP)
@@ -353,7 +355,7 @@ enum req_flag_bits {
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 
 #define REQ_NOMERGE_FLAGS \
-	(REQ_NOMERGE | REQ_PREFLUSH | REQ_FUA)
+	(REQ_NOMERGE | REQ_PREFLUSH | REQ_FUA | REQ_DMA_DIRECT)
 
 enum stat_group {
 	STAT_READ,
@@ -412,6 +414,11 @@ static inline int op_stat_group(unsigned int op)
 	return op_is_write(op);
 }
 
+static inline int op_is_dma_direct(unsigned int op)
+{
+	return op & REQ_DMA_DIRECT;
+}
+
 typedef unsigned int blk_qc_t;
 #define BLK_QC_T_NONE		-1U
 #define BLK_QC_T_SHIFT		16
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 592669bcc536..ce70d5dded5f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -271,6 +271,16 @@ static inline bool bio_is_passthrough(struct bio *bio)
 	return blk_op_is_scsi(op) || blk_op_is_private(op);
 }
 
+static inline bool bio_is_dma_direct(struct bio *bio)
+{
+	return op_is_dma_direct(bio->bi_opf);
+}
+
+static inline bool blk_rq_is_dma_direct(struct request *rq)
+{
+	return op_is_dma_direct(rq->cmd_flags);
+}
+
 static inline unsigned short req_get_ioprio(struct request *req)
 {
 	return req->ioprio;
-- 
2.20.1
