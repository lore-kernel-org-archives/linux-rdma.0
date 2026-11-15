Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794735348;
	b=bVxxROLvF1grkY5oyOTfxD7ySTTA5HYmedUgwea841DL+YmrwsQoN7BbrWkBeYwtfZ8Z
	 R/SeEmO5k7LKjyu5P+SPwEZ+TUfyaVNocCFC+sun6dQJxmq2bmfSvMN2W9G67Kt4VPY6/
	 2AR9u1pvl6DFWEBBVymlgLLXU4g/vQyoJcnlmMpJmkyAlQCj13eTCSbmGpwam0YpW6hKW
	 +o99XH+YeKy2i3xox6vpenEbTkQZKKJJCO+Yot4ZjWmujUgSIzjv9p6qbNzGXy6uVFgMU
	 +Kdxp2cr2LT6Rb8Qk7HqDqw9VcEcavCnb9v2zrURWR+bECf8aZl/RH1dG7KVMHLdexw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794735348;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=vNH2MZuApL5YDTOSUTfDpUJ91yQsUgYD3FvfPJN7/C0=;
	b=38ZOPIoVNLieMfQ2TZoHsBgkGlzH5q8N871GRjRVxaXOcBFPl3e7nkC9fXCJBiL3Uy/z
	 XExLqb2GC4gnxM4RPEdeqOlBGVkRx03pvwjVzgE8ivMowLLMSuuJqio+eRcL949oz47Q9
	 qpabf6/VDVtjrsk2cg1MmL1/t2ooaD+0y8vUvHf+6wpr0TmUTahfyjBtec0VW90R6BnBn
	 0f0bcFYJJuFENgC514SyQFZ7M2lfq8b8Ir6VgAj+8Mmco1sEZ6mPWZO4H1fxzwZsYwG5O
	 e9cm79hMoLJh9Q3Qm2voiH3uI3oI/Lf4wjilFynKSGcIFaLTSQAVdjlVsq+JInZQ79g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=VZtcyiee;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2806E606A31D;
	Sun, 15 Nov 2026 09:35:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2806E606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=VZtcyiee
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794735346; bh=6fMjWIeIdYpKpmz6XprTWXXqXk3u6uBajFiJMaSzxOQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VZtcyieeykN/y7SwZzmJmmACNYFyoPVeb9hVb1m/O7AEkMOkTEWcFDwCtkbsYWZrm
	 rKuNUJhebAwzs7zreqBTrcX+UAGrT2bqWpgrwPSKI2/j9Ee322Ka36wiG2lFM8IP7R
	 8ICEsIuLKMehBhoUPPMElm78cK+R7tsNZItCfz7Of8ylM9W6U3ZD2s52IXXPmQHPQl
	 cfiN3bmw28mYo1ZNb6O64P5oxwvPxuuKBSyCykqp7iTdeflQ9ObnTXVc5no6g8JRJN
	 2aqjF8o75qOwgrv/VgGccD8oXwhSoIG78YIDH8rrIDR7wn5wfVr9KCXWCouQHIClju
	 oGMYdM3NSjVfQ==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id C87EB44C089C;
	Sun, 15 Nov 2026 10:35:44 +0100 (CET)
Message-ID: <d9956526-edd9-4d8c-85cb-42670ee0b308@corp.free.fr>
Date: Sun, 15 Nov 2026 10:35:44 +0100
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
Subject: Re: [PATCH net-next 09/10] net/mlx5e: TC, match the tunnel key
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
References: <20261109131039.959438-10-acassen@corp.free.fr>
 <179442433391.2199510.196528697168850523@kernel.org>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <179442433391.2199510.196528697168850523@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/11/26 20:12, netdev-bot+sashiko@kernel.org wrote:
> [Severity: Medium]
> This describes a bug that predates this patch. Before this change,
> __parse_cls_flower() whitelisted FLOW_DISSECTOR_KEY_ENC_KEYID but only read
> it when mlx5e_get_tc_tun(filter_dev) was non-NULL. So a skip_sw rule with
> enc_key_id on a non-tunnel device was offloaded without the key.
> 
> Could the fix go in its own patch with a Fixes: tag? As it stands, stable
> trees can't take it without also taking the new outer key feature,
> tc_tun_gtp.c and the parse_outer_key op.


This patch doesn't fix the old behavior. Since 075973c7d7bb a device 
without a tunnel ignores every tunnel key. Fixing it means refusing them 
all, which is a separate fix for net. This patch only gives enc_key_id a 
match.


> 
> Is the old bug really limited to the uplink representor?
> parse_cls_flower() is shared by mlx5e_add_nic_flow() and
> __mlx5e_add_fdb_flow(). That suggests the NIC netdev (FS_FT_NIC_RX) and VF
> representors accepted enc_key_id the same way without matching it.


No. NIC flows and VF representors did the same. v2 fixes the message.


> [Severity: High]
> Are the other tunnel keys in the same rule silently dropped here?
> 
> The used_keys whitelist in __parse_cls_flower() still accepts
> ENC_IPV4_ADDRS, ENC_IPV6_ADDRS, ENC_PORTS, ENC_IP, ENC_OPTS and ENC_CONTROL
> on any filter device. Only two places turn these keys into hardware
> matches:
> 
>    - mlx5e_get_flow_tunnel_id()
>    - mlx5e_tc_tun_parse() and mlx5e_tc_verify_tunnel_ecn()
> 
> Both are reached only from the mlx5e_get_tc_tun(filter_dev) branch.
> 
> This path programs only the key register and then returns 0. Take this rule
> on the uplink representor:
> 
>    tc filter add dev <uplink_rep> ingress protocol ip flower skip_sw \
>        ip_proto 0x2f enc_key_id 100 enc_dst_ip 10.0.0.1 \
>        action mirred egress redirect dev <vf_rep> skip_sw
> 
> It looks like the rule would be accepted. Hardware would then redirect
> every GRE packet with key 100 to that VF, whatever its outer destination.
> enc_opts, enc_dst_port and enc_tos would be ignored in the same way.
> 
> Because skip_sw is required, software never shows the wider match. A
> documentation patch later in the series says "All the keys describe the
> packet on the wire", which makes such rules more likely. That patch does
> not change this code.
> 
> Should mlx5e_tc_tun_parse_outer_key() refuse rules that carry any other
> ENC_* key?


Yes. v2 refuses them on this path.



> [Severity: Medium]
> Can this path be hit on VF representors whose eswitch min-inline mode does
> not cover the tunnel header?
> 
> For non-uplink eswitch flows, parse_cls_flower() only checks the match
> level:
> 
> 	if (rep->vport != MLX5_VPORT_UPLINK &&
> 	    (esw->offloads.inline_mode != MLX5_INLINE_MODE_NONE &&
> 	    esw->offloads.inline_mode < non_tunnel_match_level)) {
> 
> mlx5e_tc_tun_parse_outer_key() writes misc.gre_key, vxlan_vni, geneve_vni
> or misc3.gtpu_teid, but it never raises *outer_match_level. The level stays
> at MLX5_MATCH_L3 (from ip_proto) or MLX5_MATCH_L4 (from dst_port).
> 
> On the VF TX side, mlx5e_calc_min_inline() does:
> 
> 	case MLX5_INLINE_MODE_TCP_UDP:
> 		hlen = eth_get_headlen(skb->dev, skb->data, skb_headlen(skb));
> 	...
> 	case MLX5_INLINE_MODE_IP:
> 		hlen = mlx5e_skb_l3_header_offset(skb);
> 
> So inline_mode IP does not inline the GRE key. With inline_mode TCP_UDP,
> the inlined bytes end after the UDP header, so the VXLAN, GENEVE or GTP-U
> header is left out.
> 
> A GRE key rule therefore passes the check with inline_mode IP. A VXLAN,
> GENEVE or GTP-U rule passes with inline_mode TCP_UDP.
> 
> On min-inline devices, such as ConnectX-4 Lx with vport context inline
> mode, could the eswitch miss these bytes in VF-originated traffic? The
> skip_sw rule would then never fire, or would match the wrong packets.
> 
> Before this patch, tunnel key matching never reached hardware on VF
> representors. The VF representor testing in the commit message was on
> ConnectX-7, where inline mode is NONE.
> 
> Should this path refuse the rule on non-uplink vports when
> esw->offloads.inline_mode is not MLX5_INLINE_MODE_NONE?


Yes. v2 refuses it there.




