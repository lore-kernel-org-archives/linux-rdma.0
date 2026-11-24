Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795528424;
	b=pnJXae/FNCdJEvBHJHmB6VolHj57Z959e98r/u4b/gTPoQUoLB1qTtQeKMICjUKWfHTd
	 zU3dKzHQve21WKJxmIS3noLo4dQ/rJr3E+wf3LqAj5vr3T0iRGBAf1zipqfu4b/N4YjYj
	 /wpf6cDc1KncDZSGQjjIF2AF+oqj8fas8uBIDMdJNsPGYZ/WPkCuOl91pbSe6Hd4tFwFL
	 gDU87NBHnOFhO8j0S0SHPJEcOr8L6dVbYeWtlLEeEkCCerbpPbsErLusUJzzo1cgPuRKg
	 xS0HPjoe9vXrTuPI4fz8RnidZc2F+9PGVavAcgmBG7d8afC4TxF4ZgeAJPnafS00Vaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795528424;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/TR5NvUlPrWkZidpo8NpGlurym56SZzfsHzZEIx9OMA=;
	b=pSQlM29PEp7vIZF1ScJ4jfGzgsVG5CzfZIKN48L7DKUN1jOOOQy5JdZ+y0r7P6gHLEcN
	 m0FsJ/kG8hlShuqIz5JoNtmMJUOj/sT0sLzUMY0yL/yUWmrAc674xkjPHfKr+rLu+KwW7
	 kypLv9S2LB0cJjSk5Yz605fDUG4UgWO1wZHnkq/vqEdYJumvu/eTZC62TIPRVVA3azfkC
	 KLUp4nIVgE0omXQ9E8jcUSoumar6VMth0ZA/TnmUhaOQnwsX1UnR0JHzT7Fju4DKMXTPp
	 QadbbdApNg9AZ/aKogqWNL1ym3RCzTO/pStk5dNEaR/AFKVllR1+B1wVGswTBUq/vcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IiH4+I60;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76724606A331;
	Tue, 24 Nov 2026 13:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IiH4+I60
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C3B1F000E0;
	Tue, 24 Nov 2026 13:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795528423;
	bh=/TR5NvUlPrWkZidpo8NpGlurym56SZzfsHzZEIx9OMA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IiH4+I605+DLKHBhtgflFm3D7+fdNKs2WoiJKtjp6Ooo8W0dSLllZjCu58GziWXg3
	 trz8E+qyXs+Giw9mDPDJ2cbQKGjuh3mNm5P81EYiklic0SZuDSxegB6ZndHKOAMiIM
	 5gWmlWCTpVWZG1h5NC5VOjjfL/EfZRjgA3B0ENXrb4HAXZy11yyNo2sO+ieFm537uw
	 Y3G7CZKB64sVOvie9UhRN4u7q0p38peBDhn8nH0LUOy7jeqKIvyBoigeB0VxsIF9me
	 Pjv9aau71AirZvcnJwgCiTvOYLYpPXE6ezEDdOv2w8tMnCCt7+eF1N5hKbhBM3f0Qz
	 DIlJh76gnn0zw==
Message-ID: <sashiko-outbox-231270@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2 1/2] net/smc: bound the failover cursor catch-up
 by what is outstanding
Reply-To: sashiko-reviews@lists.linux.dev
To: "Piyus Kedia" <piyus@iiitd.ac.in>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261123135327.3953509-1-piyus@iiitd.ac.in>
References: <20261123135327.3953509-1-piyus@iiitd.ac.in>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 13:53:43 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] net/smc: smc_switch_cursor() bounds catch-up by prepared
  instead of sent bytes
- [High] net/smc: smc_switch_cursor() clamp leaves local_tx_ctrl.prod
  behind cons
--

commit d641bcdb06babb4611de33b1b2a3ed34727ace6d
Author: Piyus Kedia <piyus@iiitd.ac.in>

net/smc: bound the failover cursor catch-up by what is outstanding

This commit bounds the cursor catch-up diff in smc_switch_cursor() by
conn->sndbuf_desc->len - atomic_read(&conn->sndbuf_space) so a peer's
consumer cursor cannot credit conn->sndbuf_space past the send buffer size.

Link: https://lore.kernel.org/all/20261122053223.2497832-2-piyus@iiitd.ac.i=
n/

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index a3164201c1420..436a702f3d8de 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1057,6 +1057,7 @@ static int smc_switch_cursor(struct smc_sock *smc, =
struct smc_cdc_tx_pend *pend,
>  	union smc_host_cursor cons, fin;
>  	int rc =3D 0;
>  	int diff;
> +	int sent;
> =20
>  	smc_curs_copy(&conn->tx_curs_sent, &conn->tx_curs_fin, conn);
>  	smc_curs_copy(&fin, &conn->local_tx_ctrl_fin, conn);
> @@ -1069,6 +1070,16 @@ static int smc_switch_cursor(struct smc_sock *smc,=
 struct smc_cdc_tx_pend *pend,
>  		 * fin above, so now prod is smaller than cons. Fix that.
>  		 */
>  		diff =3D smc_curs_diff(conn->peer_rmbe_size, &fin, &cons);
> +		/* The peer's consumer cursor is taken as it arrives, so this
> +		 * difference is a value the peer chose.  An honest peer cannot
> +		 * have consumed more than this side has outstanding, so bound
> +		 * the catch-up by that: sndbuf_space then keeps the invariant
> +		 * the tx path relies on, and the cursors advanced below stay
> +		 * within the send buffer.
> +		 */
> +		sent =3D conn->sndbuf_desc->len - atomic_read(&conn->sndbuf_space);

[Severity: High]
Does conn->sndbuf_desc->len - atomic_read(&conn->sndbuf_space) measure all
prepared bytes in the send buffer (tx_curs_prep - tx_curs_fin) rather than =
the
unconfirmed bytes actually transmitted to the peer RMBE (tx_curs_sent -
tx_curs_fin before tx_curs_sent is overwritten above)?

When prepared but unsent data sits between tx_curs_sent and tx_curs_prep (f=
or
example due to corking, autocorking, or a full peer RMBE), advancing
tx_curs_sent and tx_curs_fin up to sent skips over unsent payload in sndbuf
and credits sndbuf_space for data that was never put on the wire.  Also, wh=
en
conn->sndbuf_desc->len > conn->peer_rmbe_size, sent can exceed
conn->peer_rmbe_size, allowing smc_curs_add(conn->peer_rmbe_size, ...) below
(which subtracts peer_rmbe_size only once) to leave local_tx_ctrl.prod.count
at or above conn->peer_rmbe_size.  Finally, advancing tx_curs_fin past the =
old
tx_curs_sent moves it ahead of any in-flight cdcpend->cursor on the old link
(which is drained via smc_wr_tx_wait_no_pending_sends() only after
smc_switch_conns() returns), so a completing CQE on the old link in
smc_cdc_tx_handler() either computes a wrapped diff or rewinds tx_curs_fin =
and
lets the new link's validation CQE double-credit sndbuf_space above
sndbuf_desc->len.

Computing the bound from smc_curs_diff(conn->sndbuf_desc->len,
&conn->tx_curs_fin, &conn->tx_curs_sent) before overwriting conn->tx_curs_s=
ent
would limit the catch-up to bytes actually sent on the old link.

> +		diff =3D min_t(int, diff, max_t(int, sent, 0));

[Severity: High]
When this clamp reduces diff below smc_curs_diff(conn->peer_rmbe_size, &fin,
&cons), does leaving conn->local_rx_ctrl.cons unclamped leave
conn->local_tx_ctrl.prod behind conn->local_rx_ctrl.cons after this block?

smc_switch_cursor() resets conn->local_tx_ctrl.prod to fin and relies on
adding diff to bring prod up to cons, then immediately updates peer_rmbe_sp=
ace
via smc_write_space():

net/smc/smc_core.c:smc_write_space() {
	...
	smc_curs_copy(&prod, &conn->local_tx_ctrl.prod, conn);
	smc_curs_copy(&cons, &conn->local_rx_ctrl.cons, conn);
	/* determine rx_buf space */
	space =3D buffer_len - smc_curs_diff(buffer_len, &cons, &prod);
	return space;
}

Both smc_curs_diff(buffer_len, &cons, &prod) and smc_tx_rdma_writes() assume
cons <=3D prod.  If prod < cons across a wrap boundary (prod.wrap !=3D cons=
.wrap),
smc_curs_diff() takes the old->wrap !=3D new->wrap branch and returns
(buffer_len - cons.count) + prod.count; when prod.count > cons.count that
exceeds buffer_len and makes peer_rmbe_space negative, and when
peer_rmbe_space > 0 smc_tx_rdma_writes() sees prod.wrap !=3D cons.wrap, ski=
ps
clamping dst_len to conn->peer_rmbe_size - prod.count, and can RDMA-write p=
ast
the end of the peer RMBE.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123135327.3953=
509-1-piyus@iiitd.ac.in?part=3D1
