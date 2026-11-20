Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795145440;
	b=itBTvYywGH7P3nNXyVdy9s1Jr3sfjwWIkqjiZSkK9Nh0OuJAMnn538siM47z439nd4yW
	 tEEaL/ce7NK3p7Zq7Fqk7l0P6phdZ2LLENJZribcew7WqxQtilZUDJvNI2k0H1b8qYjPt
	 ACgcwcMCx9XXAWdrnrzkwNmOgGvjM3tcgKJJ1OuxAiEvfkTBtBUrFprzVyGgF5vDV1yaH
	 jLv00sK4hkkY/ercrj3hj5aqaqyNEU3dqzo34+Bhl6HRC+531hL5CP6DiRFyzF6rJYNYE
	 Q2xo+67+6LtKD/zpnnEdloqmPVOWU5i6bQkjKA1UP+ygh1vY0ry44+u4No/4yAAZxEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795145440;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=svVu4tGtXkUqJeH2S67jLdV8xt9bisNFvl26L3qlsJI=;
	b=d2g+Z9tt8M2CW/TMpT84cpEbH89E9TQ87/9pyRvA2VNR65VgLGQLoTCyOEK+l8s5rde9
	 QVQa8as78o3SpcunU26OyhYqB7kXhST5e9QdxEG4yI2BTLQ33qNWTp8x54JGUar6RleYq
	 lMFANiooOmlg5HHetxVtUXr3XQGCJzN0PxF1z0E5UdOONNeS0h1eS/sqE3BlTJuXrNsDT
	 1H+eYpCH5FQ1nIo2GSP3kJSbN+a4mMmM57XEgS4NntTbQO9Py9ixbjCuZxcD0287EuDx5
	 CvSXyro+vZGg+qlpFKtO4BDPZNHf/OMtdwd07yf/cw+7l+JrbgoyML/0MbTYDKglK4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aDlHmmls;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70685606A330;
	Fri, 20 Nov 2026 03:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aDlHmmls
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08DE1F000C4;
	Fri, 20 Nov 2026 03:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795145440;
	bh=svVu4tGtXkUqJeH2S67jLdV8xt9bisNFvl26L3qlsJI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=aDlHmmlsjwOA5819XcEcfYMdn8JfR28OvPOsvKTx0IvSVNwF4EPrIIjThTpSF+xhV
	 SXIPRVt5CWJJPkFXn7odk6Ivi9ct95PMwWeGhgTWFNEL+4c3dgZ8Z42kwOApD/aUun
	 tzBSH/gg3LP56jeUxPpha5PSoe74n347ABHUEyl8Og9S5CvQFS6ZWMdYDzMgDhqe77
	 Al1CohkjkRmIFvMoyFO1giovqfviL1u4aosq33NSQynsME8y92DXSa2xQYfOUVYbB2
	 3ZQU1GeG+abQ4T+rdAmM3BbSBLnL4E3QyKQUq0rrb8+iCyDpISs/UlEf0ut57A1zEx
	 qKDNUOyoYH+Xw==
Subject: Re: [PATCH net-next v2 05/10] net/mlx5e: TC, reject a partial tunnel
 key with tunnel mapping
From: netdev-bot+sashiko@kernel.org
To: acassen@corp.free.fr
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 jhs@mojatatu.com, jiri@resnulli.us, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, michael.chan@broadcom.com, pavan.chebbi@broadcom.com,
 bharat@chelsio.com, donald.hunter@gmail.com, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org, dsahern@kernel.org,
 idosch@nvidia.com, shuah@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, oss-drivers@corigine.com
Date: Fri, 20 Nov 2026 03:30:38 +0000
Message-ID: <179514543838.3136.15751272244504735479@kernel.org>
In-Reply-To: <20261117092915.255194-6-acassen@corp.free.fr>
References: <20261117092915.255194-6-acassen@corp.free.fr>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] In mlx5e_get_flow_tunnel_id()
  (drivers/net/ethernet/mellanox/mlx5/core/en_tc.c), the new check only…

--

I found one low-severity regression in this patch: the new check in mlx5e_get_flow_tunnel_id() refuses a VXLAN or Geneve rule that uses the full 24-bit VNI mask, even though the hardware programs it the same way as an all-ones mask. The reply below is ready to send to the list.

net/mlx5e: TC, reject a partial tunnel key with tunnel mapping

This patch makes mlx5e_get_flow_tunnel_id() reject flower rules whose
enc_key_id mask is not all ones. The tunnel mapping keeps the matched key
and uses it to restore metadata after a hardware miss. The change prepares
for flower accepting enc_key_id masks.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 1d35c97aea0bc..ba3aef3c80635 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c

[ ... ]

> @@ -2265,6 +2266,16 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
>  	u32 value, mask;
>  	int err;
>  
> +	/* The mapping restores the tunnel id of a packet missing in hardware */
> +	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
> +		flow_rule_match_enc_keyid(rule, &enc_keyid);
> +		if (enc_keyid.mask->keyid != cpu_to_be32(U32_MAX)) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Partial match of tunnel key in chains isn't supported");
> +			return -EOPNOTSUPP;
> +		}
> +	}
> +

[Severity: Low]
Should this check depend on the tunnel type? For VXLAN and Geneve the
tunnel id is a 24-bit VNI, but this check requires all 32 mask bits.

The VXLAN and Geneve parsers already refuse keys that do not fit in 24
bits:

drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c:mlx5e_tc_tun_parse_geneve_vni() {
    ...
	if (be32_to_cpu(enc_keyid.key->keyid) >= MLX5E_TC_TUN_N_VNI) {
    ...
	MLX5_SET(fte_match_set_misc, misc_c, geneve_vni, be32_to_cpu(enc_keyid.mask->keyid));
    ...
}

mlx5e_tc_tun_parse_vxlan() has the same check. The mask is then written
into the 24-bit vxlan_vni or geneve_vni field of fte_match_set_misc, so
MLX5_SET() cuts it down to 0xffffff. On the VXLAN-GBP path,
tunnel_header_1 gets mask << 8, which is 0xffffff00 for both masks.

As a result, enc_key_id <vni>/0xffffff and enc_key_id <vni>/0xffffffff
program the same hardware match. Also, key & 0x00ffffff equals key for
every key the parser accepts. So the wrong-tunnel-id case from the commit
message does not seem possible with this mask.

After "net/sched: cls_flower: add enc_key_id mask" later in this series,
a VXLAN or Geneve rule with the natural full-VNI mask 0xffffff would get
-EOPNOTSUPP on every tunnel-mapping path. That covers rules in a chain
greater than 0, and chain 0 rules with goto or sample actions.

Would it work better to compare against the id width of the tunnel (24
bits for VXLAN/Geneve, 32 for GRE)? Another option is to compare the mask
only over the bits the device actually programs.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261117092915.255194-1-acassen%40corp.free.fr
