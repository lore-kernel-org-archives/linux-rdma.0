Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795138316;
	b=VK5ISte63zgiO0bvIE8Zn5I+q+x/2IudeJoaZ2AXDLHY2ykJBM1bdfWwHZxTTx9qLXSx
	 /rLW3nYac0RhqFXpXrzRSv6r3CpH+NHBmDsJ1VfQKlJTiiwk25QuAyOx6t1nMkjytMkNX
	 z46jC6rMj1grfbhdkVSaWTmCiOqZEJcMdkP+F6CNsu4RCoxJO8RN95dZbapQImaYJ3x6Q
	 FvJdKlX08fq+zSaab8X2zI1USNQqBYdeJXr+XoF4GX+ICRVeOD85oRIUNqTVj3VOrhy/U
	 OnxnLUU9zYn9rgA7AWpsX8qEzfBjz0IX9OJSG03NElXkBQOMZi01lgkt0VsiIWNy6lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795138316;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=W3U+DiHsTo89zU9T0xEA7l81Hf7pLxoR4RXEss/W0uc=;
	b=2rlswO963SMBqjOWsbzp0yO/hZyER62j7rVkHVY3r/XWO3y6Kw63uWFt65Q/1ZKgO18J
	 Yp6HDlQhVwiLDEVGYtTyXRPTJsr/I77Txnnaj8d4QGUS8wSCxRhOHJUGbFlPuky6arYt7
	 ICVqbMnUiMHHaV8wNqbd/6G27Sji7Di2HK2S2QmBzuNJjl2fbLdU4rRWR76bAozjY7h7r
	 j4Uga910wxqtaF2r/VvIg24BMygdpIUGhdN6TbWfpMIYDKoqpW+1PzCVkeGZub+UmAZkC
	 ePQ7C6mVNy6NPhiWIpgGO1Xl06+lM05mHDatE/SDFSd/+5VdNTi7jJK2I/L3H3IZFAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S5ob6PJw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40D7606A326
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 01:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S5ob6PJw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910B81F000CF;
	Fri, 20 Nov 2026 01:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795138316;
	bh=W3U+DiHsTo89zU9T0xEA7l81Hf7pLxoR4RXEss/W0uc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S5ob6PJw7fVtZjGUjA2gT3373cRUXprArapfmw971/5zSGdq6QCHKbzl3DghL2CEG
	 VcZ/pGk2UR0YaQ9PwaXovGmCqqg5t9xR6UqaGhcW23kyxf5CA/kSfz+HM5ptz6qKdb
	 +RWM37it1LF7yYNTwWeYlrKtos+Aytj6W7L4v4fg0dnklTjj5RieijQ0bJvGgEn1jg
	 7VPCFejGLeSCIrx8N+6RFQou1u3REFmU/WlG2XpH1b/0I6vx+GWolcbxmCmPegC3+R
	 x5dAF4Jyz+V4M2sHVUbB+oZKAM7nXhEE87Q6iLoM7uzjntkMWDd72QPUuR2+WdXvEN
	 3YSZhPLBud09A==
Message-ID: <sashiko-outbox-224309@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 02/12] psp: take the psp nexthdr from the
 packet on encap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119013103.1092559-3-toddfreed@meta.com>
References: <20261119013103.1092559-1-toddfreed@meta.com>
 <20261119013103.1092559-3-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 01:31:56 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mlx5e: psp software GSO on tunneled skbs bypasses
  psp_dev_encap_ok()
--

commit a0d2a8f5be06d7567437603fff001e2cd59e1432
Author: Todd Freed <toddfreed@meta.com>

psp: take the psp nexthdr from the packet on encap

This commit populates the PSP next header from the original IP header
instead of hardcoding IPPROTO_TCP, rejecting unsupported packets such as
fragments, IPv6 extension headers, and already-encapsulated tunnel packets,
and adjusts mlx5e feature checks and outer UDP source port selection for
non-TCP packets.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en_main.c
> index 2be8147fdb64f..d6c32080634da 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -5139,6 +5139,23 @@ static netdev_features_t mlx5e_tunnel_features_che=
ck(struct mlx5e_priv *priv,
>  	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
>  }
> =20
> +/* The L4 protocol right after the fixed IP header, which the PSP Tx path
> + * requires, is one the device can complete the checksum of
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
> @@ -5147,6 +5164,22 @@ netdev_features_t mlx5e_features_check(struct sk_b=
uff *skb,
> =20
>  	features =3D vlan_features_check(skb, features);
> =20
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

[Severity: Medium]
Can clearing NETIF_F_CSUM_MASK or NETIF_F_GSO_MASK on a tunneled GSO skb
(skb->encapsulation =3D=3D 1) cause software GSO to strip skb->encapsulation
before psp_dev_encap_ok() checks it?

For an already-encapsulated GSO packet such as GRE (IPPROTO_GRE),
mlx5e_psp_l4_csum_ok() sees the outer IP protocol, returns false, and
clears NETIF_F_CSUM_MASK, causing harmonize_features() to also clear
NETIF_F_GSO_MASK.  When validate_xmit_skb() then runs software tunnel
GSO (e.g., gre_gso_segment()), it segments and checksums the inner
packet in software, clears seg->encapsulation to 0, sets
seg->transport_header to the outer tunnel header right after the outer
IP header, and (for SKB_GSO_GRE_CSUM) sets seg->ip_summed to
CHECKSUM_PARTIAL for the GRE checksum.

When those segments reach mlx5e_psp_handle_tx_skb() ->
psp_dev_encapsulate(), psp_dev_encap_ok() sees seg->encapsulation =3D=3D 0
and skb_network_header_len(seg) =3D=3D ip_hdrlen(seg), so it encapsulates
the tunnel packet with nexthdr =3D IPPROTO_GRE instead of rejecting it.
mlx5e_psp_set_swp() then leaves eseg->swp_inner_l4_offset as 0 because
skb->inner_ipproto is IPPROTO_GRE, while
mlx5e_psp_txwqe_build_eseg_csum() still sets
MLX5_ETH_WQE_L4_INNER_CSUM for the CHECKSUM_PARTIAL segment, producing
corrupted frames or device TX syndromes.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119013103.1092=
559-1-toddfreed@meta.com?part=3D2
