Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655977;
	b=QzBLRJCvlEHspyOi0VYaYArbUeyvf/gyhP29vhXyFwH9HP6Y4W6hzWVbcR0vIsp84cfh
	 lIv4l7+FWOC7JkEcSsY1j5G+x2bwHk1rmT+Q+G231o6XbTK6ZI51dVfAWuqUpw6lJZe2M
	 eqa2NgZqjoYJ/ZnMKTO4Rza62p09++1dzZBeqWM54+mXRMI32N97xDh5lUYZL8kQ8Fdz/
	 PlEmcHnDKmJ42YAN66grkRbbUd5ngsRB7MKv1LloRKwZyPgCzTgMXLvOosA/Y1VERi74M
	 HEtPvYBUrVQe5UP/WB9pzQqPGvz8sqBisHBZQ+bVHjq4NfB2YfewwqS7lMZMDtbLAtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655977;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=FJPSwS1dKDAOqkSA6MWiKD6GwRfZLBYjMISnGkKuJ+c=;
	b=KhNgSPxGwr360ODpgv/fDKQxRuwMARApWqUJ7AJmpInQ9CVVCCzitNhlNG9xJz13heDR
	 NIS/gnAZTr+PAKnWyag4Q3K6NWQd13kYfWu03s9yNL8RfNmngLz6fFpv03dKB/Vtfw0Hu
	 w1P1niK22Y2TE8EnGUpem2O5WGcTeJGvqE2+LnkjvEtSKofhkwGQAs5BNUsZt3pft692T
	 x5CPgeW2dgxhWDvsNxrNG0x6WUblPBmsaMNQqiRqhREHqUADGmM+bAxF7J+GLF63TttxD
	 ebxBty07z+FwD385XZjMPERtzSb05NQ5cTNVlvc9uSJlZO8+N6P4TrfO3TIh/V1qklQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="C5OXb/sc";
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=bBY+q+Jb;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC95606A329
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 21:46:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9AC95606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=C5OXb/sc;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=bBY+q+Jb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793655975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FJPSwS1dKDAOqkSA6MWiKD6GwRfZLBYjMISnGkKuJ+c=;
	b=C5OXb/scUI6lDM32iI3IXS+geTXgkSyFEjMPbOeyx3ZfE7l2mDRp7rNdSsQSQoLG/QdkL9
	jP/A2G1X/tn+8DMjflRHHD1D2MLLPtom8BcUnouH0UgPOWv6e5bPeunsL97cvYTRPNmpOx
	vB0lkCxJuUvRsKkUw+MZVSZ6fkwcCZA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-dzOKGR_PPOW827K83g-F1g-1; Mon, 02 Nov 2026 16:46:14 -0500
X-MC-Unique: dzOKGR_PPOW827K83g-F1g-1
X-Mimecast-MFC-AGG-ID: dzOKGR_PPOW827K83g-F1g_1793655973
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a77c1cbd15so34683025e9.0
        for <linux-rdma@vger.kernel.org>; Mon, 02 Nov 2026 13:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793655973; x=1794260773; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FJPSwS1dKDAOqkSA6MWiKD6GwRfZLBYjMISnGkKuJ+c=;
        b=bBY+q+Jbl1OsCdVUPAc3TLlm2ZdLn1POJ2xcKXxLkIiOMLhO4zTl1hwKgrbW7uigE0
         RWcL9DiLQ8STUShPfY11USg/VkHDKRamOPGCCwcRzv8Hwvd70OBGKLHtdJ9fCHRS5xy2
         /0SOsMST8FHpmdI5w1RBs/9u7XncRx8M32gyWSelaIYH3Ep22HJLtxyVE0jq7OQwMNpv
         ZmESJxWKu6Sd9HoWN50IQMeXDhnaRZLKxkRr35beuX1tKa5myRlLfqKIlgm5CcyaLptO
         IiQR6ns+//XRSJ+N+vYW7tTYU/KHwBqr3pYJmEtMDJFY91/0VJfCSbMEeSXkIFH9Xq/W
         vrDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793655973; x=1794260773;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FJPSwS1dKDAOqkSA6MWiKD6GwRfZLBYjMISnGkKuJ+c=;
        b=X0qDnGwAgL3+GXawZVe+XbTLTiZtyMr6VXR63W3DMtu7pQ+JCnr/mquvO7Z4GefcLe
         NM+yumVg/Dm9NhnViwPnom4rfJqD0Ez/QSCV+v7HSkXsDVoSx6SWmwby3EKNRk3kAzS7
         +cTMOP7XsjBFiHFYbG/JybzSYL53YZ5p1G4w8yC8TJSGwjgzAzfSOOuii/dWiuw4HwmA
         P+Pc9eL+IYZ3AmKpqD3SS4T/4r2jnI2J0wlxII0H2KHA5fiVOVvJcYXnjoydLydeIkV4
         kMd7+lBlQG358n3J/yaozNszp5FPh1qI6rZpbReux+TadqFjPaYP++lGIdpBZ10oTJy7
         RvWA==
X-Forwarded-Encrypted: i=1; AKwUvBzmwCW+zJ/ndOfkMLaNI2eb4Q9PH+az+/gebwlLYlyhRBVtT5Tn0ZriQ0CxQEzdxc38syBWs7EbLUsz@vger.kernel.org
X-Gm-Message-State: AFq9FYKIjsH5T7ZiAcEAj3w19FJIfSgq3bgEgxze1FIhtVSfUYnQ/kDh
	8Y3cKcaRHM/hX/L5U+ldCy4hf6zVVa+asqk4xvcmXWOFDSODl8xE3PKcoXJF57Q5u2rGj2TjhSh
	Rn0/Fv0ilOZHA1N+t2/oDJ7LBBAmoOvVKdjc0cHQp6gCvyPpWBPlsh8+VRDDHnmw=
X-Gm-Gg: AYBFou2zwiZPqhD+9anHYAiSdWja5Iag6PnOxm3CETMQWfqY2/A0yQJWjV2lype/1MW
	kcP7EPquSyixcXnwbhQhXX1c9VEVofaeOBKCVJVLaaNAy0ua55PcpeUV4QoiFVcizulG3MhhNkN
	49H4ucKBosiYaFCd4ELTqtR1yRpje2P2elLFB3v7MNZeEKxqB0zXjUVEk1LuEP+f8cAPYHniSgu
	/nmsVgos7tIUlCLwyG120zERR0Cj2HV+lZscGa6cxSYe40vXZQeeT8uBqBAisayOp0D1AHKGKK1
	nGIXq+BP2riKWjR1xz9uZlWzGmzpp5o7/Msn8JiEqy+NUXlQ1RnbSsgNc72JBZXOWxM0Z4MqunK
	8kMx9Uf55jNqT6eD/dzXKb9mglH47oDHghFHHfIbTdkmOqIpFXKQ2/VH44pExAOYZM7R13dNbPA
	yyiMQJorjvJuNglFBWL5oMxa/ZHjZNiIejzoC82JK1LOE=
X-Received: by 2002:a05:600c:848a:b0:4a3:59c9:a756 with SMTP id 5b1f17b1804b1-4ac17b2ce84mr286349235e9.6.1793655973261;
        Mon, 02 Nov 2026 13:46:13 -0800 (PST)
X-Received: by 2002:a05:600c:848a:b0:4a3:59c9:a756 with SMTP id 5b1f17b1804b1-4ac17b2ce84mr286348985e9.6.1793655972889;
        Mon, 02 Nov 2026 13:46:12 -0800 (PST)
Received: from [192.168.88.29] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ac09ad5ff8sm207221675e9.4.2026.11.02.13.46.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 13:46:12 -0800 (PST)
Message-ID: <07a21553-8ab1-4478-8a22-b1a13e70faba@redhat.com>
Date: Mon, 2 Nov 2026 22:46:10 +0100
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
To: netdev-bot+sashiko@kernel.org, sahilchandna@linux.microsoft.com
Cc: haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, kotaranov@microsoft.com, horms@kernel.org,
 ernis@linux.microsoft.com, gargaditya@linux.microsoft.com,
 mawasthi@linux.microsoft.com, leitao@debian.org,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 stable@vger.kernel.org
References: <20261028084020.2051254-1-sahilchandna@linux.microsoft.com>
 <179352349805.3131.9139142774275348324@kernel.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <179352349805.3131.9139142774275348324@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/1/26 09:58, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 (1) · Medium: 0 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] The patch tells firmware that every EQ on the function handles
>    throttled EQEs.
> - [Low] The patch marks only one side of the concurrent accesses.
> 
> Pre-existing issues:
> - [High] mana_gd_destroy_cq() waits for a grace period
>    (synchronize_net()) only when mana_gd_detach_cq() returns true,…
> 
> --
> 
> net: mana: Add support to process throttled EQEs
> 
> This commit handles GDMA_EQE_THROTTLE events. It records up to two child
> CQs per EQ and calls their callbacks when a throttle EQE arrives. CQ
> teardown now detaches the CQ from its parent EQ and from cq_table[]
> before a grace period. The patch also advertises a new capability bit and
> adds a per-EQ throttle counter to ethtool stats.
> 
>> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
>> index 8c915e0087846..ab942d5bfe058 100644
>> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
>> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
>> @@ -757,6 +757,27 @@ void mana_gd_free_service_wq(struct gdma_context *gc)
>>   	gc->service_wq = NULL;
>>   }
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
> 
> [Severity: Low]
> This patch marks only the write side. mana_gd_detach_cq() clears
> gc->cq_table[id] with WRITE_ONCE(), and mana_hwc_destroy_channel() now
> sets gc->max_num_cqs with WRITE_ONCE().
> 
> The readers still use plain loads. Here that means gc->cq_table and
> gc->cq_table[cq->id]. The GDMA_EQE_COMPLETION branch of
> mana_gd_process_eqe() also reads both fields without READ_ONCE():
> 
> 	if (WARN_ON_ONCE(cq_id >= gc->max_num_cqs))
> 		break;
> 
> 	cq = gc->cq_table[cq_id];
> 
> Could KCSAN report these as data races? Should the readers use
> READ_ONCE() to pair with the marked writers?
> 
> This is mostly an annotation issue. The completion-path race was already
> there before this patch, and the loads in mana_gd_schedule_eq_cqs() only
> compare the pointer value.
> 
>> +
>> +		if (cq->cq.callback)
>> +			cq->cq.callback(cq->cq.context, cq);
>> +	}
>> +}
> 
> [ ... ]
> 
>> @@ -1073,25 +1104,66 @@ static void mana_gd_create_cq(const struct gdma_queue_spec *spec,
>>   			      struct gdma_queue *queue)
>>   {
>>   	u32 log2_num_entries = ilog2(spec->queue_size / GDMA_CQE_SIZE);
>> +	struct gdma_queue *parent;
>> +	u8 i;
>>   
>>   	queue->head |= INITIALIZED_OWNER_BIT(log2_num_entries);
>> -	queue->cq.parent = spec->cq.parent_eq;
>> +	parent = spec->cq.parent_eq;
>> +	queue->cq.parent = parent;
>>   	queue->cq.context = spec->cq.context;
>>   	queue->cq.callback = spec->cq.callback;
>> +
>> +	if (!parent)
>> +		return;
>> +
>> +	/* For throttled EQE store the child CQ */
>> +	for (i = 0; i < GDMA_EQ_MAX_CHILD_CQ; i++) {
>> +		if (!rcu_access_pointer(parent->eq.child_cq[i])) {
>> +			rcu_assign_pointer(parent->eq.child_cq[i], queue);
>> +			return;
>> +		}
>> +	}
>> +
>> +	WARN_ONCE(1, "mana: EQ %u has no free child CQ slot\n", parent->id);
>>   }
> 
> [Severity: High]
> Do mana_ib CQs ever end up in child_cq[]?
> 
> This is the only place that writes child_cq[], and it returns early when
> spec->cq.parent_eq is NULL. mana_ib_create_kernel_queue() uses a zeroed
> spec:
> 
> drivers/infiniband/hw/mana/main.c:mana_ib_create_kernel_queue() {
> 	struct gdma_queue_spec spec = {};
> 	...
> 	err = mana_gd_create_mana_wq_cq(mdev->gdma_dev, &spec, &queue->kmem);
> 	...
> }
> 
> mana_ib_gd_create_cq() then binds the RNIC CQ in hardware to an mana_ib
> EQ:
> 
> 	req.eq_id = mdev->eqs[cq->comp_vector]->id;
> 
> mana_ib_install_cq_cb() adds it only to gc->cq_table[].
> 
> mana_ib_create_qp_rss() and mana_ib_create_qp_raw() attach raw and RSS
> QP CQs to the per-vPort mana_en EQs:
> 
> 	eq = &mpc->eqs[cq->comp_vector % mpc->num_queues];
> 	cq_spec.attached_eq = eq->eq->id;
> 
> These CQs are also registered only through mana_ib_install_cq_cb().
> 
> The patch also adds GDMA_DRV_CAP_FLAG_1_THROTTLED_EVENT_QUEUE to
> GDMA_DRV_CAP_FLAGS1, which mana_gd_verify_vf_version() sends for the
> whole function.
> 
> Suppose hardware folds one of these CQs' completions into a
> GDMA_EQE_THROTTLE. mana_gd_schedule_eq_cqs() walks child_cq[], which is
> empty on mdev->eqs and holds only the mana_en TX and RX CQs on mpc->eqs.
> mana_ib_cq_handler() never runs, and nothing polls or re-arms the CQ.
> 
> Wouldn't that stall the RDMA CQ the same way the commit message
> describes for TX?
> 
> A fixed two-entry child_cq[] also cannot represent an EQ shared by many
> RDMA CQs on the same comp_vector.
> 
> The commit message says:
> 
>    "A mana_en EQ serves one TX CQ and one RX CQ, and the HWC EQ serves
>    the HWC CQ."
> 
> Is that still true once raw QPs attach CQs to mpc->eqs?
> 
> If advertising the bit is what turns on throttle EQEs, this patch adds a
> new RDMA stall. If it is not, the RDMA case stays unfixed. Could the
> commit message cover mana_ib in either case?
I understand from discussion on v3 that this will be handled separately,
am I correct?

/P

