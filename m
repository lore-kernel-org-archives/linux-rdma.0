Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C7B4A5ED0;
	Thu, 15 Oct 2026 20:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792095328; cv=none; b=SUyr0PWfVxrB1VcIlQL9daBUWnrbIOsTpLCRZrrTggE7DGBChXHcGIL5J/dk/dPL2guP8M3CBVqhC6p+a0+qYH6te2Ait3CBAnIOlSQj5ZTgJEjX6jXVS1gbwEJ5rEhFFcmAGkD2lrkSEaECQFszHjdm6i5E/3+sDAOweNXDa7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792095328; c=relaxed/simple;
	bh=o/6tC4Iti9jgkzvtQ+oMdQp9J3+vt+1OqpnJZGpvPv0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jB++1fwpJ4BDpXjySNu/tyyAnPtI/6kneEWQHxr9mfeMY7WVci9ONiEKQIdbOgHwAgKEHeZK4ShGoH/J00Atq/uDtPiv9Q9eBYeR7+w+YJiBa56B1IH53S9EKqb31isMY70vLnjSM2a47u1SyH+c1x9WR16X7z9QL0xkYikP1zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BEJj5h5q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BEJj5h5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68BF1F000C6;
	Thu, 15 Oct 2026 20:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792095326;
	bh=HVseH2fe+YHS4QdNyOTjNRFrabGI0KhJiTZ4qqpyAPE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=BEJj5h5q2+AZISYNE1EMj8hWcr2a71cLbzm+luRX+kBH5ZwxxMxAd6auOeB7kKLm2
	 aHPRJX20MbJ9FvqgnQgUydmHRcj3L1tedG7ALGd9fdUugMwzPS2Ml38Uw9aBGNHdn+
	 olvGVlhttfRU7N0EtNIvqSowu+9kjYUOQVvWwmBB1OMclji9JgUrxX4ERetM6RII11
	 Xfwo3Do+7VAHHzp4KR0HUvjfxhCK+Hub/iWY2relq4a1KiaFtKEjBHQK5XU5az8F5q
	 +XeMVmhanx6Vn/DNlCTTW73VzbkgIrZ1lrRB8YX57KcfHkU1K1hRGTJ0X6t8gNVOvV
	 CIvGlKWmguMyw==
Subject: Re: [PATCH net v7 4/4] net/smc: bound the link failover cursor
 advance to the send buffer
From: netdev-bot+sashiko@kernel.org
To: hexlabsecurity@proton.me
Cc: alibuda@linux.alibaba.com, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, dust.li@linux.alibaba.com, mjambigi@linux.ibm.com,
 sidraya@linux.ibm.com, davem@davemloft.net, netdev@vger.kernel.org,
 horms@kernel.org, linux-kernel@vger.kernel.org, wenjia@linux.ibm.com,
 tonylu@linux.alibaba.com, linux-s390@vger.kernel.org,
 guangguan.wang@linux.alibaba.com, ubraun@linux.ibm.com,
 linux-rdma@vger.kernel.org, raspl@linux.ibm.com, hidayath@linux.ibm.com,
 guwen@linux.alibaba.com
Date: Thu, 15 Oct 2026 20:15:24 +0000
Message-ID: <179209532452.434549.6588379141939967966@kernel.org>
In-Reply-To: <20261013-b4-disp-f345196c-v7-4-ef3dddfbfa68@proton.me>
References: <20261013-b4-disp-f345196c-v7-4-ef3dddfbfa68@proton.me>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 (2) · Medium: 0 (2) · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix stops a forged cursor from moving the RDMA source past
  the send buffer, but the destination can still run past the peer's RMB…
- [Low] After the patch, smc_switch_cursor() can leave local_tx_ctrl.prod
  behind local_rx_ctrl.cons.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but
  smc_switch_cursor() reads and changes tx_curs_fin, local_tx_ctrl_fin…
- [High] This problem wasn't introduced by this patch, but
  smcr_tx_rdma_writes() (net/smc/smc_tx.c:421-422) sizes the first…
- [Medium] This problem wasn't introduced by this patch, but the two
  consumers of the peer's wire consumer cursor now treat it differently.
- [Medium] This problem wasn't introduced by this patch, but
  smc_curs_comp() (net/smc/smc_cdc.h) compares the u16 wrap fields as…

--

net/smc: bound the link failover cursor advance to the send buffer

This patch hardens smc_switch_cursor() against a forged peer consumer
cursor during SMC-R link failover. The catch-up advance now runs only when
cons.count is inside the peer RMB. It is also capped at the amount of data
between tx_curs_sent and tx_curs_prep.

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 8829517299def..36aee89e5f5f7 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c

[ ... ]

> @@ -1043,12 +1043,18 @@ static int smc_switch_cursor(struct smc_sock *smc, struct smc_cdc_tx_pend *pend,
>  	/* set prod cursor to old state, enforce tx_rdma_writes() */
>  	smc_curs_copy(&conn->local_tx_ctrl.prod, &fin, conn);
>  	smc_curs_copy(&cons, &conn->local_rx_ctrl.cons, conn);
> +	smc_curs_copy(&prep, &conn->tx_curs_prep, conn);
>  
> -	if (smc_curs_comp(conn->peer_rmbe_size, &cons, &fin) < 0) {
> +	if (cons.count < conn->peer_rmbe_size &&

[Severity: High]
Does this fully close the destination side of the overrun that the commit
message describes? The new cons.count check only decides whether the
catch-up branch runs. The forged cursor is not rejected and stays in
conn->local_rx_ctrl.cons.

Right after the if-block, smc_switch_cursor() still does:

	/* recalculate, value is used by tx_rdma_writes() */
	atomic_set(&smc->conn.peer_rmbe_space, smc_write_space(conn));

smc_write_space() computes the window from that same cursor:

	space = buffer_len - smc_curs_diff(buffer_len, &cons, &prod);

Take peer_rmbe_size = 16384, fin/prod = {wrap 2, count 1000} and a forged
cons = {wrap 3, count 17000}. The branch is skipped because 17000 >= 16384.
In smc_curs_diff() the wraps differ, so (size - old->count) is computed as
unsigned and wraps around. The diff comes out as 384, which makes
peer_rmbe_space 16000.

smc_tx_rdma_writes() then sees prod.wrap != cons.wrap and takes the
single-chunk path:

		dst_len = len;

This write starts at dst_off = prod.count = 1000, and nothing limits it to
peer_rmbe_size - prod.count. Wouldn't that RDMA write cover bytes
1000..17000 of a 16384 byte peer RMB?

The receive path in smc_cdc_msg_recv_action() also credits
peer_rmbe_space from the same cursor. smcr_cdc_msg_to_host() imports cons
with max_count == 0:

	smc_cdc_cursor_to_host(&local->cons, &peer->cons, conn, 0);

So this looks reachable with or without failover.

Would it be better to validate the consumer cursor once at import (count
against peer_rmbe_size, plus a sane wrap delta)? Alternatively,
peer_rmbe_space and dst_len could be clamped to the peer RMB. A check
inside the catch-up branch alone doesn't seem to cover it.

[Severity: Medium]
This isn't a bug introduced by this patch, but the two users of the wire
consumer cursor now handle it differently. smc_switch_cursor() bounds its
use of local_rx_ctrl.cons. smc_cdc_msg_recv_action() in net/smc/smc_cdc.c
still credits the window without a limit:

	diff_cons = smc_curs_diff(conn->peer_rmbe_size, &cons_old,
				  &conn->local_rx_ctrl.cons);
	if (diff_cons) {
		...
		atomic_add(diff_cons, &conn->peer_rmbe_space);
		/* guarantee 0 <= peer_rmbe_space <= peer_rmbe_size */

A forged cons with the same wrap as prod and a large count pushes
peer_rmbe_space above peer_rmbe_size. smc_tx_rdma_writes() then uses
len = min(to_send, rmbespace). That can be larger than peer_rmbe_size when
the sndbuf is bigger than the peer RMB.

The second destination chunk in smcr_tx_rdma_writes() is then:

		dst_off = 0; /* modulo offset in RMBE ring buffer */
		dst_len = len - dst_len; /* remainder */

Can that second chunk run past the end of the peer RMB? Should the
receive path get the same bound as the failover path?

> +	    smc_curs_comp(conn->peer_rmbe_size, &cons, &fin) < 0) {

[Severity: Medium]
This is a pre-existing issue, but smc_curs_comp() in net/smc/smc_cdc.h
compares the u16 wrap fields as plain numbers:

	if (old->wrap > new->wrap ||
	    (old->wrap == new->wrap && old->count > new->count))
		return -smc_curs_diff(size, new, old);
	return smc_curs_diff(size, old, new);

smc_cdc_cursor_to_host() and smc_curs_diff_large() handle the 65535 to 0
wrap rollover explicitly, but smc_curs_comp() does not.

Take peer_rmbe_size = 16384, fin = {wrap 65535, count 12288} and a
legitimately advanced cons = {wrap 0, count 4096}. Here
smc_curs_comp(P, &cons, &fin) returns +24576, so the catch-up is skipped
even though cons is 8192 bytes ahead. smc_write_space() then returns
16384 - 24576 = -8192.

smc_tx_sndbuf_nonempty() then returns early:

	if (unlikely(atomic_read(&conn->peer_rmbe_space) <= 0)) {

If the peer has nothing left to consume, no new cons update arrives to
reopen the window. Can the connection stall permanently if failover hits
this window? Reaching it takes about 65536 wraps of the peer RMB before
the failover.

>  		/* cons cursor advanced more than fin, and prod was set
> -		 * fin above, so now prod is smaller than cons. Fix that.
> +		 * fin above, so now prod is smaller than cons. cons comes
> +		 * off the wire: catch up only for a count inside the peer's
> +		 * RMB and no further than the data in the send buffer.
>  		 */
> -		diff = smc_curs_diff(conn->peer_rmbe_size, &fin, &cons);
> +		diff = min(smc_curs_diff(conn->peer_rmbe_size, &fin, &cons),
> +			   smc_curs_diff(conn->sndbuf_desc->len,
> +					 &conn->tx_curs_sent, &prep));

[Severity: Low]
Two cases leave local_tx_ctrl.prod behind local_rx_ctrl.cons: the prep
term of this min() wins, or the branch is skipped because
cons.count >= peer_rmbe_size. The comment above still says the catch-up
fixes prod < cons.

smc_write_space() assumes prod >= cons. Suppose cons is one wrap ahead,
for example cons = {w + 1, c} and prod = {w, p} with p > c. Then
smc_curs_diff(buffer_len, &cons, &prod) is larger than buffer_len, and the
returned space is c - p, which is negative. In the equal-wrap case
smc_curs_diff() clamps to 0, so space is just peer_rmbe_size.

A negative space breaks the "guarantee 0 <= peer_rmbe_space <=
peer_rmbe_size" comments in smc_cdc.c and smc_tx.c. Sending on the
connection also stops while peer_rmbe_space <= 0.

For a conforming peer neither the skip nor the cap should fire. So the
effect seems limited to a stall of the misbehaving peer's own connection.
Is this state intended, and should the comment be updated to match?

>  		smc_curs_add(conn->sndbuf_desc->len,
>  			     &conn->tx_curs_sent, diff);

[Severity: High]
This isn't a bug introduced by this patch, but the RDMA write takes its
offsets from these cursors. Is the source side of smcr_tx_rdma_writes() in
net/smc/smc_tx.c bounded for the second destination chunk?

		dst_off = 0; /* modulo offset in RMBE ring buffer */
		dst_len = len - dst_len; /* remainder */
		dst_len_sum += dst_len;
		src_len = min_t(int, dst_len, conn->sndbuf_desc->len -
				sent_count);

This uses the original sent_count rather than the current src_off.
smcd_tx_rdma_writes() uses src_off here:

		src_len = min_t(int, dst_len, conn->sndbuf_desc->len - src_off);

A conforming peer doesn't seem able to reach this. The SMC-R sndbuf and
RMB sizes are both 1 << (comp + 14), and tx_curs_sent and
local_tx_ctrl.prod advance together. It does become reachable once the
unbounded credit in smc_cdc_msg_recv_action() pushes peer_rmbe_space above
peer_rmbe_size.

Example: peer_rmbe_size = 16384, sndbuf_desc->len = 65536,
prod.count = sent.count = 4096, a forged same-wrap cons with a large
count, and to_send = 65536.

The first destination chunk has dst_len = 12288, and src_off becomes
16384. The second has dst_len = 53248 and
src_len = min(53248, 65536 - 4096) = 53248.

Wouldn't sge[0] then cover [16384, 69632)? That is 4096 bytes past the
end of the 65536 byte sndbuf, and sndbuf [0, 4096) is never sent.

For physically contiguous sndbufs without an IOMMU, could this send
adjacent kernel memory to the peer?

>  		smc_curs_add(conn->sndbuf_desc->len,

[Severity: High]
This is a pre-existing issue, but smc_switch_cursor() reads and updates
tx_curs_fin, local_tx_ctrl_fin and sndbuf_space while holding only
conn->send_lock. smc_switch_conns() takes that lock:

			spin_lock_bh(&conn->send_lock);
			smc_switch_link_and_count(conn, to_lnk);
			rc = smc_switch_cursor(smc, pend, wr_buf);

smc_cdc_tx_handler() updates the same fields from the send completion
tasklet. It holds only bh_lock_sock() and never takes send_lock:

	bh_lock_sock(&smc->sk);
	if (!wc_status && sndbuf_desc) {
		diff = smc_curs_diff(sndbuf_desc->len,
				     &cdcpend->conn->tx_curs_fin,
				     &cdcpend->cursor);
		...
		atomic_add(diff, &cdcpend->conn->sndbuf_space);
		...
		smc_curs_copy(&conn->tx_curs_fin, &cdcpend->cursor, conn);

smc_llc_delete_asym_link() calls smc_switch_conns() before it waits for
pending sends on the old link, and the DELETE_LINK path does the same:

	lnk_new = smc_switch_conns(lgr, lnk_asym, false);
	smc_wr_tx_wait_no_pending_sends(lnk_asym);

So CDC sends already posted on the old link can complete on another CPU
during the switch. One possible interleaving:

CPU0 smc_switch_cursor()
  tx_curs_sent = tx_curs_fin = F0
  fin = L0
                          CPU1 smc_cdc_tx_handler()
                            sndbuf_space += F1 - F0
                            tx_curs_fin = F1
CPU0
  tx_curs_fin += diff    /* now F1 + diff */
  sndbuf_space += diff

Doesn't that leave sndbuf_space overcounted by F1 - F0? Also, an old-link
completion that lands after the switch can move tx_curs_fin backwards, and
later completions would then credit the same bytes again.

The earlier patch in this series, "net/smc: bound the send length to the
send buffer in smc_tx_sendmsg()", clamps writespace to
sndbuf_desc->len. That keeps the copy inside the buffer.

Even so, can smc_tx_sendmsg() still overwrite unsent or unconfirmed data
between the real tx_curs_fin and tx_curs_prep?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261013-b4-disp-f345196c-v7-0-ef3dddfbfa68%40proton.me
