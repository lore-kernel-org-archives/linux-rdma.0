From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/16] IB/hfi1: stop passing bogus gfp flags arguments to dma_alloc_coherent
Date: Fri, 14 Jun 2019 15:47:17 +0200
Message-ID: <20190614134726.3827-8-hch@lst.de>
References: <20190614134726.3827-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190614134726.3827-1-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <maxime.ripard@bootlin.com>, Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Ian Abbott <abbotti@mev.co.uk>, H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Intel Linux Wireless <linuxwifi@intel.com>, "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, linux-s390@vger.kernel.org, devel@driverdev.osuosl.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

dma_alloc_coherent is not just the page allocator.  The only valid
arguments to pass are either GFP_ATOMIC or GFP_ATOMIC with possible
modifiers of __GFP_NORETRY or __GFP_NOWARN.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/hw/hfi1/init.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 71cb9525c074..ff9d106ee784 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1846,17 +1846,10 @@ int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 	u64 reg;
 
 	if (!rcd->rcvhdrq) {
-		gfp_t gfp_flags;
-
 		amt = rcvhdrq_size(rcd);
 
-		if (rcd->ctxt < dd->first_dyn_alloc_ctxt || rcd->is_vnic)
-			gfp_flags = GFP_KERNEL;
-		else
-			gfp_flags = GFP_USER;
 		rcd->rcvhdrq = dma_alloc_coherent(&dd->pcidev->dev, amt,
-						  &rcd->rcvhdrq_dma,
-						  gfp_flags | __GFP_COMP);
+						  &rcd->rcvhdrq_dma, GFP_KERNEL);
 
 		if (!rcd->rcvhdrq) {
 			dd_dev_err(dd,
@@ -1870,7 +1863,7 @@ int hfi1_create_rcvhdrq(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 			rcd->rcvhdrtail_kvaddr = dma_alloc_coherent(&dd->pcidev->dev,
 								    PAGE_SIZE,
 								    &rcd->rcvhdrqtailaddr_dma,
-								    gfp_flags);
+								    GFP_KERNEL);
 			if (!rcd->rcvhdrtail_kvaddr)
 				goto bail_free;
 		}
@@ -1926,19 +1919,10 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd)
 {
 	struct hfi1_devdata *dd = rcd->dd;
 	u32 max_entries, egrtop, alloced_bytes = 0;
-	gfp_t gfp_flags;
 	u16 order, idx = 0;
 	int ret = 0;
 	u16 round_mtu = roundup_pow_of_two(hfi1_max_mtu);
 
-	/*
-	 * GFP_USER, but without GFP_FS, so buffer cache can be
-	 * coalesced (we hope); otherwise, even at order 4,
-	 * heavy filesystem activity makes these fail, and we can
-	 * use compound pages.
-	 */
-	gfp_flags = __GFP_RECLAIM | __GFP_IO | __GFP_COMP;
-
 	/*
 	 * The minimum size of the eager buffers is a groups of MTU-sized
 	 * buffers.
@@ -1969,7 +1953,7 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd)
 			dma_alloc_coherent(&dd->pcidev->dev,
 					   rcd->egrbufs.rcvtid_size,
 					   &rcd->egrbufs.buffers[idx].dma,
-					   gfp_flags);
+					   GFP_KERNEL);
 		if (rcd->egrbufs.buffers[idx].addr) {
 			rcd->egrbufs.buffers[idx].len =
 				rcd->egrbufs.rcvtid_size;
-- 
2.20.1
