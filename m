Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B42486640;
	Mon,  5 Oct 2026 13:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791206616; cv=none; b=C+rBHR975XL/Sw+5HfJoKZwjvHEzeoF+SMnF+kgB4L9FdFFfCLtLshAcarnNT8z099dOib4xeLwAzyvQkd+BLLibPxTdgfqc2BG7QTY+VwQMVn4x0TBr/92wbyPQUj45S6/ktt9mntb1mbb2zvTjjM3REB9KTxPzqp6SVN0qzuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791206616; c=relaxed/simple;
	bh=TYAB72t94W0qnEpUNtIL3wZa9xujdTauTwyHXFnzALI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qEWnqKK4INhm/KnAk9zK7HmNGMo/bsAbifIf3EHgSrttmQ6DBNzA5uxVa/vLepjsWL3aQSjhFnF09ZZls5HiFOq3ukggsdAfp0CXyunj6ztISYUjvOH5CeUsnnWhtEqlol0TlMG7KYI9e7Wnk0DtoAlliBJPahwSAGI4YwG6S/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IpQNzINi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IpQNzINi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B891F00898;
	Mon,  5 Oct 2026 13:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791206589;
	bh=TYAB72t94W0qnEpUNtIL3wZa9xujdTauTwyHXFnzALI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IpQNzINi1fOXov3yO9eARUudpJ+M7Of3mOs78XMF/lVA3kfi1Hd3XhAgcX7us35Q+
	 i5L7IUOLMPfatsys1cLnNUgjhjOdrvhWjWHwb14j8TnFTgiUoSKFsYg2SuTmpqP/oT
	 0lqvxgQTLrnwsujPzB0LSweVdCPR3wuzgz0uPSXlrZqOjqPmpFUu4MLZXKAlI95c9R
	 arE1v98nLOfpjQ6AkaNBTom4orXKAbaqoZS1JLw+xH/drgfDY228HUBhIyx0c6Vgt5
	 gchQD0rR/fMuDIhXtT3ZddWEa3E5sUe00D8Is4NG8IiCGa6DnZtdr9G1F18zFO3ed+
	 SnVspWdC5KFMQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v8] net/smc: fix lgr/lnk lifetime vs diag reader
 race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261005131241.1575131-1-mjambigi@linux.ibm.com>
References: <20261005131241.1575131-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Oct 2026 13:23:08 +0000
Message-Id: <20261005132309.63B891F00898@smtp.kernel.org>
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
> while the socket is still hashed in SMC_INIT, synchronously freeing the l=
gr on
> the smc_lgr_cleanup_early() path without holding the hash write_lock. A
> concurrent diag reader can load a non-NULL conn->lgr and dereference
> lgr->is_smcd after the kfree. Guard the conn/lgr/lnk blocks in __smc_diag=
_dump()
> for SMC_INIT and SMC_CLOSED sockets; smcss already suppresses these attri=
butes
> for closed/unconnected sockets so there is no observability regression. U=
se
> smp_load_acquire() / smp_store_release() on sk_state to prevent speculati=
ve load
> reordering on weakly ordered CPUs (e.g. ARM64) during fallback.
>=20
> Second, in smc_conn_kill() on SMC-D with dmb_nocopy, smcd_buf_detach() NU=
LLs and
> [ ... ]
> Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supporte=
d")
> Cc: stable@vger.kernel.org
> Reviewed-by: Hidayath Khan <hidayath@linux.ibm.com>
> Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261005131241.1575=
131-1-mjambigi@linux.ibm.com?part=3D1

