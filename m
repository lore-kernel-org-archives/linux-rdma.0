Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794963127;
	b=GQSCUkMFE7uUQTMtmpF5n7x1PlPLQlsYSiT+Wg7j9A04XWOil8I9DYFPIj2Un5w0vxbK
	 tMtjRqMFfJWlJ1JG+ATIcU/xszO6Ysz2eGILWPfqQT26NS259NyTjyp75x6ZZto60BMw6
	 5ezcvhDhUM30eDF7Zw0od6gPiVUUmcIuZU5PNLjxosM6PZxYTf571kernRY3t399nAyyM
	 B1yRWuu8rGRqavDED1d6IpyyRWQfNDSbWYyQs9V0CDO4PQGCfIAB/M9UhSxv/m3KbEBXo
	 lDTF8r5CPyXdrUohPXUKtLqYfpHP14roX+J9s77ZWejUpziJMh/+22Sl3bN7P0+zrhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794963127;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=5YEjBS6xE1eBk+mrimGlFTFMZhAtwJy1TMR+gCWx7jI=;
	b=JgPrHeN8wYwDArM5GNbyfYaeiU+r6VxDyJATKsU/aI4tkhHpelh4nwEhNeZPWkHCORP0
	 VJ3eA6Ix1pFC3wgJzzGz4p8o44cU17BhU64OZ5iGi8wjpxorhtu7m/cIvaoUlqP2caz0j
	 DPI/xhPGgefcvAWcID7rICEbvPnt6GpbAm03ucQfuSwRlIVcxb8LMvrGMlaqIQ+TJO6r0
	 okGGNsN1V/9U3cm/obmQ7jALLXEoqOxGv4qWd+eUl4JQ1UGiPAHMBxYFXeCQGLUTTcs/J
	 YJnqE//7mH1lBSwwrRSqkOVZiX6wDVu5g3C8iHnBo2RZlMFmP9n4QCzhAHgFu4foxnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=G3qRHQMA;
	arc=none smtp.remote-ip=74.125.82.46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27403606A331
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 00:52:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27403606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=G3qRHQMA
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1a8cc11ac42so645316c88.0
        for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 16:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794963126; x=1795567926; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5YEjBS6xE1eBk+mrimGlFTFMZhAtwJy1TMR+gCWx7jI=;
        b=G3qRHQMA8OBSG/SeK4THNh0KKALKpLDgZLISJzsrYrx7B6qYQ9uVos8KxghIFRCZEc
         f/XQclwG1h8FsqZ4X5TtVNFvRxHaRXIR6IlDpaVFcMU4uToIiBMV23KjCRAQTjRTvCxE
         tAToPFscVe9C8b1xAv2izulKy6qFb5kVH7tFvh0zvhqBypxKkO779hh6t5Osbd755Dwg
         wVBhUWg7S9CxCuMkalfzJvWXfygt0lbMl3iI06DF7Shf+e+z+iJcLkOzlDna/qafRP4S
         FAMh2wlEsRAaD0ScJ7f1e5u5lCzyGTJE5OmpoVimu8vfKJtdKfbHSruDIwMvSuJAgFJ9
         8Zpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794963126; x=1795567926;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5YEjBS6xE1eBk+mrimGlFTFMZhAtwJy1TMR+gCWx7jI=;
        b=gYAyCZGnExrLgu5xB11w/nNxaFoyOYOK+wzm7778fyJ+fADfslGBtk8Xra8QlT6P94
         BjpGKtNsRacahSyi9mRJcsAlXky/wDbli9UU/dOzxLY7z6WNkSMMNLBPpzy6ZLB3NWIW
         qOVJsePxGe+NiRWn6ugmMKWO0XAyXz5rIrKNDUQB4+wzSzj2sfXTuElO7F6WbRw92faN
         n6O0yWqIkbDGr3GKPR8z3x6sk2lyF9XHuJus+imL1+pNqShQBV8CVrG2Jh4Gi2ly9EZx
         TDmStOS/8eo11YoJ7O4PrBedopQYf3yM/hUB+beTJ8NSKdBvgPSZGET0QWK/7L/Gg/kk
         Okgg==
X-Forwarded-Encrypted: i=1; AL+hErFZqRk9uVgqf5EtFWlBdDZfG0YxGQ8f3XDMr+FVze0xlWY0HEvqSB/BOP3hUQfhCPOghq9TbWMpHRIE@vger.kernel.org
X-Gm-Message-State: APuU4Z/vzHA9xj3TXJ1OcfIJeZ7KUrRdNpjdmHgiZi/Qw+RhcQdgRzJy
	FjrK4AHzEoQfkPM0dC16BJGFvipnDI2yYIhEI+LDGzPpnQ/Dk9VCXMz/
X-Gm-Gg: AYBFou0vi1oscKyDzIgNaZyNawSMJIxBPZDRGEJdTomsg8IkscEeU49msizWXunzJt/
	51zUkaUd/wRuSezrQjOrd/Lb6tqpbADt3nN1piwC5IPg0sOs9QxCbbRA7d0K/bv5bXex1vhMSMw
	ZrALkDKeiW1tN4BBYm/GMy1RVEJp197XPrUNpi+gzvjWQ7Rjj/CC5WV6O12m5SHPMqic8wSyb/9
	qsE/dYaLUZv/MWCVTJ0E53CKwNnrqg/TGOKaONA1o3LxhyJHMhxIoVSlsOih1ePDPXMJUvUa+tC
	1zR2JKPDAKW3dPCPhUhIxwbzN2KpFNnNfRjJeRvn/saAPBMdS2Duu4ZTniDFiRtU3UauHz+GWV2
	Rzw1UzAzu64lPlntphdtCezd1DAkVoySAVXsW1ur5HEyETs7lDIwvb74VDtXgPoXVP4gUfRriWw
	eC/GcFKOIDpPnnAv5l5R/0vSOomyJYeVfGn9JcqrsRrocvxb7jVx6NeJthI2WTXbUKK4+67NX3Y
	7tUULPtibdN/6wQBDjOlVvYzCLVQXv8cBAx/u7k6jOZk5EsgsqlueVfmd+1I4GTgRXGw494mPB/
	Y9ZYjqPfjLlqCZk56bQKIrfbnrqUgkkwzfu5NdjQOlJAIlmDDSQpDBx5VrOaLA==
X-Received: by 2002:a05:701b:4642:b0:1ae:b906:7733 with SMTP id a92af1059eb24-1b543ceba98mr1015904c88.23.1794963125640;
        Tue, 17 Nov 2026 16:52:05 -0800 (PST)
Received: from ?IPV6:2620:10d:c085:21d6::11c9? ([2620:10d:c090:400::5:bd16])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b544830c99sm3017616c88.15.2026.11.17.16.52.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 16:52:05 -0800 (PST)
Message-ID: <acd93d7c-1e91-45f4-b178-07c6afea7fe5@gmail.com>
Date: Tue, 17 Nov 2026 16:52:03 -0800
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
Content-Language: en-US
From: Mohsin Bashir <mohsin.bashr@gmail.com>
In-Reply-To: <194e1103-0d28-45d4-986a-819955e11268@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/17/26 2:14 PM, Mark Bloch wrote:
> 
> 
> On 17/11/2026 23:52, Mohsin Bashir wrote:
>>
>>
>> On 11/17/26 11:18 AM, Mark Bloch wrote:
>>> On 17/11/2026 5:13, Mohsin Bashir wrote:
>>>> From: Mohsin Bashir <hmohsin@meta.com>
>>>>
>>>> In switchdev mode, mlx5 offloads police only when other actions follow
>>>> it. TC needs no extra action for a police-only rule to work. The mlx5
>>>> driver makes every police rule forward to the post meter table, but for
>>>> a rate police it adds that forward only after verify_attr_actions() has
>>>> checked the rule, so the check rejects it. The ok result of police is
>>>> also handled as pipe. In TC, ok accepts the packet and ends the action
>>>> list, whereas mlx5 goes on with the actions after police.
>>>>
>>>> Support police as the only action of a rule. Set the forward while
>>>> parsing police, as is already done for police with mtu, and forward
>>>> an ok result to the end of the TC chains, as the driver does when it
>>>> offloads the gact ok action. The upcoming selftest series also relies on
>>>> such rules for TC offload validation.
>>>>
>>>> The patch was tested on a ConnectX-7 in switchdev mode with the command
>>>> below, and it was verified that the rule is offloaded and limits the
>>>> matching traffic to the configured rate, using the hardware drop counter.
>>>>
>>>>     tc filter add dev eth0 ingress pref 100 protocol ipv6 flower skip_sw \
>>>>       ip_proto udp dst_port 5201 \
>>>>       action police rate 100mbit burst 1m conform-exceed drop/ok
>>>>
>>>> Cc: Carolina Jubran <cjubran@nvidia.com>
>>>> Signed-off-by: Mohsin Bashir <hmohsin@meta.com>
>>>> ---
>>>>    drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c | 3 ++-
>>>>    drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            | 3 +++
>>>>    2 files changed, 5 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
>>>> index 1bd1c94fb977..52295f5d644c 100644
>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
>>>> @@ -94,13 +94,14 @@ tc_act_parse_police(struct mlx5e_tc_act_parse_state *parse_state,
>>>>                  MLX5_FLOW_STEERING_CAP_MATCH_RANGES))
>>>>                return -EOPNOTSUPP;
>>>>    -        attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>>>>            attr->flags |= MLX5_ATTR_FLAG_MTU;
>>>>        } else {
>>>>            attr->action |= MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO;
>>>>            attr->exe_aso_type = MLX5_EXE_ASO_FLOW_METER;
>>>>        }
>>>>    +    attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>>>
>>> This makes every police that is the lact action pass verify_attr_actions()
>>> not only ok case described.
>>>
>>> what happens with:
>>> "police ... conform-exceed drop/pipe"
>>> with this not writes to FTEID_TO_REG so what happens once a packet
>>> reaches the port action table?
>>>
>>> also what about:
>>> tc filter add dev eth0 ingress pref 100 protocol ipv6 flower skip_sw \
>>>       ip_proto udp dst_port 5201 \
>>>       action police rate 100mbit burst 1m conform-exceed drop/pipe \
>>>       action police rate 100mbit burst 1m conform-exceed drop/pipe
>>>
>>> won't this create a loop?
>>>
>>
>> Thanks for reviewing Mark.
>>
>> Ahh! I missed the loop case. I had a patch to handle pipe on the last police but I dropped it, since my testing showed the post_act table still passed the packets up. Let me respin and send pipe and jump on the last police to the end of the TC chains. Would that work in your opinion?
> 
> Yes for PIPE.
> 
> For JUMP, we need to check the target. tcf_action_exec() counts from
> the start of the action list, so even the last police can jump back
> to itself or an earlier action. If we can't offload that, we should
> probably reject it.
> 
> That's how I read tcf_action_exec(), but please correct me if I'm
> missing something as I'm not really a tc expert.
> 
>>

Yeah, jump restarts the list. Before this patch police as the last 
action was rejected anyway, so I believe rejecting jump there in the 
respin should be okay?

>>>> +
>>>>        return 0;
>>>>    }
>>>>    diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>>> index 1d35c97aea0b..8685e41487f3 100644
>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>>> @@ -3892,6 +3892,9 @@ alloc_branch_attr(struct mlx5e_tc_flow *flow,
>>>>            attr->action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
>>>>            break;
>>>>        case FLOW_ACTION_ACCEPT:
>>>> +        attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>>>> +        attr->flags |= MLX5_ATTR_FLAG_ACCEPT;
>>>> +        break;
>>>>        case FLOW_ACTION_PIPE:
>>>>            err = set_branch_dest_ft(flow->priv, attr);
>>>>            if (err)
>>>
>>> This also changes rules where police is not the last action.
>>> The conform result defaults to ok when it is not given.
>>>
>>> action police rate 100mbit burst 1m conform-exceed drop \
>>>           action mirred egress redirect dev eth2
>>>
>>>
>>> won't with this change the conforming packets go to the tc end table
>>> and not to the redirect dev?
>>> The rule is still reported as offloaded and installs the redirect
>>> which can't reached now.
>>>
>>
>> Maybe I am missing something here, but when the conform action is not given, doesn't it default to ok? For example, if we have
>>    action police rate 100mbit burst 1m conform-exceed drop action drop
>> shouldn't conforming packets still be pushed up rather than dropped by the following action, making the action drop (or the action mirred) dead code?
>>
> 
> Yes, agreed, the following action is dead code in software too,
> a separated cleanup patch maybe?
> 

Yeah probably.

> What about packets that reach the rep? I don't see anything in
> the ACCEPT path that tells software TC the packet has already been
> processed. For example:
> 
> tc filter add dev eth2 ingress pref 100 protocol ipv6 flower skip_sw \
>      ip_proto udp dst_port 5201 \
>      action police rate 100mbit burst 1m conform-exceed drop/ok
> 
> tc filter add dev eth2 ingress pref 200 protocol ipv6 flower skip_hw \
>      ip_proto udp dst_port 5201 \
>      action drop
> 
> Wouldn't a conforming packet reach software, skip the first rule and
> get dropped by the second, despite already being accepted in hardware?
> 
> Can you test this? The existing gact ok path might have the same issue.

Yeah, in both cases (police and gact ok) the conforming packets are 
pushed up, where they get dropped by the skip_hw rule. My understanding 
is that with existing behavior the restore doesn't happen on accept 
path, so sw tc takes the packet through classification again.

> Mark

