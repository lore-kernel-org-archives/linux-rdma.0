Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5332C3C7E13;
	Tue, 13 Oct 2026 15:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791904149; cv=none; b=ARzEMafnO+jMYF/RQRccHm7I6aA/fMd/FuGSp21UNrFQ9KFI0+5gGCH07ujpLyup9fVetdIP0qtxXeOkSLKD5ddtbPWFWmzgmGEY37Rs1VXYXZLEf573Z8szHf43//IJ/Pj8ADMnsUcJkPKVjc73q12TwsBhbSTMl/GuRad8cPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791904149; c=relaxed/simple;
	bh=jsPV0JSIGSmCdmGYp+E4FmOl1B850oT6JaQHeCgb8+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HSfUO/Dmi5If08jPcmNS7977cYncgl3t2x226ikSNRIdxu6W85Cypj9Zk2+kV8bQrkpgh3/WFxX/hmfRfjki/jxHP5Hs999s4SUeafCFkv7/iutiLlb1twnXVAcDT99R23RhQkvKoAWBj8M555unLDskB2rX1W8AwXsq/7ZU4Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=iTcC5Iw3; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="iTcC5Iw3"
Received: from [10.26.7.43] (unknown [4.213.232.22])
	by linux.microsoft.com (Postfix) with ESMTPSA id 8542120B7169;
	Tue, 13 Oct 2026 08:08:58 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8542120B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791904142;
	bh=e7ew6NMtWrwcepLYlmJQ93zo9inrfT5l5nZou0ZT5RY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iTcC5Iw32vTmbNFHvf+WhuzXJCCLJNjAmxkKgrzfiakgKV6tC4zApuY5ii0iNko4I
	 2OFi/NuJWKKZ2lpdy0Tty6jPIyoH+A5swfMfG0b+sgXnO3r+iq1h1uospeKogemBm9
	 LTd996h1eKylLyQoy1dq6Wc1HT3pnrxfAuY1Dr68=
Message-ID: <083267ab-5989-487f-86c7-7a4b4fe3a6dd@linux.microsoft.com>
Date: Tue, 13 Oct 2026 20:38:59 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] net: mana: Add support to process throttled EQEs
To: netdev-bot+sashiko@kernel.org
Cc: haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, kotaranov@microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, gargaditya@linux.microsoft.com,
 mawasthi@linux.microsoft.com, leitao@debian.org,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261008083315.306076-1-sahilchandna@linux.microsoft.com>
 <179179616248.434549.2649767157991099688@kernel.org>
Content-Language: en-US
From: Sahil Chandna <sahilchandna@linux.microsoft.com>
In-Reply-To: <179179616248.434549.2649767157991099688@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 12-10-2026 14:39, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 2 · Medium: 2 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] The throttle-EQE fix only reaches CQs that mana_gd_create_cq()
>   registered in parent->eq.child_cq[], but the patch asks for throttled…
> - [High] During HWC teardown, the HWC CQ stays published in the HWC EQ's
>   RCU-protected child_cq[] after the state its callback uses has been…
> - [Medium] The commit message presents the change as a fix: hardware
>   sends type-4 throttle EQEs, the driver drops them, and CQs stall.
> - [Medium] mana_gd_destroy_cq() now calls synchronize_rcu() once for
>   every CQ that has a parent EQ.
> - [Low] eq->eq.throttle_count is incremented with a plain '++' in hardirq
>   context (mana_gd_intr -> mana_gd_process_eqe).
> 
> --
> 
> net: mana: Add support to process throttled EQEs
> 
> This patch handles the type 4 throttle EQE. The hardware sends it in place
> of per-CQ completion notifications when an EQ nears full. Each EQ records
> up to two child CQs and schedules them when a throttle EQE arrives. The
> patch also advertises a new driver capability bit and adds an ethtool -S
> counter.
> 
>> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
>> index ae0ed700b3b93..b8e5ad2c6d312 100644
>> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
>> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
>> @@ -747,6 +747,18 @@ void mana_gd_free_service_wq(struct gdma_context *gc)
>>  	gc->service_wq = NULL;
>>  }
>>  
>> +static void mana_gd_schedule_eq_cqs(struct gdma_queue *eq)
>> +{
>> +	struct gdma_queue *cq;
>> +	u8 i;
>> +
>> +	for (i = 0; i < GDMA_EQ_MAX_CHILD_CQ; i++) {
>> +		cq = rcu_dereference(eq->eq.child_cq[i]);
>> +		if (cq && cq->cq.callback)
>> +			cq->cq.callback(cq->cq.context, cq);
>> +	}
>> +}
> 
> [Severity: High]
> Can this path reach the HWC CQ callback after its state has been freed?
> 
> Before this patch, the only way to reach the HWC CQ callback was the
> GDMA_EQE_COMPLETION case. That case is gated by gc->max_num_cqs and
> gc->cq_table[]. The throttle path walks child_cq[] directly and skips
> that gate.
> 
> mana_hwc_destroy_channel() tears things down in this order:
> 
> drivers/net/ethernet/microsoft/mana/hw_channel.c:mana_hwc_destroy_channel() {
>     ...
> 	if (gc->max_num_cqs > 0) {
> 		mana_smc_teardown_hwc(&gc->shm_channel, false);
> 		gc->max_num_cqs = 0;
> 	}
> 
> 	if (hwc->txq)
> 		mana_hwc_destroy_wq(hwc, hwc->txq);
> 
> 	if (hwc->rxq)
> 		mana_hwc_destroy_wq(hwc, hwc->rxq);
> 
> 	if (hwc->cq)
> 		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
>     ...
> }
> 
> mana_hwc_destroy_cq() then frees comp_buf before the CQ is removed from
> child_cq[]:
> 
> drivers/net/ethernet/microsoft/mana/hw_channel.c:mana_hwc_destroy_cq() {
> 	kfree(hwc_cq->comp_buf);
> 
> 	if (hwc_cq->gdma_cq)
> 		mana_gd_destroy_queue(gc, hwc_cq->gdma_cq);
>     ...
> }
> 
> The HWC EQ interrupt is still registered at that point. Suppose a throttle
> EQE arrives on the HWC EQ in this window:
> 
> mana_gd_intr()
>   mana_gd_process_eqe()
>     mana_gd_schedule_eq_cqs()
>       mana_hwc_comp_event()
>         mana_gd_poll_cq(q_self, hwc_cq->comp_buf, ...)
>         mana_hwc_rx_event_handler() / mana_hwc_tx_event_handler()
> 
> Wouldn't this write CQEs into the freed comp_buf, and then dereference the
> freed hwc->rxq and hwc->txq?
> 
> A well-behaved device probably would not post a throttle EQE after SMC
> teardown. In confidential VMs, though, the driver treats the host as
> untrusted, and the max_num_cqs gate used to block this route.
> 
> Should the CQ be removed from child_cq[], followed by a grace period,
> before the HWC teardown frees comp_buf, txq and rxq?
> 
I will fix this in v2.
>> +
>>  static void mana_gd_process_eqe(struct gdma_queue *eq)
>>  {
>>  	u32 head = eq->head % (eq->queue_size / GDMA_EQE_SIZE);
>> @@ -777,6 +789,11 @@ static void mana_gd_process_eqe(struct gdma_queue *eq)
>>  
>>  		break;
>>  
>> +	case GDMA_EQE_THROTTLE:
>> +		eq->eq.throttle_count++;
> 
> [Severity: Low]
> This counter is incremented with a plain ++ in hardirq context, via
> mana_gd_intr()->mana_gd_process_eqe(). mana_get_ethtool_stats() reads it
> with a plain load in process context, with no shared lock:
> 
> 	apc->eth_stats.eq_throttle_events +=
> 		apc->eqs[q].eq->eq.throttle_count;
> 
> The value can't tear because MANA only builds on 64-bit. Do these accesses
> still need READ_ONCE()/WRITE_ONCE() annotations? Without them KCSAN will
> report a data race, and the compiler is free to fuse or reload the
> accesses.
> 
>> +		mana_gd_schedule_eq_cqs(eq);
>> +		break;
>> +
> 
I will fix this in v2.
> [ ... ]
> 
>> @@ -1063,17 +1080,41 @@ static void mana_gd_create_cq(const struct gdma_queue_spec *spec,
>>  			      struct gdma_queue *queue)
>>  {
>>  	u32 log2_num_entries = ilog2(spec->queue_size / GDMA_CQE_SIZE);
>> +	struct gdma_queue *parent;
>> +	u8 i;
>>  
>>  	queue->head |= INITIALIZED_OWNER_BIT(log2_num_entries);
>> -	queue->cq.parent = spec->cq.parent_eq;
>> +	parent = spec->cq.parent_eq;
>> +	queue->cq.parent = parent;
>>  	queue->cq.context = spec->cq.context;
>>  	queue->cq.callback = spec->cq.callback;
>> +
>> +	if (!parent)
>> +		return;
>> +
>> +	/* For throttled EQE store the child CQ */
>> +	for (i = 0; i < GDMA_EQ_MAX_CHILD_CQ; i++)
>> +		if (!rcu_access_pointer(parent->eq.child_cq[i])) {
>> +			rcu_assign_pointer(parent->eq.child_cq[i], queue);
>> +			return;
>> +		}
>>  }
> 
> [Severity: High]
> Does this registration cover every CQ the hardware can attach to an EQ?
> 
> The capability bit added to GDMA_DRV_CAP_FLAGS1 requests throttled EQEs
> for the whole function. However, child_cq[] is only filled here. It is
> only filled when spec->cq.parent_eq is set, and only for the first two
> CQs.
> 
> The mana_ib CQs never go through this path. RNIC CQs are bound in
> hardware to the mana_ib EQs:
> 
> drivers/infiniband/hw/mana/main.c:mana_ib_gd_create_cq() {
>     ...
> 	req.eq_id = mdev->eqs[cq->comp_vector]->id;
>     ...
> }
> 
> RSS and raw QP CQs are attached to the Ethernet per-vPort EQs:
> 
> drivers/infiniband/hw/mana/qp.c:mana_ib_create_qp_rss() {
>     ...
> 	eq = &mpc->eqs[cq->comp_vector % mpc->num_queues];
> 	cq_spec.attached_eq = eq->eq->id;
>     ...
> }
> 
> mana_ib_create_qp_raw() does the same. Both kinds of CQ are published only
> through gc->cq_table[]:
> 
> drivers/infiniband/hw/mana/cq.c:mana_ib_install_cq_cb() {
>     ...
> 	gdma_cq->cq.callback = mana_ib_cq_handler;
> 	gdma_cq->id = cq->queue.id;
> 	gc->cq_table[cq->queue.id] = gdma_cq;
>     ...
> }
> 
> Also, mana_ib_create_kernel_queue() builds its GDMA_CQ spec without
> spec.cq.parent_eq, so mana_gd_create_cq() returns before reaching this
> loop.
> 
> On an RDMA EQ, a throttle EQE would find every child_cq[] slot NULL and
> only increment throttle_count. On an Ethernet EQ, the two slots already
> hold the Ethernet TX and RX CQs, so the loop silently skips the RDMA CQ.
> 
> In both cases, wouldn't mana_ib_cq_handler() lose its only notification
> and the CQ stall? That is the stall the commit message says this patch
> fixes.
> 
> Would it work to dispatch to every CQ bound to the EQ, or to scope the
> capability so it only covers EQs whose CQs are all tracked?
> 
This is similar to sashiko review comment, after discussing this
internally we decided to handle rdma seperately.>>
>>  static void mana_gd_destroy_cq(struct gdma_context *gc,
>>  			       struct gdma_queue *queue)
>>  {
>> +	struct gdma_queue *parent = queue->cq.parent;
>>  	u32 id = queue->id;
>> +	u8 i;
>> +
>> +	if (parent) {
>> +		for (i = 0; i < GDMA_EQ_MAX_CHILD_CQ; i++) {
>> +			if (rcu_access_pointer(parent->eq.child_cq[i]) == queue)
>> +				RCU_INIT_POINTER(parent->eq.child_cq[i], NULL);
>> +		}
>> +
>> +		synchronize_rcu();
>> +	}
> 
> [Severity: Medium]
> Does this add a full RCU grace period to every CQ destroy?
> 
> synchronize_rcu() runs whenever the CQ has a parent, even when the CQ was
> never found in child_cq[]. mana_destroy_txq() and mana_destroy_rxq() loop
> over apc->num_queues and, for each queue, reach:
> 
> mana_deinit_cq()
>   mana_gd_destroy_queue()
>     mana_gd_destroy_cq()
> 
> These loops run under the netdev instance lock and RTNL. Ifdown,
> set_channels, ring size, MTU and XDP changes, and the reset/servicing
> paths would all wait for 2 * num_queues back-to-back grace periods while
> holding RTNL. With 64 queues that is 128 serialized grace periods.
> 
> Could all child slots be cleared first and synchronize_rcu() called once?
> Alternatively, the free could be deferred with call_rcu() or kfree_rcu().
> 
>>  
>>  	if (id >= gc->max_num_cqs)
>>  		return;
> 
> [ ... ]
> 
I will fix this in v2.
>> diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
>> index c610fc1067e0d..03fe9395604d6 100644
>> --- a/include/net/mana/gdma.h
>> +++ b/include/net/mana/gdma.h
> 
> [ ... ]
> 
>> @@ -752,6 +758,9 @@ enum {
>>  /* Driver supports non-contiguous queue buffers */
>>  #define GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS BIT(30)
>>  
>> +/* Driver supports handling throttled EQEs */
>> +#define GDMA_DRV_CAP_FLAG_1_THROTTLED_EVENT_QUEUE BIT_ULL(32)
>> +
> 
> [Severity: Medium]
> The commit message describes this as a fix:
> 
>   The driver does not handle this event type, so
>   it falls through to the default case and is dropped. Any CQ whose
>   completion notification was replaced by the throttle EQE is then never
>   scheduled again and its queue stalls.
> 
> It doesn't mention that the patch also advertises a new capability bit to
> the device. GDMA_DRV_CAP_FLAG_1_THROTTLED_EVENT_QUEUE is added to the
> common GDMA_DRV_CAP_FLAGS1, which mana_gd_verify_vf_version() sends
> unconditionally.
> 
> If the device only sends type 4 EQEs after the driver sets this bit, can
> the described stall happen on current kernels at all? If not, this is a
> feature opt-in rather than a fix.
> 
> If the stall can happen today, should the patch carry a Fixes: tag?
> 
> The commit message also doesn't mention the new eq_throttle_events
> counter in ethtool -S. Could both changes be described in the commit
> message?
> 
>>  /* Capabilities in the PCI-only group below rely on dynamic MSI-X allocation
>>   * and on the servicing and reset paths reached through
>>   * mana_schedule_serv_work(). Transports that provide neither leave
>> @@ -776,7 +785,8 @@ enum {
>>  	 GDMA_DRV_CAP_FLAG_1_HANDLE_STALL_SQ_RECOVERY | \
>>  	 GDMA_DRV_CAP_FLAG_1_EQ_MSI_UNSHARE_MULTI_VPORT | \
>>  	 GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION | \
>> -	 GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS)
>> +	 GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS | \
>> +	 GDMA_DRV_CAP_FLAG_1_THROTTLED_EVENT_QUEUE)
>>  
>>  #define GDMA_DRV_CAP_FLAGS2 0
> 
I will fix this in v2.

pw-bot: cr

