Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3778B3D0932;
	Fri, 16 Oct 2026 08:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792138452; cv=none; b=eQwwivEPyZPryt8vzrF0GYn8q8Q4hJbm6qcgJoEAKeY+YZ3liM+3phatOi9NJsbbTa8Gnq84YXe7mFk1M/IsJh7WuquBicNjUL0tQXXybTW7GiCN4zCVyCBzEb20Uv+ohYbeoqhfEU9/j2RCuqvz3p8/N+bjsTK3DxgV4fNrmHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792138452; c=relaxed/simple;
	bh=RSNBag+k0/MX++CVjc2zc96iItdliQ25MR7Mrjcsv8U=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=LN59Ejvk8/2tJbcngniTyLZimsuZBy2L/Zx3T7HD+djy7+m7lPCkQjiJxrPIKTkNJJhzSLsqQrljLBwzk0w/cGguU71Ff7pVPENFP/VCdiUqD5vYoGlJUd3WRUItrTpaOUY5uR2q6rs0CPgJHo8WYCb2QhpyBnTCEwisxwkFZ1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M9S8jTOz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M9S8jTOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC071F000C4;
	Fri, 16 Oct 2026 08:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792138450;
	bh=QhC3pBRmBHm6+32ZfPdmfgjg+RMymgl4S9jrSVvv9t0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M9S8jTOzSQXk8XrpdCZTggndpf85Mlr8yK7GRkDycOaYb3bnAEv5v+BjdYlGqdxZk
	 h5O9UGxp9y8aBC7eCUvE+5U1aoPqO6vleZAMGqwqW4pCcHJZmu7NX7o9kVu2UHghaC
	 V5DUUrdSR1jYX3lA1D2nYk6eTXPwMdTO9QFHRpMix216f7OlBrO+hCAESKDVQTsVhc
	 7aEWTTldo3S16aYxvQ3h4EjXsExcSAUaEj77B3KVByXxmGfeZCN6ih3OqMq5bqiWwu
	 80fDFIfadp87cTGyU8nYEYu6pvqDhce2A5XwznkiImkxVYXr5QaQ4BF9WiitsLn5wz
	 /uuBOeUiT3y+A==
Message-ID: <sashiko-outbox-174005@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v11] net/smc: fix lgr/lnk lifetime vs diag reader
 race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261015081349.1252391-1-mjambigi@linux.ibm.com>
References: <20261015081349.1252391-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 08:14:09 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] smc: UAF on link group due to re-arming free_work after cancellati=
on
--

commit 14f4015f5f30a5352d7329e4e8f9201358d5aebb
Author: Mahanta Jambigi <mjambigi@linux.ibm.com>

net/smc: fix lgr/lnk lifetime vs diag reader race

This commit addresses races between the diag reader and connection/lgr/lnk
teardown paths by skipping unhashed or partially freed state, avoiding NULL
pointer dereferences and UAFs.

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 9974149659c2f..6735f185cf48c 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1279,10 +1279,9 @@ void smc_conn_free(struct smc_connection *conn)
>  		if (current_work() !=3D &conn->abort_work)
>  			cancel_work_sync(&conn->abort_work);
>  	}
> -	if (!list_empty(&lgr->list)) {
> +	if (!list_empty(&lgr->list))
>  		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
> -		smc_lgr_unregister_conn(conn);
> -	}
> +	smc_lgr_unregister_conn(conn);
> =20
>  	if (!lgr->conns_num)
>  		smc_lgr_schedule_free_work(lgr);

[Severity: High]
Can this unconditionally re-arm the free_work on a terminating link group,
leading to a use-after-free?

If a remote peer sends a DECLINE message with SMC_CLC_DECL_SYNCERR,
smc_listen_work() calls smc_lgr_cleanup_early(lgr). This unlinks the LGR
and calls __smc_lgr_terminate(), which cancels lgr->free_work and sets
lgr->terminating =3D 1.

Next, smc_listen_work() calls smc_conn_abort(), which calls smc_conn_free().
By moving smc_lgr_unregister_conn() outside the list_empty() check, it will
now be executed for the unlinked LGR. This decrements lgr->conns_num to 0,
which triggers smc_lgr_schedule_free_work().

Because smc_lgr_schedule_free_work() only checks !lgr->freeing (and not
lgr->terminating), it successfully re-arms the workqueue on the terminating
LGR:

net/smc/smc_core.c:smc_lgr_schedule_free_work() {
    if (!lgr->freeing) {
        mod_delayed_work(system_percpu_wq, &lgr->free_work, ...);
    }
}

The LGR is then freed by __smc_lgr_terminate(), leaving the re-armed timer
to eventually execute and dereference the freed lgr pointer.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015081349.1252=
391-1-mjambigi@linux.ibm.com?part=3D1
