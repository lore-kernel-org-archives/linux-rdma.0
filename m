From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] iw_cm: reject connect requests if cmid is not in LISTEN
Date: Fri, 24 Feb 2012 08:16:22 -0600
Message-ID: <4F479BB6.7060101@opengridcomputing.com>
References: <20120222214307.23921.83903.stgit@build.ogc.int> <CAL1RGDV7ZoKWgbh+ERF+af3_B7K2USAkXSPKWeQEg5atpHY0og@mail.gmail.com> <4F465A46.3060301@opengridcomputing.com> <4F4699A1.7030402@opengridcomputing.com> <CAL1RGDWkVJxEDZ5SaaSa8oA_y6a0u1NCbzTK9agsJE+V_YzimQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWkVJxEDZ5SaaSa8oA_y6a0u1NCbzTK9agsJE+V_YzimQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 02/23/2012 07:57 PM, Roland Dreier wrote:
> On Thu, Feb 23, 2012 at 11:55 AM, Steve Wise
> <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>  wrote:
>> RIP: 0010:[<0000000000200200>]  [<0000000000200200>]
> 0x200200 is LIST_POISON2, which is set when something is removed
> from a Linux list.
>
>>   [<ffffffff8008c846>] __wake_up_common+0x3e/0x68
>>   [<ffffffff8002e261>] __wake_up+0x38/0x4f
>>   [<ffffffff8867410b>] :iw_cm:iw_cm_reject+0x5a/0xa7
> So in the code
>
>         if (cm_id_priv->state != IW_CM_STATE_CONN_RECV) {
>                 spin_unlock_irqrestore(&cm_id_priv->lock, flags);
>                 clear_bit(IWCM_F_CONNECT_WAIT,&cm_id_priv->flags);
>                 wake_up_all(&cm_id_priv->connect_wait);
>                 return -EINVAL;
>         }
>
> the cm_id_priv->connect_wait is being corrupted before
> or during the call to wake_up_all...
>
> could the HW or low-level driver be generating events for
> the incoming connections that are associated with the
> listen ID, as the listen ID is being destroyed?
>
> Maybe that's why the code silently ignored these requests
> before :)
>

The low level driver at this point doesn't have the cm_id for this connect request because it has not been accepted or 
rejected by the iwcm.  So there's no way it can post any events.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
