Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794769126;
	b=kb+V/0KmjsJasXTAwbkY2v1sPpyqE6k8OXZfYjEKqtO7mjDNu5MQo3ZD22ljTAOJ/1bd
	 uvLa9UMzIlKiRgJW7eC+gLaoscQ720K6jZ2NWfvF0wJS1K+J3tsrp/gqZ+aOVzQChT0a4
	 L+x52LjlFCLPdkoPxTtMvV3afsQPTDYj1V2TCkx+koe6C9hH4ehtsOc+5dgHdbXlj/Ve/
	 OCAgi0TfJmo0JpPuBEKzQ664Z/48TbgYeyBvILzOv7RRMvBAU+6d6IaZUnbbgpeKZ4iMm
	 J1SeUZKHbh42fl9jPYs1kQtzvB8hVfSNxLSzCS4USe7tht+nZgS48HZKibBJC9worgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794769126;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=OozrX5+5YwM9zfAx2Ehcf9fkQN+LRH5406p4vwn9r4M=;
	b=JA2yuAsAPuWzzhTwVgkwOeLTEq/040eF06rD32W7wwkiUep+JOZj5Gn7cJnQx/xNTTgF
	 tWB32cuJwNpFZrXHUJy2zHxpseXs3wTHbTBAvYr0AkeyBkmyq5nUug5A+T5uSRK+pDPpe
	 8gjCwTdQEIpXO5mzeLjaP0EoRHvFZkLAPbI+4/C5YY6MY3FW/o8te6M+azNa4PcdXZzHF
	 DUwnq/yqrYA8GBXn4DNqTzS/+ETLqjKL54D32KY8XROYJ4RzhqEgjvw5bc67hrn/oAxd7
	 BvOgBXcRG5WqAVFQ9AcQOia+JD370vSNU8gDs4lbHfiGkcOfHcl8V36PcWHQzGfCKAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HiFMf+fs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E832606A31F;
	Sun, 15 Nov 2026 18:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HiFMf+fs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CB71F000C4;
	Sun, 15 Nov 2026 18:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794769126;
	bh=OozrX5+5YwM9zfAx2Ehcf9fkQN+LRH5406p4vwn9r4M=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=HiFMf+fsX9h3AY3nU/qSUJua+WK8RqANhDvSWxiYvrzk7s8VtzZbjoE1B7kpXcjvT
	 scVw3f3H7HpUkNDRwwPKtXGWIzraAUhKU/NaCZzpbYA5XDNdypZRC3ebProtupJjuG
	 h3zalkE8LihjosLrD66oF9Nn4f2vwAC99RIKKh5mNBWBs45OiCHE0W5ogWluAhqZd5
	 LPdzpVCXsIVS+GOYA89rBF1k2AJ4zrR7VBCJh/E0Z/BZUgYS+2dIZKtNKrI94R0P79
	 TfsCfVKhdBIa7tJb9oA5WPQrRtYpF4M13MNXEifibX6akvy6hnkLeUF4kd04pkn0W5
	 sUWdO3U7jx9fw==
Subject: Re: [PATCH net v2 1/2] net: keep the TCP fixed-ID flags on the header
 they describe
From: netdev-bot+sashiko@kernel.org
To: julius@bairaktaris.de
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, andrew+netdev@lunn.ch,
 dsahern@kernel.org, idosch@nvidia.com, ncardwell@google.com,
 kuniyu@google.com, richardbgobert@gmail.com, willemb@google.com,
 ecree.xilinx@gmail.com, linux-net-drivers@amd.com, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 linux-rdma@vger.kernel.org, alexei.starovoitov@gmail.com, ast@kernel.org,
 daniel@iogearbox.net, john.fastabend@gmail.com, sdf@fomichev.me,
 martin.lau@linux.dev, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com,
 song@kernel.org, yonghong.song@linux.dev, jolsa@kernel.org,
 emil@etsalapatis.com, ihor.solodrai@linux.dev, corbet@lwn.net,
 rdunlap@infradead.org, skhan@linuxfoundation.org, shuah@kernel.org,
 bpf@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 15 Nov 2026 18:58:43 +0000
Message-ID: <179476912337.3136.17852036246328803167@kernel.org>
In-Reply-To: <f7d096c63c6a0b7a23a4dcea9a3de0915a48ac56.1794139176.git.julius@bairaktaris.de>
References: <f7d096c63c6a0b7a23a4dcea9a3de0915a48ac56.1794139176.git.julius@bairaktaris.de>
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

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 2 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The commit message says the case 'Decapsulation leaves the state
  of the removed outer header on the new outer one' is fixed by clearing…
- [High] The patch says 'A new outer header then has no flag and gets
  incrementing IDs, so encapsulation needs no change', and the new…
- [Medium] inet_gso_segment() (net/ipv4/af_inet.c:1405-1410) now uses
  skb->encapsulation alone to decide that the header at encap_level 0 is…
- [Low] bpf_skb_net_shrink() (net/core/filter.c:3870) now clears
  SKB_GSO_TCP_FIXEDID_OUTER whenever a BPF_F_ADJ_ROOM_DECAP_L4_* or…

--

net: keep the TCP fixed-ID flags on the header they describe

This patch makes SKB_GSO_TCP_FIXEDID describe the innermost IPv4 header
again. It replaces SKB_GSO_TCP_FIXEDID_INNER with
SKB_GSO_TCP_FIXEDID_OUTER for the outer header of an encapsulated packet.
Decapsulation clears the outer flag in iptunnel_pull_offloads() and
bpf_skb_net_shrink(), and mlx5 and sfc are converted to the new flag.

[ ... ]

> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 6787fcf6ac3e4..6eb913ebc7d53 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -716,9 +716,11 @@ enum {
>  
>  	/* These indirectly map onto the same netdev feature.
>  	 * If NETIF_F_TSO_MANGLEID is set it may mangle both inner and outer IDs.
> +	 * SKB_GSO_TCP_FIXEDID stays with the innermost IPv4 header, so there is
> +	 * nothing to do on encapsulation. Decapsulation clears the outer flag.

[Severity: High]

Is "nothing to do on encapsulation" still true when the skb is already
encapsulated?

Take a forwarded IPIP stream that a router GRO merges without
terminating the tunnel. ipip_gro_complete() sets skb->encapsulation = 1.
tcp4_gro_complete() then maps the old outer header's fixed-ID bit to
SKB_GSO_TCP_FIXEDID_OUTER.

If that skb is then routed into an IP tunnel,
ipip_tunnel_xmit()->iptunnel_handle_offloads() skips the reset block and
only ORs in the new tunnel type:

net/ipv4/ip_tunnel_core.c:iptunnel_handle_offloads() {
	if (likely(!skb->encapsulation)) {
		skb_reset_inner_headers(skb);
		skb->encapsulation = 1;
	}

	if (skb_is_gso(skb)) {
		...
		skb_shinfo(skb)->gso_type |= gso_type_mask;
		return 0;
	}
}

So SKB_GSO_TCP_FIXEDID_OUTER stays set. IPVS ip_vs_tunnel_xmit() goes
through the same helper.

In software GSO, inet_gso_segment() handles the newly created outermost
header at encap_level 0 with skb->encapsulation set. It reads
SKB_GSO_TCP_FIXEDID_OUTER, which was recorded for the old outer header.

Would every segment then share one ID on the header the tunnel just
built, even though iptunnel_xmit() reserved gso_segs IDs for it?

For IPIP-in-IPIP, ipip_gso_segment() reaches the old outer header (now
the middle one) at encap_level > 0. There it reads SKB_GSO_TCP_FIXEDID,
which holds the innermost header's state. With two flags and three IPv4
headers, the middle header's state can't be represented.

The ESP tunnel mode case doesn't look affected. GRO'd encapsulated skbs
have inner_protocol set, so xfrm_output() segments them through
xfrm_output_gso() before ESP adds its header.

The behaviour here is the same as before the patch. However, the commit
message says the "forwarded into an IPIP tunnel" case is fixed and that
"encapsulation needs no change".

Should the tunnel xmit path clear SKB_GSO_TCP_FIXEDID_OUTER when it adds
a header to an already-encapsulated skb? Or should the comment and the
commit message be narrowed?

>  	 */
>  	SKB_GSO_TCP_FIXEDID = 1 << 30,
> -	SKB_GSO_TCP_FIXEDID_INNER = 1 << 31,
> +	SKB_GSO_TCP_FIXEDID_OUTER = 1 << 31,
>  };
>  
>  #if BITS_PER_LONG > 32
> diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
> index 5cccf4c0e6913..a8e1cd7021fcf 100644
> --- a/include/net/ip_tunnels.h
> +++ b/include/net/ip_tunnels.h
> @@ -667,6 +667,7 @@ static inline int iptunnel_pull_offloads(struct sk_buff *skb)
>  			return err;
>  		skb_shinfo(skb)->gso_type &= ~(NETIF_F_GSO_ENCAP_ALL >>
>  					       NETIF_F_GSO_SHIFT);
> +		skb_shinfo(skb)->gso_type &= ~SKB_GSO_TCP_FIXEDID_OUTER;

[Severity: High]

The commit message says decapsulation "clears the outer flag in
iptunnel_pull_offloads() and bpf_skb_net_shrink()". Does the netfilter
flowtable IPIP fast path need the same change?

nf_flow_encap_pop()->nf_flow_ip_tunnel_pop() removes the outer IPv4
header of a GRO'd IPIP skb:

net/netfilter/nf_flow_table_ip.c:nf_flow_ip_tunnel_pop() {
	...
	skb_pull(skb, ctx->tun.hdr_size);
	skb_reset_network_header(skb);

	if (ctx->tun.inner_proto == IPPROTO_IPIP)
		skb->protocol = htons(ETH_P_IP);
	...
}

It never touches gso_type or skb->encapsulation.

ipip_gro_complete() set skb->encapsulation = 1, and tcp4_gro_complete()
stored the removed outer header's state in SKB_GSO_TCP_FIXEDID_OUTER. On
transmit, software GSO runs inet_gso_segment() for the remaining header
at encap_level 0. It reads SKB_GSO_TCP_FIXEDID_OUTER and ignores
SKB_GSO_TCP_FIXEDID, which is the flag that describes this header.

Suppose the removed header had fixed IDs and the remaining one did not.
Wouldn't every forwarded segment get the same ID? inet_gro_flush() only
requires DF to match between packets, so that header may have DF clear.
In the reverse case, fixed IDs are rewritten as incrementing.

The result is the same as before the patch. Still, this is the
"Decapsulation leaves the state of the removed outer header on the new
outer one" case that the commit message says is fixed.

Should nf_flow_ip_tunnel_pop() also clear SKB_GSO_TCP_FIXEDID_OUTER, or
skb->encapsulation?

>  	}
>  
>  	skb->encapsulation = 0;
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 52e6ea6d50455..340b2e64d818e 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3867,6 +3867,7 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
>  		/* Clear encapsulation flag only when no tunnel GSO flags remain */
>  		if (flags & (BPF_F_ADJ_ROOM_DECAP_L4_MASK |
>  			     BPF_F_ADJ_ROOM_DECAP_IPXIP_MASK)) {
> +			shinfo->gso_type &= ~SKB_GSO_TCP_FIXEDID_OUTER;

[Severity: Low]

This isn't a bug, but the documentation no longer matches the code
here.

The new clear only runs when BPF_F_ADJ_ROOM_DECAP_L4_MASK or
BPF_F_ADJ_ROOM_DECAP_IPXIP_MASK flags are passed. The
bpf_skb_adjust_room() documentation in include/uapi/linux/bpf.h lists
which SKB_GSO_* flags each decap flag clears, and this one isn't
included. That documentation also says BPF_F_ADJ_ROOM_DECAP_L3_IPV4 and
BPF_F_ADJ_ROOM_DECAP_L3_IPV6 "only trigger a protocol change without
clearing any tunnel-specific GSO flags".

The new skbuff.h comment says, with no qualification, "Decapsulation
clears the outer flag". After a decap with flags = 0 or with only the
DECAP_L3 flags, both SKB_GSO_TCP_FIXEDID_OUTER and skb->encapsulation
stay set. inet_gso_segment() then applies the removed header's state to
the new outermost header.

Could the uapi documentation list SKB_GSO_TCP_FIXEDID_OUTER, and could
the skbuff.h comment be qualified to match?

>  			if (!(shinfo->gso_type & (SKB_GSO_UDP_TUNNEL |
>  						  SKB_GSO_UDP_TUNNEL_CSUM |
>  						  SKB_GSO_GRE |
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 7677b0343abd4..d5769a5fdc314 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -1402,10 +1402,12 @@ struct sk_buff *inet_gso_segment(struct sk_buff *skb,
>  
>  	segs = ERR_PTR(-EPROTONOSUPPORT);
>  
> -	fixedid = !!(skb_shinfo(skb)->gso_type & (SKB_GSO_TCP_FIXEDID << encap));
> -
> -	if (!skb->encapsulation || encap)
> +	if (!skb->encapsulation || encap) {
>  		udpfrag = !!(skb_shinfo(skb)->gso_type & SKB_GSO_UDP);
> +		fixedid = !!(skb_shinfo(skb)->gso_type & SKB_GSO_TCP_FIXEDID);
> +	} else {
> +		fixedid = !!(skb_shinfo(skb)->gso_type & SKB_GSO_TCP_FIXEDID_OUTER);
> +	}

[Severity: Medium]

Does the else branch hold for ESP transport mode and BEET with crypto
offload?

xfrm_output() sets skb->encapsulation = 1 for every offloaded state. For
transport and BEET GSO skbs it then only adds SKB_GSO_ESP:

net/xfrm/xfrm_output.c:xfrm_output() {
	...
		xfrm_get_inner_ipproto(skb, x);
		skb->encapsulation = 1;

		if (skb_is_gso(skb)) {
			if (skb->inner_protocol && x->props.mode == XFRM_MODE_TUNNEL)
				return xfrm_output_gso(net, sk, skb);

			skb_shinfo(skb)->gso_type |= SKB_GSO_ESP;
			goto out;
	...
}

No second IPv4 header is added.

The stack can fall back to software GSO when the device lacks GSO_ESP
or TSO_MANGLEID, or in validate_xmit_xfrm() after a reroute. In that
case inet_gso_segment() handles the only IPv4 header at encap_level 0
with skb->encapsulation == 1. It takes the else branch and reads
SKB_GSO_TCP_FIXEDID_OUTER.

esp4_gso_segment()->xfrm4_transport_gso_segment() and
xfrm4_beet_gso_segment() call the TCP handler directly, so
SKB_GSO_TCP_FIXEDID is never read on this path.

For a forwarded TCP stream that GRO merged without a tunnel,
tcp4_gro_complete() sets only SKB_GSO_TCP_FIXEDID, because
skb->encapsulation is 0 at GRO time.

Won't these segments now get incrementing IDs even though the stream had
fixed IDs? Before this patch, SKB_GSO_TCP_FIXEDID << encap with
encap == 0 read SKB_GSO_TCP_FIXEDID and the IDs were kept.

>  
>  	ops = rcu_dereference(inet_offloads[proto]);
>  	if (likely(ops && ops->callbacks.gso_segment)) {

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1794139176.git.julius%40bairaktaris.de
