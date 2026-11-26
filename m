Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795730062;
	b=IulJh/F3GTFtErfKgnZ64Yt9NlJ00BvaNqUL73hX7eNmFsRhwxCIgnER9jDOJPuWkbSm
	 qe0FbaUrW+Jc4ELgJskUEmIPnmCRbLEudcbU7LlVkutGCkdf5UDO2HfXZmYYYn87PVZWV
	 w/KYxqndNj89Q+O3+Yo4uQflC+Ss/46o0A/VtpwF9QS+6S6LmKhFIfDn4X5Mk5kMMM6Gw
	 PXAMfgMmGsCr6SFaxaqRUGx3j4WG2YUIYQ0DjulZ9W2GPseZq+j+EOEdhVj2K347imYE5
	 vEHbHQ537Gvm1hIJkrxx5IayBbI3nx3OHXNmwpvVu88NOuDxhqiLWw+kkP3lfcFtk2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795730062;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=C9eoWPo0266fGZF/sCeB0L6HWQh4fMh4NsSwHePxn+Q=;
	b=ncNAKOxIOCKIcDDuG7/mU5Iobk6UnkI2mEt4Rqxdl8sOlxRyEuf/nueVNQI9vV+lOIdU
	 enz94XLB2iHU9mWZ+1EwshHWE3j4CJII1xrWiUs4yISqXc2U+ewSP3LEFfXEPNulcCd5Q
	 QHi3tAl59IePKmwncfafOqakGmrL8LbVfuz0xr/da4Kv1ZojuwNWubqMshWoJKgt36HRA
	 bnpKQTnpWmcYDGlYgH4apPw6/LR0sNtVLKgYVzqAvgerjStNExf0+0hIvro/TwMtjbA+L
	 hOM2gIbNbI1YnQrQzDFvata6xJ6KUJqTpAXwjQlYjeSHpb4j8smqiHaFY6j8UFLt4+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Fj6TBBA7;
	arc=none smtp.remote-ip=74.125.82.177
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC01606A321
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 21:54:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CEC01606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Fj6TBBA7
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-386ab9ab619so9960861eec.1
        for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 13:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795730061; x=1796334861; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C9eoWPo0266fGZF/sCeB0L6HWQh4fMh4NsSwHePxn+Q=;
        b=Fj6TBBA7ILCX2x4gIIIEa8y179XZLUb4veMZLsESp2/Gk2/PfAnG2ytKFhECpm/S6b
         M1wBDPnHA+zm7/w35BbzRY6+RahedeiClhPUhCT0+txgLmXu+j9D1pTg4cNyICjJsU90
         KRoivPcTASO/H24guAjw6LEKNPXVkiOsDaRG5TYqNpKggVgS0sraL8ETnApSmYYmGTHT
         XPPl0+5Y9SSb70JleqbOQsto8QPTB9GgSRNDYZH52sYlNGJrq3O0sfDnU0LavEH2w81r
         81VbGyYtKEYwwu18V8ZYg3bWwsuxK4W28wETASXtl9oSwzpq04RgBNKH4FZwsBQAn2Ze
         ar5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795730061; x=1796334861;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C9eoWPo0266fGZF/sCeB0L6HWQh4fMh4NsSwHePxn+Q=;
        b=aNx2ZrKhunSKDGGuIbaOO4xVtBphLdg2kOAhSjBQWuVWrN8XiXEjCNLWCe1wVC6GE1
         /g2c+yWwO3ftiAorS6coUuxfZ7ehbgQZAl4rN4/KvEZhZh4bKTXetR702/pCvDYGG8JA
         p9lr4wtPXNsg6XCOtBG6a2ALJLhwt9JtxOMnXJqeU72vnU8SEuzJFBBqclH/15tzGlc2
         eO8eNXVZLAF/D4etmON1DSousavlMNZyG592rzXRkw7tCeWYH1f1u44eyVGnlqD1412u
         Tn3P1RS7ChsMTP5zqksXE9CMxWV7CwiluAJBXTWSoBptpTZuPyImuypz9IweF97qBp5p
         5sAg==
X-Forwarded-Encrypted: i=1; AL+hErHlwHIbT9OdFHVvR5vPetPlFEhQGx5aznetwF9THdGq+lIgxcvU7xmGaLsKlzZmDDP7Gt8u665IqkCf@vger.kernel.org
X-Gm-Message-State: APuU4Z+77rQMpvXo9VaJWPAAp2D52fu9v8tT9GrWVKvHPWJjEsLKJJmh
	LVmMycKckgQFA9tGEf0Fg9MBZfPsIm5PF6ymc4K5dvfbmAYTzU8h1XAy
X-Gm-Gg: AZFdTZehpuC8l2tF2DFCvgP/MCwlUFuXKuxmGGNoFnZfqgQoIVUwzZ6y8AviI5a4N9Z
	PrMK78cJKyBWv29+cz0xm9AGiN4Gm+XxtEHNdx0pCRMMr1wADV7byP97jBEczKUxCR6/mgDdPx4
	kLN90eFZwGfHtwl9RTUUGRqsSjHRFnnF728MzyXG/Lccq0R7GaWtOvoEA7EmEOIlzaiATqrWbQb
	NnrEjTdPNooYFPG8vfph6QoPu3Qitjvrehp2nyZeZrEef5TjomGHj/Hjq+1a1o5cVERNE2X1v2t
	W/ujgzgsf92ZVJPoZwQBNjSqBdnfCOGMptWzF1RBDeBnGvqZXWlB62SDTaf27SBt9s8r3TLyy6b
	5Qd/+bt9ztqbXO1lxorw107fx3xPPtCPn18d8s2J91aH2Q95IFBkVceRikug/rl3DVvRh5GliXN
	I72AowQL7jjg5BwxT6XZS7pHrJsDyhn+EKGWvzlS6iA0T30ES1lQhkJVTVo7ldinB5rNjAU1Zsq
	wb9g8SbwAlloLOx3QCM/d2waIlVxwqAQQKwkY/i2AJFtdR1kaTk5NitTWL6xwOafIrFgoyyaMdI
	sYE5DwMgybMOA441i23VPkmVrBI0sQm4KqYsTOmh9zoWGDTLPp53i3ZFdcfZ2MnIm34=
X-Received: by 2002:a05:693c:60d4:b0:369:fe81:a575 with SMTP id 5a478bee46e88-3857111f203mr27254329eec.35.1795730060741;
        Thu, 26 Nov 2026 13:54:20 -0800 (PST)
Received: from ?IPV6:2620:10d:c085:21d6::110c? ([2620:10d:c090:400::5:a169])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3866f299d0bsm57369732eec.19.2026.11.26.13.54.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 13:54:20 -0800 (PST)
Message-ID: <cf0cf72a-493b-4945-a887-7305ae086028@gmail.com>
Date: Thu, 26 Nov 2026 13:54:19 -0800
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
Subject: Re: [PATCH net-next v3] net: mlx5: Allow police as the last action of
 a TC rule
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, saeedm@nvidia.com, leon@kernel.org,
 tariqt@nvidia.com, mbloch@nvidia.com, cjubran@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261124220251.776944-1-mohsin.bashr@gmail.com>
 <179570909592.3135.1382351175870070773@kernel.org>
Content-Language: en-US
From: Mohsin Bashir <mohsin.bashr@gmail.com>
In-Reply-To: <179570909592.3135.1382351175870070773@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/26/26 8:04 AM, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] In police_act_can_offload_jump()
>    (drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c), every…
> - [Low] Besides adding police-as-last-action support, the patch fixes two
>    hardware/software mismatches in existing offloaded rules, both present…
> 
> --
> 
> net: mlx5: Allow police as the last action of a TC rule
> 
> This patch lets mlx5 offload TC rules in switchdev mode where police is
> the last action. It also changes how police results are offloaded: ok is
> now accept, pipe as the last action is accept, and a jump is only
> offloaded when police is the first action and the skipped actions are all
> drop or all ok. The forward to the post meter table is now set for rate
> police as well as mtu police.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
>> index 1bd1c94fb9776..f03a992cbc270 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
>> @@ -37,6 +37,52 @@ static int police_act_validate(const struct flow_action_entry *act,
>>   	return 0;
>>   }
>>   
>> +static bool
>> +police_act_can_offload_jump(struct mlx5e_tc_act_parse_state *parse_state,
>> +			    const struct flow_action_entry *act,
>> +			    int act_index, u32 target)
>> +{
> 
> [ ... ]
> 
>> +	prev = act;
>> +	for (i = 1; i <= target; i++) {
>> +		entry = &flow_action->entries[i];
>> +
>> +		if (i < target &&
>> +		    ((entry->id != FLOW_ACTION_DROP &&
>> +		      entry->id != FLOW_ACTION_ACCEPT) ||
>> +		     entry->id != flow_action->entries[1].id)) {
>> +			NL_SET_ERR_MSG_MOD(extack,
>> +					   "Jump can only skip actions that are all drop or all ok");
>> +			return false;
>> +		}
> 
> [Severity: Medium]
> 
> Does this check stop offloading police-first jump rules that were offloaded
> correctly before this patch?
> 
> tc_act_can_offload_police() calls police_act_can_offload_jump() for each
> jump result of both rate and mtu police. With police at index 0, any
> skipped action other than drop or ok is now rejected. For example:
> 
>    action police mtu 1500 conform-exceed pipe/jump 2 \
>    action mirred egress redirect dev A \
>    action mirred egress redirect dev B
> 
> Before this patch, dec_jump_count() already handled this case when police
> is at index 0. jump_count is set to extval and decremented once per
> distinct TC action, so the jump lands on the same entry where
> tcf_action_exec() restarts.
> 
> The last skipped action is either marked terminating or forwarded to the
> post action table (as for mirror):
> 
> dec_jump_count() {
>      ...
> 		if (tc_act->is_terminating_action) { /* the branch ends here */
> 			attr->flags |= MLX5_ATTR_FLAG_TERMINATING;
> 			...
> 		} else { /* the branch continues executing the rest of the actions */
> 			attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
> 			...
> }
> 
> With this patch these rules fail can_offload with "Jump can only skip
> actions that are all drop or all ok". With skip_sw the filter add fails.
> Without skip_sw (for example with OVS) the traffic goes to the software
> datapath.
> 
> The only flaw the commit message names in the old jump handling is that
> the jump is counted from police instead of from the start of the action
> list. That cannot happen when police is at index 0, and the act_index
> check above already rejects the other case.
> 
> Is the extra all drop or all ok restriction needed? If it is intentional,
> could the commit message say that rules which offload today will stop
> offloading, instead of only "Reject the rest"?
> 

Thanks for the review. Yes, this is intentional. Please see the 
discussion on v1 and v2
https://lore.kernel.org/netdev/20261117031337.4126403-1-mohsin.bashr@gmail.com
https://lore.kernel.org/netdev/20261119040010.1405900-1-mohsin.bashr@gmail.com

In summary, we discussed that a jump either executes the correct target 
or the offload is rejected.

Police first alone does not meet this expectation. My understanding is 
that the driver counts a jump in flow action entries, while TC counts it 
in TC actions, and the two do not always match. This can be an issue 
when one TC action gives entries of different types, for example a pedit 
with a set and an add key. I have not tested this on HW though. Maybe 
Mark or someone else from NVIDIA can correct me here.

>> +
>> +		if (entry->id == prev->id && entry->hw_index == prev->hw_index) {
> 
> [ ... ]
> 
>> @@ -49,6 +95,16 @@ tc_act_can_offload_police(struct mlx5e_tc_act_parse_state *parse_state,
>>   	if (err)
>>   		return false;
>>   
>> +	if (act->police.exceed.act_id == FLOW_ACTION_JUMP &&
>> +	    !police_act_can_offload_jump(parse_state, act, act_index,
>> +					 act->police.exceed.extval))
>> +		return false;
>> +
>> +	if (act->police.notexceed.act_id == FLOW_ACTION_JUMP &&
>> +	    !police_act_can_offload_jump(parse_state, act, act_index,
>> +					 act->police.notexceed.extval))
>> +		return false;
>> +
>>   	return !!mlx5e_get_flow_meters(parse_state->flow->priv->mdev);
>>   }
> 
> [ ... ]
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> index 1d35c97aea0bc..7e7111e6d058b 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> 
> [ ... ]
> 
>> @@ -3891,11 +3891,17 @@ alloc_branch_attr(struct mlx5e_tc_flow *flow,
>>   	case FLOW_ACTION_DROP:
>>   		attr->action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
>>   		break;
>> -	case FLOW_ACTION_ACCEPT:
>>   	case FLOW_ACTION_PIPE:
>> -		err = set_branch_dest_ft(flow->priv, attr);
>> -		if (err)
>> -			goto out_err;
>> +		if (!last) {
>> +			err = set_branch_dest_ft(flow->priv, attr);
>> +			if (err)
>> +				goto out_err;
>> +			break;
>> +		}
>> +		fallthrough;
>> +	case FLOW_ACTION_ACCEPT:
>> +		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>> +		attr->flags |= MLX5_ATTR_FLAG_ACCEPT;
>>   		break;
> 
> [Severity: Low]
> 
> This isn't a runtime bug in the patch. However, this hunk and the
> act_index check in police_act_can_offload_jump() also fix two
> hardware/software mismatches in rules that are already offloaded.
> 
> First, alloc_branch_attr() handled an ok police result like pipe. For
> "police ... conform-exceed drop/ok action mirred ...", the hardware ran
> the following actions for conforming packets, while tcf_action_exec()
> stops at TC_ACT_OK.
> 
> Second, dec_jump_count() counts a police jump from the police action,
> while TC counts from the start of the list. With police at a non-zero
> index, the hardware ran different actions than software did.
> 
> Both seem to date back to the branching support in commit f86488cb4685
> ("net/mlx5e: TC, initialize branch flow attributes") and its follow-up
> c84fa1ab94a77c ("net/mlx5e: TC, initialize branching action with target
> attr").
> 
> The commit message describes the behavior change, but there is no Fixes:
> tag, and the fixes are mixed with the new police-as-last-action support.
> Could these fixes be split out and sent to net with Fixes: tags, so that
> stable trees pick them up?
> 

I kept them in net-next on purpose, since both change the behavior of 
rules that are offloaded today. That said, if the maintainers prefer, I 
can split them out to net with appropriate fixes tags.

>>   	case FLOW_ACTION_JUMP:
>>   		if (*jump_count) {
> 
> [ ... ]
> 

