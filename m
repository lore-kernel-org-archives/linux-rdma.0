From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] x86/mm/pat, drivers/media/ivtv: move pat warn and
 replace WARN() with pr_warn()
Date: Fri, 26 Jun 2015 10:45:46 +0200
Message-ID: <20150626084546.GD26303@gmail.com>
References: <1435166600-11956-1-git-send-email-mcgrof@do-not-panic.com>
 <1435166600-11956-3-git-send-email-mcgrof@do-not-panic.com>
 <20150625065147.GB5339@gmail.com>
 <20150625173847.GH3005@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150625173847.GH3005-B4tOwbsTzaBolqkO4TVVkw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
Cc: Hyong-Youb Kim <hkim-Z0sFnEBmPCA@public.gmane.org>, Andy Walls <awalls-Xoej9cPu4Z+RGvkDC/A1pg@public.gmane.org>, benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org, "Luis R. Rodriguez" <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>, bp-l3A5Bk7waGM@public.gmane.org, andy-JCKMKWeByS3xr+NhZqW+5SMd26UNKDXL@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


* Luis R. Rodriguez <mcgrof-IBi9RG/b67k@public.gmane.org> wrote:

> On Thu, Jun 25, 2015 at 08:51:47AM +0200, Ingo Molnar wrote:
> > 
> > * Luis R. Rodriguez <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org> wrote:
> > 
> > > From: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
> > > 
> > > On built-in kernels this warning will always splat as this is part
> > > of the module init. Fix that by shifting the PAT requirement check
> > > out under the code that does the "quasi-probe" for the device. This
> > > device driver relies on an existing driver to find its own devices,
> > > it looks for that device driver and its own found devices, then
> > > uses driver_for_each_device() to try to see if it can probe each of
> > > those devices as a frambuffer device with ivtvfb_init_card(). We
> > > tuck the PAT requiremenet check then on the ivtvfb_init_card()
> > > call making the check at least require an ivtv device present
> > > before complaining.
> > > 
> > > Reported-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> [0-day test robot]
> > > Signed-off-by: Luis R. Rodriguez <mcgrof-IBi9RG/b67k@public.gmane.org>
> > > ---
> > >  drivers/media/pci/ivtv/ivtvfb.c | 15 +++++++++------
> > >  1 file changed, 9 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
> > > index 4cb365d..8b95eef 100644
> > > --- a/drivers/media/pci/ivtv/ivtvfb.c
> > > +++ b/drivers/media/pci/ivtv/ivtvfb.c
> > > @@ -38,6 +38,8 @@
> > >      Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> > >   */
> > >  
> > > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > > +
> > >  #include <linux/module.h>
> > >  #include <linux/kernel.h>
> > >  #include <linux/fb.h>
> > > @@ -1171,6 +1173,13 @@ static int ivtvfb_init_card(struct ivtv *itv)
> > >  {
> > >  	int rc;
> > >  
> > > +#ifdef CONFIG_X86_64
> > > +	if (pat_enabled()) {
> > > +		pr_warn("ivtvfb needs PAT disabled, boot with nopat kernel parameter\n");
> > > +		return -ENODEV;
> > > +	}
> > > +#endif
> > > +
> > >  	if (itv->osd_info) {
> > >  		IVTVFB_ERR("Card %d already initialised\n", ivtvfb_card_id);
> > >  		return -EBUSY;
> > 
> > Same argument as for ipath: why not make arch_phys_wc_add() fail on PAT and 
> > return -1, and check it in arch_phys_wc_del()?
> 
> The arch_phys_wc_add() is a no-op for PAT systems but for PAT to work we need 
> not only need to add this in where we replace the MTRR call but we also need to 
> convert ioremap_nocache() calls to ioremap_wc() but only if things were split up 
> already.

We don't need to do that: for such legacy drivers we can fall back to UC just 
fine, and inform the user that by booting with 'nopat' the old behavior will be 
back...

Thanks,

	Ingo
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
