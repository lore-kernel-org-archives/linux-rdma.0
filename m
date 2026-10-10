Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F5078F3A
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 03:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791603146; cv=none; b=axjPYsauTn2mfHMABa8mtIDp/0T4O6Ur8ogWLIaCmti/AYZUOYDgZYUsV2faaAUSjMHVt5NdztO+pmaKtPZQc3ooDlyM/YQZon5r0DWwVSVZqHk66gXMo8phbTM7LgK2cpOanNZekLNb+Pn0/bC2GhIM85IBMiguYK9v6JOeTJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791603146; c=relaxed/simple;
	bh=UOTKI/QYO1GxD/5Aya7fgT0g7kAeLdc/Lp3Toj6J9+I=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Ks7CZgl8nnGLDCEHVe5O1g6x36Fft6gOphmTDaO0CKmOvJ4naZLETIL/zqYPtK8ifcW0kgSJ83ZuYCutnJbMxrn7lfYZJ5IjIHorwEMzQ/Ed/EjwlnQg0iaSmHo7CrV04wFJnf1Ndcr6EXhJ5on0IGtG15DVZtc+HpjubhpG/2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ec8Aqzq/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ec8Aqzq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3E41F00893;
	Sat, 10 Oct 2026 03:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791603144;
	bh=fgS8uh/PRnLCrIq1H+RA1/wW6yVKrKmZ6KoTFJaKhN0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ec8Aqzq/3gqzRHTgP/odpQGq8Vi49Z5ROZhleuLm3NXGwnX8GPSnlH1ZF/3hOKcHG
	 e29ey+79q/NjHBq0LtpTxMfT9nW12Pu54es943oPXvhAODfUMgvo3hdWenLGay20HP
	 psyNLXjd6KRH1cXaWqwP9aL3vhGXltLzCafhDwq/ohCRomcNJowQr6oFXlkJ+/oO6A
	 PbZyRAAW0ixo12o7ZUJB0pW5B/cTr+jOn5PZz0VWjrKvT9N+i6Gj2seUg/ZrcfSP0B
	 rYieBuzj/yMpdb9BMJsWinSNpg/3cMF19jfHveLGRHIMVaGz6zBKJE0JuNRV8NKoRC
	 4keVb5DO4eeiQ==
Message-ID: <sashiko-outbox-166248@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] net: mlx5e: Fix use-after-free of the MACsec
 xarray entry on RX SC deletion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Binbin Deng" <18983559317@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261010032115.93545-1-18983559317@163.com>
References: <20261010032115.93545-1-18983559317@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 03:32:24 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> In macsec_del_rxsc_ctx(), the RX secure channel is torn down with:
>=20
> 	list_del_rcu(&rx_sc->rx_sc_list_element);
> 	xa_erase(&macsec->sc_xarray, rx_sc->sc_xarray_element->fs_id);
> 	dst_release(&rx_sc->md_dst->dst);
> 	kfree(rx_sc->sc_xarray_element);
> 	kfree_rcu_mightsleep(rx_sc);
>=20
> The comment above the sequence claims that "xa_erase which uses rcu to
> sync" hides the RX SC from the data path, but this is not sufficient:
> the RCU protection of xarray covers only its internal nodes (making
> xa_load() safe against concurrent erase); it does not extend to the
> object pointed to by the entry value.  A reader that has already
> obtained the pointer from xa_load() is not covered by any grace period,
> and the bare kfree() releases the entry object immediately.
> [ ... ]
> confirmed by LLM-assisted (GLM-5.3) code inspection.  The issue was
> not observed at runtime; it is identified by code inspection only.
>=20
> Fixes: b7c9400cbc48 ("net/mlx5e: Implement MACsec Rx data path using MACs=
ec skb_metadata_dst")
> Signed-off-by: Binbin Deng <18983559317@163.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010032115.9354=
5-1-18983559317@163.com?part=3D1

