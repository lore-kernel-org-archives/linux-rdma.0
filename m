Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C6A3A874C;
	Wed, 30 Sep 2026 07:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754411; cv=none; b=rkz4pkvfs3VkVtTy2DjhfsebcPkByvk+Qw2XVQukatCrSuddEuRw8YyJVX+mogFrGjnqgpIRRUoEPYRDinuo0sQ9n2qL47GMwg5Xb1/Slvfk5oaTbSlWU2pK5ppkwoLB/M/OfDvxK+638lECWxrJBUph0b0hNB/8MRlvF3OIPDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754411; c=relaxed/simple;
	bh=ELkK23LN+zu2hGb2dMJ4KsbNkjaGX7pdkVOpw2NwU5E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CW+qY256MSABwvu7Zf+1D4HKn8kNB5N9xQets/H8gMBrRna/JcjDZRJucetiazOYwDqPH03znMPEbyUfUpOUgkc78vbW42us/Pq/S2cWbuh3idbYSirr5l8SXv5Rdb+dMcL2iEHS0/u+WP/SOH1xjnBMP6cX0gOzyRH1oHHYoWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UyQaeCFm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UyQaeCFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DFB1F0089C;
	Wed, 30 Sep 2026 07:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790754410;
	bh=ELkK23LN+zu2hGb2dMJ4KsbNkjaGX7pdkVOpw2NwU5E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UyQaeCFmngjZOFEWGw25Hp5ZVNZw16+Wqo4ihsUyTD3YgmIu2LgyKx6iTcVzQ5WsT
	 gx2T0KPgFBJo96VNnjoVtWWGfOw28afnSFdtKiVYMdVqSvNdWwzrWkas6RD++v//f3
	 ZoMgoUhosDjlkHPh8tvuJtNuYbIUjqen7C8gThZY6pzZFWPdCruo9tcchcdPYFkrME
	 QWKAn8ObrB2G9e+LhpOi53+3ZJUcjyaNGsP6OY6yLLYYgugnxfcXDSw+U5lXT2idXe
	 b6WlnfilaZUInVCN5n80drgMRQn8E2QoCnYOtTesOzYK7JxWrokRjimuTxaCviNEcL
	 8vRK3CNqKyfiQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v7] net/smc: fix lgr/lnk lifetime vs diag reader
 race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20260930073029.1201202-1-mjambigi@linux.ibm.com>
References: <20260930073029.1201202-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 07:46:49 +0000
Message-Id: <20260930074649.D3DFB1F0089C@smtp.kernel.org>
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
> concurrent diag reader can therefore load a non-NULL conn->lgr and derefe=
rence
> lgr->is_smcd after the kfree. Guard the conn->lgr->is_smcd load in
> __smc_diag_dump() by skipping it when the socket is in SMC_INIT state. Th=
e same
> guard also skips the CONNINFO/LGRINFO/DMBINFO blocks for SMC_CLOSED socke=
ts,
> which may briefly remain hashed after smc_conn_free() when the fd is stil=
l open;
> smcss already suppresses those attributes for closed sockets, so there is=
 no
> observability regression.
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
> Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supporte=
d")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930073029.1201=
202-1-mjambigi@linux.ibm.com?part=3D1

