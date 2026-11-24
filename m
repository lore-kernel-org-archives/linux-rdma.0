Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795559334;
	b=CroKbg/OLak6MW0a6h4YvKiexUfbos5r9gjbF6htTEfceNQ8haLX0kkdWznOcRJGbTFa
	 MYwnm6AZl7zrtNlIgAFFVAURcUswDU4VIy2EBxvUu4Z/z7TQAg+jYsMFLTY64bdhs6cIL
	 bVl/cK6jJJVJ3CljN7Tut2Hjw6krVRvUI7JyI8J8uadSKzFcBjSjAMxXesCEdPWu0jJrd
	 fJaZHu6VdaPlgOPQL1WYV4xKuspTg3K63IZySLYfxF+3X24oySVa1v64VjFfAuydhuPS2
	 OT1fjfbKu1XeDhjVxJNohFyLG+ui+BLQPIOPPmweSsBD9Df4yDgenqQYuSPRaWcdw9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795559334;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YzbuVuA79UjODe1t29r8mPwlpccTHuBHgF/hCDt9QMI=;
	b=APM7pgxGW1T9C5XWyZTcfyK7PkB2J6IBtRm0KbXlfvEwXWAmoocRJod7x9kxThC+7uUr
	 TXLsNUl0a0kOBD9cFhMODOfEzPL0D3UVuX2HC+bl6V94PKpBF655kLkuq+dkun8cxpL0W
	 OQUPDmWdj+39FF1Ac4Zd6rEUPg7/6eAaLSupaw+JXzqtLC2myRnVPDe57xOwKfgA2vLHn
	 8ap8ahSndg5xsQGNaVA+cSND1hOVOOKjNeJlgnYh31wKKl4AP4kXFY1XOlWalfyoHXL2G
	 BKcka/8w7z4c+vOP+irJbmEoiyvIKNJXeaeASRKZJY7ePv0Cy9nGtzkxFgcPXvVYgHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mMl27csB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89027606A321
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 22:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mMl27csB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC36B1F000C6;
	Tue, 24 Nov 2026 22:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795559334;
	bh=YzbuVuA79UjODe1t29r8mPwlpccTHuBHgF/hCDt9QMI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mMl27csBoGcLyIah5cBFsAYoDnSvUddKaGtBVI70amVzfme/lHQtDr2E5mZG63PP/
	 uSLaLwcmd4iSrS5E4t840lmOKYVdRUsLTuvtXM8+UWeE4QjmUMa23h52G/QzLzLF5m
	 wYm1tA0fT6nWkdzBoTe3hRMFAOx5baZy1bkD/H0KOtKfDLpJabm+XSqYKcrjYhcYJd
	 31HlAjpt2aEzL3pFQqTS7GZUrEKEzBhQU+FjIsohSTXsQkWL5BvWsKY2ZTnCp1yqTu
	 yBNgjbaMqJdfc06vMCRGUckcJjiOyIiZHmhpXzBZ/DvSULIk7JqQXlTjzfEz4X2vPF
	 XOoK/LVZ9njLA==
Message-ID: <sashiko-outbox-232132@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3] net: mlx5: Allow police as the last action
 of a TC rule
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mohsin Bashir" <mohsin.bashr@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261124220251.776944-1-mohsin.bashr@gmail.com>
References: <20261124220251.776944-1-mohsin.bashr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 22:28:53 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Mohsin Bashir <hmohsin@meta.com>
>=20
> In switchdev mode, mlx5 does not offload a rule where police is the last
> action, although TC needs no other action for such a rule. The upcoming
> selftest series relies on these rules. With nothing after police, the
> police result alone decides where the packet goes, so each result must
> be offloaded as TC executes it. The driver does not do that today. An ok
> result is handled as pipe and runs the actions after police, a pipe
> result always returns to the post action table, and a jump is counted
> from police while TC counts it from the start of the action list. A rate
> police is also rejected by verify_attr_actions(), as its forward to the
> post meter table is added only after the check.
>=20
> Make the offloaded rule behave as it does in TC. An ok result ends
> processing in TC. A pipe result does the same when police is the last
> [ ... ]
>     action police rate 100mbit burst 1m conform-exceed drop / jump 2 \
>     action drop action ok
>=20
> Cc: Carolina Jubran <cjubran@nvidia.com>
> Signed-off-by: Mohsin Bashir <hmohsin@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124220251.7769=
44-1-mohsin.bashr@gmail.com?part=3D1
