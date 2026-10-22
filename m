Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792653780;
	b=gAkt4p8i5uAyrqGy7jtEzfM8yZsB8PW9pwSkhqACnTKU4YAKWqSqwn8Ve/Ifi2M5Ne2f
	 wBh2MnmvN7wp178Wu4Ban09tyQ30jXVcZQItEmnLM4xINrm6My59viVlKdJx/pvzwhTDs
	 ztQanYQ9do9hVrs2uDI2ch2Qs+fAWhvQ2z6eulH2sN2b3sVzF4aWLmXedNSbdUQ9uVaww
	 0L/Jw6N8t5+YW8N5uEdoPludo7jUZr3RbuZQDVOowCz4z5AW5vfsKqhKMDS5cvM6ei+ed
	 BtadXecBr44sSd5/55i5+UJSXNzmhlOxWghjAfzQMNY1kcQNZN3OichBUqbDJgEgMXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792653780;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=PW5neJ7JMxScbtg4OaowkQDxwAtD/GfPxcBg2b3OZkA=;
	b=Q66nkAulzJrZrOWcLRqcOShGacWAoM2PA+JtkE0o5uj4CCJAFY80AANQllBx3uAMnE+Q
	 AUJdj6UwPBqwuQ+sZ98RvwA3kkh6KVwCAHH9nWJHK0n+7p9d7EcLMl+s1SOPBNcRP8aAj
	 ZkimRiLlH7+RHrAyc20/IqDUikInbAoShLUIQav6560JXU2zFcZIaffRe4ciI1u1nLKG4
	 Acax6b8NnnrQStQ/lfP1z9+848KvQ3JiRRvkJC16nXANDLxR5Hsxt2LyPxzaOOWaJF/7T
	 9ra235BRI39/UmMwQZOSWcGfXy0YO+l6MUdPBBvXVdTiJzfCLyDz0UrUcLfutT8vWBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GYYXx3FH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161AF606A31B;
	Thu, 22 Oct 2026 07:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GYYXx3FH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597601F000C1;
	Thu, 22 Oct 2026 07:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792653779;
	bh=PW5neJ7JMxScbtg4OaowkQDxwAtD/GfPxcBg2b3OZkA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GYYXx3FHcklShDfkx6667nxK913Fg6GQf7tja4PqlZNxuYe6SRNnuiPl/w5URpHqw
	 lUxLIXF1EBVypfo3J8lZCHZPXuvPwyiua4s+6rKyV2Viz/ASGQPNrGJiKT1sJOai0U
	 CLBWPX3G5NTzOKGmd5Ca5tGQQ/zc73REa3xNt7t0o4JhOmD2vUOIzKw4uZ5ZcmjTkA
	 OvHlB0kxUcJRygcoaqtTV8Tz2yNklyMajNG8LW+hJuhHJPqs7TZy5ySoyNT/fs+4mE
	 8X0WOq7aMBlG3c4jFGa7z2JrIulEbHzMU/hcFiQLY6Tzp1jCCV7+q6KbRj9hgZaBEF
	 SOy9MssAuf77g==
Date: Thu, 22 Oct 2026 09:22:54 +0200
From: Joel Granados <joel.granados@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com, 
	edumazet@google.com, kuba@kernel.org, horms@kernel.org, oleg@redhat.com
Subject: Re: [PATCH net 1/2] net/rds: do not fail init when CONFIG_SYSCTL=n
Message-ID: <atm5EFVaz2USohS_@hobbes>
References: <20261021195837.142802-1-achender@kernel.org>
 <20261021195837.142802-2-achender@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lgjygsa544j27wnn"
Content-Disposition: inline
In-Reply-To: <20261021195837.142802-2-achender@kernel.org>


--lgjygsa544j27wnn
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH net 1/2] net/rds: do not fail init when CONFIG_SYSCTL=n
MIME-Version: 1.0

On Wed, Oct 21, 2026 at 12:58:36PM -0700, Allison Henderson wrote:
> With CONFIG_SYSCTL=3Dn, register_net_sysctl() and register_net_sysctl_sz()
> are inline stubs that return NULL.  rds_sysctl_init(),
> rds_ib_sysctl_init() and rds_tcp_init_net() all treat that NULL as
> -ENOMEM, so RDS refuses to initialize at all even though every tunable
> has a sane compiled-in default.
>=20
> When RDS is built in, that is worse than a missing feature: the failed
> rds_init() destroys rds_wq, but the rds_rdma initcall still runs, and
> when rds_ib_sysctl_init() fails the same way, the error path in
> rds_ib_init() flushes the already freed workqueue:
>=20
>   BUG: KASAN: slab-use-after-free in touch_wq_lockdep_map
>   ...
>    __flush_workqueue
>    rds_ib_init
>    rds_rdma_init
>   ...
>   Allocated by task 1:
>    alloc_workqueue_noprof
>    rds_threads_init
>    rds_init
>   ...
>   Freed by task 0:
>    kfree
>    rcu_do_batch
>=20
> Only treat the NULL return as a failure when sysctl support is actually
> compiled in.  The exit paths need no change: unregister_net_sysctl_table()
> is an empty stub with CONFIG_SYSCTL=3Dn and already tolerates a NULL head=
er
> otherwise.
>=20
> The underlying problem of built-in transports initializing after
> rds_init() has failed is independent of sysctl and is addressed
> separately.
>=20
> Reported-by: kernel test robot <yi1.lai@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202610190310.9737b2e3-lkp@intel.com
> Fixes: 3e5048495c85 ("RDS: sysctls")
> Fixes: e6babe4cc4ce ("RDS/IB: Stats and sysctls")
> Fixes: c6a58ffed536 ("RDS: TCP: Add sysctl tunables for sndbuf/rcvbuf on =
rds-tcp socket")
> Suggested-by: Joel Granados <joel.granados@kernel.org>
> Assisted-by: LLM
> Signed-off-by: Allison Henderson <achender@kernel.org>
> ---
>  net/rds/ib_sysctl.c | 2 +-
>  net/rds/sysctl.c    | 2 +-
>  net/rds/tcp.c       | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/rds/ib_sysctl.c b/net/rds/ib_sysctl.c
> index 2af678e71e3c..bc97a3eecad6 100644
> --- a/net/rds/ib_sysctl.c
> +++ b/net/rds/ib_sysctl.c
> @@ -114,7 +114,7 @@ void rds_ib_sysctl_exit(void)
>  int rds_ib_sysctl_init(void)
>  {
>  	rds_ib_sysctl_hdr =3D register_net_sysctl(&init_net, "net/rds/ib", rds_=
ib_sysctl_table);
> -	if (!rds_ib_sysctl_hdr)
> +	if (!rds_ib_sysctl_hdr && IS_ENABLED(CONFIG_SYSCTL))
>  		return -ENOMEM;
>  	return 0;
>  }
> diff --git a/net/rds/sysctl.c b/net/rds/sysctl.c
> index 025f518a4349..968d6279bbd3 100644
> --- a/net/rds/sysctl.c
> +++ b/net/rds/sysctl.c
> @@ -103,7 +103,7 @@ int rds_sysctl_init(void)
> =20
>  	rds_sysctl_reg_table =3D
>  		register_net_sysctl(&init_net, "net/rds", rds_sysctl_rds_table);
> -	if (!rds_sysctl_reg_table)
> +	if (!rds_sysctl_reg_table && IS_ENABLED(CONFIG_SYSCTL))
>  		return -ENOMEM;
>  	return 0;
>  }
> diff --git a/net/rds/tcp.c b/net/rds/tcp.c
> index 774a71f88d37..34815b4f658b 100644
> --- a/net/rds/tcp.c
> +++ b/net/rds/tcp.c
> @@ -637,7 +637,7 @@ static __net_init int rds_tcp_init_net(struct net *ne=
t)
>  	tbl[RDS_TCP_RCVBUF].data =3D &rtn->rcvbuf_size;
>  	rtn->rds_tcp_sysctl =3D register_net_sysctl_sz(net, "net/rds/tcp", tbl,
>  						     ARRAY_SIZE(rds_tcp_sysctl_table));
> -	if (!rtn->rds_tcp_sysctl) {
> +	if (!rtn->rds_tcp_sysctl && IS_ENABLED(CONFIG_SYSCTL)) {
>  		pr_warn("could not register sysctl\n");
>  		err =3D -ENOMEM;
>  		goto fail;
> --=20
> 2.50.1
>=20

This LGTM

Reviewed-by: Joel Granados <joel.granados@kernel.org>

--lgjygsa544j27wnn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmrZucYACgkQupfNUreW
QU9mdgv/Zv1clsJ61kjW2j5pVJXo8dLSowVRYq9YSV7mjHRR/Hf1krRQvxnJaRXC
Nhranb4rDeMd1+D5AXvzk1a3fM9YQbuXgnQ10hMFxZp9IrkI4l7ThcaRh12kAp0G
dIaj4C19p6Lmrn0KXmklxN3Ik5Nk8ATdS7p+X+EmkXAwUy+zUd+gxa5lwI7cKbsh
/fCwdUjsqPJz0mCaSYAIFUccAsSviZsFjj00ysf/mQ9HQbm0Hl1zys5GBp1OsyVG
Okr5pracCX4YN1wwjkGMDf5BARfkpvzPkx36Gx/rfAGL1XkQI0IF1V85Ov4nGGmc
HPsT6AkGPZgdIEEA+NltLQ42dvDQ5uHm0jGh71g0qqhxFVNYQ3vzgDOOogH9VZhH
w6jOuqUbazMFOMRhRPrWPYcmQzJ0vnjUnv6vELeT7HGZM3bJ8+f3OqP+kSaDHNUe
/S9reU1gVPYSwj3Acb1pBzTzRHsLcMcFd+HI5seh/aiQErJU/WUNLJy7eNDvpfl7
H3dG+eHf
=GTvb
-----END PGP SIGNATURE-----

--lgjygsa544j27wnn--
