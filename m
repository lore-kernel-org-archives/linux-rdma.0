Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794443464;
	b=y2h/MsRpMdKhiZ5cbYXz3HgOivHv9JOCqTgym3CRxHi/dUrAEgR+eisak9sdT3aTLBuy
	 B8GYmQ5oNNyOWpdmipw6E8SYnQq6glt//MmeFRw2hy0TJbmGbYtgud78H6Qlm/OOkovaM
	 i6r4CT7RllzkQFSlqMCLdCplhkoIWu1zs3g5svWdyhz/7LDVcNUgi/T/KZP+vbM37cORp
	 CehFMT4JhLf2EdJ6FT6nyWJzqwMPdvDsz5+fFmsKwHtqy96sUI0AIRfm7fjvxOKYJMS8b
	 uKymoP7iNfScPaDCXYNeMizjI74O/R6dsNBvb/rolaxA+5XgXDIMvCqjFDPa1G9wXdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794443464;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JGAd0PbKavtrx83qBFoeLTTYy1wU+6Cbvb3A1x3Fkvc=;
	b=W+jwTv3L/12AspYgPAWqtdlczgFYfkZQvGxEmhZDjNBIvM+lczOgfzfjds3zSWS1+gTB
	 rSMx4a11zeDW+8/NgxHq9JM5TvAw9NOvRisd/B0voVZ0QUe0xchfvsGkI5DvOJ9YD/7Mc
	 hWxyRGF8Obpx9HiKVpPlrVzRWgCrijPIqfEPD9+cAqyhUdoYZjAkkcEooQceTGSbLM0Qj
	 kxZz+Q78nauIUEANdsYh6c/sGvw4A9De131Cg2zrVxiSGdKQK1mFSbUrW2t+VVorSrYqd
	 SFXTU+FcgI8R3PZ81+qD0ztIPuGWfENPVPyB8yVNua52XoL5lVE+71q5Aa2qCmP3y7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mguFv9Er;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FA7606A334
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 00:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mguFv9Er
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3581F00A05;
	Thu, 12 Nov 2026 00:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794443463;
	bh=JGAd0PbKavtrx83qBFoeLTTYy1wU+6Cbvb3A1x3Fkvc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mguFv9ErbKI8OOQSLFVoJ74nto83/MB6iKJeImI4EvFyuLGrnbYRpwvz6XhbX0T4e
	 1vFnGznFN17V/sjeMVvwpBSQM/Dj7lKZ2zdWOHkvyovg8xPeGGifiSch4myv9ob40O
	 tfgWs/3q+JrI0X25V0C+Lb3fGk/OIgbBNi93BINXJvhIZSku/MKxZwpvVholax7/LH
	 MRvtoqYgJEUUBBxHy1/Nr93qaQLs4tZx2k1xpyLxPjkQDrx7lDt+0dIBk4wWXd4OYm
	 twMZGN3W7MO6mKvDNH6rDU6dFcj9Ex5/YfWUUStr+E4QDilMD7Ikecc8R/NzXhOOEb
	 v4OAcnmf1XPKw==
Message-ID: <sashiko-outbox-209932@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v5 8/8] net/mlx5e: psp: tso: replace only the length
 in checksum seed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111001831.3710881-9-toddfreed@meta.com>
References: <20261111001831.3710881-1-toddfreed@meta.com>
 <20261111001831.3710881-9-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:31:03 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> for psp tcp with tso,
>=20
>  - __tcp_transmit_skb() -> tcp_v6_send_check() or tcp_v4_send_check()
>    computes the checksum seed using the addresses on the socket and the
>    total length, then
>=20
>  - mlx5e_psp_handle_tx_skb() recomputes the checksum seed using
>    addresses from the packet's l3 header, and the length of one segment
>=20
> the length difference is expected by the device. however, the difference
> in addresses is incorrect in cases where the l3 header daddr is an
> intermediate hop, for example,
>=20
>  - ipv4 source route option (IP_OPTIONS with lsrr or ssrr)
>  - ipv6 IPV6_RTHDR header (conceptually ; ipv6 extension headers are not
>    properly supported on this path yet)
>=20
> in these cases every segment of the tso packet to go out with a bad tcp
> checksum
>=20
> the fix is to replace only the length in the seed which tcp had already
> computed. this is also what tcp_gso_segment() does.
>=20
> tested on connectx-7, with a psp tcp socket whose ipv4 loose source
> route's first hop isn't the final destination, and the peer checking
> tcp checksums in software.
>=20
> Fixes: e5a1861a298e ("net/mlx5e: Implement PSP Tx data path")
> Acked-by: Daniel Zahka <daniel.zahka@gmail.com>
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111001831.3710=
881-1-toddfreed@meta.com?part=3D8

