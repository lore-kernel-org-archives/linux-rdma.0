Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793175529;
	b=s4Nv472FQuHNSULz1wcUuxGYlevvyOfRunWJdWQKE2aX5scf6c9JSPZz0CVx6FfCl0ST
	 3C02yHAOjm2M5nArUtgF46BuL5kbfPncdXOqHdibMeR0UeEOvVnfc4Q2lk+LQL7WnYXAs
	 TzWwifOgifkkrZBUswP6T83Z1Vo7AH429EbkuqPv1H0KeT83gdeeu/9zdQ6Xs8J1Er+76
	 TgFNc0TTo4cBcBRAafBtCisckJQR9RGMW6jfyAxgrC9rjRvBCSkjpS4XNkT0yE4hWZlaR
	 /lEOugvWk5klGX96L6ATyMRGCW7xuqsAh9FkM6EeZ/RpWXkutOK29uPZ/8uqM/yuUdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793175529;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=XlpO6EQu+C5X1emUUUam6jKnE32+edCfS5s9qfhUjic=;
	b=P46fKe62RagHKHXUD0k8EY88rv1+Hqx1SsXrDwWrMn13LmtrOOb3A0POsr/T7g3Xrtth
	 kS1X6pc7a2LpOxM0l7jvsYa/URTSQpe/vwJgaHBkvO80WOSV69FeuVFUYs5TB5iDrR9Gw
	 tQNlDU3bT6POblbdGDqPufix083SoGic2zP9048L5iP79i0hli8RpX6ip3tvTuc9WKYif
	 HtUSnUbTkpW6laHCvkGIhiYR67hREHgbhzHcegxkvf5qChnFovzBRi128Ne5iMWbyIcYB
	 EaJcumynDatjf47x58+OHIcdNmizAgYJ1cz+TffF1g3kTJbzifceTGqFNBIhbxNcdSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=q2AJUIJA;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA758606A329;
	Wed, 28 Oct 2026 08:18:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA758606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=q2AJUIJA
Received: from [10.26.7.43] (unknown [4.213.232.22])
	by linux.microsoft.com (Postfix) with ESMTPSA id C512E20B7166;
	Wed, 28 Oct 2026 01:18:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C512E20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793175516;
	bh=XlpO6EQu+C5X1emUUUam6jKnE32+edCfS5s9qfhUjic=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=q2AJUIJAz1gMNBivOfb0SCvHPmW+yi8LWWWAewhCHfYRmOFNnLTI3ke7ve2YR0tkH
	 xgS7pzrJVeNnQGsLOo8cNl9ehDUMlEJLCrULZeFJmlbV5/IuHDVzGksbkd3R9D/C6G
	 kbM+qNUoT1IE+T9bpzSi2dGvD6U+1Jhe+rrseqSk=
Message-ID: <10979583-c3db-4ebe-bdec-f1848b27c96b@linux.microsoft.com>
Date: Wed, 28 Oct 2026 13:48:44 +0530
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net: mana: Avoid waiting on dead HWC after device
 reset
To: sashiko-reviews@lists.linux.dev, linux-hyperv@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20261025072838.1991785-1-sahilchandna@linux.microsoft.com>
 <sashiko-outbox-184659@kernel.org>
Content-Language: en-US
From: Sahil Chandna <sahilchandna@linux.microsoft.com>
In-Reply-To: <sashiko-outbox-184659@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 26-10-2026 12:59, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] net: mana: non-waiting CQ poll in mana_dealloc_queues() triggers false FLR
> - [Medium] net: mana: mana_hwc_send_request() blocks on hwc->sema before checking hwc_dead
> --
> 
> commit 7823c203253d16c1fb640cce922ae30200b9f486
> Author: Sahil Chandna <sahilchandna@linux.microsoft.com>
> 
> net: mana: Avoid waiting on dead HWC after device reset
> 
> This commit replaces the sleep-based TX queue drain in mana_dealloc_queues()
> with synchronous CQE polling and marks the hardware channel dead via hwc_dead
> after a device reset so subsequent HWC commands fail fast with -ETIMEDOUT.
> 
>> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
>> index 3bca4b683134b..c9337f49fbe15 100644
>> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
>> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> 
> [ ... ]
> 
>> @@ -862,6 +867,7 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
>>  	u32 dest_vrcq;
>>  	u32 dest_vrq;
>>  	u32 command;
>> +	u32 timeout = 0;
>>  	u16 msg_id;
>>  	int err;
>>  
>> @@ -897,6 +903,17 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
>>  	dest_vrq = hwc->dest_vrq_id;
>>  	dest_vrcq = hwc->dest_vrcq_id;
>>  
>> +	/* If the HWC is unavailable (e.g. hwc_timeout was set to 0 or
>> +	 * hwc_dead set after device reset), do not post the WQE: the
>> +	 * hardware cannot respond, so fail fast instead of waiting out
>> +	 * the full timeout.
>> +	 */
>> +	timeout = READ_ONCE(hwc->hwc_timeout);
>> +	if (timeout == 0 || READ_ONCE(hwc->hwc_dead)) {
>> +		err = -ETIMEDOUT;
>> +		goto out;
>> +	}
> 
> [Severity: Medium]
> Can mana_hwc_send_request() still block for the full hwc_timeout on
> hwc->sema before reaching this hwc_dead check?
> 
> At the start of mana_hwc_send_request(), mana_hwc_get_msg_index() is called:
> 
>     mana_hwc_send_request()
>       -> mana_hwc_get_msg_index()
>            -> down(&hwc->sema);
> 
> Because hwc->sema is initialized to 1 (HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH),
> only one HWC command can be in flight at a time.
> 
> While the device is active, periodic work such as
> mana_gf_stats_work_handler() (running every 2 seconds without holding
> rtnl_lock) or auxiliary RDMA (mana_ib) callers can enter
> mana_hwc_send_request(), acquire hwc->sema, and sleep in
> wait_for_completion_timeout(&ctx->comp_event, ...) for the full 60s
> hwc_timeout when the hardware stops responding.
> 
> When mana_dealloc_queues() resets the device and sets hwc->hwc_dead = true,
> it does not complete any in-flight ctx->comp_event, so the subsequent
> mana_disable_vport_rx() -> mana_hwc_send_request() call in
> mana_dealloc_queues() will still block in down(&hwc->sema) while holding
> rtnl_lock until the concurrent caller's timeout expires.
> 
> Should hwc_timeout == 0 || hwc_dead also be checked before acquiring
> hwc->sema (or should in-flight waiters be completed when marking HWC dead)?
> 
Ack, this is valid, I will fix this in v2.>> diff --git
a/drivers/net/ethernet/microsoft/mana/mana_en.c
b/drivers/net/ethernet/microsoft/mana/mana_en.c
>> index 6b7c027e497ed..00885d21a9af0 100644
>> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
>> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
>> @@ -3753,16 +3753,19 @@ int mana_attach(struct net_device *ndev)
>>  static int mana_dealloc_queues(struct net_device *ndev)
>>  {
>>  	struct mana_port_context *apc = netdev_priv(ndev);
>> -	unsigned long timeout = jiffies + 120 * HZ;
>>  	struct gdma_dev *gd = apc->ac->gdma_dev;
>> +	struct hw_channel_context *hwc;
>> +	bool trigger_flr = false;
>> +	int flr_pending, i, err;
>>  	struct mana_txq *txq;
>>  	struct sk_buff *skb;
>> -	int i, err;
>> -	u32 tsleep;
>> +	u32 flr_txq_id = 0;
>>  
>>  	if (apc->port_is_up)
>>  		return -EINVAL;
>>  
>> +	hwc = gd->gdma_context->hwc.driver_data;
>> +
>>  	if (apc->rxqs)
>>  		mana_chn_setxdp(apc, NULL);
>>  
>> @@ -3774,42 +3777,92 @@ static int mana_dealloc_queues(struct net_device *ndev)
>>  	 * a txq because it may not timely see apc->port_is_up being cleared
>>  	 * to false, but it doesn't matter since mana_start_xmit() drops any
>>  	 * new packets due to apc->port_is_up being false.
>> -	 *
>> -	 * Drain all the in-flight TX packets.
>> -	 * A timeout of 120 seconds for all the queues is used.
>> -	 * This will break the while loop when h/w is not responding.
>> -	 * This value of 120 has been decided here considering max
>> -	 * number of queues.
>> +	 * Drain the in-flight TX completions for each queue. TX is already
>> +	 * stopped, so pending_sends can no longer grow. For each queue,
>> +	 * disable NAPI so it cannot run at the same time as this drain,
>> +	 * then process all completions still in the CQ. If some are still
>> +	 * missing after that, the hardware is not responding: reset device
>> +	 * and stop waiting on the now-unavailable HWC.
>>  	 */
>>  
>>  	if (apc->tx_qp) {
>>  		for (i = 0; i < apc->num_queues; i++) {
>> +			struct mana_cq *tx_cq;
>> +			struct napi_struct *napi;
>> +			int pending;
>> +
>> +			if (!apc->tx_qp[i])
>> +				continue;
>> +
>> +			tx_cq = &apc->tx_qp[i]->tx_cq;
>>  			txq = &apc->tx_qp[i]->txq;
>> -			tsleep = 1000;
>> -			while (atomic_read(&txq->pending_sends) > 0 &&
>> -			       time_before(jiffies, timeout)) {
>> -				usleep_range(tsleep, tsleep + 1000);
>> -				tsleep <<= 1;
>> +			napi = &tx_cq->napi;
>> +
>> +			if (txq->napi_initialized) {
>> +				/* Stop the NAPI poll so it cannot run
>> +				 * concurrently with the synchronous drain.
>> +				 */
>> +				napi_synchronize(napi);
>> +				napi_disable_locked(napi);
>> +				cancel_work_sync(&tx_cq->dim.work);
>> +
>> +				/* Reap all TX completions currently in the CQ.
>> +				 * A zero budget frees skbs via the non-NAPI
>> +				 * path, which is required outside softirq.
>> +				 */
>> +				tx_cq->budget = 0;
>> +				do {
>> +					tx_cq->work_done = 0;
>> +					mana_poll_tx_cq(tx_cq);
>> +				} while (tx_cq->work_done);
>>  			}
>> -			if (atomic_read(&txq->pending_sends)) {
>> -				err = mana_gd_dev_reset(gd->gdma_context);
>> -				if (err) {
>> -					netdev_err(ndev, "device reset failed %d with %d pkts pending in txq %u\n",
>> -						   err,
>> -					    atomic_read(&txq->pending_sends),
>> -					    txq->gdma_txq_id);
>> -				}
>> -				break;
>> +
>> +			pending = atomic_read(&txq->pending_sends);
>> +			if (!trigger_flr && pending > 0) {
>> +				trigger_flr = true;
>> +				flr_txq_id = txq->gdma_txq_id;
>> +				flr_pending = pending;
>>  			}
>>  		}
>>  
>> +		if (trigger_flr && !(hwc && hwc->hwc_dead)) {
>> +			/* Completions never arrived: the device is
>> +			 * unresponsive. Issue device reset and
>> +			 * mark the HWC dead so subsequent HWC commands
>> +			 * fail fast instead of each waiting the full
>> +			 * hwc_timeout.
>> +			 */
>> +			err = mana_gd_dev_reset(gd->gdma_context);
>> +			if (err)
>> +				netdev_err(ndev, "device reset failed %d with %d pkts pending in txq %u\n",
>> +					   err,
>> +					   flr_pending,
>> +					   flr_txq_id);
>> +			else if (hwc)
>> +				WRITE_ONCE(hwc->hwc_dead, true);
>> +		}
> 
> [Severity: High]
> Won't this non-waiting CQ poll trigger a premature Function Level Reset and
> permanently mark the HWC dead whenever TX packets are still in flight in the
> hardware during a normal detach or per-port queue reset?
> 
> In mana_detach(), setting apc->port_is_up = false and calling
> netif_tx_disable(ndev) prevents new packets from being queued in software,
> but packets posted to txq->gdma_sq right before netif_tx_disable() are still
> asynchronously in flight in the NIC hardware (DMA read, shaping, wire
> transmission, and CQE DMA write-back).
> 
> mana_poll_tx_cq() is non-blocking:
> 
>     mana_poll_tx_cq()
>       comp_read = mana_gd_poll_cq(cq->gdma_cq, completions, ...);
>       if (comp_read < 1)
>               return;
> 
> As soon as mana_gd_poll_cq() reaches a CQE slot that the hardware has not
> yet written back to host memory, it returns 0, mana_poll_tx_cq() returns
> early with tx_cq->work_done == 0, and the do-while loop exits immediately
> without waiting for the in-flight SQ entries to complete.
> 
> If any packet is still in flight on the NIC when the loop exits,
> atomic_read(&txq->pending_sends) > 0 sets trigger_flr = true, which calls
> mana_gd_dev_reset() and sets hwc->hwc_dead = true on healthy hardware.
> 
> Because hwc->hwc_dead is never cleared without destroying and recreating the
> HWC channel, any operation that detaches and reattaches queues under traffic
> (such as mana_close() followed by mana_open(), mana_change_mtu(),
> mana_set_channels(), mana_set_ringparam(), mana_set_priv_flags(), or
> mana_xdp_set()) will cause subsequent mana_attach() or mana_open() calls and
> any other vPorts or RDMA instances on the function to fail permanently with
> -ETIMEDOUT.
> 
> Similarly, single-port TX timeout recovery in
> mana_per_port_queue_reset_work_handler() runs when a TX queue is stalled
> (so pending_sends > 0 holds by definition):
> 
>     mana_per_port_queue_reset_work_handler()
>       -> mana_detach(ndev, false)
>            -> mana_dealloc_queues(ndev)
>       -> mana_attach(ndev)
> 
> Because mana_dealloc_queues() now resets the entire PCIe function and sets
> hwc->hwc_dead = true, the recovery call to mana_attach(ndev) immediately
> fails with -ETIMEDOUT instead of recovering the port.
> 
> Furthermore, if mana_gd_dev_reset() fails or is skipped because hwc_dead was
> already set, the cleanup loop immediately below unmaps and frees the
> in-flight TX SKBs via mana_unmap_skb() and dev_kfree_skb_any() without
> having waited for DMA completion or reset the device.
> 
Ack, this would need a bounded wait to verify queue is really stuck
rather than depend only on pending_sends, I will fix this in v2.

