Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794877587;
	b=H6ELadEiP7aY0NabySqX0ZhE8hpf1aZTIR89o3Xpl7nUr1sFFHphQdDvrpmJn6TiUJfu
	 cs9152FHzBIEhGotR7IbCYMTXpWMUrlWT0TXAOMy+jDPYIkPBqYQmYZk2kHhFCgwifyyC
	 ToMFdK/6NRKf8cdZlQ9kL8BxJUWTxvLLRFmXDTimVgmar14IzX6NZOT525zFruy5rnvjT
	 hIwLkRkyr3tkrt8xRP9yRmwOYoh/EtJzG7Y1XvAy3vBg/ntjnRPu2dEUY1X2OpCneKiWC
	 6SgsG6Lyd8Txcn2EnyEbSgP/Pm3EHhkh9RJ2ICijkG4sxzyEErLWnoPjuIiONGDYBUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794877587;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Sb9h9j6lPynfBYh6n95WwXR9U5v9/0qOxm69owQ23yI=;
	b=0M+td1tRIWhnv4ddREK9nW2t+Yb5AqIfVJjvsYiXKTC6tzQeOpxcyzlIfPP34BVPuwFS
	 KXO09tnzbzGZRbq1X8YRrnVEeN4WRhpvJAORPUbBX9LJqAwFkxEiYgJWcnSx24R8FkOiY
	 +mYCKCEtc2eGCfiUviP6aplatQi4iHyjVWRD18phThQTns5nfcfZIXrj1blgmKFQqp1J/
	 bgMyK+95Gs+2x1lvUOL13PvlwbMV3NVhkunj7t7ltlW7yXNTqQBXvf23FxGN9rt/9/0Nw
	 J3iHNjctMSF+BRIT0aFBrFgZy433DV59WyEQO9qEVPxokERn9iL7+up5ATF/cwK4BpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="bXD/oVvm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99838606A882;
	Tue, 17 Nov 2026 01:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bXD/oVvm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673BA1F000C4;
	Tue, 17 Nov 2026 01:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794877587;
	bh=Sb9h9j6lPynfBYh6n95WwXR9U5v9/0qOxm69owQ23yI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=bXD/oVvmhB9L9jp9ytgzC5qCGW3Ey2wz/1tlFoUdSEZdp392eY/YVWA2THUHjXD6X
	 6DR/Xn82HT3L/gpCKMlwIECGkbyM6iT7fLpWHVyGzmNxSis3DkACfVJGFo0yQv7A/6
	 stawLvWsg5OSgW+oBxtBEO1PVSw/WP+oNWrUfaMz6J6J3tEc6l6qsV7geJLOaiczY7
	 NuqFnqMAp781RfUJ2Wr001B20qqeiLbWM6/7sLdgOlflQMvE1RJe//lEAgVOO+sLeW
	 AxcRSrqH6EYwLBaTV2k1Ly4jTRtFL8EOmsP5eCwP8AB13FilQ67ya177JeNAIidSPZ
	 ZjVgPIXdjKwDQ==
Subject: Re: [PATCH net v6 3/3] net/smc: skip the DMB nocopy accounting until
 the send buffer is set
From: netdev-bot+sashiko@kernel.org
To: hexlabsecurity@proton.me
Cc: mjambigi@linux.ibm.com, kuba@kernel.org, dust.li@linux.alibaba.com,
 davem@davemloft.net, edumazet@kernel.org, sidraya@linux.ibm.com,
 pabeni@redhat.com, alibuda@linux.alibaba.com, hwippel@linux.ibm.com,
 linux-kernel@vger.kernel.org, wenjia@linux.ibm.com, netdev@vger.kernel.org,
 hidayath@linux.ibm.com, ubraun@linux.ibm.com, tonylu@linux.alibaba.com,
 linux-rdma@vger.kernel.org, guwen@linux.alibaba.com,
 linux-s390@vger.kernel.org, horms@kernel.org
Date: Tue, 17 Nov 2026 01:06:25 +0000
Message-ID: <179487758596.3136.12928828467382443502@kernel.org>
In-Reply-To: <20261112-b4-disp-1c8d3a53-v6-3-36a38ae35021@proton.me>
References: <20261112-b4-disp-1c8d3a53-v6-3-36a38ae35021@proton.me>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The new NULL check only covers the time before
  smcd_buf_attach().
- [Medium] The patch stops the NULL dereference, but it keeps processing
  a CDC that, by the patch's own new comment, can come from the old peer…

--

net/smc: skip the DMB nocopy accounting until the send buffer is set

This patch changes smcd_buf_attach() to publish conn->sndbuf_desc with a
release store once sndbuf_space has been set. While sndbuf_desc is still
NULL, smc_cdc_msg_recv_action() now skips the SMC-D DMB nocopy accounting.
The aim is to avoid a NULL dereference when the old peer of a reused DMB
sends a consumer update before the new connection has attached its send
buffer.

> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index b3bcc206efe3e..4a4a279b405b1 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c

[ ... ]

> @@ -357,12 +358,19 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
>  		 * peer RMB, then update tx_curs_fin and sndbuf_space
>  		 * here since peer has already consumed the data.
>  		 */
> +		sndbuf_desc = NULL;
>  		if (conn->lgr->is_smcd &&
>  		    smc_ism_support_dmb_nocopy(conn->lgr->smcd)) {
> +			/* NULL until smcd_buf_attach(), but the old peer of
> +			 * a reused DMB can already signal us.
> +			 */
> +			sndbuf_desc = smp_load_acquire(&conn->sndbuf_desc);
> +		}
> +		if (sndbuf_desc) {

[Severity: Medium]
The NULL dereference is gone. But the new comment says this CDC can come
from the old peer of a reused DMB, so should it be processed at all?

smcd_cdc_rx_tsklet() passes the CDC here without checking its seqno, token
or source. smcd_cdc_msg_to_host() then overwrites local_rx_ctrl.prod, cons,
prod_flags and conn_state_flags unconditionally:

net/smc/smc_cdc.h:smcd_cdc_msg_to_host() {
    ...
	smc_curs_copy(&local->cons, &temp, conn);
	local->prod_flags = peer->cons.prod_flags;
	local->conn_state_flags = peer->cons.conn_state_flags;
}

Only the tx_curs_fin/sndbuf_space sync is skipped here. The connection may
still be in its CLC handshake, and the rest of smc_cdc_msg_recv_action()
still runs on the stale data:

- diff_cons is added to peer_rmbe_space
- diff_prod is added to bytes_to_rcv, and sk_data_ready() is called
- stale peer_conn_abort, peer_conn_closed or peer_done_writing flags set
  sk_err = ECONNRESET, RCV_SHUTDOWN and SOCK_DONE, and queue close_work

For an abort, smc_close_passive_abort_received() then moves the socket
from SMC_INIT to SMC_PROCESSABORT.

Can stale flags from an unrelated connection reset or close a connection
that is still in its handshake?

This also leaves a cursor mismatch behind. local_rx_ctrl.cons ends up at
the stale value X, while tx_curs_fin stays at {0,0}.
smcd_conn_save_peer_info() resets peer_rmbe_space but not
local_rx_ctrl.cons:

net/smc/af_smc.c:smcd_conn_save_peer_info() {
    ...
	atomic_set(&smc->conn.peer_rmbe_space, smc->conn.peer_rmbe_size);
    ...
}

The first real CDC from the new peer (cons Y) is then diffed against X:

- Same wrap and Y.count <= X.count: diff_cons is 0, and peer_rmbe_space
  stays below its real value from then on.
- Different wraps: peer_rmbe_space is credited past peer_rmbe_size, which
  breaks 0 <= peer_rmbe_space <= peer_rmbe_size.

In both cases peer_rmbe_space can no longer equal peer_rmbe_size. So this
check later in the function never fires:

	if (diff_cons && conn->urg_tx_pend &&
	    atomic_read(&conn->peer_rmbe_space) == conn->peer_rmbe_size) {

Would a MSG_OOB sender then block in smc_tx_sendmsg()->smc_tx_wait() until
a timeout or a signal?

The commit message says:

    The update's cursors and flags are still applied to the new
    connection, as those of a CDC that leaves the consumer cursor alone
    already are.

Is that comparison accurate? A CDC that leaves the consumer cursor alone
does not create a cons/tx_curs_fin mismatch.

A CDC that moves the consumer cursor before smcd_buf_attach() cannot come
from the real peer. That is the reasoning behind "Nothing of ours can have
been consumed before the attach".

Would it be better to drop such a CDC, or to stop reusing a DMB that a
previous peer can still signal, instead of applying part of it?

>  			/* Calculate consumed data and
>  			 * increment free send buffer space.
>  			 */
> -			diff_tx = smc_curs_diff(conn->sndbuf_desc->len,
> +			diff_tx = smc_curs_diff(sndbuf_desc->len,
>  						&conn->tx_curs_fin,
>  						&conn->local_rx_ctrl.cons);
>  			/* increase local sndbuf space and fin_curs */

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 9ef9019bc4974..982cfc79ee1cc 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -2654,9 +2654,10 @@ int smcd_buf_attach(struct smc_sock *smc)
>  	buf_desc->cpu_addr =
>  		(u8 *)buf_desc->cpu_addr + sizeof(struct smcd_cdc_msg);
>  	buf_desc->len -= sizeof(struct smcd_cdc_msg);
> -	conn->sndbuf_desc = buf_desc;
> -	conn->sndbuf_desc->used = 1;
> -	atomic_set(&conn->sndbuf_space, conn->sndbuf_desc->len);
> +	buf_desc->used = 1;
> +	atomic_set(&conn->sndbuf_space, buf_desc->len);
> +	/* Set last; pairs with the acquire in smc_cdc_msg_recv_action() */
> +	smp_store_release(&conn->sndbuf_desc, buf_desc);

[Severity: High]
Does this only close the window before attach? The old peer that still
holds the reused DMB token can keep signalling after this store.

Once sndbuf_desc is published, the new "if (sndbuf_desc)" branch in
smc_cdc_msg_recv_action() runs on the foreign consumer cursor:

	diff_tx = smc_curs_diff(sndbuf_desc->len,
				&conn->tx_curs_fin,
				&conn->local_rx_ctrl.cons);
	...
	atomic_add(diff_tx, &conn->sndbuf_space);

Right after attach, tx_curs_fin is {0,0} and sndbuf_space is len. A stale
cons X with X.wrap != 0 gives diff_tx = len + X.count, so sndbuf_space
becomes 2 * len + X.count.

Can sndbuf_space grow past sndbuf_desc->len this way? peer_rmbe_space
would be over-credited in the same way.

smc_tx_sendmsg() sizes its copy only from sndbuf_space:

net/smc/smc_tx.c:smc_tx_sendmsg() {
    ...
	copylen = min_t(size_t, send_remaining, writespace);
    ...
	chunk_len = copylen - chunk_len; /* remainder */
    ...
}

With prep.count == 0, the second chunk is len + X.count bytes, written at
offset 0.

Would memcpy_from_msg() then write X.count bytes of user data past the end
of the attached peer DMB? With CONFIG_HARDENED_USERCOPY this would hit a
usercopy_abort() BUG instead.

Smaller inflations would overwrite data that has not been consumed yet, and
tx_curs_fin would be left at the foreign baseline.

The underlying problem seems to be that a DMB is handed to a new
connection while a previous peer is still attached. smc_buf_unuse() only
does this:

	WRITE_ONCE(conn->rmb_desc->used, 0);

The token stays registered. __smc_buf_create()->smc_ism_set_conn() maps the
sba_idx to the new connection, so dibs_lo_move_data() delivers the old
peer's signals there.

One way to reach this: smc_listen_decline() calls smc_conn_abort() after
the client has already run smcd_buf_attach() and moved to SMC_ACTIVE.

Would it be better to stop reusing the DMB while a peer is attached, or to
drop signals that do not come from the current peer, instead of making the
receive path tolerate a NULL sndbuf_desc?

>  	return 0;
>  
>  free:

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261112-b4-disp-1c8d3a53-v6-0-36a38ae35021%40proton.me
