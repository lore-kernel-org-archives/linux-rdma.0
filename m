Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794424338;
	b=MFYcNT2Qb7LuodD7bONcCa2zKdftnikJAMjuMp6ijiIrQxoH4liihPnni2BqxklaQz+r
	 p9wNQdu7P+DEWFB3lK58KqOsEV8VsohK0xndTbgZ2bQPK2s4h9ABzZKwcajgSz/T/Pf0E
	 ZPkNtGmOGui+/tY1qhUBk1SbL/rSpkF2Cse70A3x3hkm0fApzZGvgY4OGOk9WcxvfEHuX
	 LdgobCVbstJcxJ8JP3Gdk2gZr6i2RyZyaizOV5tVKyvKq/9jCQuycEoTPgjDQTjBr7BOl
	 ImsAqGPyYXcLB8VerRxbc41t/kPKCdYjHLaVL/pgItvAnX1XwGhx4IIjXA90EeyXqyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794424338;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=TYBYTqmsCEkuPeF6UUVuvymRyySqseSuHMHuFSF29/s=;
	b=F79HWPG4grb0ujPWjBAIVwttDXsMBcJs0GaD6daYndQiCTWw1hUm0ngok7k2Ygngiszt
	 Hcyk+P5tYj63z6mqj9RR7hvFpH6sLpg8BgXC8/0L6tEVZ2vNPWG0cbfOsNeICM9sY6kWj
	 cPvXBZqQNaS1TNegDWSCBRXYIO4b1HgmIcTmVCAoS5qChrl3rRJHRsSJv8P7AOVnN8gQb
	 JmDmcz+2fA7SdyjfYZKtupXkcpKzHYZ2cezh2h/jO7sg6VM5rLrxhmvRAOli0mm7TpvKr
	 2NfUxYNANl9iF/R0q6VU69pzVbLyQjHqSjcfqYFsgdIHG7G7xsJXRYWd94DaSXlgjOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tb9sIjD5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5105A606A8A7;
	Wed, 11 Nov 2026 19:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tb9sIjD5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9751F00A06;
	Wed, 11 Nov 2026 19:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794424337;
	bh=TYBYTqmsCEkuPeF6UUVuvymRyySqseSuHMHuFSF29/s=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Tb9sIjD5MfxoIVlQ61rTb+WDUHdk4NZtEH6zlIzApmb331n5cMDbSLhoLzkrStAJI
	 gmOi2NHeC/1pCO/UNWcLECw4jj9XNxO0QVObKGYKS24JWiWDtvrxo2+MyOKVWI0EzE
	 Icn6rMoHDD5qJIeqcQ1yJsv6ZydJkY2DIKy8kMUz2KjWLxJB1+jw6B0v1qo3v11x33
	 QK9RgcoxvdACiNQfaAHriAZvaUX8Wu1z8Kl6V0aassKuEos/5GUpQU30YaYzGKaNHW
	 tpP205MwY/pH+K0UJEW8h+XeeYoOV1p54OscB4NI680JEkqn51Vklu/A4Wws586b6a
	 aguPrJ59Sq8SA==
Subject: Re: [PATCH net-next 10/10] docs: networking: describe tunnel key
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
Date: Wed, 11 Nov 2026 19:12:16 +0000
Message-ID: <179442433615.2199510.11200298531505956799@kernel.org>
In-Reply-To: <20261109131039.959438-11-acassen@corp.free.fr>
References: <20261109131039.959438-11-acassen@corp.free.fr>
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
  filters.rst (lines 54-56) says: "The filter therefore needs skip_sw.
- [Low] The commit message says the patch documents 'what enc_key_id
  means on a physical port of mlx5'.

--

docs: networking: describe tunnel key partitioning in TC queue filtering

This commit documents tunnel key partitioning in tc-queue-filters.rst, where
a mask on enc_key_id steers blocks of tunnel flows to RX queues. It adds a
GTP-U example and describes what enc_key_id means on an mlx5 physical port.
It also covers what happens to the filter when its target queue goes away.

> diff --git a/Documentation/networking/tc-queue-filters.rst b/Documentation/networking/tc-queue-filters.rst
> index 6b417092276f6..de54d43687c60 100644
> --- a/Documentation/networking/tc-queue-filters.rst
> +++ b/Documentation/networking/tc-queue-filters.rst
> @@ -35,3 +35,25 @@ queues and/or a single queue are supported as below:

[ ... ]

> +  # GTP-U TEIDs whose two top bits are 01 go to queue 1
> +  tc filter add dev eth0 ingress protocol ip flower skip_sw \
> +      ip_proto udp dst_port 2152 enc_key_id 0x40000000/0xc0000000 \
> +      action skbedit queue_mapping 1 skip_sw
> +
> +Not all drivers can program a partial mask.
> +
> +On mlx5 devices such a filter runs on a physical port where nothing
> +decapsulates the packet. All the keys describe the packet on the wire.
> +ip_proto and dst_port tell the hardware which tunnel header holds the key.

[Severity: Low]

The commit message says this documents "what enc_key_id means on a physical
port of mlx5". Should this paragraph also list the limits the driver
enforces? As written, the driver can refuse the GTP-U example above, and
small variations of it, for reasons the document does not mention.

First, the GTP-U example needs firmware flex parser support:

drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gtp.c:mlx5e_tc_tun_parse_outer_key_gtp() {
    ...
	if (!(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) &
	      MLX5_FLEX_PARSER_GTPU_TEID_ENABLED)) {
		NL_SET_ERR_MSG_MOD(extack,
				   "Matching on GTP-U TEID is not supported");
		return -EOPNOTSUPP;
    ...
}

The commit "net/mlx5e: TC, match the tunnel key without a tunnel device"
says GTP-U needs flex parser profile 3, while GENEVE needs profile 0. Since
skip_sw is mandatory there is no software fallback. The documented command
therefore fails on a device that runs another profile.

Second, queue mapping is only offloaded in NIC mode. In en/tc/act/act.c,
FLOW_ACTION_RX_QUEUE_MAPPING is registered only in tc_acts_nic, and
mlx5e_tc_act_get() uses tc_acts_fdb for FDB flows. The action is refused on
the uplink representor in switchdev mode, which is also a physical port.

Third, ip_proto and dst_port only select a match register.
mlx5e_tc_tun_outer_lookup() accepts only ip_proto GRE or an exact UDP
dst_port of 2152, 4789 or 6081:

drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:mlx5e_tc_tun_outer_lookup() {
    ...
	/* Only an exact port names a tunnel */
	if (ports.mask->dst != htons(U16_MAX))
		return NULL;

	switch (ntohs(ports.key->dst)) {
    ...
}

VXLAN on port 8472, or a masked port, is refused with "enc_key_id needs
ip_proto 0x2f or the exact dst_port of a supported tunnel".

Fourth, VXLAN and GENEVE keys are 24 bit VNIs.
mlx5e_tc_tun_parse_outer_key_vxlan() and
mlx5e_tc_tun_parse_outer_key_geneve() refuse a masked key that does not fit
in 24 bits ("Tunnel key does not fit the 24 bit VNI"). The top bits mask
from the example (0x40000000/0xc0000000) cannot be reused for those tunnels.

Fifth, mlx5e_tc_tun_parse_outer_key() also refuses decap actions.

The only caveat the document gives is "Not all drivers can program a
partial mask", which covers none of these limits.

> +The software datapath has no tunnel metadata on such a port. The filter
> +therefore needs skip_sw. Without it the filter stays in software, where
> +the port reads key zero.

[Severity: Low]

Is "Without it the filter stays in software" accurate for the queue_mapping
filters this document describes? Leaving out skip_sw does not seem to
install a software only filter.

If skip_sw is removed only from the filter, tcf_action_init() rejects the
skip_sw action:

net/sched/act_api.c:tcf_action_init() {
    ...
				if ((tc_act_skip_sw(act->tcfa_flags) && !skip_sw) ||
				    (tc_act_skip_hw(act->tcfa_flags) && !skip_hw)) {
					NL_SET_ERR_MSG(extack,
						       "Mismatch between action and filter offload flags");
					err = -EINVAL;
					goto err;
				}
    ...
}

If skip_sw is removed from the action, tcf_skbedit_init() refuses ingress
queue_mapping:

net/sched/act_skbedit.c:tcf_skbedit_init() {
    ...
		if (is_tcf_skbedit_ingress(act_flags) &&
		    !(act_flags & TCA_ACT_FLAGS_SKIP_SW)) {
			NL_SET_ERR_MSG_MOD(extack, "\"queue_mapping\" option on receive side is hardware only, use skip_sw");
			return -EOPNOTSUPP;
		}
    ...
}

The filter level skip_sw is not merged into the flags that the action init
sees, so this happens whatever the filter flags are. Both failures happen
before mlx5e_tc_tun_parse_outer_key() runs.

The "stays in software, reads key zero" behavior only seems to apply to
actions that can run in software, such as drop, mirred or mark. The text
looks like it was carried over from the commit message of "net/mlx5e: TC,
match the tunnel key without a tunnel device", which describes generic
actions.

Could this sentence say that the queue_mapping request is refused instead?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261109131039.959438-1-acassen%40corp.free.fr
