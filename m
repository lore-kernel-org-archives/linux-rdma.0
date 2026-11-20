Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795145448;
	b=apxL6TIZHRE/kUgXI6xCYZDOzJM0YcDLiaY2hwd46XGfKG9SMCXULoDQOKBUWqXPBSI9
	 yPIfJ9bfQ3XlV6MwKhWZgXF4z9iJF+urPHVfysWYJ88bQivCAG0VjsYU6dvr4OPv6hh4W
	 NPr/ft/GitrUbA1TllSQYJ6YTeCGQ6XbfrdrfN5kGJx6xHpqaNOhV+qjxpUga2qFYNaNm
	 QGaPkhwgXPjJZ8COLFLHQZ5ThBhoV8XWWHYyMFL9O7hseKgrQGmV0flJoyWo7Y/ouI5D6
	 Z9WB8Vx0im5h1A8MIlik5e0eIVBA/dVuc+a6cudUfynJrFhpPJFmphmQoEyNMLQZS4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795145448;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=DzL+yn5jSD+uOgBTf8SzAp9nCi6wEKaq2tvvd5oCRh8=;
	b=H8Q1IS2UY7NW9qD2v7SZg2iXAfoRvQED2A17Nf9ci0fh76GmUM95o1Vde8/jC9p8M1E/
	 mB9TLo1EtAC3j1rlXv163cdQV94q3m9mafobslZMJ5T957qXcitdVX0oHzjA1BzjfnudN
	 yvC0yH6HCSEXmPfNlhsBQ2L0oTEkr1u4CKCn+AcME/r3ioJNop0z523hc83WqFazvvT8G
	 3K7/rBhOrOqZf4Abo3FmQCm58zRTjer9a5rLSQFQdxhXUdbMTjunLlKIzaazSPJVp7NEC
	 jCVHCjCMrdHo/A1YAdl5eMcfhuV8IhgsR6cEaCkS0LPnxv4nabEsNupZCEd+ooV4new==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RNyo1ZnL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518F460A2601;
	Fri, 20 Nov 2026 03:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RNyo1ZnL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AC91F000C4;
	Fri, 20 Nov 2026 03:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795145448;
	bh=DzL+yn5jSD+uOgBTf8SzAp9nCi6wEKaq2tvvd5oCRh8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=RNyo1ZnL/rnIJXIxucxYmZ6GQAjoBRYYaJjIa++LqRcMggy2wKubrbRW7jqV2jL8U
	 DOBoWVGP3IFAGErRyXwZoZNMD7fHOevtQAYp/Rf5akSvYXjHluHTFPwpNHEr61aZMv
	 E6ws5pH+0lhB7fEgQbP3k5R/Kl4+2rirlPL/Y6SJ1EUZy2dOH5CcHHY3uH50Prycqr
	 hi0i57IMMh4VDd9o9xuG0vRBxk9oNLDnRXioh0D/85Fyi8ujlTbGl818j/SVLns54h
	 jKPeNpW3uaq5/7YJpgd7Kacbr4qDffvUufywXXKE5W8PVM2hvSZ4wMnDXMyXEHpaiY
	 f+Fmpn0sbTSkA==
Subject: Re: [PATCH net-next v2 10/10] docs: networking: describe tunnel key
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
Date: Fri, 20 Nov 2026 03:30:46 +0000
Message-ID: <179514544619.3136.11935885435056519543@kernel.org>
In-Reply-To: <20261117092915.255194-11-acassen@corp.free.fr>
References: <20261117092915.255194-11-acassen@corp.free.fr>
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

- [Low] The new 'Tunnel key partitioning' text in
  Documentation/networking/tc-queue-filters.rst (lines 39-56) uses a…
- [Low] The mlx5 paragraph in Documentation/networking/tc-queue-
  filters.rst (lines 51-56) says a masked enc_key_id filter "runs on a…
- [Low] Documentation/networking/tc-queue-filters.rst (lines 39-47)
  describes splitting "the key space of a tunnel" into blocks, and its…

--

docs: networking: describe tunnel key partitioning in TC queue filtering

This commit documents tunnel key partitioning, where a filter with a mask
on enc_key_id steers a block of tunnel flows to an RX queue. It gives a
GTP-U example, describes what enc_key_id means on an mlx5 physical port,
and explains what happens to the filter's traffic when its channel goes
away.

> diff --git a/Documentation/networking/tc-queue-filters.rst b/Documentation/networking/tc-queue-filters.rst
> index 6b417092276f6..14032375d6308 100644
> --- a/Documentation/networking/tc-queue-filters.rst
> +++ b/Documentation/networking/tc-queue-filters.rst
> @@ -35,3 +35,25 @@ queues and/or a single queue are supported as below:
>     devices, TC filter directing traffic to a queue have higher
>     priority over flow director filter assigning a queue. The hash
>     filter has lowest priority.
> +
> +Tunnel key partitioning splits the key space of a tunnel into blocks. One
> +filter with a mask on enc_key_id steers a block to its own queue. This
> +helps with traffic that RSS cannot spread because its hashed fields barely
> +vary, such as GTP-U tunnels between a few endpoints::
> +
> +  # GTP-U TEIDs whose two top bits are 01 go to queue 1
> +  tc filter add dev eth0 ingress protocol ip flower skip_sw \
> +      ip_proto udp dst_port 2152 enc_key_id 0x40000000/0xc0000000 \
> +      action skbedit queue_mapping 1 skip_sw

[Severity: Low]

Does this example work on mlx5 with the default firmware configuration?
mlx5e_tc_tun_parse_outer_key_gtp() refuses the filter unless the firmware
reports the GTP-U TEID flex parser:

drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gtp.c:mlx5e_tc_tun_parse_outer_key_gtp() {
    ...
	if (!(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) &
	      MLX5_FLEX_PARSER_GTPU_TEID_ENABLED)) {
		NL_SET_ERR_MSG_MOD(extack,
				   "Matching on GTP-U TEID is not supported");
		return -EOPNOTSUPP;
	}
    ...
}

The GENEVE selector also needs a flex parser bit (MLX5_FLEX_PROTO_GENEVE,
checked through mlx5e_tc_tun_can_offload_geneve()). The preceding commit
"net/mlx5e: TC, match the tunnel key without a tunnel device" says "GTP-U
needs flex parser profile 3 and GENEVE profile 0". That means the 2152 and
6081 selectors listed further down cannot both be available at once.

If the firmware default is profile 0, the firmware will refuse this
example, and the extack message does not mention the flex parser profile.
Could the text mention this firmware dependency?

Also, the example passes skip_sw on the filter, but the text only implies
that it is required ("Only the hardware can match the key").
mlx5e_tc_tun_parse_outer_key() refuses the offload without it:

	if (!f->common.skip_sw) {
		NL_SET_ERR_MSG_MOD(extack,
				   "enc_key_id without a tunnel device requires skip_sw");
		return -EOPNOTSUPP;
	}

Would it help to state that requirement explicitly?

> +
> +Not all drivers can program a partial mask.
> +
> +On mlx5 devices such a filter runs on a physical port where nothing
> +decapsulates the packet. All the keys describe the packet on the wire.

[Severity: Low]

Is "physical port" the full scope here? __parse_cls_flower() calls
mlx5e_tc_tun_parse_outer_key() for any filter_dev that is not a tunnel
device. That includes FDB flows on VF representors:

drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:mlx5e_tc_tun_parse_outer_key() {
    ...
	if (fs_type == FS_FT_FDB && !mlx5e_is_uplink_rep(priv) &&
	    esw->offloads.inline_mode != MLX5_INLINE_MODE_NONE) {
		NL_SET_ERR_MSG_MOD(extack,
				   "Flow is not offloaded due to min inline setting");
		return -EOPNOTSUPP;
	}
    ...
}

On a VF representor the keys describe what the VF sent, not the packet on
the physical wire. The text also does not mention the min inline
requirement.

Separately, the example's action is only registered for NIC flows:

drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c:tc_acts_nic[] {
    ...
	[FLOW_ACTION_RX_QUEUE_MAPPING] = &mlx5e_tc_act_rx_queue,
    ...
}

tc_acts_fdb[] has no such entry, and mlx5e_tc_act_get() uses tc_acts_fdb
for MLX5_FLOW_NAMESPACE_FDB. Wouldn't the documented command then be
refused on the uplink representor in switchdev mode, even though that is
the physical port?

Could the paragraph say that queue_mapping steering only applies to NIC
(legacy mode) flows?

> +enc_key_id is the only tunnel key such a filter matches.
> +ip_proto 0x2f, or udp with dst_port 2152, 4789 or 6081, tells the hardware
> +which tunnel header holds the key. The software datapath has no tunnel

[Severity: Low]

Should this mention that VXLAN (4789) and GENEVE (6081) carry a 24 bit
VNI? The example above partitions on the top two bits of a 32 bit key,
but both parsers refuse keys that do not fit in 24 bits:

drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c:mlx5e_tc_tun_parse_outer_key_vxlan() {
    ...
	if (key >= MLX5E_TC_TUN_N_VNI) {
		NL_SET_ERR_MSG_MOD(extack,
				   "Tunnel key does not fit the 24 bit VNI");
		return -EOPNOTSUPP;
	}
    ...
}

mlx5e_tc_tun_parse_outer_key_geneve() has the same check. So a filter that
copies the example with dst_port 4789 and enc_key_id
0x40000000/0xc0000000 would be refused. For those tunnels the top of the
key space is bits 23:22, not 31:30.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261117092915.255194-1-acassen%40corp.free.fr
