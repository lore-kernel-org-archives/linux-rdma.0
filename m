From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma_cm NULL deref in 4.11.0+
Date: Wed, 24 May 2017 13:19:00 -0600
Message-ID: <20170524191900.GA25200@obsidianresearch.com>
References: <acc72471-eb22-4474-04f5-db23227faadd@grimberg.me>
 <VI1PR0502MB30083E6CB505CA90A9E047C0D1FB0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170521154443.GD17751@mtr-leonro.local>
 <20170524163832.GA23034@obsidianresearch.com>
 <20170524185256.GT17751@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170524185256.GT17751-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 24, 2017 at 09:52:56PM +0300, Leon Romanovsky wrote:
> On Wed, May 24, 2017 at 10:38:32AM -0600, Jason Gunthorpe wrote:
> > On Sun, May 21, 2017 at 06:44:43PM +0300, Leon Romanovsky wrote:
> > > On Sun, May 21, 2017 at 02:30:04PM +0000, Parav Pandit wrote:
> > > > Hi Sagi,
> > > >
> > > > Majd encountered same sometime back and reported [1].
> > > > He has the fix should be posting the fix soon.
> > > >
> > > > Majd/Leon?
> > >
> > > The fix is in our rdma-rc branch.
> > > https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=rdma-rc&id=f1fff656d55c52aeb12129f57347886b02f90e1d
> > >
> > > I planned to submit it today.
> >
> > Is someone going to look at the segfault in librdmacm?
> 
> Does it reproduce with these two patches?

I don't think librdmacm should segfault even if the kernel is
malfunctioning, should it?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
