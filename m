From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 FIX for-3.19] IB/ipoib: Fix broken multicast flow
Date: Fri, 23 Jan 2015 09:07:16 +0200
Message-ID: <CAJ3xEMhX9VWobHhUmW_=kumTNL6TWG6L+RrCtT2Zd=mjg-BOew@mail.gmail.com>
References: <1421933479-18214-1-git-send-email-ogerlitz@mellanox.com>
	<1421959236.3352.233.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421959236.3352.233.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 22, 2015 at 10:40 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 2015-01-22 at 15:31 +0200, Or Gerlitz wrote:
>> Changes from V1:
>> 1. always do clear_bit(IPOIB_MCAST_FLAG_BUSY) inipoib_mcast_sendonly_join_complete()

> This part is good.

good to know...

>> 2. Sync between ipoib_mcast_sendonly_join() to ipoib_mcast_sendonly_join_complete
>> using a IS_ERR_OR_NULL() test

> This part is no good.  You just added a kernel data corrupter or kernel
> oopser depending on the situation.

Yep, you probably have a point here, but didn't that exist prior to
your 3.19-rc1 series too? in other words, if bug X was there before
and you added bug Y and we fix Y that's fine and by the rules.

> These items make a passable effort at fixing up the same items as
> patches 1 and 2 in my patchset.  Patch 3 in my patchset was just
> something I noticed, but it isn't drastically important.

> This alternative patch does nothing to address what is fixed in these
> patches though:

The below list is too heavy for rc6 fixes


> patch 4: we leaked joins as a result of handling ENETRESET wrong.  you
> wouldn't see this unless your testing included taking the network up and
> down via killing opensm or the like, but it's a real issue
>
> patch 5: over zealous rescheduling of join task that got in the way of
> the flush thread
>
> patch 6: took out an unneeded spinlock
>
> patch 7: during my testing, I got an oops in ipoib_mcast_join that is
> the result of lack of locking between the flush task and the
> mcast_join_task thread
>
> patch 8: there is a legitimate leak of mcast entries any time we process
> this list and get to the end only to find that our device is no longer
> up, and given that the debug messages show that we call
> mcast_restart_task every time right before we call mcast_dev_flush when
> we are downing the interface, the chance of leak here is very high
>
> patch 9: similar to patch 4, you don't see this unless you are abusing
> opensm in order to trigger net events, and then combining that with
> removing the module at the same time.  but if you have a queue net event
> and you don't flush after you unregister, it can oops your kernel later
> when the net event finally runs
>
> patch 10: if you have mcast debugging on, that printk can actually cause
> problems that don't otherwise exist because it isn't rate limited in any
> way
>
> This interim patch you are suggesting addresses the first couple items
> my patches address, but it also introduces data corrupter/oopser, but
> also like I said in a previous email, your testing is myopic, just like
> my original testing was, and you are ignoring other items and thinking
> your patch is OK when it really isn't.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
