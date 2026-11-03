Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718949;
	b=Bd0pTxJ+SyitDYnyRsv14irxfjYSluXSOBUuV9FmSdUOsO2y1oVPnX295+hrR6pLqa6M
	 VIJb+M3wcS3khJYQiA8Psurb+lSoyojO/yNc2P84Xbz31GQY5efLtrfOQEpH1T8NvlNhW
	 qHammzg9XQv5eTRP0WWN27F1qbP9tJ15NlXqXXHD5LpbJQDxvlvB3A35gzSJI1CsXyhEX
	 ZgvTPLjWAdAzjHonTLJ9ZcgE2G8MbbO0W3PCRXTrRrhmj2tKon0IHsNB+ke/JVWzYvTQf
	 W27xTdWKE2GG9h/ODMQx8J0NOw0Wt0D3L+iMPh8fcBj1F1EmKzNOqMVbm65rufJJgng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718949;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=W0s7ZEWF8co8VYOGI85E38Dt868T5tqn4KMr7YPDLx4=;
	b=rfty5BZ36Y3jHjquGTMO1ZoFx3wEFGCs3qBaW3WV9EEK5vqMMdQIKsGOgrMdUQGBcRsl
	 xxuKdtdkkKGcnhASaftQoHsR46FIym/jFH5+e6LtsE613lpzdWTswpQM5D5G0bChPQpIy
	 Iroj/BrWl135rwm6fUlqRZH9e39WhpyVe48yTKn7d714qilP9edRFSkp4XgCZ1u7MbThy
	 96M6Yj2JNXxPzXo0NYJCpY+sMp+8UOX941eLdzMJlUnw4wByBdTy54QfzMRXbuDJczKS0
	 O3yA18XbL1kQeICSQnECaWoo8YS4ig0wwjVrjUehRYjFyRDgvILNH7S9PuSeLyszTmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=fb2BBPzZ;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98CAE6071A06;
	Tue,  3 Nov 2026 15:15:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98CAE6071A06
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=fb2BBPzZ
Received: from [10.26.7.43] (unknown [4.213.232.16])
	by linux.microsoft.com (Postfix) with ESMTPSA id 8D0D620B7166;
	Tue,  3 Nov 2026 07:15:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8D0D620B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793718933;
	bh=W0s7ZEWF8co8VYOGI85E38Dt868T5tqn4KMr7YPDLx4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fb2BBPzZx0r364zjrBTyixV4UjCX9yqZab3TgOEp+I7KXTPdkLhH/d1Xh0WkpXyZj
	 2MOn5TigDJl4bxbuLWsQAALsgAva5eG1udYtFVcfDv+qYm+h57iZ/OUiOyNiDase4x
	 ZhqpG/21G6UdYzqMpkZ77Y8Q2m++FpWpsoQJYQeg=
Message-ID: <d8a49b6a-36b9-4ebb-9d26-b6ce58248ed7@linux.microsoft.com>
Date: Tue, 3 Nov 2026 20:45:40 +0530
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
Subject: Re: [PATCH net v4] net: mana: Add support to process throttled EQEs
To: Paolo Abeni <pabeni@redhat.com>, netdev-bot+sashiko@kernel.org
Cc: haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, kotaranov@microsoft.com, horms@kernel.org,
 ernis@linux.microsoft.com, gargaditya@linux.microsoft.com,
 mawasthi@linux.microsoft.com, leitao@debian.org,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 stable@vger.kernel.org, weh@linux.microsoft.com
References: <20261028084020.2051254-1-sahilchandna@linux.microsoft.com>
 <179352349805.3131.9139142774275348324@kernel.org>
 <07a21553-8ab1-4478-8a22-b1a13e70faba@redhat.com>
Content-Language: en-US
From: Sahil Chandna <sahilchandna@linux.microsoft.com>
In-Reply-To: <07a21553-8ab1-4478-8a22-b1a13e70faba@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 03-11-2026 03:16, Paolo Abeni wrote:
> On 11/1/26 09:58, netdev-bot+sashiko@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 2 potential
>> issue(s) to consider.
>>
>> Critical: 0 · High: 1 (1) · Medium: 0 · Low: 1
>>
>> If you believe none of the issues are legitimate, please reply to each
>> issue of Medium severity or higher and explain why the AI is wrong.
>> If any of them are legitimate and you plan to respin, please let patchwork
>> know by including "pw-bot: cr" as a separate line at the end of your reply
>> (one such reply per series is enough).
>>
>> - [High] The patch tells firmware that every EQ on the function handles
>>    throttled EQEs.
>> - [Low] The patch marks only one side of the concurrent accesses.
>>
>> Pre-existing issues:
>> - [High] mana_gd_destroy_cq() waits for a grace period
>>    (synchronize_net()) only when mana_gd_detach_cq() returns true,…
>>
>> --
>>
>> net: mana: Add support to process throttled EQEs
>>
>> This commit handles GDMA_EQE_THROTTLE events. It records up to two child
>> CQs per EQ and calls their callbacks when a throttle EQE arrives. CQ
>> teardown now detaches the CQ from its parent EQ and from cq_table[]
>> before a grace period. The patch also advertises a new capability bit and
>> adds a per-EQ throttle counter to ethtool stats.
>>
>>> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
>>> index 8c915e0087846..ab942d5bfe058 100644
>>> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
>>> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
>>> @@ -757,6 +757,27 @@ void mana_gd_free_service_wq(struct gdma_context *gc)
>>>   	gc->service_wq = NULL;
>>>   }
>>>   
>>> +static void mana_gd_schedule_eq_cqs(struct gdma_queue *eq)
>>> +{
>>> +	struct gdma_context *gc = eq->gdma_dev->gdma_context;
>>> +	struct gdma_queue *cq;
>>> +	u8 i;
>>> +
>>> +	for (i = 0; i < GDMA_EQ_MAX_CHILD_CQ; i++) {
>>> +		cq = rcu_dereference(eq->eq.child_cq[i]);
>>> +
>>> +		if (!cq)
>>> +			continue;
>>> +
>>> +		if (cq->id >= READ_ONCE(gc->max_num_cqs) ||
>>> +		    !gc->cq_table || gc->cq_table[cq->id] != cq)
>>> +			continue;
>>
>> [Severity: Low]
>> This patch marks only the write side. mana_gd_detach_cq() clears
>> gc->cq_table[id] with WRITE_ONCE(), and mana_hwc_destroy_channel() now
>> sets gc->max_num_cqs with WRITE_ONCE().
>>
>> The readers still use plain loads. Here that means gc->cq_table and
>> gc->cq_table[cq->id]. The GDMA_EQE_COMPLETION branch of
>> mana_gd_process_eqe() also reads both fields without READ_ONCE():
>>
>> 	if (WARN_ON_ONCE(cq_id >= gc->max_num_cqs))
>> 		break;
>>
>> 	cq = gc->cq_table[cq_id];
>>
>> Could KCSAN report these as data races? Should the readers use
>> READ_ONCE() to pair with the marked writers?
>>
>> This is mostly an annotation issue. The completion-path race was already
>> there before this patch, and the loads in mana_gd_schedule_eq_cqs() only
>> compare the pointer value.
>>
>>> +
>>> +		if (cq->cq.callback)
>>> +			cq->cq.callback(cq->cq.context, cq);
>>> +	}
>>> +}
>>
>> [ ... ]
>>
>>> @@ -1073,25 +1104,66 @@ static void mana_gd_create_cq(const struct gdma_queue_spec *spec,
>>>   			      struct gdma_queue *queue)
>>>   {
>>>   	u32 log2_num_entries = ilog2(spec->queue_size / GDMA_CQE_SIZE);
>>> +	struct gdma_queue *parent;
>>> +	u8 i;
>>>   
>>>   	queue->head |= INITIALIZED_OWNER_BIT(log2_num_entries);
>>> -	queue->cq.parent = spec->cq.parent_eq;
>>> +	parent = spec->cq.parent_eq;
>>> +	queue->cq.parent = parent;
>>>   	queue->cq.context = spec->cq.context;
>>>   	queue->cq.callback = spec->cq.callback;
>>> +
>>> +	if (!parent)
>>> +		return;
>>> +
>>> +	/* For throttled EQE store the child CQ */
>>> +	for (i = 0; i < GDMA_EQ_MAX_CHILD_CQ; i++) {
>>> +		if (!rcu_access_pointer(parent->eq.child_cq[i])) {
>>> +			rcu_assign_pointer(parent->eq.child_cq[i], queue);
>>> +			return;
>>> +		}
>>> +	}
>>> +
>>> +	WARN_ONCE(1, "mana: EQ %u has no free child CQ slot\n", parent->id);
>>>   }
>>
>> [Severity: High]
>> Do mana_ib CQs ever end up in child_cq[]?
>>
>> This is the only place that writes child_cq[], and it returns early when
>> spec->cq.parent_eq is NULL. mana_ib_create_kernel_queue() uses a zeroed
>> spec:
>>
>> drivers/infiniband/hw/mana/main.c:mana_ib_create_kernel_queue() {
>> 	struct gdma_queue_spec spec = {};
>> 	...
>> 	err = mana_gd_create_mana_wq_cq(mdev->gdma_dev, &spec, &queue->kmem);
>> 	...
>> }
>>
>> mana_ib_gd_create_cq() then binds the RNIC CQ in hardware to an mana_ib
>> EQ:
>>
>> 	req.eq_id = mdev->eqs[cq->comp_vector]->id;
>>
>> mana_ib_install_cq_cb() adds it only to gc->cq_table[].
>>
>> mana_ib_create_qp_rss() and mana_ib_create_qp_raw() attach raw and RSS
>> QP CQs to the per-vPort mana_en EQs:
>>
>> 	eq = &mpc->eqs[cq->comp_vector % mpc->num_queues];
>> 	cq_spec.attached_eq = eq->eq->id;
>>
>> These CQs are also registered only through mana_ib_install_cq_cb().
>>
>> The patch also adds GDMA_DRV_CAP_FLAG_1_THROTTLED_EVENT_QUEUE to
>> GDMA_DRV_CAP_FLAGS1, which mana_gd_verify_vf_version() sends for the
>> whole function.
>>
>> Suppose hardware folds one of these CQs' completions into a
>> GDMA_EQE_THROTTLE. mana_gd_schedule_eq_cqs() walks child_cq[], which is
>> empty on mdev->eqs and holds only the mana_en TX and RX CQs on mpc->eqs.
>> mana_ib_cq_handler() never runs, and nothing polls or re-arms the CQ.
>>
>> Wouldn't that stall the RDMA CQ the same way the commit message
>> describes for TX?
>>
>> A fixed two-entry child_cq[] also cannot represent an EQ shared by many
>> RDMA CQs on the same comp_vector.
>>
>> The commit message says:
>>
>>    "A mana_en EQ serves one TX CQ and one RX CQ, and the HWC EQ serves
>>    the HWC CQ."
>>
>> Is that still true once raw QPs attach CQs to mpc->eqs?
>>
>> If advertising the bit is what turns on throttle EQEs, this patch adds a
>> new RDMA stall. If it is not, the RDMA case stays unfixed. Could the
>> commit message cover mana_ib in either case?
> I understand from discussion on v3 that this will be handled separately,
> am I correct?
> 
Yes, that is correct. I have discussed this already with Wei Hu for RDMA
CQ handling.

Regards,
Sahil
> /P

