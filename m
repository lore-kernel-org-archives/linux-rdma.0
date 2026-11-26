Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795703575;
	b=3ljPzOjcbI6gq5UP+golZFABptT9i3bR/Dyv4rjAeNNKUGecb7fp2zLDSKW8CgViln7r
	 8A7y0ynJlJW3m3Iv9S1y0eKUSBWoRwZouU3SdnoCIt3K2MuHBoTcScy16mwHcwmjwCd/8
	 Iq4ILif8ER6HbKmqgFuA1oujKbOjQmTelX37KSuiB1WMMlcWC8DJdITCiyxpYdNx1q0V6
	 7Rg/yazUTVd40ZN17cc2KbphGht0gjD+5msYSEWebjFX1IN7+1J5AXY3R73Pj7uyFLrEV
	 NAUpJethZKAYbwDqQsAU0RwsVZydTq4nt4uG1H29dX/BpsSOj6NSGmb7l/uXuJTgsAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795703575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lh7RPirw1fOLix78b5McENzWSQPv2ScyL9X0ufdtQao=;
	b=RtfF0jTxz52UoQrZ2YuxDTjTdKfQzlnDACaR0yrMgjpKyoVhSZvuGdQM+OQ8rKI1lFmB
	 xtbEKH9q+uV5o3ov28SjObsyhFf2UbUZSFXQx9Z57AzV77O/LgbY4XMmwZ/QJC4UKxNeQ
	 Et5ibvDjG/wqElNe9YZJvti0v/nCoNDh/xdRcfA0zUTaODMluZwjBkY26Pepk1yrdXbtI
	 /YrODVYJA+nwm33w58+PZLlglJddpVsLFkTRgcbiC6in+WIAAzA6xAofdm564pnklckiR
	 OCsHrxX6IpSR4lmOAx18A0XZR/WiKbnka8gY50tS6DUp84Qk+f+NqGvR9+ArzTExiSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HrNCUEeT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28024606A683;
	Thu, 26 Nov 2026 14:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HrNCUEeT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28361F000C4;
	Thu, 26 Nov 2026 14:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795703574;
	bh=lh7RPirw1fOLix78b5McENzWSQPv2ScyL9X0ufdtQao=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=HrNCUEeTAhOWR1IQilGFsl5Z0M6KEHvI3p4ZWhkWJYc1d/3XH4HfTdnseq1layVul
	 lOtNqTbJpsHUKstbpbjjtYqQX69nCKvS5+PsgDzzf+Cq+KWqngjIzTc3iBme6+zoSc
	 M39ST3oF5CJCTOEMq0tDLWmyrVIJ5lRYcY+rJT1R90HPfLeCv7IHwb3gD6G2G+sPI0
	 9Nn2gQBWu0jjP6GTuO2XWveelOPUmUaPer/YNTzdl6IbM75hivo+kH4u8Q0eQc4KkN
	 HtTLKBmIhLXuqmepKnj0ZdFVE3zXyITbbn4DdOgQnH9ZLCmw0FlfSW5p2//I9bEqF4
	 Gz6P9fwNyolBg==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: Todd Freed <toddfreed@meta.com>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Andrew Lunn
 <andrew+netdev@lunn.ch>, Boris Pismenny <borisp@nvidia.com>, Cosmin Ratiu
 <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Donald Hunter
 <donald.hunter@gmail.com>, Dragos Tatulea <dtatulea@nvidia.com>, Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Jamal
 Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>, Leon
 Romanovsky <leon@kernel.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, Paolo Abeni
 <pabeni@redhat.com>, Pedro Tammela <pctammela@mojatatu.com>, Saeed
 Mahameed <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq
 Toukan <tariqt@nvidia.com>, Wei Wang <weiwan@google.com>, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 bpf@vger.kernel.org, =?utf-8?Q?Asbj=C3=B8rn?= Sloth =?utf-8?Q?T=C3=B8nnes?=
 =?utf-8?Q?en?= <ast@fiberby.net>, Qingfang
 Deng <qingfang.deng@linux.dev>, Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgense?=
 =?utf-8?Q?n?= <toke@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 Matthieu
 Baerts <matttbe@kernel.org>, David Ahern <dsahern@kernel.org>, Jonas
 =?utf-8?Q?K=C3=B6ppeler?= <j.koeppeler@tu-berlin.de>, Hangbin Liu
 <hangbin.liu@linux.dev>
Subject: Re: [PATCH net-next v3 02/12] psp: take the psp nexthdr from the
 packet on encap
In-Reply-To: <20261124221758.3230929-3-toddfreed@meta.com>
References: <20261124221758.3230929-1-toddfreed@meta.com>
 <20261124221758.3230929-3-toddfreed@meta.com>
Date: Thu, 26 Nov 2026 15:32:50 +0100
Message-ID: <87h5h3irxp.fsf@all.your.base.are.belong.to.us>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Todd Freed <toddfreed@meta.com> writes:

> PSP socket support has thus far been limited to TCP, and
> psp_dev_encapsulate() hardcodes IPPROTO_TCP as the PSP next header.
>
> Socket-less PSP associations will also support UDP traffic. Populate the
> PSP next header from the IP header of the original packet instead.
>
> With the next header taken from the fixed header, psp_dev_encapsulate()
> now refuses some cases which are unsupported:
>
>  - IPv4 and IPv6 fragments. Non-initial fragments have no L4 header, so
>    this cannot work. Not a behavior change for PSP sockets.
>  - IPv6 extension headers. More generally, any packet whose transport
>    header isn't right after the IP header (IPv4 options are fine). Some
>    of these could be supported in the future. Not a behavior change for
>    PSP sockets.
>  - Already encapsulated for a tunnel (skb->encapsulation). Their inner
>    headers are already set up.
>  - A checksum to complete (CHECKSUM_PARTIAL) for a next header other than
>    TCP or UDP, which the device can't complete behind the PSP header.
>    Software GSO of a tunnel with an outer checksum, e.g. GRE with csum,
>    clears skb->encapsulation on the segments but leaves the outer checksum
>    to the device.
>
> Both callers of psp_dev_encapsulate(), mlx5 and netdevsim, drop the
> packet when it returns false.
>
> mlx5e also fixes up the TCP checksum of GSO skbs for the device, which
> is only valid for TCP. Have the stack segment other GSO skbs, e.g. UDP
> from socket-less associations, in software. Likewise the device only
> completes a TCP or UDP checksum behind the PSP header: have the stack
> checksum the other CHECKSUM_PARTIAL skbs.
>
> For the outer UDP source port, psp_write_headers() already branches to
> use TCP ehash if the skb has a socket, with fallback to
> udp_flow_src_port(). Previously, sk always meant TCP. Add an explicit
> check on nexthdr, and on the socket being a TCP one (a raw or packet
> socket can send TCP segments, and has no sk_hash), so that the fallback
> branch is taken for other packets. udp_flow_src_port() hashes the flow
> if the skb has no hash yet: compute it in psp_dev_encapsulate() before
> the headers are moved and the IP protocol rewritten, so that it covers
> the packet's own flow rather than the outer headers being written.
>
> Signed-off-by: Todd Freed <toddfreed@meta.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en_main.c | 33 +++++++++
>  net/psp/psp_main.c                            | 67 ++++++++++++++++---
>  2 files changed, 90 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en_main.c
> index 54f4f5a097c8..0fac06651e5b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -5248,6 +5248,23 @@ static netdev_features_t mlx5e_tunnel_features_che=
ck(struct mlx5e_priv *priv,
>  	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
>  }
>=20=20
> +/* The L4 protocol right after the IP header (and its IPv4 options), whi=
ch
> + * the PSP Tx path requires, is one the device can complete the checksum=
 of
> + */
> +static bool mlx5e_psp_l4_csum_ok(const struct sk_buff *skb)
> +{
> +	u8 proto;
> +
> +	if (skb->protocol =3D=3D htons(ETH_P_IP))
> +		proto =3D ip_hdr(skb)->protocol;
> +	else if (skb->protocol =3D=3D htons(ETH_P_IPV6))
> +		proto =3D ipv6_hdr(skb)->nexthdr;
> +	else
> +		return false;
> +
> +	return proto =3D=3D IPPROTO_TCP || proto =3D=3D IPPROTO_UDP;
> +}
> +
>  netdev_features_t mlx5e_features_check(struct sk_buff *skb,
>  				       struct net_device *netdev,
>  				       netdev_features_t features)
> @@ -5256,6 +5273,22 @@ netdev_features_t mlx5e_features_check(struct sk_b=
uff *skb,
>=20=20
>  	features =3D vlan_features_check(skb, features);
>=20=20
> +	/* The PSP tx path fixes up the TCP checksum of a GSO skb for the
> +	 * device, which is only valid for TCP, and the device only completes
> +	 * a TCP or UDP checksum behind the PSP header. Have the stack segment
> +	 * and checksum other skbs.
> +	 */
> +	if ((skb_is_gso(skb) || skb->ip_summed =3D=3D CHECKSUM_PARTIAL) &&
> +	    mlx5e_psp_is_offload(skb, netdev)) {
> +		if (skb_is_gso(skb) &&
> +		    !(skb_shinfo(skb)->gso_type &
> +		      (SKB_GSO_TCPV4 | SKB_GSO_TCPV6)))
> +			features &=3D ~NETIF_F_GSO_MASK;
> +		if (skb->ip_summed =3D=3D CHECKSUM_PARTIAL &&
> +		    !mlx5e_psp_l4_csum_ok(skb))
> +			features &=3D ~NETIF_F_CSUM_MASK;
> +	}

Hmm, that's a large check in the hotpath -- maybe it's cheap? So the
cost for small UDP packets with Tx checksumming enabled and no PSP don't
blow up.

> +
>  	/* Validate if the tunneled packet is being offloaded by HW */
>  	if (skb->encapsulation &&
>  	    (features & NETIF_F_CSUM_MASK || features & NETIF_F_GSO_MASK))
> diff --git a/net/psp/psp_main.c b/net/psp/psp_main.c
> index 964749a865b1..dc6144469647 100644
> --- a/net/psp/psp_main.c
> +++ b/net/psp/psp_main.c
> @@ -214,7 +214,8 @@ unsigned int psp_key_size(u32 version)
>  EXPORT_SYMBOL(psp_key_size);
>=20=20
>  static void psp_write_headers(struct net *net, struct sk_buff *skb, __be=
32 spi,
> -			      u8 ver, unsigned int udp_len, __be16 sport)
> +			      u8 ver, u8 nexthdr, unsigned int udp_len,
> +			      __be16 sport)
>  {
>  	struct udphdr *uh =3D udp_hdr(skb);
>  	struct psphdr *psph =3D (struct psphdr *)(uh + 1);
> @@ -236,10 +237,11 @@ static void psp_write_headers(struct net *net, stru=
ct sk_buff *skb, __be32 spi,
>  	 * This field is subject to reshuffling, thanks to
>  	 * sk_rethink_txhash() calls in various TCP functions.
>  	 *
> -	 * Instead, use sk->sk_hash which is constant through
> +	 * Instead, use sk->sk_hash for TCP which is constant through
>  	 * the whole flow duration.
>  	 */
> -	if (likely(sk)) {
> +	if (likely(sk && nexthdr =3D=3D IPPROTO_TCP &&
> +		   (!sk_fullsock(sk) || sk_is_tcp(sk)))) {
>  		u32 hash =3D sk->sk_hash;
>  		int min, max;
>=20=20
> @@ -261,7 +263,7 @@ static void psp_write_headers(struct net *net, struct=
 sk_buff *skb, __be32 spi,
>  	uh->check =3D 0;
>  	udp_set_len(uh, udp_len);
>=20=20
> -	psph->nexthdr =3D IPPROTO_TCP;
> +	psph->nexthdr =3D nexthdr;
>  	psph->hdrlen =3D PSP_HDRLEN_NOOPT;
>  	psph->crypt_offset =3D 0;
>  	psph->verfl =3D FIELD_PREP(PSPHDR_VERFL_VERSION, ver) |
> @@ -270,8 +272,34 @@ static void psp_write_headers(struct net *net, struc=
t sk_buff *skb, __be32 spi,
>  	memset(&psph->iv, 0, sizeof(psph->iv));
>  }
>=20=20
> -/* Encapsulate a TCP packet with PSP by adding the UDP+PSP headers and f=
illing
> - * them in.
> +/* UDP+PSP goes in at the transport header, the protocol of the IP header
> + * becomes UDP, and the PSP next header takes the protocol it had. The
> + * transport header must directly follow the IP header: IPv4 options are=
 fine,
> + * IPv6 extension headers aren't.
> + */
> +static bool psp_dev_encap_ok(const struct sk_buff *skb)
> +{
> +	u32 network_len =3D skb_network_header_len(skb);
> +
> +	/* inner headers already set up */
> +	if (skb->encapsulation)
> +		return false;
> +	/* fragments not supported for transport mode */
> +	if (skb->protocol =3D=3D htons(ETH_P_IP))
> +		return network_len =3D=3D ip_hdrlen(skb) &&
> +		       !ip_is_fragment(ip_hdr(skb));
> +	if (skb->protocol =3D=3D htons(ETH_P_IPV6))
> +		return !ipv6_ext_hdr(ipv6_hdr(skb)->nexthdr) &&
> +		       network_len =3D=3D sizeof(struct ipv6hdr);
> +	return false;
> +}
> +
> +/* Encapsulate a packet with PSP by adding the UDP+PSP headers and filli=
ng
> + * them in. The PSP next header is taken from the IP header: packets with
> + * IPv6 extension headers, or whose transport header isn't right after t=
he IP
> + * header, are refused, as are IP fragments, packets already encapsulated
> + * for a tunnel, and packets with a checksum to complete for a protocol =
other
> + * than TCP or UDP.
>   */
>  bool psp_dev_encapsulate(struct net *net, struct sk_buff *skb, __be32 sp=
i,
>  			 u8 ver, __be16 sport)
> @@ -279,11 +307,30 @@ bool psp_dev_encapsulate(struct net *net, struct sk=
_buff *skb, __be32 spi,
>  	u32 network_len =3D skb_network_header_len(skb);
>  	u32 ethr_len =3D skb_mac_header_len(skb);
>  	u32 bufflen =3D ethr_len + network_len;
> +	u8 nexthdr;
>=20=20
> -	if (skb->protocol !=3D htons(ETH_P_IP) &&
> -	    skb->protocol !=3D htons(ETH_P_IPV6))
> +	if (!psp_dev_encap_ok(skb))
>  		return false;
>=20=20
> +	if (skb->protocol =3D=3D htons(ETH_P_IP))
> +		nexthdr =3D ip_hdr(skb)->protocol;
> +	else
> +		nexthdr =3D ipv6_hdr(skb)->nexthdr;
> +
> +	/* Devices complete only a TCP or UDP checksum behind the PSP header.
> +	 * Software GSO of a tunnel with an outer checksum, e.g. GRE, leaves
> +	 * the segments here with encapsulation cleared and CHECKSUM_PARTIAL
> +	 * at the tunnel header.
> +	 */
> +	if (skb->ip_summed =3D=3D CHECKSUM_PARTIAL &&
> +	    nexthdr !=3D IPPROTO_TCP && nexthdr !=3D IPPROTO_UDP)
> +		return false;
> +
> +	/* udp_flow_src_port() may need to hash the flow: do it on the
> +	 * original headers, before they are moved and rewritten
> +	 */
> +	skb_get_hash(skb);

Wdyt about adding a helper that does source port selection here?
Then pass that sport to the psp_write_headers (unused argument btw). The
block in the header writer is then just uh->source =3D sport.

Interesting series!


Bj=C3=B6rn
