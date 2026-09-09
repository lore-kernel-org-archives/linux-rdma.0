Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C583D8900;
	Wed,  9 Sep 2026 09:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788945798; cv=none; b=M87yGd5Q1SSuTjiJuJnTiKt4xzMg+374uUDBaNV59HTbxVyyecSiLgS/sv6zU+IiB/BoAMl+cQBzExnbaLr9Te+7YRgOVXi5DzXwNcNWeUivANlctxIrUQMMtHx93zh2+2QzId7kzd199uflEy/chTXFOVXecKrUXNlTe70VmW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788945798; c=relaxed/simple;
	bh=iaOKxw/5t4Qa45VN3o6Di3xNnFDEsLMTvF0O9gZmedA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=t8UyixnA0M+h3KCVpWp7bc+ehgBKPnl15QbezmfD4WAlL39BF9krjHmWNZI2MhCthzRjmksLXPpg2wk/ItrFhg5zSoG4uTg0A6sY5nBQW67oMXpahLJ25Bsl2MVI3j33Ab2xJycAL0oMJ6HSvMD7uH3Dlw4R8siiBYVwDfewINs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lr31+R+o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lr31+R+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CC41F00A3A;
	Wed,  9 Sep 2026 09:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788945795;
	bh=sM9dFZWHv89yerjpZwp4SFRolEwk1RLEm+pJq+itXrU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Lr31+R+o/7rEOm/ov7IVRtCpd6V1+1XOqfgd3rFLp9f+IHoq0hFGgU1Kp2GJLEbdE
	 4orTQuuGBn5cTKFXAasJggD3SUqPQ7/J+C1UbY1DiPu8mvyZrVT74S670yC97qRre3
	 8YHAEnPQ/9O+dlmJIG5Jm7yuzIDmsa0FsvPSEEi1dGIMO7p5+2osGOxMIRmk0/1sX0
	 QOPmvCZPzdiZoJd7KCI5yOWlKIiyW8K5qZSC1HE/DJbwU+Q3oxRE4w40u4sD9YEDcU
	 BJP9QdSbvAixOpTZ0hbZpP3cUjmdyVJrFFIek0x912sgfkgNAxWZuJk+inZn1GLGD3
	 0GkTSUfUAURCA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v3] net/smc: fix lgr/lnk lifetime vs diag reader
 race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-rdma@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260908092252.3832975-1-mjambigi@linux.ibm.com>
References: <20260908092252.3832975-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 09:23:15 +0000
Message-Id: <20260909092315.64CC41F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] Premature unhashing of SMC sockets breaks netlink diagnostics fo=
r fallback and aborted connections.

Pre-existing issues:
- [High] Concurrent link failover clears link memory while diagnostic reade=
r accesses it, causing a NULL pointer dereference.
--

commit c0cbdd828a851e80ad0c79e6d2ccf5b0b5d7e16e
Author: Mahanta Jambigi <mjambigi@linux.ibm.com>

    net/smc: fix lgr/lnk lifetime vs diag reader race

This commit aims to resolve a race condition between the SMC diagnostic dump
reader and connection teardown. It introduces a mechanism to ensure sockets
are unhashed before their link group and link references are released in
smc_conn_free(), preventing the diagnostic reader from accessing freed
structures.

>     The diag path therefore reduces to:
>       hold hash read_lock -> read conn->lgr -> if non-NULL, dereference -=
> done
>     with no new lock, no extra reference count, and no trylock.

[Severity: High]
This isn't a bug introduced by this patch, but does this approach still lea=
ve
the link memory vulnerable to concurrent clearance during a link failover?

When __smc_diag_dump() in net/smc/smc_diag.c iterates over the hash table, =
it
extracts link =3D smc->conn.lnk. Concurrently, a link failure could trigger
smcr_link_down() -> smc_switch_conns() -> smc_switch_link_and_count().

The link is swapped and the old link's reference is dropped locklessly with
respect to the dump:

net/smc/smc_core.c:smc_switch_link_and_count() {
    ...
    smcr_link_put(conn->lnk);
    conn->lnk =3D to_lnk;
    ...
}

Next, smcr_link_down() calls smcr_link_clear(). When the reference count hi=
ts
zero, __smcr_link_clear() zeroes out the link memory:

net/smc/smc_core.c:__smcr_link_clear() {
    ...
    memset(lnk, 0, sizeof(struct smc_link));
    ...
}

The diagnostic reader then evaluates link->smcibdev->ibdev->name. Since the
link was zeroed, link->smcibdev is NULL, leading to a fatal dereference.
Can the diagnostic reader safely dereference link->smcibdev without holding
any connection-level lock that protects the link from concurrent clearance?

> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index e9f93b3ab435b..8c781a4a4485b 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -310,7 +310,15 @@ static int __smc_release(struct smc_sock *smc)
[ ... ]
> -	sk->sk_prot->unhash(sk);
> +	/* Fallback sockets never call smc_conn_free(), so unhash directly.
> +	 * Non-fallback sockets use smc_conn_unhash() so that the conn->unhashed
> +	 * flag keeps the unhash exactly once even when smc_conn_free() already=
 ran
> +	 * first (e.g. via smc_conn_kill()).
> +	 */

[Severity: Medium]
Is the assumption that fallback sockets never call smc_conn_free() accurate?

If a late fallback occurs, it invokes smc_conn_abort(), which calls
smc_conn_free() before switching to TCP fallback:

net/smc/af_smc.c:smc_listen_decline() {
    ...
    smc_conn_abort(new_smc, local_first);
    if (reason_code < 0 ||
        smc_switch_to_fallback(new_smc, reason_code)) {
    ...
}

Does this mean fallback sockets can traverse the smc_conn_free() path?

> +	if (smc->use_fallback)
> +		sk->sk_prot->unhash(sk);
> +	else
> +		smc_conn_unhash(&smc->conn);
> =20
[ ... ]
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 04aedd957543a..e302221c35e3f 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1263,6 +1277,11 @@ void smc_conn_free(struct smc_connection *conn)
>  		return;
> =20
>  	conn->freed =3D 1;
> +	/* Unhash before dropping lgr/lnk refs so the diag reader, which
> +	 * iterates under the socket hash read_lock, cannot see a connection wh=
ose
> +	 * lgr or lnk is being freed concurrently.
> +	 */
> +	smc_conn_unhash(conn);

[Severity: Medium]
Will this prematurely unhash SMC sockets during connection aborts and late
fallback transitions?

Since smc_conn_free() is called by smc_conn_abort(), and late fallback calls
smc_conn_abort() (e.g., smc_listen_decline() -> smc_conn_abort() ->
smc_conn_free()), the socket is removed from the SMC hash table despite
remaining an active, functioning fallback socket.

Could this hide fallback and aborted sockets from diagnostic monitoring too=
ls
that rely on the hash table (using SMC_DIAG_MODE_FALLBACK_TCP), breaking
observability for these sockets?

>  	if (!smc_conn_lgr_valid(conn))
>  		/* Connection has already unregistered from
>  		 * link group.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908092252.3832=
975-1-mjambigi@linux.ibm.com?part=3D1
