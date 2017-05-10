From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core in Dabian
Date: Wed, 10 May 2017 09:50:05 -0600
Message-ID: <20170510155005.GB1007@obsidianresearch.com>
References: <20170507064349.GM22833@mtr-leonro.local>
 <1494351789.3752.5.camel@profitbricks.com>
 <20170509180517.GA9715@obsidianresearch.com>
 <1494408947.3739.2.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1494408947.3739.2.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Spanier <noas-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 10, 2017 at 11:35:47AM +0200, Benjamin Drung wrote:
> Am Dienstag, den 09.05.2017, 12:05 -0600 schrieb Jason Gunthorpe:
> > On Tue, May 09, 2017 at 07:43:09PM +0200, Benjamin Drung wrote:
> > 
> > > * Can we upstream some redhat files, i.e. move them out of the
> > > redhat
> > > directory and maintain them in their corresponding code? Following
> > > files fall in this category:
> > 
> > Anything in the redhat directory could be moved out if it is going to
> > be used by another distro. It is there waiting for other distros to
> > look at it.
> 
> * The ifdown-ib and ifup-ib scripts are redhat-specific. It won't work
> with ifupdown from Debian.
> 
> * The files related to mlx4 look like a special handling for mlx4 to me
> and they do not following the KISS principle.

One part is managing the need to setup multi-protocol ports on
boot. This seems like a general requirement for mlx4/5 so maybe it
should get some more common solution..

> * What's the purpose of the cxgb{3,4} modprobe files?

cxgb is a multi-kernel module driver, those scripts are an attempt to
load the other parts when the main driver is loaded. I'm not sure why
cxgb is special enough to get these files but mlx/etc are not.

I suspect it is old cruft because redhat/rdma.kernel-init handles
things uniformly on systemd environments.

I've been thinking we should patch the kernel to solve this problem
instead of using this ugly userspace solution..

> Jarod already created a rdma-core package in debian/control in commit
> 8df5873b9. Currently we do not have a rdma-core package in Debian and
> no package with a kernel-boot service file. I know that the openibd and
>  mlnx-ofed-kernel-utils packages shipped a openibd service that does
> similar job.

Yes, pulling something like openibd into rdma-core is the idea here..

> Do we want to call the binary package that contains the kernel-boot
> service 'rdma-core' or simplify that to 'rdma'? We should use the same
> binary package name across the distributions (unless it's conflicting
> with a naming convention).

I think rdma-core is fine..

> Can you come up with a patch set? I will be happy to review it. Note
> that paths like /usr/libexec/rdma-init-kernel (in rdma.service) needs
> to be made configurable. In Debian, we would install these helper
> scripts in /usr/lib/$packagename/$filename.

Maybe Leon's team will try to tackle some of this? It is complicated,
the RH scripts do quite a bit stuff :\

But this doesn't seem particularly urgent for Debian packaging, right?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
