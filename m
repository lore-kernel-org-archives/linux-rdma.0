From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/12] IB/rdmavt: Fix adaptive pio hang
Date: Tue, 12 Apr 2016 10:45:51 -0700
Message-ID: <20160412174549.19295.98346.stgit@scvm10.sc.intel.com>
References: <20160412173504.19295.7241.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412173504.19295.7241.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The RVT_S_WAIT_PIO_DRAIN flag was missing from
the set of flags indicating a qp is waiting
on a resource.

This caused the sleep/wakeup for adaptive pio
drain to lose a wakeup "hanging" a QP.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/rdmavt_qp.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 497e590..0e1ff2a 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -117,8 +117,9 @@
 /*
  * Wait flags that would prevent any packet type from being sent.
  */
-#define RVT_S_ANY_WAIT_IO (RVT_S_WAIT_PIO | RVT_S_WAIT_TX | \
-	RVT_S_WAIT_DMA_DESC | RVT_S_WAIT_KMEM)
+#define RVT_S_ANY_WAIT_IO \
+	(RVT_S_WAIT_PIO | RVT_S_WAIT_PIO_DRAIN | RVT_S_WAIT_TX | \
+	 RVT_S_WAIT_DMA_DESC | RVT_S_WAIT_KMEM)
 
 /*
  * Wait flags that would prevent send work requests from making progress.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
