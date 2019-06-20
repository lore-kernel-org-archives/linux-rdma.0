From: Logan Gunthorpe <logang@deltatee.com>
Subject: [RFC PATCH 07/28] block: Use dma_vec length in bio_cur_bytes() for dma-direct bios
Date: Thu, 20 Jun 2019 10:12:19 -0600
Message-ID: <20190620161240.22738-8-logang@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190620161240.22738-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>, Logan Gunthorpe <logang@deltatee.com>
List-Id: linux-rdma@vger.kernel.org

For dma-direct bios, use the dv_len of the current vector
seeing the bio_vec's are not valid in such a context.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 include/linux/bio.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index e212e5958a75..df7973932525 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -91,10 +91,12 @@ static inline bool bio_mergeable(struct bio *bio)
 
 static inline unsigned int bio_cur_bytes(struct bio *bio)
 {
-	if (bio_has_data(bio))
-		return bio_iovec(bio).bv_len;
-	else /* dataless requests such as discard */
+	if (!bio_has_data(bio)) /* dataless requests such as discard */
 		return bio->bi_iter.bi_size;
+	else if (op_is_dma_direct(bio->bi_opf))
+		return bio_dma_vec(bio).dv_len;
+	else
+		return bio_iovec(bio).bv_len;
 }
 
 static inline void *bio_data(struct bio *bio)
-- 
2.20.1
