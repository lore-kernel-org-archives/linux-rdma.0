Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794236907;
	b=H6Gui9ZnjjN7plU9ZtXA+shNMKqNOt2q838j4iXiliBjvk69Xm34NtLIWmiyhFFLoMOU
	 ZL1UHUkCVRaY9p5HmoNyN+bhgnZQRuBEDJdGzNz3Nra7TCzULLsljXA0elXr9EByShDVB
	 AnQCJxNq+7xQxDef+I6t7mFZIEFTQQSg7mKYoywD2aHGERDnuXj5oCZRZ62hIAZZwTXpG
	 BhVAWGtxoHrCTTqegwnxFCJJ3TZ0FmaiZDmIHEQ6q1HulENRq5WVMCIN6wdqF8J1sevwC
	 Vu2KeFeAiqbU32uGLi7xJvHofCUQLzmbAKSXZrqho2Yfl3RaeWTXoSFiSbqYtNSihIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794236907;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=q5lU3tLTaAO/4qWffqookdGD8sLU+fXZ2U9Hi2CgXeE=;
	b=yjWF+RsLempH0XsPaF53M8aCQgjFI25zjq4gg5b4J5cPBBRjxYBkW75qPQ68kGO4EKkg
	 kBM1Y6Cl9cwoYcZPM1Qly+yzmU72rspYrqpjspGHGTidqFKNrZydwRyzU3Q3hIouAxAu8
	 g15HzKR59cVCH/5WFfb0VE9Dp9Tzh/HjnhRbrn7MGaUgFfjc306xyiq78eJKVQi9bx90O
	 rz/tw9MHz5woce0JU4vQugQDPC+DU8fAMgQkeUgzNbvfie/2+4gmFDlL1hvu8wdUshoNh
	 U4Xxbr7mG0ynFxaNn0LYF6ODJFy6KczFPNxZAZ0Aa06QWdh+O6oxp1m1VeRxPIhs0BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h5n+AF0B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1D5606EE8D;
	Mon,  9 Nov 2026 15:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h5n+AF0B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D241F008A1;
	Mon,  9 Nov 2026 15:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794236906;
	bh=q5lU3tLTaAO/4qWffqookdGD8sLU+fXZ2U9Hi2CgXeE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=h5n+AF0BWq6i1QzZvBl77yoGmakE0pdyirHuBcPMBk5gPAL9CCPp+74p6kkwxF+f8
	 76JZroFMpvLDJOCq0Ud262QjUhxfKJzRgM+7xkv4wl6KLGWlb14ts/Yo2IqinS0VWB
	 gjqtD/rpCZoIPrJHn3AZbtcx/SeoHhythEXE2VXWMcSuROWkjPjoR5IfL5OGNSYClA
	 Jt1y3jcO88dRDKomHkNInQ7pN0RZB6oCTmo30SkRwgu2z2Rc1Tvd2ucLvz38Slg0wu
	 /SeU606SrdnlBsIRuFBpXP6Fw3nKieX1VGSI7wjSavQxZEViFJNDM5BcHw8aMfchpz
	 /1Oy604zrImYg==
Subject: Re: [PATCH ipsec v2 6/7] xfrm: segment untrusted GSO packets before
 sequence allocation
From: netdev-bot+sashiko@kernel.org
To: Jeremy.Jean@oss.cyber.gouv.fr
Cc: steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
 sd@queasysnail.net, davem@davemloft.net, borisp@nvidia.com, saeedm@nvidia.com,
 leonro@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, kuba@kernel.org
Date: Mon, 09 Nov 2026 15:08:25 +0000
Message-ID: <179423690512.994134.5259531255676223726@kernel.org>
In-Reply-To: <20261108142652.1330952-7-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20261108142652.1330952-7-Jeremy.Jean@oss.cyber.gouv.fr>
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 (1) · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In xfrm_output() (net/xfrm/xfrm_output.c:821-827), the new
  `skb_shinfo(skb)->gso_type & SKB_GSO_DODGY` check sends every DODGY…
- [Medium] xfrm: early IPv6 UFO segmentation corrupts xo->proto in
  esp6_gso_encap()

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the new gate
  only distrusts gso_segs when SKB_GSO_DODGY is set.

--

xfrm: segment untrusted GSO packets before sequence allocation

On ESP offload SAs, xfrm_output() now segments SKB_GSO_DODGY GSO packets
in software before any sequence numbers are allocated. gso_segs can be
zero for such packets, which leads to sequence number and AES-GCM nonce
reuse. Setting skb->encapsulation also moves into xfrm_output_one(), so
it happens after the early segmentation.

> diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
> index 99d1b33db52a6..a1fb60971c6bc 100644
> --- a/net/xfrm/xfrm_output.c
> +++ b/net/xfrm/xfrm_output.c

[ ... ]

> @@ -814,10 +817,10 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
>  		xfrm_state_hold(x);
>  
>  		xfrm_get_inner_ipproto(skb, x);
> -		skb->encapsulation = 1;
>  
>  		if (skb_is_gso(skb)) {
> -			if (skb->inner_protocol && x->props.mode == XFRM_MODE_TUNNEL)
> +			if ((skb_shinfo(skb)->gso_type & SKB_GSO_DODGY) ||
> +			    (skb->inner_protocol && x->props.mode == XFRM_MODE_TUNNEL))
>  				return xfrm_output_gso(net, sk, skb);

[Severity: Medium]
Does this early segmentation feed IPv6 segments into the ESP offload
encap path that it then misparses?

Take an IPv6 UFO skb with SKB_GSO_UDP | SKB_GSO_DODGY, for example from
virtio_net_hdr_to_skb() with VIRTIO_NET_HDR_GSO_UDP, sent over an IPv6
transport mode SA with esp6_offload loaded. xfrm_dev_offload_ok() has
already accepted the unfragmented skb, and secpath_set() has attached
an xfrm_offload entry.

Before this patch the skb took the SKB_GSO_ESP path. Now
xfrm_output_gso() calls skb_gso_segment(), and udp6_ufo_fragment()
inserts a struct frag_hdr after the IPv6 header. Every segment then
has ipv6_hdr(seg)->nexthdr == NEXTHDR_FRAGMENT, and xfrm_offload(seg)
is still set.

In xfrm_output_one(), xfrm6_transport_output() gets hdr_len == 40 from
xfrm6_hdr_offset()->ip6_find_1stfragopt(), which stops at the fragment
header. Only the struct ipv6hdr is moved down by x->props.header_len.
The ESP header gap at offset 40 still holds stale bytes from the end of
the old IPv6 header, and the fragment header now sits after the gap.
With an 8-byte IV, as with rfc4106(gcm(aes)), the gap starts with the
old daddr.

esp6_gso_encap() starts with proto = iph->nexthdr and, before writing
the ESP header, calls:

    ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &proto, &frag);

Since proto is NEXTHDR_FRAGMENT, ipv6_skip_exthdr() parses the
uninitialised ESP header slot as a fragment header. If the stale
frag_off looks like a first fragment, proto becomes the stale nexthdr
byte. With the layout above, that happens when the upper 13 bits of
daddr.s6_addr16[1] are zero, as for fe80::/64, ::1 and fd00::1. In that
case proto becomes daddr.s6_addr[0]. That value is stored in
xo->proto, and esp6_xmit() writes it into the ESP trailer next header
field.

Won't the peer then decrypt these segments and hand them to the wrong
protocol, or drop them, instead of reassembling the fragments?

What is the intended fix here? Should such segments lose their offload
state so they go through x->type->output(), or should esp6_gso_encap()
take the next header from *skb_mac_header(skb), the way esp6_output()
does?

[Severity: Medium]
Does this new check also send DODGY GSO traffic to software segmentation
when the SA is bound to a NIC with hardware ESP and ESP GSO?

xfrm_dev_offload_ok() is also true for SAs offloaded to devices such as
mlx5. That driver advertises ESP GSO in mlx5e_ipsec_build_netdev():

    netdev->features |= NETIF_F_GSO_ESP;

With this change, those packets go to xfrm_output_gso(), which does:

    segs = skb_gso_segment(skb, 0);

With no features passed, segmentation, linearisation and checksumming are
all done in software. Each segment then goes through xfrm_output_one() and
the hardware crypto path on its own.

Before this patch, these skbs got SKB_GSO_ESP and were sent whole. In
validate_xmit_skb()->esp4_gso_segment()/esp6_gso_segment()->tcp_gso_segment(),
gso_segs was recomputed under NETIF_F_GSO_ROBUST and NULL was returned, so
the NIC still did ESP TSO.

DODGY GSO skbs are the normal case for traffic forwarded from
tun/tap/vhost-net/macvtap, from AF_PACKET with vnet_hdr (through
virtio_net_hdr_to_skb()), from xen-netfront and from the BPF encap
helpers. Will VM and container bulk traffic on IPsec gateways with
hardware offload lose ESP TSO here?

The commit message says:

    This affects IPv4 and IPv6, with or without ESN, when the ESP offload
    type is registered. Hardware encryption is not required.

It doesn't mention this cost for hardware ESP setups. Since the patch is
tagged for stable, could the commit message describe the tradeoff?

>  
>  			skb_shinfo(skb)->gso_type |= SKB_GSO_ESP;

[Severity: High]
This isn't a bug introduced by this patch, but is the DODGY test enough
to close the nonce reuse described in the commit message?

Non-DODGY GSO skbs still reach this deferred path with whatever gso_segs
they carry. Some in-tree code grows a GSO skb without setting
SKB_GSO_DODGY or clearing gso_segs, which is the convention the BPF
helpers in net/core/filter.c follow.

One case is nfqnl_mangle() in net/netfilter/nfnetlink_queue.c. With
NFQA_CFG_F_GSO, GSO skbs are queued unsegmented, and a verdict can grow
the skb to as much as 0xFFFF bytes:

    skb_put(e->skb, diff);

nfqnl_validate_ip4()/nfqnl_validate_ip6() only check the IP length fields.
Neither gso_segs nor DODGY is updated.

Another case is the NAT helpers (FTP, SIP, IRC and others), through
__nf_nat_mangle_tcp_packet()->enlarge_skb()/mangle_contents() in
net/netfilter/nf_nat_helper.c:

    skb_put(skb, rep_len - match_len);

These helpers run in POSTROUTING, before
xfrm4_output()->__xfrm4_output()->xfrm_output(), and nothing recomputes
gso_segs.

xfrm_replay_overflow_offload(), like the _bmp and _esn variants, then
reserves only the stale count:

    oseq += skb_shinfo(skb)->gso_segs;

After segmentation, esp_xmit()/esp6_xmit() give each segment the next
number from xo->seq.low:

	if (xo->flags & XFRM_GSO_SEGMENT) {
		esph->seq_no = htonl(seq);

		if (!skb_is_gso(skb))
			xo->seq.low++;
		else
			xo->seq.low += skb_shinfo(skb)->gso_segs;
	}

If the grown payload is larger than gso_segs * gso_size, would the extra
segments use sequence numbers that the next packet on the SA also gets?
GCM and seqiv derive the IV from the sequence number, so that would be
the same nonce reuse.

Software-only ESP offload is affected as well, because
xfrm_dev_offload_ok() returns true when no offload device is bound.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261108142652.1330952-1-Jeremy.Jean%40oss.cyber.gouv.fr
