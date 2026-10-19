Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EA1F481641;
	Mon, 19 Oct 2026 08:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792399189; cv=none; b=kMZ7A9GjJYnckRgkXaG7Xds4Quo23ec8H6C+T4m75lTuYoBvczDbTQkRu21T5KJEQfIbSznR5ZucXBveXY6YSoqJgFNhW3naexgaSbICBRD9CBqLCoAicERagW+02sGgts4XpMKjtGkTD2ro+uJJslTBCAPv+wLTnBkFuf8qnRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792399189; c=relaxed/simple;
	bh=xmkBK6nT2CHtVPbOi2Q09ixzEOYZHXw/Q3ljrPHbFeM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FuodIrLPHqNzxwru5l96l1AGX1JlzAFN/oakUxJMKgTd+hCxF6VbP2WIqQutJNuzfY2ghYWeccywMuAwzkWaOfGNlSCTQzUkEZ4h4wPMIzjs6u+e+fCqzZQd+s/0txGHw55ofCUhYLOXTDq3ndFY9qL3OuUrhZYmo0caQgwkZOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=lOA28Bvb; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="lOA28Bvb"
Received: from [10.26.7.43] (unknown [4.213.232.21])
	by linux.microsoft.com (Postfix) with ESMTPSA id 0B92E20B7168;
	Mon, 19 Oct 2026 01:39:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0B92E20B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792399169;
	bh=f+80vBHLFi4oFrGve7Id4lDuk45EJXNBjrz+eGgB4J0=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=lOA28Bvb5GLpiR/bm804rRGdqvyVRZKaMMQMcajZ61dYc98z82Chl1W/MdLIKtcHr
	 ujr0QdeNJ8bO40znpGj8MrR3HJf+ReP0U2BxmZDqdEKgXogrCLl+KM6Tkl9rXHHIfF
	 vzBpwARJW/50Aw3B1j8J2jgp+OtU1ap1T1hObfDQ=
Message-ID: <63471f61-97ff-4cd9-9c45-3b737edd8e69@linux.microsoft.com>
Date: Mon, 19 Oct 2026 14:09:33 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2] net: mana: Add support to process throttled EQEs
To: sashiko-reviews@lists.linux.dev, linux-hyperv@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20261014134304.4177657-1-sahilchandna@linux.microsoft.com>
 <sashiko-outbox-172938@kernel.org>
Content-Language: en-US
From: Sahil Chandna <sahilchandna@linux.microsoft.com>
In-Reply-To: <sashiko-outbox-172938@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15-10-2026 19:13, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] net: mana: use-after-free of CQ during teardown due to RCU-001 removal ordering violation
> --
> 
> commit 4c00972dfa8283dfc036bc3bbb77031cb6550854
> Author: Sahil Chandna <sahilchandna@linux.microsoft.com>
> 
> net: mana: Add support to process throttled EQEs
> 
> When an event queue nears full, the hardware coalesces the per-CQ
> GDMA_EQE_COMPLETION notifications into a single throttle EQE (type 4)
> that carries no cq_id. The driver does not handle this event type, so
> it falls through to the default case and is dropped. Any CQ whose
> completion notification was replaced by the throttle EQE can remain
> unserviced, causing its queue to stall.
> 
> Link: https://lore.kernel.org/all/20261008083315.306076-1-sahilchandna@linux.microsoft.com/
> 
>> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
>> index ae0ed700b3b93..95ba6ba161ae2 100644
>> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
>> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> [ ... ]
>> @@ -1063,17 +1089,45 @@ static void mana_gd_create_cq(const struct gdma_queue_spec *spec,
>>  static void mana_gd_destroy_cq(struct gdma_context *gc,
>>  			       struct gdma_queue *queue)
>>  {
>> +	struct gdma_queue *eq = queue->cq.parent;
>> +	bool attached = false;
>>  	u32 id = queue->id;
>> +	u8 i;
>> +
>> +	if (eq) {
>> +		for (i = 0; i < GDMA_EQ_MAX_CHILD_CQ; i++) {
>> +			if (rcu_access_pointer(eq->eq.child_cq[i]) == queue) {
>> +				RCU_INIT_POINTER(eq->eq.child_cq[i], NULL);
>> +				attached = true;
>> +			}
>> +		}
>> +
>> +		if (attached)
>> +			synchronize_net();
>> +	}
>>  
>>  	if (id >= gc->max_num_cqs)
>>  		return;
> 
> [Severity: High]
> Does this code order the CQ removal and grace period correctly to prevent
> a use-after-free?
> 
> Looking at the rest of mana_gd_destroy_cq(), gc->cq_table[id] is cleared
> after the synchronize_net() grace period ends:
> 
> drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_destroy_cq() {
> 	if (eq) {
> 		...
> 		if (attached)
> 			synchronize_net();
> 	}
> 
> 	if (id >= gc->max_num_cqs)
> 		return;
> 
> 	if (!gc->cq_table[id])
> 		return;
> 
> 	gc->cq_table[id] = NULL;
> }
> 
> Because gc->cq_table[id] remains published during and immediately after
> the grace period, can a concurrent or delayed interrupt processing
> GDMA_EQE_COMPLETION in mana_gd_process_eqe() still find the CQ?
> 
> drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_process_eqe() {
> 	case GDMA_EQE_COMPLETION:
> 		...
> 		cq = gc->cq_table[cq_id];
> 		...
> 		if (cq->cq.callback)
> 			cq->cq.callback(cq->cq.context, cq);
> }
> 
> If a new reader accesses the CQ from gc->cq_table after synchronize_net()
> returns, but before the caller mana_gd_destroy_queue() frees the memory via
> kfree(), could it lead to a use-after-free crash?
> 
> Should the clearing of gc->cq_table[id] happen before calling
> synchronize_net() so all reader-visible references are removed before
> waiting for the grace period?
> 
The cq_table dereferencing race is real between mana_gd_destroy_cq and
in GDMA_EQE_COMPLETION. I will address this re-ordering and if there are
any other comments on this patch in v3.
