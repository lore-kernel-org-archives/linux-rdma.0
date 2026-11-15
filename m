Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794712695;
	b=0cfll5ynoEK+xSFG6FPcckwNTRu3fhdyCEQfUCuASGt3LAvlyRFKHiliDzfuGBcyXctk
	 Hm8AzdfUSkhTMVsEksWFpBcj2aV8qUK35MCFZbMhRlefmEN931d0P55hZrkHM/PbNw+nS
	 DnItSCIIRzjyFcGPsVMOlYT95VGpjDdkqr9VaVxh+GfKGyvwgI5vn+PuqSWQY6/xsadAo
	 8gmK2+AQ4/iUTyippejoTZyfOSGTDqJzlRgzu316YzEEo07KqPxB187UUUjEnOz30uL+O
	 PdP6YzGVg+asfwNMipciyjcZ82Tqd/+3+vTyyy8ljF81Au+M1VFIIrBLwfTw7piPGnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794712695;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=4Ndi0ltXRU7nxmxD7d4uTFdZMGtp3eSYlxzbi6FeOro=;
	b=tj4iNrVHo1sPwASgsugDADSPZwCWnTXa+etgqEdPLyHV+2TubqLfgOF9hujD79FlVeak
	 Htx/kjY9H4Ku1gL0VqCOf5yTTt4t9rVcTOj8G53fJY2EbZjptptgI3QVyTogTYtQ4UEZM
	 m+vdmq9sXOQDyhrAxWqEvDS4j7GdDXlx2hrK8gSALgJbs8HVwwE39lU6RGGXaz5j3dPA1
	 3BOcPcLl6arYU/lbm9FHRVbEixb7v5OYnZXU+Lk70Id+eUOfCG0+5EFrfJ4J++nJM9DsA
	 QI/qjlkxL2H/gEty+vICJxHntMddPBqBOJ2VKiUb6hst4MwGl/shE85ywjBWMUq3HYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="T9AN4k/r";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D980606A323;
	Sun, 15 Nov 2026 03:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T9AN4k/r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885FE1F000C4;
	Sun, 15 Nov 2026 03:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794712694;
	bh=4Ndi0ltXRU7nxmxD7d4uTFdZMGtp3eSYlxzbi6FeOro=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=T9AN4k/reNPzg8+Lb9NCo+jxd1Fl8TuGmTEa+NKww9XMoDiNn+ZmkusVGcxs9RWvt
	 S5MIuVkS4w42HcwHA2JKfvoqYv+1ZauvRCERXjpEA4HcqK25zJ2r5V5/4o2uiDgOYi
	 Vx1uSJ5r0Idxflhw6kgpZjd50ERQUA38BZ4umiFTPpVDYYHnw42tLdymtgJ/FwJXq6
	 BvkQeITgYVLGAuBXb1jP3w4YzCV024x8urb8Rr9fAht7oC2ay4dZDs+cQklC0fBNf/
	 Q/sQ5TMozOjY4Q3N/XQ+bM7Uh7BC/mh7xw7QRTrhUUGTwd6Tr3Qw2QcuZv0SfPiqxv
	 naBffzjBpIdVg==
Subject: Re: [PATCH net-next v1 02/15] psp: take the psp nexthdr from the
 packet on encap
From: netdev-bot+sashiko@kernel.org
To: toddfreed@meta.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
 bjorn@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
 daniel.zahka@gmail.com, donald.hunter@gmail.com, edumazet@kernel.org,
 kuba@kernel.org, jhs@mojatatu.com, jiri@resnulli.us, john.fastabend@gmail.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 martin.lau@linux.dev, pabeni@redhat.com, saeedm@nvidia.com, horms@kernel.org,
 tariqt@nvidia.com, weiwan@google.com, willemdebruijn.kernel@gmail.com
Date: Sun, 15 Nov 2026 03:18:13 +0000
Message-ID: <179471269307.2199510.1215468778950936295@kernel.org>
In-Reply-To: <20261111005533.6436-3-toddfreed@meta.com>
References: <20261111005533.6436-3-toddfreed@meta.com>
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

- [Medium] This patch makes psp_dev_encapsulate() accept protocols other
  than TCP: psp->nexthdr and inner_ipproto now come from the packet, and…

--

psp: take the psp nexthdr from the packet on encap

This patch takes the PSP next header from the IP header of the original
packet instead of hardcoding IPPROTO_TCP, so that socket-less associations
can carry UDP. psp_dev_encapsulate() now refuses packets with IPv6
extension headers, IPv4 fragments and skbs that are already encapsulated.
mlx5e_features_check() also turns off GSO and checksum offload for PSP
skbs the device can't handle.

> diff --git a/net/psp/psp_main.c b/net/psp/psp_main.c
> index e09f6fec948d7..1eb1617aaf2b5 100644
> --- a/net/psp/psp_main.c
> +++ b/net/psp/psp_main.c

[ ... ]

> @@ -236,7 +237,7 @@ static void psp_write_headers(struct net *net, struct sk_buff *skb, __be32 spi,
>  	uh->check = 0;
>  	udp_set_len(uh, udp_len);
>  
> -	psph->nexthdr = IPPROTO_TCP;
> +	psph->nexthdr = nexthdr;

[Severity: Medium]

psp_dev_encapsulate() now accepts non-TCP packets. Is the outer UDP
source port selection in psp_write_headers() still correct when skb->sk
is a UDP socket?

The code just above this hunk still does:

	if (likely(sk)) {
		u32 hash = sk->sk_hash;
		...
		hash ^= hash << 16;
		uh->source = htons(reciprocal_scale(hash, max - min + 1) + min);
	}

The comment there assumes sk_hash is the TCP ehash, which stays constant
for the life of the flow. UDP sockets use the same storage for other
values:

include/linux/udp.h:
#define udp_port_hash		inet.sk.__sk_common.skc_u16hashes[0]
#define udp_portaddr_hash	inet.sk.__sk_common.skc_u16hashes[1]

udp_lib_get_port() then sets:

	udp_sk(sk)->udp_port_hash = snum;
	udp_sk(sk)->udp_portaddr_hash ^= snum;

At that point udp_portaddr_hash already holds
ipv4_portaddr_hash(net, rcv_saddr, 0).

After hash ^= hash << 16, the upper 16 bits are
udp_portaddr_hash ^ udp_port_hash. That cancels snum and leaves only the
hash of the netns and local address. reciprocal_scale() uses essentially
only those upper bits.

Wouldn't every UDP socket bound to the same local address then get the
same outer PSP source port? That includes all wildcard-bound sockets in a
netns, and it would undo the RSS spreading the comment describes.

This path becomes reachable later in the series. tcf_psp_act() in
net/sched/act_psp.c attaches the METADATA_PSP dst to egress skbs that
still carry their UDP skb->sk. As a result, mlx5 and netdevsim call
psp_dev_encapsulate()->psp_write_headers() with a UDP socket. The later
patches in the series leave psp_write_headers() unchanged. The sk == NULL
branch, which uses udp_flow_src_port(), is not affected.

Should the sk->sk_hash path be limited to TCP sockets, with other sockets
falling back to udp_flow_src_port()?

>  	psph->hdrlen = PSP_HDRLEN_NOOPT;
>  	psph->crypt_offset = 0;
>  	psph->verfl = FIELD_PREP(PSPHDR_VERFL_VERSION, ver) |

[ ... ]

> @@ -279,11 +313,11 @@ bool psp_dev_encapsulate(struct net *net, struct sk_buff *skb, __be32 spi,
>  		be16_add_cpu(&ipv6_hdr(skb)->payload_len, PSP_ENCAP_HLEN);
>  	}
>  
> -	skb_set_inner_ipproto(skb, IPPROTO_TCP);
> +	skb_set_inner_ipproto(skb, nexthdr);
>  	skb_set_inner_transport_header(skb, skb_transport_offset(skb) +
>  						    PSP_ENCAP_HLEN);
>  	skb->encapsulation = 1;
> -	psp_write_headers(net, skb, spi, ver,
> +	psp_write_headers(net, skb, spi, ver, nexthdr,
>  			  skb->len - skb_transport_offset(skb), sport);
>  
>  	return true;

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261111005533.6436-1-toddfreed%40meta.com
