From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH 01/16] dmaengine: ste_dma40,
 imx-dma: Cleanup scatterlist layering violations
Date: Wed, 24 May 2017 15:42:12 -0600
Message-ID: <1495662147-18277-2-git-send-email-logang@deltatee.com>
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

Two dma engine drivers directly accesses page_link assuming knowledge
that should be contained only in scatterlist.h.

We replace these with calls to sg_chain and sg_assign_page.

Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Signed-off-by: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
---
 drivers/dma/imx-dma.c   | 7 ++-----
 drivers/dma/ste_dma40.c | 5 +----
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index ab0fb80..f681df8 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -888,7 +888,7 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
 	sg_init_table(imxdmac->sg_list, periods);
 
 	for (i = 0; i < periods; i++) {
-		imxdmac->sg_list[i].page_link = 0;
+		sg_assign_page(&imxdmac->sg_list[i], NULL);
 		imxdmac->sg_list[i].offset = 0;
 		imxdmac->sg_list[i].dma_address = dma_addr;
 		sg_dma_len(&imxdmac->sg_list[i]) = period_len;
@@ -896,10 +896,7 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
 	}
 
 	/* close the loop */
-	imxdmac->sg_list[periods].offset = 0;
-	sg_dma_len(&imxdmac->sg_list[periods]) = 0;
-	imxdmac->sg_list[periods].page_link =
-		((unsigned long)imxdmac->sg_list | 0x01) & ~0x02;
+	sg_chain(imxdmac->sg_list, periods + 1, imxdmac->sg_list);
 
 	desc->type = IMXDMA_DESC_CYCLIC;
 	desc->sg = imxdmac->sg_list;
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index a6620b6..c3052fb 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2528,10 +2528,7 @@ dma40_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t dma_addr,
 		dma_addr += period_len;
 	}
 
-	sg[periods].offset = 0;
-	sg_dma_len(&sg[periods]) = 0;
-	sg[periods].page_link =
-		((unsigned long)sg | 0x01) & ~0x02;
+	sg_chain(sg, periods + 1, sg);
 
 	txd = d40_prep_sg(chan, sg, sg, periods, direction,
 			  DMA_PREP_INTERRUPT);
-- 
2.1.4
