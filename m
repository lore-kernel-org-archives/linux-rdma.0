Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424802;
	b=miPdA+H4kdWnm1Wm6yZUrSA3THcl28m+lI4nyRbt7t4VsYl6IJb+XbJwerkb84MmZ2P6
	 jCVcI5LeQBw3PvPyzqTT7ulOPrWY414EgUVjZezl55jVnyJYIdTY1rR/CAwZmeSxvq7KS
	 hMTFt4INWENMQtiW31svSlvl4xaBjCPOQET29vsaj/EZrA+8GLDWFA4Y7fltVNDqPszE/
	 TnBlaGObDg2ucqP95lt1oigE+0dsLuaNQ1btR9D4m/XVbRfSxFNSJwpL3F6o+Nk1YP0dA
	 jNzCiSy24RoOykCZX7ALecQd/bM8JPjAjupBtAMEDzNyE4fbuB1HH8su/objRbCxn8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424802;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HiowjyzPj0k5SFvkD5EEydxWi/FJaYSnnQkB/C596CU=;
	b=ODwQSRSSafMLfTsnsX/sXrubHmYIVAXnW3Pa2G7TPfJl+tFMytBmrcnzIK6cwxjYJZMC
	 tX7NDJ1zVVsRvrm8Ou9xIW/Hu+zZ+r8q9KhCRT7dP+gRkpDDwAChATjAPWeYrxze8ucV2
	 Qe+23zDdx03DV6EWDfkLpQgpW5gwB7WI/W/bO8wVknwf4uVmmRdp+tto2BzE4dA63UTg6
	 5uaLOW9g3kJw3lG6/YyImA6YjuYTs/G2mpUX7lIQIIzssdmi8/qbGXHq3lYZ0zFMhEGIi
	 bJC9pFAVDh/O/tp8M7kZvL35VutCFUT1okJhRFku4ciiiG8I4w7NwRyD0hepAgYZI9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YjD9OPQE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEC6606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 09:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YjD9OPQE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2B31F000C4;
	Mon, 23 Nov 2026 09:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795424801;
	bh=HiowjyzPj0k5SFvkD5EEydxWi/FJaYSnnQkB/C596CU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YjD9OPQEx98FrlVO/CHhfHy0LynrLkV7hfR66VWPl4NaMcNhh4cq3XZ+oPBZ2lsTw
	 hsCSo8ZZTR7gmI/z+Ajyth5pDuiAuIMuwYyvEPqrU5XKOieFWwmmrpOGoNf5AzQNJV
	 w2le1JvHq3S9gtSX9aOX8lJhzlfl6mRHHWDadWipECuFkZ2tElD4TzwxpFIJepG3Lf
	 8iPRF96Mgc5yS+BCZ+IVTmsgRimVeL4zvcW8D69VZPMt+UbSEhcB6zwlfc4sM3naVI
	 JTh+Ko+4LmsHSAZoCfOli3SysvH6S7EmeLIAjuttVm5hXfjelNl1aUVpNsZYBs5Gd5
	 8uTWSfD710Eew==
Message-ID: <sashiko-outbox-228934@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2] net/mlx5e: TX, Do not open a multi-packet
 WQE for a single packet
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xuanqiang Luo" <xuanqiang.luo@linux.dev>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261123090200.1284018-1-xuanqiang.luo@linux.dev>
References: <20261123090200.1284018-1-xuanqiang.luo@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 09:06:41 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
>=20
> A multi-packet WQE (MPWQE, added by commit 5af75c747e2a ("net/mlx5e:
> Enhanced TX MPWQE for SKBs")) lets several packets share one WQE, so the
> control and Ethernet segments are fetched by the device once per batch
> instead of once per packet. This saves PCIe bandwidth and CPU cycles, but
> only if the WQE carries more than one packet.
>=20
> With skb_tx_mpwqe enabled, which is the default, mlx5e_xmit() sends every
> skb accepted by mlx5e_tx_skb_supports_mpwqe() through an MPWQE session.
> A session stays open between two calls only while the stack sets
> xmit_more. A packet without xmit_more closes the session and rings the
> doorbell. Hence a packet that comes without xmit_more while no session is
> open opens a session just for itself and closes it right away. Such a WQE
> takes one WQEBB, as a regular WQE does for the same packet, and the
> [ ... ]
> than a single packet MPWQE does (mlx5e_sq_calc_wqe_attr(),
> mlx5e_accel_tx_finish()): the instructions per byte of UDP_STREAM 65507
> go up by 0.3-0.4%, which the gains above outweigh.
>=20
> Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123090200.1284=
018-1-xuanqiang.luo@linux.dev?part=3D1
