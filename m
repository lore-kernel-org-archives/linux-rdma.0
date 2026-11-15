Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794716090;
	b=GBltxnjwXH9IPeWGo1GLecQ569RHRoZLmeWN0zE3nB2m2Ow5t5LpAkO+mXf0cHj6BkAD
	 bChCPwfbtv6BmiCxVhvUKDuEU11UTNYfH8U95MZR1QglbfvFzdR4EIHz135nO7ecpWK+H
	 AEdgtr0rzsIRzPNa/CcGoDThELEyFnbSmNgoSApUFucydkxpBYzp6G+PR2b8Vr5it64R8
	 qkkI8oLNhepdZ3mrM55TvyQBw1gs8QESyz/AfEtquVFXQt/p9bT5kWBGjYdlDIGTMIn7k
	 k3vwk1YBkfR1MN5N9LE8hXozOK4BWYv/BSfTPe+WidR0/bYeDILs9GsIXYUFurIXlTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794716090;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=dy3DqqjlJAYbU7izAe9O6h4a8ILz+nM/9IKZsDy+mFM=;
	b=DEurbc1jT2gkIMHW/2BOyRApTNyGW0lRVg8ENT3RK7Ws2NgEC6rAGwyVR/oOwGx3cPxv
	 +4qQHblly2kwjLZ7NC+XvmFvKtuULI2qLIBlAQhZN04YP1X3C+2FLjD0IcXwz43C/m2ra
	 MnBTnEfNbwhIg3pwOMrcjSNlhvHQ23GgeeR79WH3Ty4bNmKU59A58YJa9A4f4gHKroccz
	 0V9P8SPor8Yx75jDpJ4l1Mip/AQuUeMhpGPjPplsiP7xKQqmNLtFfMam/cwtlX9kgALi/
	 3pgL+HvoxfdbfJoRc83FxyazYFFtokQemoIR+lqBU2ZlWYTB6Nt8nxPzcHjwlLdVg3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="GI7Foi/7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F696606A334;
	Sun, 15 Nov 2026 04:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GI7Foi/7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0F91F000C5;
	Sun, 15 Nov 2026 04:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794716090;
	bh=dy3DqqjlJAYbU7izAe9O6h4a8ILz+nM/9IKZsDy+mFM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GI7Foi/79+y+FQJy+CIq7TODcFWtp+aBv+N3XBWQhlc50e/lzwZUpl2OdT/DJLxOX
	 huCZZvDVZ0FnoSPxTga1KWnwK0QyHTexETf7AjZ5utlGhhfLfzlQPYKDP3EH++KjkY
	 70NHPwwYcI1jXoENgbdFGpfSLLAklBgzkYcnGKvXXHJp7Wt+LC1EaiPM/PTdDs2u2w
	 JGlM6hCPNF8k5lQbUHv2GOAPvkhFPnHwi6AP/D6lNoPw8NxOif2rfUdG7XoPlud5FL
	 jTausdZPJTGrKNaJfs7A6xFB8h1YqOFjMJtaEDIcG+shFdpe7RNzTk71AK2AUpSi3f
	 sp8tnqVoCO8dA==
Message-ID: <sashiko-outbox-215219@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 3/4] net/smc: fix the failover catch-up across the
 cursor wrap rollover
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261113-b4-disp-1a9ab9b0-v1-3-4a7c8d85d849@proton.me>
References: <20261113-b4-disp-1a9ab9b0-v1-0-4a7c8d85d849@proton.me>
 <20261113-b4-disp-1a9ab9b0-v1-3-4a7c8d85d849@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 04:14:49 +0000
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
- [High] net/smc: clamping diff in smc_switch_cursor() leaves prod
  behind cons
--

commit 232f7aaa1516220f36350d189111dfcee52e69da
Author: Bryam Vargas <hexlabsecurity@proton.me>

net/smc: fix the failover catch-up across the cursor wrap rollover

This commit updates smc_switch_cursor() to compute the failover catch-up
distance using smc_curs_sdiff(), bound it by the number of sent bytes,
and advance the RMB cursors across multiple ring wraps.

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index fb9f6a4eb6835..76a577a20e4ae 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1054,22 +1054,28 @@ static int smc_switch_cursor(struct smc_sock *smc=
, struct smc_cdc_tx_pend *pend,
>  			     struct smc_wr_buf *wr_buf)
>  {
>  	struct smc_connection *conn =3D &smc->conn;
> -	union smc_host_cursor cons, fin;
> +	union smc_host_cursor cons, fin, sent;
>  	int rc =3D 0;
> -	int diff;
> +	s64 diff;
> =20
>  	conn->tx_switch_gen++;	/* completions of earlier sends: no credit */
> +	smc_curs_copy(&sent, &conn->tx_curs_sent, conn);
>  	smc_curs_copy(&conn->tx_curs_sent, &conn->tx_curs_fin, conn);
>  	smc_curs_copy(&fin, &conn->local_tx_ctrl_fin, conn);
>  	/* set prod cursor to old state, enforce tx_rdma_writes() */
>  	smc_curs_copy(&conn->local_tx_ctrl.prod, &fin, conn);
>  	smc_curs_copy(&cons, &conn->local_rx_ctrl.cons, conn);
> =20
> -	if (smc_curs_comp(conn->peer_rmbe_size, &cons, &fin) < 0) {
> +	/* not past what was sent, whatever cons says; that also keeps
> +	 * diff within one send buffer for smc_curs_add()
> +	 */
> +	diff =3D min(smc_curs_sdiff(conn->peer_rmbe_size, &fin, &cons),
> +		   smc_curs_sdiff(conn->sndbuf_desc->len,
> +				  &conn->tx_curs_fin, &sent));
> +	if (diff > 0) {
>  		/* cons cursor advanced more than fin, and prod was set
>  		 * fin above, so now prod is smaller than cons. Fix that.
>  		 */
> -		diff =3D smc_curs_diff(conn->peer_rmbe_size, &fin, &cons);
>  		smc_curs_add(conn->sndbuf_desc->len,
>  			     &conn->tx_curs_sent, diff);
>  		smc_curs_add(conn->sndbuf_desc->len,
> @@ -1079,10 +1085,10 @@ static int smc_switch_cursor(struct smc_sock *smc=
, struct smc_cdc_tx_pend *pend,
>  		atomic_add(diff, &conn->sndbuf_space);
>  		smp_mb__after_atomic();
> =20
> -		smc_curs_add(conn->peer_rmbe_size,
> -			     &conn->local_tx_ctrl.prod, diff);
> -		smc_curs_add(conn->peer_rmbe_size,
> -			     &conn->local_tx_ctrl_fin, diff);
> +		smc_curs_advance(conn->peer_rmbe_size,
> +				 &conn->local_tx_ctrl.prod, diff);
> +		smc_curs_advance(conn->peer_rmbe_size,
> +				 &conn->local_tx_ctrl_fin, diff);
>  	}

[Severity: High]
Can clamping diff to tx_curs_fin..sent leave conn->local_tx_ctrl.prod
behind conn->local_rx_ctrl.cons?

Whenever fin..cons exceeds tx_curs_fin..sent, local_tx_ctrl.prod is only
advanced by diff (to fin + diff), which remains strictly behind cons.
That happens if a peer advertises cons ahead of tx_curs_sent, or across
two link switches when data sent on the first link reaches the peer and is
consumed after the first smc_switch_cursor() already rewound tx_curs_sent
to tx_curs_fin (making tx_curs_fin..sent zero on the second switch before
tx_work resends).

Both smc_write_space() and smc_tx_rdma_writes() assume cons <=3D prod:

net/smc/smc_tx.c:smc_tx_rdma_writes() {
	...
	if (prod.wrap =3D=3D cons.wrap) {
		dst_len =3D min_t(size_t,
				conn->peer_rmbe_size - prod.count, len);
	} else {
		dst_len =3D len;
	}
	...
}

When prod < cons, smc_write_space() can compute a negative
peer_rmbe_space (stalling the connection), or when prod.wrap !=3D cons.wrap
with prod.count <=3D cons.count, smc_tx_rdma_writes() skips clamping
dst_len to conn->peer_rmbe_size - prod.count and can issue an RDMA write
past the end of the peer RMBE.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-b4-disp-1a=
9ab9b0-v1-0-4a7c8d85d849@proton.me?part=3D3
