From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 libibverbs 1/8] Add ibv_poll_cq_ex verb
Date: Tue, 1 Mar 2016 10:24:48 -0700
Message-ID: <20160301172448.GA24031@obsidianresearch.com>
References: <1456306924-31298-1-git-send-email-yishaih@mellanox.com>
 <1456306924-31298-2-git-send-email-yishaih@mellanox.com>
 <20160224190230.GA10588@obsidianresearch.com>
 <56CEB4C7.60607@dev.mellanox.co.il>
 <20160225170541.GA22513@obsidianresearch.com>
 <56D31A58.20205@mellanox.com>
 <20160229191734.GA15042@obsidianresearch.com>
 <56D55851.60206@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56D55851.60206-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Matan Barak (External)" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 01, 2016 at 10:52:33AM +0200, Matan Barak (External) wrote:
> >By my count it scores about a 2 on the Rusty API scale, which is
> >pretty bad.
> 
> This is like writing something that means nothing....

If you don't agree with the points on the Rusty scale as what
constitutes good API design then we really have no common ground on
this point at all.

> >This series trade cache line efficiency for computation efficiency,
> >and it isn't at all clear to me that is going to be a win. Better
> >include some good benchmarks.
> >
> 
> WRONG. Which computational overhead are you talking about?

I don't see the driver side posted, but obviously there must be
indexing maths and possibly branching, depending on the design, that
is overhead.

> The user-space driver writes one completion at a time, which (depending on
> the user configuration) is probably less than a cache line. Why do you think
> it's worse than how ibv_poll_cq behaves? The way the user-space driver
> optimizes/dirties the cache line is unrelated to the API.

I didn't say it was worse, I questioned that this should be the
overarching goal when no data to support this has been posted and it
doesn't even make inutitive sense that worrying about the size of
*dirty cache lines* is even very important, (well, within limits).

Christoph may have some data, but I do wonder if his results are
polluted by the current ibv_poll_cq driver implementations which do
trigger RMW overheads.

> Function per every completion fields permutation is uglier for sure (there
> are currently 9 optional completion fields in this proposal, you could
> easily do the math to calculate how many permutations we have).

Why would you do every permutation?

Try a non-memcpy API design. Provide an opaque 'cursor' and functions
to return certain data. This has more unconditional branches, but may
avoid branching within the driver and certainly avoid memcpy's and
pretty much all cache line dirtying. Sean had some results that
were positive on this sort of direction.

Justify this horrible API is *necessary* with something concrete, just
not random hand waving and mumbling about cache lines. That means
benchmark several options.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
