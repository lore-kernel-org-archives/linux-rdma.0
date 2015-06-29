From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 2/2] x86/mm/pat, drivers/media/ivtv: move pat warn and
 replace WARN() with pr_warn()
Date: Mon, 29 Jun 2015 08:55:05 +0200
Message-ID: <20150629065505.GB17509@gmail.com>
References: <1435166600-11956-1-git-send-email-mcgrof@do-not-panic.com>
 <1435166600-11956-3-git-send-email-mcgrof@do-not-panic.com>
 <20150625065147.GB5339@gmail.com>
 <20150625173847.GH3005@wotan.suse.de>
 <20150626084546.GD26303@gmail.com>
 <1435322161.2713.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-media-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1435322161.2713.10.camel@localhost>
Sender: linux-media-owner@vger.kernel.org
To: Andy Walls <andy@silverblocksystems.net>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>, Hyong-Youb Kim <hkim@cspi.com>, Andy Walls <awalls@md.metrocast.net>, benh@kernel.crashing.org, "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, bp@suse.de, mchehab@osg.samsung.com, dledford@redhat.com, fengguang.wu@intel.com, linux-media@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


* Andy Walls <andy@silverblocksystems.net> wrote:

> On Fri, 2015-06-26 at 10:45 +0200, Ingo Molnar wrote:
> > * Luis R. Rodriguez <mcgrof@suse.com> wrote:
> > 
> > > On Thu, Jun 25, 2015 at 08:51:47AM +0200, Ingo Molnar wrote:
> > > > 
> > > > * Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> > > > 
> > > > > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > > > > 
> > > > > On built-in kernels this warning will always splat as this is part
> > > > > of the module init. Fix that by shifting the PAT requirement check
> > > > > out under the code that does the "quasi-probe" for the device. This
> > > > > device driver relies on an existing driver to find its own devices,
> > > > > it looks for that device driver and its own found devices, then
> > > > > uses driver_for_each_device() to try to see if it can probe each of
> > > > > those devices as a frambuffer device with ivtvfb_init_card(). We
> > > > > tuck the PAT requiremenet check then on the ivtvfb_init_card()
> > > > > call making the check at least require an ivtv device present
> > > > > before complaining.
> > > > > 
> > > > > Reported-by: Fengguang Wu <fengguang.wu@intel.com> [0-day test robot]
> > > > > Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> > > > > ---
> > > > >  drivers/media/pci/ivtv/ivtvfb.c | 15 +++++++++------
> > > > >  1 file changed, 9 insertions(+), 6 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
> > > > > index 4cb365d..8b95eef 100644
> > > > > --- a/drivers/media/pci/ivtv/ivtvfb.c
> > > > > +++ b/drivers/media/pci/ivtv/ivtvfb.c
> > > > > @@ -38,6 +38,8 @@
> > > > >      Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> > > > >   */
> > > > >  
> > > > > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > > > > +
> > > > >  #include <linux/module.h>
> > > > >  #include <linux/kernel.h>
> > > > >  #include <linux/fb.h>
> > > > > @@ -1171,6 +1173,13 @@ static int ivtvfb_init_card(struct ivtv *itv)
> > > > >  {
> > > > >  	int rc;
> > > > >  
> > > > > +#ifdef CONFIG_X86_64
> > > > > +	if (pat_enabled()) {
> > > > > +		pr_warn("ivtvfb needs PAT disabled, boot with nopat kernel parameter\n");
> > > > > +		return -ENODEV;
> > > > > +	}
> > > > > +#endif
> > > > > +
> > > > >  	if (itv->osd_info) {
> > > > >  		IVTVFB_ERR("Card %d already initialised\n", ivtvfb_card_id);
> > > > >  		return -EBUSY;
> > > > 
> > > > Same argument as for ipath: why not make arch_phys_wc_add() fail on PAT and 
> > > > return -1, and check it in arch_phys_wc_del()?
> > > 
> > > The arch_phys_wc_add() is a no-op for PAT systems but for PAT to work we need 
> > > not only need to add this in where we replace the MTRR call but we also need to 
> > > convert ioremap_nocache() calls to ioremap_wc() but only if things were split up 
> > > already.
> > 
> 
> Hi Ingo,
> 
> > We don't need to do that: for such legacy drivers we can fall back to UC just 
> > fine, and inform the user that by booting with 'nopat' the old behavior will be 
> > back...
> 
> This is really a "user experience" decision.
> 
> IMO anyone who is still using ivtvfb and an old conventional PCI PVR-350 to 
> render, at SDTV resolution, an X Desktop display or video playback on a 
> television screen, isn't going to give a hoot about modern things like PAT.  The 
> user will simply want the framebuffer performance they are accustomed to having 
> with their system.  UC will probably yield unsatisfactory performance for an 
> ivtvfb framebuffer.
> 
> With that in mind, I would think it better to obviously and clearly disable the 
> ivtvfb framebuffer module with PAT enabled, so the user will check the log and 
> read the steps needed to obtain acceptable performance.
> 
> Maybe that's me just wanting to head off the "poor ivtvfb performance with 
> latest kernel" bug reports.
> 
> Whatever the decision, my stock response to bug reports related to this will 
> always be "What do the logs say?".

So what if that frame buffer is their only (working) frame buffer? A slow 
framebuffer is still much better at giving people logs to look at than a 
non-working one.

Thanks,

	Ingo
