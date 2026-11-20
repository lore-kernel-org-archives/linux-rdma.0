Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795183891;
	b=y+LbKQ9+7fMZ17xpRdLJGVi8qA4jcEWSNyiC6aEHRpXabArCjKUiqsRBw8TvSWe0rECu
	 pnItl/t4UMVi3loN8we2GYJTBzFDR8DG5tnQz8IogS78zJDIF7lWpMFTu68moQTqO2bPx
	 GvIVMLjGrewyQhioDElQp4sScjLfV2+T+FPhplK2vjzg0p89Vu6NdR0dVmeht042z+fp+
	 jEUtrZCaZkV1y0Obmj0dg39bwvjmLUOJ2ZplwufxJ7hnRJB0lijgcnUxqmR8AmcZGblko
	 ZBNMwKX7QUWUwcztTlbgLQHLPSGGPm4Qmuig6/lWSiX/LfhKi57IfkVjJKKxgZ2WbsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795183891;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0UAZ28iHSNnNclVnxK24LlVi1tJxd0JPAlcsWLI0jRY=;
	b=SkJB4zhLnajCM50MgI75oA+p6h+0XhS0og0x3XOEbAHj/cN6BRKVCCup0sF0mC/SvjiQ
	 Ay5QfSzSKz75MbAMXWYXDsUgNZUmWk0FCp5V3k48SIpvD/tFBwMfm+BDd213QYv462KAk
	 yeY9lU4a0CMSGbk8OyHfSmZ2nNaNS9V29y9g3OXkhO2WXraJDoL9vMjTFUegohaR30rdy
	 YeY485QPhnSCBrUVg/eloKGSYD5tFTQ3ZCtLR93q73HoPRTQaZglVvk/qEzdu3MP8amhh
	 nrKxB7NHq5tZb2PADH6nKqVOpp4vQ+Tgth6dh36EftJCG1t7BApDzNMwre0pMKqQmdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hQTWSMYl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A528606A325
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 14:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hQTWSMYl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5731F000D4;
	Fri, 20 Nov 2026 14:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795183890;
	bh=0UAZ28iHSNnNclVnxK24LlVi1tJxd0JPAlcsWLI0jRY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hQTWSMYldpkOGVe+XMFxEJWr2tGPETMDlZ6jSTPd6mIP92mDzhs7sa10AEsA36/st
	 O2zvDK//ZShjP77OP2jRFXkZ41gRJLZ1gclulkUHR1YO5lsJyPGS4u+QvTQaR71uMr
	 ffJpE90OH3UZVGYeMZdws0qNsHk40VlI9Qa7Q6EToE+TFzkA8Xtif06/wgUIemi1o1
	 n77ta+kIL5OO0qiduW3GmDJ1Apwmb1QGy/J/kQ9dGdmuAcOHJ1lnvJ7kDSG352Xjmp
	 nEznR3D0xQGYuCQ4oHlEzuReBeH2JIYavDDITvgCFLs7JIatAmh5/m3lhjU4SddcIM
	 3Bfe+cPOyNFTw==
Message-ID: <sashiko-outbox-225335@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc v2] RDMA/siw: Reject opcodes a user send queue
 may not use
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Stellman" <astellman@stellman-greene.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261120140605.62810-1-astellman@stellman-greene.com>
References: <20261120140605.62810-1-astellman@stellman-greene.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 14:11:30 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> A user QP's send queue is mapped into the process, and
> siw_activate_tx_from_sq() only checks that an SQE's opcode is below
> SIW_NUM_OPCODES. siw-abi.h marks SIW_OP_INVAL_STAG and SIW_OP_REG_MR as
> valid for in-kernel clients only, but a user process can still post
> them. For SIW_OP_REG_MR, siw_fastreg_mr() then uses the user supplied
> base_mr value as a kernel pointer to a struct ib_mr.
>=20
> The uverbs device is mode 0666, so once an administrator has created a
> siw device any local user can trigger this. With an unmapped base_mr,
> as an unprivileged user under KASAN:
>=20
>   Oops: general protection fault, probably for non-canonical address 0xe0=
00042828282002: 0000 [#1] SMP KASAN NOPTI
>   KASAN: probably user-memory-access in range [0x0000414141410010-0x00004=
14141410017]
>   CPU: 1 UID: 65534 PID: 116 Comm: siw003 Not tainted 7.4.0-rc3-gaebb7274=
4764 #16 PREEMPT(lazy)
>   Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1=
996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [ ... ]
> The fix and this changelog were drafted with the same tool and reviewed
> by me.
>=20
> Fixes: f29dd55b0236 ("rdma/siw: queue pair methods")
> Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120140605.6281=
0-1-astellman@stellman-greene.com?part=3D1

