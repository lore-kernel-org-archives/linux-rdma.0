Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795381033;
	b=0RREsd9i3J8U3zDslOZe/bIJBj32fxu2D8irSIgwooGlDO3FGhSPcScF2H+erNR8p3mb
	 U136A6Wd5jJc7OGi+ZLmZg1NH6TNT40GuA5+rBBBwC8q+FO1CpGn7QpOfJHCey/ejZL0p
	 //a6Ps8bK0zd7WoRMVTq0qJmAk66qAeXvfF8qTNLul5JMDQw9NTLfjc0SgMPzrAQfQiYD
	 7zZ8GGp4JEVuNf/KrELId8+4wZd+Cs+dxlUtbqu3wUxnyakh+rwPpj07c9xF1KNHE4FbE
	 wnJu/CbgXYal9cX5oyEkrVAY7DYUYGU4zZSmlHU0C+ZQrRWG91p7iky4rqe7k8RqtMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795381033;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=yIEAeJJhh545A+d8R8ZP72GJKN4grQvJ9n+GKgnK/2s=;
	b=eFuSAVB1PjiuXLWnzPfmdVnNkvRe6Li4AxBwn7JFV6QCTYkKad0F9KNcXaLwoYMu1ayC
	 GGM04ckxZ+jIG+sNCR6J+yGzfb9Qk0gvvIFyPJFv3UOI0WbFMQ3mIShzyX4Vb0BArwzcX
	 tcYEYATj4pqAw2hPMOhtngOcZahziV5pLUwauO1o9qz5GWRppwG8CM3giLgb0By0HaslV
	 LGIQ/SWIB6UlSO/KPZV/j/qPIgiuduPeGOQTPyn5ecWgMu7LamgGetlRDPsuF7Y5lMKzn
	 Xq619gmEN1DkJEWL3vBOPe7o6Gftti90M6++FwOrrO3reSrXGMBdhHGTKDfFFZBz4vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=IG8O6WXj;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DAB606A31D;
	Sun, 22 Nov 2026 20:57:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8DAB606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=IG8O6WXj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1795381031; bh=KRJiDlse0G6+CAgKwCdP300usgLB9uEV6J3e9CTYwtQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IG8O6WXjGRsSeKGvVWkehqu6ICBUGrwOCWhdcXyS8/Y/UPgP5lGIwaQqy/Wrxtb/Q
	 U6vA+t+YaooTjJbtKt0bFCBj2TqYPXHUHWz4S9nIxlq6E5Wv7L6t/puVplYKsBEMTU
	 5l5pNEXHI74rOm3t0visFtWQT38WaAmUp71gstSPF7fuN9IfaLBk2wH9Qh9gul+vuV
	 ZpPrOKNB+Vp8ZSKiQ3bpE/kVsgzhsig3mm74PrpVwmPvzu4q+LeeFtikvO2+/IDVLT
	 mqtML7mMvj9ZOY8l0wCpgo377kiejFrC+6QDpos49M203Z/rDn/BK+JVkGzrZAfzdc
	 LHFm2lg18cACg==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id 74FB944C0515;
	Sun, 22 Nov 2026 21:57:09 +0100 (CET)
Message-ID: <bfa7625b-1452-4ced-b172-604216264cfc@corp.free.fr>
Date: Sun, 22 Nov 2026 21:57:08 +0100
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
Subject: Re: [PATCH net-next v2 10/10] docs: networking: describe tunnel key
 partitioning in TC queue filtering
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
References: <20261117092915.255194-11-acassen@corp.free.fr>
 <179514544619.3136.11935885435056519543@kernel.org>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <179514544619.3136.11935885435056519543@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/20/26 04:30, netdev-bot+sashiko@kernel.org wrote:
> [Severity: Low]
>
> Does this example work on mlx5 with the default firmware configuration?
> mlx5e_tc_tun_parse_outer_key_gtp() refuses the filter unless the firmware
> reports the GTP-U TEID flex parser:
>
> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gtp.c:mlx5e_tc_tun_parse_outer_key_gtp() {
>      ...
> 	if (!(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) &
> 	      MLX5_FLEX_PARSER_GTPU_TEID_ENABLED)) {
> 		NL_SET_ERR_MSG_MOD(extack,
> 				   "Matching on GTP-U TEID is not supported");
> 		return -EOPNOTSUPP;
> 	}
>      ...
> }
>
> The GENEVE selector also needs a flex parser bit (MLX5_FLEX_PROTO_GENEVE,
> checked through mlx5e_tc_tun_can_offload_geneve()). The preceding commit
> "net/mlx5e: TC, match the tunnel key without a tunnel device" says "GTP-U
> needs flex parser profile 3 and GENEVE profile 0". That means the 2152 and
> 6081 selectors listed further down cannot both be available at once.
>
> If the firmware default is profile 0, the firmware will refuse this
> example, and the extack message does not mention the flex parser profile.
> Could the text mention this firmware dependency?
>
> Also, the example passes skip_sw on the filter, but the text only implies
> that it is required ("Only the hardware can match the key").
> mlx5e_tc_tun_parse_outer_key() refuses the offload without it:
>
> 	if (!f->common.skip_sw) {
> 		NL_SET_ERR_MSG_MOD(extack,
> 				   "enc_key_id without a tunnel device requires skip_sw");
> 		return -EOPNOTSUPP;
> 	}
>
> Would it help to state that requirement explicitly?


No, as on v1. The document doesn't repeat each driver limit. The mlx5 
commit names
the flex parser profiles and the driver refuses the filter with an 
extack that names
the missing match or skip_sw.


> [Severity: Low]
>
> Is "physical port" the full scope here? __parse_cls_flower() calls
> mlx5e_tc_tun_parse_outer_key() for any filter_dev that is not a tunnel
> device. That includes FDB flows on VF representors:
>
> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:mlx5e_tc_tun_parse_outer_key() {
>      ...
> 	if (fs_type == FS_FT_FDB && !mlx5e_is_uplink_rep(priv) &&
> 	    esw->offloads.inline_mode != MLX5_INLINE_MODE_NONE) {
> 		NL_SET_ERR_MSG_MOD(extack,
> 				   "Flow is not offloaded due to min inline setting");
> 		return -EOPNOTSUPP;
> 	}
>      ...
> }
>
> On a VF representor the keys describe what the VF sent, not the packet on
> the physical wire. The text also does not mention the min inline
> requirement.
>
> Separately, the example's action is only registered for NIC flows:
>
> drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c:tc_acts_nic[] {
>      ...
> 	[FLOW_ACTION_RX_QUEUE_MAPPING] = &mlx5e_tc_act_rx_queue,
>      ...
> }
>
> tc_acts_fdb[] has no such entry, and mlx5e_tc_act_get() uses tc_acts_fdb
> for MLX5_FLOW_NAMESPACE_FDB. Wouldn't the documented command then be
> refused on the uplink representor in switchdev mode, even though that is
> the physical port?
>
> Could the paragraph say that queue_mapping steering only applies to NIC
> (legacy mode) flows?


The paragraph covers a filter that steers to a queue. mlx5 offloads that 
action in
NIC flows only and a representor never takes it. The mlx5 commit 
describes the representor cases...


> [Severity: Low]
>
> Should this mention that VXLAN (4789) and GENEVE (6081) carry a 24 bit
> VNI? The example above partitions on the top two bits of a 32 bit key,
> but both parsers refuse keys that do not fit in 24 bits:
>
> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c:mlx5e_tc_tun_parse_outer_key_vxlan() {
>      ...
> 	if (key >= MLX5E_TC_TUN_N_VNI) {
> 		NL_SET_ERR_MSG_MOD(extack,
> 				   "Tunnel key does not fit the 24 bit VNI");
> 		return -EOPNOTSUPP;
> 	}
>      ...
> }
>
> mlx5e_tc_tun_parse_outer_key_geneve() has the same check. So a filter that
> copies the example with dst_port 4789 and enc_key_id
> 0x40000000/0xc0000000 would be refused. For those tunnels the top of the
> key space is bits 23:22, not 31:30.


The VNI width comes with the protocol and the example is GTP-U. The 
driver refuses a wider
VXLAN or GENEVE key with "Tunnel key does not fit the 24 bit VNI".


