Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F9C431A51;
	Mon, 12 Oct 2026 08:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791792660; cv=none; b=D0+199AZ71TvY8e/vTV717lhtUmvdq0+24nCZ6MPh3qhgx3TnfaXBobBTQLm6TkhH5THvJIdTMOPiOvuIAWv+csr7Z2DdIwWQyVIwWtem9A9OHpsMnb0eBbpKpYWy2rXXE+EBKQbM69k6GCvzfzJgP9wpDMoTsq8JYSk5SUIljQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791792660; c=relaxed/simple;
	bh=f31osDknqZLMxyTuOZvRMawO3DAQaXXjcNZcGehmM4k=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=bJwnStAlQ1v7E4ODhHAfffrieVSK1mHngSdgZ7PpI5yZWYadR+5UFKEuAMtJW+Z18hJ2PHse109+SlbW0I+vM0z6HG2DjsrZn16hrag0nY8kozBniXcrTC3indaAvo2yuQzZ1mbUOQ+KQChll3yzjeSXjHYDinqVcWamhFcO88U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TFKiQuqi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TFKiQuqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F3F1F0089B;
	Mon, 12 Oct 2026 08:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791792658;
	bh=f31osDknqZLMxyTuOZvRMawO3DAQaXXjcNZcGehmM4k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TFKiQuqiXoUISJ6+SVb0wni171l2X6dSIME517d2sIXVbg1tPcNsVrj233XT0DcQy
	 8G+Ayi26NwU2HGTdeATWsx5yzYUDW+gRkvVF3b8VzTDGqp4fqfQqYnCBjEJGyP6Trx
	 iK6qDcV4GB3OWvtfFI4axSq7noi70NufeUPCdFRqppyj9cfl6I4nCYbjUNg/R50dWs
	 mk7bm1RYrlH29hIjWxBFXiarxRBY+xRVLAd28aEGVauYEKkk8qOQEzLnP5bYlSB70W
	 4zTGU+4FFG0kk4lnSaOL6gdt6ECBjUCLGFfRwhxv8pjr9falBDCzvhe55H/Q79+PGp
	 YNIu4VOAv4siQ==
Message-ID: <sashiko-outbox-167827@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v9] net/smc: fix lgr/lnk lifetime vs diag reader
 race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>
Cc: linux-rdma@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>
In-Reply-To: <20261012080034.38770-1-mjambigi@linux.ibm.com>
References: <20261012080034.38770-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 08:10:57 +0000
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
> lgr->is_smcd after the kfree. Guard the conn/lgr/lnk blocks in __smc_diag=
_dump()
> for SMC_INIT and SMC_CLOSED sockets. As a side effect the diag_mode field=
 is
> reported as SMC_DIAG_MODE_SMCR for SMC-D sockets still in SMC_INIT; smcss
> suppresses those rows before printing the mode string so there is no rend=
ered
> regression. Use smp_load_acquire() / smp_store_release() on sk_state to o=
rder
> these checks on weakly ordered CPUs.
>=20
> [ ... ]
> Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supporte=
d")
> Cc: stable@vger.kernel.org
> Reviewed-by: Hidayath Khan <hidayath@linux.ibm.com>
> Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012080034.3877=
0-1-mjambigi@linux.ibm.com?part=3D1

