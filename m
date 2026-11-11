Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794424336;
	b=DlMrKkyUR9Rs61Yb8k3XZQXPjcKTu8srIItIZE7xIwD+l3XbTM8SdUzkrWtDq30RyUwt
	 KX7b9PWB8kAe3J5uvaa1Ne75IiO6ZjIQDL5AQ4nU37JNPEf0Ro82TD8916zhz0F8I68Fo
	 HuHlrIaqfidqRn4mMQH4P+GqvLja53aKq7B/RGCltNHqb6cCQH0RrUryc2pG8RBEDqTU8
	 vgaw9NFxSVbmkcjCBBhdPogQZAZ4InKIHoRPGbFccf3WThTo//WL4obIxcRUCZ4Rj9Ycx
	 ftlCs8obAicEauTCAuy83QEwe8h6MIJx0R1Th2Z4BBtIYpmBNQ52bAM5LPwD9dI/KSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794424336;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=+vddkaLT6r9Qg+VZp9hd3qPKksz/5ONk6NPlMylLqlY=;
	b=rad9OXnEe0XEDrqN3k3UFy8kpSq07Bml0Der311vllV9QigL7Qv4LrMxMIslyysDizbf
	 nCYFjd1FzdSL6pR32VD6DqaHAXt8NhV8hRBakQYstYSxJ7Lh5wwTojCgvzJ8bsLNAWP6j
	 ytgknCkqxVNim8RgbvPPAAtX/3P4/rsnQ4gyoTy04e/T5KGEM7vHgadCYSxSNoF47lvWh
	 BkYul+lfyAvOp8iDE2UD2RJts9OjGSvIVYlYvjBdeZBPeESAYAVBEj8HfgbQvDk6sYem2
	 z2uFnYhod4ZYd5VDSFIKxkfu+cPxhW8Q6XwMEYS4DE8g1TQy/VDvUsCW4EGD25/6fig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RDDOvhOW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBBF60A380A;
	Wed, 11 Nov 2026 19:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RDDOvhOW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610A61F00A11;
	Wed, 11 Nov 2026 19:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794424336;
	bh=+vddkaLT6r9Qg+VZp9hd3qPKksz/5ONk6NPlMylLqlY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=RDDOvhOWStL5eTghhV+WNTTCfKRx6kWFREOg2W2H070X2Ard9W44EKqZR1Uwws/wX
	 XQGOGA2tjsvVok0sZD9zEcaeVlTJSphZdpXDr7OkUfIWeYc/8gfgC3LG+TzMhu/4xw
	 nNVXAOm4woXHENuHdhmJ9EAAn+V5ZuKG0VhQ0WVR0BlbHN7HEvAyDCsQ4sh3b+O1za
	 DN71KhGHHiwRT/qPDmTkzJMu9Nk2oDQqg7W/Bwgs56sXkzPDW7QL5OTTABjZw7HO5B
	 DMtNX9wK2iIyDfYhDf01oOJITRcAE2xKJogwk7KaVqis4b7lnuQ2xASOrRsOeTGbdq
	 7XvbnISPa8Z7Q==
Subject: Re: [PATCH net-next 09/10] net/mlx5e: TC, match the tunnel key
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
Date: Wed, 11 Nov 2026 19:12:13 +0000
Message-ID: <179442433391.2199510.196528697168850523@kernel.org>
In-Reply-To: <20261109131039.959438-10-acassen@corp.free.fr>
References: <20261109131039.959438-10-acassen@corp.free.fr>
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

Critical: 0 · High: 1 · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The new non-tunnel-device path in __parse_cls_flower()
  (en_tc.c:2789-2793) offloads any rule that carries ENC_KEYID.
- [Medium] The patch fixes a bug that users can already hit, but the fix
  ships inside a net-next feature patch with no Fixes: tag.
- [Medium] On VF representor (FDB) flows, the new path matches fields
  that sit past the header region the eswitch min-inline contract…

--

net/mlx5e: TC, match the tunnel key without a tunnel device

This adds a parse_outer_key tunnel op. With it, __parse_cls_flower() can
offload enc_key_id on filter devices that are not tunnel devices. The GRE
key, VXLAN VNI, GENEVE VNI or GTP-U TEID is matched on the wire, and the
tunnel is picked from ip_proto and an exact dst_port. These rules must be
skip_sw and cannot carry a decap action.

> This covers NIC and eswitch flows. A rule on the uplink representor used
> to accept enc_key_id without matching on it. It caught all the traffic of
> its other keys. It now matches the key or gets refused.

[Severity: Medium]
This describes a bug that predates this patch. Before this change,
__parse_cls_flower() whitelisted FLOW_DISSECTOR_KEY_ENC_KEYID but only read
it when mlx5e_get_tc_tun(filter_dev) was non-NULL. So a skip_sw rule with
enc_key_id on a non-tunnel device was offloaded without the key.

Could the fix go in its own patch with a Fixes: tag? As it stands, stable
trees can't take it without also taking the new outer key feature,
tc_tun_gtp.c and the parse_outer_key op.

Is the old bug really limited to the uplink representor?
parse_cls_flower() is shared by mlx5e_add_nic_flow() and
__mlx5e_add_fdb_flow(). That suggests the NIC netdev (FS_FT_NIC_RX) and VF
representors accepted enc_key_id the same way without matching it.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
> index de74dbfe7b20c..921af801d4d4e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c

[ ... ]

> @@ -996,3 +997,90 @@ int mlx5e_tc_tun_parse_udp_ports(struct mlx5e_priv *priv,

[ ... ]

> +/* Without a tunnel device only the hardware can read the tunnel key */
> +int
> +mlx5e_tc_tun_parse_outer_key(struct mlx5e_priv *priv,
> +			     struct mlx5_flow_spec *spec,
> +			     struct flow_cls_offload *f,
> +			     enum fs_flow_table_type fs_type)
> +{

[ ... ]

> +	tunnel = mlx5e_tc_tun_outer_lookup(rule);
> +	if (!tunnel) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "enc_key_id needs ip_proto 0x2f or the exact dst_port of a supported tunnel");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	flow_rule_match_enc_keyid(rule, &enc_keyid);
> +	return tunnel->parse_outer_key(priv, spec, extack,
> +				       be32_to_cpu(enc_keyid.key->keyid),
> +				       be32_to_cpu(enc_keyid.mask->keyid),
> +				       fs_type);
> +}

[Severity: High]
Are the other tunnel keys in the same rule silently dropped here?

The used_keys whitelist in __parse_cls_flower() still accepts
ENC_IPV4_ADDRS, ENC_IPV6_ADDRS, ENC_PORTS, ENC_IP, ENC_OPTS and ENC_CONTROL
on any filter device. Only two places turn these keys into hardware
matches:

  - mlx5e_get_flow_tunnel_id()
  - mlx5e_tc_tun_parse() and mlx5e_tc_verify_tunnel_ecn()

Both are reached only from the mlx5e_get_tc_tun(filter_dev) branch.

This path programs only the key register and then returns 0. Take this rule
on the uplink representor:

  tc filter add dev <uplink_rep> ingress protocol ip flower skip_sw \
      ip_proto 0x2f enc_key_id 100 enc_dst_ip 10.0.0.1 \
      action mirred egress redirect dev <vf_rep> skip_sw

It looks like the rule would be accepted. Hardware would then redirect
every GRE packet with key 100 to that VF, whatever its outer destination.
enc_opts, enc_dst_port and enc_tos would be ignored in the same way.

Because skip_sw is required, software never shows the wider match. A
documentation patch later in the series says "All the keys describe the
packet on the wire", which makes such rules more likely. That patch does
not change this code.

Should mlx5e_tc_tun_parse_outer_key() refuse rules that carry any other
ENC_* key?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 3823ccc60dd39..6780e54a0cb93 100644
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

[Severity: Medium]
Can this path be hit on VF representors whose eswitch min-inline mode does
not cover the tunnel header?

For non-uplink eswitch flows, parse_cls_flower() only checks the match
level:

	if (rep->vport != MLX5_VPORT_UPLINK &&
	    (esw->offloads.inline_mode != MLX5_INLINE_MODE_NONE &&
	    esw->offloads.inline_mode < non_tunnel_match_level)) {

mlx5e_tc_tun_parse_outer_key() writes misc.gre_key, vxlan_vni, geneve_vni
or misc3.gtpu_teid, but it never raises *outer_match_level. The level stays
at MLX5_MATCH_L3 (from ip_proto) or MLX5_MATCH_L4 (from dst_port).

On the VF TX side, mlx5e_calc_min_inline() does:

	case MLX5_INLINE_MODE_TCP_UDP:
		hlen = eth_get_headlen(skb->dev, skb->data, skb_headlen(skb));
	...
	case MLX5_INLINE_MODE_IP:
		hlen = mlx5e_skb_l3_header_offset(skb);

So inline_mode IP does not inline the GRE key. With inline_mode TCP_UDP,
the inlined bytes end after the UDP header, so the VXLAN, GENEVE or GTP-U
header is left out.

A GRE key rule therefore passes the check with inline_mode IP. A VXLAN,
GENEVE or GTP-U rule passes with inline_mode TCP_UDP.

On min-inline devices, such as ConnectX-4 Lx with vport context inline
mode, could the eswitch miss these bytes in VF-originated traffic? The
skip_sw rule would then never fire, or would match the wrong packets.

Before this patch, tunnel key matching never reached hardware on VF
representors. The VF representor testing in the commit message was on
ConnectX-7, where inline mode is NONE.

Should this path refuse the rule on non-uplink vports when
esw->offloads.inline_mode is not MLX5_INLINE_MODE_NONE?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261109131039.959438-1-acassen%40corp.free.fr
