Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793175070;
	b=jBp/V5AXPd5g+Y/I4xbBNdU0KsF+4/3FNjeZWsV7e84eyjMMI+7YL732b7eQ9K4gGHJ3
	 WzAaCbaWX5alYXgvl3YrybuYyAX8OcFtYONKwuvXIj/ZHsRJtR6CGOrlJsldrNniOjADo
	 FQxA1mbc/DE/fOQ8dIi0/hqX6AZlUreyP3VUQ8n3ovg9T3iKxOazYmy1ZlXN5eLF8oMTV
	 ee+nrM0Ngq9a5CQqPpWKLcbKZXlmVO/HrZlI/3nLNHMBGFcvsRjWC2NncOWUf7obRDBsU
	 2NX0yBnA0ZGnJrp/3UYTjH5TRDpuoTTTCjhDh7h2kZX81FhsMZQxd1SO2xw1w2jILxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793175070;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=JP4KfsVX3G3pDEhHGD62pQlYeAuCHGaVp+P1DEP+rJc=;
	b=TqROREKaBkM0FnpgDppMUJpFpr8o1huf0Id2OL+QUKxUazmkNLBlPFbHWLoAEy+qsKA/
	 wqsyIu3ChourY925xwjWpTyAkH9ZkVbNNxs8Q2apYUP9LIuk63lXnbyotP4qj1lCsSTlH
	 jeND+HJbB8mmPgAX7/oFLGcdmXgQLkw9zNEthnQJghHnykrABWrapvF1YuU7LdM8RRPTp
	 HTNTI4Z5aar5QVbg3zkCVL5iIX0ZY6GeIno4eVbrw0yInT21X0p3KBlyGUOm5jO0INAgH
	 24vFtNS7p7+AjVGvz0CEldXQeu0xHal3dWJolxyAen5xi7KvVRvzYQoemtzd16FbgkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b="mOF/KkVp";
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3277606A31D;
	Wed, 28 Oct 2026 08:11:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3277606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=mOF/KkVp
Received: from [10.26.7.43] (unknown [4.213.232.22])
	by linux.microsoft.com (Postfix) with ESMTPSA id A9D7620B7166;
	Wed, 28 Oct 2026 01:10:52 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A9D7620B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793175057;
	bh=JP4KfsVX3G3pDEhHGD62pQlYeAuCHGaVp+P1DEP+rJc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mOF/KkVpNeai9SicOkRnmsfo8w60U4/clLuC9CDezx+kHETKUfknBUt+S2K3FT+xZ
	 9/snIy9HlxCtpo/lzfxIE6q7+NOh44tGmCMNe88xZkjC3L2qaUQ64/PAI8Ux9bCkBs
	 wXIrR5Nl1u2O9hJk3N0hg7Wq/yL4uD2TLS4470hA=
Message-ID: <abeb55bf-20d6-4b62-b2a0-baa3649657eb@linux.microsoft.com>
Date: Wed, 28 Oct 2026 13:41:01 +0530
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
Subject: Re: [PATCH net v3] net: mana: Add support to process throttled EQEs
To: netdev-bot+sashiko@kernel.org
Cc: haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, kotaranov@microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, gargaditya@linux.microsoft.com,
 mawasthi@linux.microsoft.com, leitao@debian.org,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 stable@vger.kernel.org, weh@linux.microsoft.com
References: <20261022145428.323576-1-sahilchandna@linux.microsoft.com>
 <179302835318.3134.6374899091861716214@kernel.org>
Content-Language: en-US
From: Sahil Chandna <sahilchandna@linux.microsoft.com>
In-Reply-To: <179302835318.3134.6374899091861716214@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 26-10-2026 20:55, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 1 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] Incomplete fix: a throttle EQE never services RDMA (mana_ib)
>   CQs, so the CQ-stall bug the patch claims to fix is still reachable.
> - [Medium] mana_gd_destroy_cq() now calls synchronize_net() for every CQ
>   that was attached to a parent EQ, which is every mana_en TX and RX CQ.
> - [Low] Claimed race: mana_create_txq() and mana_create_rxq() write
>   gc->cq_table[] (mana_en.c:2855, 3181) before netif_napi_add_*() (2860,…
> 
> --
> 
> net: mana: Add support to process throttled EQEs
> 
> This patch handles GDMA_EQE_THROTTLE (type 4) events. Each EQ records
> up to two child CQs, and their callbacks are invoked when a throttle EQE
> arrives. It also advertises a new driver capability bit, adds an
> eq_throttle_events ethtool counter, and adds RCU grace period waits to
> the CQ and HWC teardown paths.
> 
>> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
>> index 8e9bfc1d6a2ae..d74ed00bb7834 100644
>> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
>> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
>> @@ -904,6 +904,27 @@ ssize_t mana_gd_read_ring(struct gdma_queue *q, char __user *buf,
>>  	return copied;
>>  }
>>  
>> +static void mana_gd_schedule_eq_cqs(struct gdma_queue *eq)
>> +{
>> +	struct gdma_context *gc = eq->gdma_dev->gdma_context;
>> +	struct gdma_queue *cq;
>> +	u8 i;
>> +
>> +	for (i = 0; i < GDMA_EQ_MAX_CHILD_CQ; i++) {
>> +		cq = rcu_dereference(eq->eq.child_cq[i]);
>> +
>> +		if (!cq)
>> +			continue;
>> +
>> +		if (cq->id >= READ_ONCE(gc->max_num_cqs) ||
>> +		    !gc->cq_table || gc->cq_table[cq->id] != cq)
>> +			continue;
>> +
>> +		if (cq->cq.callback)
>> +			cq->cq.callback(cq->cq.context, cq);
> 
> [Severity: Low]
> This may not be reachable today, but is cq_table membership enough to
> show that the CQ is ready for its callback?
> 
> mana_create_txq() and mana_create_rxq() publish the CQ in cq_table
> before they add NAPI. For example, in mana_create_rxq():
> 
>     gc->cq_table[cq->gdma_id] = cq->gdma_cq;
> 
>     netif_napi_add_weight_locked(ndev, &cq->napi, mana_poll, 1);
> 
> If a GDMA_EQE_THROTTLE arrived on the parent EQ in that window, this
> loop would call mana_schedule_napi()->napi_schedule_irqoff() on a
> napi_struct that is not initialized yet.
> 
> In mana_alloc_queues() the EQs are freshly created. During the RX
> window, the only other CQ on EQ i is TX CQ i. That CQ carries no
> traffic while port_is_up is still false, so with the throttle semantics
> described in the commit message this looks unreachable. It does depend
> on that ordering, and on the hardware never sending a throttle EQE
> without pending completions.
> 
> Would it be more robust to publish the cq_table entry only after
> netif_napi_add_*() has run?
> 
This is not reachable path for throttle eqe to fire at startup before
adding NAPI. I prefer to keep this as is.>> +	}
>> +}
> 
> [ ... ]
> 
>> @@ -1220,25 +1246,49 @@ static void mana_gd_create_cq(const struct gdma_queue_spec *spec,
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
> Can a throttle EQE leave the mana_ib CQs unserviced?
> 
> child_cq[] is only filled here, and only when spec->cq.parent_eq is
> set. In practice that covers the mana_en TX/RX CQs and the HWC CQ.
> 
> The RDMA CQs never get here with a parent:
> 
> - mana_ib_create_kernel_queue() in drivers/infiniband/hw/mana/main.c
>   builds its spec as below, so parent_eq is NULL:
> 
>     struct gdma_queue_spec spec = {};
> 
> - User CQs from mana_ib_create_queue() never go through
>   mana_gd_create_cq().
> 
> - mana_ib_install_cq_cb() only does:
> 
>     gc->cq_table[cq->queue.id] = gdma_cq;
> 
> The hardware still binds these CQs to GDMA EQs. In
> mana_ib_gd_create_cq():
> 
>     req.eq_id = mdev->eqs[cq->comp_vector]->id;
> 
> and in mana_ib_create_qp_rss() and mana_ib_create_qp_raw():
> 
>     cq_spec.attached_eq = eq->eq->id;
> 
> where those EQs are created by mana_ib_cfg_vport() when RDMA owns the
> vport.
> 
> These EQs are serviced by mana_gd_intr()->mana_gd_process_eqe(). On a
> GDMA_EQE_THROTTLE, mana_gd_schedule_eq_cqs() walks an all-NULL
> child_cq[], and mana_ib_cq_handler() never runs.
> 
> Wouldn't that leave RDMA consumers waiting on comp_handler with
> completions pending? That is the same queue stall the commit message
> describes.
> 
> GDMA_DRV_CAP_FLAG_1_THROTTLED_EVENT_QUEUE is added to
> GDMA_DRV_CAP_FLAGS1. mana_gd_verify_vf_version() sends that once for
> the whole device, which mana_en and mana_ib share. If firmware only
> emits type 4 EQEs after this bit is set, does this add a new stall for
> RDMA CQs? If firmware always emits them, is the fix incomplete for
> those EQs?
> 
The RDMA CQs are going to be handled separately in different patch
series from Wei Hu. For the cap bits, the throttle EQE fire irrespective
of whether they are present or not, this change adds support to handle
them.> Separately, once both GDMA_EQ_MAX_CHILD_CQ slots are taken, the loop
> above returns without recording the CQ and without any warning. Many
> RDMA CQs can share one comp_vector EQ, and that seems to be the case
> most likely to fill an EQ and trigger throttling.
> 
> Would this need a per-EQ list of CQs, or a walk over every CQ whose
> parent is this EQ, rather than a fixed 2-entry array?
> 
>>  
>>  static void mana_gd_destroy_cq(struct gdma_context *gc,
>>  			       struct gdma_queue *queue)
>>  {
> 
> [ ... ]
> 
>> -	gc->cq_table[id] = NULL;
>> +	/* Wait for irq reader holding the cq */
>> +	if (attached)
>> +		synchronize_net();
>>  }
> 
> [Severity: Medium]
> Does this add one RCU grace period per CQ to every port teardown?
> 
> Every mana_en TX and RX CQ is attached to a parent EQ, and they are
> destroyed one at a time:
> 
> mana_dealloc_queues()
>   mana_destroy_txq()        /* loops over apc->num_queues */
>     mana_deinit_cq()
>       mana_gd_destroy_queue()
>         mana_gd_destroy_cq()
>           synchronize_net()
> 
> The same happens for each RX CQ through
> mana_destroy_rxqs()->mana_destroy_rxq().
> 
> These paths run under RTNL: mana_close(), and mana_detach() from
> ethtool -L/-G, MTU changes, XDP setup, and queue reset. Under RTNL,
> synchronize_net() does:
> 
>     if (from_cleanup_net() || rtnl_is_locked())
>         synchronize_rcu_expedited();
> 
> With MANA_MAX_NUM_QUEUES at 64, one teardown can run up to 128
> expedited grace periods back to back while RTNL is held.
> 
> The HWC path also waits twice: once here for its CQ, and once in the
> new synchronize_rcu() in mana_hwc_destroy_channel().
> 
> Could the child_cq[] and cq_table entries be cleared for all CQs first,
> with a single grace period before the queues are freed?
> 
> [ ... ]
> 
I will fix this in v4.

pw-bot: cr
