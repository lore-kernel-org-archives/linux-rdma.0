Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE9B49BD8A;
	Thu, 15 Oct 2026 20:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792095326; cv=none; b=EtAtgvdqcFFL/wwFsDjLNYtNmN725HbkuYdgpRXMjsFygVzsT3BpUEZvu7N9im5jBvViQSieQQum2zYXg+knNFp8Z9VYsGejrBSW1b83ZTR3+MREtT1tJY+QNgif75MJPJVUh3Pw+xwVA/hrMpfn+02MbiqT2wxFHv9wEIG2hgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792095326; c=relaxed/simple;
	bh=ey04gfJGbAVXgslnspjApSQ1xcd4Bcxxhuwto2yM10s=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ozKzSMHVNQewaMle2gH8AyrJZctme9Ankz5rAFEDvmGbcMgilfxp28yikf2V+G9MOjEgUyr8eV0hTTnL2TLLdMzzvkdskxh6X3KAcCPeXb7u8bHDYK82C+d5i29j7DkyApasG33suyuu+Z6fAoin5VMdEgoaLv/X2qDBfIhsPSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SKiQT30S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SKiQT30S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C48D1F000C5;
	Thu, 15 Oct 2026 20:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792095324;
	bh=cv5PwzXj7RudYzCjURYGyHpUsBCfIZE6LpWxucxV88M=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=SKiQT30SsQ1suvXAJcBE6BoqY2cgiTNwstDEr9SQ5h9KPB+fVctEF6B79wGnkWa1f
	 8jJTuQafcP6SkGvtP7v83mcfar+LyOAsNCcX88ZrmpF/8wU29CkGZgtjhdgMOCSMmM
	 F/aEqd3XKZY3yxwCfQWpbtxoPfKeD/hJIYciaffWM6BtahOasbDZjXyuwoMMLFzyV6
	 GAAdELJeYxFP6mtn9hWcQE1qA/iRvA0m22xOWdSYjW1Y3uGqYqeeRkqHnieK2EnUVx
	 iFb/5sRnKQ17w44q3fJBfXo9qPx6ymXJCsjCZnqYt46skF9+vXY9a+hjOpl8FFjeHx
	 BHNe+iwlxaO+Q==
Subject: Re: [PATCH net v7 3/4] net/smc: bound the send length to the send
 buffer in smc_tx_sendmsg()
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
Date: Thu, 15 Oct 2026 20:15:22 +0000
Message-ID: <179209532279.434549.3831566859438447501@kernel.org>
In-Reply-To: <20261013-b4-disp-f345196c-v7-3-ef3dddfbfa68@proton.me>
References: <20261013-b4-disp-f345196c-v7-3-ef3dddfbfa68@proton.me>
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

Critical: 0 · High: 1 (2) · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] smc: flow control bypass and data corruption on negative
  sndbuf_space
- [Low] The new comment in smc_tx_sendmsg() (net/smc/smc_tx.c:236-240)
  says sndbuf_space 'can be out of range' because of late SMC-R…

Pre-existing issues:
- [High] The clamp bounds the size of each copy, not the flow control.
- [High] smc_switch_cursor() (net/smc/smc_core.c:1033) reads tx_curs_fin
  and local_tx_ctrl_fin, rewrites tx_curs_sent, tx_curs_fin and…

--

net/smc: bound the send length to the send buffer in smc_tx_sendmsg()

The patch clamps writespace in smc_tx_sendmsg() to sndbuf_desc->len. It
also maps negative values to len. This keeps the copy inside the send
buffer when conn->sndbuf_space has been over-credited, either after an
SMC-R link failover or through the SMC-D DMB merge path.

> diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> index 3144b4b1fe290..58d9dfdcdf33e 100644
> --- a/net/smc/smc_tx.c
> +++ b/net/smc/smc_tx.c
> @@ -233,6 +233,14 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
>  		/* initialize variables for 1st iteration of subsequent loop */
>  		/* could be just 1 byte, even after smc_tx_wait above */
>  		writespace = atomic_read(&conn->sndbuf_space);
> +		/* sndbuf_space can be out of range: late completions of an
> +		 * old SMC-R link credit it again after a failover, and with
> +		 * SMC-D DMB merge it follows the peer's consumer cursor.

[Severity: Low]
This isn't a bug, but the new comment says sndbuf_space can be out of
range. A few lines further down in the same loop, the existing comment
still says the opposite:

net/smc/smc_tx.c:smc_tx_sendmsg() {
    ...
	atomic_sub(copylen, &conn->sndbuf_space);
	/* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */
	smp_mb__after_atomic();
    ...
}

The same "guarantee" comment also appears in the credit paths that the
new comment names: smc_cdc_tx_handler(), smcd_cdc_msg_send() and the DMB
merge branch of smc_cdc_msg_recv_action().

The clamped subtraction doesn't bring the value back into that range. If
sndbuf_space starts at 3 * len, subtracting copylen <= len leaves at
least 2 * len. A negative value is mapped to len and then pushed further
below zero.

Should those comments be updated or dropped so they don't contradict the
new one?

> +		 * Bound writespace, which sizes the copy; a negative value
> +		 * would become huge in the size_t min_t() below.
> +		 */
> +		if (writespace < 0 || writespace > conn->sndbuf_desc->len)
> +			writespace = conn->sndbuf_desc->len;

[Severity: High]
Mapping a negative writespace to sndbuf_desc->len is new behaviour from
this patch. It turns a negative sndbuf_space into a full-ring copy on
every pass of the loop. Is that intended?

The gate at the top of the loop treats only zero as no space:

	if (!atomic_read(&conn->sndbuf_space) || conn->urg_tx_pend) {

A negative sndbuf_space is non-zero, so it skips smc_tx_wait()
entirely. The new check then sets writespace to sndbuf_desc->len, so
copylen can be a whole ring.

memcpy_from_msg() writes that at tx_curs_prep. It overwrites whatever
is still unsent in [tx_curs_sent, tx_curs_prep), and whatever is still
unconfirmed in [tx_curs_fin, tx_curs_sent) that an in-flight RDMA write
may still be reading.

The atomic_sub(copylen, &conn->sndbuf_space) afterwards pushes the
value further below zero. This path can therefore never bring it back
to zero. The loop keeps copying until the whole message is consumed,
with no back-pressure. That lasts until CDC completions happen to
credit sndbuf_space back above zero.

smc_tx_wait(), smc_tx_should_cork() and smc_poll() use the same
non-zero test. While the space is negative, a blocked writer would be
woken, corking would still apply, and a poller would see EPOLLOUT.

The note below the --- line says 0 was avoided because the send loop
would spin. That is true with the current !atomic_read() gate. Would it
be better to make the gate treat sndbuf_space <= 0 as no space, along
with the matching checks in smc_tx_wait(), smc_tx_should_cork() and
smc_poll()? A negative value would then block the sender instead of
letting it overwrite data the peer has not received.

Before this patch a negative value caused an out-of-bounds write. With
it, the result is silent stream corruption that sendmsg() reports as
success.

[Severity: High]
This is a pre-existing issue, and this patch didn't introduce it. The
clamp limits the size of each copy but doesn't fix the flow control.
While sndbuf_space is over-credited, can smc_tx_sendmsg() still overwrite
data in the send buffer that hasn't been sent or confirmed yet?

The wait check at the top of the loop counts any non-zero value as free
space:

	if (!atomic_read(&conn->sndbuf_space) || conn->urg_tx_pend) {

smc_tx_wait(), smc_tx_should_cork() and smc_poll() make the same check.
Each pass then copies up to sndbuf_desc->len bytes at tx_curs_prep and
subtracts only copylen. A value of 3 * len stays positive for two more
passes. A negative value never reaches zero.

That lets tx_curs_prep run more than a full ring past tx_curs_sent and
tx_curs_fin. The copy then overwrites unsent bytes in
[tx_curs_sent, tx_curs_prep), plus bytes in [tx_curs_fin, tx_curs_sent)
that in-flight RDMA writes may still be reading.

smc_tx_rdma_writes() then computes:

	to_send = smc_curs_diff(conn->sndbuf_desc->len, &sent, &prep);

That value is now larger than len, so the overwritten ring contents get
sent. sendmsg() reports success, but the peer receives a corrupted
stream.

One trigger is a peer DELETE LINK while the old QP still works:

smc_llc_process_cli_delete_link()
  smc_switch_conns(lgr, lnk_del, false)

A CDC completion still pending on the old link is later handled by
smc_wr_tx_process_cqe()->smc_cdc_tx_handler() with a stale
cdcpend->cursor. If tx_curs_fin is one wrap ahead, smc_curs_diff()
returns nearly 2 * len and tx_curs_fin moves back. The next completion
then credits the same bytes again.

If corking with MSG_MORE or a full peer RMBE keeps tx_curs_sent from
moving between passes, the overwrite is guaranteed.

The note below the --- line already says that "send() can still
overwrite data in the buffer that the peer has not received yet". Before
this patch, the same over-credit caused an out-of-bounds write instead.
Is a fix for the credit in smc_cdc_tx_handler() planned as a follow-up?

[Severity: High]
This is also a pre-existing issue. What serializes smc_switch_cursor()
against smc_cdc_tx_handler()?

smc_switch_conns() holds only conn->send_lock around the switch:

	spin_lock_bh(&conn->send_lock);
	smc_switch_link_and_count(conn, to_lnk);
	rc = smc_switch_cursor(smc, pend, wr_buf);
	spin_unlock_bh(&conn->send_lock);

smc_switch_cursor() rewrites tx_curs_sent, tx_curs_fin,
local_tx_ctrl.prod and local_tx_ctrl_fin, and it adds to sndbuf_space.

smc_cdc_tx_handler() runs from the send CQ tasklet. It does a non-atomic
read, diff, add and copy while holding only bh_lock_sock():

	bh_lock_sock(&smc->sk);
	if (!wc_status && sndbuf_desc) {
		diff = smc_curs_diff(sndbuf_desc->len,
				     &cdcpend->conn->tx_curs_fin,
				     &cdcpend->cursor);
		...
		atomic_add(diff, &cdcpend->conn->sndbuf_space);
		...
		smc_curs_copy(&conn->tx_curs_fin, &cdcpend->cursor, conn);

Neither path takes the other's lock, and the tasklet can run on another
CPU in the middle of the switch. One possible interleaving:

CPU1 (smc_switch_cursor)
  smc_curs_copy(&conn->tx_curs_sent, &conn->tx_curs_fin, conn);
  smc_curs_copy(&fin, &conn->local_tx_ctrl_fin, conn);

CPU2 (smc_cdc_tx_handler)
  atomic_add(diff, &cdcpend->conn->sndbuf_space);
  smc_curs_copy(&conn->tx_curs_fin, &cdcpend->cursor, conn);

CPU1 (smc_switch_cursor, diff computed from the older fin)
  smc_curs_add(conn->sndbuf_desc->len, &conn->tx_curs_fin, diff);
  atomic_add(diff, &conn->sndbuf_space);

Does this credit the same bytes twice and leave tx_curs_fin ahead of
tx_curs_sent?

The patch bounds only the local writespace snapshot. The shared
sndbuf_space would stay inflated, so smc_tx_sendmsg() could still
overwrite unsent data. On SMC-R an RDMA write may still be using that
data. With SMC-D nocopy, the peer may still be reading it from its DMB.

>  		/* not more than what user space asked for */
>  		copylen = min_t(size_t, send_remaining, writespace);
>  		/* determine start of sndbuf */

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261013-b4-disp-f345196c-v7-0-ef3dddfbfa68%40proton.me
