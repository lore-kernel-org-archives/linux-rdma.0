From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 4/5] ib/core: add support for extended performance
 counters in sysfs
Date: Mon, 7 Nov 2011 18:09:52 -0700
Message-ID: <20111108010952.GC4934@obsidianresearch.com>
References: <CAL1RGDXdkiZNtAsnqDtgbCJGLXLFvk8s-YA5mR189kmg6FkabQ@mail.gmail.com>
 <CAJZOPZ+K3u+u5XutGfBhKh3DaBpNRKV_bw67CLK6jy3060OHqA@mail.gmail.com>
 <20111101162218.GA10710@obsidianresearch.com>
 <CAJZOPZLXZL=vEDdXE3rE5Jzw840SrdY=73M7QgKSNzOysRE6MQ@mail.gmail.com>
 <20111101173625.GH26974@obsidianresearch.com>
 <CAJZOPZJCY5ehTGw8htsxw0dJgMXJJAS-=LGJde9ddcMsmhqvMg@mail.gmail.com>
 <20111101183730.GI26974@obsidianresearch.com>
 <CAG4TOxMOPaTy+Y+M+4xuO_uQ-vqs+Z=GV172UJcqdMrA+mPv=w@mail.gmail.com>
 <4EB17AF9.3000608@mellanox.com>
 <CAG4TOxOYAnuB8oKkJgr9_6EpF+YR-h9WNak+gSWwpV0Nz-LeZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG4TOxOYAnuB8oKkJgr9_6EpF+YR-h9WNak+gSWwpV0Nz-LeZg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 07, 2011 at 04:54:42PM -0800, Roland Dreier wrote:
> On Wed, Nov 2, 2011 at 10:16 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> > I suggest we go that least bad way along the lines of your comment.
> >
> > If/when on some future point something constructive can be formed from
> > Jason's observations, changes will follow, agree?
> 
> Let's make sure we learn from our mistakes.  Let's say we create a
> new "ext_counters" directory.  What should the format of those files
> be?  Should they be assumed to be 64-bit quantities?  Do we want to
> allow some way of indicating the number of bits (ie 0-padded hex
> entries?)?

That is a good idea. Let's require counters_ext to be sane:

 1 Hex quantity of unspecified size
 2 Prefixed with 0x and leading zeros to fill out to size and allow
   userspace discovery of size
 3 Size must be a multiple of 4 bits.
 4 Counters do not saturate
 5 Counters wrap around at all F's back to 0.
 6 If the counter is resettable it is only via a local operation
   through netlink or sysfs or something. Not PMA reset.

Certainly, aside from some minor details and different string
formatting, the 64 bit counters Or proposes to add meet these
requirements when the port is used in Ethernet mode.

How do you feel about having counters_ext appear in ethernet mode and
disappear in IB mode?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
