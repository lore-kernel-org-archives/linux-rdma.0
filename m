Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445020;
	b=5mzAPVTGyWC0O+UpULZ4aV2TMtyKoaNyr8EZ7YgR/RzYk4V+HhUXd1LROH65J4hY8/O4
	 9UGFLIeYMOnTvdLGSY9DaqoqPSHqSlwCU62cqvNiZxMrOcPmTRsRwaloUFn2777nZIcsm
	 amtSeWpiE9iOaFt3apRm5LLHfDRtnajMyxbI0R2ajdboMzTOWD1En7r6zOLM+wvmqj1Jv
	 0maQTvlBSW3w+Pnb4a/SOjn1Fu1rGV62vI49NIxED9kfX/X5FoynV0fD7tqelFMRBBquz
	 TLr5Gl1rlmtl8bQxkIT9F9sT1AB1MJl+eEj8X5oMkzDg4p7pRlIG+2mvVXmyysXTfJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445020;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gWfHLyQLp5lkE6MADJry2BBpDAlp8gpq9Vu/5uioiTQ=;
	b=tN2/OCmFo85oRlg690+5BvN+qc+wUmOMI4x4BCZ1CWjmN0nsRz3vN+uAgX26rU2c8hXR
	 vhRsr2QNyUBVT9zsbSZnbv+bTPqex4QiHp0msY/KwCDrxG+b80p460+DXCW4iZkkRABQd
	 ig0vrwxO18LuTf8sOlchT1cNDoROHHsJ437umRdf7a2VHJj6HCkdXNJEBFVGZ7LQxB8BC
	 4a3W53V3lK2uUHURMhSxCtYhkaiP5cra4jk9H/jYnlfd36m9GJ9cPqiJ+YYijLgbGKkCM
	 BaRPc3oG9i29rkq9FP9gL1WSK8jhu7NZTVVo4s6TEtCHIirNIteOfeWH1yCzZRV81iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ksG/82Eg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0100606A326;
	Thu, 12 Nov 2026 00:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ksG/82Eg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0DE1F00A06;
	Thu, 12 Nov 2026 00:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445019;
	bh=gWfHLyQLp5lkE6MADJry2BBpDAlp8gpq9Vu/5uioiTQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ksG/82Eg+NtrCQ2ecbJAFXm2bAnUiVLW3r5PnrrDzpkBWpVGa4uOLF+haukHLjK4g
	 C3SWqMiJJBzBtunphkiV50lmCd9m6nJgEm5qqYCXeeNPoxmSgvGCGi8bl9ZuqMIXwI
	 dRCW8I2xHYwT9zwJIlAbGZ84lBTcIke9Jn74LehBjnlEidYzF+pZ6SyinvJ+7iYZcs
	 hT15k4ipIElBxqsyLaEa8e0LPfegJmJf2pQ37fdVSF57+JWzI2SeUIa1UdRz+l1UQV
	 Sp/uZhG2iaMzo49LsH/I0sCZ2W3fSSXslwvMIvRl10h7NYJGNE+7JptkS/2fAAvj47
	 4A2QbKrKjP8ZQ==
Message-ID: <sashiko-outbox-210005@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 02/15] psp: take the psp nexthdr from the
 packet on encap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: bpf@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261111005533.6436-3-toddfreed@meta.com>
References: <20261111005533.6436-1-toddfreed@meta.com>
 <20261111005533.6436-3-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:56:59 +0000
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

commit 1d6df14f6316e027ee333bf0c262d7f9842ccd5c
Author: Todd Freed <toddfreed@meta.com>

psp: take the psp nexthdr from the packet on encap

This commit populates the PSP next header from the original IP header in
psp_dev_encapsulate() instead of hardcoding IPPROTO_TCP, rejects packets
that cannot be encapsulated (IPv6 extension headers, IPv4 fragments, and
already-encapsulated packets), and updates mlx5e_features_check() to fall
back to software GSO and checksumming for unsupported protocols.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en_main.c
> index c3c2c5720c6f3..d091de1a5992b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c

[ ... ]

> @@ -5140,6 +5157,22 @@ netdev_features_t mlx5e_features_check(struct sk_b=
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
Can clearing NETIF_F_CSUM_MASK and NETIF_F_GSO_MASK on an already
encapsulated GSO skb (skb->encapsulation =3D=3D 1) cause software tunnel GSO
to strip skb->encapsulation and bypass the check in psp_dev_encap_ok()?

For a PSP-offloaded GSO packet encapsulated in a tunnel such as GRE,
mlx5e_psp_l4_csum_ok() sees IPPROTO_GRE and clears NETIF_F_CSUM_MASK,
which also clears NETIF_F_GSO_MASK in harmonize_features().
validate_xmit_skb() then runs software tunnel GSO (gre_gso_segment()),
which completes the inner checksums in software, leaves seg->encapsulation
as 0, points seg->transport_header at the outer GRE header right after the
outer IP header, and for SKB_GSO_GRE_CSUM sets seg->ip_summed to
CHECKSUM_PARTIAL.

When those segments reach mlx5e_psp_handle_tx_skb() ->
psp_dev_encapsulate(), psp_dev_encap_ok() sees seg->encapsulation =3D=3D 0 =
and
network_len =3D=3D ip_hdrlen(seg), so it encapsulates the outer GRE packet
with nexthdr =3D IPPROTO_GRE instead of dropping it.  In the mlx5e TX path,
mlx5e_psp_set_swp() leaves eseg->swp_inner_l4_offset as 0 for IPPROTO_GRE
while mlx5e_psp_txwqe_build_eseg_csum() still sets
MLX5_ETH_WQE_L4_INNER_CSUM because seg->ip_summed =3D=3D CHECKSUM_PARTIAL,
producing corrupted frames or hardware TX descriptor syndromes.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111005533.6436=
-1-toddfreed@meta.com?part=3D2
