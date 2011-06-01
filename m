From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] RDMA/cxgb4: Don't exceed hw IQ depth limit for user CQs.
Date: Wed, 01 Jun 2011 12:49:14 -0500
Message-ID: <20110601174913.18744.61491.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Memory allocated for user CQs gets rounded up to the next page boundary.
And after rounding, we recalculate the resulting IQ depth and we need
to make sure we don't exceed the HW limits.

This bug can result a much smaller CQ allocated than was expected if
the HW size field is exceeded, resulting in CQ overflow failures.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cq.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 8d8f8ad..1720dc7 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -801,6 +801,10 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev, int entries,
 	if (ucontext) {
 		memsize = roundup(memsize, PAGE_SIZE);
 		hwentries = memsize / sizeof *chp->cq.queue;
+		while (hwentries > T4_MAX_IQ_SIZE) {
+			memsize -= PAGE_SIZE;
+			hwentries = memsize / sizeof *chp->cq.queue;
+		}
 	}
 	chp->cq.size = hwentries;
 	chp->cq.memsize = memsize;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
