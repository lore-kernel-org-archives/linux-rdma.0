Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B6239B96A;
	Sat, 26 Sep 2026 07:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790406106; cv=none; b=N5z74stK3Vt8AmzWnGO2LyLafm8rEEAOEjk8HdCjO0x8PoDT+DRdznuINd01Vx9dIzYr8RuqIvE+1ZzsXmNfwnYeGKDGuj/IQmtNc3aO1Hd/apOUWoTJK4S4FAfcBAwEV9UHNnPuZJ0dY3S34c2v/KbhKz1p/A4Sc1nCaVgvxTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790406106; c=relaxed/simple;
	bh=Kd8FmktDoZF0fQVAKjw3C1cpvzfP/gJS3nTrDlcZhJI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kFNDsIizYV5wAJNg0ohgPRYIzY5WfTOcPqPM3SO8Tzxpb+smpZXXPE6T1kCA/Xtij2QPGTv2gZ1k8Z3Kmk1hlOmWHHt1r7YBCzcgOAPZ/Zq6T72kwQ1Kf4oFZCszuNHHrtK91yJb0byrA/cM+pT2tu/y04SAG7sqwhZEkVOtlN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QM3KUcjt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QM3KUcjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696541F000FF;
	Sat, 26 Sep 2026 07:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790406104;
	bh=Kd8FmktDoZF0fQVAKjw3C1cpvzfP/gJS3nTrDlcZhJI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QM3KUcjtkCx//QN7ZDxYtuKqkdPj8CsGxdYb3G4w/Zq9Gl5rq0MUGASFAsB1mzGDM
	 xkwIz4gTndjjpzosbGTv5cRO1PK8lHh+1Ezx2Gnyz0CSiT+8dwhSc7cu0Bq+Tow3tJ
	 P5AfZVfplA5AS9pq0pUWsZsbnXcqZxcvUi7YKYRHGojLbWXQCJljIjQTPrIpMfQnlN
	 7jYJrni+1h95UZXh7ZXUME8qQ0pJ9TdNKUs/DqnZva8Ml/OajDInyEdC9CiBoYZXjY
	 OhBDTep3hBp1kqOr0fi777NkDnfzMTM2C27q031FQoQ05i+ejdzZRc+13nIHSZyG1z
	 qxhAc3pVJ+Lvg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v6] net/smc: fix lgr/lnk lifetime vs diag reader
 race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260926065023.1629497-1-mjambigi@linux.ibm.com>
References: <20260926065023.1629497-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 26 Sep 2026 07:01:43 +0000
Message-Id: <20260926070144.696541F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The diag dump walks the socket hash table under a read_lock and dereferen=
ces
> conn->lgr and conn->lnk. Three paths expose a window where a hashed socke=
t has
> freed or partially freed conn/lgr/lnk state.
>=20
> First, smc_conn_abort() calls smc_conn_free() during early handshake abor=
ts
> while the socket is still hashed in SMC_INIT. On the smc_lgr_cleanup_earl=
y()
> path this frees the lgr synchronously without holding the hash write_lock=
. A
> concurrent diag reader can therefore load a non-NULL conn->lgr and then
> dereference lgr->is_smcd after the kfree. Guard the conn->lgr->is_smcd lo=
ad in
> __smc_diag_dump() by skipping it when the socket is in SMC_INIT state.
>=20
> Second, in smc_conn_kill() on SMC-D with dmb_nocopy, smcd_buf_detach() NU=
LLs and
> frees conn->sndbuf_desc before the socket is unhashed. A concurrent diag =
reader
> entering the CONNINFO block can dereference the freed descriptor. Unhash =
the
> socket at the top of smc_conn_kill(), before smcd_buf_detach().
>=20
> Third, in the terminal teardown branches of smc_close_active_abort()
> (PEERCLOSEWAIT and PROCESSABORT groups) and in smc_close_passive_work(),
> smc_conn_free() drops lgr and lnk references while the socket is still ha=
shed.
> Unhash immediately before each smc_conn_free() call at those two sites.
>=20
> Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
> Fixes: 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R c=
onnections")
> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260926065023.1629=
497-1-mjambigi@linux.ibm.com?part=3D1

