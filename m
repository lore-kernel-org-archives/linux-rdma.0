Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECD4C3B8105;
	Mon, 12 Oct 2026 06:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791787824; cv=none; b=oRCyJP45qLDC/ninBP1jsVylx6nLpHFKw+9Q4xAQ5v0Oe3lMgJQwyNlv4zt9APEBs/tLRTH3znBixntCaNoCr+lhuGvm5Jo9d7rAia9Dr/YRZDznsRfFQmu7p5GfG9pOvyj5LsbtxrEq9StoZEb70G7E3f3zxHZAcw+uxm8CQBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791787824; c=relaxed/simple;
	bh=egOGF2YMkY84SdQDfFHKr5RvMlJFcDVp/9ho6j2nLyM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YC0R5QQ5TVfRH+gq6GEcldJCZgq9cww0c4FbzHq5pqBA67Uxukiw05lIoP2hGyUt6g4WDrYOW3eDDVEsWLPQYv7wsD8hrY/PC7jF4JgqZ/lrd6kqoW7pNj1ulRMZkWQZQGiQuXIAYu9Z9if1VK+GOjzj7mA/4Jx5xmp61TAoHGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=VMT2kDNf; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="VMT2kDNf"
Received: from [10.26.7.43] (unknown [4.213.232.22])
	by linux.microsoft.com (Postfix) with ESMTPSA id 858EC20B7166;
	Sun, 11 Oct 2026 23:50:18 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 858EC20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791787819;
	bh=+9iUhCEphPPg92ggxJrYeydbG+8hPQiyIc2GjHpFHhk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VMT2kDNfdSpfat5+iShIN0Ec0JtqA/xMw+bZIn+9cvA5iQg5HzG+wMeLNBOwX1g/X
	 0RG8g7HaaINYVaxxa1UBmq3fZZ7+YFKvkIKYwQ70TqWXPLpzC6d7uHbevsJTELBQot
	 9bRkJ+wIJVmQw7F0CZXczCyQXvD/nGUIpQ2LVL28=
Message-ID: <b884be07-3e76-4256-a8e6-70b8540ab492@linux.microsoft.com>
Date: Mon, 12 Oct 2026 12:20:18 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] net: mana: Add support to process throttled EQEs
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
 weh@linux.microsoft.com
References: <20261008083315.306076-1-sahilchandna@linux.microsoft.com>
 <sashiko-outbox-165094@kernel.org>
Content-Language: en-US
From: Sahil Chandna <sahilchandna@linux.microsoft.com>
In-Reply-To: <sashiko-outbox-165094@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 09-10-2026 14:03, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] mana: RDMA queue stalls due to dropped throttle events
> --
> 
> commit 49b4827fa426b6ae0b8759a5984d01f44b8db5e1
> Author: Sahil Chandna <sahilchandna@linux.microsoft.com>
> 
> net: mana: Add support to process throttled EQEs
> 
> This commit adds support for processing throttled EQEs of type 4 when an
> event queue nears full capacity. The driver advertises the
> GDMA_DRV_CAP_FLAG_1_THROTTLED_EVENT_QUEUE capability and attempts to schedule
> the CQs associated with a throttled EQE. CQs are tracked in a new child_cq
> array initialized when creating a CQ.
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
> 
> [Severity: High]
> When a GDMA_EQE_THROTTLE event is processed, this function attempts to notify
> the CQs. Will RDMA CQs receive these notifications?
> 
> RDMA CQs do not appear to be added to child_cq, which might cause their
> notifications to be entirely dropped and result in RDMA queue stalls.
> 
>> +	}
>> +}
>> +
> 

The issue for RDMA CQ handling were highlighted in internal AI reviews
as well and I discussed this with Wei Hu from RDMA about this.

Before the patch, all throttled EQEs were getting dropped, the patch
aims to address this gap by handling the throttled EQE which were
reproduced in internal testing.The RDMA side throttling is going to be
handled separately by Wei.

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
> 
> [Severity: High]
> Does this logic handle RDMA CQs correctly?
> 
> RDMA CQs are created with a NULL parent_eq (via mana_ib_create_kernel_queue),
> which causes this function to return early without populating the child_cq
> array.
> 
> Additionally, if an EQ has more than GDMA_EQ_MAX_CHILD_CQ (which is 2) CQs
> attached, which is common in RDMA workloads, this loop will silently return
> without adding the additional CQs. Can this lead to lost completions?
> 
>>  }
> 
The handling of RDMA CQ and attaching to parent EQ will be done in
separate series, as discussed.> [ ... ]
> 
>> diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
>> index c610fc1067e0d..03fe9395604d6 100644
>> --- a/include/net/mana/gdma.h
>> +++ b/include/net/mana/gdma.h
>> @@ -776,7 +785,8 @@ enum {
>>  	 GDMA_DRV_CAP_FLAG_1_HANDLE_STALL_SQ_RECOVERY | \
>>  	 GDMA_DRV_CAP_FLAG_1_EQ_MSI_UNSHARE_MULTI_VPORT | \
>>  	 GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION | \
>> -	 GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS)
>> +	 GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS | \
>> +	 GDMA_DRV_CAP_FLAG_1_THROTTLED_EVENT_QUEUE)
> 
> [Severity: High]
> Since this patch globally advertises throttling support, the hardware might
> send throttle events on RDMA EQs when they are heavily loaded.
> 
The cap bit does not enable throttle events. The device generates
THROTTLE EQEs for any EQ created with throttle_limit, whether or not the
driver sets cap bits so the RDMA throttle would not be a consequence of
this patch.

> Given that RDMA EQs are initialized with a log2_throttle_limit in
> mana_ib_create_eqs(), will enabling this capability cause RDMA workloads to
> stall if their throttle events are dropped due to the missing child_cq mapping
> in mana_gd_create_cq()?
> Yes, it is possible but it is not tied to capability bits, and handling
of RDMA throttled events is a planned task to be handled in separate
series.

Regards,
Sahil
