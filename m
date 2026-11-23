Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795469667;
	b=RN/HgSfBPIR9AyIw6sGaQwqci/D8oPjDd+Msgh7n8Gjvex+bL8yolqFzSDCVQ3w+8wI6
	 99mCkZEv9pYfmO+topSJf95ZlXZpQJy2zRje8a9tYJXhzfi5xNa06WwRZeolUXY8NC0M6
	 sLkGdGMgEKIaEUaL2lfqkvZx+1qojCKB+JWK/SyEf+J57wYAcSvqYJUZsB+iQJHtudH8l
	 MhqH9xVn2aMnW1dB8tH729hgYQ44HfhooQau5Xxti20mW+rgFAdlFsLh/PEZHIc8wLLef
	 3b2czMFbikGo1wmwGXoYFA3dbzH44JwHBF9tPNVHnaEccZVTYLi50KfwHobRUF5Bzxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795469667;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=0CvUnIpTCsoLAZFv5fEnyxCYoygVAmsjuGHwr8OUOzE=;
	b=ULqWBN5H+M60Y3xM30FnK7Tk3Xp6inj5iPZCMWdIRW1TzyER+n+U+7anb7jt1w5vr9vq
	 LkunjIONHt3oAXUc8QQK1I/wUdpTq3t43bDbi83Ywj/NNn6on6f4v33f7yN9dWgCHLPfP
	 TR26f+IFkW8Gdh9pnwHctS5d6P/F+N72ejO0vbFBhpUMnWu0IfRCY9EWczHBn7ilF+JvC
	 ezGXIZB/aUFbajdUn/TLyhgay7oUh0H1j7B4vrBYV6XcbcLn6E3CAkC9Cog6zXsheQUOX
	 JeoLTEYsGFB0uRsuIGlpndaUH62JMsOlulRw+SDUjPBKzWhXAlqmwYTMss2zhINd3dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SokxTiBz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBD5606A31E;
	Mon, 23 Nov 2026 21:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SokxTiBz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80191F000D8;
	Mon, 23 Nov 2026 21:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795469667;
	bh=0CvUnIpTCsoLAZFv5fEnyxCYoygVAmsjuGHwr8OUOzE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=SokxTiBzfM6nkJz6PFUfTNET9o+qkwp5JM85l21kyooUPTGup9EQoyYoUxNvkwibY
	 Akwh+tOjVcXxv3H95tPYc+zT2+2QOyy83LJwfpy86vNtYOr7ckWuSTAUrcb+brrME7
	 ud3negYEvS4y2X+YF1917wFVuZt+JoOGqBnWbXqQ3hMd8m+it3Mav5+L80zm1HxtXC
	 9JZuryI8A7Yzvt6qtjKc1oLpxojwIj46iHPTPBFLdlggKYZdkFa+SgDeWpYFBEU9hg
	 4fToR49GuDLF257oa1CCm6LrKKTZdmym9d/qA5+VeMQA8e0rsnnkhmzs9+nbUxx8v5
	 TdzRz0oy6StHA==
Subject: Re: [PATCH net-next v3 05/11] net/mlx5e: TC, reject a partial tunnel
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
Date: Mon, 23 Nov 2026 21:34:25 +0000
Message-ID: <179546966530.3135.14742631609975673237@kernel.org>
In-Reply-To: <20261122213200.3207385-6-acassen@corp.free.fr>
References: <20261122213200.3207385-6-acassen@corp.free.fr>
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
  (drivers/net/ethernet/mellanox/mlx5/core/en_tc.c), the new check…

--

net/mlx5e: TC, reject a partial tunnel key with tunnel mapping

This patch makes mlx5e_get_flow_tunnel_id() refuse any enc_key_id mask
other than all ones. The tunnel mapping stores the matched key, and the
metadata of a packet that misses in hardware is restored from it.

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

[Severity: Low]
Is this check too strict for VXLAN and Geneve? It compares against a
32-bit all-ones mask for every tunnel type. Those tunnels carry a 24-bit
VNI, so a mask of 0x00ffffff already covers every bit a packet can carry.

Both parsers run before mlx5e_get_flow_tunnel_id(), and they already
reject keys that don't fit in 24 bits:

mlx5e_tc_tun_parse_vxlan() and mlx5e_tc_tun_parse_geneve_vni():
	if (be32_to_cpu(enc_keyid.key->keyid) >= MLX5E_TC_TUN_N_VNI) {
		NL_SET_ERR_MSG_MOD(extack,
				   "Tunnel key does not fit the 24 bit VNI");

The mask is then written into fte_match_set_misc.vxlan_vni[0x18] or
geneve_vni[0x18]. Both fields are 24 bits wide, so 0x00ffffff and
0xffffffff program the same hardware match.

This means the masked key stored in the tunnel mapping is the full VNI.
key32_to_tunnel_id(key.enc_key_id.keyid) in mlx5e_restore_tunnel() would
give back the packet's real tunnel id, so the wrong-id restore described
in the commit message can't happen with this mask.

Once the flower enc_key_id mask patch later in this series is applied, a
VXLAN or Geneve rule such as "enc_key_id 42/0xffffff ... action goto
chain 1" would fail here with -EOPNOTSUPP. The same goes for a sample
action, or for any such rule in a chain above 0. With skip_sw the rule
is refused, and otherwise it stays in software. Only GRE uses all 32
bits of the key.

Could the check instead require that the mask covers the full key width
of the tunnel type? No later patch in the series changes
mlx5e_get_flow_tunnel_id(), so this limit is still there at the end of
the series.

> +
>  	esw = priv->mdev->priv.eswitch;
>  	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
>  	uplink_priv = &uplink_rpriv->uplink_priv;

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261122213200.3207385-1-acassen%40corp.free.fr
