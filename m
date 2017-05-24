From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH 08/16] scatterlist: add iomem support to sg_miter and
 sg_copy_*
Date: Wed, 24 May 2017 15:42:19 -0600
Message-ID: <1495662147-18277-9-git-send-email-logang@deltatee.com>
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

IO memory support can be indicated by an iteratee with the
SG_MITRE_SUPPORTS_IOMEM flag. If an unmappable sgl gets into a miter
without this support, the kernel will BUGON.

For supported cases, the sg_miter code will set the ioaddr pointer and
leave addr NULL.

sg_copy_buffer is changed to support IO memory by simply calling
the appropriate memcpy when required.

Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Signed-off-by: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
---
 include/linux/scatterlist.h |  3 +++
 lib/scatterlist.c           | 35 +++++++++++++++++++++++++++++------
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 8cb662c..2c54c6c 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -447,11 +447,14 @@ static inline dma_addr_t sg_page_iter_dma_address(struct sg_page_iter *piter)
 #define SG_MITER_ATOMIC		(1 << 0)	 /* use kmap_atomic */
 #define SG_MITER_TO_SG		(1 << 1)	/* flush back to phys on unmap */
 #define SG_MITER_FROM_SG	(1 << 2)	/* nop */
+#define SG_MITRE_SUPPORTS_IOMEM (1 << 3)	/* io memory is supported by
+						 * the iteratee */
 
 struct sg_mapping_iter {
 	/* the following three fields can be accessed directly */
 	struct page		*page;		/* currently mapped page */
 	void			*addr;		/* pointer to the mapped area */
+	void __iomem            *ioaddr;	/* address to io memory */
 	size_t			length;		/* length of the mapped area */
 	size_t			consumed;	/* number of consumed bytes */
 	struct sg_page_iter	piter;		/* page iterator */
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 6bc33e0..1ec768e 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -601,6 +601,8 @@ EXPORT_SYMBOL(sg_miter_skip);
  */
 bool sg_miter_next(struct sg_mapping_iter *miter)
 {
+	pfn_t pfn = miter->piter.sg->__pfn;
+
 	sg_miter_stop(miter);
 
 	/*
@@ -610,9 +612,20 @@ bool sg_miter_next(struct sg_mapping_iter *miter)
 	if (!sg_miter_get_next_page(miter))
 		return false;
 
-	miter->page = sg_page_iter_page(&miter->piter);
 	miter->consumed = miter->length = miter->__remaining;
 
+	if (!(miter->__flags & SG_MITRE_SUPPORTS_IOMEM)) {
+		BUG_ON(!pfn_t_is_always_mappable(pfn));
+	} else if (pfn_t_is_iomem(pfn)) {
+		miter->ioaddr = ioremap(pfn_t_to_phys(pfn), PAGE_SIZE);
+		miter->addr = NULL;
+		return true;
+	}
+
+	miter->ioaddr = NULL;
+	miter->page = pfn_t_to_page(pfn);
+	BUG_ON(!miter->page);
+
 	if (miter->__flags & SG_MITER_ATOMIC)
 		miter->addr = kmap_atomic(miter->page) + miter->__offset;
 	else
@@ -660,6 +673,9 @@ void sg_miter_stop(struct sg_mapping_iter *miter)
 		miter->length = 0;
 		miter->consumed = 0;
 	}
+
+	if (miter->ioaddr)
+		iounmap(miter->ioaddr);
 }
 EXPORT_SYMBOL(sg_miter_stop);
 
@@ -681,7 +697,7 @@ size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
 {
 	unsigned int offset = 0;
 	struct sg_mapping_iter miter;
-	unsigned int sg_flags = SG_MITER_ATOMIC;
+	unsigned int sg_flags = SG_MITER_ATOMIC | SG_MITRE_SUPPORTS_IOMEM;
 
 	if (to_buffer)
 		sg_flags |= SG_MITER_FROM_SG;
@@ -698,10 +714,17 @@ size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
 
 		len = min(miter.length, buflen - offset);
 
-		if (to_buffer)
-			memcpy(buf + offset, miter.addr, len);
-		else
-			memcpy(miter.addr, buf + offset, len);
+		if (miter.addr) {
+			if (to_buffer)
+				memcpy(buf + offset, miter.addr, len);
+			else
+				memcpy(miter.addr, buf + offset, len);
+		} else if (miter.ioaddr) {
+			if (to_buffer)
+				memcpy_fromio(buf + offset, miter.addr, len);
+			else
+				memcpy_toio(miter.addr, buf + offset, len);
+		}
 
 		offset += len;
 	}
-- 
2.1.4
