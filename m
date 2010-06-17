From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/7] IB/qib: clear 6120 hardware error register
Date: Thu, 17 Jun 2010 16:14:04 -0700
Message-ID: <20100617231404.8006.48845.stgit@chromite.mv.qlogic.com>
References: <20100617231338.8006.18131.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100617231338.8006.18131.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The hardware error register needs to be cleared or another interrupt
will be generated, thus causing an infinite loop.
This is a regression introduced when removing debug output.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_iba6120.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
index 1eadadc..a5e29db 100644
--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -1355,8 +1355,7 @@ static int qib_6120_bringup_serdes(struct qib_pportdata *ppd)
 	hwstat = qib_read_kreg64(dd, kr_hwerrstatus);
 	if (hwstat) {
 		/* should just have PLL, clear all set, in an case */
-		if (hwstat & ~QLOGIC_IB_HWE_SERDESPLLFAILED)
-			qib_write_kreg(dd, kr_hwerrclear, hwstat);
+		qib_write_kreg(dd, kr_hwerrclear, hwstat);
 		qib_write_kreg(dd, kr_errclear, ERR_MASK(HardwareErr));
 	}
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
