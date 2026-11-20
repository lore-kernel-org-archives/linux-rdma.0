Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795199194;
	b=bC5KcFkU4kv0TJHi5U2WjnLF5apyvDl5tEuIEFnCHEIDE2I8PFDEPHPDNjsvI9D0NQ+o
	 hTe1Yym7Tm7zFNK1jvqojruV9DgGwz8aEpxeyyE4aBUveePIuIR+fpT4ymH1W9xiR9U1C
	 /YS0Rps8CXnPP+zVauD56gYNGB9Dlm/ym5eGzEo/EpqjhGsu7IYKLLddJDJbbXbABYm5L
	 693NCX7b7Ke9qZFMLlEFBQZ6B2e/HC8w/ryoWaZyKlhJ3i4nBx85x/cIDZuEvTCc7ty7W
	 UVzOgdMY/LFXsobupGcD3kHPpgC6StaMh/GuPF9wpVv/PlbMA9ZWpQeo5TMrBrzS3FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795199194;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=hiyFKVpmmZxy1WJhIZ2wQOiq0flu9/jgh5TB7ONFXc4=;
	b=Edc/KKvQXsD9t62JvZzQgXCIGbQZ4P62MQm7jQPlc39ChowWyUhSlJmu9f8b63BLafsN
	 qh1fj55o7Y3LlvHe19t9vG38neXi6VxgpddTp+KsGfgqcf//mzdKHIlba4YowtVXELz/d
	 kztLNvbvp8e5pzMpwSo1zanlcwk8ZiEV1PcJ1L1xN2ZjPduaQaigm+udGWOgt4OC5XgxU
	 l/KcG05zKVXEW4WHCXDCQRvv3qm9bDZM2hkOwhKiJb/TjTPF0GPqH5JNqIy5HQhJ7n7+a
	 0yKmtrBdX1nil3E2gl5igs+zhJmSLtAbMqHL0o4jXuys6P2sNcOiLofAhCR4b9oZcnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="a/3ha5sa";
	arc=none smtp.remote-ip=74.125.82.180
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68940606A325
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 18:26:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68940606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a/3ha5sa
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-38587f3de36so1430386eec.0
        for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 10:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795199193; x=1795803993; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hiyFKVpmmZxy1WJhIZ2wQOiq0flu9/jgh5TB7ONFXc4=;
        b=a/3ha5saUfvEW5Ua5HPuBbNQ1V1As+4BM/acXODn/gT96QZO5WsVwMU47R3EGbaYN8
         AgaVEeT6V/mSy8VRWYTCW3WJ6vbjs3XIfS/nrVfUv8a2uhndA1h5cZTKC+AE+bLHAWlN
         dLoI05Wi+YyOKZ4+Xspl9XF3dhYQDCZ3gjyLykfqzWnMtirh6NCHdoonV9OYz9M9EY9S
         OsIqZLzny5QD+mkPwqEpKeyTC70n4TE8amHOki8mkM2PCU8GfcKhVqrbTw5cEnbQJTwN
         SkBvrcVknPEmCXbXQ7G4wSjuQBhGJpH9/5ulrcjioJaD+ETnVrInfpZgenGBCkZDghrU
         puqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795199193; x=1795803993;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hiyFKVpmmZxy1WJhIZ2wQOiq0flu9/jgh5TB7ONFXc4=;
        b=O+jGay8HqXN07R1N9D+hXHPsBztO/pvFjwnkRaGPCtIBXqmHa2tR2y8y005/ivj8S5
         vFQo7H6Ipc3L/v9mMPVbs35BSKfgF6RzK2B6qgmNgiNffslVyTK7qoVXwZ8o/q5A08KX
         xoprLgpJNaAOOb3yUowqrDLTX3TnJqcAOJ7fKajZCVfVjcUasPQx+BNulShXjvEw/wg0
         NodHU0i8/1xCz0tiB7tv2tOFh9cJJ3VLnKbaPHlyWBAjF6io6Sx9pmAU6JkubwRzjfHQ
         qX6ACTLaAJC0BEDxbOkQJqzlVWByluLwo6zo/VIfogH3v68Zzj/pfWd5sVmZ5zUlHe15
         9PAQ==
X-Forwarded-Encrypted: i=1; AL+hErEWGlLlbOoBKgf/Txzhp1f6Zi/JroWxH9gvJGtJLVyHJepQ7K91ObngUXp+7amYTWhSB6e7h1B1eQjm@vger.kernel.org
X-Gm-Message-State: APuU4Z+ASC82DMGCRgUsXCr6YZMiiilYNRA6zhKelgbf6eEPxfxoS00p
	3seK92aRZWqnYDoUQx+0ECr07WwATFbyFpVTyUvtFZGiG9Rn9t00jSuT
X-Gm-Gg: AZFdTZdlXPQyn9w6qclN0q/UKSaeOqIOob/qMPFRuTY900bpuMVuRahOEdZhdeAUNcO
	siV+LdNkbTINRtB8TA8eS8IbiTSRRiug0TPgifsnItrd4dnrJ8gRjuVdXfCLhMDsqQWfGc3Ioj3
	v2W3lstYtrHVxN37kbwp/p5uxeYI6aYfugOdUbnuJzsaHw6v6oVCWUKplOQTGDSOYA+a0bqq+in
	UdkKAVZD/tHOd/WgoXwBGM1+qExcT9/1udqXLvn9IekWpZ/oT2z9TIjmOU2pFw4Ntb+LlW28HVr
	CauWdAFbcI0oboGnjSMjilLDa/5hlnWrjAvvdpKpPkUwZTJIV7FmHJ1giyKOWZule+ItLxOxfwp
	Zk9msjoxSTHY0MUAq3/RhpQaplqttC351vl2CorOVdVtD30+XWpcWx0Nh7iwldlRkWLKDXNtkHn
	7GuV5MnnW+elspTpIKRqh0xKwJ4oREbAJ1yo2vDTCaUe9g9xhsi2oLLLLJBbShbnTTveZTXT+qG
	Mpaw1fmnUBB1eV2bv3PsJk6zHbZM0lwlOy2ewTUk0FdrXBZUEk0YqUjBk1Ya/uLmxsEbBuYcq/6
	YgQy0BdNwtp/1usrr+I623FXIYPmrjZIPun0KGho0RhiJ2P8cD32Hu7OWGSCYvEOysGst6kFLAI
	7PUk=
X-Received: by 2002:a05:7300:7c08:b0:384:3123:a0cb with SMTP id 5a478bee46e88-3856ff5b880mr5515943eec.27.1795199193306;
        Fri, 20 Nov 2026 10:26:33 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1151:15:18db:c1e7:4974:be38? ([2620:10d:c090:500::5:5388])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38577214c2dsm9144539eec.17.2026.11.20.10.26.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 10:26:32 -0800 (PST)
Message-ID: <cf523269-53c1-4357-a628-87e25e5a6ae0@gmail.com>
Date: Fri, 20 Nov 2026 10:26:32 -0800
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
Subject: Re: [PATCH net-next] net: mlx5: Allow police as the last action of a
 TC rule
To: Mark Bloch <mbloch@nvidia.com>, netdev@vger.kernel.org
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 cjubran@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, idosch@nvidia.com
References: <20261117031337.4126403-1-mohsin.bashr@gmail.com>
 <82d9959a-8176-4433-94a4-ff72445306ca@nvidia.com>
 <09ae2064-38ff-4d25-83e5-0ac4c3eb1658@gmail.com>
 <194e1103-0d28-45d4-986a-819955e11268@nvidia.com>
 <acd93d7c-1e91-45f4-b178-07c6afea7fe5@gmail.com>
 <0a9b34c9-32d8-4325-aaef-c358c41a9f5a@nvidia.com>
Content-Language: en-US
From: Mohsin Bashir <mohsin.bashr@gmail.com>
In-Reply-To: <0a9b34c9-32d8-4325-aaef-c358c41a9f5a@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/20/26 10:06 AM, Mark Bloch wrote:
> 
> 
> On 18/11/2026 2:52, Mohsin Bashir wrote:
>>
>>
>> On 11/17/26 2:14 PM, Mark Bloch wrote:
>>>
>>>
>>> On 17/11/2026 23:52, Mohsin Bashir wrote:
>>>>
>>>>
>>>> On 11/17/26 11:18 AM, Mark Bloch wrote:
>>>>> On 17/11/2026 5:13, Mohsin Bashir wrote:
>>>>>> From: Mohsin Bashir <hmohsin@meta.com>
>>>>>>
>>>>>> In switchdev mode, mlx5 offloads police only when other actions follow
>>>>>> it. TC needs no extra action for a police-only rule to work. The mlx5
>>>>>> driver makes every police rule forward to the post meter table, but for
>>>>>> a rate police it adds that forward only after verify_attr_actions() has
>>>>>> checked the rule, so the check rejects it. The ok result of police is
>>>>>> also handled as pipe. In TC, ok accepts the packet and ends the action
>>>>>> list, whereas mlx5 goes on with the actions after police.
>>>>>>
>>>>>> Support police as the only action of a rule. Set the forward while
>>>>>> parsing police, as is already done for police with mtu, and forward
>>>>>> an ok result to the end of the TC chains, as the driver does when it
>>>>>> offloads the gact ok action. The upcoming selftest series also relies on
>>>>>> such rules for TC offload validation.
>>>>>>
>>>>>> The patch was tested on a ConnectX-7 in switchdev mode with the command
>>>>>> below, and it was verified that the rule is offloaded and limits the
>>>>>> matching traffic to the configured rate, using the hardware drop counter.
>>>>>>
>>>>>>      tc filter add dev eth0 ingress pref 100 protocol ipv6 flower skip_sw \
>>>>>>        ip_proto udp dst_port 5201 \
>>>>>>        action police rate 100mbit burst 1m conform-exceed drop/ok
>>>>>>
>>>>>> Cc: Carolina Jubran <cjubran@nvidia.com>
>>>>>> Signed-off-by: Mohsin Bashir <hmohsin@meta.com>
>>>>>> ---
>>>>>>     drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c | 3 ++-
>>>>>>     drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            | 3 +++
>>>>>>     2 files changed, 5 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
>>>>>> index 1bd1c94fb977..52295f5d644c 100644
>>>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
>>>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
>>>>>> @@ -94,13 +94,14 @@ tc_act_parse_police(struct mlx5e_tc_act_parse_state *parse_state,
>>>>>>                   MLX5_FLOW_STEERING_CAP_MATCH_RANGES))
>>>>>>                 return -EOPNOTSUPP;
>>>>>>     -        attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>>>>>>             attr->flags |= MLX5_ATTR_FLAG_MTU;
>>>>>>         } else {
>>>>>>             attr->action |= MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO;
>>>>>>             attr->exe_aso_type = MLX5_EXE_ASO_FLOW_METER;
>>>>>>         }
>>>>>>     +    attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>>>>>
>>>>> This makes every police that is the lact action pass verify_attr_actions()
>>>>> not only ok case described.
>>>>>
>>>>> what happens with:
>>>>> "police ... conform-exceed drop/pipe"
>>>>> with this not writes to FTEID_TO_REG so what happens once a packet
>>>>> reaches the port action table?
>>>>>
>>>>> also what about:
>>>>> tc filter add dev eth0 ingress pref 100 protocol ipv6 flower skip_sw \
>>>>>        ip_proto udp dst_port 5201 \
>>>>>        action police rate 100mbit burst 1m conform-exceed drop/pipe \
>>>>>        action police rate 100mbit burst 1m conform-exceed drop/pipe
>>>>>
>>>>> won't this create a loop?
>>>>>
>>>>
>>>> Thanks for reviewing Mark.
>>>>
>>>> Ahh! I missed the loop case. I had a patch to handle pipe on the last police but I dropped it, since my testing showed the post_act table still passed the packets up. Let me respin and send pipe and jump on the last police to the end of the TC chains. Would that work in your opinion?
>>>
>>> Yes for PIPE.
>>>
>>> For JUMP, we need to check the target. tcf_action_exec() counts from
>>> the start of the action list, so even the last police can jump back
>>> to itself or an earlier action. If we can't offload that, we should
>>> probably reject it.
>>>
>>> That's how I read tcf_action_exec(), but please correct me if I'm
>>> missing something as I'm not really a tc expert.
>>>
>>>>
>>
>> Yeah, jump restarts the list. Before this patch police as the last action was rejected anyway, so I believe rejecting jump there in the respin should be okay?
>>
>>>>>> +
>>>>>>         return 0;
>>>>>>     }
>>>>>>     diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>>>>> index 1d35c97aea0b..8685e41487f3 100644
>>>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>>>>> @@ -3892,6 +3892,9 @@ alloc_branch_attr(struct mlx5e_tc_flow *flow,
>>>>>>             attr->action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
>>>>>>             break;
>>>>>>         case FLOW_ACTION_ACCEPT:
>>>>>> +        attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>>>>>> +        attr->flags |= MLX5_ATTR_FLAG_ACCEPT;
>>>>>> +        break;
>>>>>>         case FLOW_ACTION_PIPE:
>>>>>>             err = set_branch_dest_ft(flow->priv, attr);
>>>>>>             if (err)
>>>>>
>>>>> This also changes rules where police is not the last action.
>>>>> The conform result defaults to ok when it is not given.
>>>>>
>>>>> action police rate 100mbit burst 1m conform-exceed drop \
>>>>>            action mirred egress redirect dev eth2
>>>>>
>>>>>
>>>>> won't with this change the conforming packets go to the tc end table
>>>>> and not to the redirect dev?
>>>>> The rule is still reported as offloaded and installs the redirect
>>>>> which can't reached now.
>>>>>
>>>>
>>>> Maybe I am missing something here, but when the conform action is not given, doesn't it default to ok? For example, if we have
>>>>     action police rate 100mbit burst 1m conform-exceed drop action drop
>>>> shouldn't conforming packets still be pushed up rather than dropped by the following action, making the action drop (or the action mirred) dead code?
>>>>
>>>
>>> Yes, agreed, the following action is dead code in software too,
>>> a separated cleanup patch maybe?
>>>
>>
>> Yeah probably.
>>
>>> What about packets that reach the rep? I don't see anything in
>>> the ACCEPT path that tells software TC the packet has already been
>>> processed. For example:
>>>
>>> tc filter add dev eth2 ingress pref 100 protocol ipv6 flower skip_sw \
>>>       ip_proto udp dst_port 5201 \
>>>       action police rate 100mbit burst 1m conform-exceed drop/ok
>>>
>>> tc filter add dev eth2 ingress pref 200 protocol ipv6 flower skip_hw \
>>>       ip_proto udp dst_port 5201 \
>>>       action drop
>>>
>>> Wouldn't a conforming packet reach software, skip the first rule and
>>> get dropped by the second, despite already being accepted in hardware?
>>>
>>> Can you test this? The existing gact ok path might have the same issue.
>>
>> Yeah, in both cases (police and gact ok) the conforming packets are pushed up, where they get dropped by the skip_hw rule. My understanding is that with existing behavior the restore doesn't happen on accept path, so sw tc takes the packet through classification again.
>>
> 
> Hi,
> 
> Sorry for the delay. I had other things to deal with and wanted to
> go through the original internal reviews before replying.
> 
> I'm fine with supporting this, provided we preserve TC semantics:
> 
> - ok stops processing; later actions are not executed.
> - jump executes the correct target, or we reject the offload.
> - pipe executes the next action, or ends processing if it is last.
> 
> Please address the issues discussed in the next submission.
> 

Hey, thanks for getting back. Please have a look at v2 here: 
20261119040010.1405900-1-mohsin.bashr@gmail.com

I believe v2 addresses P1 and P3 fully. P2 needs some feedback. I reject 
jump only if police is the last action.

I can update it to reject jump unless police is the first action and the 
target is within the action list. That way jump always land on the same 
action as in TC or it gets rejected. What do you think about it?

> Mark
> 
>>> Mark
>>
>>
> 

