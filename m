From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv6 1/3] rdmacg: Added rdma cgroup controller
Date: Thu, 25 Feb 2016 19:04:56 +0530
Message-ID: <CAG53R5UZb=9WR7zk2b5C_FuKmt+WdNkbcrVbW+g1-oAj6J=w_Q@mail.gmail.com>
References: <1455966006-13774-1-git-send-email-pandit.parav@gmail.com>
	<1455966006-13774-2-git-send-email-pandit.parav@gmail.com>
	<56CDAC7A.6030206@mellanox.com>
	<CAG53R5Uof+Ve7CndWy=BrgtxxCisQpzP_Ls0kw=Q270DhoEsZw@mail.gmail.com>
	<56CEED81.7010507@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56CEED81.7010507-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 25, 2016 at 5:33 PM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>>> +retry:
>>>> +     spin_lock(&cg->rpool_list_lock);
>>>> +     rpool = find_cg_rpool_locked(cg, device);
>>>> +     if (!rpool) {
>>>> +             spin_unlock(&cg->rpool_list_lock);
>>>> +             ret = alloc_cg_rpool(cg, device);
>>>> +             if (ret)
>>>> +                     goto err;
>>>> +             else
>>>> +                     goto retry;
>>> Instead of retrying after allocation of a new rpool, why not just return the
>>> newly allocated rpool (or the existing one) from alloc_cg_rpool?
>>
>> It can be done, but locking semantics just becomes difficult to
>> review/maintain with that where alloc_cg_rpool will unlock and lock
>> conditionally later on.
> Maybe I'm missing something, but couldn't you simply lock rpool_list_lock
> inside alloc_cg_rpool()? It already does that around its call to
> find_cg_rpool_locked() and the insertion to cg_list.

No. ref_count and usage counters are updated at level where lock is
taken in charge_cg_resource().
If I move locking rpool_list_lock inside alloc_cg_rpool, unlocking
will continue outside, alloc_cg_rpool() when its found or allocated.
As you acknowledged in below comment that this makes confusing to
lock/unlock from different context, I think current implementation
achieves both.
(a) take lock from single context
(b) keep functionality of find and alloc in two separate individual functions

>
>> This path will be hit anyway on first allocation typically. Once
>> application is warm up, it will be unlikely to enter here.
>> I should change if(!rpool) to if (unlikely(!rpool)).
> Theoretically the new allocated rpool can be released again by the time you
> get to the second call to find_cg_rpool_locked().
>
Thats ok, because if that occurs find_cg_rpool_locked() won't find the
entry and will try to allocate again.
Things work fine in that case.

> I thought that was about functions that only locked the lock, called the
> find function, and released the lock. What I'm suggesting is to have one
> function that does "lock + find + allocate if needed + unlock",

I had similar function in past which does,
"lock + find + allocate if needed + + inc_ref_cnt + unlock", (get_cg_rpool)
update usage_counter atomically, because other thread/process might update too.
check atomic_dec_cnt - on reaching zero, "lock + del_entry + unlock + free".

Tejun asked to simplify this to,

"lock + find + allocate if needed + inc_ref_cnt_without_atomic" + unlock".
which I did in this patch v6.

> and another
> function that does (under caller's lock) "check ref count + check max count +
> release rpool".
This can be done. Have one dumb basic question for thiat.
Can we call kfree() with spin_lock held? All these years I tend to
avoid doing so.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
