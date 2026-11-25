Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795576881;
	b=48dXJBVYr5fsdiTyESbB7KJb23W8abLq/TA2LEvbSOiV1CCH2/Sv0JcUoxuMBC8Vp6pP
	 xfHYEHXXJ+LpHJayrbzOc6sUzDHUED6+BGVihmrISLyiK0jPaNa7uTW91rxyhYdVOkB4e
	 dms9IUqshO7smVd9Q/QCdoTQOnGl26QQpHbTwhkJZQjMFEORZw03M431BfWhLD7YFNsyz
	 vSeaIDrXxCE7HKQ3ODxkEinVLktlAzFCwiW7Uk8K0sgvd2dRmrJXMWzVp46lpKxXZqgig
	 /CiblqQ5zpcbKXkhbV3qMNX7F8BAIHNcWqRK01J9GDnb3bLnYIu0ZSblejwCWQv0a+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795576881;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BYEw4LReM8jd7zxCyyxvwZ3gIo1peIA5T+sz5mf4TIo=;
	b=RsErDxLnHKrmkX0Vxra9yLmZX8+YnLwn0tl/80WeIjefclB3RvFRIHz6MY/2D1dvC0bA
	 lCFmL5MtW9rOu///Ys+9D0a9Cs1eD7ypMawaOQ+CfV6fPRvYStD+ftl6pP5jf6ZP54GmW
	 N4cd1g2OlJEtw3IcqqnYsj1OVIryB31cc+wKOOn0PQtN8oBfp0nSXMSn2RizblF+NDg/U
	 LJ69T1Gy6nbv4x5NDRJu83AOW0cu1uaCv27243CqXfsPU06sSbtuKpDty4eS5Ft8yez0A
	 yLHmWnS7Rt1z76mjW3ftU76Kp++lD5DbB/VXMyrpSCaY97lhF6Jr0MRLnCfVGk4VCrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TfX1eQGS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EDC606A323;
	Wed, 25 Nov 2026 03:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TfX1eQGS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209A11F000C0;
	Wed, 25 Nov 2026 03:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795576880;
	bh=BYEw4LReM8jd7zxCyyxvwZ3gIo1peIA5T+sz5mf4TIo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TfX1eQGSJozqrtDby6XAblKI0HJ7z+r+P22060Bbmz5eE2oK07x0fCOzZsp4Nq/9g
	 UTk6a0UViNRPSET4LQyT7/gBWrBci5SFdSewstVB9ooHdtLBxq9af2bvC8fneUDx3t
	 zw1hUzri6bR5/gBbnSq1DwwkdRghgKJx/UHCdUYd3cJHQ9KmPcgx/3vzPYUem6z2RR
	 VkKgc0X52iVzcX65nPS0A/5JIbvu4eL31fZX1AQhU2FmDUrZssZ+utAp61PUNcG4dC
	 lOdS27yfEbPvQRurOgtoPLRZXF+gGUHi8aCn/psHHfjBZHOF6fA+lo3pa7bVPyUHR0
	 tbO0JtCpMt1Ag==
Message-ID: <sashiko-outbox-232458@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/smc: validate peer CDC cursors against buffer
 bounds and window
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qican Ma" <goonsomeway@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <CA+OT+ON4Lt9mLvWPK8rUaHKZ01_p0fGCiCsWHwXWzT1sGaTtLA@mail.gmail.com>
References: <CA+OT+ON4Lt9mLvWPK8rUaHKZ01_p0fGCiCsWHwXWzT1sGaTtLA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 03:21:19 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Critical] net/smc: missing monotonicity and wrap checks in
  smc_cdc_msg_recv_action()
- [High] net/smc: incomplete diff_prod window check in
  smc_cdc_msg_recv_action()
- [High] net/smc: valid initial CDC messages dropped in
  smc_cdc_msg_recv_action()
--

commit 1b4f7a808b103f512ec58fa5533fdc1b60707fd4
Author: Qican Ma <goonsomeway@gmail.com>

net/smc: validate peer CDC cursors against buffer bounds and window

This commit decodes incoming CDC messages into a temporary
smc_host_cdc_msg and validates cursor offsets and deltas against buffer
bounds and available capacity before updating conn->local_rx_ctrl.

> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index 32d6d03df3214..fd5e296e8becb 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -332,14 +332,48 @@ static void smc_cdc_msg_recv_action(struct smc_sock=
 *smc,
>  {
>  	union smc_host_cursor cons_old, prod_old;
>  	struct smc_connection *conn =3D &smc->conn;
> -	int diff_cons, diff_prod, diff_tx;
> +	struct smc_host_cdc_msg rx_ctrl =3D {};
> +	int diff_cons, diff_prod, diff_tx =3D 0;
> =20
>  	smc_curs_copy(&prod_old, &conn->local_rx_ctrl.prod, conn);
>  	smc_curs_copy(&cons_old, &conn->local_rx_ctrl.cons, conn);
> -	smc_cdc_msg_to_host(&conn->local_rx_ctrl, cdc, conn);
> +	rx_ctrl.prod =3D prod_old;
> +	rx_ctrl.cons =3D cons_old;
> +	smc_cdc_msg_to_host(&rx_ctrl, cdc, conn);
> +
> +	if (rx_ctrl.prod.count >=3D conn->rmb_desc->len ||
> +	    rx_ctrl.cons.count >=3D conn->peer_rmbe_size)
> +		return;

[Severity: High]
Does checking rx_ctrl.cons.count >=3D conn->peer_rmbe_size drop valid
initial CDC messages on a listening server before conn->peer_rmbe_size is
initialized?

In smc_listen_work(), the server allocates conn->rmb_desc and registers
the connection before sending SMC_CLC_ACCEPT, while conn->peer_rmbe_size
remains 0 until SMC_CLC_CONFIRM arrives and smc_conn_save_peer_info()
runs.  On the client, smc_connect_rdma() and smc_connect_ism() send
SMC_CLC_CONFIRM, set sk_state to SMC_ACTIVE, and return from connect()
immediately:

kworker (server)                  <softirq> (server)
smc_listen_work()
  smc_listen_find_device()
  smc_clc_send_accept()
                                  /* client receives ACCEPT, sends
                                   * CONFIRM + initial data + CDC
                                   * (prod.count > 0, cons.count =3D=3D 0)
                                   */
                                  smc_cdc_msg_recv()
                                    bh_lock_sock(&smc->sk)
                                    smc_cdc_msg_recv_action()
                                      rx_ctrl.cons.count >=3D
                                        conn->peer_rmbe_size
                                      /* 0 >=3D 0 -> message dropped */
  smc_clc_wait_msg(CONFIRM)
  ...
  smc_conn_save_peer_info()
    conn->peer_rmbe_size =3D ...

Because delivered RDMA/ISM CDC messages are not retransmitted, dropping
this initial CDC message loses the producer cursor update (and any close
flags), leaving the server blocked in recvmsg().

>  	diff_cons =3D smc_curs_diff(conn->peer_rmbe_size, &cons_old,
> -				  &conn->local_rx_ctrl.cons);
> +				  &rx_ctrl.cons);
> +	if (diff_cons > conn->peer_rmbe_size - atomic_read(&conn->peer_rmbe_spa=
ce))
> +		return;
> +
> +	if (diff_cons && conn->lgr->is_smcd &&
> +	    smc_ism_support_dmb_nocopy(conn->lgr->smcd)) {
> +		if (rx_ctrl.cons.count >=3D conn->sndbuf_desc->len)
> +			return;
> +		diff_tx =3D smc_curs_diff(conn->sndbuf_desc->len,
> +					&conn->tx_curs_fin, &rx_ctrl.cons);
> +		if (diff_tx > conn->sndbuf_desc->len - atomic_read(&conn->sndbuf_space=
))
> +			return;
> +	}
> +
> +	diff_prod =3D smc_curs_diff(conn->rmb_desc->len, &prod_old,
> +				  &rx_ctrl.prod);
> +	if (diff_prod > conn->rmb_desc->len - atomic_read(&conn->bytes_to_rcv))
> +		return;

[Severity: High]
Can a peer still advance conn->local_rx_ctrl.prod past
conn->local_tx_ctrl.cons because conn->bytes_to_rcv does not include
non-inline urgent bytes or in-flight spliced bytes?

When SOCK_URGINLINE is not set and rx_ctrl.prod_flags.urg_data_present is
set, smc_cdc_handle_urg_data_arrival() decrements diff_prod before
atomic_add(diff_prod, &conn->bytes_to_rcv), so each 1-byte urgent CDC
message advances conn->local_rx_ctrl.prod by 1 without increasing
conn->bytes_to_rcv.  Similarly, on splice() reads, smc_rx_recvmsg()
subtracts copylen from conn->bytes_to_rcv immediately while
conn->local_tx_ctrl.cons is not advanced until smc_rx_pipe_buf_release()
drops conn->splice_pending.  In both cases, checking only against
conn->rmb_desc->len - atomic_read(&conn->bytes_to_rcv) allows the peer to
wrap conn->local_rx_ctrl.prod past unconsumed data in the RMB.

> +
> +	conn->local_rx_ctrl.common.type =3D rx_ctrl.common.type;
> +	conn->local_rx_ctrl.len =3D rx_ctrl.len;
> +	conn->local_rx_ctrl.seqno =3D rx_ctrl.seqno;
> +	conn->local_rx_ctrl.token =3D rx_ctrl.token;
> +	smc_curs_copy(&conn->local_rx_ctrl.prod, &rx_ctrl.prod, conn);
> +	smc_curs_copy(&conn->local_rx_ctrl.cons, &rx_ctrl.cons, conn);

[Severity: Critical]
Can a peer bypass these delta checks by rewinding cursors on SMC-D or
jumping wrap counters on SMC-R and SMC-D?

On SMC-D, smcd_cdc_msg_to_host() copies peer->prod and peer->cons without
checking monotonicity.  If a peer sends new.wrap =3D=3D old.wrap with
new.count < old.count, smc_curs_diff() clamps new->count - old->count to
0, which passes the upper-bound checks and commits the rewound cursor to
conn->local_rx_ctrl without decreasing bytes_to_rcv or peer_rmbe_space
(and on dmb_nocopy links, a subsequent small advance with diff_cons > 0
and diff_tx =3D=3D 0 rewinds conn->tx_curs_fin as well).  Advancing the
cursor again then re-credits the same range and still inflates
bytes_to_rcv, peer_rmbe_space, and sndbuf_space past the buffer length.

In addition, when old->wrap !=3D new->wrap, neither smc_curs_diff() nor
smc_cdc_cursor_to_host() verifies that new->wrap =3D=3D (u16)(old->wrap + 1)
and new->count <=3D old->count.  A peer can jump rx_ctrl.cons.wrap while
keeping diff_cons within peer_rmbe_size - atomic_read(&conn->peer_rmbe_spac=
e),
leaving prod.wrap !=3D cons.wrap in smc_tx_rdma_writes() when
prod.count + len > conn->peer_rmbe_size so that dst_len is not clamped to
conn->peer_rmbe_size - prod.count, causing an out-of-bounds write past
the peer RMBE/DMB.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/CA+OT+ON4Lt9mLvWPK8=
rUaHKZ01_p0fGCiCsWHwXWzT1sGaTtLA@mail.gmail.com?part=3D1
