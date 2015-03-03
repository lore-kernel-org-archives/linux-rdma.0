From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 8/9] IB/ipoib: deserialize multicast joins
Date: Tue, 03 Mar 2015 11:54:39 +0200
Message-ID: <54F584DF.8080603@dev.mellanox.co.il>
References: <cover.1424562072.git.dledford@redhat.com>	 <a24ade295dfdd1369aac47a978003569ec190952.1424562072.git.dledford@redhat.com>	 <54F31AEC.3010001@dev.mellanox.co.il> <1425310145.2354.26.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425310145.2354.26.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/2/2015 5:29 PM, Doug Ledford wrote:
> On Sun, 2015-03-01 at 15:58 +0200, Erez Shitrit wrote:
>> On 2/22/2015 2:27 AM, Doug Ledford wrote:
>>> Allow the ipoib layer to attempt to join all outstanding multicast
>>> groups at once.  The ib_sa layer will serialize multiple attempts to
>>> join the same group, but will process attempts to join different groups
>>> in parallel.  Take advantage of that.
>>>
>>> In order to make this happen, change the mcast_join_thread to loop
>>> through all needed joins, sending a join request for each one that we
>>> still need to join.  There are a few special cases we handle though:
>>>
>>> 1) Don't attempt to join anything but the broadcast group until the join
>>> of the broadcast group has succeeded.
>>> 2) No longer restart the join task at the end of completion handling.
>>> If we completed successfully, we are done.  The join task now needs kicked
>>> either by mcast_send or mcast_restart_task or mcast_start_thread, but
>>> should not need started anytime else except when scheduling a backoff
>>> attempt to rejoin.
>>> 3) No longer use separate join/completion routines for regular and
>>> sendonly joins, pass them all through the same routine and just do the
>>> right thing based on the SENDONLY join flag.
>>> 4) Only try to join a SENDONLY join twice, then drop the packets and
>>> quit trying.  We leave the mcast group in the list so that if we get a
>>> new packet, all that we have to do is queue up the packet and restart
>>> the join task and it will automatically try to join twice and then
>>> either send or flush the queue again.
>>>
>>> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>    drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 250 ++++++++-----------------
>>>    1 file changed, 82 insertions(+), 168 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>>> index 277e7ac7c4d..c670d9c2cda 100644
>>> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>>> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>>> @@ -307,111 +307,6 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
>>>    	return 0;
>>>    }
>>>    
>>> -static int
>>> -ipoib_mcast_sendonly_join_complete(int status,
>>> -				   struct ib_sa_multicast *multicast)
>>> -{
>>> -	struct ipoib_mcast *mcast = multicast->context;
>>> -	struct net_device *dev = mcast->dev;
>>> -	struct ipoib_dev_priv *priv = netdev_priv(dev);
>>> -
>>> -	/*
>>> -	 * We have to take the mutex to force mcast_sendonly_join to
>>> -	 * return from ib_sa_multicast_join and set mcast->mc to a
>>> -	 * valid value.  Otherwise we were racing with ourselves in
>>> -	 * that we might fail here, but get a valid return from
>>> -	 * ib_sa_multicast_join after we had cleared mcast->mc here,
>>> -	 * resulting in mis-matched joins and leaves and a deadlock
>>> -	 */
>>> -	mutex_lock(&mcast_mutex);
>>> -
>>> -	/* We trap for port events ourselves. */
>>> -	if (status == -ENETRESET) {
>>> -		status = 0;
>>> -		goto out;
>>> -	}
>>> -
>>> -	if (!status)
>>> -		status = ipoib_mcast_join_finish(mcast, &multicast->rec);
>>> -
>>> -	if (status) {
>>> -		if (mcast->logcount++ < 20)
>>> -			ipoib_dbg_mcast(netdev_priv(dev), "sendonly multicast "
>>> -					"join failed for %pI6, status %d\n",
>>> -					mcast->mcmember.mgid.raw, status);
>>> -
>>> -		/* Flush out any queued packets */
>>> -		netif_tx_lock_bh(dev);
>>> -		while (!skb_queue_empty(&mcast->pkt_queue)) {
>>> -			++dev->stats.tx_dropped;
>>> -			dev_kfree_skb_any(skb_dequeue(&mcast->pkt_queue));
>>> -		}
>>> -		netif_tx_unlock_bh(dev);
>>> -		__ipoib_mcast_schedule_join_thread(priv, mcast, 1);
>>> -	} else {
>>> -		mcast->backoff = 1;
>>> -		mcast->delay_until = jiffies;
>>> -		__ipoib_mcast_schedule_join_thread(priv, NULL, 0);
>>> -	}
>>> -out:
>>> -	clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
>>> -	if (status)
>>> -		mcast->mc = NULL;
>>> -	complete(&mcast->done);
>>> -	mutex_unlock(&mcast_mutex);
>>> -	return status;
>>> -}
>>> -
>>> -static int ipoib_mcast_sendonly_join(struct ipoib_mcast *mcast)
>>> -{
>>> -	struct net_device *dev = mcast->dev;
>>> -	struct ipoib_dev_priv *priv = netdev_priv(dev);
>>> -	struct ib_sa_mcmember_rec rec = {
>>> -#if 0				/* Some SMs don't support send-only yet */
>>> -		.join_state = 4
>>> -#else
>>> -		.join_state = 1
>>> -#endif
>>> -	};
>>> -	int ret = 0;
>>> -
>>> -	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags)) {
>>> -		ipoib_dbg_mcast(priv, "device shutting down, no sendonly "
>>> -				"multicast joins\n");
>>> -		clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
>>> -		complete(&mcast->done);
>>> -		return -ENODEV;
>>> -	}
>>> -
>>> -	rec.mgid     = mcast->mcmember.mgid;
>>> -	rec.port_gid = priv->local_gid;
>>> -	rec.pkey     = cpu_to_be16(priv->pkey);
>>> -
>>> -	mutex_lock(&mcast_mutex);
>>> -	mcast->mc = ib_sa_join_multicast(&ipoib_sa_client, priv->ca,
>>> -					 priv->port, &rec,
>>> -					 IB_SA_MCMEMBER_REC_MGID	|
>>> -					 IB_SA_MCMEMBER_REC_PORT_GID	|
>>> -					 IB_SA_MCMEMBER_REC_PKEY	|
>>> -					 IB_SA_MCMEMBER_REC_JOIN_STATE,
>>> -					 GFP_ATOMIC,
>>> -					 ipoib_mcast_sendonly_join_complete,
>>> -					 mcast);
>>> -	if (IS_ERR(mcast->mc)) {
>>> -		ret = PTR_ERR(mcast->mc);
>>> -		clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
>>> -		ipoib_warn(priv, "ib_sa_join_multicast for sendonly join "
>>> -			   "failed (ret = %d)\n", ret);
>>> -		complete(&mcast->done);
>>> -	} else {
>>> -		ipoib_dbg_mcast(priv, "no multicast record for %pI6, starting "
>>> -				"sendonly join\n", mcast->mcmember.mgid.raw);
>>> -	}
>>> -	mutex_unlock(&mcast_mutex);
>>> -
>>> -	return ret;
>>> -}
>>> -
>>>    void ipoib_mcast_carrier_on_task(struct work_struct *work)
>>>    {
>>>    	struct ipoib_dev_priv *priv = container_of(work, struct ipoib_dev_priv,
>>> @@ -452,7 +347,9 @@ static int ipoib_mcast_join_complete(int status,
>>>    	struct net_device *dev = mcast->dev;
>>>    	struct ipoib_dev_priv *priv = netdev_priv(dev);
>>>    
>>> -	ipoib_dbg_mcast(priv, "join completion for %pI6 (status %d)\n",
>>> +	ipoib_dbg_mcast(priv, "%sjoin completion for %pI6 (status %d)\n",
>>> +			test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) ?
>>> +			"sendonly " : "",
>>>    			mcast->mcmember.mgid.raw, status);
>>>    
>>>    	/*
>>> @@ -477,27 +374,52 @@ static int ipoib_mcast_join_complete(int status,
>>>    	if (!status) {
>>>    		mcast->backoff = 1;
>>>    		mcast->delay_until = jiffies;
>>> -		__ipoib_mcast_schedule_join_thread(priv, NULL, 0);
>>>    
>>>    		/*
>>>    		 * Defer carrier on work to priv->wq to avoid a
>>> -		 * deadlock on rtnl_lock here.
>>> +		 * deadlock on rtnl_lock here.  Requeue our multicast
>>> +		 * work too, which will end up happening right after
>>> +		 * our carrier on task work and will allow us to
>>> +		 * send out all of the non-broadcast joins
>>>    		 */
>>> -		if (mcast == priv->broadcast)
>>> +		if (mcast == priv->broadcast) {
>>>    			queue_work(priv->wq, &priv->carrier_on_task);
>>> +			__ipoib_mcast_schedule_join_thread(priv, NULL, 0);
>>> +		}
>>>    	} else {
>>>    		if (mcast->logcount++ < 20) {
>>>    			if (status == -ETIMEDOUT || status == -EAGAIN) {
>>> -				ipoib_dbg_mcast(priv, "multicast join failed for %pI6, status %d\n",
>>> +				ipoib_dbg_mcast(priv, "%smulticast join failed for %pI6, status %d\n",
>>> +						test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) ? "sendonly " : "",
>>>    						mcast->mcmember.mgid.raw, status);
>>>    			} else {
>>> -				ipoib_warn(priv, "multicast join failed for %pI6, status %d\n",
>>> +				ipoib_warn(priv, "%smulticast join failed for %pI6, status %d\n",
>>> +						test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) ? "sendonly " : "",
>>>    					   mcast->mcmember.mgid.raw, status);
>>>    			}
>>>    		}
>>>    
>>> -		/* Requeue this join task with a backoff delay */
>>> -		__ipoib_mcast_schedule_join_thread(priv, mcast, 1);
>>> +		if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) &&
>>> +		    mcast->backoff >= 2) {
>>> +			/*
>>> +			 * We only retry sendonly joins once before we drop
>>> +			 * the packet and quit trying to deal with the
>>> +			 * group.  However, we leave the group in the
>>> +			 * mcast list as an unjoined group.  If we want to
>>> +			 * try joining again, we simply queue up a packet
>>> +			 * and restart the join thread.  The empty queue
>>> +			 * is why the join thread ignores this group.
>>> +			 */
>> Question: the sendonly is at the list for ever? looks like that, and it
>> is prior to your patches, so probably it should be sent in some other
>> patch to solve that.
> Correct.  That logic is unchanged.  It probably deserves some sort of
> timeout such that after X seconds with no traffic on a sendonly group,
> we leave that group and only rejoin if we get a new send.  I had thought
> about making it something really long, like 20 minutes, but thinking
> about it is all I've done.  I didn't code anything up or include that in
> these patches.
>
OK, Thanks. We we will need to send a patch for that.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
