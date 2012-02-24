From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] iw_cm: reject connect requests if cmid is not in LISTEN
Date: Fri, 24 Feb 2012 15:41:45 -0600
Message-ID: <4F480419.5050706@opengridcomputing.com>
References: <20120222214307.23921.83903.stgit@build.ogc.int> <CAL1RGDWb0ocYN5oM3QtxRj5VWCAWrp3Jtx6N1UHSrNDP2A1WEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWb0ocYN5oM3QtxRj5VWCAWrp3Jtx6N1UHSrNDP2A1WEw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 02/24/2012 03:32 PM, Roland Dreier wrote:
> On Wed, Feb 22, 2012 at 1:43 PM, Steve Wise<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>  wrote:
>> @@ -631,6 +631,8 @@ static void cm_conn_req_handler(struct iwcm_id_private *listen_id_priv,
>>         spin_lock_irqsave(&listen_id_priv->lock, flags);
>>         if (listen_id_priv->state != IW_CM_STATE_LISTEN) {
>>                 spin_unlock_irqrestore(&listen_id_priv->lock, flags);
>> +               iw_cm_reject(cm_id, NULL, 0);
>> +               iw_destroy_cm_id(cm_id);
>>                 goto out;
>>         }
>>         spin_unlock_irqrestore(&listen_id_priv->lock, flags);
> I think I see your bug.  Look at the whole cm_conn_req_handler()
> function.  Where is this new code relative to where you initialize cm_id?
>
>   - R.

duh. jeeze. ok, lemme try again.  I'll add printks to make sure I'm really hitting this path too.




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
