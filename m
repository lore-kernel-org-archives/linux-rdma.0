Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9F64E8E14;
	Mon, 19 Oct 2026 12:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792412088; cv=none; b=q0JVyJUMvniEIF6XZBZcG4LgOL+vMt5VOV/j05PenF2jtfc1Wiv+hOlETD4uCOjdB+4bi5ldjU3DTud8BapB/hRjmueJGn/WsXLmRBq/3zxcUYeDbHSBxyfHwmvx97OqGAsobY4VAtCzY44++uHAuf4wiZnllLlRLOeyP8sWJBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792412088; c=relaxed/simple;
	bh=BSwWM6nk7DbWd35aVGGbKQmA1GKDsr2fA5SkIsFb+HE=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=koXwNxM1tRnHfgE8VeYHtmFtWlWAllr8tJ+1IVXl4JyhkESR0xIvRLAnNl6OpiXTTqdzLy0j9LQhcb2lIcBpPW1Oa8iobWodCKrXSyFbFstPbrPA5XrTkcsGWG8RH5/iqdFc6EDKCsixdM/r9I+B9/kAqeEERFbOTDBFmBiW3SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hox1yaR0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hox1yaR0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8AF1F000C5;
	Mon, 19 Oct 2026 12:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792412086;
	bh=euTmnjJJH55Slsz5ix2BxC7yGtPMw6Gg6ky+Uj/HNiw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=hox1yaR0J5Cj1OLYfJO/Tqm4WEXlRStY6vpfsuQPuXdTCbFEASbI8qSz1ISK7Dnly
	 Knstx1yRS03wg5h9RNEfwPBRykNH9IVi2Mt9s/R7slxdoX2HMsTjN7PbwRYrx9bTkC
	 xvp0+sVgkZrYa3bo1muDloN5C34R+PO1qbn9XIRo+bNJAoIO0/SyGHx2/c3/5vcT8x
	 qM8lWiZL0pbX8uAgM6VGDlwYtGM+lb8ncwIDwGQWoJYZS7keZzFUSeBM8oehv3QBh8
	 qFYGfXu0u3amqHkxVL80/mDKK97l/ondiU9BT4k4Q8Epxrne22lJ6hvd2hkYGFnYXn
	 eEWtC8MiY1QeA==
Subject: Re: [PATCH net v5 2/2] net/smc: skip the DMB nocopy accounting until
 the send buffer is set
From: netdev-bot+sashiko@kernel.org
To: hexlabsecurity@proton.me
Cc: kuba@kernel.org, dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
 davem@davemloft.net, pabeni@redhat.com, alibuda@linux.alibaba.com,
 mjambigi@linux.ibm.com, edumazet@kernel.org, horms@kernel.org,
 wenjia@linux.ibm.com, ubraun@linux.ibm.com, hwippel@linux.ibm.com,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 tonylu@linux.alibaba.com, linux-rdma@vger.kernel.org, guwen@linux.alibaba.com,
 linux-s390@vger.kernel.org
Date: Mon, 19 Oct 2026 12:14:45 +0000
Message-ID: <179241208501.3135.14193534440423847161@kernel.org>
In-Reply-To: <20261015-b4-disp-2a8d85ef-v5-2-6b795e8263c9@proton.me>
References: <20261015-b4-disp-2a8d85ef-v5-2-6b795e8263c9@proton.me>
X-sashiko-severity: Critical
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

Critical: 1 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Critical] The patch only skips the nocopy accounting while
  conn->sndbuf_desc is NULL.
- [High] A stale CDC from the old peer of a reused DMB that arrives
  before attach used to oops whenever diff_cons != 0.

--

net/smc: skip the DMB nocopy accounting until the send buffer is set

The patch changes smcd_buf_attach() so it publishes conn->sndbuf_desc with
a release store after sndbuf_space has been set. smc_cdc_msg_recv_action()
then skips the SMC-D DMB nocopy send buffer accounting while sndbuf_desc is
still NULL. This avoids a NULL dereference when the old peer of a reused
DMB signals the new connection before the attach.

> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index 7bf902ebd7ab6..d6825f48f5688 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c

[ ... ]

> @@ -353,12 +354,19 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
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

[Severity: High]
With this gate, a stale CDC from the old peer that arrives before
smcd_buf_attach() no longer oopses. It is now processed silently, and only
the sndbuf part is skipped. Doesn't the rest of smc_cdc_msg_recv_action()
still apply the old peer's state to the new connection?

smc_cdc_msg_to_host() runs before the gate. It writes the old peer's
prod/cons cursors and flags into conn->local_rx_ctrl:

    smc_cdc_msg_to_host(&conn->local_rx_ctrl, cdc, conn);

    diff_cons = smc_curs_diff(conn->peer_rmbe_size, &cons_old,
                              &conn->local_rx_ctrl.cons);
    if (diff_cons) {
        ...
        atomic_add(diff_cons, &conn->peer_rmbe_space);

After that, diff_prod is added to bytes_to_rcv and sk_data_ready() is
called. Can recvmsg() on the new socket then return whatever the old peer
wrote into the reused DMB? Stale conn_state_flags could also abort or close
the new connection.

smcd_buf_attach() resets only sndbuf_space and sndbuf_desc. It never
resyncs local_rx_ctrl.cons/prod or peer_rmbe_space, so the current peer's
first consumer update is diffed against the stale cons_old.

For example, say the stale cursor is {wrap=1, count=x>0}. The real peer
then drains a full buffer and sends {wrap=1, count=0}. smc_curs_diff()
returns 0, so the whole if (diff_cons) block is skipped. sndbuf_space is not
credited, tx_curs_fin does not move, and smc_tx_sndbuf_nonfull() is not
called.

smcd_cdc_msg_send() also returns early for nocopy:

    if (smc_ism_support_dmb_nocopy(conn->lgr->smcd))
        ...
        return 0;

Is there any other path that recovers this credit? A sender that has
filled the buffer could end up blocked forever.

If the wraps differ instead, peer_rmbe_space is over-credited past
peer_rmbe_size. Then this check further down in smc_cdc_msg_recv_action()
can never be true:

    if (diff_cons && conn->urg_tx_pend &&
        atomic_read(&conn->peer_rmbe_space) == conn->peer_rmbe_size) {

Would sendmsg() after MSG_OOB then block?

This also seems to contradict the commit message:

    "Before the attach the current peer has consumed nothing of ours, so
    no update from it is lost."

>  			/* Calculate consumed data and
>  			 * increment free send buffer space.
>  			 */
> -			diff_tx = smc_curs_diff(conn->sndbuf_desc->len,
> +			diff_tx = smc_curs_diff(sndbuf_desc->len,
>  						&conn->tx_curs_fin,
>  						&conn->local_rx_ctrl.cons);

[Severity: Critical]
This only covers the window before smcd_buf_attach(). After
smp_store_release() publishes sndbuf_desc, can the old peer of the reused
DMB still signal this connection and have its consumer cursor counted here
as if the current peer had sent it?

Nothing in smcd_buf_attach() filters CDCs from the old peer, which still
holds the DMB token. smcd_cdc_rx_tsklet() reads whichever peer last wrote
the DMB header. smcd_cdc_msg_to_host() then copies the cursors without the
monotonicity check that smc_cdc_cursor_to_host() does for SMC-R.

The new connection's tx_curs_fin starts at {0,0}. If the stale cons is
{wrap!=0, count=c}, then diff_tx = len + c, and sndbuf_space becomes about
2 * len + c. That breaks the invariant sndbuf_space <= sndbuf_desc->len.

smc_tx_sendmsg() then uses that value:

    copylen = min_t(size_t, send_remaining, writespace);
    ...
    chunk_len = min_t(size_t, copylen, conn->sndbuf_desc->len -
                      tx_cnt_prep);
    ...
            chunk_len = copylen - chunk_len; /* remainder */
            chunk_len_sum += chunk_len;
            chunk_off = 0; /* modulo offset in send ring buffer */

The second chunk is copied to offset 0 by memcpy_from_msg(), and nothing
bounds it against sndbuf_desc->len. With prep at 0 that chunk is len + c
bytes. Does that write c bytes of user data past the end of the peer's DMB
folio? The folio is exactly the DMB size, so the extra bytes would land in
the pages next to it.

Smaller over-credits stay inside the buffer. They can still overwrite data
the real peer has not consumed yet, and tx_curs_fin is overwritten with the
foreign cursor.

One way to get there: smc_release() calls smc_close_active_abort() when a
non-blocking connect finishes during close. That sends no CDC to the peer.
smc_conn_free()->smc_buf_unuse() then only zeroes the DMB and clears used,
and the token stays registered. The peer is still active and still
attached.

__smc_buf_create() can then reuse the slot, and smc_ism_set_conn() maps it
to the new connection. The old peer's next CDC follows this path:

    smcd_cdc_msg_send()->dibs_lo_move_data()->handle_irq()
        ->smcd_cdc_rx_tsklet()

and is processed on the new connection. AF_SMC needs no privilege, so a
local user who controls both ends and the timing could trigger this
wherever loopback-ism is enabled.

This post-attach path already existed before this patch. Since the commit
message names "the old peer of a reused DMB can still signal us" as the
root cause, would it be better to not reuse a DMB that a peer may still
have attached, or to filter CDCs from the stale peer? Gating on
sndbuf_desc only hides the NULL dereference.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261015-b4-disp-2a8d85ef-v5-0-6b795e8263c9%40proton.me
