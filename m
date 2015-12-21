From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V1 1/3] IB/core: Align coding style of ib_device_cap_flags structure
Date: Mon, 21 Dec 2015 09:40:25 +0200
Message-ID: <CAJ3xEMjioX_fFZptJSLLC_yv1NszPwJET3zWj8+1x5fajXfBCQ@mail.gmail.com>
References: <1450606571-15877-1-git-send-email-leon@leon.nu>
	<1450606571-15877-2-git-send-email-leon@leon.nu>
	<20151221062252.GE3860@phlsvsds.ph.intel.com>
	<CALq1K=J2e=aw1QuJHGhFFcKkY391myz11r7tG-H+fYbQEyr+Gw@mail.gmail.com>
	<CAJ3xEMjcusZHb5PRT3ziv-sSYM70U+QtNbjhEYNhvL853Q57Qw@mail.gmail.com>
	<CALq1K=J-Zmb1zwh-ak+wYxo-xooGGYhCjiCOC_Z-4dYVGgkVsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALq1K=J-Zmb1zwh-ak+wYxo-xooGGYhCjiCOC_Z-4dYVGgkVsA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 21, 2015 at 9:27 AM, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org> wrote:
> On Mon, Dec 21, 2015 at 8:52 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Mon, Dec 21, 2015 at 8:37 AM, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org> wrote:
>>> On Mon, Dec 21, 2015 at 8:22 AM, ira.weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>>> On Sun, Dec 20, 2015 at 12:16:09PM +0200, Leon Romanovsky wrote:
>>>>> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>>>>> Modify enum ib_device_cap_flags such that other patches which add new
>>>>> enum values pass strict checkpatch.pl checks.
>>
>>>>> -     IB_DEVICE_RESERVED              = (1<<16), /* old SEND_W_INV */
>>>>> -     IB_DEVICE_MEM_WINDOW            = (1<<17),
>>>>> +     IB_DEVICE_RESIZE_MAX_WR         = (1 << 0),
>>
>>> 2. Change the whole file => the work with "git blame" will be less
>>> straightforward.
>>
>> Agree.
>>
>> Leon, I don't think we need to take checkpatch-ing of things to that level.
>>
>> Indeed, we should make sure that whole new enums and such are done right --
>> but avoid touching core structs/enums in a manner that disallows
>> simple git blaming of things, which is very useful for new comers and
>> old suffers.

> There are no doubts that standalone fixing checkpatch errors is more
> suitable to staging subsystem.

Agree

> In our case, it is part of coming changes in that structure. such
> change serves specific goal to minimize the possibility of error
> by seeing clean output from static analyser tool.

Disagree.

What future bugs are you envisioning by let this 10y old header file
keep having some checkpatch issues on few of the major enums?!

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
