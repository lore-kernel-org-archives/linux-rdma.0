Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D794F4030;
	Tue, 13 Oct 2026 14:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901649; cv=none; b=ZIiVAC6SBGL+70mqmkEQNCUaaf9bs1k6ZnHfGnifJD4rVXDmr4LVUqZc4gwgIlPsO0mS80VaB1QCwT8IQWESMYXjN6JcD7DDqvCPxaStCUoiGZnFRfbxJCsVmPS4SzsCYGkIRC5sPDjq3fK7b1O+NVdQFsHFZJiTq79RWmNv7U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901649; c=relaxed/simple;
	bh=7rd2uTWDIekUPYhyh5Hel9xCtohJCO1LTLpwWRmLO+Q=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ifXns66P0uQ5iXZdRhXyV1fHOaYe3Ufn+MU1Qz9t+YXr1kkuBfRBwGxMw2US4ciJ1iySaT+yX+xBUVYEYuQiSvvKgprMaG8RhWcZ1pMpc2JmouOfpI74YvtA4gPX2F8wt4yFssp7uhE7OMOLU0av2tYZTZiBSEtooU2cC8/54iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m+UK1fqP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m+UK1fqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945031F00893;
	Tue, 13 Oct 2026 14:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901648;
	bh=7rd2uTWDIekUPYhyh5Hel9xCtohJCO1LTLpwWRmLO+Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m+UK1fqP03tgT5asUJHcrbhUanDX9XyQ5gD9U/DH1mHIQqkt1QIcv0eNoiWXUTVGI
	 TvMBkACvawmr6j6UmVRfY3VniVeV6f5Np42DDbKDVDLtZkXWMcmgv5jmq+ZaSyrJXE
	 +9FMZCoSkYUMffsO5VoQwzR/v5Ot72YUCdMUBi48Rqzr3BZp8yz/ZHwAQKFSJz/CD5
	 yOAUVACMUUpQ1vqKlO7Xrpq/hIyJ8BUs8TcvkJ8Rza4i6GbuSAh1dXIubeWI/y2eAF
	 8SywBWoLFNpQ50qllnfD14qW4rbGV206BMI6Psp8lkWlI4tgVXAUVa+uRYpP+1N32r
	 4XIfN0Oaxh4XQ==
Message-ID: <sashiko-outbox-169904@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v10] net/smc: fix lgr/lnk lifetime vs diag reader
 race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013141510.2621698-1-mjambigi@linux.ibm.com>
References: <20261013141510.2621698-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 14:27:27 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The diag dump walks the socket hash table under a read_lock and dereferen=
ces
> conn->lgr and conn->lnk. Four paths expose a window where a hashed socket=
 has
> freed or partially freed conn/lgr/lnk state.
>=20
> First, smc_conn_abort() calls smc_conn_free() during early handshake abor=
ts
> while the socket is still hashed in SMC_INIT, synchronously freeing the l=
gr on
> the smc_lgr_cleanup_early() path without holding the hash write_lock. A
> concurrent diag reader can load a non-NULL conn->lgr and dereference
> lgr->is_smcd after the kfree. Skip the connection, link group and DMB att=
ributes
> in __smc_diag_dump() for sockets in SMC_INIT or SMC_CLOSED, and do not lo=
ok at
> conn->lgr to determine diag_mode in SMC_INIT.
>=20
> This changes the sock_diag output for such sockets. SMC_DIAG_CONNINFO,
> SMC_DIAG_LGRINFO and SMC_DIAG_DMBINFO are no longer reported while a sock=
et is
> in SMC_INIT or SMC_CLOSED, and diag_mode is SMC_DIAG_MODE_SMCR for a
> [ ... ]
> Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supporte=
d")
> Cc: stable@vger.kernel.org
> Reviewed-by: Hidayath Khan <hidayath@linux.ibm.com>
> Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013141510.2621=
698-1-mjambigi@linux.ibm.com?part=3D1

