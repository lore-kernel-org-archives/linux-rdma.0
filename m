From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/2] ipoib: Ratelimit messages which can flood a host.
Date: Mon, 1 Aug 2016 11:11:49 +0300
Message-ID: <CAAk-MO-j1+vAPCQNvwOocLRsc-CB2C0BkUULDcwaniHKurEjZw@mail.gmail.com>
References: <1469543929-17659-1-git-send-email-kernel@kyup.com>
 <1469543929-17659-2-git-send-email-kernel@kyup.com> <20160726180021.GA6144@yuval-lap.uk.oracle.com>
 <CAJFSNy5RA_PVxz0oPdKamF7Kc+1LFDZ9P0LbQH6EHuvqJO18xQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJFSNy5RA_PVxz0oPdKamF7Kc+1LFDZ9P0LbQH6EHuvqJO18xQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nikolay Borisov <n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 27, 2016 at 1:02 AM, Nikolay Borisov
<n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org> wrote:
> On Tue, Jul 26, 2016 at 9:00 PM, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>> On Tue, Jul 26, 2016 at 05:38:49PM +0300, Nikolay Borisov wrote:
>>> In case an infiniband outtage occurs the messages modified
>>> in this patchset can flood the host with a rate of 1 message per
>>
>> s/patchset/patch
>>
>>> ms which is a lot. Using the ratelimited version of ipoib_warn
>>> fixes the issue by limiting at most 10 messages in 5 seconds.
>>>
>>> Signed-off-by: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
>>> ---
>>>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
>>> index 7d3281866ffc..dd5b4afbc00b 100644
>>> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
>>> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
>>> @@ -1034,9 +1034,9 @@ static void ipoib_timeout(struct net_device *dev)
>>>  {
>>>       struct ipoib_dev_priv *priv = netdev_priv(dev);
>>>
>>> -     ipoib_warn(priv, "transmit timeout: latency %d msecs\n",
>>> +     ipoib_warn_rl(priv, "transmit timeout: latency %d msecs\n",
>>>                  jiffies_to_msecs(jiffies - dev->trans_start));
>>> -     ipoib_warn(priv, "queue stopped %d, tx_head %u, tx_tail %u\n",
>>> +     ipoib_warn_rl(priv, "queue stopped %d, tx_head %u, tx_tail %u\n",
>>
>> So this is just to hide the hide the problem, the real question is what is
>> causing this to happen a lot.
>
> So the answer to that should be "yes and no". So it's true that the
> underlying bug that's causing those symptoms is not fixed, but it
> seems no one has an idea how to debug it based on past reports I have
> made:
>
> http://www.spinics.net/lists/linux-rdma/msg34577.html
> http://www.spinics.net/lists/linux-rdma/msg37011.html (Looking back it
> seems you have also replied to one of the threads:
> http://www.spinics.net/lists/linux-rdma/msg37022.html)
> http://thread.gmane.org/gmane.linux.drivers.rdma/38899
>
> I'm currently have 10s of servers experiencing this and I have no idea
> what's causing, the excessive print is just one of the symptoms. While
> I will be totally glad to find the root cause and troubleshoot it so
> far it seems to elude me. In any case I believe those patches on their
> own do make sense.

As i wrote you in previous mail, there is more to debug here, and not
only the SW.

>
>>
>>>                  netif_queue_stopped(dev),
>>>                  priv->tx_head, priv->tx_tail);
>>>       /* XXX reset QP, etc. */
>>> --
>>> 2.5.0
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
