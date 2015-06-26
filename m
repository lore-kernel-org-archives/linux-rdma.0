From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 1/2] x86/mm/pat, drivers/infiniband/ipath: replace
 WARN() with pr_warn()
Date: Fri, 26 Jun 2015 10:44:39 +0200
Message-ID: <20150626084438.GC26303@gmail.com>
References: <1435166600-11956-1-git-send-email-mcgrof@do-not-panic.com>
 <1435166600-11956-2-git-send-email-mcgrof@do-not-panic.com>
 <20150625064922.GA5339@gmail.com>
 <20150625171549.GG3005@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150625171549.GG3005@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, bp@suse.de, andy@silverblocksystems.net, mchehab@osg.samsung.com, dledford@redhat.com, fengguang.wu@intel.com, linux-media@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


* Luis R. Rodriguez <mcgrof@suse.com> wrote:

> On Thu, Jun 25, 2015 at 08:49:22AM +0200, Ingo Molnar wrote:
> > 
> > * Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> > 
> > > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > > 
> > > WARN() may confuse users, fix that. ipath_init_one() is part the
> > > device's probe so this would only be triggered if a corresponding
> > > device was found.
> > > 
> > > Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> > > ---
> > >  drivers/infiniband/hw/ipath/ipath_driver.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
> > > index 2d7e503..871dbe5 100644
> > > --- a/drivers/infiniband/hw/ipath/ipath_driver.c
> > > +++ b/drivers/infiniband/hw/ipath/ipath_driver.c
> > > @@ -31,6 +31,8 @@
> > >   * SOFTWARE.
> > >   */
> > >  
> > > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > > +
> > >  #include <linux/sched.h>
> > >  #include <linux/spinlock.h>
> > >  #include <linux/idr.h>
> > > @@ -399,8 +401,8 @@ static int ipath_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> > >  	u32 bar0 = 0, bar1 = 0;
> > >  
> > >  #ifdef CONFIG_X86_64
> > > -	if (WARN(pat_enabled(),
> > > -		 "ipath needs PAT disabled, boot with nopat kernel parameter\n")) {
> > > +	if (pat_enabled()) {
> > > +		pr_warn("ipath needs PAT disabled, boot with nopat kernel parameter\n");
> > >  		ret = -ENODEV;
> > >  		goto bail;
> > >  	}
> > 
> > So driver init will always fail with this on modern kernels.
> 
> Nope, I double checked this, ipath_init_one() is the PCI probe routine,
> not the module init call. It should probably be renamed.
> 
> > Btw., on a second thought, ipath uses MTRRs to enable WC:
> > 
> >         ret = ipath_enable_wc(dd);
> >         if (ret)
> >                 ret = 0;
> > 
> > Note how it ignores any failures - the driver still works even if WC was not 
> > enabled.
> 
> Ah, well WC strategy requires a split of the MMIO registers and the desired
> WC area, right now they are combined for some type of ipath devices. There
> are two things to consider when thinking about whether or not we want to
> do the work required to do the split:

But ... why doing the 'split'?

With my suggested approach the driver will behave in two ways:

  - if booted with 'nopat' it will behave as always and have the WC MTRR entries 
    added

  - if booted with a modern kernel without 'nopat' then instead of getting WC MTRR 
    entries it will not get them - we'll fall back to UC. No 'split' or any other 
    change is needed to the driver AFAICS: it might be slower, but it will still 
    be functional. It will _not_ get PAT WC mappings - it will fall back to UC - 
    which is still much better for any potential user than not working at all.

Same suggestion for the other affected driver.

what am I missing?

Thanks,

	Ingo
