From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH V1 1/3] IB/core: Align coding style of ib_device_cap_flags structure
Date: Mon, 21 Dec 2015 08:37:26 +0200
Message-ID: <CALq1K=J2e=aw1QuJHGhFFcKkY391myz11r7tG-H+fYbQEyr+Gw@mail.gmail.com>
References: <1450606571-15877-1-git-send-email-leon@leon.nu>
 <1450606571-15877-2-git-send-email-leon@leon.nu> <20151221062252.GE3860@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151221062252.GE3860-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 21, 2015 at 8:22 AM, ira.weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Sun, Dec 20, 2015 at 12:16:09PM +0200, Leon Romanovsky wrote:
>> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Modify enum ib_device_cap_flags such that other patches which add new
>> enum values pass strict checkpatch.pl checks.
>>
....
>> -     IB_DEVICE_RESERVED              = (1<<16), /* old SEND_W_INV */
>> -     IB_DEVICE_MEM_WINDOW            = (1<<17),
>> +     IB_DEVICE_RESIZE_MAX_WR         = (1 << 0),
>
> NIT: Shouldn't we just use the BIT macro?
>
>         IB_DEVICE_RESIZE_MAX_WR         = BIT(0),
You are right and it is a preferred way for me too, however the
downside of such change will be one of two:
1. Change this structure only => we will have style mix of BITs and
shifts in the same file. IMHO it looks awful.
2. Change the whole file => the work with "git blame" will be less
straightforward.

I will do the change across whole file, If Doug accepts such change.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
