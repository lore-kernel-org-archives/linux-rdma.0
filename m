From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/6] IB/rdmavt: rdmavt can handle non aligned page maps
Date: Mon, 10 Oct 2016 06:14:45 -0700
Message-ID: <20161010131444.17586.43811.stgit@scvm10.sc.intel.com>
References: <20161010131249.17586.23789.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161010131249.17586.23789.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The initial code for rdmavt carried with it a restriction that was a
vestige from the qib driver, that to dma map a page it had to be less
than a page size. This is not the case on modern hardware, both qib and
hfi1 will be just fine with unaligned map requests.

This fixes a 4.8 regression where by an IPoIB transfer of > PAGE_SIZE
will hang because the dma map page call always fails. This was
introduced after commit 5faba5469522 ("IB/ipoib: Report SG feature
regardless of HW UD CSUM capability") added the capability to use SG by
default. Rather than override this, the HW supports it, so allow SG.

Cc: Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 4.8
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/dma.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/dma.c b/drivers/infiniband/sw/rdmavt/dma.c
index 01f71ca..f2cefb0 100644
--- a/drivers/infiniband/sw/rdmavt/dma.c
+++ b/drivers/infiniband/sw/rdmavt/dma.c
@@ -90,9 +90,6 @@ static u64 rvt_dma_map_page(struct ib_device *dev, struct page *page,
 	if (WARN_ON(!valid_dma_direction(direction)))
 		return BAD_DMA_ADDRESS;
 
-	if (offset + size > PAGE_SIZE)
-		return BAD_DMA_ADDRESS;
-
 	addr = (u64)page_address(page);
 	if (addr)
 		addr += offset;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
