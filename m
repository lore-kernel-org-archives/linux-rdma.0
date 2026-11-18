Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794987868;
	b=lRR639the0Sfg7/GGkYgRoBKEsSaQvq7qAHPkW9mQZXI5hFi+s23TtTd7zUTxFdxLnQ7
	 mmZBo6aGvca0zHc3HDAkpTOSISmWPQnDORjUk6g4N1loClTv4gIov5sxLsu+2wnXP78RS
	 u0Exw2nSu7IVj3r1nwRx0ymugNxSPwDWqMWAKK3lOXfuWnhtQuOrNyEqHXdfyaRM2o8QQ
	 TWxQ6eDRXVwkDmWHU5TKb204OHHVS2cg4r1lBEpaVkPxt2ImI476p4NCo9IDPjcgSE5Nx
	 iFnjku9oIVPvXT4xsP0FN9sBg3QRrlRjgLE1C2x0s1SfI55qPQ+Ul5d4xO3vp6QARsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794987868;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=gX7kzTJMGEgUilvfYAhS+WHhKveX5bpbpbQGBDJ6GaE=;
	b=LGdjmi/WvJr/UjifpwP9I3l1LOUeh4RD+aHvNmrGBrfZG4x39jAIOoJo1AoiY8XjxHmH
	 6/0uU2VF75jUpVOEBR2zWf8KJ0lqjKSSAjB7yl/WlS3BN2T8Lru/HVtZ1IfeQwr4ur38x
	 fsp6vxFx9/0Y52VxqRFdu3l64/kcTmF+zdOiRRiUSO+HEO7LYFEMfFEV/psJ38nquCqWm
	 G3xcHYHNOo9RdN7Uket4SvdtHJMAj7alqnes3Rxy464SDs29dV9AbuYA7GBsxhR66eW2E
	 mpMjFXinsqTwkpgM38QlKEIjpA/AU28lhYbQvbBkd/rLDiZCyfp8T2fcvAN8rnr6VpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=Pdgk9FT3;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87B33606A325;
	Wed, 18 Nov 2026 07:44:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87B33606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=Pdgk9FT3
Received: from [10.26.7.43] (unknown [4.213.232.16])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5C30920B7169;
	Tue, 17 Nov 2026 23:44:26 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5C30920B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794987867;
	bh=gX7kzTJMGEgUilvfYAhS+WHhKveX5bpbpbQGBDJ6GaE=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=Pdgk9FT33bNeYIK2fpQ2c6t3bvmQpYWDnMgKtelx/ESt4qrvGoOCQ086hbaAfqf9O
	 jMb3xi/mqSf4fJJi+VyK2HqrCcPV+x8V2SAVORwYA+5fZdT/3G9ldtpjDLBrxwtA5J
	 A6qk9AGgrRkXT15QSqtbcTw9ajvNdDN34NH/xt3I=
Message-ID: <1b7ff0e0-a607-49e4-a14b-be95a726e0a8@linux.microsoft.com>
Date: Wed, 18 Nov 2026 13:14:24 +0530
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
Subject: Re: [PATCH net v3] net: mana: Avoid waiting on dead HWC after device
 reset
To: sashiko-reviews@lists.linux.dev, linux-hyperv@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20261112085226.878780-1-sahilchandna@linux.microsoft.com>
 <sashiko-outbox-212474@kernel.org>
Content-Language: en-US
From: Sahil Chandna <sahilchandna@linux.microsoft.com>
In-Reply-To: <sashiko-outbox-212474@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 13-11-2026 14:22, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] net: mana: premature TX NAPI deletion in
>   mana_dealloc_queues()
> --
> 
> commit d359cd9ade3de8d4713c17d8d3e7c311b5d6d28c
> Author: Sahil Chandna <sahilchandna@linux.microsoft.com>
> 
> net: mana: Avoid waiting on dead HWC after device reset
> 
> This commit replaces the sleep-based TX drain in mana_dealloc_queues()
> with synchronous CQ polling and marks the hardware channel dead after a
> device reset so subsequent HWC commands fail fast.
> 
>> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
>> index 38249e092090a..739021aa09b38 100644
>> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
>> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> 
> [ ... ]
> 
>> @@ -3799,42 +3809,110 @@ static int mana_dealloc_queues(struct net_device *ndev)
> 
> [ ... ]
> 
>>  		for (i = 0; i < apc->num_queues; i++) {
>> +			struct napi_struct *napi;
>> +			struct mana_cq *tx_cq;
>> +
>> +			if (!apc->tx_qp[i])
>> +				continue;
>> +
>> +			tx_cq = &apc->tx_qp[i]->tx_cq;
>> +			napi = &tx_cq->napi;
>> +
>>  			txq = &apc->tx_qp[i]->txq;
>>  			while ((skb = skb_dequeue(&txq->pending_skbs))) {
>>  				mana_unmap_skb(skb, apc);
>>  				dev_kfree_skb_any(skb);
>>  			}
>>  			atomic_set(&txq->pending_sends, 0);
>> +
>> +			if (txq->napi_initialized) {
>> +				netif_napi_del_locked(napi);
>> +				txq->napi_initialized = false;
>> +			}
>>  		}
>>  	}
> 
> [Severity: Medium]
> Does deleting the TX NAPI and clearing txq->napi_initialized here run too
> early, before mana_destroy_txq() destroys the SQ object and detaches the
> TX CQ?
> 
> At this point in mana_dealloc_queues(), the SQ object is still alive and
> tx_cq.gdma_cq remains published in gc->cq_table[] and eq->eq.child_cq[]
> while mana_disable_vport_rx(), mana_fence_rqs(), mana_destroy_rxqs() and
> mana_destroy_wq_obj() run, so a completion or GDMA_EQE_THROTTLE event on
> the shared EQ can still call mana_schedule_napi() on the deleted
> napi_struct.
> 
> Clearing txq->napi_initialized here also causes mana_destroy_txq() to skip
> its post-mana_destroy_wq_obj() detach block:
> 
> drivers/net/ethernet/microsoft/mana/mana_en.c:mana_destroy_txq() {
>     ...
> 		if (apc->tx_qp[i]->tx_object != INVALID_MANA_HANDLE)
> 			mana_destroy_wq_obj(apc, GDMA_SQ, apc->tx_qp[i]->tx_object);
> 
> 		if (apc->tx_qp[i]->txq.napi_initialized) {
> 			/* Detach the CQ only after the WQ object is destroyed,
> 			 * so a completion EQE that arrives before then still
> 			 * finds the CQ in cq_table[] rather than hitting the
> 			 * WARN in mana_gd_process_eqe(). One grace period then
> 			 * covers both mana_gd_intr() and NAPI users.
> 			 */
> 			mana_gd_detach_cq(gc, apc->tx_qp[i]->tx_cq.gdma_cq);
> 			netif_napi_del_locked(napi);
> 			apc->tx_qp[i]->txq.napi_initialized = false;
> 		}
> 
> 		mana_deinit_cq(apc, &apc->tx_qp[i]->tx_cq);
>     ...
> }
> 
> Because mana_gd_detach_cq() is skipped there, mana_deinit_cq() ->
> mana_gd_destroy_queue() -> mana_gd_destroy_cq() has to detach the CQ and
> wait for a second synchronize_net() grace period for every TX queue under
> rtnl_lock.  Leaving netif_napi_del_locked() and txq->napi_initialized =
> false to mana_destroy_txq() (and guarding the redundant napi_disable_locked()
> in mana_destroy_txq()) would avoid both issues.
In v4, I have removed this and is handled in mana_destroy_txq as was
originally.
> 

