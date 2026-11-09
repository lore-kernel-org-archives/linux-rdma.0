Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794236905;
	b=RL5N8lOG2XP+dz5EsP3LMx1gasCAbLIg7nRmc8iVKXCUWact6MuzMGcggDBFJM7Io1VL
	 sl3NgAaulIkq7p9A5YvQVTjNe7hAYMQZmff4XvTHvZ3gQFIR/IoP9xqtCD967hXpLhWU4
	 kkvH3GbmaExFdv1Wo/ekAedIXYPbGSD6Dvkjb4eu20wqdKqphQd4dQVi1l5mrjTP4ue9b
	 0/CqukhHrpwa0di1w0kz5b4M2j6GnlyzScHaSFpuD8Ldt9g9o/eRewVhULoskKe3IWP5m
	 Q7uM/aKRIFMgfubBYyKTOGR2wX1RV1CyIaKvu8C/4vJVZIwGKMgc5ZboGQASjLj/0dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794236905;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=NcQSsbzqyco4Iw3u+HR1WbdmTXLgzsyGZKY4I0nDx4g=;
	b=z2G7WOK0OaZmrR6ZyoNKTLt9psOGGRWHPqLPPn0EzjpUHPrit7o2RRwZhpOvM5F/19AX
	 RsGMQBVgAOLyw3nUZBaf0+hvHUJcMCzBSA83aL/l1al4VLDmp4MzlWQJ+06t7Dx4dq/Bw
	 vQg5vWU/ipoJRx9DOr9z6xHd1P1xiXLCi5+phqBwFcscLZOeadNKbl2fmKUP0qb3PzpRt
	 Wcfm+6cWvC0HWpVU6QwDMXYqHmmq3siAO9kyZI+8xVKmO8DAszh/BZJfQ62RT5mWqx4JB
	 iDFzGf5SBiKmSRq9I3Z/rDEwIYn73Yr7sUyJZXtfKOubTbyTDnn0STSFihyyqOaX12w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hjE1vUbw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19808606A333;
	Mon,  9 Nov 2026 15:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hjE1vUbw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269DC1F008A1;
	Mon,  9 Nov 2026 15:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794236905;
	bh=NcQSsbzqyco4Iw3u+HR1WbdmTXLgzsyGZKY4I0nDx4g=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=hjE1vUbw/MMz5L3/c3e7VTt/XVkSOGHsTV3pWhlWM1HM5RWYYLmwYwfOCcIzbu3mp
	 UhO/J3C0hANhRN9HAY/oUSsuFqWA8Yd4qtX4XFftPVHk6Kx1R1JlvubmHfhg9grooV
	 tNx8QH6wA1auUk1qvoWjOtTLjscnhQSS1o5YUWE2BO/v+vMP53MB/uwo9SDheschzf
	 UpcV0NXyHznsKwhredcD2RPPg5JhZLh5rBxh8LvbeRET7a2XR9hILPVd2ecuMaoFEz
	 UhbZBo9z/KnEknIAztvDSDUN1p6sQ5zXvkGfX/XMMICJ17Pzx4acbvM7RrIuXmBP6i
	 ecvjMADGumsVQ==
Subject:
 Re: [PATCH ipsec v2 4/7] xfrm: prevent AES-GCM nonce reuse after early GSO
From: netdev-bot+sashiko@kernel.org
To: Jeremy.Jean@oss.cyber.gouv.fr
Cc: steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
 sd@queasysnail.net, davem@davemloft.net, borisp@nvidia.com, saeedm@nvidia.com,
 leonro@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, kuba@kernel.org
Date: Mon, 09 Nov 2026 15:08:23 +0000
Message-ID: <179423690370.994134.2277361511117933962@kernel.org>
In-Reply-To: <20261108142652.1330952-5-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20261108142652.1330952-5-Jeremy.Jean@oss.cyber.gouv.fr>
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

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The code change is correct, but the commit message for "xfrm:
  prevent AES-GCM nonce reuse after early GSO" describes a narrower…

--

xfrm: prevent AES-GCM nonce reuse after early GSO

This commit calls secpath_set() on each segment in xfrm_output_gso() when
xfrm_offload() is set. As a result, segments produced by skb_gso_segment()
no longer share a single xo->seq. Each segment's IV is then built from its
own sequence number.

> xfrm: prevent AES-GCM nonce reuse after early GSO
>
> With software ESP offload, xfrm_output() attaches a secpath before
> calling xfrm_output_gso() for an encapsulated GSO packet, but
> skb_gso_segment() leaves the splitted skbs sharing the same secpath,
> including xo->seq.

[ ... ]

> segments. When validate_xmit_xfrm() calls esp*_xmit() for each
> segment, the IV is constructed from the same value N+t-1, causing
> nonce reuse in AES-GCM. Yet, each ESP header correctly keeps using
> value N+i from its private XFRM_SKB_CB.

[Severity: Medium]
The code change looks correct. Is the commit message narrower than the bug
it fixes, though?

Is the problem limited to software ESP offload? In xfrm_output(), the early
GSO path runs for any state where xfrm_dev_offload_ok() is true. That
includes XFRM_DEV_OFFLOAD_CRYPTO states bound to a NIC:

net/xfrm/xfrm_output.c:xfrm_output() {
    ...
	if (xfrm_dev_offload_ok(skb, x)) {
		...
		if (skb_is_gso(skb)) {
			if (skb->inner_protocol && x->props.mode == XFRM_MODE_TUNNEL)
				return xfrm_output_gso(net, sk, skb);
    ...
}

In that case, xfrm_replay_overflow_offload() writes N+i into the shared xo
for each segment. If the segments are queued before validate_xmit_xfrm()
runs, esp_xmit() reads the shared value N+t-1. On the hw_offload branch it
then copies that value into the private xo:

net/ipv4/esp4_offload.c:esp_xmit() {
    ...
	seq = xo->seq.low;
    ...
	if (hw_offload && encap_type == UDP_ENCAP_ESPINUDP) {
		...
		esph->seq_no = htonl(seq);
	}
    ...
	if (hw_offload) {
		if (!skb_ext_add(skb, SKB_EXT_SEC_PATH))
			return -ENOMEM;
		...
		xo->seq.low = seq;
    ...
}

Drivers build the IV from this xo->seq. For example, mlx5e_ipsec_set_iv()
does:

	seqno = cpu_to_be64(xo->seq.low + ((u64)xo->seq.hi << 32));

and nfp copies xo->seq.low and xo->seq.hi into offload_info. Wouldn't
hardware crypto offload users hit the same nonce reuse?

Is the statement "each ESP header correctly keeps using value N+i"
accurate? For hardware offload with UDP_ENCAP_ESPINUDP, the
esph->seq_no = htonl(seq) assignment above overwrites the header with the
shared value. Every segment would then carry the same sequence number on
the wire, and the peer's anti-replay check would drop t-1 of the t
segments.

Is the problem specific to AES-GCM? In the software fallback, esp.seqno
feeds the seqiv-based IV for any counter-nonce AEAD the SA uses. That
includes rfc4106(gcm), rfc4309(ccm), rfc4543(gmac) and
rfc7539esp(chacha20,poly1305).

The new secpath_set() call in xfrm_output_gso() is guarded only by
xfrm_offload(segs), so the fix appears to cover all of these cases. Could
the subject and commit message be updated to mention hardware crypto
offload, the UDP encapsulation ESP header sequence number, and the non-GCM
AEAD modes?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261108142652.1330952-1-Jeremy.Jean%40oss.cyber.gouv.fr
