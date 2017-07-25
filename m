From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/3] iwpmd: Suppress expected kernel message
Date: Tue, 25 Jul 2017 15:21:17 -0600
Message-ID: <20170725212117.GC10905@obsidianresearch.com>
References: <1500935204-6505-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1500935204-6505-4-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170725133030.GR3259@mtr-leonro.local>
 <20170725153608.GA6715@obsidianresearch.com>
 <20170725181254.GS3259@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170725181254.GS3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 25, 2017 at 09:12:54PM +0300, Leon Romanovsky wrote:
> On Tue, Jul 25, 2017 at 09:36:08AM -0600, Jason Gunthorpe wrote:
> > On Tue, Jul 25, 2017 at 04:30:30PM +0300, Leon Romanovsky wrote:
> > > On Mon, Jul 24, 2017 at 04:26:44PM -0600, Jason Gunthorpe wrote:
> > > > RMDA_NL_RSVD was obsoleted a long time ago, but user space still
> > > > uses it to support old kernels. Avoid logging:
> > > >
> > > >  ib_core:ibnl_rcv_msg: Index 3 wasn't found in client list
> > > >
> > > > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > > >  drivers/infiniband/core/iwcm.c | 7 +++++++
> > > >  1 file changed, 7 insertions(+)
> > > >
> > >
> > > This print should be removed, on my system (Debian), it prints without
> > > any relation to iwpmd.
> >
> > Really? What from?
> 
> Yes, I constantly delayed the debug of it :)
> Debian 9 + latest rdma-core, see attached log.
> 
> ib_core:ibnl_rcv_msg: Index 3 wasn't found in client list

Index 3 should only used by iwpmd, are you sure it isn't running for
you? Otherwise have a larger problem as it has been removed from the
kernel on the assumption that only iwpmd touched and it was OK to
remove it.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
