Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795380736;
	b=TWNBG/SkJaGQ9uAp6LXTwYVaENsAbi12yUng1sGO1vM6Gfid+ak+7kgyxsb+++Pc6aJq
	 GVMhO4+fcX9aii36wB4b5diaS0qzLCy3yibBHQ+QT/hUQkuY9pVDzj66YFKE0ydjIs4nr
	 OCRVQ9m9Pdn0s1pLUDNYDPv/yTZ9yLZR2y1a4qZ++TnoWVq0skhJZVQ9P6ypCFIfT64nm
	 uXwFOPfubeNM3LUkmimLVb/R17Zt/7xV4fkVcYkS7jaURIuinKIGaE9RK5dLCuvWQddXk
	 Q1nRk3/vjKzWO9e5EYAz3GOvgm3kj7vxhbehbqqNkzwoV+D4Sl9ll9pHE1ntNVdTQew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795380736;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=ub/o+NYQ5pm8BwB5aYpp2bp6JXQS+XMCaTR9q9LIwTc=;
	b=YG/iL4gM+rpGWLIgHV+71Yhk3H7bNtyR3YMFxOvoNQxxgn2pFayT86bl3LTxP3J5Gs5S
	 5roWdp6vO4s6DEtgPQaS49127YYrxop/XRkqjYHZd9hSNXEc4sw7hTz+cudos5nc0w/Km
	 uDQpA3WFMLxB4c6LFBWy3zrphg+uwfRQEmBCgMlDZ4JuAbppTjLQnnFgV15WHlVHBU0Lp
	 xgw3T9qRMDbhjSC4Y8BpGqZnAzcyHS80Huv5pslQ1sVH/ql5topiP38dyKyEOO7cKLB5o
	 Fke+ZALm4OmQ+wQ984nc+oF7s83AX2iPi+go+Mhv3qzeYojes0yzXJ/LfKDH1xCAPxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=j4VgXjuI;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9694C606A31A;
	Sun, 22 Nov 2026 20:52:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9694C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=j4VgXjuI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1795380733; bh=WsjM7iTjR2vD7tYEQEjXsVKnYR6/ArOoRprNQpgU0x8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=j4VgXjuIcEcOQ5P573bvYlxgZjKICjIaIwRpZ5qqELwWSQk7APMTVyoMTzCuhnNi8
	 c/8+4skZYF53viCg5+Rnoi9jhKTABTdIa26N8cwRMYAgFNj2HKsvSgXCsJwdXaGDRK
	 ZnktwSCTfrtJKkD9ihZr906lFhZwlU6Je5HbkAkQ/FkVog+1KFYPP6TXe+p97jQab3
	 nVjW+JCE3d/os1QbjHmNDbri8Dw6igJXX+tTYP4cDes6GffrRmP9a8EzBcrJdP5zQx
	 VyRCBWHcbC4nY1sOwZ9yRf09FcUEYjWg8r1QIzylMWyvvXn2icayYC/y0jvZJ2bXhb
	 7+pgMjmtBvxQQ==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id 051F844C0459;
	Sun, 22 Nov 2026 21:52:11 +0100 (CET)
Message-ID: <e3163758-5829-46a7-b49c-08411c0f123a@corp.free.fr>
Date: Sun, 22 Nov 2026 21:52:11 +0100
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
Subject: Re: [PATCH net-next v2 09/10] net/mlx5e: TC, match the tunnel key
 without a tunnel device
To: netdev-bot+sashiko@kernel.org
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 jhs@mojatatu.com, jiri@resnulli.us, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, michael.chan@broadcom.com,
 pavan.chebbi@broadcom.com, bharat@chelsio.com, donald.hunter@gmail.com,
 corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org,
 dsahern@kernel.org, idosch@nvidia.com, shuah@kernel.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 oss-drivers@corigine.com
References: <20261117092915.255194-10-acassen@corp.free.fr>
 <179514544426.3136.3728064977734495529@kernel.org>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <179514544426.3136.3728064977734495529@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/20/26 04:30, netdev-bot+sashiko@kernel.org wrote:
> [Severity: Low]
> This isn't a bug, but this paragraph describes an existing mis-offload.
> On a device that is not a tunnel, __parse_cls_flower() accepts
> FLOW_DISSECTOR_KEY_ENC_KEYID in its used_keys allow-list, and nothing on
> that path reads it.
>
> In this patch the fix arrives as a side effect of a new feature (a new
> tc_tun_gtp.c, a new parse_outer_key op, new capability requirements).
> There is no Fixes: tag, so the fix can't go to net or stable on its own.
>
> Other fixes in the same series do carry Fixes: tags, for example
> "net/mlx5e: TC, refuse a tunnel key wider than the VNI".
>
> Would it make sense to send a minimal fix to net that refuses enc_* keys
> when filter_dev is not a tunnel device, and then build the feature on
> top of it? That fix would also cover the __parse_cls_flower() gap
> described below.


Yes. v3 adds that fix as its own patch before this one with a Fixes tag 
on 075973c7d7bb.
It refuses every tunnel key without a tunnel device. This patch then 
only lets enc_key_id
through and its message no longer describes the old behavior. The bug is 
old and nobody
reported it... and this patch builds on the fix. Like patches 2 to 4, it 
stays in the series.



> [Severity: Medium]
> This one may be speculative. Should this path also check the driver's
> VXLAN port table?
>
> The tunnel device path goes through
> mlx5e_tc_tun_parse_udp_ports_vxlan()->mlx5e_tc_tun_check_udp_dport_vxlan(),
> which refuses the rule unless the port is known:
>
> 	if (!mlx5_vxlan_lookup_port(priv->mdev->vxlan,
> 				    be16_to_cpu(enc_ports.key->dst))) {
> 		NL_SET_ERR_MSG_MOD(extack,
> 				   "Matched UDP dst port is not registered as a VXLAN port");
>
> mlx5_vxlan_lookup_port() returns false when mlx5_vxlan_allowed() is
> false. mlx5_vxlan_create() leaves VXLAN disallowed when
> tunnel_stateless_vxlan is missing or the function is not a PF.
>
> Here mlx5e_tc_tun_outer_lookup() picks vxlan_tunnel from an exact
> dst_port 4789 alone. After that, only ft_field_support.outer_vxlan_vni is
> checked.
>
> Suppose firmware can advertise that capability while the parser does not
> handle UDP 4789. Could a skip_sw rule then be installed with a VNI match
> that the parser never fills? The rule would match nothing or, if the
> masked key includes zero, all UDP/4789 traffic.
>
> I couldn't confirm whether firmware can report outer_vxlan_vni in that
> state. mlx5_vxlan_create() notes that the hardware adds 4789 by default,
> so this may not happen in practice.


No. Only dst_port 4789 selects VXLAN here. The hardware parses it by 
default and mlx5e
declares it as a static port that the stack never removes. The tunnel 
device path
needs the table because its port can be any one the stack registered!




> [Severity: High]
> Can a rule with other enc_* keys but no enc_key_id still be offloaded
> without those keys being matched?
>
> The refusal of the other tunnel keys only exists inside
> mlx5e_tc_tun_parse_outer_key():
>
> 	/* Without a tunnel device the other tunnel keys go unmatched */
> 	if (rule->match.dissector->used_keys &
> 	    (BIT_ULL(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) |
> 	     ...
>
> That function is only called when FLOW_DISSECTOR_KEY_ENC_KEYID is
> present.
>
> The used_keys allow-list at the top of __parse_cls_flower() accepts every
> ENC_* key for any filter_dev. Nothing else on the non-tunnel path reads
> these keys. mlx5e_get_flow_tunnel_id() and mlx5e_tc_verify_tunnel_ecn()
> are only reached through the mlx5e_get_tc_tun(filter_dev) branch.
>
> Take a rule like this:
>
>    tc filter add dev <uplink|VF rep|NIC netdev> ingress flower skip_sw \
>        ip_proto udp enc_dst_port 4789 \
>        action mirred egress redirect dev <vf_rep>
>
> The same goes for a rule with enc_dst_ip X action drop. Wouldn't such a
> rule skip both branches, reach hardware with the enc_* key dropped, and
> catch all traffic that matches its other keys?
>
> The over-match itself predates this patch. However, the commit message
> says "Nothing matches the other tunnel keys on this path. Refuse them in
> such a rule.", and the new code comment states the same rule for any
> rule without a tunnel device.
>
> Should this check cover every rule where mlx5e_get_tc_tun(filter_dev)
> returns NULL, and not only rules that carry enc_key_id?


Yes. The over-match predates the series as I said on v1 [1]...
The new patch in v3 refuses these rules. On ConnectX-7 a skip_sw rule on
enc_dst_ip alone dropped every frame of its VLAN without the fix and it 
is refused with it.

[1] 
https://lore.kernel.org/netdev/d9956526-edd9-4d8c-85cb-42670ee0b308@corp.free.fr/

pw-bot: cr


