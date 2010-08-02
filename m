From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] IB/qib: limit the number of packets processed per
	interrupt
Date: Mon, 02 Aug 2010 15:39:24 -0700
Message-ID: <20100802223924.8701.14389.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Don't processes too many packets without allowing other IRQ
functions a chance to run. Otherwise, there is a chance of
getting "soft lockup" messages and poor application response times.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 0 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index f15ce07..9cd1936 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -335,7 +335,7 @@ u32 qib_kreceive(struct qib_ctxtdata *rcd, u32 *llic, u32 *npkts)
 		smp_rmb();  /* prevent speculative reads of dma'ed hdrq */
 	}
 
-	for (last = 0, i = 1; !last; i += !last) {
+	for (last = 0, i = 1; !last && i <= 64; i += !last) {
 		hdr = dd->f_get_msgheader(dd, rhf_addr);
 		eflags = qib_hdrget_err_flags(rhf_addr);
 		etype = qib_hdrget_rcv_type(rhf_addr);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
