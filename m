From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 4/5] ib/core: add support for extended performance
 counters in sysfs
Date: Tue, 20 Dec 2011 10:46:39 -0700
Message-ID: <20111220174639.GE25774@obsidianresearch.com>
References: <20111101162218.GA10710@obsidianresearch.com>
 <CAJZOPZLXZL=vEDdXE3rE5Jzw840SrdY=73M7QgKSNzOysRE6MQ@mail.gmail.com>
 <20111101173625.GH26974@obsidianresearch.com>
 <CAJZOPZJCY5ehTGw8htsxw0dJgMXJJAS-=LGJde9ddcMsmhqvMg@mail.gmail.com>
 <20111101183730.GI26974@obsidianresearch.com>
 <CAG4TOxMOPaTy+Y+M+4xuO_uQ-vqs+Z=GV172UJcqdMrA+mPv=w@mail.gmail.com>
 <4EB17AF9.3000608@mellanox.com>
 <CAG4TOxOYAnuB8oKkJgr9_6EpF+YR-h9WNak+gSWwpV0Nz-LeZg@mail.gmail.com>
 <20111108010952.GC4934@obsidianresearch.com>
 <4EF07993.2090900@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4EF07993.2090900-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 20, 2011 at 02:03:31PM +0200, Or Gerlitz wrote:

> >That is a good idea. Let's require counters_ext to be sane:
> >
> >  1 Hex quantity of unspecified size
> >  2 Prefixed with 0x and leading zeros to fill out to size and allow
> >    userspace discovery of size
> >  3 Size must be a multiple of 4 bits.
> >  4 Counters do not saturate
> >  5 Counters wrap around at all F's back to 0.
> >  6 If the counter is resettable it is only via a local operation
> >    through netlink or sysfs or something. Not PMA reset.
> >
> >Certainly, aside from some minor details and different string
> >formatting, the 64 bit counters Or proposes to add meet these
> >requirements when the port is used in Ethernet mode.
> 
> Jason, in an earlier post of yours you mentioned the netdev counters
> as something we should be following, well, I took a look - the
> counters are read-only (see /sys/class/net/$DEV/statistics/*) they
> are displayed in decimal/non-padded manner (see
> /sys/class/net/$DEV/statistics/* or /proc/net/dev or ifconfig and
> friends)

The netdev counters are all the same size and there is some other way
to discover what the size is. I'd like to see that for IB counters
too, but it is probably infeasible. So if we have counters that are
not the same size as netdev counters then some kind of size indicator
is required for sane userspace.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
