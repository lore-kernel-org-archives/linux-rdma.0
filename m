From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 08/24] IB/qib: Handle transitions from ACTIVE_DEFERRED to
	ACTIVE better
Date: Tue, 28 Dec 2010 10:27:32 -0500
Message-ID: <20101228152731.19960.35270.stgit@kop-dev-sles11-04.qlogic.org>
References: <20101228152648.19960.84006.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101228152648.19960.84006.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When the link transitions from ACTIVE_DEFERRED to ACTIVE, the driver
only sees the ACTIVE state. With this change, it will check whether
the state was already ACTIVE and if so, it will not generated IB
events and will not clear symbol error counts.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_intr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_intr.c b/drivers/infiniband/hw/qib/qib_intr.c
index 54a4082..a693c56 100644
--- a/drivers/infiniband/hw/qib/qib_intr.c
+++ b/drivers/infiniband/hw/qib/qib_intr.c
@@ -131,7 +131,8 @@ void qib_handle_e_ibstatuschanged(struct qib_pportdata *ppd, u64 ibcs)
 			/* start a 75msec timer to clear symbol errors */
 			mod_timer(&ppd->symerr_clear_timer,
 				  msecs_to_jiffies(75));
-		} else if (ltstate == IB_PHYSPORTSTATE_LINKUP) {
+		} else if (ltstate == IB_PHYSPORTSTATE_LINKUP &&
+			   !(ppd->lflags & QIBL_LINKACTIVE)) {
 			/* active, but not active defered */
 			qib_hol_up(ppd); /* useful only for 6120 now */
 			*ppd->statusp |=

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
