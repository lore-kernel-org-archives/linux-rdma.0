From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 6/6] RDMA/core: Unify style of IOCTL commands
Date: Thu, 1 Sep 2016 11:07:42 -0600
Message-ID: <20160901170742.GA20098@obsidianresearch.com>
References: <1471987907-6336-1-git-send-email-leon@kernel.org>
 <1471987907-6336-7-git-send-email-leon@kernel.org>
 <1472738739.16467.8.camel@intel.com>
 <20160901164624.GC6479@obsidianresearch.com>
 <20160901165552.GE21847@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160901165552.GE21847-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 01, 2016 at 07:55:52PM +0300, Leon Romanovsky wrote:
> On Thu, Sep 01, 2016 at 10:46:24AM -0600, Jason Gunthorpe wrote:
> > On Thu, Sep 01, 2016 at 02:05:44PM +0000, Dalessandro, Dennis wrote:
> >
> > > > +/* allocate HFI and context */
> > > > +#define HFI1_CMD_ASSIGN_CTXT??????????(HFI1_CMD_BASE + 0x01)
> > >
> > > This is a minor issue, but the problem here is when we build PSM
> > > against this kernel it will no longer work for older kernels because
> > > the value of HFI1_CMD_ASSIGN_CTXT has changed where as it used to be 1.
> > > Right now PSM is backwards compatible, this breaks that compatibility.
> >
> > What? Someone renumberd an ioctl? When? Why? How?
> >
> > Was this ioctl ever in a mainline non-staging kernel? If not, too bad,
> > deal with it in your user space..
> >
> > If yes, can we revert the renumbering? Why was that even done??
> >
> > > So while no one uses the __NUM() macro directly it lets us not change
> > > the PSM command values. Can we put that part back and keep the command
> > > values unchanged?
> >
> > Please no, do not do crazy subtle things like this. If the ioctl has
> > two valid numbers then you need two entries in the ioctl file.
> 
> I didn't renumbered ioctls, but renumbered one of the internals number
> which is not used in kernel, but for any reasons used in their
> user-space.

If it is not used in the kernel why is it in this header?

Ah, I see, this was part of the staging clean up, this is part of the
old non-ioctl UAPI that got trashed ??

> ???  linux-rdma git:(master) grep -r HFI1_CMD_ASSIGN_CTXT drivers/infiniband/hw/hfi1/* include/*
> include/uapi/rdma/hfi/hfi1_user.h:#define HFI1_CMD_ASSIGN_CTXT     1 /* allocate HFI and context */
> 
> So what should I do? respin or not?

Drop the cruft. These header file definitions should have been deleted
when the API was dropped during the staging review.

We do not promise anything for drivers during their time in staging,
and we do not support ABIs that only existed during staging.

Dennis should use an internal definition in PSM if he wishes to
continue to support the staging kernel ABI.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
