From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 15/15] IB/hfi1: Change hfi1_init loop to preserve error
 returns
Date: Thu, 12 May 2016 10:24:00 -0700
Message-ID: <20160512172358.9741.70478.stgit@scvm10.sc.intel.com>
References: <20160512172050.9741.84190.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160512172050.9741.84190.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If one iteration of the loop causes an error return and a later iteration
doesn't, the later iteration causes the earlier error condition to be
lost. This could result in driver probe succeeding when it should have
failed. Therefore save off the error return in the loop itself rather than
outside the loop.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/init.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 502b7cf..9e71abf 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -732,12 +732,12 @@ int hfi1_init(struct hfi1_devdata *dd, int reinit)
 		lastfail = hfi1_create_rcvhdrq(dd, rcd);
 		if (!lastfail)
 			lastfail = hfi1_setup_eagerbufs(rcd);
-		if (lastfail)
+		if (lastfail) {
 			dd_dev_err(dd,
 				   "failed to allocate kernel ctxt's rcvhdrq and/or egr bufs\n");
+			ret = lastfail;
+		}
 	}
-	if (lastfail)
-		ret = lastfail;
 
 	/* Allocate enough memory for user event notification. */
 	len = PAGE_ALIGN(dd->chip_rcv_contexts * HFI1_MAX_SHARED_CTXTS *

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
