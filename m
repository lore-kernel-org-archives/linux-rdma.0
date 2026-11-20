Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795145446;
	b=RTqLHNUgRC1/G8q0RNUWC3vJXELWPOXat6og3z/+P0A7KIhgXO2aIxNN8TyLwSU0wRnX
	 4q49WeMUO3nuJKydVJkV/O+YghSQBdvJ055bk03qtbL0RplvHB0+heA4jy834SFhmq441
	 o56oiEnYOiAGkXsGfw9RE00dpD2l0S4dH/t5O/NFUg2vhEW4kYyN0hnGz/PjWIBRRPdcA
	 jpTj7N0WZJV18IYofT00uF2gEIBC6M7becInwN4PAXiWh1aS8ZcZ/QPBD5ZoHlukjOY4l
	 O6Toz6SNpquxQZYHyTWdIRyze5HshAp5XgQqAEo7bsgn8OcM2AmcVwk9D9SxzqT6iag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795145446;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=vK4QUXUiTfHup41my65EvPZk5UpSNzvc3ogu+VzFD00=;
	b=a4II2Mh38vBhBDNny7FY0zBp/2y6eWxxj5q4OX/AFdajYFK280V5d6AN7h1jjIRc+AjH
	 qlJZhmSV/yFSNLD+pzrVO4jmvxoC+0iDwo5w9yi6NYVJT48qr+PcpQ0s9M+LKYfwzNU8n
	 VqtsWZ70wIgRrDsYWDznuxl09k35tBIHaZYtKYJT9ylhSczj58PNs8ht3WEfjlEfvZZW9
	 HEykXGIA2rgDQqfr4o+rSZEtHA6J/81YG4ezPUeMjzvTDArGIhJKOXgFzL/V1cd27DB1l
	 rNDRsIBKpaPA6hVEf3nawgLtmcZ5e/5+T3vnMiNKOOREB/VmmZvyGuyQCzoALa4vY6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c9lX2c1R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5C460A2611;
	Fri, 20 Nov 2026 03:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c9lX2c1R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63FE1F000C4;
	Fri, 20 Nov 2026 03:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795145446;
	bh=vK4QUXUiTfHup41my65EvPZk5UpSNzvc3ogu+VzFD00=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=c9lX2c1RT4YfEQqeEy899DsroMwn1127JTLXm/ZCxtukerCv0uN4Q7ILBv5AqFRhM
	 2zRxCdlmVPH/FIM8KEm0ejsx8ujKfaPOFnOKv9Wig4WlFHJTMhNft0AWrOnrreJyBQ
	 MqJqd/alsJSsmplI0NoiGDBuKttA+6mS/IZdKsWMHuMMPQjbNklkPlEBxkvvEhN3FA
	 sYtQkYon8kQeA6ITmFxy+kgOTJ+SHt77ayGOFqv4lXft8Bn7ALOTgtWSsbLzkqHJI/
	 8Xo7g+F0/JBbWZvWo0+7kejev7mXhcCFqpcW5546DVFhBFYqJuCHJB+wHWno6pOQ5U
	 Jne4NFJqxzxCg==
Subject: Re: [PATCH net-next v2 09/10] net/mlx5e: TC, match the tunnel key
 without a tunnel device
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
Date: Fri, 20 Nov 2026 03:30:44 +0000
Message-ID: <179514544426.3136.3728064977734495529@kernel.org>
In-Reply-To: <20261117092915.255194-10-acassen@corp.free.fr>
References: <20261117092915.255194-10-acassen@corp.free.fr>
X-sashiko-severity: High
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] When a rule has no tunnel device, the refusal of the other
  tunnel keys only runs if enc_key_id is also present.
- [Medium] This one is speculative.
- [Low] The commit message describes an existing user-visible mis-
  offload: 'A rule without a tunnel device used to accept enc_key_id…

--

net/mlx5e: TC, match the tunnel key without a tunnel device

This adds a parse_outer_key op to the mlx5e tunnel ops. On a device that
is not a tunnel, a flower enc_key_id match now programs the GRE key,
VXLAN VNI, GENEVE VNI or GTP-U TEID register, chosen by the outer
ip_proto and dst_port keys. Such rules must be skip_sw, cannot decap and
cannot carry other enc_* keys.

> This covers NIC and eswitch flows. A rule without a tunnel device used to
> accept enc_key_id without matching on it. It caught all the traffic of its
> other keys. It now matches the key or gets refused.

[Severity: Low]
This isn't a bug, but this paragraph describes an existing mis-offload.
On a device that is not a tunnel, __parse_cls_flower() accepts
FLOW_DISSECTOR_KEY_ENC_KEYID in its used_keys allow-list, and nothing on
that path reads it.

In this patch the fix arrives as a side effect of a new feature (a new
tc_tun_gtp.c, a new parse_outer_key op, new capability requirements).
There is no Fixes: tag, so the fix can't go to net or stable on its own.

Other fixes in the same series do carry Fixes: tags, for example
"net/mlx5e: TC, refuse a tunnel key wider than the VNI".

Would it make sense to send a minimal fix to net that refuses enc_* keys
when filter_dev is not a tunnel device, and then build the feature on
top of it? That fix would also cover the __parse_cls_flower() gap
described below.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
> index 33911e72d20d0..610e2bbc21f1f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c

[ ... ]

> @@ -261,6 +262,41 @@ static int mlx5e_tc_tun_get_remote_ifindex(struct net_device *mirred_dev)
>  	return ifindex;
>  }
>  
> +static int
> +mlx5e_tc_tun_parse_outer_key_vxlan(struct mlx5e_priv *priv,
> +				   struct mlx5_flow_spec *spec,
> +				   struct netlink_ext_ack *extack,
> +				   u32 key, u32 mask,
> +				   enum fs_flow_table_type fs_type)
> +{
> +	void *misc_c, *misc_v;
> +
> +	if (key >= MLX5E_TC_TUN_N_VNI) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Tunnel key does not fit the 24 bit VNI");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (!MLX5_CAP_FLOWTABLE_TYPE(priv->mdev,
> +				     ft_field_support.outer_vxlan_vni,
> +				     fs_type)) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Matching on VXLAN VNI is not supported");
> +		return -EOPNOTSUPP;
> +	}

[Severity: Medium]
This one may be speculative. Should this path also check the driver's
VXLAN port table?

The tunnel device path goes through
mlx5e_tc_tun_parse_udp_ports_vxlan()->mlx5e_tc_tun_check_udp_dport_vxlan(),
which refuses the rule unless the port is known:

	if (!mlx5_vxlan_lookup_port(priv->mdev->vxlan,
				    be16_to_cpu(enc_ports.key->dst))) {
		NL_SET_ERR_MSG_MOD(extack,
				   "Matched UDP dst port is not registered as a VXLAN port");

mlx5_vxlan_lookup_port() returns false when mlx5_vxlan_allowed() is
false. mlx5_vxlan_create() leaves VXLAN disallowed when
tunnel_stateless_vxlan is missing or the function is not a PF.

Here mlx5e_tc_tun_outer_lookup() picks vxlan_tunnel from an exact
dst_port 4789 alone. After that, only ft_field_support.outer_vxlan_vni is
checked.

Suppose firmware can advertise that capability while the parser does not
handle UDP 4789. Could a skip_sw rule then be installed with a VNI match
that the parser never fills? The rule would match nothing or, if the
masked key includes zero, all UDP/4789 traffic.

I couldn't confirm whether firmware can report outer_vxlan_vni in that
state. mlx5_vxlan_create() notes that the hardware adds 4789 by default,
so this may not happen in practice.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 2326fb21da66b..d2b961d473b89 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -2786,6 +2786,10 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
>  		err = mlx5e_tc_verify_tunnel_ecn(priv, f, &match_inner_ecn);
>  		if (err)
>  			return err;
> +	} else if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
> +		err = mlx5e_tc_tun_parse_outer_key(priv, spec, f, fs_type);
> +		if (err)
> +			return err;
>  	}

[Severity: High]
Can a rule with other enc_* keys but no enc_key_id still be offloaded
without those keys being matched?

The refusal of the other tunnel keys only exists inside
mlx5e_tc_tun_parse_outer_key():

	/* Without a tunnel device the other tunnel keys go unmatched */
	if (rule->match.dissector->used_keys &
	    (BIT_ULL(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) |
	     ...

That function is only called when FLOW_DISSECTOR_KEY_ENC_KEYID is
present.

The used_keys allow-list at the top of __parse_cls_flower() accepts every
ENC_* key for any filter_dev. Nothing else on the non-tunnel path reads
these keys. mlx5e_get_flow_tunnel_id() and mlx5e_tc_verify_tunnel_ecn()
are only reached through the mlx5e_get_tc_tun(filter_dev) branch.

Take a rule like this:

  tc filter add dev <uplink|VF rep|NIC netdev> ingress flower skip_sw \
      ip_proto udp enc_dst_port 4789 \
      action mirred egress redirect dev <vf_rep>

The same goes for a rule with enc_dst_ip X action drop. Wouldn't such a
rule skip both branches, reach hardware with the enc_* key dropped, and
catch all traffic that matches its other keys?

The over-match itself predates this patch. However, the commit message
says "Nothing matches the other tunnel keys on this path. Refuse them in
such a rule.", and the new code comment states the same rule for any
rule without a tunnel device.

Should this check cover every rule where mlx5e_get_tc_tun(filter_dev)
returns NULL, and not only rules that carry enc_key_id?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261117092915.255194-1-acassen%40corp.free.fr
