From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/9] IB/ipoib: factor out ah flushing
Date: Fri, 13 Mar 2015 10:39:06 +0200
Message-ID: <CAJ3xEMgxxHu5BQdADaRe-Grtf4rm1LMfsCRiDyF6ToPdV_62OA@mail.gmail.com>
References: <cover.1424562072.git.dledford@redhat.com>
	<b06eb720c2f654f5ecdb72c66f4e89149d1c24ec.1424562072.git.dledford@redhat.com>
	<54EF1F67.4000001@dev.mellanox.co.il>
	<1424968046.2543.18.camel@redhat.com>
	<54F2B61C.9080308@dev.mellanox.co.il>
	<1425308967.2354.19.camel@redhat.com>
	<54F585E9.7070704@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54F585E9.7070704-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 3, 2015 at 11:59 AM, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On 3/2/2015 5:09 PM, Doug Ledford wrote:
>>
>> On Sun, 2015-03-01 at 08:47 +0200, Erez Shitrit wrote:
>>>
>>> On 2/26/2015 6:27 PM, Doug Ledford wrote:
>>>>>>
>>>>>> @@ -1037,6 +1038,7 @@ static void __ipoib_ib_dev_flush(struct
>>>>>> ipoib_dev_priv *priv,
>>>>>>         if (level == IPOIB_FLUSH_LIGHT) {
>>>>>>                 ipoib_mark_paths_invalid(dev);
>>>>>>                 ipoib_mcast_dev_flush(dev);
>>>>>> +               ipoib_flush_ah(dev, 0);
>>>>>
>>>>> Why do you need to call the flush function here?
>>>>
>>>> To remove all of the ah's that were reduced to a 0 refcount by the
>>>> previous two functions prior to restarting operations.  When we remove
>>>> an ah, it calls ib_destroy_ah which calls all the way down into the low
>>>> level driver.  This was to make sure that old, stale data was removed
>>>> all the way down to the card level before we started new queries for
>>>> paths and ahs.
>>>
>>> Yes. but it is not needed.
>>
>> That depends on the card.  For the modern cards (mlx4, mlx5, qib), it
>> isn't needed but doesn't hurt either.  For older cards (in particular,
>> mthca), the driver actually frees up card resources at the time of the
>> call.
>
>
> Can you please elaborate more here, I took a look in the mthca and didn't
> see that.
> anyway, what i don't understand is why you need to do that now, the ah is
> already in the dead_ah_list so, in at the most 1 sec will be cleared and if
> the driver goes down your other hunk fixed that.

Doug, ten days and no response from you... lets finalize the review on
this series so we have it safely done for 4.1 -- on top of it Erez
prepares a set of IPoIB fixes from our internal tree and we want that
for 4.1 too. Please address.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
