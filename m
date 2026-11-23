Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795445532;
	b=PpPWKs+G5oPb6DZlU1w8AkRMlD+4ILi+HPUTRbWNCitUFAcC/EBu0FEKnpzIXvT6SwCY
	 lH9QsxvdMmEmPrTqeTj2OYXCum2g8WAmQgRMAnTrdpaFwYqC0djgjH/oH167GD5Ev1nD1
	 PCEi4/QERh8peHz82dP97itKh+6TeDfGEPkdPYt6ByJPUx79eQXszffSw4kelLTPg4ezy
	 hzn09cqRusouIiX9ezB7YkeGVsmC5oS++Jx42cUAZ0n7CPiYcfhKnFqe7QYDbpROiHQLj
	 ZUQDuIhMgZANA/yaZS2A1tZRwpc9kG1Z/yLZyqLMmenj/USEtKoxz4Oss2Go1kIbfow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795445532;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5qqNJMd6VbYnixx3z0Z0ClF7j1KojBVaxzh+Jz8wsfA=;
	b=LzgpUVL9sVcz7kz8lQeGULWXhvMXxfuSxtcQ28kUxYWp59XLGKAU9S11gHTGQA7j6KiQ
	 E4IvMXwTEUz/276Ozs22y8s6jreiD3eplhODT7xjdq0oTKZYwl8xR6qRptweEQScjMMdZ
	 CBarjvnMPuuIBl12bUdIvwlK8rH/jk1ODWFCQNt9Is8WKMiqbTJ2e37krERFhJkPzY40j
	 rCd/XKrZ80JfHnjQHtLELIkHoc1sebrYkNcKO1v1aOD9VRyPVr9rNFCGAYX1Dy0scQzwj
	 52X7O5WBmtMywaa6BPnFrbrnI/SD56euti8yOHVEsRN2Q3wLJCChCifAYbJAsOfnAXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LcICR7Z1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ECA606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LcICR7Z1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBE21F000C0;
	Mon, 23 Nov 2026 14:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795445531;
	bh=5qqNJMd6VbYnixx3z0Z0ClF7j1KojBVaxzh+Jz8wsfA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LcICR7Z1hvWbV34guA+pGFzIGGAs/Rsb7gXjGPpHOczUTRJRK5mOnbABTTB5vImPN
	 MhFXSa1n/SBGead3ZW0k9Fo11sViktNXkGLl9oYmczuPs+RKQUWZGG52CeWsrmSRk0
	 BmxWPXctqZQ4rIBLNtu1OItz/1nq7426H7qRR0CGIwCoUgiI1b8HjoJkqC0WXSHgg8
	 dIRS6UCxphXW0X4GDGkt0I9r0awlMqASsk0WTV17yLNFeVpIGewR4XAmMFrYiEjs7g
	 3b2p2p4sZgl2f/sdUTpJyUAJrz9rTg2oHrCzz3QGuw9bbBRsgwzgaBlQ0nvXJRpR6M
	 +4g55mpMyP2tA==
Message-ID: <sashiko-outbox-229449@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v4] net/rds: defer CM id destruction to a workqueue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Aibing Chen" <chenaibing@cmss.chinamobile.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261122145148.1250-1-chenaibing@cmss.chinamobile.com>
References: <20261122145148.1250-1-chenaibing@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 14:52:11 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] net/rds: silent TCP fallback or wrong errno on
  rds_ib_laddr_check_cm() -EAGAIN
--

commit e574b9774f231da9aa189fbad06e4a6b85eb1372
Author: Aibing Chen <chenaibing@cmss.chinamobile.com>

net/rds: defer CM id destruction to a workqueue

This commit defers rdma_destroy_id() from rds_ib_laddr_check_cm() to rds_wq=
 to
avoid a lockdep cycle between rds_trans_sem and handler_mutex, and bounds t=
he
number of pending probe CM IDs to 64.

> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 4ea9838d090c3..c4c10e3eabced 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c

[ ... ]

> @@ -411,14 +435,39 @@ static int rds_ib_laddr_check_cm(struct net *net, c=
onst struct in6_addr *addr,
>  #endif
>  	struct sockaddr_in sin;
>  	struct sockaddr *sa;
> +	struct rds_ib_destroy_work *w;
>  	bool isv4;
> =20
>  	isv4 =3D ipv6_addr_v4mapped(addr);
> +
> +	/*
> +	 * The id is destroyed from rds_wq: rds_trans_get_preferred() calls this
> +	 * function with rds_trans_sem held for reading, and rdma_destroy_id()
> +	 * takes handler_mutex, which the CM callback path acquires before
> +	 * taking rds_trans_sem.  Reserve a pending-probe slot first, so that a
> +	 * loop of bind() calls cannot pile up ids that pin a cma_dev reference
> +	 * and an RDMA_PS_TCP port.
> +	 */
> +	if (atomic_inc_return(&rds_ib_pending_probes) >
> +	    RDS_IB_MAX_PENDING_PROBES) {
> +		atomic_dec(&rds_ib_pending_probes);
> +		return -EAGAIN;
> +	}

[Severity: Medium]
When rds_ib_laddr_check_cm() returns -EAGAIN (or -ENOMEM), does
rds_trans_get_preferred() silently fall back to rds_tcp_transport instead of
propagating the error?

net/rds/transport.c:rds_trans_get_preferred() {
	for (i =3D 0; i < RDS_TRANS_COUNT; i++) {
		trans =3D transports[i];

		if (trans && (trans->laddr_check(net, addr, scope_id) =3D=3D 0) &&
		    (!trans->t_owner || try_module_get(trans->t_owner))) {
			ret =3D trans;
			break;
		}
	}
}

rds_trans_get_preferred() treats any non-zero return from trans->laddr_chec=
k()
as a non-match and continues to the next transport.  Because
rds_tcp_laddr_check() accepts any local address on the host, a socket bindi=
ng
to a local IPoIB address while RDS_IB_MAX_PENDING_PROBES is exceeded will be
bound to rds_tcp_transport instead of rds_ib_transport, causing subsequent
RDMA operations such as RDS_GET_MR to fail with -EOPNOTSUPP.  In rds_bind(),
-EAGAIN is also overwritten with -EADDRNOTAVAIL when no fallback transport =
is
loaded, or with -ENOPROTOOPT when rs->rs_transport was preset.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122145148.1250=
-1-chenaibing@cmss.chinamobile.com?part=3D1
