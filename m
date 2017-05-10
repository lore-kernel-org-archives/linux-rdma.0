From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core in Dabian
Date: Wed, 10 May 2017 10:58:29 -0600
Message-ID: <20170510165829.GA8288@obsidianresearch.com>
References: <20170507064349.GM22833@mtr-leonro.local>
 <1494351789.3752.5.camel@profitbricks.com>
 <20170509180517.GA9715@obsidianresearch.com>
 <1494408947.3739.2.camel@profitbricks.com>
 <20170510155005.GB1007@obsidianresearch.com>
 <20170510160201.GD1839@mtr-leonro.local>
 <20170510163341.GA25041@obsidianresearch.com>
 <004001d2c9ad$7a141f70$6e3c5e50$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <004001d2c9ad$7a141f70$6e3c5e50$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Benjamin Drung' <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, 'RDMA mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, 'Talat Batheesh' <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Noa Spanier' <noas-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 10, 2017 at 11:50:06AM -0500, Steve Wise wrote:
> > From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> > 
> > On Wed, May 10, 2017 at 07:02:01PM +0300, Leon Romanovsky wrote:
> > 
> > > > I've been thinking we should patch the kernel to solve this problem
> > > > instead of using this ugly userspace solution.
> > >
> > > Can it be related to the fact that mlx5 core calls to
> > > request_module_nowait for mlx5_ib and chelsio doesn't do it?
> > 
> > Yeah, maybe we should update chelsio kernel drivers instead of using
> > these strange modprobe files...
> > 
> > Steve?
> 
> Under what criteria would cxgb4 want to request its Upper Layer Drivers (ULDs)
> to be loaded?  You wouldn't want to load the iwarp and iscsi drivers if they
> aren't going to be used, would you?

Sounds like Mellanox is loading rocee drivers unconditionally, so why
not load iwarp ones too? People who really don't want that can opt out
with some modprobe configuration to block the modules.

iscsi should probably be demand loaded when userspace uses iscsi that
crosses a cxgb chip..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
