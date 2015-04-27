From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 for-next 01/33] IB/core: Add RoCE GID cache
Date: Mon, 27 Apr 2015 10:32:36 +0300
Message-ID: <553DE614.7050508@mellanox.com>
References: <1427318422-12004-1-git-send-email-somnath.kotur@emulex.com>
	<44ab0dce-c7c9-400b-af24-10b8981358a7@CMEXHTCAS2.ad.emulex.com>
 <CAJ3xEMgepRUQs+GiMWxzV_QFaRnfbX7TPOdB_sKgRhHj7x7NDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgepRUQs+GiMWxzV_QFaRnfbX7TPOdB_sKgRhHj7x7NDg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 4/26/2015 8:20 PM, Or Gerlitz wrote:
> On Thu, Mar 26, 2015 at 12:19 AM, Somnath Kotur
> <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:
>> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> In order to manage multiple types, vlans and MACs per GID, we
>> need to store them along the GID itself. We store the net device
>> as well, as sometimes GIDs should be handled according to the
>> net device they came from. Since populating the GID table should
>> be identical for every RoCE provider, the GIDs table should be
>> handled in ib_core.
>>
>> Adding a GID cache table that supports a lockless find, add and
>> delete gids. The lockless nature comes from using a unique
>> sequence number per table entry and detecting that while reading/
>> writing this sequence wasn't changed.
>
> Matan, please use existing mechanism which fits the problem you are
> trying to solve, I guess one of RCU or seqlock should do the job.
>

seqcount fits this problem better. Since if a write and read are done in 
parallel, there's a good chance we read an out of date entry and we are 
going to use a GID entry that's going to change in T+epsilon, so RCU 
doesn't really have an advantage here.

The current implementation is a bit more efficient than seqcount, as it 
allows early termination of read-while-write (because the write puts a 
known "currently updating" value that the read knows to ignore). AFAIK, 
this doesn't exist in the current seqcount implementation. However, 
since this isn't a crucial data-path, I'll change that to seqcount.

seqcount is preferred over seqlock, as I don't need the spinlock in seqlock.

> Or.
>

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
