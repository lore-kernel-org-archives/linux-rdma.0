Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795295862;
	b=XBg+Ydq9ULMHasVwRG4QksrCdvp0gIKX9KgCNcJp8gOLGcqcHXeZvqjSkGHsiYdoh702
	 eWVDtEBC3gVC3OiAjsMQK5cawbwr5B28neKChmBKjxAn/ytcndNyizWZWrkFkvaoSQkxs
	 VQo20Zmz7Q3AA+2m+qPEn74CRu7Afpe3nRTV5E8JQ9aCkqcON8RWbLd2OTthzecgd7DXo
	 f2T8/3HjUU55pqQbzhlSJdhGADzXEWtMRnLORqP1eM+pQnIl2GsU4iz2WHvunQ7zn85cZ
	 hg7GuVwvOluTlOoSFZNmsaTvFPsLejQpryt6ghw3mY1dZQX5TLANsNvprzuHi6fVaXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795295862;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=3CgYEOCuySKfkNOqIxxRN+n3wk7VUoG7yJZDvZ1nM8s=;
	b=ywStawXJHARgLP9byiCY1F27I/BvWUhdUTNRnjU5FKfa5Hg/+OIvT/rq6dWAwajtNnX1
	 mn7Mpo93+L6O+LQv1QbmZF2I9a7a8DYQ2hKm4KlK4h8XB6TbqNsFDER2nCoWOv+4XrdfB
	 jUbNhmhKlK/nspN2ltHGFxm1iy/C5YXEqvm3k6jAebpwTSjO1A34bc52W30IUTXZ1wK6p
	 dtWSOoldA/aIcQXSGMQX2uSKwvy3TFjbR2TSgwLG8jbihFduMDkTokoqSFkoQZ/VpNpmU
	 DrdseGj3IZVjO5JruzHA7BlNhya8Fxl/CtP/8i3qS0KqdZk+VYZzwAxn/td5dZr10/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tmop0Iwu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE8F606A330;
	Sat, 21 Nov 2026 21:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tmop0Iwu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1471F000D4;
	Sat, 21 Nov 2026 21:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795295862;
	bh=3CgYEOCuySKfkNOqIxxRN+n3wk7VUoG7yJZDvZ1nM8s=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Tmop0IwuxMegvTe6zdSoy6VYlMPeeNhp0bvnxZsam6EzXeFi/aQ0ILKwnxk5wXqe6
	 8DIGxDA+v2Rfw0BbkgpD8Y8XJTHaee18R+8MXO+nrDM/mPUHJDAzfP9T6hF0CfZZ1q
	 uj7cNUs0DnoiAChSGk8EXxK3y47jVK47vzN5RMSFTFKeVulSz+u4ThFNbyvcVxx1jP
	 y0tDUWNHtqUeJ+5EX5tvaOSrTmW02JIBvyV43fRLM7zaCwj9mB8ouxG5cAIoZk3lmG
	 UvgY6EOyJRdymWTvkuzjLIPz3OzsNHpOmQJ9rj1z3mz/a9Kixwda9uTwLSulqNWt46
	 d3YkcrPRZuWKg==
Subject: Re: [PATCH net v6 4/8] ipv4: icmp: don't quote decrypted payload in
 icmp errors
From: netdev-bot+sashiko@kernel.org
To: toddfreed@meta.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
 bjorn@kernel.org, borisp@nvidia.com, cratiu@nvidia.com,
 daniel.zahka@gmail.com, dsahern@kernel.org, dtatulea@nvidia.com,
 edumazet@kernel.org, idosch@nvidia.com, kuba@kernel.org,
 john.fastabend@gmail.com, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, pabeni@redhat.com, raeds@nvidia.com,
 rrameshbabu@nvidia.com, sd@queasysnail.net, saeedm@nvidia.com,
 shuah@kernel.org, horms@kernel.org, tariqt@nvidia.com, weiwan@google.com,
 willemdebruijn.kernel@gmail.com, stable@vger.kernel.org
Date: Sat, 21 Nov 2026 21:17:40 +0000
Message-ID: <179529586053.3135.7106623626318776669@kernel.org>
In-Reply-To: <20261117203137.804424-5-toddfreed@meta.com>
References: <20261117203137.804424-5-toddfreed@meta.com>
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

- [Medium] The patch blocks decrypted-payload quoting only in
  __icmp_send() (net/ipv4/icmp.c).

--

ipv4: icmp: don't quote decrypted payload in icmp errors

This patch makes __icmp_send() skip the error when the invoking skb was
decrypted by the device. Locally originated skbs are the exception: if the
error is routed to a local address, it is still sent. The netdev and bridge
nft reject paths are left to a separate nf-next patch.

Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261023234640.1459291-1-toddfreed%40meta.com

> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 90c0e22c29bea..e11008aa4cecd 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -979,6 +979,18 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
>  	if (rt->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
>  		goto ende;
>
> +	/* Don't send parts of a decrypted skb onto the network. A received skb
> +	 * was decrypted by the device, and the transport header may have been
> +	 * encrypted. The different offloads can't be distinguished in all cases
> +	 * so simply don't send the error.
> +	 *
> +	 * A locally originated skb to be encrypted may be quoted if its source
> +	 * address (target of the error) is local.
> +	 */
> +	if (unlikely(skb_is_decrypted(skb_in)) &&
> +	    (skb_in->skb_iif || !(rt->rt_flags & RTCF_LOCAL)))
> +		goto ende;

[Severity: Medium]
This check only covers ICMP errors sent through icmp_send(). Can a
decrypted payload still be quoted in cleartext by the other IPv4
unreachable builder?

nf_reject_skb_v4_unreach() in net/ipv4/netfilter/nf_reject_ipv4.c is
unchanged by this series and has no skb_is_decrypted() check:

net/ipv4/netfilter/nf_reject_ipv4.c:nf_reject_skb_v4_unreach() {
    ...
	len = min_t(unsigned int, 536, oldskb->len);
    ...
	nskb = alloc_skb(sizeof(struct iphdr) + sizeof(struct icmphdr) +
			 LL_MAX_HEADER + len, GFP_ATOMIC);
    ...
	skb_put_data(nskb, skb_network_header(oldskb), len);
    ...
}

It is called from nft_reject_netdev_send_v4_unreach() and
nft_reject_br_send_v4_unreach(). The nskb comes from a fresh alloc_skb(),
so its decrypted bit is 0, and it goes out through dev_queue_xmit() or
br_forward().

With a netdev or bridge family reject rule matching device-decrypted
traffic, this would still send up to about 508 bytes of kTLS payload, or
the PSP-covered TCP header and payload, unencrypted.

nf_reject_skb_v6_unreach() in net/ipv6/netfilter/nf_reject_ipv6.c has the
same gap, with a quote of up to 1220 bytes. The icmp6_send() side is
handled by the later "ipv6: icmpv6: don't quote decrypted payload in
icmpv6 errors" patch in this series.

The commit message says:

    nft reject in the netdev and bridge families builds its own
    error (nf_reject_skb_v4_unreach()); a separate nf-next patch applies the
    same rule there.

This patch carries Fixes: 784abe24c903 and Cc: stable. A stable backport
would then make an inet family reject of a decrypted packet send nothing.
A netdev or bridge family reject of the same packet would still send
plaintext.

Should the netfilter builders be fixed in this same series, or through
nf/net with the same Fixes: and Cc: stable tags, rather than nf-next?

> +
>  	/* peer icmp_ratelimit */
>  	if (!icmpv4_xrlim_allow(net, rt, &fl4, type, code, apply_ratelimit))
>  		goto ende;

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261117203137.804424-1-toddfreed%40meta.com
