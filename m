From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/7] IB/qib: avoid a rare 7322 chip problem by not marking
	VL15 bufs as WC
Date: Thu, 17 Jun 2010 16:13:44 -0700
Message-ID: <20100617231344.8006.26305.stgit@chromite.mv.qlogic.com>
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

From: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

Don't set write combining via PAT on the VL15 buffers to avoid a
rare problem with unaligned writes from interrupt-flushed store buffers.

Signed-off-by: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib.h         |    1 +
 drivers/infiniband/hw/qib/qib_diag.c    |   19 +++++++++++++++----
 drivers/infiniband/hw/qib/qib_iba7322.c |   18 +++++++++++++++++-
 drivers/infiniband/hw/qib/qib_init.c    |    6 ++++++
 drivers/infiniband/hw/qib/qib_pcie.c    |    2 ++
 drivers/infiniband/hw/qib/qib_tx.c      |    6 +++++-
 6 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 32d9208..3593983 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -686,6 +686,7 @@ struct qib_devdata {
 	void __iomem *piobase;
 	/* mem-mapped pointer to base of user chip regs (if using WC PAT) */
 	u64 __iomem *userbase;
+	void __iomem *piovl15base; /* base of VL15 buffers, if not WC */
 	/*
 	 * points to area where PIOavail registers will be DMA'ed.
 	 * Has to be on a page of it's own, because the page will be
diff --git a/drivers/infiniband/hw/qib/qib_diag.c b/drivers/infiniband/hw/qib/qib_diag.c
index ca98dd5..05dcf0d 100644
--- a/drivers/infiniband/hw/qib/qib_diag.c
+++ b/drivers/infiniband/hw/qib/qib_diag.c
@@ -233,6 +233,7 @@ static u32 __iomem *qib_remap_ioaddr32(struct qib_devdata *dd, u32 offset,
 	u32 __iomem *krb32 = (u32 __iomem *)dd->kregbase;
 	u32 __iomem *map = NULL;
 	u32 cnt = 0;
+	u32 tot4k, offs4k;
 
 	/* First, simplest case, offset is within the first map. */
 	kreglen = (dd->kregend - dd->kregbase) * sizeof(u64);
@@ -250,7 +251,8 @@ static u32 __iomem *qib_remap_ioaddr32(struct qib_devdata *dd, u32 offset,
 	if (dd->userbase) {
 		/* If user regs mapped, they are after send, so set limit. */
 		u32 ulim = (dd->cfgctxts * dd->ureg_align) + dd->uregbase;
-		snd_lim = dd->uregbase;
+		if (!dd->piovl15base)
+			snd_lim = dd->uregbase;
 		krb32 = (u32 __iomem *)dd->userbase;
 		if (offset >= dd->uregbase && offset < ulim) {
 			map = krb32 + (offset - dd->uregbase) / sizeof(u32);
@@ -277,14 +279,14 @@ static u32 __iomem *qib_remap_ioaddr32(struct qib_devdata *dd, u32 offset,
 	/* If 4k buffers exist, account for them by bumping
 	 * appropriate limit.
 	 */
+	tot4k = dd->piobcnt4k * dd->align4k;
+	offs4k = dd->piobufbase >> 32;
 	if (dd->piobcnt4k) {
-		u32 tot4k = dd->piobcnt4k * dd->align4k;
-		u32 offs4k = dd->piobufbase >> 32;
 		if (snd_bottom > offs4k)
 			snd_bottom = offs4k;
 		else {
 			/* 4k above 2k. Bump snd_lim, if needed*/
-			if (!dd->userbase)
+			if (!dd->userbase || dd->piovl15base)
 				snd_lim = offs4k + tot4k;
 		}
 	}
@@ -298,6 +300,15 @@ static u32 __iomem *qib_remap_ioaddr32(struct qib_devdata *dd, u32 offset,
 		cnt = snd_lim - offset;
 	}
 
+	if (!map && offs4k && dd->piovl15base) {
+		snd_lim = offs4k + tot4k + 2 * dd->align4k;
+		if (offset >= (offs4k + tot4k) && offset < snd_lim) {
+			map = (u32 __iomem *)dd->piovl15base +
+				((offset - (offs4k + tot4k)) / sizeof(u32));
+			cnt = snd_lim - offset;
+		}
+	}
+
 mapped:
 	if (cntp)
 		*cntp = cnt;
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 503992d..3e9828b 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -6119,9 +6119,25 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 	qib_set_ctxtcnt(dd);
 
 	if (qib_wc_pat) {
-		ret = init_chip_wc_pat(dd, NUM_VL15_BUFS * dd->align4k);
+		resource_size_t vl15off;
+		/*
+		 * We do not set WC on the VL15 buffers to avoid
+		 * a rare problem with unaligned writes from
+		 * interrupt-flushed store buffers, so we need
+		 * to map those separately here.  We can't solve
+		 * this for the rarely used mtrr case.
+		 */
+		ret = init_chip_wc_pat(dd, 0);
 		if (ret)
 			goto bail;
+
+		/* vl15 buffers start just after the 4k buffers */
+		vl15off = dd->physaddr + (dd->piobufbase >> 32) +
+			dd->piobcnt4k * dd->align4k;
+		dd->piovl15base	= ioremap_nocache(vl15off,
+						  NUM_VL15_BUFS * dd->align4k);
+		if (!dd->piovl15base)
+			goto bail;
 	}
 	qib_7322_set_baseaddrs(dd); /* set chip access pointers now */
 
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 9b40f34..2589599 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1499,6 +1499,12 @@ bail:
 	return -ENOMEM;
 }
 
+/*
+ * Note: Changes to this routine should be mirrored
+ * for the diagnostics routine qib_remap_ioaddr32().
+ * There is also related code for VL15 buffers in qib_init_7322_variables().
+ * The teardown code that unmaps is in qib_pcie_ddcleanup()
+ */
 int init_chip_wc_pat(struct qib_devdata *dd, u32 vl15buflen)
 {
 	u64 __iomem *qib_kregbase = NULL;
diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index c926bf4..7fa6e55 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -179,6 +179,8 @@ void qib_pcie_ddcleanup(struct qib_devdata *dd)
 		iounmap(dd->piobase);
 	if (dd->userbase)
 		iounmap(dd->userbase);
+	if (dd->piovl15base)
+		iounmap(dd->piovl15base);
 
 	pci_disable_device(dd->pcidev);
 	pci_release_regions(dd->pcidev);
diff --git a/drivers/infiniband/hw/qib/qib_tx.c b/drivers/infiniband/hw/qib/qib_tx.c
index f7eb1dd..af30232 100644
--- a/drivers/infiniband/hw/qib/qib_tx.c
+++ b/drivers/infiniband/hw/qib/qib_tx.c
@@ -340,9 +340,13 @@ rescan:
 		if (i < dd->piobcnt2k)
 			buf = (u32 __iomem *)(dd->pio2kbase +
 				i * dd->palign);
-		else
+		else if (i < dd->piobcnt2k + dd->piobcnt4k || !dd->piovl15base)
 			buf = (u32 __iomem *)(dd->pio4kbase +
 				(i - dd->piobcnt2k) * dd->align4k);
+		else
+			buf = (u32 __iomem *)(dd->piovl15base +
+				(i - (dd->piobcnt2k + dd->piobcnt4k)) *
+				dd->align4k);
 		if (pbufnum)
 			*pbufnum = i;
 		dd->upd_pio_shadow = 0;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
