Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795529661;
	b=B3Brwjdda+ZwN8G+RD4mql3Lje3S0wPhC0ImOZo9chl+DrkRw6lvNxxkFvXh4ssVhMgv
	 1SGGQp8JjfkAVUdcL5DE5UChC6tZohWhMruqSJsQ40nGZMW/6gr2KEkzLAjitjf9PhYbY
	 KvCCDy2i58tq+GGA+4VtSP9uK48rVnWXPDumEBFeynFhC/nS8p1NsjhitQ52QX9uF4F4t
	 ah7IeZM4ZD3mqM8ukOFYITm+9P5L4kMVFJnQlv6vtOuuhRG5AAOeCfvJdtOdJ/zniofui
	 9Um3GrQ/2dMq5WFg9m9umOZTJUg64Arb7fo7zV2Rjo37DD6ExJ0OdWJMAr9j255/PtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795529661;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=LvJWJlf5iq1bxTZ/Pi7wnqUYZw6hL5app7P3pS/MwcY=;
	b=dHsm5ibZMom+RU6fwMEb1PxZnRcCM2GVHu5oQ5FQkWDtuE0CXjgG7F3CPid6u0EMqImm
	 VgmKZjAdayZHYgweQrrSuxeX2zNGM8oEUkjbbNZu2nbmXjETB2++SOf5OQN6XBcmpEqAk
	 fs22KEItQCE/modhJ30xBNRIrPb4zyyEyqW7tXSp0l1kstkqjm/tEKtHe0vy232NGxMbO
	 Pi/vGqRGRJvwITN+hdhWBid5Wz5zYEj+XQJwThScgH21vVUfBJLg2ZTvJ8MkMM7ej3PCR
	 XFJszthixJtyPNNkWyNF5igUIj9MHZZrrJbjSIez7X/TFEEF785+9nj4FABDMb5Fx2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aEfj7T8Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0786606A321;
	Tue, 24 Nov 2026 14:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aEfj7T8Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7501F000D2;
	Tue, 24 Nov 2026 14:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529660;
	bh=LvJWJlf5iq1bxTZ/Pi7wnqUYZw6hL5app7P3pS/MwcY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=aEfj7T8Q1koa+ivp6riQSUXgnghMoIf8OrXc18aP+SnH9YPunS31TqKlIca2tcrQO
	 ZN+KFI4NyZTpdVZdPJJaqfrC6WW8eObQevwGWRcdxVAxHrjNiME5wa3fSQyRyvwEIq
	 6VFWSmLDQh8jJisv0KKaA6R6gWhCRf5gKjegRoAZiep1PQkZ1ah4iofTKlbPys8WdI
	 Gq2byWrBdw/k0lx2jFEp73wx9YJ8RSdR0k/vHjGgZO1tKTseYqm6nyIQ3y+sseAwjk
	 dG980EP41GAHloUklPP53zRbiW8iTic8zlSFtyewARrALVxCEcH8VUJ7+FCZmfKiYr
	 Q3WTnEqckC9OQ==
Subject: Re: [PATCH net v2 1/2] net/smc: bound the failover cursor catch-up by
 what is outstanding
From: netdev-bot+sashiko@kernel.org
To: piyus@iiitd.ac.in
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, netdev@vger.kernel.org,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
 kapil@presceralabs.ai, stable@vger.kernel.org, kuba@kernel.org
Date: Tue, 24 Nov 2026 14:14:19 +0000
Message-ID: <179552965941.3135.8878591105354373466@kernel.org>
In-Reply-To: <20261123135327.3953509-1-piyus@iiitd.ac.in>
References: <20261123135327.3953509-1-piyus@iiitd.ac.in>
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

Critical: 0 · High: 1 · Medium: 0 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The new bound in smc_switch_cursor() reads sndbuf_space, then
  advances tx_curs_fin and sndbuf_space.
- [Low] In smc_switch_cursor() (net/smc/smc_core.c:1080-1081), the new
  bound is stored in a variable named `sent`, and the comment calls it…
- [Low] When the new clamp in smc_switch_cursor() lowers diff below the
  cons - fin gap the peer reported, local_tx_ctrl.prod and…

--

net/smc: bound the failover cursor catch-up by what is outstanding

This commit clamps the diff that smc_switch_cursor() uses to advance
tx_curs_sent and tx_curs_fin and to credit sndbuf_space during SMC-R link
failover. The bound is sndbuf_desc->len - sndbuf_space. The goal is to stop
a forged peer consumer cursor from pushing sndbuf_space past the send
buffer size, which leads to an out-of-bounds write in smc_tx_sendmsg().

Link: https://lore.kernel.org/all/20261122053223.2497832-2-piyus@iiitd.ac.in/

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index a3164201c1420..436a702f3d8de 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c

[ ... ]

> @@ -1069,6 +1070,16 @@ static int smc_switch_cursor(struct smc_sock *smc, struct smc_cdc_tx_pend *pend,
>  		 * fin above, so now prod is smaller than cons. Fix that.
>  		 */
>  		diff = smc_curs_diff(conn->peer_rmbe_size, &fin, &cons);
> +		/* The peer's consumer cursor is taken as it arrives, so this
> +		 * difference is a value the peer chose.  An honest peer cannot
> +		 * have consumed more than this side has outstanding, so bound
> +		 * the catch-up by that: sndbuf_space then keeps the invariant
> +		 * the tx path relies on, and the cursors advanced below stay
> +		 * within the send buffer.
> +		 */
> +		sent = conn->sndbuf_desc->len - atomic_read(&conn->sndbuf_space);
> +		diff = min_t(int, diff, max_t(int, sent, 0));
> +

[Severity: High]

Does this bound keep sndbuf_space <= sndbuf_desc->len on the DELETE_LINK
path, given that the old link's CDC completions can still run?

smc_switch_conns() calls smc_switch_cursor() with only conn->send_lock
held:

	spin_lock_bh(&conn->send_lock);
	smc_switch_link_and_count(conn, to_lnk);
	rc = smc_switch_cursor(smc, pend, wr_buf);
	spin_unlock_bh(&conn->send_lock);

CDC send completions on the old link go through smc_cdc_tx_handler(),
which holds only bh_lock_sock():

	bh_lock_sock(&smc->sk);
	if (!wc_status && sndbuf_desc) {
		diff = smc_curs_diff(sndbuf_desc->len,
				     &cdcpend->conn->tx_curs_fin,
				     &cdcpend->cursor);
		...
		atomic_add(diff, &cdcpend->conn->sndbuf_space);
		...
		smc_curs_copy(&conn->tx_curs_fin, &cdcpend->cursor, conn);

In smc_llc_process_cli_delete_link(), the old QP is still live when the
connections are switched. It is moved to error and drained only later, in
smcr_link_clear():

	if (smc_link_downing(&lnk_del->state))
		smc_switch_conns(lgr, lnk_del, false);
	smcr_link_clear(lnk_del, true);

So completions for CDCs already posted on the old QP can run during or
after smc_switch_cursor().

In the concurrent case, smc_switch_cursor() snapshots sent as
prep - fin_old. The old-link handler then credits C - fin_old and sets
tx_curs_fin to C. smc_switch_cursor() then credits up to prep - fin_old
more and adds diff to the tx_curs_fin that has already moved. The total
credit is more than prep - fin_old.

In the late completion case, a peer forges cons so that the clamp moves
tx_curs_fin all the way to prep. A completion for an older cursor C then
arrives on the old QP. If C.wrap != prep.wrap, smc_curs_diff() looks only
at the wraps:

	if (old->wrap != new->wrap)
		return max_t(int, 0,
			     ((size - old->count) + new->count));

It returns (len - prep.count) + C.count, which is larger than len, so
sndbuf_space moves toward 2 * len. If the wraps are equal, the credit is 0
but tx_curs_fin moves back to C. The next completion on the new link then
credits prep - C again.

Either way sndbuf_space ends up above sndbuf_desc->len. The second chunk
in smc_tx_sendmsg() then writes past the send buffer:

	rc = memcpy_from_msg(sndbuf_base + chunk_off,
			     msg, chunk_len);

The commit message says:

  For a lying one sndbuf_space keeps the invariant that
  smc_tx_sendmsg(), smc_tx_prepared_sends() and SIOCOUTQ in smc_ioctl()
  all depend on

Does that still hold on this path? The follow-up patch "net/smc: bound the
DMB-nocopy send-buffer credit as well" only changes the SMC-D DMB-nocopy
credit in smc_cdc_msg_recv_action(), so it doesn't cover this case.

Do the old link's TX completions also need to be quiesced or serialized
with the switch? Two options: drain them before smc_switch_cursor(), or
take the same lock and ignore completions whose cursor is behind
tx_curs_fin.

[Severity: Low]

Is sent the right name for this value? Does "what this side has
outstanding" in the comment describe it accurately?

sndbuf_desc->len - sndbuf_space is the amount prepared but not yet
confirmed (tx_curs_prep - tx_curs_fin). smc_tx_sendmsg() lowers
sndbuf_space when data is copied in, not when it is RDMA-written:

	atomic_sub(copylen, &conn->sndbuf_space);

The real pre-switch send position is already lost at this point, because
smc_switch_cursor() starts with:

	smc_curs_copy(&conn->tx_curs_sent, &conn->tx_curs_fin, conn);

So a lying peer can still move tx_curs_sent and tx_curs_fin up to
tx_curs_prep. Bytes that sendmsg() accepted but never wrote are then
counted as confirmed and never sent. The clamp also hides the protocol
violation: out_of_sync is not set and the connection is not aborted.

Without a race, sndbuf_space and the cursors stay in range. But the
variable name, the comment, and the commit message's "bound the catch-up
by what is outstanding" all describe a tighter bound than the code
applies. Could they be adjusted to match?

>  		smc_curs_add(conn->sndbuf_desc->len,
>  			     &conn->tx_curs_sent, diff);
>  		smc_curs_add(conn->sndbuf_desc->len,

[Severity: Low]

When the clamp makes diff smaller than the cons - fin gap the peer
reported, where does local_tx_ctrl.prod end up?

prod was set to fin earlier, and this branch runs only when cons > fin.
Further down, prod and local_tx_ctrl_fin move forward only by the clamped
diff:

	smc_curs_add(conn->peer_rmbe_size,
		     &conn->local_tx_ctrl.prod, diff);
	smc_curs_add(conn->peer_rmbe_size,
		     &conn->local_tx_ctrl_fin, diff);

That leaves prod behind local_rx_ctrl.cons, which is the state the
existing "now prod is smaller than cons. Fix that." comment says this
block repairs.

The next statement recomputes peer_rmbe_space from that inverted pair:

	atomic_set(&smc->conn.peer_rmbe_space, smc_write_space(conn));

and smc_write_space() computes:

	space = buffer_len - smc_curs_diff(buffer_len, &cons, &prod);

If the wraps are equal, smc_curs_diff() returns 0 and peer_rmbe_space
becomes peer_rmbe_size. If cons.wrap == prod.wrap + 1, it returns
(size - cons.count) + prod.count. For example, size=100, prod=(0,90) and
cons=(1,10) give space = -80.

With a negative peer_rmbe_space, smc_tx_rdma_writes() returns early on
every call:

	if (rmbespace <= 0) {

Later CDCs in smc_cdc_msg_recv_action() only add diff_cons on top of that
wrong base, so the value never recovers and the connection stops sending.

Should the clamp firing be treated as a protocol violation that aborts the
connection, rather than continuing with inconsistent flow-control state?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261123135327.3953509-1-piyus%40iiitd.ac.in
