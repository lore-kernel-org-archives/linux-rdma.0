Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794424328;
	b=HK8+ELGYaisDcM/fLSkBvFtFgJzNa3xzLQ37b0VlLFyfxgL/bYMGmj/LH2ey9My30Nl0
	 IwAlUB4v6ZCXt8NaLq2y3t6ojulTFpcqMBCEwyjkdpa5JEl+bgGvTtKNgL/SHDiqyfWAu
	 //P1hEKWAJrwpgZlaHofv3AfNyZ8BeYffMBfRuoaQeerVIZbH4OngKQNEb9A+yf9twdba
	 mhRHTBAR9Ryafp9hFqVT26CAwORKs91yGy5/Pf4wsOcWAWOLczFjot+BgD6hS/Zaeb8Wl
	 WPKZM07ZrFvR/vaeCnM32EKiYJ9rcJgWTYC8xe+XdO2NFhAR/JxV4OCrT3ZVqTcuRsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794424328;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=jGvOIlTOeKyRBFS8dOTR3QjQ1zJt+mIHpbYnrWv4/V8=;
	b=u2S/+lHOmF3sLTeG3IVSeTE/E6i+oUm7SE4VtWvCuya6uTd0aUN8N98ok0JxX1ZVgaxc
	 ZqShyn59n6ZahjwCH8ubOl+SPdu2IaOPmipkE61ogTsCflvvjTKoYlEVpvsbsfsbmPuVL
	 fj2MoCIMpbf/N5kAnEvEcScCPVfXpWr/Sh2wOg3MYrcnfVEoChqGWcLvuYQkQRhWhMHYm
	 5dXpSm1XE8ewZrfiWLdM82BqzIw0CU2dqBcJ9xYxxojDstjn/s4kTOX/e1qDVAd4DLA1i
	 fn1Ok2z5FBd0ua/SqWii/YtHiwicfs8p7Uj4g13md7mCNuzXeIfGBF49wganXyLVjpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XIxDLlGo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D4D606A881;
	Wed, 11 Nov 2026 19:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XIxDLlGo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4701F00A0E;
	Wed, 11 Nov 2026 19:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794424327;
	bh=jGvOIlTOeKyRBFS8dOTR3QjQ1zJt+mIHpbYnrWv4/V8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=XIxDLlGoZXvoaeaKnQLZPVrifVFUBVUpV8UOL5M9dXcSN+liqxWys2ABdrGynNn9T
	 xy5tfQSuYB8yhdYLTU5FoKz+lWjMpyEJXPgeigzm9kBSCtUQeiU9bBJiGvBKnCmUr6
	 4w5+qLImGf44G7yJdEp0tJLZC996AgSakxR8bz9DTe1Hws/Xk0O4fRmcYGzsqCGUy9
	 bV6lRA/26X256WF7SiMh+p1hOJ+iJb6InwBYwnaPu6s3lKkdnn47Rz2nEA8XC+dQhO
	 tCtOUYtXln/3Z62GgV0v3hQRn0SvRWVket4WUodAY9zlgPDPSDKznAfzSD0oBByxid
	 g8gFAJDgU+/cA==
Subject: Re: [PATCH net-next 05/10] net/mlx5e: TC, reject a partial tunnel key
 with tunnel mapping
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
Date: Wed, 11 Nov 2026 19:12:05 +0000
Message-ID: <179442432587.2199510.12038956805266142950@kernel.org>
In-Reply-To: <20261109131039.959438-6-acassen@corp.free.fr>
References: <20261109131039.959438-6-acassen@corp.free.fr>
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

- [Low] The new check in mlx5e_get_flow_tunnel_id()
  (drivers/net/ethernet/mellanox/mlx5/core/en_tc.c) rejects any…

--

net/mlx5e: TC, reject a partial tunnel key with tunnel mapping

This commit adds a check to mlx5e_get_flow_tunnel_id() that rejects an
enc_key_id mask other than all-ones when tunnel mapping is used. The
mapping is used to restore tunnel metadata for packets that miss in
hardware after a goto chain or a sample. This is preparation for flower
accepting partial enc_key_id masks.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 708b7987ea4cd..28f09d234835d 100644
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
Should the full-mask width here depend on the tunnel type?

On VXLAN and GENEVE the tunnel key is a 24-bit VNI. The parsers in the
same driver already refuse wider keys and program the 24-bit match
fields:

drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c:mlx5e_tc_tun_parse_vxlan() {
    ...
	if (be32_to_cpu(enc_keyid.key->keyid) >= MLX5E_TC_TUN_N_VNI) {
    ...
	MLX5_SET(fte_match_set_misc, misc_c, vxlan_vni,
		 be32_to_cpu(enc_keyid.mask->keyid));
    ...
}

mlx5e_tc_tun_parse_geneve_vni() does the same with geneve_vni.

That means a mask of 0x00ffffff programs the same hardware criteria as
0xffffffff. The masked key stored in the tunnel mapping is also equal to
the full VNI, so mlx5e_tc_restore_tunnel() would restore the correct
tunnel id.

Once the later series commit "net/sched: cls_flower: add enc_key_id mask"
lets userspace send a mask, a rule like enc_key_id N/0xffffff on a VXLAN
or GENEVE device would be refused with -EOPNOTSUPP here. This happens in
any chain > 0, and in chain 0 with goto or sample. Is that intended?

The extack text "Partial match of tunnel key in chains isn't supported"
also seems misleading for that case, because the mask covers the whole
VNI.

The earlier series commit "net/mlx5e: TC, refuse a tunnel key wider than
the VNI" treats 24 bits as the full key for VXLAN and GENEVE, but this
check uses 32 bits. Only GRE, with its 32-bit gre_key, seems to need a
full 32-bit mask. This check is still the same at the end of the series.

> +
>  	esw = priv->mdev->priv.eswitch;
>  	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
>  	uplink_priv = &uplink_rpriv->uplink_priv;

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261109131039.959438-1-acassen%40corp.free.fr
