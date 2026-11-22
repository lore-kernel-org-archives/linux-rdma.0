Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795367811;
	b=DdcmL++WerQ8lv0mGWCgofk2vWDXNtpSAVG1Ifq9wfPNKRTdesB5vzo10335sVzwfBWM
	 VNrwjMKD6b35QwAhIkiVPISptQUqqNGzKNFtMQjH9FM8pAHB589Fo7UNO5TuADda5G1wS
	 mcEIi1McqIt+xdVZcVi/ci++Ig1CkBZMNtc+g7yJxJqvvR45mq3FSMwWCCj3z3/CB0JUd
	 ewC++quatEsD+JLsUg5fYjpHu657aHNDyo4sfof19TRW7MvMkfIVOT1AsGwapusjNjglA
	 Crc6vSyUFTNaPJY7NuIP+eO6il9a2RM2hd+ooVqQ/N9Wwl0qOnC2hkwYPngW/EZoDNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795367811;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8gB+WgW1XOvxGp8TJoNG0a951LpDJwcUtxx3kjYRwuE=;
	b=tBSIgAjM6eEdO3Ij8kVz/AKWF5NHZtN3W6wGLlcZDA8LjgjoQ1xwXQlpMdNIApTCXVDN
	 u/E11y+d0sErUywRaUG6rx744ofbPfhFxJIHlO9izM0g5j21qIVC1+k3sG4KxiM1DpG6W
	 wu+phCuVppSdGk+Uw8CqNQhQlPt+TzW2Hx5yvkET40uAblVtjnuxzz1U0S8hBHaBGslY5
	 BI7JW/BtOOeWYy0gZHqvcWJHztcIN5XmeRqQLaoxP+vjxybhBzL8miWkLA06OdtZ7x81v
	 2PC2ghw2L+9rRuXJ3zYVGAMk116x8fgXEqGonahpGmp7DBTgsFjkL+ZuqG+6km3sDMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ES0N2qgt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE009606A335
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 17:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ES0N2qgt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECB31F01568;
	Sun, 22 Nov 2026 17:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795367811;
	bh=8gB+WgW1XOvxGp8TJoNG0a951LpDJwcUtxx3kjYRwuE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ES0N2qgtqStWyfTOC1mq2irTocnMyjw8KuDumTHJAR61ogEblIsOBOxqzdY7+uQdn
	 FcDvk/00l2g47YTBh38iYIxF9di3Jd0x8w0xQ36igl7YIwMQpINhs+h3KpT4ax9YHR
	 gwf1YzxlRBKAJggNH1jGfKsCT3XCLMMR0y43LcAQxeqenJm7wy2W6MLuZUvNiskura
	 xV3coK1ouTNybXiALejdEqPyBYanxvE+Bn1A/XPYIlKuHvu16wLI7Dp71cMtRnxWC1
	 TEwK80RQccNxcZXSoK1ILUhoa/Lc4MXKAvpUffvIRjiNL4keXfHNovNV+2vXpJphl5
	 skTaLGnwLt4KQ==
Message-ID: <sashiko-outbox-228130@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2] RDMA/rxe: Require a responder resource for
 FLUSH
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Stellman" <astellman@stellman-greene.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261122170551.19582-1-astellman@stellman-greene.com>
References: <20261122170551.19582-1-astellman@stellman-greene.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 17:16:51 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> process_flush() keeps its state in a responder resource from
> rxe_prepare_res(), as READ and ATOMIC requests do. check_resource()
> refuses those requests when max_dest_rd_atomic is 0, but it does not
> check FLUSH. With max_dest_rd_atomic 0, qp->resp.resources is
> ZERO_SIZE_PTR, and rxe_prepare_res() writes through it in
> free_rd_atomic_resource().
>=20
> A FLUSH sent to an RC QP with max_dest_rd_atomic 0 oopses the
> responder:
>=20
>   Oops: general protection fault, probably for non-canonical address 0xdf=
fffc0000000002: 0000 [#1] SMP KASAN NOPTI
>   KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
>   CPU: 0 UID: 0 PID: 13 Comm: kworker/u8:0 Not tainted 7.4.0-rc3-gaebb727=
44764 #1 PREEMPT(lazy)
>   Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1=
996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>   Workqueue: rxe_wq do_work
> [ ... ]
> The fix and this changelog were drafted with Claude Opus 5.5 and
> reviewed by me.
>=20
> Fixes: ea1bb00ee9a5 ("RDMA/rxe: Implement flush execution in responder si=
de")
> Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122170551.1958=
2-1-astellman@stellman-greene.com?part=3D1
