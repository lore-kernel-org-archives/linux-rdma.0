Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792854225;
	b=GzvYn5mAcrFtq8StwOnIBtiRPW+Mt9LMsLNyqg7//gH2pRRHvAtZlkvQJbaeav/ziH+r
	 trh4LeqFu37PAzbb5l2c17EPHTweZUcyEWS14j9Wop/d5o6qqmfDklafgwxsIAYC2DYha
	 VA4yJFI0fzL3JRmWo9EdBO+RcTNGPt7EB5HrN841gONgW9GKNOqgg8VEhNLLZLULSIWi1
	 KW8ctKFqk/dli0a9zcBgEasehzEUyKzqIg9CSyHa/jXV/S0kEHTiI+lz292lwx2Z2A2cz
	 2MX1Yg9Wqf0/rkcHyOnTa/xYKDNqFg8h21DrNiit8sikbwKZvyVNxEHCsEkdnrsEGaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792854225;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UTEVG361IRMXf581ocd/rLsL4XSZOtBCvjNuPo0XcUo=;
	b=LoIU1E8UFE7EnBJDVxK9dIJ8bCVOq3thNDGfdkW1ZIxDlOYxqv4iTQD/eFVOB8YbqTAS
	 6iyy7V3aNqOLH5wC+Zv/d8P2rXZUtxzTiBUPOqEoICBFVfONzfq7/TzGfupLhoDwM+J81
	 5KyxPVvU0ji7XhMyf9kkodSKMf6TBr0iBJol0S51Hwr3y2MHrzkX6VgKjXO53/HrxopPB
	 meZSYhSLM/VokoMTqf8TRl8jKmVb3BrehfYvKvPU1bo5CiT6iB1Asne+6198eDdoESdUw
	 hB7JiUEi2ZA1khGmnbRaD3FsKYt1nNxONCDxl2eMO/ETLSFynpgV2wgYCMJqQ4Sef8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BOIVXypQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6784D606A31A;
	Sat, 24 Oct 2026 15:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BOIVXypQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44E51F01825;
	Sat, 24 Oct 2026 15:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792854225;
	bh=UTEVG361IRMXf581ocd/rLsL4XSZOtBCvjNuPo0XcUo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BOIVXypQej2WV8dl4nY3g102yezTk6ZfyBZoFaIy2E+NEaepbspLWYrDdGclYr+ib
	 GKobZJAb0c2TUmF35gRcP7LpYX1g6dSKThkOEkj3DdRRNop+3J43vE3IIMs8vqNBSS
	 7XcnkFJA9BP3CEOTch+pXGgyhiPh0AjUNwMlNhuU2FftPOi6bbJR/E3kG0UkWJsOD4
	 vImCAifdWYxp4pTTXBNjTx15r7hp7UXCL2JED2Bgvuw0cZEhERsm4kTzH77K9mM8DY
	 1+iNwhh8e+KkBiP96Vi+vL6ymYY9LrZkM9vokYeDDRjQfnUX9vnY9g0cIy6rIg1ax8
	 JCBNp2jXb0qgg==
Message-ID: <sashiko-outbox-183765@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v13] net/smc: fix lgr/lnk lifetime vs diag reader
 race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261023150317.1163397-1-mjambigi@linux.ibm.com>
References: <20261023150317.1163397-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 15:03:44 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] net/smc: use-after-free of conn->lgr in __smc_diag_dump() for =
SMC_CLOSED
--

commit 899c06b63c039c1819c9691a7be591a10540701e
Author: Mahanta Jambigi <mjambigi@linux.ibm.com>

net/smc: fix lgr/lnk lifetime vs diag reader race

This commit addresses races between sock_diag dumps and connection, link
group, or link teardown by unhashing sockets before freeing connection
resources, ordering sk_state transitions with acquire/release barriers, and
skipping extended diag attributes for SMC_INIT, SMC_CLOSED, and fallback
sockets.

> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
> index bf0beaa23bdb6..84c45aabc196c 100644
> --- a/net/smc/smc_diag.c
> +++ b/net/smc/smc_diag.c
> @@ -87,10 +87,11 @@ static int __smc_diag_dump(struct sock *sk, struct sk=
_buff *skb,
> =20
>  	r =3D nlmsg_data(nlh);
>  	smc_diag_msg_common_fill(r, sk);
> -	r->diag_state =3D sk->sk_state;
> +	r->diag_state =3D smp_load_acquire(&sk->sk_state);
>  	if (smc->use_fallback)
>  		r->diag_mode =3D SMC_DIAG_MODE_FALLBACK_TCP;
> -	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
> +	else if (r->diag_state !=3D SMC_INIT &&
> +		 smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>  		r->diag_mode =3D SMC_DIAG_MODE_SMCD;
>  	else
>  		r->diag_mode =3D SMC_DIAG_MODE_SMCR;

[Severity: Critical]
Can smc->conn.lgr->is_smcd still be dereferenced after smc->conn.lgr has be=
en
freed when r->diag_state is SMC_CLOSED and smc->use_fallback is false?

Further down in __smc_diag_dump(), the extended attribute blocks check for
both SMC_INIT and SMC_CLOSED:

	if (r->diag_state =3D=3D SMC_INIT || r->diag_state =3D=3D SMC_CLOSED ||
	    smc->use_fallback)
		goto out;

However, the diag_mode check above only excludes r->diag_state =3D=3D SMC_I=
NIT.
If a socket reaches SMC_CLOSED without falling back to TCP while still hash=
ed
in smc_hash, __smc_diag_dump() will still evaluate
smc_conn_lgr_valid(&smc->conn) and dereference smc->conn.lgr->is_smcd.

This appears reachable in two ways:

1. When a link group is scheduled for termination (for example via
smc_lgr_terminate_sched() or smc_smcd_terminate()), list_del_init(&lgr->lis=
t)
empties lgr->list. If a handshake subsequently aborts via
smc_conn_abort() -> smc_conn_free():

net/smc/smc_core.c:smc_conn_free() {
	...
	if (!list_empty(&lgr->list)) {
		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
		smc_lgr_unregister_conn(conn);
	}
	...
	smc_lgr_put(lgr); /* lgr_hold in smc_conn_create() */
}

smc_conn_free() skips smc_lgr_unregister_conn(conn), leaving
conn->alert_token_local non-zero while dropping the connection's reference =
to
lgr. If fallback does not happen (for instance in smc_listen_decline() when
reason_code < 0 or smc_switch_to_fallback() fails), new_smc->use_fallback
remains false and smc_listen_out_err() sets sk_state to SMC_CLOSED while the
socket stays hashed:

net/smc/af_smc.c:smc_listen_decline() {
	...
	smc_conn_abort(new_smc, local_first);
	if (reason_code < 0 ||
	    smc_switch_to_fallback(new_smc, reason_code)) {
		/* error, no fallback possible */
		smc_listen_out_err(new_smc);
		return;
	}
}

Once the link group is freed, a concurrent __smc_diag_dump() reader seeing
r->diag_state =3D=3D SMC_CLOSED and a non-zero alert_token_local can derefe=
rence
the freed smc->conn.lgr->is_smcd.

2. On the client side, if smc_connect_rdma() or smc_connect_ism() aborts
after smc_conn_create() with first_contact_local set, smc_conn_abort() clea=
rs
alert_token_local and frees lgr via smc_lgr_cleanup_early(). If
smc_connect_decline_fallback() fails without setting use_fallback, sk_state
remains SMC_INIT until the socket is closed via
__smc_release() -> smc_close_active():

net/smc/smc_close.c:smc_close_active() {
	...
	switch (sk->sk_state) {
	case SMC_INIT:
		sk->sk_state =3D SMC_CLOSED;
		break;
	...
}

Because smc_close_active() writes SMC_CLOSED with a plain store before
__smc_release() calls sk->sk_prot->unhash(sk), on weakly ordered CPUs a
concurrent __smc_diag_dump() reader using smp_load_acquire(&sk->sk_state) c=
an
observe r->diag_state =3D=3D SMC_CLOSED before the alert_token_local =3D 0 =
store is
visible, and dereference the freed smc->conn.lgr->is_smcd.

Should the diag_mode condition also check r->diag_state !=3D SMC_CLOSED?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023150317.1163=
397-1-mjambigi@linux.ibm.com?part=3D1
