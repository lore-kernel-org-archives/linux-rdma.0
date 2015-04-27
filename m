From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 for-next 01/33] IB/core: Add RoCE GID cache
Date: Mon, 27 Apr 2015 21:22:11 +0300
Message-ID: <CAJ3xEMjEhv3Nm_EfFcBWLk1ChQXBM5KvPxh5DstCqxeMo0MGwA@mail.gmail.com>
References: <1427318422-12004-1-git-send-email-somnath.kotur@emulex.com>
	<44ab0dce-c7c9-400b-af24-10b8981358a7@CMEXHTCAS2.ad.emulex.com>
	<CAJ3xEMgepRUQs+GiMWxzV_QFaRnfbX7TPOdB_sKgRhHj7x7NDg@mail.gmail.com>
	<553DE614.7050508@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <553DE614.7050508-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 27, 2015 at 10:32 AM, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 4/26/2015 8:20 PM, Or Gerlitz wrote:
>> On Thu, Mar 26, 2015 at 12:19 AM, Somnath Kotur
>> <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:
>>> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

>>> In order to manage multiple types, vlans and MACs per GID, we
>>> need to store them along the GID itself. We store the net device
>>> as well, as sometimes GIDs should be handled according to the
>>> net device they came from. Since populating the GID table should
>>> be identical for every RoCE provider, the GIDs table should be
>>> handled in ib_core.
>>>
>>> Adding a GID cache table that supports a lockless find, add and
>>> delete gids. The lockless nature comes from using a unique
>>> sequence number per table entry and detecting that while reading/
>>> writing this sequence wasn't changed.

>> Matan, please use existing mechanism which fits the problem you are
>> trying to solve, I guess one of RCU or seqlock should do the job.

> seqcount fits this problem better. Since if a write and read are done in
> parallel, there's a good chance we read an out of date entry and we are
> going to use a GID entry that's going to change in T+epsilon, so RCU doesn't
> really have an advantage here.

So going back to the problem... we are talking on applications/drivers
that attempt to establish new connections doing reads and writes done
on behalf of IP stack changes, both are very much not critical path.
So this is kind of similar to the neighbour table maintained by ND
subsystem which is used by all IP based networking applications and
that code uses RCU. I don't see what's wrong with RCU for our sort
smaller scale subsystem and what is even wrong with simple rwlock
which is the mechanism used today by the IB core git cache, this goes
too complex and for no reason that I can think of.


> The current implementation is a bit more efficient than seqcount, as it
> allows early termination of read-while-write (because the write puts a known
> "currently updating" value that the read knows to ignore). AFAIK, this
> doesn't exist in the current seqcount implementation. However, since this
> isn't a crucial data-path, I'll change that to seqcount.
>
> seqcount is preferred over seqlock, as I don't need the spinlock in seqlock.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
