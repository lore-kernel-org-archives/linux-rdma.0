From: "Luis R. Rodriguez" <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>
Subject: [PATCH v6 3/3] IB/ipath: use arch_phys_wc_add() and require PAT disabled
Date: Mon,  8 Jun 2015 17:20:22 -0700
Message-ID: <1433809222-28261-4-git-send-email-mcgrof@do-not-panic.com>
References: <1433809222-28261-1-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433809222-28261-1-git-send-email-mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, bp-l3A5Bk7waGM@public.gmane.org
Cc: tomi.valkeinen-l0cyMroinI0@public.gmane.org, bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Walls <awalls-Xoej9cPu4Z+RGvkDC/A1pg@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Suresh Siddha <sbsiddha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Antonino Daplas <adaplas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, =?UTF-8?q?Vi
List-Id: linux-rdma@vger.kernel.org

=46rom: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>

We are burrying direct access to MTRR code support on
x86 in order to take advantage of PAT. In the future we
also want to make the default behaviour of ioremap_nocache()
to use strong UC, use of mtrr_add() on those systems
would make write-combining void.

In order to help both enable us to later make strong
UC default and in order to phase out direct MTRR access
code port the driver over to arch_phys_wc_add() and
annotate that the device driver requires systems to
boot with PAT disabled, with the nopat kernel parameter.

This is a worthy compromise given that the ipath device
driver powers the old HTX bus cards that only work in
AMD systems, while the newer IB/qib device driver
powers all PCI-e cards. The ipath device driver is
obsolete, hardware hard to find and because of this
this its a reasonable compromise to make to require
users of ipath to boot with nopat.

Acked-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andy Walls <awalls-Xoej9cPu4Z+RGvkDC/A1pg@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Suresh Siddha <sbsiddha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
Cc: Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>
Cc: Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Antonino Daplas <adaplas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>
Cc: Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>
Cc: Ville Syrj=C3=A4l=C3=A4 <syrjala-ORSVBvAovxo@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Davidlohr Bueso <dbueso-l3A5Bk7waGM@public.gmane.org>
Cc: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Stefan Bader <stefan.bader-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: ville.syrjala-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org
Cc: jbeulich-IBi9RG/b67k@public.gmane.org
Cc: toshi.kani-VXdhtT5mjnY@public.gmane.org
Cc: Roger Pau Monn=C3=A9 <roger.pau-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: xen-devel-GuqFBffKawuULHF6PoxzQEEOCMrvLtNR@public.gmane.org
Signed-off-by: Luis R. Rodriguez <mcgrof-IBi9RG/b67k@public.gmane.org>
---
 drivers/infiniband/hw/ipath/Kconfig           |  3 ++
 drivers/infiniband/hw/ipath/ipath_driver.c    | 18 +++++++----
 drivers/infiniband/hw/ipath/ipath_kernel.h    |  4 +--
 drivers/infiniband/hw/ipath/ipath_wc_x86_64.c | 43 ++++++-------------=
--------
 4 files changed, 26 insertions(+), 42 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/Kconfig b/drivers/infiniband/h=
w/ipath/Kconfig
index 1d9bb11..8fe54ff 100644
--- a/drivers/infiniband/hw/ipath/Kconfig
+++ b/drivers/infiniband/hw/ipath/Kconfig
@@ -9,3 +9,6 @@ config INFINIBAND_IPATH
 	as IP-over-InfiniBand as well as with userspace applications
 	(in conjunction with InfiniBand userspace access).
 	For QLogic PCIe QLE based cards, use the QIB driver instead.
+
+	If you have this hardware you will need to boot with PAT disabled
+	on your x86-64 systems, use the nopat kernel parameter.
diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infin=
iband/hw/ipath/ipath_driver.c
index bd0caed..441cfe5 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -42,6 +42,9 @@
 #include <linux/bitmap.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#ifdef CONFIG_X86_64
+#include <asm/pat.h>
+#endif
=20
 #include "ipath_kernel.h"
 #include "ipath_verbs.h"
@@ -395,6 +398,14 @@ static int ipath_init_one(struct pci_dev *pdev, co=
nst struct pci_device_id *ent)
 	unsigned long long addr;
 	u32 bar0 =3D 0, bar1 =3D 0;
=20
+#ifdef CONFIG_X86_64
+	if (WARN(pat_enabled(),
+		 "ipath needs PAT disabled, boot with nopat kernel parameter\n")) {
+		ret =3D EINVAL;
+		goto bail;
+	}
+#endif
+
 	dd =3D ipath_alloc_devdata(pdev);
 	if (IS_ERR(dd)) {
 		ret =3D PTR_ERR(dd);
@@ -542,6 +553,7 @@ static int ipath_init_one(struct pci_dev *pdev, con=
st struct pci_device_id *ent)
 	dd->ipath_kregbase =3D __ioremap(addr, len,
 		(_PAGE_NO_CACHE|_PAGE_WRITETHRU));
 #else
+	/* XXX: split this properly to enable on PAT */
 	dd->ipath_kregbase =3D ioremap_nocache(addr, len);
 #endif
=20
@@ -587,12 +599,8 @@ static int ipath_init_one(struct pci_dev *pdev, co=
nst struct pci_device_id *ent)
=20
 	ret =3D ipath_enable_wc(dd);
=20
-	if (ret) {
-		ipath_dev_err(dd, "Write combining not enabled "
-			      "(err %d): performance may be poor\n",
-			      -ret);
+	if (ret)
 		ret =3D 0;
-	}
=20
 	ipath_verify_pioperf(dd);
=20
diff --git a/drivers/infiniband/hw/ipath/ipath_kernel.h b/drivers/infin=
iband/hw/ipath/ipath_kernel.h
index e08db70..f0f9471 100644
--- a/drivers/infiniband/hw/ipath/ipath_kernel.h
+++ b/drivers/infiniband/hw/ipath/ipath_kernel.h
@@ -463,9 +463,7 @@ struct ipath_devdata {
 	/* offset in HT config space of slave/primary interface block */
 	u8 ipath_ht_slave_off;
 	/* for write combining settings */
-	unsigned long ipath_wc_cookie;
-	unsigned long ipath_wc_base;
-	unsigned long ipath_wc_len;
+	int wc_cookie;
 	/* ref count for each pkey */
 	atomic_t ipath_pkeyrefs[4];
 	/* shadow copy of struct page *'s for exp tid pages */
diff --git a/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c b/drivers/in=
finiband/hw/ipath/ipath_wc_x86_64.c
index 70c1f3a..7b6e4c8 100644
--- a/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
+++ b/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
@@ -37,7 +37,6 @@
  */
=20
 #include <linux/pci.h>
-#include <asm/mtrr.h>
 #include <asm/processor.h>
=20
 #include "ipath_kernel.h"
@@ -122,27 +121,14 @@ int ipath_enable_wc(struct ipath_devdata *dd)
 	}
=20
 	if (!ret) {
-		int cookie;
-		ipath_cdbg(VERBOSE, "Setting mtrr for chip to WC "
-			   "(addr %llx, len=3D0x%llx)\n",
-			   (unsigned long long) pioaddr,
-			   (unsigned long long) piolen);
-		cookie =3D mtrr_add(pioaddr, piolen, MTRR_TYPE_WRCOMB, 1);
-		if (cookie < 0) {
-			{
-				dev_info(&dd->pcidev->dev,
-					 "mtrr_add()  WC for PIO bufs "
-					 "failed (%d)\n",
-					 cookie);
-				ret =3D -EINVAL;
-			}
-		} else {
-			ipath_cdbg(VERBOSE, "Set mtrr for chip to WC, "
-				   "cookie is %d\n", cookie);
-			dd->ipath_wc_cookie =3D cookie;
-			dd->ipath_wc_base =3D (unsigned long) pioaddr;
-			dd->ipath_wc_len =3D (unsigned long) piolen;
-		}
+		dd->wc_cookie =3D arch_phys_wc_add(pioaddr, piolen);
+		if (dd->wc_cookie < 0) {
+			ipath_dev_err(dd, "Seting mtrr failed on PIO buffers\n");
+			ret =3D -ENODEV;
+		} else if (dd->wc_cookie =3D=3D 0)
+			ipath_cdbg(VERBOSE, "Set mtrr for chip to WC not needed\n");
+		else
+			ipath_cdbg(VERBOSE, "Set mtrr for chip to WC\n");
 	}
=20
 	return ret;
@@ -154,16 +140,5 @@ int ipath_enable_wc(struct ipath_devdata *dd)
  */
 void ipath_disable_wc(struct ipath_devdata *dd)
 {
-	if (dd->ipath_wc_cookie) {
-		int r;
-		ipath_cdbg(VERBOSE, "undoing WCCOMB on pio buffers\n");
-		r =3D mtrr_del(dd->ipath_wc_cookie, dd->ipath_wc_base,
-			     dd->ipath_wc_len);
-		if (r < 0)
-			dev_info(&dd->pcidev->dev,
-				 "mtrr_del(%lx, %lx, %lx) failed: %d\n",
-				 dd->ipath_wc_cookie, dd->ipath_wc_base,
-				 dd->ipath_wc_len, r);
-		dd->ipath_wc_cookie =3D 0; /* even on failure */
-	}
+	arch_phys_wc_del(dd->wc_cookie);
 }
--=20
2.3.2.209.gd67f9d5.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
