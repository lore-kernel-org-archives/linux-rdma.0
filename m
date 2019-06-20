From: Logan Gunthorpe <logang@deltatee.com>
Subject: [RFC PATCH 06/28] block: Support dma-direct bios in bio_advance_iter()
Date: Thu, 20 Jun 2019 10:12:18 -0600
Message-ID: <20190620161240.22738-7-logang@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190620161240.22738-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>, Logan Gunthorpe <logang@deltatee.com>
List-Id: linux-rdma@vger.kernel.org

Dma-direct bio iterators need to be advanced using a similar
dvec_iter_advance helper.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 include/linux/bio.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8180309123d7..e212e5958a75 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -134,6 +134,8 @@ static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
 
 	if (bio_no_advance_iter(bio))
 		iter->bi_size -= bytes;
+	else if (op_is_dma_direct(bio->bi_opf))
+		dvec_iter_advance(bio->bi_dma_vec, iter, bytes);
 	else
 		bvec_iter_advance(bio->bi_io_vec, iter, bytes);
 		/* TODO: It is reasonable to complete bio with error here. */
-- 
2.20.1
