From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 1/1] IB/ipoib: fix for rare multicast join race condition
Date: Fri, 12 Feb 2016 22:47:06 +0100
Message-ID: <CAJ3xEMh-F7HNZ73G9HojJOHww5GPo3VMDa9ffiFq3NXKUi69sQ@mail.gmail.com>
References: <20160211213051.29589.31877.stgit@phlsvlogin03.ph.intel.com>
	<CAJ3xEMgRxXx8kijLZK072oiN=_gYUXjqdUS=KtTKjk_BfKuXOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgRxXx8kijLZK072oiN=_gYUXjqdUS=KtTKjk_BfKuXOw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 12, 2016 at 10:45 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Feb 11, 2016 at 10:30 PM, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> Proposed patch should prevent multicast join task to continue
>> if link state change is detected.
>>
>> Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> Changes from v4:
>> - as suggested by Doug Ledford, optimized spinlock usage,
>> i.e. ipoib_mcast_join() is called with lock held.
>> Changes from v3:
>> - sync with priv->lock before flag check.
>> Chages from v2:
>> - Move check for OPER_UP flag state to mcast_join() to
>> ensure no event worker is in progress.
>> - minor style fixes.
>> Changes from v1:
>> - No need to lock again if error detected.
>> ---
>>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   24
>> +++++++++++++++++-------
>>  1 files changed, 17 insertions(+), 7 deletions(-)
>>
>
>

Alex, for next times... please put the Vx --> Vy history either in the cover
letter or in a case where this is single patch (as was here) after the ---
line, else we'll have this listing present in the upstream kernel git for
the rest of the human/linux history, since when the maintainer uses git am,
it goes in.
>
Doug, I see now in your github that this indeed went in, could you made a
small git rebase rewording and remove this review history?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
