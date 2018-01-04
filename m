From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH 00/28] IB/srp and IB/srpt patches
Date: Wed, 3 Jan 2018 20:15:05 -0700
Message-ID: <20180104031505.GP11348@ziepe.ca>
References: <20180103213938.11664-1-bart.vanassche@wdc.com>
 <20180103215130.GN11348@ziepe.ca>
 <1515017215.2582.50.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515017215.2582.50.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 03, 2018 at 10:06:56PM +0000, Bart Van Assche wrote:
> On Wed, 2018-01-03 at 14:51 -0700, Jason Gunthorpe wrote:
> > On Wed, Jan 03, 2018 at 01:39:10PM -0800, Bart Van Assche wrote:
> > > Hello Jason,
> > > 
> > > This patch series adds RDMA/CM support to the SRP initiator and target drivers
> > > and also includes a series of bug fixes for the SRPT driver. Please consider
> > > at least the SRPT bug fixes for kernel v4.16 since one of these fixes is a
> > > security fix.
> > 
> > Bart, this is really big for the rc6 timeframe.. This might make it if
> > there is a rc8 this cycle.
> > 
> > I'll grab the two patches marked for stable to for-rc, they look
> > trivial.
> > 
> > I'm with the DaveM school of thought here that patch series should be
> > 10-15 at most, and have a clear purpose, even if that purpose is just
> > 'assorted one patch fixes'.. If you resend it can you split the series?
> 
> Hello Jason,
> 
> How about splitting this series as follows:
> * Patches 1..4 with the SRP initiator changes.
> * Patches 5..6 with the SRPT bugfixes that have the "Cc: stable" tag.
> * Patches 7,8,11..19 with trival SRPT changes.
> * Patches 9,10,20..28 with the deeper SRPT changes.

Sounds fine to me. Can they rebase like that without conflicts?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
