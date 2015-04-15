From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
Date: Thu, 16 Apr 2015 00:15:17 +0200
Message-ID: <20150415221517.GF5622@wotan.suse.de>
References: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-media-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, linux-media@vger.kernel.org
Cc: linux-rdma@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Suresh Siddha <sbsiddha@gmail.com>, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Roland Dreier <roland@purestorage.com>, Juergen Gross <jgross@suse.com>, Andy Walls <awalls@md.metrocast.net>, Borislav Petkov <bp@suse.de>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Davidlohr Bueso <dbueso@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Thomas Gleixner <tglx@linutronix.de>, Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>Linux Fbdev development list <linux>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 15, 2015 at 01:42:47PM -0700, Andy Lutomirski wrote:
> On Mon, Apr 13, 2015 at 10:49 AM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> 
> > c) ivtv: the driver does not have the PCI space mapped out separately, and
> > in fact it actually does not do the math for the framebuffer, instead it lets
> > the device's own CPU do that and assume where its at, see
> > ivtvfb_get_framebuffer() and CX2341X_OSD_GET_FRAMEBUFFER, it has a get
> > but not a setter. Its not clear if the firmware would make a split easy.
> > We'd need ioremap_ucminus() here too and __arch_phys_wc_add().
> >
> 
> IMO this should be conceptually easy to split.  Once we get the
> framebuffer address, just unmap it (or don't prematurely map it) and
> then ioremap the thing.

The driver has split code for handling framebuffer devices, the framebuffer
base address will also vary depending on the type of device it has, for
some its on the encoder, for others its on the decoder. We'd have to account
for the removal of the framebuffer on either of those regions, and would also
need some vetting that the driver doesn't use areas beyond that for MMIO.
Using the trick you suggest though we could overlap ioremap calls and if that
truly works on PAT and non-PAT adding a new ioremap_wc() could do the trick,
I'd appreciate a Tested-by or Acked-by to be done with this. Mauro, any chance
we can get a tested-by of ivtvfb for both non-PAT and PAT systems with this:

diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
index 9ff1230..1838738 100644
--- a/drivers/media/pci/ivtv/ivtvfb.c
+++ b/drivers/media/pci/ivtv/ivtvfb.c
@@ -44,10 +44,6 @@
 #include <linux/ivtvfb.h>
 #include <linux/slab.h>
 
-#ifdef CONFIG_MTRR
-#include <asm/mtrr.h>
-#endif
-
 #include "ivtv-driver.h"
 #include "ivtv-cards.h"
 #include "ivtv-i2c.h"
@@ -155,12 +151,11 @@ struct osd_info {
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
@@ -1099,6 +1094,8 @@ static int ivtvfb_init_vidmode(struct ivtv *itv)
 static int ivtvfb_init_io(struct ivtv *itv)
 {
 	struct osd_info *oi = itv->osd_info;
+	/* Find the largest power of two that maps the whole buffer */
+	int size_shift = 31;
 
 	mutex_lock(&itv->serialize_lock);
 	if (ivtv_init_on_first_open(itv)) {
@@ -1120,7 +1117,7 @@ static int ivtvfb_init_io(struct ivtv *itv)
 	oi->video_buffer_size = 1704960;
 
 	oi->video_pbase = itv->base_addr + IVTV_DECODER_OFFSET + oi->video_rbase;
-	oi->video_vbase = itv->dec_mem + oi->video_rbase;
+	oi->video_vbase = ioremap_wc(oi->video_pbase, oi->video_buffer_size);
 
 	if (!oi->video_vbase) {
 		IVTVFB_ERR("abort, video memory 0x%x @ 0x%lx isn't mapped!\n",
@@ -1132,29 +1129,16 @@ static int ivtvfb_init_io(struct ivtv *itv)
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
 
@@ -1172,14 +1156,8 @@ static void ivtvfb_release_buffers (struct ivtv *itv)
 
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

> 
> > From the beginning it seems only framebuffer devices used MTRR/WC, lately it
> > seems infiniband drivers also find good use for for it for PIO TX buffers to
> > blast some sort of data, in the future I would not be surprised if other
> > devices found use for it.
> 
> IMO the Infiniband maintainers should fix their code.  Especially in
> the server space, there aren't that many MTRRs to go around.  I wrote
> arch_phys_wc_add in the first place because my server *ran out of
> MTRRs*.
> 
> Hey, IB people: can you fix your drivers to use arch_phys_wc_add
> (which is permitted to be a no-op) along with ioremap_wc?  Your users
> will thank you.

Provided the above ivtv driver changes are OK this would be the *last* and only
driver required to be changed.

> > It may be true that the existing drivers that
> > requires the above type of work are corner cases -- but I wouldn't hold my
> > breath for that. The ivtv device is a good example of the worst type of
> > situations and these days. So perhap __arch_phys_wc_add() and a
> > ioremap_ucminus() might be something more than transient unless hardware folks
> > get a good memo or already know how to just Do The Right Thing (TM).
> 
> I disagree.  We should try to NACK any new code that can't function
> without MTRRs.
> 
> (Plus, ARM is growing in popularity in the server space, and ARM quite
> sensibly doesn't have MTRRs.)

Great, happy with this, but we need to address the last few drivers and their
exisitng code then.

 Luis
