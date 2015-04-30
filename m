From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH v5 6/6] IB/ipath: use arch_phys_wc_add() and require PAT disabled
Date: Thu, 30 Apr 2015 13:25:20 -0700
Message-ID: <1430425520-22275-7-git-send-email-mcgrof@do-not-panic.com>
References: <1430425520-22275-1-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430425520-22275-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: bp@suse.de, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, daniel.vetter@intel.com, airlied@linux.ie
Cc: dledford@redhat.com, awalls@md.metrocast.net, syrjala@sci.fi, luto@amacapital.net, mst@redhat.com, cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Suresh Siddha <sbsiddha@gmail.com>, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Roland Dreier <roland@purestorage.com>, Linus Torvalds <torvalds@linux-foundation.org>, Juergen Gross <jgross@suse.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Antonino Daplas <adaplas@gmail.com>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Davidlohr Bueso <dbueso@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, Stefan Bader <stefan.>
List-Id: linux-rdma@vger.kernel.org

=46rom: "Luis R. Rodriguez" <mcgrof@suse.com>

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

Acked-by: Doug Ledford <dledford@redhat.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Andy Walls <awalls@md.metrocast.net>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Suresh Siddha <sbsiddha@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Juergen Gross <jgross@suse.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Ville Syrj=C3=A4l=C3=A4 <syrjala@sci.fi>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Borislav Petkov <bp@suse.de>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Stefan Bader <stefan.bader@canonical.com>
Cc: konrad.wilk@oracle.com
Cc: ville.syrjala@linux.intel.com
Cc: david.vrabel@citrix.com
Cc: jbeulich@suse.com
Cc: toshi.kani@hp.com
Cc: Roger Pau Monn=C3=A9 <roger.pau@citrix.com>
Cc: infinipath@intel.com
Cc: linux-rdma@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
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
