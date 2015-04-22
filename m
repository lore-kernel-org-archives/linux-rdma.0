From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
Date: Wed, 22 Apr 2015 18:51:58 +0200
Message-ID: <20150422165158.GG5622@wotan.suse.de>
References: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
 <20150421224601.GY5622@wotan.suse.de>
 <20150421225732.GA17356@obsidianresearch.com>
 <20150421233907.GA5622@wotan.suse.de>
 <20150422053939.GA29609@obsidianresearch.com>
 <20150422152328.GB5622@wotan.suse.de>
 <20150422161755.GA19500@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-media-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150422161755.GA19500@obsidianresearch.com>
Sender: linux-media-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Andy Lutomirski <luto@amacapital.net>, mike.marciniszyn@intel.com, infinipath@intel.com, linux-rdma@vger.kernel.org, awalls@md.metrocast.net, Toshi Kani <toshi.kani@hp.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Suresh Siddha <sbsiddha@gmail.com>, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Roland Dreier <roland@purestorage.com>, Juergen Gross <jgross@suse.com>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Borislav Petkov <bp@suse.de>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Davidlohr Bueso <dbueso@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Thomas Gleixner <tglx@linutronix.de>, Ville
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 22, 2015 at 10:17:55AM -0600, Jason Gunthorpe wrote:
> On Wed, Apr 22, 2015 at 05:23:28PM +0200, Luis R. Rodriguez wrote:
> > On Tue, Apr 21, 2015 at 11:39:39PM -0600, Jason Gunthorpe wrote:
> > > On Wed, Apr 22, 2015 at 01:39:07AM +0200, Luis R. Rodriguez wrote:
> > > > > Mike, do you think the time is right to just remove the iPath driver?
> > > > 
> > > > With PAT now being default the driver effectively won't work
> > > > with write-combining on modern kernels. Even if systems are old
> > > > they likely had PAT support, when upgrading kernels PAT will work
> > > > but write-combing won't on ipath.
> > > 
> > > Sorry, do you mean the driver already doesn't get WC? Or do you mean
> > > after some more pending patches are applied?
> > 
> > No, you have to consider the system used and the effects of calls used
> > on the driver in light of this table:
> 
> So, just to be clear:
> 
> At some point Linux started setting the PAT bits during
> ioremap_nocache, which overrides MTRR, and at that point the driver
> became broken on all PAT capable systems?

No, PAT code lacked quite a bit of love, and Juergen and some others have
been giving it some love and now we expect PAT to be enabled by default on
more systems. When and and on what systemes and as of what commits? Not
sure, there's quite a bit of PAT work but hoping Juergen might fill
in the details, CC'd.

> Not only that, but we've only just noticed it now, and no user ever
> complained?

No, well this is all recent, so we expect more PAT enabled systems now.

> So that means either no users exist, or all users are on non-PAT
> systems?

PAT was not being enabled before on most systems, it will now be on
most systems, for some systems there may be some errata that needs to
be addressed for PAT.

> This driver only works on x86-64 systems. Are there any x86-64 systems
> that are not PAT capable? 

Not that I know of, but I've heard of some "PAT errata" systems, and
that may need some attention.

> IIRC even the first Opteron had PAT, but my
> memory is fuzzy from back then :|
> 
> > Another option in order to enable this type of checks at run time
> > and still be able to build the driver on standard distributions and
> > just prevent if from loading on PAT systems is to have some code in
> > place which would prevent the driver from loading if PAT was
> > enabled, this would enable folks to disable PAT via a kernel command
> > line option, and if that was used then the driver probe would
> > complete.
> 
> This seems like a reasonble option to me. At the very least we might
> learn if anyone is still using these cards.

OK great.

> I'd also love to remove the driver if it turns out there are actually
> no users. qib substantially replaces it except for a few very old
> cards.
> 
> Mike?

By replacing do you mean same hardware? BTW below are the changes
which I describe above which would prevent both ipath and ivtv
to load on PAT enabled systems. I think its a reasonable compromise.
If this is OK I can proceed with a split of the patches and move 
on with the last series that burries MTRR.

Andy Walls, please review too.

  Luis

diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index bd0caed..3ef592c 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -42,6 +42,9 @@
 #include <linux/bitmap.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#ifdef CONFIG_X86_64
+#include <asm/pat.h>
+#endif
 
 #include "ipath_kernel.h"
 #include "ipath_verbs.h"
@@ -395,6 +398,14 @@ static int ipath_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	unsigned long long addr;
 	u32 bar0 = 0, bar1 = 0;
 
+#ifdef CONFIG_X86_64
+	if (WARN(pat_enabled,
+		 "ipath needs PAT disabled, boot with nopat kernel parameter\n")) {
+		ret = EINVAL;
+		goto bail;
+	}
+#endif
+
 	dd = ipath_alloc_devdata(pdev);
 	if (IS_ERR(dd)) {
 		ret = PTR_ERR(dd);
@@ -542,6 +553,7 @@ static int ipath_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dd->ipath_kregbase = __ioremap(addr, len,
 		(_PAGE_NO_CACHE|_PAGE_WRITETHRU));
 #else
+	/* XXX: split this properly to enable on PAT */
 	dd->ipath_kregbase = ioremap_nocache(addr, len);
 #endif
 
@@ -587,12 +599,8 @@ static int ipath_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ret = ipath_enable_wc(dd);
 
-	if (ret) {
-		ipath_dev_err(dd, "Write combining not enabled "
-			      "(err %d): performance may be poor\n",
-			      -ret);
+	if (ret)
 		ret = 0;
-	}
 
 	ipath_verify_pioperf(dd);
 
diff --git a/drivers/infiniband/hw/ipath/ipath_kernel.h b/drivers/infiniband/hw/ipath/ipath_kernel.h
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
diff --git a/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c b/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
index 70c1f3a..7b6e4c8 100644
--- a/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
+++ b/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
@@ -37,7 +37,6 @@
  */
 
 #include <linux/pci.h>
-#include <asm/mtrr.h>
 #include <asm/processor.h>
 
 #include "ipath_kernel.h"
@@ -122,27 +121,14 @@ int ipath_enable_wc(struct ipath_devdata *dd)
 	}
 
 	if (!ret) {
-		int cookie;
-		ipath_cdbg(VERBOSE, "Setting mtrr for chip to WC "
-			   "(addr %llx, len=0x%llx)\n",
-			   (unsigned long long) pioaddr,
-			   (unsigned long long) piolen);
-		cookie = mtrr_add(pioaddr, piolen, MTRR_TYPE_WRCOMB, 1);
-		if (cookie < 0) {
-			{
-				dev_info(&dd->pcidev->dev,
-					 "mtrr_add()  WC for PIO bufs "
-					 "failed (%d)\n",
-					 cookie);
-				ret = -EINVAL;
-			}
-		} else {
-			ipath_cdbg(VERBOSE, "Set mtrr for chip to WC, "
-				   "cookie is %d\n", cookie);
-			dd->ipath_wc_cookie = cookie;
-			dd->ipath_wc_base = (unsigned long) pioaddr;
-			dd->ipath_wc_len = (unsigned long) piolen;
-		}
+		dd->wc_cookie = arch_phys_wc_add(pioaddr, piolen);
+		if (dd->wc_cookie < 0) {
+			ipath_dev_err(dd, "Seting mtrr failed on PIO buffers\n");
+			ret = -ENODEV;
+		} else if (dd->wc_cookie == 0)
+			ipath_cdbg(VERBOSE, "Set mtrr for chip to WC not needed\n");
+		else
+			ipath_cdbg(VERBOSE, "Set mtrr for chip to WC\n");
 	}
 
 	return ret;
@@ -154,16 +140,5 @@ int ipath_enable_wc(struct ipath_devdata *dd)
  */
 void ipath_disable_wc(struct ipath_devdata *dd)
 {
-	if (dd->ipath_wc_cookie) {
-		int r;
-		ipath_cdbg(VERBOSE, "undoing WCCOMB on pio buffers\n");
-		r = mtrr_del(dd->ipath_wc_cookie, dd->ipath_wc_base,
-			     dd->ipath_wc_len);
-		if (r < 0)
-			dev_info(&dd->pcidev->dev,
-				 "mtrr_del(%lx, %lx, %lx) failed: %d\n",
-				 dd->ipath_wc_cookie, dd->ipath_wc_base,
-				 dd->ipath_wc_len, r);
-		dd->ipath_wc_cookie = 0; /* even on failure */
-	}
+	arch_phys_wc_del(dd->wc_cookie);
 }
diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
index 9ff1230..369598c 100644
--- a/drivers/media/pci/ivtv/ivtvfb.c
+++ b/drivers/media/pci/ivtv/ivtvfb.c
@@ -44,8 +44,8 @@
 #include <linux/ivtvfb.h>
 #include <linux/slab.h>
 
-#ifdef CONFIG_MTRR
-#include <asm/mtrr.h>
+#ifdef CONFIG_X86_64
+#include <asm/pat.h>
 #endif
 
 #include "ivtv-driver.h"
@@ -155,12 +155,11 @@ struct osd_info {
 	/* Buffer size */
 	u32 video_buffer_size;
 
-#ifdef CONFIG_MTRR
 	/* video_base rounded down as required by hardware MTRRs */
 	unsigned long fb_start_aligned_physaddr;
 	/* video_base rounded up as required by hardware MTRRs */
 	unsigned long fb_end_aligned_physaddr;
-#endif
+	int wc_cookie;
 
 	/* Store the buffer offset */
 	int set_osd_coords_x;
@@ -1099,6 +1098,8 @@ static int ivtvfb_init_vidmode(struct ivtv *itv)
 static int ivtvfb_init_io(struct ivtv *itv)
 {
 	struct osd_info *oi = itv->osd_info;
+	/* Find the largest power of two that maps the whole buffer */
+	int size_shift = 31;
 
 	mutex_lock(&itv->serialize_lock);
 	if (ivtv_init_on_first_open(itv)) {
@@ -1120,6 +1121,7 @@ static int ivtvfb_init_io(struct ivtv *itv)
 	oi->video_buffer_size = 1704960;
 
 	oi->video_pbase = itv->base_addr + IVTV_DECODER_OFFSET + oi->video_rbase;
+	/* XXX: split this for PAT */
 	oi->video_vbase = itv->dec_mem + oi->video_rbase;
 
 	if (!oi->video_vbase) {
@@ -1132,29 +1134,16 @@ static int ivtvfb_init_io(struct ivtv *itv)
 			oi->video_pbase, oi->video_vbase,
 			oi->video_buffer_size / 1024);
 
-#ifdef CONFIG_MTRR
-	{
-		/* Find the largest power of two that maps the whole buffer */
-		int size_shift = 31;
-
-		while (!(oi->video_buffer_size & (1 << size_shift))) {
-			size_shift--;
-		}
-		size_shift++;
-		oi->fb_start_aligned_physaddr = oi->video_pbase & ~((1 << size_shift) - 1);
-		oi->fb_end_aligned_physaddr = oi->video_pbase + oi->video_buffer_size;
-		oi->fb_end_aligned_physaddr += (1 << size_shift) - 1;
-		oi->fb_end_aligned_physaddr &= ~((1 << size_shift) - 1);
-		if (mtrr_add(oi->fb_start_aligned_physaddr,
-			oi->fb_end_aligned_physaddr - oi->fb_start_aligned_physaddr,
-			     MTRR_TYPE_WRCOMB, 1) < 0) {
-			IVTVFB_INFO("disabled mttr\n");
-			oi->fb_start_aligned_physaddr = 0;
-			oi->fb_end_aligned_physaddr = 0;
-		}
-	}
-#endif
-
+	while (!(oi->video_buffer_size & (1 << size_shift)))
+		size_shift--;
+	size_shift++;
+	oi->fb_start_aligned_physaddr = oi->video_pbase & ~((1 << size_shift) - 1);
+	oi->fb_end_aligned_physaddr = oi->video_pbase + oi->video_buffer_size;
+	oi->fb_end_aligned_physaddr += (1 << size_shift) - 1;
+	oi->fb_end_aligned_physaddr &= ~((1 << size_shift) - 1);
+	oi->wc_cookie = arch_phys_wc_add(oi->fb_start_aligned_physaddr,
+					 oi->fb_end_aligned_physaddr -
+					 oi->fb_start_aligned_physaddr);
 	/* Blank the entire osd. */
 	memset_io(oi->video_vbase, 0, oi->video_buffer_size);
 
@@ -1172,14 +1161,8 @@ static void ivtvfb_release_buffers (struct ivtv *itv)
 
 	/* Release pseudo palette */
 	kfree(oi->ivtvfb_info.pseudo_palette);
-
-#ifdef CONFIG_MTRR
-	if (oi->fb_end_aligned_physaddr) {
-		mtrr_del(-1, oi->fb_start_aligned_physaddr,
-			oi->fb_end_aligned_physaddr - oi->fb_start_aligned_physaddr);
-	}
-#endif
-
+	iounmap(oi->video_vbase);
+	arch_phys_wc_del(oi->wc_cookie);
 	kfree(oi);
 	itv->osd_info = NULL;
 }
@@ -1190,6 +1173,13 @@ static int ivtvfb_init_card(struct ivtv *itv)
 {
 	int rc;
 
+#ifdef CONFIG_X86_64
+	if (WARN(pat_enabled,
+		 "ivtv needs PAT disabled, boot with nopat kernel parameter\n")) {
+		return EINVAL;
+	}
+#endif
+
 	if (itv->osd_info) {
 		IVTVFB_ERR("Card %d already initialised\n", ivtvfb_card_id);
 		return -EBUSY;
