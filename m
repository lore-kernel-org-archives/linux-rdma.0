Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794616388;
	b=hglZ6jz7ByTdIJGFuGdukLRnzWO646mbnyNTEon65cXNENXY3+IUD2rBQ60ViAMRddOe
	 AK4dkdnjnSBqCO4szEWZtXg3YIYA0fQUK5hcdsp0/vWM7qwjDeMJeCk2ENJPghuVzIZ0Q
	 Fd5YzFeWLdmW1kMTsyPGg51xoCgaaIfOXftX4g4jlNTER8oIrIS75Kv8lX7t9oxQv8Q2H
	 +ljMJBNzS7mN+uvdUkGLuMWdw0v6vIEPlPUmm7YGICc4D3UnUsGyEZY5mbu0mZ2oyrVlg
	 O3H1Q1VVHWGOsBI7xhJ7ORWHI3FXxktdvwL8T2HNuhyR9sLA0uX3RbD5+VACrUO1urQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794616388;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=h9o3ref5abPS1tzID0uVpSVaTc7XzmVFwjmBd4FciDY=;
	b=wbCcUkwFCh7V+R5nRRp9FFdQixp5RLkMzoCdp+ADji1UAyk+LIzv4fTTpND3bcQdxPBP
	 LkHH4+oDHrnEUrl8jNZxjj7imtvjo0I2nLhX1lPUwaj8k7p/pgVEiRYLvCXwlgksFY4Gs
	 ABDxyH7KagWyrzR53+4b2auaYp2PNYjbuQABKfFHt6nJzNxLWbSAuSdvsguDJ7TXn+JuP
	 vAMXFLuI4xuxSwbkgSC4ye38bWrJQHxQ9gbAGDSe0DekRdKZ3X4/AG/LawJbj+MvyIest
	 vyKAjgj9IquU9FM6CjS4ou78vmfln8fzBPtFJ9SfEwHGJnu8EAsFDy4DuLK2pR7AZOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LyONqunU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C6A606A32E;
	Sat, 14 Nov 2026 00:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LyONqunU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26F01F000C5;
	Sat, 14 Nov 2026 00:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794616388;
	bh=h9o3ref5abPS1tzID0uVpSVaTc7XzmVFwjmBd4FciDY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LyONqunUp8e3esQJSJgPc+hiyHPxnt66sHcLIbOllLplY+TSWHu/lzkWJF15auaL9
	 oJNdWzbhHRoHQRQ56lndMD+D+iXcyfCoroGFx+OKbADdWqMv/JghQnqeMT1eQfLMwi
	 yhXx2utobAulnpGApZkARZA/fQoCITntikNj6lNTApVprqrAIu10mQr1Gk9ikvvhBH
	 1Dm/wdaQ/3lYC1wIrUST/EpqBZIgXqEiqzGyJg274nphirjdmXkKEWw0jihUy9V1fp
	 F4Yx1tfb7SYlblpwb1r+esODIncJzL2IeYq3g5CbFhrQRcbTZCmOGKesruv3U9d0w1
	 Ck2kpdycoF3HA==
Message-ID: <sashiko-outbox-213929@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v6 3/3] net/smc: skip the DMB nocopy accounting
 until the send buffer is set
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261112-b4-disp-1c8d3a53-v6-3-36a38ae35021@proton.me>
References: <20261112-b4-disp-1c8d3a53-v6-0-36a38ae35021@proton.me>
 <20261112-b4-disp-1c8d3a53-v6-3-36a38ae35021@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 00:33:07 +0000
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
- [High] net/smc: cursor and sndbuf_space corruption in
  smc_cdc_msg_recv_action()
--

commit e0b814dd8c52ebec88e4c2f0e2ec1ede28947bff
Author: Bryam Vargas <hexlabsecurity@proton.me>

net/smc: skip the DMB nocopy accounting until the send buffer is set

This commit publishes conn->sndbuf_desc with smp_store_release() in
smcd_buf_attach() and skips the SMC-D DMB nocopy accounting in
smc_cdc_msg_recv_action() when conn->sndbuf_desc is still NULL.

> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index b3bcc206efe3e..4a4a279b405b1 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -333,6 +333,7 @@ static void smc_cdc_msg_recv_action(struct smc_sock *=
smc,
>  	union smc_host_cursor cons_old, prod_old;
>  	struct smc_connection *conn =3D &smc->conn;
>  	int diff_cons, diff_prod, diff_tx;
> +	struct smc_buf_desc *sndbuf_desc;
> =20
>  	/* smc_conn_create() can have cleared rmb_desc */
>  	if (!smp_load_acquire(&conn->rmb_desc))
> @@ -357,12 +358,19 @@ static void smc_cdc_msg_recv_action(struct smc_sock=
 *smc,
>  		 * peer RMB, then update tx_curs_fin and sndbuf_space
>  		 * here since peer has already consumed the data.
>  		 */
> +		sndbuf_desc =3D NULL;
>  		if (conn->lgr->is_smcd &&
>  		    smc_ism_support_dmb_nocopy(conn->lgr->smcd)) {
> +			/* NULL until smcd_buf_attach(), but the old peer of
> +			 * a reused DMB can already signal us.
> +			 */
> +			sndbuf_desc =3D smp_load_acquire(&conn->sndbuf_desc);
> +		}
> +		if (sndbuf_desc) {
>  			/* Calculate consumed data and
>  			 * increment free send buffer space.
>  			 */
> -			diff_tx =3D smc_curs_diff(conn->sndbuf_desc->len,
> +			diff_tx =3D smc_curs_diff(sndbuf_desc->len,
>  						&conn->tx_curs_fin,
>  						&conn->local_rx_ctrl.cons);
>  			/* increase local sndbuf space and fin_curs */

[Severity: High]
Does skipping the if (sndbuf_desc) block while still applying
conn->local_rx_ctrl.cons desynchronize conn->tx_curs_fin from
conn->local_rx_ctrl.cons and corrupt conn->sndbuf_space?

When a CDC message from the old peer of a reused DMB arrives before
smcd_buf_attach() with a non-zero consumer cursor, smc_cdc_msg_to_host()
advances conn->local_rx_ctrl.cons (and adds diff_cons to
conn->peer_rmbe_space, which smc_conn_save_peer_info() already set to
conn->peer_rmbe_size), while skipping the if (sndbuf_desc) block leaves
conn->tx_curs_fin at {0, 0}.

smcd_buf_attach() then initializes conn->sndbuf_space to the full
buf_desc->len without resetting conn->local_rx_ctrl.cons or matching
conn->tx_curs_fin to it.  Because diff_tx is computed against
conn->tx_curs_fin rather than cons_old:

net/smc/smc_cdc.c:smc_cdc_msg_recv_action() {
    ...
			diff_tx =3D smc_curs_diff(sndbuf_desc->len,
						&conn->tx_curs_fin,
						&conn->local_rx_ctrl.cons);
			/* increase local sndbuf space and fin_curs */
			smp_mb__before_atomic();
			atomic_add(diff_tx, &conn->sndbuf_space);
			/* guarantee 0 <=3D sndbuf_space <=3D sndbuf_desc->len */
			smp_mb__after_atomic();
			smc_curs_copy(&conn->tx_curs_fin,
				      &conn->local_rx_ctrl.cons, conn);
    ...
}

any later consumer update that advances past the pre-attach cursor still
credits the pre-attach delta on top of buf_desc->len, pushing
conn->sndbuf_space above sndbuf_desc->len and letting smc_tx_sendmsg()
overwrite unconsumed data or write past the end of the buffer.  Conversely,
when the new peer sends consumer updates at or below the stale
conn->local_rx_ctrl.cons, smc_curs_diff() returns 0 and never credits
conn->peer_rmbe_space or conn->sndbuf_space, stalling transmission.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112-b4-disp-1c=
8d3a53-v6-0-36a38ae35021@proton.me?part=3D3
