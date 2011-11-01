From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/5] ib/core: add support for extended performance
 counters in sysfs
Date: Tue, 1 Nov 2011 20:14:30 +0200
Message-ID: <CAJZOPZJCY5ehTGw8htsxw0dJgMXJJAS-=LGJde9ddcMsmhqvMg@mail.gmail.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com>
	<alpine.LRH.2.00.1110101055570.11243@ogerlitz.voltaire.com>
	<CAL1RGDXdkiZNtAsnqDtgbCJGLXLFvk8s-YA5mR189kmg6FkabQ@mail.gmail.com>
	<CAJZOPZ+K3u+u5XutGfBhKh3DaBpNRKV_bw67CLK6jy3060OHqA@mail.gmail.com>
	<20111101162218.GA10710@obsidianresearch.com>
	<CAJZOPZLXZL=vEDdXE3rE5Jzw840SrdY=73M7QgKSNzOysRE6MQ@mail.gmail.com>
	<20111101173625.GH26974@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111101173625.GH26974-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

Guys (Roland, Jason), I'm open to any comments, any time, for any
patch, but for a patch which was posted weeks ago it's pretty unfair
to have your comments coming only eight days after the merge window
has been opened, lets try to come quickly to decision so I can fix
this up along those lines,

> I don't see a problem with having a sysfs counter file being extended
> to return a 64 bit number.. I think that is within the purvue of
> acceptable changes. Shame the counter wasn't exported as hex though -
> makes it harder to signal if it is 32 or 64 bit.

if I understand you right, we would have traffic counters exposed
through sysfs, where a counter is either a 32 zero-padded/embedded in
64bit one or true 64 bit one, a problem is that the four 32bit traffic
counters (rx/tx data/packets) are actually part of the IB port L2
basic counter set which includes about ten more counters to mark
different kinds of errors, wheres the 64bit counters are only traffic
counters, so what do you suggest for them? use the same approach for
the error counters as well even though IB doesn't define 64 bit
version for them? also zero padding for something which isn't exported
in hex is very ugly, isn't that?

> Frankly, exporting these PMA counters as saturate on maximum via sysfs
> is pretty useless. Does anyone actually use them aside from a few scripts?

under IB our monitorying code/scripts use perfquery/mads wheres under
IBoE we use sysfs, the mad approach allows to reset the counters, so
the 32 bit counters aren't useless, reset via sysfs isn't supported so
the 64 bit counter are kind of must, anyway,

> What would be useful is free running 64 bit sysfs counters that are
> independent and not reset by PMA activity. Like all the other Linux
> networking counters. That would be great. I hope that is what is done for IBoE?

yes this is what the 64 bit counters are

> Unifying the counters to be semantically the same on IB and IBoE seems
> like a very good idea.

yes, this is what we do here
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
