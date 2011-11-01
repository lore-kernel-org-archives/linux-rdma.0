From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 4/5] ib/core: add support for extended performance
 counters in sysfs
Date: Tue, 1 Nov 2011 15:58:43 -0600
Message-ID: <20111101215843.GO26974@obsidianresearch.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com>
 <alpine.LRH.2.00.1110101055570.11243@ogerlitz.voltaire.com>
 <CAL1RGDXdkiZNtAsnqDtgbCJGLXLFvk8s-YA5mR189kmg6FkabQ@mail.gmail.com>
 <CAJZOPZ+K3u+u5XutGfBhKh3DaBpNRKV_bw67CLK6jy3060OHqA@mail.gmail.com>
 <20111101162218.GA10710@obsidianresearch.com>
 <CAJZOPZLXZL=vEDdXE3rE5Jzw840SrdY=73M7QgKSNzOysRE6MQ@mail.gmail.com>
 <20111101173625.GH26974@obsidianresearch.com>
 <CAJZOPZJCY5ehTGw8htsxw0dJgMXJJAS-=LGJde9ddcMsmhqvMg@mail.gmail.com>
 <20111101183730.GI26974@obsidianresearch.com>
 <CAJZOPZ+zmwTdHva5C7k0QhBmEzxSGTa1Ajszz3eSH=WpP3A4fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJZOPZ+zmwTdHva5C7k0QhBmEzxSGTa1Ajszz3eSH=WpP3A4fg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 01, 2011 at 11:46:08PM +0200, Or Gerlitz wrote:

> > In the same vien adding saturating but non-resettable PMA-esque
> > counters for IBoE seems pretty hackish to me.. Though I agree it is
> > not terribly relevant for 64 bit counters.
 
> To put things in place, the IB stack PMA counters aren't resettable
> through sysfs, still, under IB, the same counter set is readable
> through both mads and sysfs and resettable through mads.

Right, the sysfs interface is pretty much unusable for IB. Your work
to make it go on IBoE makes something is very nearly usuable, but you
can't write a tool that collects these counters from a port in IBoE
mode and also expect it to work in IB mode because the semantics are
different.

My argument here is that the semantics we have for the IB case are not
useful. Let us define sane semantics for the IBoE case and have a
longer term clean up to make the IB case follow them as well.

Sane semantics for a sysfs counter are:
  - Free-running
  - Non-saturating
  - No reset
  - 64 or 32 bit value, detectable by user-space

No 6 bit counters. No counters that saturate. No counters that
randomly reset.

To this end, I think exporting 64 bit and 32 bit counts of the same
value is not the way to go.

> As for the saturation thing, I didn't think about that, but you're
> probably right and all the IBA PMA counters are saturating, but as
> your comment said, the 64 bit case is practically okay

Will any counters that get exposed when IBoE is turned on not be 64
bits? There are not very many 64 bit PMA counters.

If yes, maybe you should patch to un-export them until things can be
fixed sanely...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
