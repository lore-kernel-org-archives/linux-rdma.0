From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 4/5] ib/core: add support for extended performance
 counters in sysfs
Date: Tue, 1 Nov 2011 11:36:25 -0600
Message-ID: <20111101173625.GH26974@obsidianresearch.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com>
 <alpine.LRH.2.00.1110101055570.11243@ogerlitz.voltaire.com>
 <CAL1RGDXdkiZNtAsnqDtgbCJGLXLFvk8s-YA5mR189kmg6FkabQ@mail.gmail.com>
 <CAJZOPZ+K3u+u5XutGfBhKh3DaBpNRKV_bw67CLK6jy3060OHqA@mail.gmail.com>
 <20111101162218.GA10710@obsidianresearch.com>
 <CAJZOPZLXZL=vEDdXE3rE5Jzw840SrdY=73M7QgKSNzOysRE6MQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJZOPZLXZL=vEDdXE3rE5Jzw840SrdY=73M7QgKSNzOysRE6MQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 01, 2011 at 07:23:52PM +0200, Or Gerlitz wrote:
> Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > Is there any reason to expose the 32 and 64 bit version of the same
> > counter? That seems needless. Emit the largest version available and
> > prepend 0's to fill out to the available width so that userspace can
> > know the counter size.
> 
> Basically, the approach you suggest seems fine for IBoE which is
> pretty new, however,
> 
> the problem is that the 32 bit counters exists from kind of day one
> AND have the same semantics either if returned through sysfs or
> through perfquery and alike mad based apps.
> In other words around IB there should be some legacy which exists
> today, and I don't think it would be wise to touch that area such that
> the 32 bit counters become embedded in 64 bit numbers, thoughts?

I don't see a problem with having a sysfs counter file being extended
to return a 64 bit number.. I think that is within the purvue of
acceptable changes. Shame the counter wasn't exported as hex though -
makes it harder to signal if it is 32 or 64 bit.

Frankly, exporting these PMA counters as saturate on maximum via sysfs
is pretty useless. Does anyone actually use them aside from a few
scripts? 

What would be useful is free running 64 bit sysfs counters that are
independent and not reset by PMA activity. Like all the other Linux
networking counters. That would be great. I hope that is what is done
for IBoE?

Unifying the counters to be semantically the same on IB and IBoE seems
like a very good idea.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
