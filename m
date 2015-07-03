From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: Deprecating ipath
Date: Fri, 3 Jul 2015 08:36:46 -0700
Message-ID: <20150703153646.GA11227@kroah.com>
References: <32E1700B9017364D9B60AED9960492BC257567C3@fmsmsx120.amr.corp.intel.com>
 <CAB=NE6WTPKUF3EUVk6Z91pd+PYTjLdrLHr0Gn=n9+Z98cVdPWg@mail.gmail.com>
 <20150626165401.GA14699@kroah.com>
 <D2F193D21ECD8C45917AD3D5B26513300C48DAD5@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <D2F193D21ECD8C45917AD3D5B26513300C48DAD5-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 03, 2015 at 01:25:25PM +0000, Dalessandro, Dennis wrote:
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Greg Kroah-Hartman
> > Sent: Friday, June 26, 2015 12:54 PM
> > To: Luis R. Rodriguez
> > Cc: Marciniszyn, Mike; Borislav Petkov; Ingo Molnar; One Thousand Gnomes;
> > Doug Ledford; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: Deprecating ipath
> > 
> > On Fri, Jun 26, 2015 at 09:23:27AM -0700, Luis R. Rodriguez wrote:
> > > On Fri, Jun 26, 2015 at 9:17 AM, Marciniszyn, Mike
> > > <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > > > Doug,
> > > >
> > > > We have been given the go ahead to start the deprecation process for
> > thie ipath driver.
> > >
> > > That's great! Do you mean removal from Linux?
> > >
> > > > What do I need to do to get that done?
> > >
> > > Feature removal txt file was removed from the kernel so there is no
> > > "schedule" per se, not sure what the process these days is for driver
> > > removal. How about punting it to staging for a release or two and then
> > > remove it? Not sure if that would be frowned upon or welcomed.
> > 
> > That is the process for driver removal, so of course it is welcomed :)
> > 
> > > That would have the cost of moving history through directories but git
> > > --follow helps with that these days. The gain of moving it to staging
> > > IMHO would be that if anyone who might care would need to complain
> > may
> > > do so for a directory change for 1-2 release may spot this easily and
> > > the issues would be much less than an immediate removal.
> > 
> > Yes, that's why we do it this way.
> > 
> > Mike, feel free to send me a patch for this if you want me to queue it up for
> > 4.3.  For 4.2 it's too late.
> > 
> > thanks,
> > 
> > greg k-h
> > --
> 
> Greg, how would you like to consume that patch? There are a number of large
> files. We can break things up into a series and send through email. We could
> also post a repo somewhere that you can do a pull from. Something else?

If you use -M to 'git format-patch' when generating a patch, it will
show that you just moved the files around the directory tree, and the
patch should be quite small and easy to email and review.

In fact, you should use that as a default for all patches, as it's now a
standard that normal patch can use to consume, I have this in my
.gitalias file:
	[alias]
		fp = format-patch -M

and just use 'git fp' all the time.

try that and see what the results are.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
