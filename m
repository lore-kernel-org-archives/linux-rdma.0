From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH] IPoIB: serialize changing on tx_outstanding
Date: Thu, 8 Oct 2015 09:39:46 +0300
Message-ID: <CALq1K=KO2SnUoPpCoyBXp_MbjkRTyoXqvz1CnBNY0fsPJ8iRUw@mail.gmail.com>
References: <1443418930-18677-1-git-send-email-wen.gang.wang@oracle.com>
 <20151008043317.GB1940@leon.nu> <5615F743.5050404@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5615F743.5050404-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>>> +               spin_lock_irqsave(&priv->lock, flags);
>>> +               --priv->tx_outstanding;
>>> +               if (netif_queue_stopped(dev))
>>> +                       netif_wake_queue(dev);
>>> +               spin_unlock_irqrestore(&priv->lock, flags);
>>
>> Why are you locking the netif_* calls?
>
>
> Yes, I intended to do that.   This make the accessing on tx_outstanding and
> the reopening of the send queue in the same atomic session which is the
> expected behavior.
> Otherwise,  we may have the following problem:
> #time order
>
> thread1(on cpu1) thread2(on cpu2)
> lock
> modify/check tx_outstanding
> unlock
>
>
> lock
> modify/check tx_outstanding
> unlock
>
> reopen queue
>
>
>                        stop queue
>
>
> So that we actually want reopen the send queue, but the result is we stopped
> it.
Thanks for the explanation.

>
> thanks,
> wengang
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
