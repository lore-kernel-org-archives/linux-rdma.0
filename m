Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794948582;
	b=aIXTdVS9ooO0IlHdUT/JXFdw7/7GzQzA2kEdWPuYZntI0snbWyRAAIVKl5XMSTyFzzbC
	 qwAv7RUqmmSPLZywyvZULkkY96vIni35z05nVdKwTOqfZya05F64D7s1MZc9M2Px3GyyW
	 yaaDYdyXDvcidvF+4inC57oYFxsSwq2+v0BJwxt0He8eJpTRLiBBS60/RZh+4m0vk6JDp
	 HqTtoBFHhFAnpPHXeds5lLa4MqHs5C1aB8oLq8qDX14sZG05mlBJEbnohSCwoKVBRr1K5
	 At+ijfwo40nzGxFKIUmvlEd3iI2s/T2oGafYjXXzZlyoFCBTgcSU0tlPNTm3ZldqKvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794948582;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0/a9X4mGoVyC/aBxEcElCljXaZ0KFrExLvz144jU6jI=;
	b=qVyasETMVIwrA0OhhS+rPfQTJQD8m/LyIohrQY8FV53ACu6snKkrLrXvilPV9TtQYRpe
	 /vzBh6bC8XYIAUx/jGKsM+aZLa99Sux1nZzUJZZVGzWLmQtUli7nZqmQXHENJBvtPLCLz
	 dV/tS1qldePXhx2pDpnurOOSYGZckThi35+PQGNFjS8xduzpLWFowlsqnYiR6d4r7U60w
	 2x6nhYKhHeDWGrS3T2DU6oMF71SCvDU1J+uN9BhA4GqkE2EmWR04+ghyx56ot8Dgq8qyA
	 m2GF3esF/0LL+/9moP+NXl7VZ12IibGGWOA4qQY3r7nHMYBhm+qksiA/CyFtbYQaOgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JWiLcIea;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789DF606A332
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 20:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JWiLcIea
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3583F1F000C5;
	Tue, 17 Nov 2026 20:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794948582;
	bh=0/a9X4mGoVyC/aBxEcElCljXaZ0KFrExLvz144jU6jI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JWiLcIeaNWOtcTfPDIfnBs8+zVZBoJSjvx6Ek4LTI0rfIYxe8h0ZEzr+8FSxZU6Tz
	 s0jqxcy2dc8MXJgW2WnDkv3xzQJK694gzWN1CnTYtoVfyST6VryBGCR6bV/jfYkyoi
	 PhqFkIeek//vXk7Bhvk2GmPn9TNgcQ6U7P0lUQ3TzNX6PBe/wqRBIoK6m2shLq+rLv
	 AfeAjzbJO0MBUtREaylGETB+JShlfJ2ufsltCPJJEqibGDwB0yXXi1oJNzVwExBfUW
	 hchbaOffHrk7YHkTYl0Cr5U+CzkqQjTWr9BuRvC08f4ElDnzo5CzJBWn0QJMu+taCf
	 MpIxzLx+zie4w==
Message-ID: <sashiko-outbox-219655@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v6 8/8] net/mlx5e: psp: tso: replace only the length
 in checksum seed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117203137.804424-9-toddfreed@meta.com>
References: <20261117203137.804424-1-toddfreed@meta.com>
 <20261117203137.804424-9-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 20:49:41 +0000
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
> [ ... ]
>=20
> Fixes: e5a1861a298e ("net/mlx5e: Implement PSP Tx data path")
> Acked-by: Daniel Zahka <daniel.zahka@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117203137.8044=
24-1-toddfreed@meta.com?part=3D8

