Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792641257;
	b=ysc9pol088CRH5hzE0Q05rIXcqyBfBl8HKlqyxuzKkEAINVuJv1P4OQVztCu5gghdzxL
	 4aZ/dplFG9FfUzTl5KxW0aMYHSHr0Woxffio2tasydHzg91W9WsGd2+N2YIZelP30E6TW
	 Oz2mw6JR30CKI4dv/FUh4DqWxKpix6uQzhHxEdZS/FZbSbNHCRLzZlVHuePGoptO5MCDK
	 X0ZhiuHPfDO+0I6vYD2VFQoNOoda2xSDpuIvz4j9S8CV6mDJgHUkO7t7wRHvQYyMLFkuV
	 DNu57KxxIqaJ1PsWIdKL469oL43vKd4b9ZJbtGMwHiKni08de/t6GX/dgqrZwLQY4iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792641257;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=B4uExw/zE5ZcFN2DSN98CrixIJD2y0y1e6TuKcKJPkg=;
	b=4v8jzVkI90/QV5c2hosLP4NlQ+Y2UAa+oaOK3SHf3bBzkPV0NEA9svMBVK2U1vNC0Oil
	 /wDjSFCEXJrajIJ66JJgGUx6fTFpm5XUEaU1p0Zt9kIAXMOmoCfbPw9Jg/yHjKl8PB9AR
	 T4h3dXJMJGJKPobEzUTFGP1KdpaHGwejOujQER4w7uKE2rvWl+enzd2eOpLEcSzvk260d
	 UXmVK7qChlnsicnxNElEbhVRFvgcu9SaESW7wQrv1CNq+ZLsP4zFBoWy1V2gfAqApZRXd
	 ZaKiCBBxHM8n1XwIpoAFXERaKh7yL6DIQyuEY3Uk/q/F720PSBGOHRtzoE0iCGYlC+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nO9MdmUy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3913606A31A
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 03:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nO9MdmUy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F151F000C1;
	Thu, 22 Oct 2026 03:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792641256;
	bh=B4uExw/zE5ZcFN2DSN98CrixIJD2y0y1e6TuKcKJPkg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nO9MdmUyCj9gDR27DHkGopelUtyfRsHYW239VACb5xNSv9TiP57UAZKS6RiWLI0Sh
	 ziSLswDwAJtvkuy/DLDrxB6nDduJYjl1EfDVDh7Hf/QZPym7uD3tCMOlk3RJ9cAwW6
	 kgs9cDHCvssEk2AP5xgJFJ/gnZi4DuCyWIJxnVaRp7b0ogQjXYPfkrDUTmbeij+cI3
	 XEsboUq1VxcQOz2sNCc27XZsG2291nqniTNxeMyZxt41EWgmj09jMJWASxWrdurHQS
	 7EW9VqZi0r0AxrA7GsqEeUAMGe9RL//CzHrJOsFJS3fGkn88VmI73he214zuiAK2fy
	 6VagZFAO+78IQ==
Message-ID: <sashiko-outbox-180982@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] svcrdma: silently discard undersized messages
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hyunsol Mun" <muumthf@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261022034629.430954-1-muumthf@gmail.com>
References: <20261022034629.430954-1-muumthf@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:54:15 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> RFC 8166 requires an RPC-over-RDMA message shorter than the 28-byte
> minimum header to be silently discarded because its XID cannot be
> trusted.
>=20
> svc_rdma_xdr_decode_req() instead returns -EINVAL when the fixed header
> cannot be decoded. svc_rdma_recvfrom() turns that into an RDMA_ERROR,
> whose encoder copies the first two words from rc_recv_buf without
> checking rc_byte_len. A zero- to seven-byte SEND can therefore return
> up to eight bytes that were not supplied by the peer.
>=20
> Check the complete minimum header length before parsing and use the
> decoder's existing silent-drop return for undersized input. This keeps
> the error encoder from reading beyond the received message and follows
> the protocol requirement.
>=20
> [ ... ]
>=20
> Fixes: f3ea53fb3bc3 ("svcrdma: Use correct XID in error replies")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Hyunsol Mun <muumthf@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022034629.4309=
54-1-muumthf@gmail.com?part=3D1

