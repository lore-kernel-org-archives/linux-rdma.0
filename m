From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 14/15] IB/srp: Make transport layer retry count
 configurable
Date: Tue, 2 Jul 2013 13:18:42 -0600
Message-ID: <20130702191842.GD14625@obsidianresearch.com>
References: <51CD856A.3010102@acm.org>
 <51CD8876.9020307@acm.org>
 <1372628891.12468.52.camel@haswell.thedillows.org>
 <51D13B52.5060803@acm.org>
 <1372677965.12468.57.camel@haswell.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1372677965.12468.57.camel-a7a0dvSY7KqLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 01, 2013 at 07:26:05AM -0400, David Dillow wrote:

> > The InfiniBand specification mentions the following about differential 
> > receiver inputs (C6-11.2.1): "A BER of 10^-12 shall be achieved when
> > connected to the worst case transmitter through any compliant channel".

This test condition is under 'stressed conditions' for the higher
rates, which doesn't directly translate into an error every 18
seconds under normal conditions.

A properly functioning IB link should not be seeing link errors with
any frequency (eg we expect/observe no errors on single links over
month long periods).

Naturally, a large number of IB links, will on aggregate, have error
rates significantly higher..

.. and this whole area is very challenging and installations with
defective cables/defective end points/non-compliance/etc are not
uncommon, so some sites see higher error rates. :(

However, IIRC, one large installation I know of, had the achieved
target of nearly no errors on any link during typical operation.

In a practical sense, IB just doesn't work with packet loss. You need
to have low error rate signalling or your network doesn't work/won't
perform.

> > The maximum packet size for an InfiniBand packet is about 4 KB (see also 
> > section 7.7.8 in the spec). This means that with an 8b/10b encoding the 
> > chance to lose a packet over a single link due to bit errors is about 
> > 4*10^-8. So the chance to lose a packet over a network consisting of n 
> > links with retry count r is about (n*4*10^-8)^r. With r=2 that results 
> > already in a really low value, even with multiple links. Since lowering 
> > the QP timeout might make congestion worse my preference is to lower the 
> > retry count.
> 
> You assume independent failures, which is suspect -- many times these
> are data-dependent, or so I tend to think. Jason, do you have any
> insight on this (overall) topic you could share?

All data transmitted on modern serial links is 'whitened'
somehow. This is does independently on a link-by-link basis either
with 8b/10b coding or with the 64b/66b scrambler. So the idea of a
high level 'magic packet' that causes data-dependent errors is not
statistically likely.

Errors in properly functioning modern serial links are pure-random,
from the perspective of SRP.

It is best to use all the information the SM provides when setting up
the path, however I don't think there is a best practice idea yet for
how to setup the retry count though..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
