From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 4/5] ib/core: add support for extended performance
 counters in sysfs
Date: Tue, 1 Nov 2011 10:22:18 -0600
Message-ID: <20111101162218.GA10710@obsidianresearch.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com>
 <alpine.LRH.2.00.1110101055570.11243@ogerlitz.voltaire.com>
 <CAL1RGDXdkiZNtAsnqDtgbCJGLXLFvk8s-YA5mR189kmg6FkabQ@mail.gmail.com>
 <CAJZOPZ+K3u+u5XutGfBhKh3DaBpNRKV_bw67CLK6jy3060OHqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJZOPZ+K3u+u5XutGfBhKh3DaBpNRKV_bw67CLK6jy3060OHqA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 01, 2011 at 08:40:12AM +0200, Or Gerlitz wrote:

> Today, e.g in some IBoE perf monitoring scripts we wrote, the
> distinction is done by if (the ext counter directory exists) then go
> and read the counters from there, else read from the non extended
> counters directory. With the change you propose, that if (.) would
> become a little less elegant and would check if this or that --file--
> exists (e.g the 64 bit tx data counter) and if yes, would read the
> four 64 bit counters (rx/tx packets/data) else the four 32 bits
> counters, so from our user standpoint, diff dirs seems better, but we
> can get along with same dir with diff contents depending on the
> device.

Is there any reason to expose the 32 and 64 bit version of the same
counter? That seems needless. Emit the largest version available and
prepend 0's to fill out to the available width so that userspace can
know the counter size.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
