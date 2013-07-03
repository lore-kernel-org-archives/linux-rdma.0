From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH v2 14/15] IB/srp: Make transport layer retry count
 configurable
Date: Wed, 03 Jul 2013 10:26:18 -0400
Message-ID: <1372861578.24238.5.camel@frustration.ornl.gov>
References: <51CD856A.3010102@acm.org> <51CD8876.9020307@acm.org>
	 <1372628891.12468.52.camel@haswell.thedillows.org>
	 <51D13B52.5060803@acm.org>
	 <1372677965.12468.57.camel@haswell.thedillows.org>
	 <20130702191842.GD14625@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130702191842.GD14625-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2013-07-02 at 13:18 -0600, Jason Gunthorpe wrote:
> On Mon, Jul 01, 2013 at 07:26:05AM -0400, David Dillow wrote:
> > You assume independent failures, which is suspect -- many times these
> > are data-dependent, or so I tend to think. Jason, do you have any
> > insight on this (overall) topic you could share?
> 
> All data transmitted on modern serial links is 'whitened'
> somehow. This is does independently on a link-by-link basis either
> with 8b/10b coding or with the 64b/66b scrambler. So the idea of a
> high level 'magic packet' that causes data-dependent errors is not
> statistically likely.

My thought was that if we hit a statistically unlikely pattern that
caused an issue, the retransmission is likely to also hit the issue
given the deterministic scrambling. But I didn't think about the fact
that the signal stream was being whitened.

> It is best to use all the information the SM provides when setting up
> the path, however I don't think there is a best practice idea yet for
> how to setup the retry count though..

Hmm, that would be a useful presentation for the workshop; I'll have to
see if I can get some people interested here.

Thanks for the information,
Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
