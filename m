Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793637301;
	b=VvydpwvLy4ou5504V6DROtttVrukzr+qRyWa++Y12ocM8wUU0iCdKirWwlboGUbfpkWx
	 hxe0BVkc5r5y+LyX1wr2hqLFF5fGUT7ioA5ncdbPGm1Ljcgdaz4Wjnc3I++gcDsyHyn/i
	 8r8vK52B5wg94BWExyjOsv8l5RN8jkWqg+HVcCsru2oNOagWRJf2SuxKvYzdGiuembKmC
	 lYOfcfaKdBX4Ax0UAEViFq7UEvPa/ULROoUF8uReZ9rMyd/rQKBCkStQ5ewBqeS515xWQ
	 PytJIfWzYLc9jD8k048NpGyo5/hcrqrlf4LOrWIfmZAMmqSWUffuTjbfpaIvccPOsTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793637301;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6BC+kLMUIBP23NtLyTExnL7eJ2Q/+ClNENpkvXXG9Io=;
	b=Vydmypk5fhDVkyR+ex/p3qUIWB0dl2vxpj3DBCinoNiS8bKeYVzBiC3ko668BGek115t
	 /S4uChghWq/vUHqHjJAfRWUwDqagj4/TENF9ZBrsfJVQJmB7E5g49fZpYEJaxyHKKXi3G
	 1qPfBp7BehRXvAyo3cmGN8rRhPkFL2MLrCKiob3dto7dkXTWY7GHvWALTbB1/l0J+D4dV
	 HBGfvLB9GQMUMJJ20BynpHX8Dg8Ut/Rw73Z3xLTU7RIouKM66HIMaMD2jJdzSLe8X0CmO
	 SysXgCN+hFSecaf538nO+0PMk6RC8h71nYTqfw/2F6q4RWGf+EawqkU36sH4UBZw3BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JXiBXySd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95A5608B060
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 16:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JXiBXySd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DED31F00A18;
	Mon,  2 Nov 2026 16:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793637300;
	bh=6BC+kLMUIBP23NtLyTExnL7eJ2Q/+ClNENpkvXXG9Io=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JXiBXySdk09d0o9mhTarYYrSuBtKbfcPGrDQVDaTXsgEX6e04MGlo+r47eMUnj5uh
	 j9xvY/QQkzanLmX031b2vTXiGv6RDmYLQpRLD8uPD1XYyi8O2hpHCxTa3droG+VTVL
	 hL0wC45v0z0icbEaF6ah6Z5q2fK8PSUI3DxTW55QUn+hQz8O90V/+Kq9w/6ZNSW6G/
	 Gb8vhoR2918Edpamtir1LVPEwRwTObd/ew8WdEsSUPdaYfNQ0jBhOBSdgN89i2Re3d
	 rbk36fYvyj4+sJngx8NAOIkSC+ag8JY0r8vC538crHxkuoPRhQbF2DBiHwEFPY8eUD
	 u2phGGofrZMgg==
Message-ID: <sashiko-outbox-193756@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v7 5/9] RDMA/mana_ib: Post receive WRs on
 kernel RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102162505.501853-6-kotaranov@linux.microsoft.com>
References: <20261102162505.501853-1-kotaranov@linux.microsoft.com>
 <20261102162505.501853-6-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 16:34:59 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement receive request posting for RC QPs. When posting a batch of
> WRs, ring the doorbell periodically to prevent the u8 counter from
> overflowing.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102162505.5018=
53-1-kotaranov@linux.microsoft.com?part=3D5

