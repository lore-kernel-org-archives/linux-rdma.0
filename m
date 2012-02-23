From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] iw_cm: reject connect requests if cmid is not in LISTEN
Date: Thu, 23 Feb 2012 09:24:54 -0600
Message-ID: <4F465A46.3060301@opengridcomputing.com>
References: <20120222214307.23921.83903.stgit@build.ogc.int> <CAL1RGDV7ZoKWgbh+ERF+af3_B7K2USAkXSPKWeQEg5atpHY0og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDV7ZoKWgbh+ERF+af3_B7K2USAkXSPKWeQEg5atpHY0og-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 02/23/2012 01:46 AM, Roland Dreier wrote:
> On Wed, Feb 22, 2012 at 1:43 PM, Steve Wise<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>  wrote:
>> diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
>> index 1a696f7..6847d76 100644
>> --- a/drivers/infiniband/core/iwcm.c
>> +++ b/drivers/infiniband/core/iwcm.c
>> @@ -631,6 +631,8 @@ static void cm_conn_req_handler(struct iwcm_id_private *listen_id_priv,
>>         spin_lock_irqsave(&listen_id_priv->lock, flags);
>>         if (listen_id_priv->state != IW_CM_STATE_LISTEN) {
>>                 spin_unlock_irqrestore(&listen_id_priv->lock, flags);
>> +               iw_cm_reject(cm_id, NULL, 0);
>> +               iw_destroy_cm_id(cm_id);
>>                 goto out;
>>         }
>>         spin_unlock_irqrestore(&listen_id_priv->lock, flags);
> Thanks, this makes more sense to my brain at least.
>

Yes, this is the best fix methinks.  Thanks for the review!

> I assume this works just as well in your testing? :)

Yes, I've run some large NP MPI tests that tickle this condition and all the connections get cleaned up now.  I also ran 
some other MPI regression tests with this fix.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
