From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] iw_cm: Call provider listen_destroy function before changing
 state.
Date: Wed, 22 Feb 2012 15:01:30 -0600
Message-ID: <4F4557AA.4040000@opengridcomputing.com>
References: <20120222194337.21025.30754.stgit@build.ogc.int> <CAG4TOxMXTzLDynza4KOaccx2C+Nn0485Xk_hXgg_bG0CiCTSEQ@mail.gmail.com> <4F45536A.3050501@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F45536A.3050501-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 02/22/2012 02:43 PM, Steve Wise wrote:
> On 02/22/2012 02:32 PM, Roland Dreier wrote:
>> On Wed, Feb 22, 2012 at 11:43 AM, Steve Wise
>> <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>  wrote:
>>>       spin_lock_irqsave(&cm_id_priv->lock, flags);
>>>         switch (cm_id_priv->state) {
>>>         case IW_CM_STATE_LISTEN:
>>> -               cm_id_priv->state = IW_CM_STATE_DESTROYING;
>>>                 spin_unlock_irqrestore(&cm_id_priv->lock, flags);
>>>                 /* destroy the listening endpoint */
>>>                 ret = cm_id->device->iwcm->destroy_listen(cm_id);
>>>                 spin_lock_irqsave(&cm_id_priv->lock, flags);
>>> +               cm_id_priv->state = IW_CM_STATE_DESTROYING;
>>>                 break;
>>>         case IW_CM_STATE_ESTABLISHED:
>>>                 cm_id_priv->state = IW_CM_STATE_DESTROYING;
>> This seems a bit wonky to me... with the old code, we set the state to
>> DESTROYING inside the lock, so we know all previous connections
>> were either done with their locked region or saw the new state.
>>
>> Now we have a window where are done with destroy_listen() but
>> the state is still not DESTROYING.
>>
>> Is it possible to have the provider reject requests instead of silently
>> dropping them?  Would that be a better fix?
>>
>
> Perhaps.   Or the connect request event handler could return a status indicating whether or not it queued the request 
> and will subsequently accept or reject it.

Actually, the events are deferred and scheduled so my idea doesn't hold water.

I'll code up and test your reject idea.

Thanks,

Steve.


>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
