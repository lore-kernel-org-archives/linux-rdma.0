From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 4/5] ib/core: add support for extended performance
 counters in sysfs
Date: Tue, 1 Nov 2011 12:37:30 -0600
Message-ID: <20111101183730.GI26974@obsidianresearch.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com>
 <alpine.LRH.2.00.1110101055570.11243@ogerlitz.voltaire.com>
 <CAL1RGDXdkiZNtAsnqDtgbCJGLXLFvk8s-YA5mR189kmg6FkabQ@mail.gmail.com>
 <CAJZOPZ+K3u+u5XutGfBhKh3DaBpNRKV_bw67CLK6jy3060OHqA@mail.gmail.com>
 <20111101162218.GA10710@obsidianresearch.com>
 <CAJZOPZLXZL=vEDdXE3rE5Jzw840SrdY=73M7QgKSNzOysRE6MQ@mail.gmail.com>
 <20111101173625.GH26974@obsidianresearch.com>
 <CAJZOPZJCY5ehTGw8htsxw0dJgMXJJAS-=LGJde9ddcMsmhqvMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJZOPZJCY5ehTGw8htsxw0dJgMXJJAS-=LGJde9ddcMsmhqvMg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > I don't see a problem with having a sysfs counter file being extended
> > to return a 64 bit number.. I think that is within the purvue of
> > acceptable changes. Shame the counter wasn't exported as hex though -
> > makes it harder to signal if it is 32 or 64 bit.
> 
> if I understand you right, we would have traffic counters exposed
> through sysfs, where a counter is either a 32 zero-padded/embedded in
> 64bit one or true 64 bit one, a problem is that the four 32bit traffic
> counters (rx/tx data/packets) are actually part of the IB port L2
> basic counter set which includes about ten more counters to mark
> different kinds of errors, wheres the 64bit counters are only traffic
> counters, so what do you suggest for them? use the same approach for
> the error counters as well even though IB doesn't define 64 bit
> version for them? also zero padding for something which isn't exported
> in hex is very ugly, isn't that?

Whats the problem here? If a 64 bit counter is available then export
it as 64 bit otherwise keep exporting something smaller.

I agree zero padding non-hex numbers isn't ideal. Export as hex?

Broadly, this is another problem with the sysfs interface because the
width matters for any kind of serious data collection, and IBA defined
interesting widths for many of the counters that was flowed right
through the sysfs interface, with no means of discovery.

> > Frankly, exporting these PMA counters as saturate on maximum via sysfs
> > is pretty useless. Does anyone actually use them aside from a few scripts?
> 
> under IB our monitorying code/scripts use perfquery/mads wheres under
> IBoE we use sysfs, the mad approach allows to reset the counters, so
> the 32 bit counters aren't useless, reset via sysfs isn't supported so
> the 64 bit counter are kind of must, anyway,

I don't mean the 32 bit counters are useless, I mean exposing PMA
counters that saturate and can be randomly reset by external agents
through sysfs is useless. You can't make any kind of data collection
based on such a system.

Ideally the sysfs counters are all non-saturating, non-resetting
counters like everything else in the net stack. You need a different
interface to the chip firmware to implement this, can't use the
existing PMA stuff.

In the same vien adding saturating but non-resettable PMA-esque
counters for IBoE seems pretty hackish to me.. Though I agree it is
not terribly relevant for 64 bit counters.

> > What would be useful is free running 64 bit sysfs counters that
> > are independent and not reset by PMA activity. Like all the other
> > Linux networking counters. That would be great. I hope that is
> > what is done for IBoE?
> 
> yes this is what the 64 bit counters are

IBA defined 64 bit counters are not free-running, they still
saturate. Does the firmware not do this in IBoE mode?

> > Unifying the counters to be semantically the same on IB and IBoE seems
> > like a very good idea.

> yes, this is what we do here

I disagree. Your IBoE counters cannot be reset, externally or
otherwise - aside from the saturating this makes them almost the same
as the usual Linux net counters. When the port is in IB mode the
counter doesn't have those properties.

That is a big semantic difference when compared to what these sysfs
files show for normal IB counters.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
