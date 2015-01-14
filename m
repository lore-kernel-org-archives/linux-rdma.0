From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH FIX for-3.19] IB/ipoib: Fix failed multicast joins/sends
Date: Wed, 14 Jan 2015 18:02:03 +0200
Message-ID: <54B692FB.1010904@dev.mellanox.co.il>
References: <c903a4f1282f7d5852157c68bcc3f4324fd4300f.1421217352.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c903a4f1282f7d5852157c68bcc3f4324fd4300f.1421217352.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Perhaps I am missing something here, but ping6 still doesn't work for me 
in many cases.

I think the reason is that your origin patch does the following:
in function ipoib_mcast_join_task
         if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
             ipoib_mcast_sendonly_join(mcast);
         else
             ipoib_mcast_join(dev, mcast, 1);
         return;
The flow for sendonly_join doesn't include handling the mc_task, so only 
the first mc in the list (if it is sendonly mcg) will be sent, and no 
more mcg's that are in the ipoib mc list are going to be sent. (see how 
it is in ipoib_mcast_join flow)

I can demonstrate it with the log of ipoib:
I am trying to ping6 fe80::202:c903:9f:3b0a via ib0

The log is:
ib0: restarting multicast task
ib0: setting up send only multicast group for 
ff12:601b:ffff:0000:0000:0000:0000:0016
ib0: adding multicast entry for mgid ff12:601b:ffff:0000:0000:0001:ff43:3bf1
ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, 
starting sendonly join
ib0: join completion for ff12:601b:ffff:0000:0000:0000:0000:0001 (status 0)
ib0: MGID ff12:601b:ffff:0000:0000:0000:0000:0001 AV ffff88081afb5f40, 
LID 0xc015, SL 0
ib0: join completion for ff12:401b:ffff:0000:0000:0000:0000:0001 (status 0)
ib0: MGID ff12:401b:ffff:0000:0000:0000:0000:0001 AV ffff88081e1c42c0, 
LID 0xc014, SL 0
ib0: sendonly multicast join failed for 
ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, 
starting sendonly join
ib0: sendonly multicast join failed for 
ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, 
starting sendonly join
ib0: sendonly multicast join failed for 
ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
ib0: setting up send only multicast group for 
ff12:601b:ffff:0000:0000:0000:0000:0002
ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, 
starting sendonly join
ib0: sendonly multicast join failed for 
ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
ib0: setting up send only multicast group for 
ff12:601b:ffff:0000:0000:0001:ff9f:3b0a
     >>>>>> here you can see that the ipv6 address is added and queued 
to the list
ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, 
starting sendonly join
ib0: sendonly multicast join failed for 
ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
     >>>>>> the ipv6 mcg will not be sent because it is after some other 
sendonly, and no one in that flow re-queue the mc_task again.

Thanks, Erez
> The usage of IPOIB_MCAST_RUN as a flag is inconsistent.  In some places
> it is used to mean "our device is administratively allowed to send
> multicast joins/leaves/packets" and in other places it means "our
> multicast join task thread is currently running and will process your
> request if you put it on the queue".  However, this latter meaning is in
> fact flawed as there is a race condition between the join task testing
> the mcast list and finding it empty of remaining work, dropping the
> mcast mutex and also the priv->lock spinlock, and clearing the
> IPOIB_MCAST_RUN flag.  Further, there are numerous locations that use
> the flag in the former fashion, and when all tasks complete and the task
> thread clears the RUN flag, all of those other locations will fail to
> ever again queue any work.  This results in the interface coming up fine
> initially, but having problems adding new multicast groups after the
> first round of groups have all been added and the RUN flag is cleared by
> the join task thread when it thinks it is done.  To resolve this issue,
> convert all locations in the code to treat the RUN flag as an indicator
> that the multicast portion of this interface is in fact administratively
> up and joins/leaves/sends can be performed.  There is no harm (other
> than a slight performance penalty) to never clearing this flag and using
> it in this fashion as it simply means that a few places that used to
> micro-optimize how often this task was queued on a work queue will now
> queue the task a few extra times.  We can address that suboptimal
> behavior in future patches.
>
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>   drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 11 +++++------
>   1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> index bc50dd0d0e4..91b8fe118ec 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -630,8 +630,6 @@ void ipoib_mcast_join_task(struct work_struct *work)
>   	}
>   
>   	ipoib_dbg_mcast(priv, "successfully joined all multicast groups\n");
> -
> -	clear_bit(IPOIB_MCAST_RUN, &priv->flags);
>   }
>   
>   int ipoib_mcast_start_thread(struct net_device *dev)
> @@ -641,8 +639,8 @@ int ipoib_mcast_start_thread(struct net_device *dev)
>   	ipoib_dbg_mcast(priv, "starting multicast thread\n");
>   
>   	mutex_lock(&mcast_mutex);
> -	if (!test_and_set_bit(IPOIB_MCAST_RUN, &priv->flags))
> -		queue_delayed_work(priv->wq, &priv->mcast_task, 0);
> +	set_bit(IPOIB_MCAST_RUN, &priv->flags);
> +	queue_delayed_work(priv->wq, &priv->mcast_task, 0);
>   	mutex_unlock(&mcast_mutex);
>   
>   	return 0;
> @@ -725,7 +723,7 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
>   		memcpy(mcast->mcmember.mgid.raw, mgid, sizeof (union ib_gid));
>   		__ipoib_mcast_add(dev, mcast);
>   		list_add_tail(&mcast->list, &priv->multicast_list);
> -		if (!test_and_set_bit(IPOIB_MCAST_RUN, &priv->flags))
> +		if (test_bit(IPOIB_MCAST_RUN, &priv->flags))
>   			queue_delayed_work(priv->wq, &priv->mcast_task, 0);
>   	}
>   
> @@ -951,7 +949,8 @@ void ipoib_mcast_restart_task(struct work_struct *work)
>   	/*
>   	 * Restart our join task if needed
>   	 */
> -	ipoib_mcast_start_thread(dev);
> +	if (test_bit(IPOIB_MCAST_RUN, &priv->flags))
> +		queue_delayed_work(priv->wq, &priv->mcast_task, 0);
>   	rtnl_unlock();
>   }
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
