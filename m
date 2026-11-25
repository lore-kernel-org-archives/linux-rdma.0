Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620473;
	b=W+Lx2MuN5uQHJLmvFRgVY9J6g0QjiIBoVAycQzemh0aZP6dvf1DHfOXRAAwz1m0LUupV
	 LenbzJk0FSNLBJ5CZtYgvXtE5XltEwMYXQeYdd/fC+9Tga1YNwDgM0hNM2rhQ8tcYN2yc
	 v67roxtm/Oxz16TPoVSRRFn1iauE3COrdI1knb5UCtYGvefFLajHub9GW3/o8MmbsNUgf
	 MKQJskXeQyWC8ZJdqHML+ixC5VOkF5pVSaktJnoS9R/r2kD7AIGDkfnow5VssjY/0WQoI
	 27WMkSG0Wu/gfZUP/Ld7/ifEjrt7ltpDgfxqSKaqbKZJpb5VAJl2Q3/TmqyZq1OjuRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620473;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=TQMJOKB5egHcGgynmGG4EwUuLrxBDUpZJMqON6XcyvA=;
	b=IJw3WNArco4bptSiq5jLsedLU/q6LH7m+Isi0o6csT+e7jwcxdReZY1DYHK9kaQjR5cD
	 S893zhRgEPJCsG8FTrwJ7AhjiMusS48Lve3Q+IQgdUZ/bZFGz4sgA2b+FQUfS3/sTuKes
	 zVf4pQMUWOQ7XqVnnremNKVpDCUGbibxwQLXiCQ9MhqwLmN/XVgwYjED8vREGXB7TVmDU
	 yXP3+FBLYvTgxHpYC/i/hcHjbWhczR4FOvm//Awo7SmGpTsgs3IA5TZN9s75y+Xg9663I
	 qULdHmjfDtjkofw+YxDkUJbmzhkbeIl0AByKQwEGboxl2fN5KLemF9EBmTDX7hbDj6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ijdrdMAR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82BD606A31E;
	Wed, 25 Nov 2026 15:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ijdrdMAR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291211F000C4;
	Wed, 25 Nov 2026 15:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795620473;
	bh=TQMJOKB5egHcGgynmGG4EwUuLrxBDUpZJMqON6XcyvA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ijdrdMARWt/P79rA/nv7dZGn4nIuZmRVHXrvsJd/KKUvyH/YKVN81Q21S58X0OyKn
	 +VtdgAu4eTUaN/mnx2oB5zfHvyOVBMQobpiDswecyA98lyaMR4NvwDQajZp4W69MHg
	 wJcqwbMRVkCQyyUaL89ECAwn0lPhtMpu/VIv5qpHvvzsU/JanDNGW6BHfG+zsXfge7
	 XHdQv5GB8N99m+2j6jWcE6tPZkhu46lBdN4FF9/Es1Cg66RdHuASowVOC6VOSyutRK
	 jao7Qf5J7ineiK1N5YgrKcfUD9rw2ki9B01JwgCJNFG1Gq3eS6wn74jHr66eCxsAxd
	 ZfutpYoiEGAkQ==
Subject: Re: [PATCH net v3 1/2] net: keep the TCP fixed-ID flags on the header
 they describe
From: netdev-bot+sashiko@kernel.org
To: julius@bairaktaris.de
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, willemb@google.com, horms@kernel.org,
 andrew+netdev@lunn.ch, dsahern@kernel.org, idosch@nvidia.com,
 ncardwell@google.com, kuniyu@google.com, steffen.klassert@secunet.com,
 herbert@gondor.apana.org.au, richardbgobert@gmail.com, ecree.xilinx@gmail.com,
 andy.moreton@amd.com, alex.austin@amd.com, linux-net-drivers@amd.com,
 saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 linux-rdma@vger.kernel.org, alexei.starovoitov@gmail.com, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com,
 martin.lau@linux.dev, song@kernel.org, yonghong.song@linux.dev,
 jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev,
 john.fastabend@gmail.com, sdf@fomichev.me, izaiahsun@gmail.com,
 corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org,
 shuah@kernel.org, bpf@vger.kernel.org, ipsec@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2026 15:27:50 +0000
Message-ID: <179562047069.3135.2008249679354171410@kernel.org>
In-Reply-To: <7c74b2076dc7dee1d481d39a135e0946d5e04145.1795284858.git.julius@bairaktaris.de>
References: <7c74b2076dc7dee1d481d39a135e0946d5e04145.1795284858.git.julius@bairaktaris.de>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 (1) · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In xfrm_output(), the new FIXEDID->OUTER copy only runs for
  TRANSPORT/BEET mode, but skb->encapsulation = 1 is set for every…

Pre-existing issues:
- [Medium] tcp6_gro_complete() (net/ipv6/tcpv6_offload.c:81-102) ignores
  NAPI_GRO_CB(skb)->ip_fixedid.

--

net: keep the TCP fixed-ID flags on the header they describe

This patch goes back to SKB_GSO_TCP_FIXEDID describing the innermost IPv4
header. It replaces SKB_GSO_TCP_FIXEDID_INNER with
SKB_GSO_TCP_FIXEDID_OUTER for the outermost header of an encapsulated
packet. The outer flag is cleared where tunnel and BPF paths add or remove
a header, xfrm_output() sets it for ESP transport and BEET offload, and the
mlx5 and sfc drivers are converted.

> diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
> index b84fcd07c7230..da0d8ba70c0cc 100644
> --- a/net/ipv4/tcp_offload.c
> +++ b/net/ipv4/tcp_offload.c

[ ... ]

> @@ -473,9 +475,10 @@ INDIRECT_CALLABLE_SCOPE int tcp4_gro_complete(struct sk_buff *skb, int thoff)
>  	th->check = ~tcp_v4_check(skb->len - thoff, iph->saddr,
>  				  iph->daddr, 0);
>  
> -	BUILD_BUG_ON(SKB_GSO_TCP_FIXEDID << 1 != SKB_GSO_TCP_FIXEDID_INNER);
> +	/* Bit 0 of ip_fixedid is the outermost header, bit 1 the inner one. */
>  	skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV4 |
> -			(NAPI_GRO_CB(skb)->ip_fixedid * SKB_GSO_TCP_FIXEDID);
> +		(((fixedid >> encap) & 1) * SKB_GSO_TCP_FIXEDID) |
> +		((fixedid & encap) * SKB_GSO_TCP_FIXEDID_OUTER);

[Severity: Medium]
This is a pre-existing issue and this patch did not introduce it. Does the
IPv6 counterpart need the same mapping?

Take an IPv4 outer header over an IPv6 inner TCP flow, such as 6in4/SIT or
VXLAN over IPv4 carrying IPv6. For the outer IPv4 header,
gro_receive_network_flush() calls inet_gro_flush() with inner=false, which
records:

include/net/gro.h:inet_gro_flush() {
    ...
		NAPI_GRO_CB(p)->ip_fixedid |= 1 << inner;
    ...
}

The flow is then merged as fixed-ID. tcp4_gro_complete() now maps that bit
to SKB_GSO_TCP_FIXEDID_OUTER, but tcp6_gro_complete() never looks at
ip_fixedid:

net/ipv6/tcpv6_offload.c:tcp6_gro_complete() {
    ...
	th->check = ~tcp_v6_check(skb->len - thoff, &iph->saddr,
				  &iph->daddr, 0);
	skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV6;
    ...
}

So the outermost IPv4 header of such a packet never gets
SKB_GSO_TCP_FIXEDID_OUTER. When the packet is forwarded and resegmented,
inet_gso_segment() rewrites the fixed outer IDs as incrementing ones.

Should tcp6_gro_complete() set SKB_GSO_TCP_FIXEDID_OUTER from bit 0 when
skb->encapsulation is set?

>  
>  	tcp_gro_complete(skb);
>  	return 0;
> diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
> index f1f612cd7b438..927e1535c47d7 100644
> --- a/net/xfrm/xfrm_output.c
> +++ b/net/xfrm/xfrm_output.c
> @@ -805,6 +805,16 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
>  		xfrm_state_hold(x);
>  
>  		xfrm_get_inner_ipproto(skb, x);
> +		/*
> +		 * Transport and BEET mode keep the IPv4 header and its ID, so
> +		 * the header that SKB_GSO_TCP_FIXEDID describes is the outer
> +		 * one as well.
> +		 */
> +		if (!skb->encapsulation &&
> +		    (x->props.mode == XFRM_MODE_TRANSPORT ||
> +		     x->props.mode == XFRM_MODE_BEET) &&
> +		    (skb_shinfo(skb)->gso_type & SKB_GSO_TCP_FIXEDID))
> +			skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_FIXEDID_OUTER;
>  		skb->encapsulation = 1;
>  
>  		if (skb_is_gso(skb)) {

[Severity: Medium]
Can a tunnel mode SA still lose the fixed IDs of the packet's only IPv4
header?

skb->encapsulation = 1 is set for every crypto offloaded SA, but the copy
to SKB_GSO_TCP_FIXEDID_OUTER is skipped for tunnel mode.

A GSO packet that was decapsulated earlier keeps a stale non-zero
skb->inner_protocol. inet_gro_complete() sets it for encapsulated GRO, and
neither iptunnel_pull_offloads() nor skb_scrub_packet() resets it. After
decap, such a packet has encapsulation=0 and SKB_GSO_TCP_FIXEDID set, and
SKB_GSO_TCP_FIXEDID_OUTER has been cleared.

If the packet is forwarded into a tunnel mode SA with offload, this check
just below fires:

			if (skb->inner_protocol && x->props.mode == XFRM_MODE_TUNNEL)
				return xfrm_output_gso(net, sk, skb);

Then xfrm_output_gso()->skb_gso_segment(skb, 0)->inet_gso_segment() runs at
encap_level 0, sees skb->encapsulation == 1, and takes the new else branch:

	} else {
		fixedid = !!(skb_shinfo(skb)->gso_type &
			     SKB_GSO_TCP_FIXEDID_OUTER);
	}

That reads 0 for the only IPv4 header, even though SKB_GSO_TCP_FIXEDID is
the flag that describes it. The segments get incrementing IDs although GRO
recorded fixed ones.

The baseline code was also wrong here, because it read the stale flag of
the removed header. Is this a remaining variant of the "forwarded into an
ESP tunnel mode SA with crypto offload" case that the commit message says
is fixed?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1795284858.git.julius%40bairaktaris.de
