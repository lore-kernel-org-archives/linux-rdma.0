From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH v2 2/2] x86/mm/pat, drivers/media/ivtv: move pat warn and
 replace WARN() with pr_warn()
Date: Tue, 7 Jul 2015 02:44:17 +0200
Message-ID: <20150707004417.GM7021@wotan.suse.de>
References: <1435166600-11956-1-git-send-email-mcgrof@do-not-panic.com>
 <1435166600-11956-3-git-send-email-mcgrof@do-not-panic.com>
 <20150625065147.GB5339@gmail.com>
 <20150625173847.GH3005@wotan.suse.de>
 <20150626084546.GD26303@gmail.com>
 <1435322161.2713.10.camel@localhost>
 <20150629065505.GB17509@gmail.com>
 <57337D5A-7486-4D01-8316-DFAF4CAF3DA7@md.metrocast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-media-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57337D5A-7486-4D01-8316-DFAF4CAF3DA7@md.metrocast.net>
Sender: linux-media-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>, Andy Walls <andy@silverblocksystems.net>, Toshi Kani <toshi.kani@hp.com>, Hyong-Youb Kim <hkim@cspi.com>, benh@kernel.crashing.org, "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, bp@suse.de, mchehab@osg.samsung.com, dledford@redhat.com, fengguang.wu@intel.com, linux-media@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 29, 2015 at 05:52:18AM -0400, Andy Walls wrote:
> On June 29, 2015 2:55:05 AM EDT, Ingo Molnar <mingo@kernel.org> wrote:
> >
> >* Andy Walls <andy@silverblocksystems.net> wrote:
> >
> >> On Fri, 2015-06-26 at 10:45 +0200, Ingo Molnar wrote:
> >> > * Luis R. Rodriguez <mcgrof@suse.com> wrote:
> >> > 
> >> > > On Thu, Jun 25, 2015 at 08:51:47AM +0200, Ingo Molnar wrote:
> >> > > > 
> >> > > > * Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> >> > > > 
> >> > > > > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> >> > > > > 
> >> > > > > On built-in kernels this warning will always splat as this is
> >part
> >> > > > > of the module init. Fix that by shifting the PAT requirement
> >check
> >> > > > > out under the code that does the "quasi-probe" for the
> >device. This
> >> > > > > device driver relies on an existing driver to find its own
> >devices,
> >> > > > > it looks for that device driver and its own found devices,
> >then
> >> > > > > uses driver_for_each_device() to try to see if it can probe
> >each of
> >> > > > > those devices as a frambuffer device with ivtvfb_init_card().
> >We
> >> > > > > tuck the PAT requiremenet check then on the
> >ivtvfb_init_card()
> >> > > > > call making the check at least require an ivtv device present
> >> > > > > before complaining.
> >> > > > > 
> >> > > > > Reported-by: Fengguang Wu <fengguang.wu@intel.com> [0-day
> >test robot]
> >> > > > > Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> >> > > > > ---
> >> > > > >  drivers/media/pci/ivtv/ivtvfb.c | 15 +++++++++------
> >> > > > >  1 file changed, 9 insertions(+), 6 deletions(-)
> >> > > > > 
> >> > > > > diff --git a/drivers/media/pci/ivtv/ivtvfb.c
> >b/drivers/media/pci/ivtv/ivtvfb.c
> >> > > > > index 4cb365d..8b95eef 100644
> >> > > > > --- a/drivers/media/pci/ivtv/ivtvfb.c
> >> > > > > +++ b/drivers/media/pci/ivtv/ivtvfb.c
> >> > > > > @@ -38,6 +38,8 @@
> >> > > > >      Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
> > 02111-1307  USA
> >> > > > >   */
> >> > > > >  
> >> > > > > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >> > > > > +
> >> > > > >  #include <linux/module.h>
> >> > > > >  #include <linux/kernel.h>
> >> > > > >  #include <linux/fb.h>
> >> > > > > @@ -1171,6 +1173,13 @@ static int ivtvfb_init_card(struct
> >ivtv *itv)
> >> > > > >  {
> >> > > > >  	int rc;
> >> > > > >  
> >> > > > > +#ifdef CONFIG_X86_64
> >> > > > > +	if (pat_enabled()) {
> >> > > > > +		pr_warn("ivtvfb needs PAT disabled, boot with nopat kernel
> >parameter\n");
> >> > > > > +		return -ENODEV;
> >> > > > > +	}
> >> > > > > +#endif
> >> > > > > +
> >> > > > >  	if (itv->osd_info) {
> >> > > > >  		IVTVFB_ERR("Card %d already initialised\n",
> >ivtvfb_card_id);
> >> > > > >  		return -EBUSY;
> >> > > > 
> >> > > > Same argument as for ipath: why not make arch_phys_wc_add()
> >fail on PAT and 
> >> > > > return -1, and check it in arch_phys_wc_del()?
> >> > > 
> >> > > The arch_phys_wc_add() is a no-op for PAT systems but for PAT to
> >work we need 
> >> > > not only need to add this in where we replace the MTRR call but
> >we also need to 
> >> > > convert ioremap_nocache() calls to ioremap_wc() but only if
> >things were split up 
> >> > > already.
> >> > 
> >> 
> >> Hi Ingo,
> >> 
> >> > We don't need to do that: for such legacy drivers we can fall back
> >to UC just 
> >> > fine, and inform the user that by booting with 'nopat' the old
> >behavior will be 
> >> > back...
> >> 
> >> This is really a "user experience" decision.
> >> 
> >> IMO anyone who is still using ivtvfb and an old conventional PCI
> >PVR-350 to 
> >> render, at SDTV resolution, an X Desktop display or video playback on
> >a 
> >> television screen, isn't going to give a hoot about modern things
> >like PAT.  The 
> >> user will simply want the framebuffer performance they are accustomed
> >to having 
> >> with their system.  UC will probably yield unsatisfactory performance
> >for an 
> >> ivtvfb framebuffer.
> >> 
> >> With that in mind, I would think it better to obviously and clearly
> >disable the 
> >> ivtvfb framebuffer module with PAT enabled, so the user will check
> >the log and 
> >> read the steps needed to obtain acceptable performance.
> >> 
> >> Maybe that's me just wanting to head off the "poor ivtvfb performance
> >with 
> >> latest kernel" bug reports.
> >> 
> >> Whatever the decision, my stock response to bug reports related to
> >this will 
> >> always be "What do the logs say?".
> >
> >So what if that frame buffer is their only (working) frame buffer? A
> >slow 
> >framebuffer is still much better at giving people logs to look at than
> >a 
> >non-working one.
> >
> >Thanks,
> >
> >	Ingo
> 
> Hi Ingo,
> 
> For an old DVR setup, I can see that being the case.
> 
> So a sluggish framebuffer is better than none.

OK, so I knew I had considered this strategy before, I did and here's
the recap:

I originally had proposed this same exact thing with my first patch set but [0]
had set to require a new __arch_phys_wc_add() which forces the setting without
checking if pat_enabled() is true. This was set out as a transient API in hopes
that device drivers that require work but hadn't been converted to split the
ioremap'd calls would later be modified / fixed with the split. Here's an
update for the status of each driver:

Driver          File
------------------------------------------------------------
fusion          drivers/message/fusion/mptbase.c
  This code was commented out, the code was just removed, this longer applies.

ivtv            drivers/media/pci/ivtv/ivtvfb.c
  The firmware sucks, it does not expose the WC area, and likely we won't be able to
  do the split, the work for it is simply not worth the effort. This driver is old
  for an old DVR setup.

ipath           drivers/infiniband/hw/ipath/ipath_driver.c
   I did an evaluation of the work required and its significant, discussions
   are ongoing about just removing the driver from v4.3.

When originally proposed __arch_phys_wc_add() Andy Luto ended up requesting to
consider instead using ioremap_nocache() and then set_memory_wc() but Toshi
noted to me that was not possible as set_memory_wc() cannot work on IO memory
because:

--
1. __pa(addr) returns a fake address since there is no direct map.
2. reserve_memtype() tracks regular memory and I/O memory differently.

For regular memory, set_memory_*() can modify WB with a new type since
reserve_memtype() does not track WB.  For I/O memory, reserve_memtype()
detects a conflict when a given type is different from a tracked type.
--

Given the changes above and the issue with set_memory_wc() another
possibility is to do overlapping ioremap calls but one issue there was
the aliasing possible issues and no one seemed to know WTF would happen
for sure. After considering the overlapping ioremap() call strategy,
since only 3 drivers were affected (we have fixed atyfb with
iorenmap_uc() solution) since it really was only 2 drivers that needed
a work around and they were both for old devices it seems me and Andy
preferred to just treat them specially and I guess what we decided
in the end to do was to just not add transient APIs [1] but instead
that boot thing this thread talks about and which got merged.

So in light of all this review now: I am not sure its worth to remove
the pat_enabled() check from arch_phys_wc_add() or to just warn about
it. If we really wanted to we could consider arch_phys_wc_add() and
deal with that this will not check for pat_enabled() and forces MTRR...
I think Andy Luto won't like that very much though ? I at least don't
like it since we did all this work to finally leave only 1 piece of
code with direct MTRR access... Seems a bit sad. Since ipath will
be removed we'd have only ivtv driver using this API, I am not sure if
its worth it.

Thoughts?

[0] http://lkml.kernel.org/r/1426893517-2511-7-git-send-email-mcgrof@do-not-panic.com
[1] http://lkml.kernel.org/r/CALCETrVY-+aZU0mTp+BUtzTiWq8cL_rK7hymtUpwyLhyRaouZA@mail.gmail.com

  Luis
