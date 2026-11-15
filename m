Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794716089;
	b=Vj+H91JPGRBGiEG0y4zifxKTdD/iIahI4RL/2HJV3+WUQTHXYN24vYjGx7FnbjgFnUtN
	 PYKcD12oY+CipUsxcPV/2+QjWQeLlfK3eQ0Ap8nhlrKN+CYrLOqKRqZjJWHO+CqeyX5LU
	 HX2JZWBF70m9UXGJ+RIdyyJO4T5FldslXe60MgBqGqzRdMDVVGqzPaJTI0SZ5ZnRlQODE
	 cXEUD8+dY1ccwsfdGK+MGPljIK0KEFSn2C4Mmnt9mDVJxbuNCDTtdRBe51hv9i1IpZ6Kd
	 y99aoHRIUuM2UfF2q7xDJLDGeRh43+OrKuraFgsDvHuTB3egDfTIg2tVyEZfVzsN4gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794716089;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=aim5ox5B2fu8qTCjyyZdWqBZlkOfrm/1AW/wZ7pJA6o=;
	b=rtjElcr3QQ1TyWN0dseXxdbDHNRh6I0B6IcFOatBu4G22DX4wFBB8rGTrF9LMDsqLvZ2
	 wZ2zFmGsCS76D8tc38KasOFKJc4D62rcZlxVc0hGXwu4kqYc7D9F1xh3OPxPlX4xuA+4a
	 QHDENa317FnJdbe7thWR8orqG1rGpWT2wTUEVPEHe/zJYdQ+SFM+rpSrcW1vWD3RR9sNI
	 +Le2a8TiSK0fqA3an7kQHfs+MFv8OM6Wqqsb7WdhPSviRbnYEcziRCYMP+vfoauxzcIfO
	 RC12yPejriD35Blk+LscBIMwatYzOHFFknJIKE73T9dx501XeU9aDu5hz9rwvGWXpfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zv97kaJm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA46F606A327;
	Sun, 15 Nov 2026 04:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zv97kaJm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FC71F000C5;
	Sun, 15 Nov 2026 04:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794716089;
	bh=aim5ox5B2fu8qTCjyyZdWqBZlkOfrm/1AW/wZ7pJA6o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Zv97kaJm4CSNg6wiWWYDlL5NyEbcHH1IFB62qGXw7XcJFwZRMsIFSidERq2uvJeMF
	 mrMWv1Ms6/n+y0JyZP9PC3U6vmpLfG8dX8WwTvVVTIO9vOEHmLu3IuLhqtiCcwupcf
	 FMyfAE54jcyRWm8M3cN7/VmNtQFOGWfaBt9W4lfK7+Xp0tVR/Md9f4EGwDzCg96FEl
	 4/OdGhOe0qc7zR0MAjRTImwbvdT10ol3+WkN4NphXKnw24Sj1gGgkKThqOChHd0g3R
	 jRh5bwsY/7bGdP344B5VgTbLn7oF+Ksyzj3mC18BACQpMpvrTYkHoOkYUvhSxusUnb
	 zqj7F3hRkUgnA==
Message-ID: <sashiko-outbox-215218@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 2/4] net/smc: do not credit stale CDC completions
 after a link switch
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261113-b4-disp-1a9ab9b0-v1-2-4a7c8d85d849@proton.me>
References: <20261113-b4-disp-1a9ab9b0-v1-0-4a7c8d85d849@proton.me>
 <20261113-b4-disp-1a9ab9b0-v1-2-4a7c8d85d849@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 04:14:48 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Medium] net/smc: non-atomic in-place cursor updates in
  smc_switch_cursor() [1]
--

commit eb6e0c5a04a6c58fa63f96a2d68145215e6a20f0
Author: Bryam Vargas <hexlabsecurity@proton.me>

net/smc: do not credit stale CDC completions after a link switch

This commit tags pending CDC transmissions with a link-switch generation
counter and checks the completion cursor against tx_curs_fin so stale or
out-of-order completions after a link switch do not credit send buffer spac=
e.

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 73e86100e6db2..fb9f6a4eb6835 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1058,6 +1058,7 @@ static int smc_switch_cursor(struct smc_sock *smc, =
struct smc_cdc_tx_pend *pend,
>  	int rc =3D 0;
>  	int diff;
> =20
> +	conn->tx_switch_gen++;	/* completions of earlier sends: no credit */
>  	smc_curs_copy(&conn->tx_curs_sent, &conn->tx_curs_fin, conn);
>  	smc_curs_copy(&fin, &conn->local_tx_ctrl_fin, conn);
>  	/* set prod cursor to old state, enforce tx_rdma_writes() */

[Severity: Medium]
This problem wasn't introduced by this patch, but can a concurrent reader
observe a torn conn->tx_curs_sent when smc_switch_cursor() advances it in
place with smc_curs_add() [1]?

net/smc/smc_core.c:smc_switch_cursor() {
	...
	if (smc_curs_comp(conn->peer_rmbe_size, &cons, &fin) < 0) {
		diff =3D smc_curs_diff(conn->peer_rmbe_size, &fin, &cons);
		smc_curs_add(conn->sndbuf_desc->len,
			     &conn->tx_curs_sent, diff);
		smc_curs_add(conn->sndbuf_desc->len,
			     &conn->tx_curs_fin, diff);
	...
}

smc_switch_cursor() holds conn->send_lock, not the socket lock.  Unlike
smc_curs_copy(), smc_curs_add() mutates curs->count and curs->wrap in place
Across three steps:

CPU0                                  CPU1
smc_switch_cursor()                   smc_close_stream_wait()
  smc_curs_add(..., &conn->tx_curs_sent, diff)
    curs->count +=3D value;
    curs->wrap++;
                                        smc_tx_prepared_sends()
                                          smc_curs_copy(&sent,
                                            &conn->tx_curs_sent, conn)
                                          smc_curs_diff(..., &sent, &prep)
                                            <-- torn cursor, returns 0
    curs->count -=3D size;

When conn->tx_curs_sent wraps to match conn->tx_curs_prep.wrap, a reader th=
at
copies conn->tx_curs_sent before curs->count is reduced sees
sent.wrap =3D=3D prep.wrap with sent.count > prep.count.  smc_curs_diff() t=
hen
clamps prep.count - sent.count to 0, which lets smc_close_stream_wait() stop
waiting for prepared sends and close the connection before queued data is
transmitted.

Advancing local cursor copies with smc_curs_add() and publishing them via
smc_curs_copy() would avoid exposing the intermediate state.

[1] https://sashiko.dev/#/bug/linux-9856806b-d08f-4d48-bb6c-9f1dcc135c1e

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-b4-disp-1a=
9ab9b0-v1-0-4a7c8d85d849@proton.me?part=3D2
