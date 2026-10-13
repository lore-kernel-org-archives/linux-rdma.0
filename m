Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C563FF1B4;
	Tue, 13 Oct 2026 09:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885112; cv=none; b=HJiiIDRtG71u8p3e3pMyzckf+3b2L2X8ARzgD2izin7iD0iAxp3cd/Gwk/Y2N88jL1fLn1JDI0qQy0DS7kQjSz0wxyUcUZa0w9jJS+JR8GaKIodqVYexLf36W0TvbrMtm0v+JAv+68/zAQg0URv+n1xVs90nc879+YuX0PsqaKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885112; c=relaxed/simple;
	bh=SKVQskqj6oMp6Nonkog3AJffxOCCayj0gdg2q9dJBdY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=tNzJ7TfNf4Lk2H0Y9r+VPvxe2b9iEDRqVJXqvzwNPLjKFPh9u/pPmHJn4qfW2bYD+iqcWEaGajzBBxtuLeS4ulCT6pyZOO4RsuKdu56ay0MV3FelP3qFLOjZV5zw+4H+vKmncuWzcdv5jNIfQYoRQFDBY9x5/cMAQ8XuPIB7vW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PQyuJC5a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PQyuJC5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1FB1F00899;
	Tue, 13 Oct 2026 09:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791885110;
	bh=DOxIm8w8e7liRZ5owy2yv9IiuKyh0JXZ+bctBv0N6jY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PQyuJC5aWFLZ/6iX5Tnlrs9TchIwI/MVk++q605Zy613OzH+BkDQqRFQBzBn2NTRB
	 WR2ZX20k0xLPNyWC7yzHN21MNF7oqh0R4h/DcZk7vCB0yTx/Sl8B5Rj1FoJLlvPe5i
	 O8P5f56S0J/TIWGIRojh+vL77NN2jccMdEMRZTr5CYDePq6c4ksdEtJwFac7lsz7pg
	 lWyFqCFF4HqGA+BjgZxfDwNqv6Cw5ovMorCgeahA5KjjdTR5cc/yTNJ3fAvjtEWzDr
	 EwW7SpawL9D5sgAYu07YBc+ecdfen/coNJp5A7Qgi47fhOnePKe0wAuNupXs+cas5s
	 gbDyzt+utBK1Q==
Message-ID: <sashiko-outbox-169392@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v3 2/3] net/smc: serialize early link group cleanup
 with termination
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chengfeng Ye" <nicoyip.dev@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013091716.1210420-3-nicoyip.dev@gmail.com>
References: <20261013091716.1210420-1-nicoyip.dev@gmail.com>
 <20261013091716.1210420-3-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 09:51:50 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> smc_lgr_cleanup_early() enters __smc_lgr_terminate() even when another
> teardown path has already claimed lgr->freeing. Both callers can observe
> lgr->terminating clear before either sets it, then tear down the same
> link group, causing use-after-free and duplicate resource release.
>=20
>   BUG: KASAN: use-after-free in __smc_lgr_terminate+0x393/0x3a0
>   Write of size 1 at addr ffff8880bf2c0300 by task poc/106
>   Call Trace:
>    __smc_lgr_terminate+0x393/0x3a0
>    __smc_connect+0x2e3d/0x4930
>    smc_connect+0x42c/0x580
>    __sys_connect+0xfc/0x130
>    __x64_sys_connect+0x6d/0xb0
>=20
> Check freeing under the link group list lock before unlinking the group
> [ ... ]
>=20
> Fixes: f9aab6f2ce57 ("net/smc: immediate freeing in smc_lgr_cleanup_early=
()")
> Cc: stable@vger.kernel.org
> Assisted-by: GPT-6.1-Sol
> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013091716.1210=
420-1-nicoyip.dev@gmail.com?part=3D2

