Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795308493;
	b=hQHrRFwAGWasJehQgwIWltRfrGIq1FgTQdThUCpcyk+roAb+XmGruWXzwr0kzLReA4ml
	 cfShMen8zytV0szvs7lT3TUhxm/pKs9yhz8GKqkTu/vdWSO+dnCjHuX+2i9u6O6X/ThOS
	 kFu1L6ncMwYThOBmnbsG+6IxCd9AN2ZoSz3etRBjBu1GBB5QYB5ll/emhuBOh/F7roFMc
	 +kog9Dc1SdqVTjBz451iKtLr9kFZp4JTz8s3UZywWY7D52HZ35OuP0EkC/pMIOcY7O3Wt
	 YF5KX16PiQnIRG7T+9Bbwoa2mOePLHXIpGVyCTMA2R9p4KvSAaQr/pJr3h6M2TEjYRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795308493;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Zl+zsLRpXjZB2IWfwm5vvA6c4QUuyHGEpwAlEhECO3Y=;
	b=5B6W4eReSicEc8J3QP2kcA+54z4ittVIGubBXCBheFgKgen8nsPn1T3FOBkurK3dpHBU
	 easEDG3+c3EJLxSeKvx1Y4mQu9hEB7K1vXMrp8B213uN0qpGmGR+IW9e8oRqtBiVc8VTj
	 guuXJHWXlRSU1m6aoNkxIyNM2r6DJODdBIbrEuCB5swqDmuJZxtBEwZB8mP86936+OcAf
	 61W4QHyiDjYVLDVqa3sTNfAHTdE0ksnGqizvn4KKWOCu/wo/8Y22ewqjJH8gUOTrPUoUh
	 bYV6cIFcqJkhRF5AVsm5LFzsnly+0V9cxW1LhymB+3LhEQRQCUFApq1JogtZUu2E/qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="An9wo/z2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6112D606A320
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 00:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=An9wo/z2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CD01F000C4;
	Sun, 22 Nov 2026 00:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795308493;
	bh=Zl+zsLRpXjZB2IWfwm5vvA6c4QUuyHGEpwAlEhECO3Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=An9wo/z2VQGn0T0E3WnAhEC7wobEW4gCQ8EfHOlMqAoUzqM+ag+CIlHk4bznvcxJ/
	 2Qb8ZpamIj4QLueBU42TSKvmpzOY4QRTejGhd+ce2f7pNKzs42R6nyevFoIOU8nBIQ
	 D2MGUVIkcpRQCLKJ61BE5VQ5+bKhFo94yDu5VTlrRKirFOQFzmfpPJl1vV+wFBtwLD
	 H+uZua2x/ENfMyEuIR/octaB5JFhPZensWSzrwm9c1SYaswC07Uv4On7lfNqYTdvwf
	 DnK83DG1pRMnkxHErDBuFVNtG7OLrWCZKj9gaU39RlMBk4lAfNJLugf7lZPAlRiK8t
	 ZcWMStu/Jb9PA==
Message-ID: <sashiko-outbox-227578@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/rxe: Fix the copy offsets in
 __rxe_odp_mr_copy()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Stellman" <astellman@stellman-greene.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261122003712.91551-1-astellman@stellman-greene.com>
References: <20261122003712.91551-1-astellman@stellman-greene.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 00:48:12 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> __rxe_odp_mr_copy() maps each page it copies and copies to or from the
> start of that page. It uses the offset of iova in the first page only
> to size the first copy, not to find where in the page to copy, and it
> does not advance addr after each page, so each page is copied between
> the start of that page and the start of addr.
>=20
> Tested as root on rxe loopback (path MTU 1024), three runs, with an
> ODP MR registered 100 bytes into a page:
>=20
> - In a 4096-byte RDMA READ or SEND from the start of the MR, the first
>   16 bytes of each of the first three 1024-byte packets were the same
>   as the first 16 bytes of the page, not the data at their offset in
>   the MR.
> - A 32-byte RDMA WRITE to the start of the MR changed 32 of the 100
>   bytes between the start of the page and the MR, which are outside
> [ ... ]
> reviewed by me.
>=20
> Fixes: 2fae67ab63db ("RDMA/rxe: Add support for Send/Recv/Write/Read with=
 ODP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122003712.9155=
1-1-astellman@stellman-greene.com?part=3D1
