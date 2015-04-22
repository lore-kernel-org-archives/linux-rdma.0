From: "Luis R. Rodriguez" <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>
Subject: [PATCH v5 2/2] IB/qib: use arch_phys_wc_add()
Date: Wed, 22 Apr 2015 11:38:24 -0700
Message-ID: <1429727904-5812-1-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Suresh Siddha <sbsiddha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Antonino Daplas <adaplas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Stefan Bader <stefan.bader-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, ville.syrjala@l
List-Id: linux-rdma@vger.kernel.org

=46rom: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>

This driver already makes use of ioremap_wc() on PIO buffers,
so convert it to use arch_phys_wc_add().

The qib driver uses a mmap() special case for when PAT is
not used, this behaviour used to be determined with a
module parameter but since we have been asked to just
remove that module parameter this checks for the WC cookie,
if not set we can assume PAT was used. If its set we do
what we used to do for the mmap for when MTRR was enabled.

The removal of the module parameter is OK given that Andy
notes that even if users of module parameter are still around
it will not prevent loading of the module on recent kernels.

Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Cc: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Suresh Siddha <sbsiddha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
Cc: Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>
Cc: Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Antonino Daplas <adaplas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>
Cc: Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>
Cc: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Stefan Bader <stefan.bader-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: ville.syrjala-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org
Cc: jbeulich-IBi9RG/b67k@public.gmane.org
Cc: Roger Pau Monn=C3=A9 <roger.pau-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: xen-devel-GuqFBffKawuULHF6PoxzQEEOCMrvLtNR@public.gmane.org
Signed-off-by: Luis R. Rodriguez <mcgrof-IBi9RG/b67k@public.gmane.org>
---

This v5 changes the comment to make it clear when the mmap code
will be true as requested by Doug. This patch still depends on
the v4 1/2 qib patch which enables accounting for the mtrr_add()
call. I won't be resending that one.

 drivers/infiniband/hw/qib/qib.h           |  1 -
 drivers/infiniband/hw/qib/qib_file_ops.c  |  3 ++-
 drivers/infiniband/hw/qib/qib_iba6120.c   |  8 +++---
 drivers/infiniband/hw/qib/qib_iba7220.c   |  8 +++---
 drivers/infiniband/hw/qib/qib_iba7322.c   | 41 +++++++++++++++--------=
--------
 drivers/infiniband/hw/qib/qib_init.c      | 26 ++++++--------------
 drivers/infiniband/hw/qib/qib_wc_x86_64.c | 31 +++--------------------
 7 files changed, 39 insertions(+), 79 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qi=
b/qib.h
index ffd48bf..ba5173e2 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -1136,7 +1136,6 @@ extern struct qib_devdata *qib_lookup(int unit);
 extern u32 qib_cpulist_count;
 extern unsigned long *qib_cpulist;
=20
-extern unsigned qib_wc_pat;
 extern unsigned qib_cc_table_size;
 int qib_init(struct qib_devdata *, int);
 int init_chip_wc_pat(struct qib_devdata *dd, u32);
diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infinib=
and/hw/qib/qib_file_ops.c
index 9ea6c44..7258818 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -835,7 +835,8 @@ static int mmap_piobufs(struct vm_area_struct *vma,
 	vma->vm_flags &=3D ~VM_MAYREAD;
 	vma->vm_flags |=3D VM_DONTCOPY | VM_DONTEXPAND;
=20
-	if (qib_wc_pat)
+	/* We used PAT if wc_cookie =3D=3D 0 */
+	if (!dd->wc_cookie)
 		vma->vm_page_prot =3D pgprot_writecombine(vma->vm_page_prot);
=20
 	ret =3D io_remap_pfn_range(vma, vma->vm_start, phys >> PAGE_SHIFT,
diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniba=
nd/hw/qib/qib_iba6120.c
index 0d2ba59..4b927809 100644
--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -3315,11 +3315,9 @@ static int init_6120_variables(struct qib_devdat=
a *dd)
 	qib_6120_config_ctxts(dd);
 	qib_set_ctxtcnt(dd);
=20
-	if (qib_wc_pat) {
-		ret =3D init_chip_wc_pat(dd, 0);
-		if (ret)
-			goto bail;
-	}
+	ret =3D init_chip_wc_pat(dd, 0);
+	if (ret)
+		goto bail;
 	set_6120_baseaddrs(dd); /* set chip access pointers now */
=20
 	ret =3D 0;
diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniba=
nd/hw/qib/qib_iba7220.c
index 22affda..00b2af2 100644
--- a/drivers/infiniband/hw/qib/qib_iba7220.c
+++ b/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -4126,11 +4126,9 @@ static int qib_init_7220_variables(struct qib_de=
vdata *dd)
 	qib_7220_config_ctxts(dd);
 	qib_set_ctxtcnt(dd);  /* needed for PAT setup */
=20
-	if (qib_wc_pat) {
-		ret =3D init_chip_wc_pat(dd, 0);
-		if (ret)
-			goto bail;
-	}
+	ret =3D init_chip_wc_pat(dd, 0);
+	if (ret)
+		goto bail;
 	set_7220_baseaddrs(dd); /* set chip access pointers now */
=20
 	ret =3D 0;
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniba=
nd/hw/qib/qib_iba7322.c
index ef97b71..f32b462 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -6429,6 +6429,7 @@ static int qib_init_7322_variables(struct qib_dev=
data *dd)
 	unsigned features, pidx, sbufcnt;
 	int ret, mtu;
 	u32 sbufs, updthresh;
+	resource_size_t vl15off;
=20
 	/* pport structs are contiguous, allocated after devdata */
 	ppd =3D (struct qib_pportdata *)(dd + 1);
@@ -6677,29 +6678,27 @@ static int qib_init_7322_variables(struct qib_d=
evdata *dd)
 	qib_7322_config_ctxts(dd);
 	qib_set_ctxtcnt(dd);
=20
-	if (qib_wc_pat) {
-		resource_size_t vl15off;
-		/*
-		 * We do not set WC on the VL15 buffers to avoid
-		 * a rare problem with unaligned writes from
-		 * interrupt-flushed store buffers, so we need
-		 * to map those separately here.  We can't solve
-		 * this for the rarely used mtrr case.
-		 */
-		ret =3D init_chip_wc_pat(dd, 0);
-		if (ret)
-			goto bail;
+	/*
+	 * We do not set WC on the VL15 buffers to avoid
+	 * a rare problem with unaligned writes from
+	 * interrupt-flushed store buffers, so we need
+	 * to map those separately here.  We can't solve
+	 * this for the rarely used mtrr case.
+	 */
+	ret =3D init_chip_wc_pat(dd, 0);
+	if (ret)
+		goto bail;
=20
-		/* vl15 buffers start just after the 4k buffers */
-		vl15off =3D dd->physaddr + (dd->piobufbase >> 32) +
-			dd->piobcnt4k * dd->align4k;
-		dd->piovl15base	=3D ioremap_nocache(vl15off,
-						  NUM_VL15_BUFS * dd->align4k);
-		if (!dd->piovl15base) {
-			ret =3D -ENOMEM;
-			goto bail;
-		}
+	/* vl15 buffers start just after the 4k buffers */
+	vl15off =3D dd->physaddr + (dd->piobufbase >> 32) +
+		  dd->piobcnt4k * dd->align4k;
+	dd->piovl15base	=3D ioremap_nocache(vl15off,
+					  NUM_VL15_BUFS * dd->align4k);
+	if (!dd->piovl15base) {
+		ret =3D -ENOMEM;
+		goto bail;
 	}
+
 	qib_7322_set_baseaddrs(dd); /* set chip access pointers now */
=20
 	ret =3D 0;
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/=
hw/qib/qib_init.c
index 2ee3695..7e00470 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -91,15 +91,6 @@ MODULE_PARM_DESC(krcvqs, "number of kernel receive q=
ueues per IB port");
 unsigned qib_cc_table_size;
 module_param_named(cc_table_size, qib_cc_table_size, uint, S_IRUGO);
 MODULE_PARM_DESC(cc_table_size, "Congestion control table entries 0 (C=
CA disabled - default), min =3D 128, max =3D 1984");
-/*
- * qib_wc_pat parameter:
- *      0 is WC via MTRR
- *      1 is WC via PAT
- *      If PAT initialization fails, code reverts back to MTRR
- */
-unsigned qib_wc_pat =3D 1; /* default (1) is to use PAT, not MTRR */
-module_param_named(wc_pat, qib_wc_pat, uint, S_IRUGO);
-MODULE_PARM_DESC(wc_pat, "enable write-combining via PAT mechanism");
=20
 static void verify_interrupt(unsigned long);
=20
@@ -1377,8 +1368,7 @@ static void cleanup_device_data(struct qib_devdat=
a *dd)
 		spin_unlock(&dd->pport[pidx].cc_shadow_lock);
 	}
=20
-	if (!qib_wc_pat)
-		qib_disable_wc(dd);
+	qib_disable_wc(dd);
=20
 	if (dd->pioavailregs_dma) {
 		dma_free_coherent(&dd->pcidev->dev, PAGE_SIZE,
@@ -1547,14 +1537,12 @@ static int qib_init_one(struct pci_dev *pdev, c=
onst struct pci_device_id *ent)
 		goto bail;
 	}
=20
-	if (!qib_wc_pat) {
-		ret =3D qib_enable_wc(dd);
-		if (ret) {
-			qib_dev_err(dd,
-				"Write combining not enabled (err %d): performance may be poor\n",
-				-ret);
-			ret =3D 0;
-		}
+	ret =3D qib_enable_wc(dd);
+	if (ret) {
+		qib_dev_err(dd,
+			"Write combining not enabled (err %d): performance may be poor\n",
+			-ret);
+		ret =3D 0;
 	}
=20
 	qib_verify_pioperf(dd);
diff --git a/drivers/infiniband/hw/qib/qib_wc_x86_64.c b/drivers/infini=
band/hw/qib/qib_wc_x86_64.c
index fe0850a..6d61ef9 100644
--- a/drivers/infiniband/hw/qib/qib_wc_x86_64.c
+++ b/drivers/infiniband/hw/qib/qib_wc_x86_64.c
@@ -116,21 +116,9 @@ int qib_enable_wc(struct qib_devdata *dd)
 	}
=20
 	if (!ret) {
-		int cookie;
-
-		cookie =3D mtrr_add(pioaddr, piolen, MTRR_TYPE_WRCOMB, 1);
-		if (cookie < 0) {
-			{
-				qib_devinfo(dd->pcidev,
-					 "mtrr_add()  WC for PIO bufs failed (%d)\n",
-					 cookie);
-				ret =3D -EINVAL;
-			}
-		} else {
-			dd->wc_cookie =3D cookie;
-			dd->wc_base =3D (unsigned long) pioaddr;
-			dd->wc_len =3D (unsigned long) piolen;
-		}
+		dd->wc_cookie =3D arch_phys_wc_add(pioaddr, piolen);
+		if (dd->wc_cookie < 0)
+			ret =3D -EINVAL;
 	}
=20
 	return ret;
@@ -142,18 +130,7 @@ int qib_enable_wc(struct qib_devdata *dd)
  */
 void qib_disable_wc(struct qib_devdata *dd)
 {
-	if (dd->wc_cookie) {
-		int r;
-
-		r =3D mtrr_del(dd->wc_cookie, dd->wc_base,
-			     dd->wc_len);
-		if (r < 0)
-			qib_devinfo(dd->pcidev,
-				 "mtrr_del(%lx, %lx, %lx) failed: %d\n",
-				 dd->wc_cookie, dd->wc_base,
-				 dd->wc_len, r);
-		dd->wc_cookie =3D 0; /* even on failure */
-	}
+	arch_phys_wc_del(dd->wc_cookie);
 }
=20
 /**
--=20
2.3.2.209.gd67f9d5.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
