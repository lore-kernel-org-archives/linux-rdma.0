Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792885703;
	b=m0CIIdIXKs3YO3JX9wTm8RXHDCgnWcWTa1E8EeEMZ53rAaRjssEQBzZu5vJdb2i25g3b
	 3z2bwWyCgHA17D6d8/3nEv1l46shXkbQ1qujBnhO8peedueelpyk0HArn+Gb9nRCAkXzd
	 nNhoJLh4UVsT+F663uPMmGvbX9W7/H9Was4VKnJ9wtV/HWEww6jfqsMebpu2CiQkLYy2g
	 H5EaToaIa7V2u5xEontZW4kcBo/z9YdJSFIbUNo0mwihjrGMY6hbxll4ry3hMpSVpTafp
	 8AyjM2Ym+KQVmxr83XjgfvOd+Cm3+kwAoywOI8QREw7PSvR/Gj8uxbVPch4WhgPmHMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792885703;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=PvD2eY8/Btwg8oEFTU1OxGBiRLbSrmrFxd6Fpk47nio=;
	b=GUnVmKuvvJJ6m2oJzNkZCoZAadFVTJNzaqJzYI7M8fxOCIxuUKRe53kNxBi8vIqa0jpz
	 nx91iEJ2FkGgE31089AIE036jgqXXBLWaNvHoo6+8SOtUuK/aj8LC3a1idK2yBLc0dcXJ
	 1F9kH7FgWbkOcqUTYPmuOEeali119I/wSH0pxxHaAWX9XXC3pGk2Jo/mRA6HBm4di9EXc
	 vA499h8wUOaSqtH8J4gCpiArdKIvxYfbbQqwoWyTGR9xATvqQpw566eW+X5AbO3UwMkc6
	 mNDNK7i8Ll8n7Zpp1rRnkd7n1PLTuZq28MzGFizF5rzuFjWXyoZMAQBPJ9iunX7IHRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jDn3+RHV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4CC606A32F;
	Sat, 24 Oct 2026 23:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jDn3+RHV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE1A1F01829;
	Sat, 24 Oct 2026 23:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792885703;
	bh=PvD2eY8/Btwg8oEFTU1OxGBiRLbSrmrFxd6Fpk47nio=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=jDn3+RHV30FbVvjjFAEIda6+EE8Iq05MPUmHs3p6xhYafM3Wwdp1EZP/UEl2hMi8+
	 F1uwIil/Rxi3I6XI21xVlUI8ebNiU1UPwuvIz9EKk/vmQ6TuD+PokDkjGxpKJOKahx
	 oCRUUbu+AVB5sUhfXvxugDOPUEiB+vBvcJWXy7TQ/IVGBOgbwQLuC/wNqmWT75ACpR
	 Nx8IhVvsUHgpbL5nRwlKzV1b3xbXDftrMp2SY5mBlCQDaDnsMb5ajU+M3awT5lO8C2
	 ZYw4STMe8L60UuvMW/oCWpB68WXXP9O84YImP+dRkcFyJLIt96106WhiuMQKBWVjon
	 ToQkylu99jVjQ==
Subject: Re: [PATCH net v3 2/4] psp: support ipv6 extension headers in
 psp_dev_rcv() decap
From: netdev-bot+sashiko@kernel.org
To: toddfreed@meta.com
Cc: netdev@vger.kernel.org, borisp@nvidia.com, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 daniel.zahka@gmail.com, willemdebruijn.kernel@gmail.com, horms@kernel.org,
 shuah@kernel.org, cratiu@nvidia.com, raeds@nvidia.com, rrameshbabu@nvidia.com,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, bjorn@kernel.org, dtatulea@nvidia.com
Date: Sat, 24 Oct 2026 23:48:21 +0000
Message-ID: <179288570143.3134.8925369868949382653@kernel.org>
In-Reply-To: <20261023234640.1459291-3-toddfreed@meta.com>
References: <20261023234640.1459291-3-toddfreed@meta.com>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] psp_dev_rcv() now decrypts and decaps PSP packets that carry
  IPv6 extension headers.

Pre-existing issues:
- [Low] TX/RX asymmetry for IPv6 extension headers.

--

psp: support ipv6 extension headers in psp_dev_rcv() decap

This patch makes psp_dev_rcv() skip IPv6 extension headers to find the
UDP and PSP headers. On decap it writes the inner nexthdr into the last
extension header instead of the fixed header. Packets that carry fragment
or authentication headers are dropped.

> diff --git a/net/psp/psp_main.c b/net/psp/psp_main.c
> index 273b010d2355c..206ab7c3e3b51 100644
> --- a/net/psp/psp_main.c
> +++ b/net/psp/psp_main.c

[ ... ]

> @@ -188,6 +189,39 @@ unsigned int psp_key_size(u32 version)
>  }
>  EXPORT_SYMBOL(psp_key_size);
>  

[ ... ]

> +static int psp_ipv6_nexthdr_off(const u8 *hdr, unsigned int len)
> +{
> +	unsigned int nh = offsetof(struct ipv6hdr, nexthdr);
> +	unsigned int off = sizeof(struct ipv6hdr);
> +	const struct ipv6_opt_hdr *eh;
> +	unsigned int rem;
> +	u8 type;
> +
> +	while (off < len) {
> +		eh = (const void *)(hdr + off);
> +		type = hdr[nh];
> +
> +		if (!ipv6_ext_hdr(type) || type == NEXTHDR_NONE ||
> +		    type == NEXTHDR_FRAGMENT || type == NEXTHDR_AUTH)
> +			return -EINVAL;

[Severity: High]
This filter only rejects NEXTHDR_FRAGMENT, NEXTHDR_AUTH and NEXTHDR_NONE.
That means routing headers of any type and any segments_left value are
accepted. So are hop-by-hop and destination options headers with any
option content. Could this expose decrypted plaintext through ICMPv6
errors?

The PSP ICV doesn't cover the outer IPv6 header or its extension headers.
An on-path attacker could take a captured PSP packet, insert one of these
headers, and set saddr to an address they control. This assumes the
device authenticates such packets, which this patch's premise implies.

Once psp_dev_rcv() succeeds, the driver marks the skb as decrypted.
For example, mlx5e_psp_offload_handle_rx_skb() sets skb->decrypted = 1.
The IPv6 stack then processes the extension headers before tcp_v6_rcv()
reaches psp_sk_rx_policy_check().

Several of those handlers reply with an ICMPv6 error that quotes the
packet. With default sysctls, this happens for an unrecognized routing
header type (type 0, for example) with segments_left != 0:

net/ipv6/exthdrs.c:ipv6_rthdr_rcv() {
    ...
unknown_rh:
	__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
	icmpv6_param_prob(skb, ICMPV6_HDR_FIELD,
			  (&hdr->type) - skb_network_header(skb));
    ...
}

It also happens for an unknown destination or hop-by-hop option whose
action bits request a parameter problem, through
ip6_parse_tlv()->ip6_tlvopt_unknown():

	case 2: /* send ICMP PARM PROB regardless and drop packet */
		icmpv6_param_prob_reason(skb, ICMPV6_UNK_OPTION, optoff,
					 SKB_DROP_REASON_UNHANDLED_PROTO);

When seg6_enabled is set, ipv6_srh_rcv() calls icmpv6_param_prob() if
segments_left >= (hdrlen >> 1). It also sends ICMPV6_TIME_EXCEED in the
hop_limit <= 1 loopback case.

icmp6_send() copies up to 1232 bytes of the original packet, starting at
the network header, into a new skb. That limit is IPV6_MIN_MTU minus the
IPv6 and ICMPv6 headers. The new skb doesn't have decrypted set, so
sk_validate_xmit_skb() doesn't drop it. It is sent in cleartext to the
attacker-chosen saddr, carrying the decrypted TCP header and payload.

Before this patch, all of these packets were dropped at the is_udp check.
Forwarding the decrypted skb itself looks blocked by
sk_validate_xmit_skb() ("unencrypted skb with no associated socket -
dropping"). That leaves the ICMP error path as the open channel.

Should psp_ipv6_nexthdr_off() be stricter about which extension headers
and options it accepts? Rejecting only routing headers with
segments_left != 0 would not cover the destination or hop-by-hop options
case. Later patches in the series don't change psp_ipv6_nexthdr_off() or
psp_dev_rcv().

[ ... ]

> @@ -390,10 +445,11 @@ int psp_dev_rcv(struct sk_buff *skb, u16 dev_id, u8 generation, bool strip_icv)
>  	} else {
>  		struct ipv6hdr *ipv6h = (struct ipv6hdr *)(skb->data + l2_hlen);
>  
> -		if (unlikely(ntohs(ipv6h->payload_len) < encap))
> +		if (unlikely(ntohs(ipv6h->payload_len) <
> +			     l3_hlen - sizeof(*ipv6h) + encap))
>  			return -EINVAL;
>  
> -		ipv6h->nexthdr = psph->nexthdr;
> +		((u8 *)ipv6h)[nh_off] = psph->nexthdr;

[Severity: Low]
This is a pre-existing issue, not one introduced by this patch. The TX
side in psp_dev_encapsulate() still writes IPPROTO_UDP into the fixed
header:

	} else {
		ipv6_hdr(skb)->nexthdr = IPPROTO_UDP;
		be16_add_cpu(&ipv6_hdr(skb)->payload_len, PSP_ENCAP_HLEN);
	}

The UDP and PSP headers are inserted after skb_network_header_len()
bytes, which include any extension headers. A TCPv6 socket with
IPV6_HOPOPTS, IPV6_DSTOPTS or IPV6_RTHDR set would therefore emit:

  fixed(nexthdr=UDP) | EXT(nexthdr=TCP) | UDP | PSP | TCP

The new psp_dev_rcv() code expects the UDP nexthdr in the last extension
header. Here it would treat the first extension header as the UDP header
and drop the packet on the dport check.

In netdevsim, nsim_do_psp() calls psp_dev_encapsulate() and then
psp_dev_rcv(). So at this commit, the new RX path can't be tested end to
end with extension headers.

The next patch in the series, "psp: support ipv6 extension headers in
psp_dev_encapsulate()", seems to fix this. It reuses
psp_ipv6_nexthdr_off() and writes IPPROTO_UDP at nh_off. Would it make
sense to land the TX change before this one, or together with it?

>  		ipv6h->payload_len = htons(ntohs(ipv6h->payload_len) - encap);
>  	}
>

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261023234640.1459291-1-toddfreed%40meta.com
