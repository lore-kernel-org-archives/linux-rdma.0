Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794424323;
	b=sEwgxYfx40cSpzqvjGXx8taPznrPAd9acisLqKuJh0wSPbxjOdgG4amRK29dGZqbXrzK
	 43sN/wSAaBZ8w+y1XwTTdfe7FEUhIlc7mMgIQI8FEuIsB3MPoypRZvkD8rra3MhXpgbrx
	 oXbNQJo2uWyc91h8MSZUkaWWtrmNc6V3spZ7tsdb4sD/285D5RuJDnr1tgQpeYBe7d90g
	 UKpf8/q3QhshLKL9mWpeK1csxMpr5pTekrLZDKmu9400MPiPTShNT+B7Z/ToF/c0Ue9uu
	 rogPurw1hwx2mjOn3Gd7I4FuQFCa5kHJ1x9iB4IKgHqztzTDtfML60weqStzahMbJwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794424323;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=NdkY7xp/B3wLXw3qOXSqhfDSdGzSUXTIrLEEowBCGRg=;
	b=cccO6AyJ1eN0+ZqjoeiW7hQjiRP5og87mtWtAia4jLgc66X1NYwV7T1xrd6+mZ/8ehLg
	 9754ykHzf3qWv+6MrSz/4rzcs3MlvgZKmAPdUv6euF3yGWMg85CAX3UXnAVc+wDClrDQu
	 9/IMBuVFk/m7/i24HgbjFwNXZMbh3N2ez8HvvT8osQ58Bx4TsY+b9pM++oaxC6xPY55h6
	 J4ilpiLbdUat7WY2hJmGYWgbJrRrsZk2+kreZVTusBvCsvDPDjVgLuCvwlS3XbhzbCDJM
	 6mkj609g4+u42D9u64rQHfi+dvYoIQha7Df+u+n4ucN25xnNn+9K64kwP4Wllc0Ht6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U5j+cBKs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0C560A2623;
	Wed, 11 Nov 2026 19:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U5j+cBKs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392AD1F00A0A;
	Wed, 11 Nov 2026 19:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794424323;
	bh=NdkY7xp/B3wLXw3qOXSqhfDSdGzSUXTIrLEEowBCGRg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=U5j+cBKsc9a+yOI/eNXb3MiV6eEzlMohwMgskjrcIC+ih7x1kepi0vN+TEoMw7dOY
	 0FSxCO87K0iZ2f9iUQIGWPPNp+RQ50211hsLgk7+h8bILxLAw1LgXO5O9/C47rzPQQ
	 L4orGYyYDz/NDqvYW3qv1pPplfev5UT2a3YmujDY9ciRiaoL8VDz4pJDcDEuoMZ22o
	 fn/J9bjAZ22AhP5NrwgKeuEkVUbttOntcm9W2BtpMeBOn2czZvB8jffSxJz1mqchs8
	 87HxPmdG1M85svOBi0M7Hnq6Fy2vn1kxMoOX0pQGbqNwjB8F+9yMZ5n95Ngf5qIbDO
	 PJXWzKJzJTX4g==
Subject: Re: [PATCH net-next 03/10] nfp: flower: refuse a tunnel key wider
 than the VNI
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
Date: Wed, 11 Nov 2026 19:12:01 +0000
Message-ID: <179442432180.2199510.17732935950535223359@kernel.org>
In-Reply-To: <20261109131039.959438-4-acassen@corp.free.fr>
References: <20261109131039.959438-4-acassen@corp.free.fr>
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

- [Low] In drivers/net/ethernet/netronome/nfp/flower/offload.c, the new
  nfp_flower_check_tun_vni() fixes a bug that already exists.

--

nfp: flower: refuse a tunnel key wider than the VNI

This patch adds nfp_flower_check_tun_vni() so that VXLAN and GENEVE flower
rules are refused when the enc_key_id key does not fit in the 24 bit VNI.
The check runs in nfp_flower_calculate_key_layers() after the UDP tunnel
type is known. GRE keeps its 32 bit key.

> diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
> index 161190200dbd0..e5f6f4f464ad6 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
> @@ -150,6 +150,23 @@ static bool nfp_flower_check_higher_than_l3(struct flow_rule *rule)
>  	       flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ICMP);
>  }
>
> +static int
> +nfp_flower_check_tun_vni(struct flow_rule *rule,
> +			 struct netlink_ext_ack *extack)
> +{
> +	struct flow_match_enc_keyid enc_keyid;
> +
> +	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID))
> +		return 0;
> +
> +	flow_rule_match_enc_keyid(rule, &enc_keyid);
> +	if (be32_to_cpu(enc_keyid.key->keyid) < VXLAN_N_VID)
> +		return 0;

[Severity: Low]
The commit message says "An exact key above bit 23 already selects the
wrong VNI", so this check also fixes a bug that exists today. Should the
patch carry a Fixes: tag and a stable Cc so that stable trees get it too?

Before cls_flower accepts an enc_key_id mask, fl_set_key() passes
TCA_FLOWER_UNSPEC as the mask attribute. That means any enc_key_id that is
present always gets an exact mask:

net/sched/cls_flower.c:fl_set_key() {
    ...
	fl_set_key_val(tb, &key->enc_key_id.keyid, TCA_FLOWER_KEY_ENC_KEY_ID,
		       &mask->enc_key_id.keyid, TCA_FLOWER_UNSPEC,
		       sizeof(key->enc_key_id.keyid));
    ...
}

nfp_flower_compile_tun_udp_key() then shifts the key and the mask left by
NFP_FL_TUN_VNI_OFFSET (8), which throws away bits 24-31:

drivers/net/ethernet/netronome/nfp/flower/match.c:nfp_flower_compile_tun_udp_key() {
    ...
		vni = be32_to_cpu((match.key->keyid & match.mask->keyid)) <<
		      NFP_FL_TUN_VNI_OFFSET;
		*key |= cpu_to_be32(vni);
		vni = be32_to_cpu(match.mask->keyid) << NFP_FL_TUN_VNI_OFFSET;
		*key_msk |= cpu_to_be32(vni);
    ...
}

So on current and stable kernels, a VXLAN or GENEVE rule with enc_key_id
0x01000005 gets programmed into the NIC as VNI 5 with mask 0xffffff00. The
hardware then matches VNI 5 traffic. In software the rule never matches,
because VXLAN and GENEVE tunnel ids are only 24 bits wide.

The Fixes: tag would need to point at the commit that first added
VXLAN/GENEVE VNI matching to nfp flower. Commit 77a5f73a8b33 ("nfp: flower:
move udp tunnel key match compilation to helper function") only moved this
code and says it makes no functional change, so the original commit is
older than that one.

> +
> +	NL_SET_ERR_MSG_MOD(extack, "unsupported offload: tunnel key does not fit the 24 bit VNI");
> +	return -EOPNOTSUPP;
> +}
> +

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261109131039.959438-1-acassen%40corp.free.fr
