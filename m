From: Wolfram Sang <w.sang-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Subject: Re: [PATCH 2/6] idr: remove MAX_IDR_MASK and move left MAX_IDR_*
 into idr.c
Date: Sun, 10 Feb 2013 12:52:14 +0100
Message-ID: <20130210115214.GC5472@nekote.pengutronix.de>
References: <20130208210050.GA26660@mtj.dyndns.org>
 <20130208210149.GB26660@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-i2c-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130208210149.GB26660-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: linux-i2c-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Jean Delvare <khali-PUYAD+kWke1g9hUCZPvPmw@public.gmane.org>, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 08, 2013 at 01:01:49PM -0800, Tejun Heo wrote:
> MAX_IDR_MASK is another weirdness in the idr interface.  As idr covers
> whole positive integer range, it's defined as 0x7fffffff or INT_MAX.
> 
> Its usage in idr_find(), idr_replace() and idr_remove() is bizarre.
> They basically mask off the sign bit and operate on the rest, so if
> the caller, by accident, passes in a negative number, the sign bit
> will be masked off and the remaining part will be used as if that was
> the input, which is worse than crashing.
> 
> The constant is visible in idr.h and there are several users in the
> kernel.
> 
> * drivers/i2c/i2c-core.c:i2c_add_numbered_adapter()
> 
>   Basically used to test if adap->nr is a negative number which isn't
>   -1 and returns -EINVAL if so.  idr_alloc() already has negative
>   @start checking (w/ WARN_ON_ONCE), so this can go away.
> 
> * drivers/infiniband/core/cm.c:cm_alloc_id()
>   drivers/infiniband/hw/mlx4/cm.c:id_map_alloc()
> 
>   Used to wrap cyclic @start.  Can be replaced with max(next, 0).
>   Note that this type of cyclic allocation using idr is buggy.  These
>   are prone to spurious -ENOSPC failure after the first wraparound.
> 
> * fs/super.c:get_anon_bdev()
> 
>   The ID allocated from ida is masked off before being tested whether
>   it's inside valid range.  ida allocated ID can never be a negative
>   number and the masking is unnecessary.
> 
> Update idr_*() functions to fail with -EINVAL when negative @id is
> specified and update other MAX_IDR_MASK users as described above.
> 
> This leaves MAX_IDR_MASK without any user, remove it and relocate
> other MAX_IDR_* constants to lib/idr.c.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

For the i2c-part:

Acked-by: Wolfram Sang <wolfram-z923LK4zBo2bacvFa/9K2g@public.gmane.org>
