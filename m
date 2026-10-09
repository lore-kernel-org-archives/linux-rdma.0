Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E94044C51D;
	Fri,  9 Oct 2026 06:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791528083; cv=none; b=lhFF0fOkXZRCfar/8fWXiQPd7gpR9x082q8NEWxSrowrJT9pdvOKbEILe4bemnM6vFdJfWYiBU3Y2D3te2eR8YhAN6xNXmhQQVXIL49TA5WR3DJEG6Y9XBercs0TMPHxeaRNwMp+FOOFGj0kyoSvFhFwEm35ZaMVIx2kGkDtxM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791528083; c=relaxed/simple;
	bh=5b7bEvA9D1R3qorEecj7lbUy+UeZj+EmNcJYtor+Izw=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cA1HlrKtr6H1vet8orAOjAFEtin5g5g7KCk8kbPnBmNo1rZFYIwYzPeEuTo8JcofrKM0eJPbQIvHK/zCnZ1j1LE7bPTg2DQAbXRBMhI/dt0RiFdLKtZkncFMl290sXoqioi9KdjGGALmtDX7eUd/YTg0Cr7XbzaNwwW8UbaTdcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T8VAtbVO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T8VAtbVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5471B1F000FF;
	Fri,  9 Oct 2026 06:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791528081;
	bh=3/gbkzEDX1YSsF3k49PS/NV+iCMWzcitK5U03jM0BP8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=T8VAtbVOuBa1Ye5d8d03QSCkbp/iRJjaONNklr+BXGSlMMg0kL9KaS/9kE0jDjZDv
	 GHMlauRRxPpky9QHwahVofNgAVqug0A+2rEZ601nemODJOewvRdlAqdTjyVaZ/miJm
	 Uxwg0ziiZ9U8isHpM57mwK/OGcIRpS0dH/O41akVNun1IyhPkydf4O7BnPf3k43Opr
	 4bU6xGMXRTAN0EhuZlnxy7Xk1tVFDqQEqvgWDGvhgs9aLtq83TmFqxczG31hDh47rB
	 pRxbogHCLEHveVHF514m3to5ltC0YcaFRzzBZExMi+Y6eFy+WR5W5GQqHtZuELVqZe
	 BvRxLaipnzNpg==
Subject: Re: [PATCH net v6 3/3] net/smc: bound the send length to the send
 buffer in smc_tx_sendmsg()
From: netdev-bot+sashiko@kernel.org
To: hexlabsecurity@proton.me
Cc: sidraya@linux.ibm.com, alibuda@linux.alibaba.com, edumazet@kernel.org,
 mjambigi@linux.ibm.com, dust.li@linux.alibaba.com, davem@davemloft.net,
 pabeni@redhat.com, kuba@kernel.org, raspl@linux.ibm.com,
 tonylu@linux.alibaba.com, hidayath@linux.ibm.com, ubraun@linux.ibm.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, horms@kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
 guwen@linux.alibaba.com, wenjia@linux.ibm.com
Date: Fri, 09 Oct 2026 06:41:19 +0000
Message-ID: <179152807992.434549.3295281690534839972@kernel.org>
In-Reply-To: <20261008-b4-disp-f7cd3d96-v6-3-fba616c0920c@proton.me>
References: <20261008-b4-disp-f7cd3d96-v6-3-fba616c0920c@proton.me>
X-sashiko-severity: Medium
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

Critical: 0 · High: 0 · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message's threat model does not match the code it
  changes.
- [Medium] The patch says it 'enforces the documented 0 <= sndbuf_space
  <= sndbuf_desc->len invariant'.

--

net/smc: bound the send length to the send buffer in smc_tx_sendmsg()

This patch clamps the local writespace snapshot in smc_tx_sendmsg() to
sndbuf_desc->len. A negative value is also treated as out of range. The
stated goal is to prevent a heap out-of-bounds write in the wrap-around
copy when the SMC-D DMB-merge path inflates conn->sndbuf_space from a
forged consumer cursor.

> On the SMC-D DMB-merge (nocopy) path, smc_cdc_msg_recv_action()
> advances conn->sndbuf_space from the peer's wire-controlled consumer
> cursor via smc_curs_diff(), which can return more than sndbuf_desc->len;
> a forged cursor drives sndbuf_space past the send buffer, and over many
> CDC messages overflows the signed counter negative. smc_tx_sendmsg()
> reads it as the write space and does a wrap-around copy whose second
> chunk is not re-bounded to sndbuf_desc->len, spilling the local
> sender's outbound data past the send buffer at a peer-controlled
> length: a heap out-of-bounds write.

[Severity: Medium]
Is "the peer's wire-controlled consumer cursor" accurate for this path?

The diff_tx update in smc_cdc_msg_recv_action() only runs behind this
check:

	if (conn->lgr->is_smcd &&
	    smc_ism_support_dmb_nocopy(conn->lgr->smcd)) {

and smc_ism_support_dmb_nocopy() is:

	/* for now only loopback-ism supports
	 * merging sndbuf with peer DMB to avoid
	 * data copies between them.
	 */
	return (smcd->dibs->ops->support_mmapped_rdmb &&
		smcd->dibs->ops->support_mmapped_rdmb(smcd->dibs));

The only in-tree provider of support_mmapped_rdmb is dibs_lo_ops in
drivers/dibs/dibs_loopback.c. dibs_lo_query_rgid() accepts only its own
GID, so the peer on this path is the same kernel's SMC stack.

That kernel builds the consumer cursor from its own connection state in
smcd_cdc_msg_send():

	curs.acurs.counter = atomic64_read(&conn->local_tx_ctrl.cons.acurs);
	cdc.cons.wrap = curs.wrap;
	cdc.cons.count = curs.count;

dibs_lo_move_data() then copies it into the DMB with a bounds check.
Userspace does not write the CDC header area of the DMB.

The buffer lengths also match. smcd_new_buf_create() sets rmb_desc->len
to bufsize - sizeof(struct smcd_cdc_msg). smcd_buf_attach() sets the
attached sndbuf_desc->len to dmb_len - sizeof(struct smcd_cdc_msg). So a
conforming cursor should not produce a diff_tx larger than
sndbuf_desc->len.

Given this, is the patch hardening against a misbehaving in-kernel peer
or a future nocopy-capable device, rather than fixing a heap
out-of-bounds write that a peer can trigger? If so, could the commit
message be reworded? The current wording and the Fixes: and Cc: stable
tags describe a memory corruption that a remote peer controls.

> diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> index 3144b4b1fe290..5916f02060fb9 100644
> --- a/net/smc/smc_tx.c
> +++ b/net/smc/smc_tx.c
> @@ -233,6 +233,19 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
>  		/* initialize variables for 1st iteration of subsequent loop */
>  		/* could be just 1 byte, even after smc_tx_wait above */
>  		writespace = atomic_read(&conn->sndbuf_space);
> +		/* sndbuf_space is advanced from the peer's wire-controlled
> +		 * consumer cursor on the SMC-D DMB-merge path; a forged cursor
> +		 * can inflate it past the send buffer, or overflow the signed
> +		 * accumulator to a negative value across many CDC messages
> +		 * (which a plain "> len" check would miss before the size_t
> +		 * cast below turns it huge).  Bound it to the send buffer in
> +		 * either case so the wrap-around write cannot run past
> +		 * sndbuf_desc->len.  This enforces the documented
> +		 * 0 <= sndbuf_space <= sndbuf_desc->len invariant at the
> +		 * producer, race-free against the CDC tasklet.
> +		 */
> +		if (writespace < 0 || writespace > conn->sndbuf_desc->len)
> +			writespace = conn->sndbuf_desc->len;

[Severity: Medium]
Does this enforce the invariant on conn->sndbuf_space itself? Only the
local writespace snapshot is clamped. The shared atomic is never
corrected.

Later in smc_tx_sendmsg(), the subtraction still runs on the
out-of-range value:

		atomic_sub(copylen, &conn->sndbuf_space);
		/* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */

A negative counter goes further negative. A value of
2 * sndbuf_desc->len stays at sndbuf_desc->len after a full-ring copy.

The source of the value is also unchanged.
smc_cdc_msg_recv_action() still adds diff_tx without a bound:

			atomic_add(diff_tx, &conn->sndbuf_space);
			/* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */

smcd_cdc_msg_to_host() copies peer->cons without the wrap and count
check that smc_cdc_cursor_to_host() does for SMC-R.

If the premise in the commit message holds, the other readers would
still see the bad value:

  smc_tx_sendmsg():  if (!atomic_read(&conn->sndbuf_space) || ...
  smc_tx_wait(), smc_tx_should_cork(), smc_poll() EPOLLOUT
  smc_ioctl() SIOCOUTQ:
	answ = smc->conn.sndbuf_desc->len -
			atomic_read(&smc->conn.sndbuf_space);

The counter would never reach zero, so sendmsg would not block. It
would keep rewriting the whole ring over data the peer has not consumed
yet. SIOCOUTQ could return a negative value or one larger than the
buffer.

The commit message also says the bound is applied "at the consumer",
but this comment says "at the producer". Which one is meant?

Would it be more accurate to describe this as bounding the copy length?
Alternatively, diff_tx (or the cursor) could also be bounded where it is
received, in smc_cdc_msg_recv_action().

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008-b4-disp-f7cd3d96-v6-0-fba616c0920c%40proton.me
