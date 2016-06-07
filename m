From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-rc 2/7] IB/IPoIB: Don't update neigh validity for
 unresolved entries
Date: Tue, 7 Jun 2016 09:01:38 +0300
Message-ID: <CAAk-MO9gUtqZHKq+7xaHLkJRM_T-DgF0wOCFuykre9=0VUBbQw@mail.gmail.com>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
	<1465042524-25852-3-git-send-email-leon@kernel.org>
	<CAJ3xEMgYKnVh4JECrCSBUYmyCr4s-zxWhMywMVTQPZswLvF61A@mail.gmail.com>
	<42668994-5666-f5b3-8d38-4c452f0cc70f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <42668994-5666-f5b3-8d38-4c452f0cc70f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 7, 2016 at 2:59 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 6/5/2016 5:10 PM, Or Gerlitz wrote:
>
>>> -                       neigh->alive = jiffies;
>>> +
>>> +                       if (likely(skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE))
>>> +                               neigh->alive = jiffies;
>>
>> why testing the queue len makes things right?
>
> I'm with Or on this one.  This test doesn't make sense unless you assume
> that the neighbor is being hit with a steady stream of packets.  If
> someone just runs ping -c 1 to a dead neighbor, this test will fail.
> The idea of the patch is OK, but the test needs to be reworked for
> situations other than a blasting stream of data.
>

I will try to explain the idea behind that test, and why it works (I
hope I'll make it clear this time :))

there are 2 objects that are taking place here, the garbage-collector
that removes neigh if was not used for defined time, and the
path-query for each neigh.
if the path-query failed the packets for specific neigh are kept in
the neigh queue, but only if there are no more than
IPOIB_MAX_PATH_REC_QUEUE, and the neigh is still kept for ever (let's
assume CM connected that was stopped without any notification with
DREQ etc.)
The only way to know that there is an unresolved neigh is by checking
its queue, if it is full we can assume that this is an unresolved
neigh otherwise it is resolved.
So, the test doesn't take any assumption on the shape of the traffic,
even in a ping requests once a second it will failed after 3 times the
request was sent, and the neigh time will not be updated which will
leave it to the garbage-collector to delete it, that gives the driver
the possibility to recreate the neigh and to update its ah/pr,
otherwise the driver will try over and over to resend to that
unresolved neigh.

>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
