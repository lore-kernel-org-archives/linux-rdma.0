Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794234434;
	b=ykGEO21SRseyZwDCXqRBLn53XPqA5+vbVigEiXYJjfH+OIax8K3bk7mU2fE1DAN+Mt9k
	 nbJDvfptgf/kqZ6pCtRvVY7rXd0I3WP7zbQmYj7nzypH2RklyLl6zRoMQ7mOUKNZdtEq9
	 /pgoxe4a0brvtw6G82dc2EUDmtQi0OU0iObs3noekYmkiznfzQmtoPTgzX7o/QsM7AUuX
	 VB75Wn6E/FNrMfX5oIVBKYjp3E8MmClwdHw/7Llxqoo5gEWugXnMGZaRC4qC0Fm+cnGav
	 Q9jFAOLbM43JgIcKCSdtlpg7D2VdDjtIbUsq2P34zIIl32nYEaitKdFCGtmJ6PGBcqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794234434;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Vj/eCCDh47tLbV7oo1+JXdX+YKca0k7uK0q4hdds8+A=;
	b=NMr84r8S2w04Kpor3NDZLlMKqbPtDadwinyJRryuEBb2dbQEc+OAPHLaUE4XPN4CwOGi
	 GR/jxj2GYLNBlEFops6SqiIsaD8QD3Fq3LWThceY4oMVJxm2b19Aaqx+om6f69t4UfklS
	 pH+8R2CQ/Wgc0BeTRGqLijTiA0IWkfOT5gKuK2Q9OJfUyI6WyvE4oRFdrzQcWMZcHnPw1
	 FWetaK0LQM0FovGS9DfmfMns8ypNQxE3hTtCZz17Ww91dGp/eXB4nr76aUBDJIUT9WDfb
	 yVDVKaoW0GhPkGYz6/CRH399kFSU+Y2ixyerrpTY8Wjq5voT6cbqjlLBSlq0xwXK7PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jO1PqWMv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD107606A321
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 14:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jO1PqWMv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751951F008A2;
	Mon,  9 Nov 2026 14:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794234433;
	bh=Vj/eCCDh47tLbV7oo1+JXdX+YKca0k7uK0q4hdds8+A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jO1PqWMvkW9UbQLrb0AGvZqbCtM2XI7DzesxM+AREzs8Ys5MSK/+oVaZIiNf48ebS
	 ipD9STRpQJQ56OUlbZpVb/PzWik3w0N+CZ6gUUF14B3dzmmHJCITFRSPieDRFH2So5
	 q1GeinBAMcU6/Mx4FQLawPl51RSVXWzjq/O29PFM+x27ZFaUVBzpDV876kkMXsWQg4
	 KoB5hPUkNkr8amCI8t1rHZLyvXV9PKadtL2K9N0xMkq/5frqm6SrSvlq/TrB1UDc/1
	 1LIV+ELlRo9Nq2zRpZPuMji3nuKPkwY/JsATpb7o2FdtoueKcftqEY0GUh3L5d6XPQ
	 PbdN1GCK4S6KQ==
Message-ID: <sashiko-outbox-205099@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH ipsec v2 6/7] xfrm: segment untrusted GSO packets before
 sequence allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261108142652.1330952-7-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20261108142652.1330952-1-Jeremy.Jean@oss.cyber.gouv.fr>
 <20261108142652.1330952-7-Jeremy.Jean@oss.cyber.gouv.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 14:27:13 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] xfrm: skb->encapsulation set in xfrm_output_one() before
  inner headers
- [Medium] xfrm: early IPv6 UFO segmentation corrupts xo->proto in
  esp6_gso_encap()
--

commit 0279671c95c12bb5bd51f663fc7acf801cb6d765
Author: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>

xfrm: segment untrusted GSO packets before sequence allocation

This commit segments SKB_GSO_DODGY packets in xfrm_output() before
allocating sequence numbers and moves setting skb->encapsulation into
xfrm_output_one().

> diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
> index 99d1b33db52a6..a1fb60971c6bc 100644
> --- a/net/xfrm/xfrm_output.c
> +++ b/net/xfrm/xfrm_output.c
> @@ -505,6 +505,9 @@ static int xfrm_output_one(struct sk_buff *skb, int e=
rr)
>  	if (err <=3D 0 || x->xso.type =3D=3D XFRM_DEV_OFFLOAD_PACKET)
>  		goto resume;
> =20
> +	if (xfrm_offload(skb))
> +		skb->encapsulation =3D 1;
> +
>  	do {
>  		err =3D xfrm_skb_check_space(skb);
>  		if (err) {

[Severity: Medium]
Does setting skb->encapsulation =3D 1 before xfrm_outer_mode_output() cause
xfrm4_tunnel_check_size() and xfrm6_tunnel_check_size() to read inner
headers before skb->inner_network_header and skb->inner_transport_header
are initialized?

In tunnel and BEET modes, xfrm_outer_mode_output() runs
xfrm_inner_extract_output() before xfrm4_tunnel_encap_add() or
xfrm6_tunnel_encap_add() sets the inner header offsets.  When
skb->encapsulation is already set on a packet whose inner header offsets
are still zero:

net/core/gso.c:skb_gso_transport_seglen() {
	...
	if (skb->encapsulation) {
		thlen =3D skb_inner_transport_header(skb) -
			skb_transport_header(skb);

		if (likely(shinfo->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6)))
			thlen +=3D inner_tcp_hdrlen(skb);
	}
	...
}

For non-dodgy GSO packets with ESP offload enabled,
skb_gso_validate_network_len() reads inner_tcp_hdrlen(skb) from skb->head
and subtracts skb->transport_header, underflowing the unsigned segment
length when gso_size is small and dropping valid packets with -EMSGSIZE.
If the size check fails on a socket-owned packet, xfrm4_local_error() and
xfrm6_local_error() also take the skb->encapsulation branch and read
hdr->daddr from skb->head into the socket error queue.

Setting skb->encapsulation =3D 1 inside the if (xfrm_offload(skb)) branch
right before x->type_offload->encap(x, skb), matching where the else
branch clears it, avoids setting it before xfrm_outer_mode_output() has
initialized the inner headers.

> @@ -814,10 +817,10 @@ int xfrm_output(struct sock *sk, struct sk_buff *sk=
b)
>  		xfrm_state_hold(x);
> =20
>  		xfrm_get_inner_ipproto(skb, x);
> -		skb->encapsulation =3D 1;
> =20
>  		if (skb_is_gso(skb)) {
> -			if (skb->inner_protocol && x->props.mode =3D=3D XFRM_MODE_TUNNEL)
> +			if ((skb_shinfo(skb)->gso_type & SKB_GSO_DODGY) ||
> +			    (skb->inner_protocol && x->props.mode =3D=3D XFRM_MODE_TUNNEL))
>  				return xfrm_output_gso(net, sk, skb);
> =20
>  			skb_shinfo(skb)->gso_type |=3D SKB_GSO_ESP;

[Severity: Medium]
Can segmenting an IPv6 UFO packet (SKB_GSO_UDP | SKB_GSO_DODGY) here
after xfrm_dev_offload_ok() has already attached an offload sec_path
corrupt xo->proto in esp6_gso_encap()?

When xfrm_dev_offload_ok() runs on the unsegmented UFO packet,
ipv6_hdr(skb)->nexthdr is IPPROTO_UDP, so offload is enabled.
xfrm_output_gso() then calls udp6_ufo_fragment(), which inserts a
struct frag_hdr and sets ipv6_hdr(seg)->nexthdr =3D NEXTHDR_FRAGMENT on
each segment.  In transport mode, xfrm6_transport_output() stops at
NEXTHDR_FRAGMENT and moves only the 40-byte struct ipv6hdr backwards to
make room for the ESP header, leaving the old iph->daddr bytes in the
uninitialized ESP header slot at offset 40:

net/ipv6/esp6_offload.c:esp6_gso_encap() {
	...
	proto =3D iph->nexthdr;

	if (x->outer_mode.encap =3D=3D XFRM_MODE_TRANSPORT) {
		__be16 frag;

		ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &proto, &frag);
	}
	...
}

Because proto is NEXTHDR_FRAGMENT, ipv6_skip_exthdr() parses offset 40 as
a fragment header before the ESP header is written and overwrites
xo->proto with leftover destination address bytes whenever those bytes
have a zero fragment offset.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108142652.1330=
952-1-Jeremy.Jean@oss.cyber.gouv.fr?part=3D6
