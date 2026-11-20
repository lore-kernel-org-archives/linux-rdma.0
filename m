Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795212005;
	b=R2+ez2cG/7HFvAjlqjIwgvLgkJaAvSX1sHrrguE9neDgRRdXnp9dUTmNMyzhdhv0Oggf
	 Nulf9InFhjov2qJZOvrQoYXHvFlSygavocdE0poCFV8/0l8WzrC1T0Yjp4hDoqznByh1n
	 yQStFmWypnZ/Ijh/1yk2fO7zubUOxsVNQ5NyAZ7GC6talfdf4NpRl4v63cDf0JtTcyXHg
	 TzBtp8nPblaDEPefR/zkiBlqknfnRzwI3CZt/g88tQ8nRARJWk65RhYQv0AAxoVnN6ha5
	 UDxXg5KrXSfx55k+Rxx2yYMm5nHitdDqdqg2aACYq5K3Ez2apvA0U3tkdl79fvUkVHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795212005;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=iLQP55WEAO3To1ycZ2DTaKrIVxUYismiwOyaOgIWcZY=;
	b=155eYHBMB1/Nw7ECaPgB0KduJ9M8HRwKvIiMEaRzpQAEmaEVW49nm4VWxj4P9G4p3+aU
	 X1Bc3oQ1gQiHelEwSoslxpag6pk2eYwd8hhDLJdN+/U1FRkQ906SP4HpzFwwsIW978ObW
	 Vrm9miR3CFzxsZBGCp/ScIyh3pWNrd3CODUrcytfYYkrx1nyrbukfdGip8sXZlE0eIiqJ
	 /K+M/FxtIDApJZ/oq2CEb4BRfIdxcUUJPMvH38fwclaXBOtGuhMk44wvxyqAlNGIaVVFl
	 dIIglE3bIhSDCjPpw1aHQz+sMTqfszFRFB8Buomo2qM8LDu46FiFLW0kdANrBMcS1ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Er5l/pkd";
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2010F606A6B0
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 21:59:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2010F606A6B0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Er5l/pkd
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-382f4710a17so2283154eec.0
        for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 13:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795211998; x=1795816798; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iLQP55WEAO3To1ycZ2DTaKrIVxUYismiwOyaOgIWcZY=;
        b=Er5l/pkdXn25K6Gxgm3+U3U4Q7jkdZKVw377ETY6fO8WqxeCTK++16osJI1ChN3SJL
         hGw/MJJuhWV55SOiNiSFOocFBRyAGqUefO8XLpYYA2fo5lSh8FOKfs8nPvL2tmpFORB1
         2KKbPklk5CX8iOsiWQkKwPbI0OAPapyJ661G2/LVRDVuuzhiThrjOdBnTda8x5QmPLBi
         ABKL+hvo84nmMbiqlE4z4m5wTE79brewi3WBC/jL5UWKTRzJmXS5VbrsWxX/3OmC/2ca
         weOVYVEY3qEd1xbBlKf7ZwUMhjPvs3NHmQj6SmbQuRpfNhpDmjIf7t9jyP3CGLySMbLc
         QxNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795211998; x=1795816798;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iLQP55WEAO3To1ycZ2DTaKrIVxUYismiwOyaOgIWcZY=;
        b=s7jmQ0Xs92xTdvKS5OAa/Fya4ijMNS/Bb9XXRonf+8naUmhbP+IB3VsEOOYzhTdYZu
         4uWtM/bG/iivYePW2nKZKs/wPkvmPwpT8CPbV9qCzI0xiafzo1UyukEuL/4IGsZUV0RX
         HSQ3TtvRevNM5nKAaN6EKFr3b1Z0KSgzrWM50dwJ7MGmb6oPR+nn0q3vnWeOSBuAENb+
         wD6eTVRDK3F8jatKhbOf9vZ7aBzNmz3DD79Q7JUnvOFXwaubt0ClZVjdSF0FgcAt5iZG
         iayTDyLrhEL9pzD95Tu3UmMZFPUsb/BK09DK97STwk2D+IKW8nYRStQGqMmw3rU5ui0i
         QWZA==
X-Forwarded-Encrypted: i=1; AL+hErGevqDMDAJs3XLDKuk0xZLFPhdxbLVAm/pppdsk0x3L8HeE4+LDLMReuLihI53oZPoG9YnnFFs650X7@vger.kernel.org
X-Gm-Message-State: APuU4Z/fWZ9LFJcXZXegZiS17bisrizv4bhWH3E4Ytw18qCtDHo1c/Su
	FJoghVFuU3hLgIM8OSyGRXL5MMphBXOfTEu+cjvNGBzNMULwJAjKR95x
X-Gm-Gg: AZFdTZdjSrB97hU9Dq7lNe8NV1QdJQn96rqXtncmO8pNN2vUZwQbKVrA/uj+quUUEii
	vbkp6ebRZ5zsNeBJCFbYzW3uarCgtF/OMJnp8XWl4nItf3geVWdpRzx/njytZfoa23PCtU3XOLa
	dvHIA2cXQsHSXwQioJibTb0ncwjZY5XgnU5RAw4eCopBtaaVRW2Lz71WdXJCuluCCDLL1W1ytXw
	CYaNGMk5YOY6Mi4+KfRI9cW7tZ+awQud7xggz9it2FZ78/kxHJF9Az9NWuqArhdH/QSzv/gbbQF
	JJUj84ibBh7iWDmR+PB4SFMLnj89DWZs2oD8UT/DY51x+Wp1mbkpx+2CuPJJYlCHdiMY8ZvFiq1
	WrumzJiJOYfGv0eAqQ9bRwHopJ4Oeq/Z0Y8rIhURq0rKi7cnMrcZydZXS5EJScxbEq9jY1T5Fqs
	W1v/pqjf6S81iysz3NMtuZQTe20RNicWDw4AiuOODgpf8V/61nEXAKG8wDkGmxW401+woDAGZ0y
	C/0BHX4qRP56CEC1lGD8VPtzOYSP82mjMvma3v89Uck9uzZ95i8fiN7UqR6ayF40VAjUhTYHu+B
	7WUwoze1E6REd8hVWQv2StEn8k73H/6j6WQSYKjsYtnFr3L9kMNQVE6sk9bvHCgWFGPpkIYWkX8
	r7CGoliAgDA==
X-Received: by 2002:a05:693c:20c8:20b0:381:53ed:1c4b with SMTP id 5a478bee46e88-38571518db2mr4304389eec.34.1795211997878;
        Fri, 20 Nov 2026 13:59:57 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1151:15:18db:c1e7:4974:be38? ([2620:10d:c090:500::5:5388])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385d2b93dd9sm10667785eec.24.2026.11.20.13.59.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 13:59:57 -0800 (PST)
Message-ID: <15afeebe-4d31-47e2-8a1d-40aac1419438@gmail.com>
Date: Fri, 20 Nov 2026 13:59:56 -0800
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
Subject: Re: [PATCH net-next v2] net: mlx5: Allow police as the last action of
 a TC rule
To: Mark Bloch <mbloch@nvidia.com>, netdev@vger.kernel.org
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 cjubran@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261119040010.1405900-1-mohsin.bashr@gmail.com>
 <5c493bd0-31f5-430a-844a-ad011a5f0ba8@nvidia.com>
Content-Language: en-US
From: Mohsin Bashir <mohsin.bashr@gmail.com>
In-Reply-To: <5c493bd0-31f5-430a-844a-ad011a5f0ba8@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/20/26 1:14 PM, Mark Bloch wrote:
> 
> 
> On 19/11/2026 6:00, Mohsin Bashir wrote:
>> From: Mohsin Bashir <hmohsin@meta.com>
>>
>> In switchdev mode, mlx5 offloads police only when other actions follow
>> it. TC needs no extra action for a police-only rule to work. The mlx5
>> driver makes every police rule forward to the post meter table, but for
>> a rate police it adds that forward only after verify_attr_actions() has
>> checked the rule, so the check rejects it. The ok result of police is
>> also handled as pipe. In TC, ok accepts the packet and ends the action
>> list, whereas mlx5 goes on with the actions after police.
>>
>> Support police as the only action of a rule. Set the forward while
>> parsing police, as is already done for police with mtu, and forward
>> an ok result to the end of the TC chains, as the driver does when it
>> offloads the gact ok action. This also changes existing offloaded rules
>> where police is followed by other actions. Before, an ok result ran the
>> actions after police. Now it accepts the packet, as TC does. The
>> upcoming selftest series also relies on such rules for TC offload
>> validation.
>>
>> When police is the last action, a pipe result also ends the action
>> list, so forward it to the end of the TC chains too. Otherwise it is
>> sent back to the post action table, and with two police actions the
>> packet loops through the second police. A jump counts from the start
>> of the action list, so its target may be an earlier action or police
>> itself. Reject jump when police is the last action.
>>
>> The patch was tested on a ConnectX-7 in switchdev mode with the
>> commands below. It was verified, using the hardware drop counter, that
>> the rules are offloaded and limit the matching traffic to the
>> configured rate, that the second police of the two police rule only
>> sees the packets conforming to the first, and that jump on the last
>> police is rejected.
>>
>>    tc filter add dev eth0 ingress pref 100 protocol ipv6 flower skip_sw \
>>      ip_proto udp dst_port 5201 \
>>      action police rate 100mbit burst 1m conform-exceed drop/ok
>>
>>    tc filter add dev eth0 ingress pref 100 protocol ipv6 flower skip_sw \
>>      ip_proto udp dst_port 5201 \
>>      action police rate 200mbit burst 1m conform-exceed drop/pipe \
>>      action police rate 100mbit burst 1m conform-exceed drop/pipe
>>
>>    tc filter add dev eth0 ingress pref 100 protocol ipv6 flower skip_sw \
>>      ip_proto udp dst_port 5201 \
>>      action police rate 100mbit burst 1m conform-exceed drop / jump 1
>>
>> Cc: Carolina Jubran <cjubran@nvidia.com>
>> Signed-off-by: Mohsin Bashir <hmohsin@meta.com>
>> ---
>> Changelog:
>> v2:
>>    - Treat pipe on the last police as ok and forward it to the end of the
>>      TC chains.
>>    - Reject jump when police is the last action, since the jump target is
>>      counted from the start of the action list.
>>    - Update commit message
>>
>> v1: https://lore.kernel.org/netdev/20261117031337.4126403-1-mohsin.bashr@gmail.com
> 
> I think we can keep this patch small and tighten the JUMP checks:
> 
> for each police branch using JUMP:
>      reject unless police is the first action
>      reject unless the target is a later, existing action
>      reject if skipped actions include anything other than DROP/OK
>      reject if the countdown would count two separate actions as one
>             (e.g. repeated uses of a shared action)
> 
> That keeps the simple forward jumps working and leaves the new OK/PIPE
> support intact. It rejects some valid configurations, but that seems
> better than offloading them with different behavior.
> 
> Broader JUMP support would need more work on the action parser to make
> sure hardware behaves the same as software. I'd handle that separately.
> 
> Unless there's a concrete use case, I'd keep backward jumps unsupported.
> We don't want to offload steering loops, intentionally or by mistake.
> 
> I'm not sure which JUMP cases you need. Would this be enough for your
> use case?
> 
> Mark

Thanks Mark, I believe this should works for us (at-least for now). We 
mainly need police as the only action and pipe or ok on the conform 
side, so for now we don't need jump beyond what's supported today. I'll 
add these checks in v3,

> 
>> ---
>>   .../mellanox/mlx5/core/en/tc/act/police.c     | 11 +++++++-
>>   .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 26 ++++++++++++-------
>>   2 files changed, 27 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
>> index 1bd1c94fb977..faa0822b1136 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
>> @@ -49,6 +49,14 @@ tc_act_can_offload_police(struct mlx5e_tc_act_parse_state *parse_state,
>>   	if (err)
>>   		return false;
>>   
>> +	if (flow_action_is_last_entry(parse_state->flow_action, act) &&
>> +	    (act->police.exceed.act_id == FLOW_ACTION_JUMP ||
>> +	     act->police.notexceed.act_id == FLOW_ACTION_JUMP)) {
>> +		NL_SET_ERR_MSG_MOD(parse_state->extack,
>> +				   "Jump on last police action is not supported");
>> +		return false;
>> +	}
>> +
>>   	return !!mlx5e_get_flow_meters(parse_state->flow->priv->mdev);
>>   }
>>   
>> @@ -94,13 +102,14 @@ tc_act_parse_police(struct mlx5e_tc_act_parse_state *parse_state,
>>   		      MLX5_FLOW_STEERING_CAP_MATCH_RANGES))
>>   			return -EOPNOTSUPP;
>>   
>> -		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>>   		attr->flags |= MLX5_ATTR_FLAG_MTU;
>>   	} else {
>>   		attr->action |= MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO;
>>   		attr->exe_aso_type = MLX5_EXE_ASO_FLOW_METER;
>>   	}
>>   
>> +	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>> +
>>   	return 0;
>>   }
>>   
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> index 1d35c97aea0b..7e7111e6d058 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> @@ -3874,7 +3874,7 @@ static int
>>   alloc_branch_attr(struct mlx5e_tc_flow *flow,
>>   		  struct mlx5e_tc_act_branch_ctrl *cond,
>>   		  struct mlx5_flow_attr **cond_attr,
>> -		  u32 *jump_count,
>> +		  u32 *jump_count, bool last,
>>   		  struct netlink_ext_ack *extack)
>>   {
>>   	struct mlx5_flow_attr *attr;
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
>>   	case FLOW_ACTION_JUMP:
>>   		if (*jump_count) {
>> @@ -3967,7 +3973,7 @@ dec_jump_count(struct flow_action_entry *act, struct mlx5e_tc_act *tc_act,
>>   static int
>>   parse_branch_ctrl(struct flow_action_entry *act, struct mlx5e_tc_act *tc_act,
>>   		  struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *attr,
>> -		  struct mlx5e_tc_jump_state *jump_state,
>> +		  struct mlx5e_tc_jump_state *jump_state, bool last,
>>   		  struct netlink_ext_ack *extack)
>>   {
>>   	struct mlx5e_tc_act_branch_ctrl cond_true, cond_false;
>> @@ -3980,7 +3986,7 @@ parse_branch_ctrl(struct flow_action_entry *act, struct mlx5e_tc_act *tc_act,
>>   	tc_act->get_branch_ctrl(act, &cond_true, &cond_false);
>>   
>>   	err = alloc_branch_attr(flow, &cond_true,
>> -				&attr->branch_true, &jump_count, extack);
>> +				&attr->branch_true, &jump_count, last, extack);
>>   	if (err)
>>   		goto out_err;
>>   
>> @@ -3988,7 +3994,7 @@ parse_branch_ctrl(struct flow_action_entry *act, struct mlx5e_tc_act *tc_act,
>>   		jump_state->jumping_attr = attr->branch_true;
>>   
>>   	err = alloc_branch_attr(flow, &cond_false,
>> -				&attr->branch_false, &jump_count, extack);
>> +				&attr->branch_false, &jump_count, last, extack);
>>   	if (err)
>>   		goto err_branch_false;
>>   
>> @@ -4052,7 +4058,9 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
>>   
>>   		dec_jump_count(act, tc_act, attr, priv, &jump_state);
>>   
>> -		err = parse_branch_ctrl(act, tc_act, flow, attr, &jump_state, extack);
>> +		err = parse_branch_ctrl(act, tc_act, flow, attr, &jump_state,
>> +					flow_action_is_last_entry(flow_action, act),
>> +					extack);
>>   		if (err)
>>   			goto out_free_post_acts;
>>   
> 

