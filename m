Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793643876;
	b=mbcjl98RDUlAFh7LqVYF9FO3NkaFQzrxCHZYRvyqsw/yGIf+XHG47QVNS09jZjgQm2Hs
	 c7Ec5wn4/cNSUDHRYutaXbKc40k9PWciYhDn4wXZaJYkDfD4+dcyLpi9p6Or9zl7ekCpc
	 dGQQhBTmy8KEnSWMAT90mpJr2PQVQyxhpFOo61XFhHpiZ/P9LHfbVQQcRHz1cZKMlTjkN
	 w8ynEb+gUP90KVqEGiMLpi93XEQSPlMxo52NS1QdWc6hLnLJ1G8zzblcbuoBBaUpQyXt2
	 OPlGH57pALLil9H/QPoEypXAme2DbyeBeJc5qG/33FP+24KgHeuYx2nJGC2HmblK2Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793643876;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=ASxeBkPjSzVyyiLEvOZsuxbplKMmTscYTISjz75ylhI=;
	b=FNMiUqR1VETpCk36csiMjXQ9qhKRfMhUDehyM4s2Iwq33HjhsJlDNxqFcsfr5Bl1CwJR
	 9yHI83I6NaprJNu9F7Ucm12qLLQZ78uq7cHc6g74GKv6rzUwDD0PoGIEsyMQKYWOozN8t
	 bVt778p+84FU4WRSLAZ9eq0o0bux8djrR70tyxHR8kDtK6JcyFhqwb11cIDm/R83UjuUi
	 8wdbpfCpCwpe//RBeNmdpQvhEvEqNR1XPThKdyb3zdRs0xEZQbiLQ546J5cOtjlNDsSu6
	 w7eyzT6Hst0DnKWBCQhDKRzP26i8xza+FQ8+39rHoPWDfQ8vhjuh2O9BYA0EWtSa3VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mybObK7I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE01A606A336;
	Mon,  2 Nov 2026 18:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mybObK7I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4932D1F00A1C;
	Mon,  2 Nov 2026 18:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793643875;
	bh=ASxeBkPjSzVyyiLEvOZsuxbplKMmTscYTISjz75ylhI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=mybObK7I4vLqJlYMiR5W+rbVuFw3y0IUnM0Fa3RCEWjpc68y3ncL703T9CZzQE5OM
	 iZ3ChlsD519gyMJrEnsTR/89hbxttbO1S7fmD+0ohRxf+9ERbsg8b5TWtriboR1FZB
	 bs8CmZFI/WlDBsVizl10PdgDBKYyxmrbGaRS0Z03sTfuV+vKpHPUsUu75qfajoox7a
	 CNUP1+mu6YyvyJK9dS7zE5KkU5kG1BRN6EoC9FGxvgYoqcWufUw37XGvW0Hu9UikSd
	 Txex/DAwvEEVAUe2J0o5HUsK+7Jj9PLzNnxVHPhR4xVK0O8dLFyIa2AB3RCBr8D1ej
	 MVMzeoie3JSKw==
Subject: Re: [PATCH net v8 4/4] net/smc: bound the link failover cursor
 advance to the send buffer
From: netdev-bot+sashiko@kernel.org
To: hexlabsecurity@proton.me
Cc: sidraya@linux.ibm.com, kuba@kernel.org, mjambigi@linux.ibm.com,
 pabeni@redhat.com, alibuda@linux.alibaba.com, davem@davemloft.net,
 dust.li@linux.alibaba.com, edumazet@kernel.org,
 guangguan.wang@linux.alibaba.com, ubraun@linux.ibm.com, raspl@linux.ibm.com,
 linux-s390@vger.kernel.org, guwen@linux.alibaba.com,
 linux-kernel@vger.kernel.org, hidayath@linux.ibm.com, horms@kernel.org,
 wenjia@linux.ibm.com, tonylu@linux.alibaba.com, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org
Date: Mon, 02 Nov 2026 18:24:33 +0000
Message-ID: <179364387382.3131.13471253186660322977@kernel.org>
In-Reply-To: <20261029-b4-disp-33001ace-v8-4-f9bb96e17827@proton.me>
References: <20261029-b4-disp-33001ace-v8-4-f9bb96e17827@proton.me>
X-sashiko-severity: Medium
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

Critical: 0 · High: 0 (2) · Medium: 2 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The patch adds a cons.count < peer_rmbe_size gate to
  smc_switch_cursor().
- [Medium] The new bound in smc_switch_cursor(), diff <=
  smc_curs_diff(len, &tx_curs_sent, &prep), is computed from a snapshot…
- [Low] The new comment in smc_switch_cursor()
  (net/smc/smc_core.c:1050-1054) says the catch-up runs 'only for a…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the catch-up
  decision in smc_switch_cursor() uses smc_curs_comp(), which compares…
- [High] This problem wasn't introduced by this patch, but
  smc_switch_cursor() reads and updates conn->tx_curs_fin,…

--

net/smc: bound the link failover cursor advance to the send buffer

On SMC-R link failover, smc_switch_cursor() advances the send and producer
cursors by the distance the peer's consumer cursor is ahead of the last
confirmed producer cursor. This patch performs that catch-up only when the
peer's consumer cursor count lies inside the peer RMB. It also caps the
advance at tx_curs_prep, so the RDMA source stays inside the send buffer.

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index fe6e4a2f7935a..42d83a002ffb3 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c

[ ... ]

> @@ -1043,12 +1043,18 @@ static int smc_switch_cursor(struct smc_sock *smc, struct smc_cdc_tx_pend *pend,
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

[Severity: Medium]

What happens here when the peer sends a consumer cursor with count >=
peer_rmbe_size and a wrap ahead of fin?

The catch-up is skipped and local_tx_ctrl.prod stays at fin. The forged
cons is still used right after the block:

	/* recalculate, value is used by tx_rdma_writes() */
	atomic_set(&smc->conn.peer_rmbe_space, smc_write_space(conn));

In smc_write_space(), cons.wrap != prod.wrap, so:

	space = buffer_len - smc_curs_diff(buffer_len, &cons, &prod);

Here smc_curs_diff() computes (size - cons.count) + prod.count in unsigned
arithmetic. With cons.count >= size, max_t() clamps that to 0, or it is
small. That leaves peer_rmbe_space at roughly peer_rmbe_size.

smc_tx_rdma_writes() then takes the wrapped branch:

	dst_off = prod.count;
	if (prod.wrap == cons.wrap) {
		...
	} else {
		...
		dst_len = len;
	}

len can be up to peer_rmbe_size. The WRITE that smc_tx_rdma_write() posts
would then end prod.count bytes past the peer RMBE.

When the peer HCA refuses it, the QP goes into the error state and the link
goes down. The next smc_switch_conns()->smc_switch_cursor() sees the same
forged local_rx_ctrl.cons and an unchanged local_tx_ctrl_fin. It posts the
same oversized WRITE on the alternate link, and this repeats until the link
group is terminated. The peer can also force the failovers itself, for
example with LLC DELETE LINK.

Before this patch, the same input moved prod onto the forged count,
smc_write_space() returned 0, and only that connection stalled. That
matches the second measurement in the notes below the --- line.

Should the skip path also avoid sizing peer_rmbe_space from this cons?

> +	    smc_curs_comp(conn->peer_rmbe_size, &cons, &fin) < 0) {

[Severity: High]

This is a pre-existing issue that was not introduced by this patch.
smc_curs_comp() compares the u16 wrap values as plain numbers:

	if (old->wrap > new->wrap ||
	    (old->wrap == new->wrap && old->count > new->count))
		return -smc_curs_diff(size, new, old);

A wrap rollover from 65535 to 0 is a normal state. smc_curs_add() does
wrap++ on a u16, and smc_cdc_cursor_to_host() accepts temp.wrap == 0.

Can this misorder cons and fin around the rollover?

Case 1: cons is ahead across the rollover. For example, peer_rmbe_size is
16384, fin=(65535,12288) and cons=(0,4096). smc_curs_comp() returns +24576,
so the catch-up is skipped. smc_write_space() then returns 16384 - 24576 =
-8192, and smc_tx_rdma_writes() returns early on rmbespace <= 0. The
connection stalls, even with a conforming peer.

Case 2: cons is correctly behind fin, with fin=(0,y), cons=(65535,x) and
x >= y. smc_curs_comp(R, &cons, &fin) returns -(R - y + x), which is
negative, and cons.count < R passes the new check. With data pending,
diff = min(R - y + x, prep - sent) > 0.

The four cursors tx_curs_sent, tx_curs_fin, local_tx_ctrl.prod and
local_tx_ctrl_fin all move forward. sndbuf_space is credited for bytes the
peer never consumed.

The data in [fin, fin + diff) is never re-sent, but prod tells the peer
that it is present. If diff is larger than the peer's free space (x - y),
the peer's bytes_to_rcv exceeds its RMB. Would the peer application then
read stale RMB contents as stream data?

The min() added here keeps the source inside the send buffer. It does not
fix this ordering problem.

> +		/* cons cursor advanced more than fin, and prod was set fin
> +		 * above, so now prod is smaller than cons. cons comes off the
> +		 * wire: catch up only for a count inside the peer's RMB and no
> +		 * further than the send buffer holds, else that peer stalls.
>  		 */

[Severity: Low]

Is "else that peer stalls" accurate for the cons.count >= peer_rmbe_size
case? As described above, that path leaves peer_rmbe_space at about
peer_rmbe_size. The next write overruns the peer RMBE and the link goes
down. That is also the outcome the notes below the --- line report for the
second scenario.

When the send buffer limit in the min() is the smaller value, prod can
also still be behind cons after this block. That doesn't fit the "now prod
is smaller than cons" framing either.

The commit message has the same issue:

  The destination side is not bounded here: smc_write_space()
  still sizes the window from the peer's cursor, so a forged one can take
  the next write past the peer's own RMB, where its HCA refuses it and
  the link goes down.

For the forged count >= peer_rmbe_size input, the write past the RMB is
new with this patch. Before it, the connection stalled. Could the wording
say so instead of "still"?

> -		diff = smc_curs_diff(conn->peer_rmbe_size, &fin, &cons);
> +		diff = min(smc_curs_diff(conn->peer_rmbe_size, &fin, &cons),
> +			   smc_curs_diff(conn->sndbuf_desc->len,
> +					 &conn->tx_curs_sent, &prep));
>  		smc_curs_add(conn->sndbuf_desc->len,
>  			     &conn->tx_curs_sent, diff);
>  		smc_curs_add(conn->sndbuf_desc->len,

[Severity: High]

This is a pre-existing issue that was not introduced by this patch. The
rest of the block updates shared connection state:

net/smc/smc_core.c:smc_switch_cursor() {
    ...
		smc_curs_add(conn->sndbuf_desc->len,
			     &conn->tx_curs_fin, diff);

		smp_mb__before_atomic();
		atomic_add(diff, &conn->sndbuf_space);
		smp_mb__after_atomic();
    ...
}

smc_switch_conns() holds only conn->send_lock here. smc_cdc_tx_handler()
updates the same fields under bh_lock_sock() only:

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

Late successful completions on the old link can run during the switch.
smc_llc_delete_asym_link() calls smc_switch_conns() before
smc_wr_tx_wait_no_pending_sends(). smc_wr_tx_process_cqe() calls the
handler without checking the link state.

Can this credit sndbuf_space twice? Take a sndbuf len of 64K, tx_curs_fin
0, tx_curs_sent 32K, tx_curs_prep 48K and cons 32K:

  smc_switch_cursor():   tx_curs_sent = 0, diff = 32K
  smc_cdc_tx_handler():  sndbuf_space += 32K, tx_curs_fin = 32K
  smc_switch_cursor():   tx_curs_fin += 32K -> (1,0), sndbuf_space += 32K

sndbuf_space ends at 80K, but only 48K is actually free. smc_tx_sendmsg()
clamps to 64K and copies 64K starting at prep 48K. That overwrites the
unsent bytes at [32K,48K) before they are RDMA-written.

smc_curs_add() also does a non-atomic read-modify-write of count and wrap,
so it can tear against the handler's smc_curs_copy().

[Severity: Medium]

The new limit is computed from the tx_curs_sent copy taken from
tx_curs_fin at the top of smc_switch_cursor(). diff is then added to the
live conn->tx_curs_fin and conn->local_tx_ctrl_fin, which
smc_cdc_tx_handler() can rewrite at the same time, as described above.

Does the limit still hold under that race? With a single racing
completion, the source does stay in bounds. A chain of events can still
get past it:

  failover 1 + race: tx_curs_fin ends one wrap ahead of prep, with
    count < prep.count
  failover 2: smc_curs_diff(len, &tx_curs_sent, &prep) sees different
    wraps and returns more than len; a forged cons with count <
    peer_rmbe_size and a wrap ahead passes the check, so diff2 > len
  race 2: the handler sets tx_curs_fin = prep before smc_curs_add(), so
    tx_curs_fin.count = prep.count + diff2 - len >= len
  failover 3: tx_curs_fin is copied into tx_curs_sent and the catch-up
    is skipped

smc_tx_rdma_writes() then uses sent.count >= sndbuf_desc->len as the
source offset:

		src_len = conn->sndbuf_desc->len - sent.count;

This needs two precisely timed late completions in successive failovers
plus a forged cursor, so it is unlikely. It does break the source-side
limit the commit message describes.

Would it help to derive tx_curs_fin and local_tx_ctrl_fin from the advanced
local copies, or to serialize against smc_cdc_tx_handler()?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261029-b4-disp-33001ace-v8-0-f9bb96e17827%40proton.me
