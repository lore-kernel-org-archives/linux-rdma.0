Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794727275;
	b=j7gfYEvi6pQU5tfEKy9i4Vvn4tF/jgfskqjFpeH2RkUB2Vh/UMTzMy8Flx++98gfDvjI
	 2qnw3ahbFCgm9j47YnPz0Cl+WW1N1fvcuWO4hY6Uv+0c7PgO9+b/PKAcNAPXacSq7XjnX
	 LdDag/7C6OdLiwE8QwxgTrGh7ESo/DG6oIzDswKTvJ9bfnhCyXSRkB4W+Rg/PP/z7L4EM
	 tiE0iV3tD0dA6cC0/yPNrn0tqGYTPbl6oXdpO7Eh0Tzet6+L0wR6cpfL61YCs7MFpTlae
	 buoApFU50s9xECM2VKfij7gXhnz3Vi76uV3IcvuC3e78P2I516DLmDCsONmIAiYgTtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794727275;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=ZJ5H09f1V3BExIVK4w7VVGGd4sSw52ixpbfEFBc1B10=;
	b=fn7hZmujGWLFTVhxDOip9i7XOVxb99uxn296kFLEwDqiiriMUCTcPSFXllxt6Y/d+AlU
	 uxkK4pSkQ0+TxeadLuqyxFTw+CO8gIXBgAnmXe505O4khpdfh9qSH9Tc5w6kfroXE9PD9
	 eS7zQ0iMOvghczMPvMKv4f1N0IADRRpqddvYgC1MkayOF6Ndrf5nus4NFhF0xDWy/R5y4
	 CDI12SURkipvzUq1wcn9yh3mAtwL4ucEJgrTR9Ee8NukThsZD3cjxOV+fvJxmDL3gzB2E
	 X2QfmSqrmX3mTdiq9aQ83LcCOp2UUyXgU1EpLLInUUoPUSy/4IAsWkMeCIkJt1JQjyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KtNAT+8R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E09606A323;
	Sun, 15 Nov 2026 07:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KtNAT+8R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B4B1F000C4;
	Sun, 15 Nov 2026 07:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794727275;
	bh=ZJ5H09f1V3BExIVK4w7VVGGd4sSw52ixpbfEFBc1B10=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=KtNAT+8RoyajsHoFAT0c6s6PxrLmj++nINrr2UP9W1XoqmlyKY/YnunvCf/nJLrAf
	 C4d55Xexbsyop5GdaFUk7oYwSXKOqvFYe0W28qVLkO/J+P+u1fQRNmW5i7VzZqcxWS
	 5RXmnKzJ0y8kD9LahsOIOTRSk71TCNu4pCZCXepJSHG0GmRIPPEG7QVZCY++mD/jHR
	 fMG0KxO7S5oJKBohHQNysSrL8gy0zK8h7Tz8wllMZAUSX760If5C5JGC05qECW+PVi
	 vxin+SrpOsVmamYRlM0TrhdE6UX9y0B7GNV/XFqtbIPBC5MUlCx+PhEPcHmwBw4ikJ
	 inZV4uQJPC7SQ==
Subject: Re: [PATCH net v5 5/8] ipv6: icmpv6: don't quote decrypted payload in
 icmpv6 errors
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
 willemdebruijn.kernel@gmail.com
Date: Sun, 15 Nov 2026 07:21:13 +0000
Message-ID: <179472727319.2199510.15887061947101112689@kernel.org>
In-Reply-To: <20261111001831.3710881-6-toddfreed@meta.com>
References: <20261111001831.3710881-6-toddfreed@meta.com>
X-sashiko-severity: High
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

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Incomplete fix: plaintext from device decryption can still be
  quoted in an ICMPv6 error.
- [Low] In icmp6_send(), the two decrypted-skb suppression checks are
  ordered differently against the rate limiter, which does not match the…

--

ipv6: icmpv6: don't quote decrypted payload in icmpv6 errors

This commit stops icmp6_send() from quoting device-decrypted packets in
ICMPv6 errors. An error about a received decrypted skb is dropped before
the rate limit. An error about a locally originated decrypted skb is sent
only when its route is RTF_LOCAL.

> diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
> index d8203ebad8827..949025d83e155 100644
> --- a/net/ipv6/icmp.c
> +++ b/net/ipv6/icmp.c
> @@ -778,6 +778,13 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
>  
>  	np = inet6_sk(sk);
>  
> +	/* Don't send parts of a decrypted skb onto the network, see
> +	 * __icmp_send(): no error about a received skb. Before the rate
> +	 * limit, so that a suppressed error costs no credit.
> +	 */
> +	if (unlikely(skb_is_decrypted(skb) && skb->skb_iif))
> +		goto out_unlock;

[Severity: High]
Does this cover every ICMPv6 error builder that quotes the invoking packet?

nf_reject_skb_v6_unreach() in net/ipv6/netfilter/nf_reject_ipv6.c builds
its own Destination Unreachable and never goes through icmp6_send():

net/ipv6/netfilter/nf_reject_ipv6.c:nf_reject_skb_v6_unreach() {
    ...
	len = min_t(unsigned int, 1220, oldskb->len);
    ...
	skb_put_data(nskb, skb_network_header(oldskb), len);
    ...
}

It has no skb_is_decrypted() or skb_iif check. It can be reached from
netdev ingress chains and from bridge chains:

nft_reject_netdev_eval()
  nft_reject_netdev_send_v6_unreach()
    nf_reject_skb_v6_unreach()
    nft_reject_queue_xmit()
      dev_queue_xmit()

nft_reject_br_send_v6_unreach()
  nf_reject_skb_v6_unreach()
  br_forward()

mlx5 sets skb->decrypted in its RX path for kTLS and PSP, and this happens
before the ingress hook runs. A reject rule in a netdev ingress or bridge
chain that matches such traffic could then send up to 1220 bytes of the
decrypted L4 header and payload back out in cleartext.

The check in sk_validate_xmit_skb() doesn't catch this. nskb comes from
alloc_skb(), so it has decrypted == 0 and no socket.

The IPv4 helper nf_reject_skb_v4_unreach() seems to have the same gap. The
earlier "ipv4: icmp: don't quote decrypted payload in icmp errors" patch
also leaves it open.

Should these reject helpers get the same check?

>  	if (!icmpv6_xrlim_allow(sk, type, &fl6, apply_ratelimit))
>  		goto out_unlock;
>  

[ ... ]

> @@ -799,6 +806,15 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
>  	if (IS_ERR(dst))
>  		goto out_unlock;
>  
> +	/* An error about a locally originated decrypted skb is sent only if
> +	 * it is routed to a local address.
> +	 */
> +	if (unlikely(skb_is_decrypted(skb)) &&
> +	    !(dst_rt6_info(dst)->rt6i_flags & RTF_LOCAL)) {
> +		dst_release(dst);
> +		goto out_unlock;
> +	}

[Severity: Low]
Is it intended that this check runs after icmpv6_xrlim_allow()?

Suppose apply_ratelimit is true and the route device isn't loopback. By
this point icmpv6_xrlim_allow() has already used a peer token through
inet_peer_xrlim_allow() and has called icmp_global_consume(). The error is
then dropped here and nothing is sent.

The IPv4 version in __icmp_send() checks both conditions before the rate
limiter:

	if (unlikely(skb_is_decrypted(skb_in)) &&
	    (skb_in->skb_iif || !(rt->rt_flags & RTCF_LOCAL)))
		goto ende;

	/* peer icmp_ratelimit */
	if (!icmpv4_xrlim_allow(net, rt, &fl4, type, code, apply_ratelimit))

So the comment above the first check, "Before the rate limit, so that a
suppressed error costs no credit", holds for only one of the two
suppressions in this patch.

One way to hit this case is a locally originated decrypted skb from a
socket bound with IPV6_FREEBIND or IPV6_TRANSPARENT to an address that
isn't local.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261111001831.3710881-1-toddfreed%40meta.com
