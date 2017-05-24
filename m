From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH 02/16] staging: ccree: Cleanup: remove references to
 page_link
Date: Wed, 24 May 2017 15:42:13 -0600
Message-ID: <1495662147-18277-3-git-send-email-logang@deltatee.com>
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

This is a layering violation so we replace it with calls to
sg_page. This is a prep patch for replacing page_link and this
is one of the very few uses outside of scatterlist.h.

Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Signed-off-by: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 038e2ff..07bbf8f 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -43,8 +43,8 @@
 #ifdef CC_DEBUG
 #define DUMP_SGL(sg) \
 	while (sg) { \
-		SSI_LOG_DEBUG("page=%lu offset=%u length=%u (dma_len=%u) " \
-			     "dma_addr=%08x\n", (sg)->page_link, (sg)->offset, \
+		SSI_LOG_DEBUG("page=%p offset=%u length=%u (dma_len=%u) " \
+			     "dma_addr=%08x\n", sg_page(sg), (sg)->offset, \
 			(sg)->length, sg_dma_len(sg), (sg)->dma_address); \
 		(sg) = sg_next(sg); \
 	}
@@ -442,10 +442,10 @@ static int ssi_buffer_mgr_map_scatterlist(
 			return -ENOMEM;
 		} 
 		SSI_LOG_DEBUG("Mapped sg: dma_address=0x%llX "
-			     "page_link=0x%08lX addr=%pK offset=%u "
+			     "page=%p addr=%pK offset=%u "
 			     "length=%u\n",
 			     (unsigned long long)sg_dma_address(sg), 
-			     sg->page_link, 
+			     sg_page(sg),
 			     sg_virt(sg), 
 			     sg->offset, sg->length);
 		*lbytes = nbytes;
@@ -505,10 +505,10 @@ ssi_aead_handle_config_buf(struct device *dev,
 			return -ENOMEM;
 	}
 	SSI_LOG_DEBUG("Mapped curr_buff: dma_address=0x%llX "
-		     "page_link=0x%08lX addr=%pK "
+		     "page=%p addr=%pK "
 		     "offset=%u length=%u\n",
 		     (unsigned long long)sg_dma_address(&areq_ctx->ccm_adata_sg), 
-		     areq_ctx->ccm_adata_sg.page_link, 
+		     sg_page(&areq_ctx->ccm_adata_sg),
 		     sg_virt(&areq_ctx->ccm_adata_sg),
 		     areq_ctx->ccm_adata_sg.offset, 
 		     areq_ctx->ccm_adata_sg.length);
@@ -540,10 +540,10 @@ static inline int ssi_ahash_handle_curr_buf(struct device *dev,
 			return -ENOMEM;
 	}
 	SSI_LOG_DEBUG("Mapped curr_buff: dma_address=0x%llX "
-		     "page_link=0x%08lX addr=%pK "
+		     "page=%p addr=%pK "
 		     "offset=%u length=%u\n",
 		     (unsigned long long)sg_dma_address(areq_ctx->buff_sg), 
-		     areq_ctx->buff_sg->page_link, 
+		     sg_page(areq_ctx->buff_sg),
 		     sg_virt(areq_ctx->buff_sg),
 		     areq_ctx->buff_sg->offset, 
 		     areq_ctx->buff_sg->length);
@@ -1870,4 +1870,3 @@ int ssi_buffer_mgr_fini(struct ssi_drvdata *drvdata)
 	}
 	return 0;
 }
-
-- 
2.1.4
