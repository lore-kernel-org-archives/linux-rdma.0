Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795469678;
	b=Af2krlC+rCz/+fvXaY0HKNmOa6bpYqJKMKDnim/aW4JeDPNudurN86CNEXs+kuYcTrsV
	 Xhy+/odNsIvxbUcBOAoxWDpznd0CaW9yWJydup5FWWmbsLfXSdmS35vHaOLyCS9iQwYjF
	 GIczhAhpg610dLr+tSY3pIzTXcQbpy/Cber1K0zHMElu12NG7MIkzU6DMrfTNN+r0EwxS
	 koa2Ea3AUGzLEz+rJcnQvvZ1t51kkAZnQHB6tHt3vvYwSAA8R1VLgy3RZPvrJmb8xna3u
	 d6cww/J53p7B5pdSFOHotPOUE6OUJxToiwiZXbRBAJC+j539EKClImjKQi43Mnpa93g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795469678;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=cF9MqqZvJpA3rAgWU3U2gamenfTkfRWF7VnItEtlw0w=;
	b=hdU57i83v2Tc1WGjQUyMyF1/byPVFPK+a5df38MGFkApEpbuZjwnxe1soJkjVKRJDjfB
	 e7aoKRECx41jQrFhiW9GU5n8nzjJo6K/SI8yqUu9laIljEJLpt9ZGT87nauXOUeDlgGdb
	 hvvq3STqU5aHHnDowtjXzZXjpA9gDURORG8PXvspK3nYeJKghGDv/Jq9fSdGchc1rYt5v
	 tY/C7o9dbEIREp8QfuXtImfCFZ9soe6s325vmm6BdM+rNUBalyIYbNlB/PoYe+4pUrCGK
	 nzTFMN03oY8aFpMk1qLjgkizjTQtQDYTy3pJAhEBs9b0RH7Q1UVs9P0ZUkZpd7ntcSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FEv6TbjR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809B7606A680;
	Mon, 23 Nov 2026 21:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FEv6TbjR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570FA1F000C0;
	Mon, 23 Nov 2026 21:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795469677;
	bh=cF9MqqZvJpA3rAgWU3U2gamenfTkfRWF7VnItEtlw0w=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=FEv6TbjRfw9/Js4uuOTiG5W2QhJt25p6GuAX+p9/00Yux6Xw+4WIB64FEKp3DRRLS
	 sRA7I337bCbifWehFB43oO3JoB0AgWg9X0ajVLdm/kOBt7YzS0KXpXfJo2hMED6wSA
	 fqaj6iU5SyUISmNN5QegrfMJJ7PZLLFtjCY+iIvdbKCj2/tFhADeWkz39zg4kDzioI
	 qKnizb4hRnD9MloKsIo2ZAkYguJpSjW+FRyjI/99CPH7nKcMADXCyE0z84znyJJsv3
	 GaHpNHCuS4krc+fVmEOvW5g0gEA+nQEMq7nvh+OYdzYF30M2qDV/ZhI5lNpbB/iA8U
	 BD6kKTRltbf3w==
Subject: Re: [PATCH net-next v3 11/11] docs: networking: describe tunnel key
 partitioning in TC queue filtering
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
Date: Mon, 23 Nov 2026 21:34:35 +0000
Message-ID: <179546967590.3135.7112800630047842498@kernel.org>
In-Reply-To: <20261122213200.3207385-12-acassen@corp.free.fr>
References: <20261122213200.3207385-12-acassen@corp.free.fr>
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

- [Low] The new mlx5 paragraph in Documentation/networking/tc-queue-
  filters.rst (lines 54-55) says 'ip_proto 0x2f, or udp with dst_port…
- [Low] The new mlx5 paragraph in Documentation/networking/tc-queue-
  filters.rst (lines 51-56) leaves out two conditions the driver…

--

docs: networking: describe tunnel key partitioning in TC queue filtering

This patch documents tunnel key partitioning in tc-queue-filters.rst,
where an enc_key_id mask steers blocks of tunnel flows to RX queues. It
gives a GTP-U example and describes how mlx5 matches enc_key_id on a
physical port. It also describes what happens to such a filter when its
channel is removed.

> diff --git a/Documentation/networking/tc-queue-filters.rst b/Documentation/networking/tc-queue-filters.rst
> index 6b417092276f6..14032375d6308 100644
> --- a/Documentation/networking/tc-queue-filters.rst
> +++ b/Documentation/networking/tc-queue-filters.rst

[ ... ]

> +  # GTP-U TEIDs whose two top bits are 01 go to queue 1
> +  tc filter add dev eth0 ingress protocol ip flower skip_sw \
> +      ip_proto udp dst_port 2152 enc_key_id 0x40000000/0xc0000000 \
> +      action skbedit queue_mapping 1 skip_sw
> +
> +Not all drivers can program a partial mask.
> +
> +On mlx5 devices such a filter runs on a physical port where nothing

[Severity: Low]
Should this paragraph list the conditions mlx5 checks before it will
offload the GTP-U example above?

First, the GTP-U TEID match depends on the firmware flex parser profile.
In mlx5e_tc_tun_parse_outer_key_gtp():

drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gtp.c:
	if (!(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) &
	      MLX5_FLEX_PARSER_GTPU_TEID_ENABLED)) {

If that capability is not set, the rule fails with -EOPNOTSUPP and
"Matching on GTP-U TEID is not supported".

The commit "net/mlx5e: TC, match the tunnel key without a tunnel device"
says GTP-U needs flex parser profile 3 and GENEVE needs profile 0. That
means 2152 and 6081 cannot both be used on one device. The text below
lists them without any condition.

Second, skbedit queue_mapping is only registered for NIC flows:

drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c:tc_acts_nic[]
	[FLOW_ACTION_RX_QUEUE_MAPPING] = &mlx5e_tc_act_rx_queue,

drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c:mlx5e_tc_act_get()
	tc_acts = ns_type == MLX5_FLOW_NAMESPACE_FDB ? tc_acts_fdb : tc_acts_nic;

tc_acts_fdb[] has no entry for it. In switchdev mode the physical port is
the uplink representor, and its ingress rules are FDB flows. Can the
example command be offloaded there at all?

Third, mlx5e_tc_tun_parse_outer_key() accepts the wire-header enc_key_id
match on FDB flows for VF representors when inline mode is none:

drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:mlx5e_tc_tun_parse_outer_key()
	if (fs_type == FS_FT_FDB && !mlx5e_is_uplink_rep(priv) &&
	    esw->offloads.inline_mode != MLX5_INLINE_MODE_NONE) {

That covers more than "a physical port". Would it help to say that the
example applies to NIC (legacy) mode with a flex parser profile that
supports GTP-U?

> +decapsulates the packet. All the keys describe the packet on the wire.
> +enc_key_id is the only tunnel key such a filter matches.
> +ip_proto 0x2f, or udp with dst_port 2152, 4789 or 6081, tells the hardware
> +which tunnel header holds the key. The software datapath has no tunnel

[Severity: Low]
This lists 4789 and 6081 next to 2152, but the 24-bit VNI limit for
VXLAN and GENEVE is not mentioned. Both
mlx5e_tc_tun_parse_outer_key_vxlan() and
mlx5e_tc_tun_parse_outer_key_geneve() have this check:

	if (key >= MLX5E_TC_TUN_N_VNI || !(mask & (MLX5E_TC_TUN_N_VNI - 1))) {

MLX5E_TC_TUN_N_VNI is BIT(24). The only example uses mask 0xc0000000,
which has no bits in the low 24 bits.

Suppose the example is copied and only dst_port is changed to 4789 or
6081. The rule is then always refused with -EOPNOTSUPP and "Tunnel key
does not fit the 24 bit VNI".

The commit message says the patch documents "what enc_key_id means on a
physical port of mlx5". Could the text state that for VXLAN and GENEVE,
the key and mask must fit in the 24-bit VNI?

> +metadata on such a port. Only the hardware can match the key.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261122213200.3207385-1-acassen%40corp.free.fr
