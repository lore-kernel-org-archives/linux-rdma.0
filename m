Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794834042;
	b=mckszZSp6mYH2eI6X2PHgm5uhLGKm7JC3Xfl3rBDc89qf6oyYJuKEVixPPcOvCuw0iC7
	 dgisBtj6KDP8MIg5NHxadvyq8xPpmV6GXG4bVd6Wu6asw+j0AXYFH99FcqvedBTmZIB+c
	 cWUuyosNRj9n4WK5bxSafE+szeH/kzhZOz7X5xOpI53tkQcFGzOm3fsP4F49f7XkQUZwl
	 NNlVGWWg/Xl+3zAJZA9o4iH2bxh+3nvK1zPJKsDh1VGWi5sxMW1nrUGWC2uTDRAUcHDTr
	 iNF3PA1swqnkByCnw1M8RqId6f8HalH1ZeV+bnKSo/rxnT/GtS1fyzoaBURvJemOqzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794834042;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=2TZLMAsBY01rsX8eNwnqsqym18bF2UipclSo0VlodOI=;
	b=Q9bUmmsMnVHY6NMEGfFOADQ0EWTI/EDzxMoY0JMWvhPhJORGcS8kNwd9DB3eiaUJ2Z3S
	 jVjrEo4kt3jiT1NyVNQ+WKBP5Beh/mczNPUuY5oj6NUwqcnLmcmJUcyPT2MqswAbDGYhJ
	 JG42DoQr6mmD+yLElZvRWyj+fv0LUz5Po5SaUHYTgwWqSfhKEFzSv99Sd82HfdgAtrLxO
	 X7h3ePD4U4cv6sMEeSdsgUsyAUkVolA0koP/05Qtrj4gyGqx+kBmJXyoy3blHRU2ZtUvA
	 ewtM1I2RCyF/t+Bhngtn2Qh4vCsBPrbiAat3K/DCLzUWn4PJzcv5BirVXjDBq4O7JEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AUMVnwgR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7239606A329;
	Mon, 16 Nov 2026 13:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AUMVnwgR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583091F000C5;
	Mon, 16 Nov 2026 13:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794834042;
	bh=2TZLMAsBY01rsX8eNwnqsqym18bF2UipclSo0VlodOI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=AUMVnwgR+hKHIQQxOpGF+wnYwseylBD2WS3Av85Y1LUn8cm0rrMHUrl7bbOCmzAl3
	 URm+z5WxO4qTa0mqv6qeqtASQwT8JaZdZ7XVZFE7PqEgi+nIz2zexLMcuoJqJjAStW
	 DjZEDqH/5cb1a2mJWDxt2oOuR8vKWwQCJosGgit9AgHVXD65K27/oG9yqiMl5UwEjS
	 eHElu1aja56l49wrtJuGwIt+AIWq3ecPVN9YDqPqSpM7pGLmb5amFEf8Ps+apsRK6a
	 +C/7l1RDo2jezwYsKgjWx834MzVL8XmstDpcJGQLCt9gJy3Zj2PuV5z4aILFUylF2J
	 ve7OIvs9ieLEQ==
Subject: Re: [PATCH net v9 6/6] net/smc: bound the link failover cursor
 advance to the send buffer
From: netdev-bot+sashiko@kernel.org
To: hexlabsecurity@proton.me
Cc: mjambigi@linux.ibm.com, dust.li@linux.alibaba.com, edumazet@kernel.org,
 pabeni@redhat.com, davem@davemloft.net, kuba@kernel.org,
 alibuda@linux.alibaba.com, sidraya@linux.ibm.com, ubraun@linux.ibm.com,
 wenjia@linux.ibm.com, raspl@linux.ibm.com, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, guwen@linux.alibaba.com,
 tonylu@linux.alibaba.com, horms@kernel.org, guangguan.wang@linux.alibaba.com,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org, hidayath@linux.ibm.com
Date: Mon, 16 Nov 2026 13:00:40 +0000
Message-ID: <179483404089.3136.10183363109829653220@kernel.org>
In-Reply-To: <20261112-b4-disp-0287c16e-v9-6-e5e8fa688177@proton.me>
References: <20261112-b4-disp-0287c16e-v9-6-e5e8fa688177@proton.me>
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

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 2 (1) · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] smc_switch_cursor() in net/smc/smc_core.c can now move
  tx_curs_fin backwards, so the same send-buffer bytes get credited to…
- [High] smc_switch_cursor() and smc_cdc_tx_handler() share no lock, and
  the patch's "set them, do not add" change does not close the race the…
- [Medium] The permanent commit message does not mention that the patch
  adds a new route to double-crediting sndbuf_space.
- [Medium] The new cap in smc_switch_cursor() can leave
  local_tx_ctrl.prod behind the peer's local_rx_ctrl.cons.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the patch
  rewrites the very condition that depends on it.

--

net/smc: bound the link failover cursor advance to the send buffer

During SMC-R link failover, this patch limits the cursor advance in
smc_switch_cursor() in two ways. The peer consumer cursor count must be
inside the peer's RMBE, and the advance can go no further than
tx_curs_prep. tx_curs_fin and local_tx_ctrl_fin are now set from the
advanced cursors rather than having diff added to them.

> "net/smc: keep an RDMA write inside the peer's RMBE" to bound it. Set
> tx_curs_fin and local_tx_ctrl_fin from the advanced cursors instead of
> adding to them: smc_cdc_tx_handler() can rewrite both while the switch
> runs. The switch is still not serialized against the handler: a
> completion handled inside it is still credited more than once and can
> make the next write hand the peer bytes it has already read.

[Severity: Medium]
Is "still credited more than once" accurate here? It reads as if nothing
changed. The v9 notes below the cut line say something different:

  v9 only: the first case under 4/6 ends with sndbuf_space 1200 bytes
  over the buffer, against 600 on unpatched and v8. v9 sets tx_curs_fin
  back to tx_curs_sent, and the next old-link completion, when it is
  handled before the validation message's, credits those 600 once more.

git am drops those notes. The commit message that lands in the tree
never says that the new smc_curs_copy() into tx_curs_fin can move
tx_curs_fin backwards, which is a second way to over-credit
sndbuf_space.

Could the changelog say that in this completion ordering the over-credit
gets larger than before?

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 0edbe6106c1ab..b5625f1a8792c 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c

[ ... ]

> @@ -1043,16 +1043,22 @@ static int smc_switch_cursor(struct smc_sock *smc, struct smc_cdc_tx_pend *pend,
>  	/* set prod cursor to old state, enforce tx_rdma_writes() */
>  	smc_curs_copy(&conn->local_tx_ctrl.prod, &fin, conn);
>  	smc_curs_copy(&cons, &conn->local_rx_ctrl.cons, conn);
> -
> -	if (smc_curs_comp(conn->peer_rmbe_size, &cons, &fin) < 0) {
> -		/* cons cursor advanced more than fin, and prod was set
> -		 * fin above, so now prod is smaller than cons. Fix that.
> +	smc_curs_copy(&prep, &conn->tx_curs_prep, conn);
> +
> +	if (cons.count < conn->peer_rmbe_size &&
> +	    smc_curs_comp(conn->peer_rmbe_size, &cons, &fin) < 0) {

[Severity: High]
This is a pre-existing issue and was not introduced by this patch, but
since this patch rewrites the condition: does smc_curs_comp() handle the
u16 wrap counter rolling over?

net/smc/smc_cdc.h:smc_curs_comp() {
	if (old->wrap > new->wrap ||
	    (old->wrap == new->wrap && old->count > new->count))
		return -smc_curs_diff(size, new, old);
	return smc_curs_diff(size, old, new);
}

Other code does handle the rollover. smc_cdc_cursor_to_host() has:

	if ((old.wrap > temp.wrap) && temp.wrap)
		return;

and smc_curs_diff_large() has a branch for the wrap going from 0xffff to
0x0000.

Say failover happens with fin = (65535, X) and a conforming peer's
cons = (0, Y). Then smc_curs_comp(size, &cons, &fin) returns a value
>= 0, the catch-up is skipped and prod stays at fin. smc_write_space()
then returns Y - X.

If Y > X, the next smc_tx_rdma_writes() writes at RMBE offset X and
advertises prod = (65535, X + len). The peer's smc_cdc_cursor_to_host()
accepts the step from wrap 0 back to 65535. diff_prod in
smc_cdc_msg_recv_action() then comes out wrong and bytes_to_rcv is
inflated.

Can the peer application then read stale or duplicated RMBE data? If
Y < X, peer_rmbe_space goes negative and the connection stalls instead.

> +		/* cons cursor advanced more than fin, and prod was set fin
> +		 * above: catch up. cons comes off the wire, so only for a
> +		 * count inside the peer's RMBE and no further than
> +		 * tx_curs_prep. smc_cdc_tx_handler() is not excluded and can
> +		 * rewrite the fin cursors meanwhile: set them, do not add.
>  		 */

[Severity: High]
Does "set them, do not add" handle the handler rewriting the fin
cursors? smc_switch_conns() takes only send_lock around the switch:

net/smc/smc_core.c:smc_switch_conns() {
    ...
			spin_lock_bh(&conn->send_lock);
			smc_switch_link_and_count(conn, to_lnk);
			rc = smc_switch_cursor(smc, pend, wr_buf);
			spin_unlock_bh(&conn->send_lock);
    ...
}

smc_cdc_tx_handler() updates the same fields while holding only the
socket spinlock:

net/smc/smc_cdc.c:smc_cdc_tx_handler() {
    ...
	bh_lock_sock(&smc->sk);
	if (!wc_status && sndbuf_desc) {
		diff = smc_curs_diff(sndbuf_desc->len,
				     &cdcpend->conn->tx_curs_fin,
				     &cdcpend->cursor);
		...
		atomic_add(diff, &cdcpend->conn->sndbuf_space);
		...
		smc_curs_copy(&conn->tx_curs_fin, &cdcpend->cursor, conn);
		smc_curs_copy(&conn->local_tx_ctrl_fin, &cdcpend->p_cursor,
			      conn);
    ...
}

smc_wr_tx_process_cqe() calls the handler for successful old-link
completions without checking link state. The handler can therefore run
on another CPU while smc_switch_cursor() runs. These interleavings still
look reachable after this patch:

- A completion handled between the first two smc_curs_copy() calls in
  smc_switch_cursor() leaves tx_curs_sent from the older completion and
  fin/prod from the newer one. The next RDMA write then hands the peer
  bytes it already has. The v9 notes show the peer reading 600 bytes
  twice.

- A completion handled between the snapshot and the atomic_add() into
  sndbuf_space gets credited by the handler and again by the switch. The
  v9 notes show sndbuf_space at 77536 for a 65536-byte buffer.

- The handler reads tx_curs_fin, the switch stores T0 + diff, and the
  handler then stores its older cursor over it.

Would taking the socket spinlock outside send_lock in smc_switch_conns()
close this? That would match the existing order in
smc_cdc_tx_handler()->smc_tx_pending()->smcr_tx_sndbuf_nonempty(), where
send_lock is taken under the socket spinlock.

> -		diff = smc_curs_diff(conn->peer_rmbe_size, &fin, &cons);
> +		diff = min(smc_curs_diff(conn->peer_rmbe_size, &fin, &cons),
> +			   smc_curs_diff(conn->sndbuf_desc->len,
> +					 &conn->tx_curs_sent, &prep));

[Severity: Medium]
Can the capped diff leave local_tx_ctrl.prod behind the peer's cons and
make peer_rmbe_space negative? The guard checks only cons.count. It does
not check how many wraps cons is ahead of fin.

Take peer_rmbe_size = 16384, fin = (w, 5000) and a forged
cons = (w + 1, 6000). smc_cdc_cursor_to_host() accepts that cons, and
smc_curs_comp() returns -17384, so the branch is taken. With 2000 bytes
prepared, diff = 2000 and prod becomes (w, 7000). Then:

smc_write_space() {
	...
	space = buffer_len - smc_curs_diff(buffer_len, &cons, &prod);
	...
}

returns 16384 - ((16384 - 6000) + 7000) = -1000, which is stored by:

	atomic_set(&smc->conn.peer_rmbe_space, smc_write_space(conn));

Before this patch the uncapped diff put prod right on cons, so the space
came out as peer_rmbe_size.

smc_cdc_msg_recv_action() documents "guarantee 0 <= peer_rmbe_space <=
peer_rmbe_size". smc_tx_rdma_writes() treats rmbespace <= 0 as no space.
If the peer has already consumed everything, cons never moves again.
Does the connection stall permanently in that case?

Later diff_cons additions would also start from the wrong baseline. The
urgent-data check against peer_rmbe_size in smc_cdc_msg_recv_action()
would then never fire.

A conforming peer might reach the same state if the handler's two
stores straddle the switch's two loads while cons is across an RMBE wrap
from prod. That case is speculative.

>  		smc_curs_add(conn->sndbuf_desc->len,
>  			     &conn->tx_curs_sent, diff);
> -		smc_curs_add(conn->sndbuf_desc->len,
> -			     &conn->tx_curs_fin, diff);
> +		smc_curs_copy(&conn->tx_curs_fin, &conn->tx_curs_sent, conn);

[Severity: High]
Can this move tx_curs_fin backwards and credit the same bytes to
sndbuf_space twice?

Here tx_curs_sent is T0 + diff. T0 is the tx_curs_fin snapshot taken at
the top of smc_switch_cursor():

	smc_curs_copy(&conn->tx_curs_sent, &conn->tx_curs_fin, conn);

Suppose smc_cdc_tx_handler() runs on another CPU after that snapshot. It
credits T1 - T0 to sndbuf_space and stores tx_curs_fin = T1. In the
normal catch-up case cons lies between fin and that completion's
p_cursor, so T0 + diff <= T1.

This copy then moves tx_curs_fin back to T0 + diff, and the atomic_add()
that follows adds diff. The next old-link completion, with cursor T2,
credits T2 - (T0 + diff). The total credit is (T2 - T0) + (T1 - T0), so
T1 - T0 is counted twice.

In the same ordering, the smc_curs_add() this replaces left tx_curs_fin
at T1 + diff, for a total of T2 - T0.

local_tx_ctrl_fin is rewound the same way by the smc_curs_copy() from
local_tx_ctrl.prod further down.

With sndbuf_space over-credited, smc_tx_sendmsg() can overwrite bytes in
[tx_curs_sent, tx_curs_prep) that have not been sent yet, even with the
send length clamp from the earlier patch in the series. The v9 notes
measure 1200 bytes over the buffer in this case, against 600 unpatched.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261112-b4-disp-0287c16e-v9-0-e5e8fa688177%40proton.me
