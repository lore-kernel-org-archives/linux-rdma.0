From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH V1 1/3] IB/core: Align coding style of
 ib_device_cap_flags structure
Date: Mon, 21 Dec 2015 12:20:57 -0800
Message-ID: <20151221202057.GA6403@infradead.org>
References: <1450606571-15877-1-git-send-email-leon@leon.nu>
 <1450606571-15877-2-git-send-email-leon@leon.nu>
 <20151221062252.GE3860@phlsvsds.ph.intel.com>
 <CALq1K=J2e=aw1QuJHGhFFcKkY391myz11r7tG-H+fYbQEyr+Gw@mail.gmail.com>
 <20151221080346.GA21779@infradead.org>
 <20151221163603.GF3860@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151221163603.GF3860-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 21, 2015 at 11:36:03AM -0500, ira.weiny wrote:
> It would be nice if we were not having to do this for staging then.  Also
> perhaps it should be removed from checkpatch --strict?

Don't use checkpatch --strict ever.  It's full of weird items that
defintively don't apply to the majority of the kernel code base.

> Where are the guidelines for when one can ignore checkpatch and when they can
> not?  It would be nice to know when we can "be developers" vs "being robots to
> some tool".

I think checkpatch is generally useful, and the errors without
--strict are something we I haven't found any false positives.

The warnings are about 90% useful but something are just weird.  For
--strict all bets are off.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
