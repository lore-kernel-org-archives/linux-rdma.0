Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795875245;
	b=utAZmPqe8xY5m5+vSMWB9MVlhzQyVx3Oqh3fZFvE8OflKWkd0cfkLeC57S4z1FKRXWEV
	 OKmRuAXZgbMbv32BNIsmbsmfR4RHKsIW1vdc8CCS2V3wG/F1Wg8LeGNhSB/qO2eOKBH9r
	 pAmpnMqYijfvR5+le/L2m8e7BszMdHBbD3o7DyUmAI4mlwKJachABPyk7Kds+L1P1xNTH
	 zsrcagOVWrTFoN/WVmIRzM5okOu5Sj7ARbp4bQS/taXafX/GpEO4GgAXbrJ/uv1tXDNv2
	 YcoGNDBl6mGRbxbsZQB7yyo/9Jm29i0uZVQvNvTl6AdxVIGv7NB7CFAdU1WkRGYf51g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795875245;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Y4WQtqFynSy6qbQFn5zVY7vadJZg239UsDg+Gfmidy0=;
	b=5WyRgvJ5UD5c7XI8Idb2WUn00XWX7XXsQMVoHGxbBuZewhXPgWibxlCHoOLB2kZPr+QQ
	 n39Ry7cQZVKFqsLjfpwhJwlIAfBMp/KlxfurW3WU7CrBPl40dccj4R7pPwgJ+w5UUUGaT
	 4Yvr/xPiVXBsINBnY7gDYz8/zi9/yO8476MIHr4lBCToYhBbYcF9gkjtsDwncM8af4AbF
	 oX273xxBmswQrj3L7bSN19kg0a/sMCjnA77tLgmaFNI5wC+wUgNykKahDCC8r2OKdbUPY
	 K5u4vC7D+gbdiglGNjfmsMGX47n0Ee88mg2HpDIT6V/0cWrs8KO1YUisgPs5Jt7OSTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FzBkaobm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454E6606A321
	for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 14:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FzBkaobm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34091F000C1;
	Sat, 28 Nov 2026 14:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795875244;
	bh=Y4WQtqFynSy6qbQFn5zVY7vadJZg239UsDg+Gfmidy0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FzBkaobmPFKTELnbYrg9bdSa0JRUmr6yDnoGAAUko0sXeLw6u/9ubhkwjfifB6EPR
	 YbODD+EliqU1gTcDL/KzUx5DDqxYYw2UngVsSWrhMSxGLnYn4u3oh5niNWF6pqqBK7
	 I+g9zMAtPuh4p0XC2a3dHpf0qdJ6EYsKT7o5kIm/me2bw1WchqdgH44u6LdKWpT+Ou
	 HFQxPSl4bwhW8H0VO6rX3pDt1nVpzZ6QMaOkl/hIrA5eM1U174+0cx+Ad9XS3T/eX8
	 JC5Vy6XuKKFkLeNWj4U9i+XNOeJUUIfNXMEGUfCk4mvRpXE2UOV4a6U6e5JAc5uBVG
	 l/iS5skikb4pA==
Message-ID: <sashiko-outbox-238763@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/rxe: Bound MR copy and flush chunks to MR
 pages
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Stellman" <bugs@stellman-greene.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261128140840.59003-1-bugs@stellman-greene.com>
References: <20261128140840.59003-1-bugs@stellman-greene.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 28 Nov 2026 14:14:04 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Andrew Stellman <astellman@stellman-greene.com>
>=20
> A fast-reg MR can use 4 KiB pages on a 64 KiB-page kernel, with each
> MR page in its own page_info entry. rxe_mr_copy_xarray() limits each
> chunk to the end of the system page, not the end of the MR page, so a
> copy that crosses an MR-page boundary continues in the same system
> page instead of moving to the next page_info entry.
> rxe_mr_flush_pmem_iova() has the same bound.
>=20
> Limit each chunk to the end of the MR page when MR pages are smaller
> than PAGE_SIZE. For MR pages of PAGE_SIZE or larger the bound is
> unchanged.
>=20
> On arm64 with 64 KiB pages (QEMU TCG, mainline 7cd8495c0f16), a
> test-only hook built an MR by hand with two 4 KiB pages at offsets
> [ ... ]
> The fix was drafted with OpenAI GPT-6 (Codex) and this changelog with
> Claude Opus 5.5, and both were reviewed by me.
>=20
> Fixes: 12985e5915a0 ("RDMA/rxe: Fix iova-to-va conversion for MR page siz=
es !=3D PAGE_SIZE")
> Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261128140840.5900=
3-1-bugs@stellman-greene.com?part=3D1
