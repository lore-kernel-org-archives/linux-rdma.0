Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795580034;
	b=YmmzA8JVSHWzDWPVbEKEfTwKVgT7i8B+V4BFzWNhLeUr1sXMv7GAwbc1HgfW9PkNu2V3
	 VCmKlp2O8LME26pCt5UkqLWKHQDpiMzTT97xV9Ng3OvPDznEpeXq7B3iwcDvSy1Uv0Zta
	 SXXJ7SCR4qIzd/XHkrbm9inCy7+WjI4DBN4dNFgEu7nRDToEzWeXrv8jUYk0iA98l5yMT
	 CC7hygO29TdmmiEH63wbE0gCq5Vog6Ft3ikhdzZIiRxZi9f4GoG4EsSYQopC20flNcfvi
	 eETRB/I9W3lieImE+p8ibzv8xvIuizyCXo0WGnnnTb8+H6x11bPpC75hWVjw74d++eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795580034;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=I8asfb39p6p5NSJw6CjSmHtTXZ+4rJ4NmO7s5qq++Zg=;
	b=WxEMkaLh2xNhyQA3LqhGuyX4t+9106PzKKVLjfhf5r6choC4CF7HDqPP8SaSaLnQQtRG
	 Jb4EGVF6g/83hx/6WkwxluC9Ch1kDT3anWVYQRO2MQ2tpLHxWlHgCEcICBNhrbuOjnRwq
	 TaB//1YuhUa8127tJ3rXv/nMkENtpyZAFwD8xV3UNPr/8I9cl0H/S6MZn3anHaFD8tPUy
	 cs8qCZrRwGZ5yDV40jc6CHT5lKhupr3ZJ98+K3YzKDvdlV14sI3dNw9/qjbSMiXoT8ugT
	 +vVaulQp1rN/gEzA3Z76YaFhzEnjpqE0OBS9dKGqEu4C+eUMYV7r8EHCDTS9IsXG+WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IWxpbKAm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C751606A31E;
	Wed, 25 Nov 2026 04:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IWxpbKAm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90861F000C4;
	Wed, 25 Nov 2026 04:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795580033;
	bh=I8asfb39p6p5NSJw6CjSmHtTXZ+4rJ4NmO7s5qq++Zg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=IWxpbKAmZbp/Yu44MVMYJ7+kWoGC77cKt0xQmj5En8EgKFuU2KgQ8LWDfx5DUwFUo
	 w18UW65i6ZnokgSBCXbzly+nG8B+WL1QijrwS0mV5LGLf3VzfmM3GOKp1mR4At+rnu
	 YCknVbftBt6BWEXIkC4h59KeEYA54nHZ2xHzrhUZ38bXJ2ZHISxn7BxSwyn1+Grt+E
	 s96sTXmwzKfM6r3nBkiWibb9VcfsVTuuOcOr8M5zlgFbIzyZMu/BJeeNivk/NwAPk5
	 3CDrwAdk7Q4Y3jOfDumxAB3BCZN0PyOuDAnaldX+yZxIoGOGYXdtul+emi32gn48nY
	 QFlEBP3RQH0dA==
Subject: Re: [PATCH net] net/smc: validate peer CDC cursors against buffer
 bounds and window
From: netdev-bot+sashiko@kernel.org
To: goonsomeway@gmail.com
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org
Date: Wed, 25 Nov 2026 04:13:52 +0000
Message-ID: <179558003243.3135.18081882180984108427@kernel.org>
In-Reply-To: <CA+OT+ON4Lt9mLvWPK8rUaHKZ01_p0fGCiCsWHwXWzT1sGaTtLA@mail.gmail.com>
References: <CA+OT+ON4Lt9mLvWPK8rUaHKZ01_p0fGCiCsWHwXWzT1sGaTtLA@mail.gmail.com>
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] net/smc: valid initial CDC messages dropped in
  smc_cdc_msg_recv_action()
- [Medium] smc_cdc_msg_recv_action() (net/smc/smc_cdc.c) adds a new
  check, `diff_cons > peer_rmbe_size - atomic_read(&peer_rmbe_space)`,…
- [Medium] Before the patch, smcr_cdc_msg_to_host() wrote
  conn->local_rx_ctrl.seqno for every CDC that reached…

--

net/smc: validate peer CDC cursors against buffer bounds and window

This commit decodes incoming CDC messages into a temporary
smc_host_cdc_msg. It checks the prod/cons cursor offsets and deltas
against rmb_desc->len, peer_rmbe_size and, for dmb_nocopy,
sndbuf_desc->len. Only then does it commit the update to
conn->local_rx_ctrl, and messages that fail the checks are dropped.

> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index 32d6d03df3214..fd5e296e8becb 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -332,14 +332,48 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
>  {
>  	union smc_host_cursor cons_old, prod_old;
>  	struct smc_connection *conn = &smc->conn;
> -	int diff_cons, diff_prod, diff_tx;
> +	struct smc_host_cdc_msg rx_ctrl = {};
> +	int diff_cons, diff_prod, diff_tx = 0;
>  
>  	smc_curs_copy(&prod_old, &conn->local_rx_ctrl.prod, conn);
>  	smc_curs_copy(&cons_old, &conn->local_rx_ctrl.cons, conn);
> -	smc_cdc_msg_to_host(&conn->local_rx_ctrl, cdc, conn);
> +	rx_ctrl.prod = prod_old;
> +	rx_ctrl.cons = cons_old;
> +	smc_cdc_msg_to_host(&rx_ctrl, cdc, conn);
> +
> +	if (rx_ctrl.prod.count >= conn->rmb_desc->len ||
> +	    rx_ctrl.cons.count >= conn->peer_rmbe_size)
> +		return;
>  
>  	diff_cons = smc_curs_diff(conn->peer_rmbe_size, &cons_old,
> -				  &conn->local_rx_ctrl.cons);
> +				  &rx_ctrl.cons);
> +	if (diff_cons > conn->peer_rmbe_size - atomic_read(&conn->peer_rmbe_space))
> +		return;

[Severity: High]
Can this check drop a valid CDC from a well-behaved client while the
listening side is still finishing the CLC handshake?

On the server, smc_listen_work() calls smc_rx_init() and
smc_listen_find_device() before sending the accept. That allocates
conn->rmb_desc and makes the connection reachable for incoming CDC
messages, via smc_ism_set_conn() for SMC-D or smc_lgr_register_conn()
and smcr_lgr_reg_rmbs() for SMC-R. Only after that does
smc_clc_send_accept() send SMC_CLC_ACCEPT.

conn->peer_rmbe_size is still 0 at that point. It is only set by
smc_conn_save_peer_info(). That runs after smc_clc_wait_msg() has
received SMC_CLC_CONFIRM and smc_listen_rdma_finish() has completed.

The client does not wait for that. smc_connect_rdma() and
smc_connect_ism() send SMC_CLC_CONFIRM over the clcsock, move the
socket to SMC_ACTIVE and return from connect(). If the application
sends right away, the first CDC carries prod.count > 0 and
cons.count == 0.

On the server that CDC is handled by smc_cdc_msg_recv() under
bh_lock_sock(). This can run while smc_listen_work() still holds
lock_sock() on new_smc; commit 5607016cd1bbe documents this window.

Before this patch the CDC was handled correctly. cons_old and the new
cons were both 0, so diff_cons was 0, and diff_prod was computed
against rmb_desc->len, which is already valid. With the new check,
rx_ctrl.cons.count >= conn->peer_rmbe_size evaluates 0 >= 0 as true and
the whole message is dropped.

That loses the prod advance into bytes_to_rcv. It also loses any
prod_flags or conn_state_flags in the same CDC, such as
peer_done_writing or peer_conn_closed. A delivered RDMA/ISM CDC is not
retransmitted. So a client that sends a request and waits for the
reply, or sends and closes, can leave the server stuck in recvmsg().

Should the peer_rmbe_size based checks be skipped while peer_rmbe_size
is still unset? Or would it be better to make sure the peer info is
saved before the connection can receive CDCs at all?

[Severity: Medium]
Can this check reject a legitimate CDC from a well-behaved peer during an
SMC-R link failover?

The check assumes peer_rmbe_space always matches what the peer has
received. In net/smc/smc_core.c, smc_switch_cursor() rewinds the prod
cursor to local_tx_ctrl_fin and then recomputes the space:

net/smc/smc_core.c:smc_switch_cursor() {
    ...
	smc_curs_copy(&fin, &conn->local_tx_ctrl_fin, conn);
	/* set prod cursor to old state, enforce tx_rdma_writes() */
	smc_curs_copy(&conn->local_tx_ctrl.prod, &fin, conn);
	smc_curs_copy(&cons, &conn->local_rx_ctrl.cons, conn);

	if (smc_curs_comp(conn->peer_rmbe_size, &cons, &fin) < 0) {
		/* cons cursor advanced more than fin, and prod was set
		 * fin above, so now prod is smaller than cons. Fix that.
		 */
    ...
	/* recalculate, value is used by tx_rdma_writes() */
	atomic_set(&smc->conn.peer_rmbe_space, smc_write_space(conn));
    ...
}

smc_cdc_tx_handler() only advances local_tx_ctrl_fin on a successful
completion. After a link failure it can therefore lag behind what the
peer actually holds. The existing "cons cursor advanced more than fin"
branch shows the code already expects this.

After the switch, peer_rmbe_space is size - (fin - C0), where C0 is the
current local_rx_ctrl.cons. Suppose the peer then sends a CDC on the new
link with cons = C1 and fin < C1. This could be its own post-failover
CDC. If it arrives before our tx_work retransmits, diff_cons = C1 - C0 is
larger than peer_rmbe_size - peer_rmbe_space, and the whole message is
dropped.

That CDC's prod advance, prod_flags and conn_state_flags
(peer_done_writing, peer_conn_closed, peer_conn_abort) would be lost. The
peer saw a successful completion, so it won't resend.

Could the connection then hang, waiting for data or a close that was
already delivered? Before this patch, this CDC was applied.

There also seems to be a second variant. smc_switch_cursor() runs from
the link-down worker:

smcr_link_down()->smc_switch_conns()->smc_switch_cursor()

It holds only spin_lock_bh(&conn->send_lock), not bh_lock_sock(). So it
can run at the same time as smc_cdc_msg_recv_action() on the new link.
Below, the rx path commits the new cons:

	smc_curs_copy(&conn->local_rx_ctrl.cons, &rx_ctrl.cons, conn);

This happens before the later atomic_add(diff_cons,
&conn->peer_rmbe_space). If smc_switch_cursor() runs in that window, it
reads C1 and sets peer_rmbe_space with atomic_set(). The rx path then
adds C1 - C0 on top, so peer_rmbe_space ends up above peer_rmbe_size.

The double count existed before this patch. With the new check, though,
peer_rmbe_size - atomic_read(&conn->peer_rmbe_space) becomes negative,
and the check fires even when diff_cons == 0.

Would every later CDC (data, flags, close/abort) then be dropped until
local transmissions bring peer_rmbe_space back down? That never happens
if the local side has nothing to send.

> +
> +	if (diff_cons && conn->lgr->is_smcd &&
> +	    smc_ism_support_dmb_nocopy(conn->lgr->smcd)) {
> +		if (rx_ctrl.cons.count >= conn->sndbuf_desc->len)
> +			return;
> +		diff_tx = smc_curs_diff(conn->sndbuf_desc->len,
> +					&conn->tx_curs_fin, &rx_ctrl.cons);
> +		if (diff_tx > conn->sndbuf_desc->len - atomic_read(&conn->sndbuf_space))
> +			return;
> +	}
> +
> +	diff_prod = smc_curs_diff(conn->rmb_desc->len, &prod_old,
> +				  &rx_ctrl.prod);
> +	if (diff_prod > conn->rmb_desc->len - atomic_read(&conn->bytes_to_rcv))
> +		return;
> +
> +	conn->local_rx_ctrl.common.type = rx_ctrl.common.type;
> +	conn->local_rx_ctrl.len = rx_ctrl.len;
> +	conn->local_rx_ctrl.seqno = rx_ctrl.seqno;

[Severity: Medium]
Before this patch, smcr_cdc_msg_to_host() updated
conn->local_rx_ctrl.seqno for every CDC that reached
smc_cdc_msg_recv_action(). Now seqno is committed only after all the
cursor checks pass, so each early return above leaves it stale.

How does this interact with failover validation?
smc_cdc_msg_validate() treats local_rx_ctrl.seqno as the last delivered
CDC:

net/smc/smc_cdc.c:smc_cdc_msg_validate() {
    ...
	/* check that seqnum was seen before */
	diff = conn->local_rx_ctrl.seqno - recv_seq;
	if (diff < 0) { /* diff larger than 0x7fff */
		/* drop connection */
		conn->out_of_sync = 1;	/* prevent any further receives */
    ...
}

The peer sets recv_seq in smcr_cdc_msg_send_validation():

	peer->seqno = htons(conn->tx_cdc_seq_fin); /* seqno last compl. tx */

Here, a CDC that was delivered but rejected by the new checks looks like
a lost message. If the next failover validation arrives before an
accepted CDC refreshes seqno, the connection is aborted with out_of_sync
and peer_conn_abort.

In the peer_rmbe_space > peer_rmbe_size case above, seqno would never
advance, so any later failover would abort the connection.

Would it make sense to advance local_rx_ctrl.seqno even when cursor
validation fails?

> +	conn->local_rx_ctrl.token = rx_ctrl.token;
> +	smc_curs_copy(&conn->local_rx_ctrl.prod, &rx_ctrl.prod, conn);
> +	smc_curs_copy(&conn->local_rx_ctrl.cons, &rx_ctrl.cons, conn);
> +	conn->local_rx_ctrl.prod_flags = rx_ctrl.prod_flags;
> +	conn->local_rx_ctrl.conn_state_flags = rx_ctrl.conn_state_flags;
> +

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/CA%2BOT%2BON4Lt9mLvWPK8rUaHKZ01_p0fGCiCsWHwXWzT1sGaTtLA%40mail.gmail.com
