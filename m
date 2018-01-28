From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] IB/cxgb3: remove cxio_dbg.c
Date: Sun, 28 Jan 2018 08:24:22 -0800
Message-ID: <1517156662.765.10.camel@perches.com>
References: <1517152289-25052-1-git-send-email-clabbe@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1517152289-25052-1-git-send-email-clabbe@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Corentin Labbe <clabbe@baylibre.com>, dledford@redhat.com, hal.rosenstock@gmail.com, sean.hefty@intel.com, swise@chelsio.com
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 2018-01-28 at 15:11 +0000, Corentin Labbe wrote:
> cxio_dbg.c is uncompiled since commit 2b540355cd2f ("RDMA/cxgb3: cleanups")
> 10 years after, we could remove it.

OK, now you could remove the prototypes and probably
CONFIG_INFINIBAND_CXGB3_DEBUG too.

There is a DEBUG test and many uses of pr_debug
that would have modified behavior.

The pr_debug uses would only be emitted via a
dynamic_debug enable and the #ifdef DEBUG is
probably not necessary or useful as it guards
a BUG_ON.

---
 drivers/infiniband/hw/cxgb3/Kconfig    | 9 ---------
 drivers/infiniband/hw/cxgb3/Makefile   | 2 --
 drivers/infiniband/hw/cxgb3/cxio_hal.h | 9 ---------
 drivers/infiniband/hw/cxgb3/iwch_cq.c  | 7 -------
 4 files changed, 27 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/Kconfig b/drivers/infiniband/hw/cxgb3/Kconfig
index 431be733fbbe..a7b77cb3d5d5 100644
--- a/drivers/infiniband/hw/cxgb3/Kconfig
+++ b/drivers/infiniband/hw/cxgb3/Kconfig
@@ -16,12 +16,3 @@ config INFINIBAND_CXGB3
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called iw_cxgb3.
-
-config INFINIBAND_CXGB3_DEBUG
-	bool "Verbose debugging output"
-	depends on INFINIBAND_CXGB3
-	default n
-	---help---
-	  This option causes the Chelsio RDMA driver to produce copious
-	  amounts of debug messages.  Select this if you are developing
-	  the driver or trying to diagnose a problem.
diff --git a/drivers/infiniband/hw/cxgb3/Makefile b/drivers/infiniband/hw/cxgb3/Makefile
index 2c66d35d19bd..66fe0917aba0 100644
--- a/drivers/infiniband/hw/cxgb3/Makefile
+++ b/drivers/infiniband/hw/cxgb3/Makefile
@@ -5,5 +5,3 @@ obj-$(CONFIG_INFINIBAND_CXGB3) += iw_cxgb3.o
 
 iw_cxgb3-y :=  iwch_cm.o iwch_ev.o iwch_cq.o iwch_qp.o iwch_mem.o \
 	       iwch_provider.o iwch.o cxio_hal.o cxio_resource.o
-
-ccflags-$(CONFIG_INFINIBAND_CXGB3_DEBUG) += -DDEBUG
diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.h b/drivers/infiniband/hw/cxgb3/cxio_hal.h
index 7e70c5492262..c64e50b5a548 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.h
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.h
@@ -202,13 +202,4 @@ int iwch_cxgb3_ofld_send(struct t3cdev *tdev, struct sk_buff *skb);
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#ifdef DEBUG
-void cxio_dump_tpt(struct cxio_rdev *rev, u32 stag);
-void cxio_dump_pbl(struct cxio_rdev *rev, u32 pbl_addr, uint len, u8 shift);
-void cxio_dump_wqe(union t3_wr *wqe);
-void cxio_dump_wce(struct t3_cqe *wce);
-void cxio_dump_rqt(struct cxio_rdev *rdev, u32 hwtid, int nents);
-void cxio_dump_tcb(struct cxio_rdev *rdev, u32 hwtid);
-#endif
-
 #endif
diff --git a/drivers/infiniband/hw/cxgb3/iwch_cq.c b/drivers/infiniband/hw/cxgb3/iwch_cq.c
index dd5348e48806..f4979a505b3c 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cq.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cq.c
@@ -200,10 +200,6 @@ int iwch_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 
 	spin_lock_irqsave(&chp->lock, flags);
 	for (npolled = 0; npolled < num_entries; ++npolled) {
-#ifdef DEBUG
-		int i=0;
-#endif
-
 		/*
 		 * Because T3 can post CQEs that are _not_ associated
 		 * with a WR, we might have to poll again after removing
@@ -211,9 +207,6 @@ int iwch_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 		 */
 		do {
 			err = iwch_poll_cq_one(rhp, chp, wc + npolled);
-#ifdef DEBUG
-			BUG_ON(++i > 1000);
-#endif
 		} while (err == -EAGAIN);
 		if (err <= 0)
 			break;
