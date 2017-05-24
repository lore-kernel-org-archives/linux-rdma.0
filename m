From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH 15/16] dma-mapping: introduce and use unmappable safe
 sg_virt call
Date: Wed, 24 May 2017 15:42:26 -0600
Message-ID: <1495662147-18277-16-git-send-email-logang@deltatee.com>
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

Introduce sg_try_virt which is safe to call with a potentially
unmappable sgl. sg_try_virt returns NULL in cases that the sgl doesn't
have an accessible virtual address to return.

Then, in dma_map_sg_attrs, we use the new function instead of sg_virt
when marking memory as initialized.

Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Signed-off-by: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
---
 include/linux/dma-mapping.h |  9 +++++++--
 include/linux/scatterlist.h | 16 ++++++++++++++++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 4f3eece..5ef1ab5 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -241,8 +241,13 @@ static inline int dma_map_sg_attrs(struct device *dev, struct scatterlist *sg,
 	int i, ents;
 	struct scatterlist *s;
 
-	for_each_sg(sg, s, nents, i)
-		kmemcheck_mark_initialized(sg_virt(s), s->length);
+	for_each_sg(sg, s, nents, i) {
+		void *addr = sg_try_virt(sg);
+
+		if (addr)
+			kmemcheck_mark_initialized(addr, s->length);
+	}
+
 	BUG_ON(!valid_dma_direction(dir));
 	ents = ops->map_sg(dev, sg, nents, dir, attrs);
 	BUG_ON(ents < 0);
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 2c54c6c..1e11af9 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -298,6 +298,22 @@ static inline void *sg_virt(struct scatterlist *sg)
 	return page_address(sg_page(sg)) + sg->offset;
 }
 
+/**
+ * sg_try_virt - Return virtual address of an sg entry or NULL if it is
+ *	unmappable
+ * @sg:      SG entry
+ *
+ * Description:
+ *   This is the same as sg_virt but is safe to call with unmappable
+ *   memory. This function will return NULL in case the sg is is
+ *   unmappable.
+ *
+ **/
+static inline void *sg_try_virt(struct scatterlist *sg)
+{
+	return pfn_t_to_virt(sg->__pfn);
+}
+
 int sg_nents(struct scatterlist *sg);
 int sg_nents_for_len(struct scatterlist *sg, u64 len);
 struct scatterlist *sg_next(struct scatterlist *);
-- 
2.1.4
