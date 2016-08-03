From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: Re: [PATCH 2/2] ipoib: Ratelimit messages which can flood a host.
Date: Wed, 3 Aug 2016 17:32:11 +0300
Message-ID: <57A2006B.5070304@kyup.com>
References: <1469543929-17659-1-git-send-email-kernel@kyup.com>
 <1469543929-17659-2-git-send-email-kernel@kyup.com>
 <20160726180021.GA6144@yuval-lap.uk.oracle.com>
 <1470234370.18081.63.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470234370.18081.63.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 08/03/2016 05:26 PM, Doug Ledford wrote:
> On Tue, 2016-07-26 at 21:00 +0300, Yuval Shaia wrote:
>> On Tue, Jul 26, 2016 at 05:38:49PM +0300, Nikolay Borisov wrote:
>>>
>>> In case an infiniband outtage occurs the messages modified
>>> in this patchset can flood the host with a rate of 1 message per
>>
>> s/patchset/patch
>>
>>>
>>> ms which is a lot. Using the ratelimited version of ipoib_warn
>>> fixes the issue by limiting at most 10 messages in 5 seconds.
>>>
>>> Signed-off-by: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
>>> ---
>>>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
>>> b/drivers/infiniband/ulp/ipoib/ipoib_main.c
>>> index 7d3281866ffc..dd5b4afbc00b 100644
>>> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
>>> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
>>> @@ -1034,9 +1034,9 @@ static void ipoib_timeout(struct net_device
>>> *dev)
>>>  {
>>>  	struct ipoib_dev_priv *priv = netdev_priv(dev);
>>>  
>>> -	ipoib_warn(priv, "transmit timeout: latency %d msecs\n",
>>> +	ipoib_warn_rl(priv, "transmit timeout: latency %d
>>> msecs\n",
>>>  		   jiffies_to_msecs(jiffies - dev->trans_start));
>>> -	ipoib_warn(priv, "queue stopped %d, tx_head %u, tx_tail
>>> %u\n",
>>> +	ipoib_warn_rl(priv, "queue stopped %d, tx_head %u, tx_tail
>>> %u\n",
>>
>> So this is just to hide the hide the problem,
> 
> No, that's not true.  To hide the problem, he would have to remove the
> printk entirely.  Linus absolutely despises when programmers use
> BUG_ON() for situations where it is possible for the system to
> continue, albeit with reduced capability or what not.  Similarly, it is
> entirely unacceptable that a simple issue, such as a hardware queue
> stoppage on a network device, can render a system mostly or entirely or
> even just somewhat unusable due to a flood of kernel printk messages.
> 
> Just so we're clear, I absolutely despise printk floods.  There is
> never a valid reason for them.  If someone in the kernel community
> suggested that we make the default printk implementation be flood
> proof, I would support it.  In the meantime, I'm all for these patches.
>  And if there are other places in the ipoib code that can cause floods
> too, I would like to see them switched over to use the rate limited
> version too.
> 
> Now that I think about it, I'm just as likely to be receptive to a
> patch that makes the default ipoib_warn() always be rate limited, and
> if there are exceptions in the ipoib stack where we truly want every

The thing with this approach is that it's entirely possible to miss
messages if there is one particular ratelimit state.

> message, then change just those places to a different
> ipoib_warn_no_rate_limit() implementation.  I would probably modify the
> default rate though...10 in 5 seconds is probably too low for some of
> the messages, as we can legitimately get a burst of 50 in less than a
> second when doing things like joining lots of multicast groups and
> there is an issue, or something like that.  Maybe 100 in 60 to allow
> for bursts but to still prevent runaway printks like you are having?
> 
If you take a closer look at the definition of ipoib_warn_rl you would
see that it's enclosed in it's own {} block, meaning its ratelimit state
is going to apply to this particular place. In essence only the
"transmit timeout: latency msec" message would be rate limited to 10
messages in 5 seconds, which I believe is fine. In a flood situation
you'd get 10 identical messages and then there will be a line saying how
many were suppressed, indicating a flood.


>>  the real question is what is
>> causing this to happen a lot.
>>
>>>
>>>  		   netif_queue_stopped(dev),
>>>  		   priv->tx_head, priv->tx_tail);
>>>  	/* XXX reset QP, etc. */
>>> -- 
>>> 2.5.0
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-
>>> rdma" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
