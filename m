Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27953450909;
	Sat,  3 Oct 2026 18:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791053102; cv=none; b=CSWcKTPSqHqOyr97aOIsqM+FvKUVLOjUsvYMTH7tfnK4ko21smEe/yjGLbzEo5UEtA3/iZprXQxXHojsjwAhbIWAZdd7omlw235gH79PTtarz1GJnvGEWPMwqnrswdl43AdBbsX62Zj1rqKsyWzGwa0MvavCeUJZ1KV1zTO6rZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791053102; c=relaxed/simple;
	bh=4lZprY+N2Vx5HSdP4VZXXzOZGZ+ENxL3AWkB+/hJ4WE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UQbkmjYQIexjJYIVY1j2TBbqLyPwHZ8eLmgHhcKlYe6ddect7n8kyQxbT99awLzJ16p8qjnvoRrY1LCmKlhEn5KTIJtR7ESaqqfV0dWmnc0jJCM1yVvLDjYVQqPMQYOwbrCw3Z5V0dfgkPaUQyXs+YuajWiu8nw3o+7JcqC65wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iaDpZKH5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iaDpZKH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C271F0089C;
	Sat,  3 Oct 2026 18:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791053098;
	bh=UhhfkcUSQ4H6VjvUaxO50v45WxmOlboYrXz9kC/TEHc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iaDpZKH5sGRH6i83yP0KN0HPpr1c68OfcTJQzkG3OIGgCH+cOZX6TiRxQWS5d7AXI
	 fDO8iYaPOyLq7jarBnj0oXG4eZuZHDWmjGzdujIul93QnImzdFU6UD2baF+4ZsS9u9
	 aIIphfGDSgt3sz91brjDOmYPkWIAge/MaxfYRpjvcgVA9Sqx1xB1PxTKeUEISUOC28
	 ZQmEpgGOccsvORefPkrnoQ1WWXltk6EkfbvoDLvc3WR+9Km5FiglJ2a2x4GEHMNxQS
	 HmQ/qzF49qqgHSPdC2javMwnNYyj+n7LS2Gp+aYKtvoKP0H6mMxvbH63F92+W1GTXO
	 TgY4csxJoZs+Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2 2/2] net/smc: serialize early link group cleanup
 with termination
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chengfeng Ye" <nicoyip.dev@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261003183237.2284245-3-nicoyip.dev@gmail.com>
References: <20261003183237.2284245-1-nicoyip.dev@gmail.com>
 <20261003183237.2284245-3-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 18:44:56 +0000
Message-Id: <20261003184457.46C271F0089C@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003183237.2284=
245-1-nicoyip.dev@gmail.com?part=3D2

