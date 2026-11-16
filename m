Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794834039;
	b=w7XKtbhVFxwhL0Cy3wi2qCaLeg3NrS/5XpzpBr+QY7dcMbbIeX36gKRZdLWoTZb8Jmyb
	 pWPvU/FIcdpyFyudahW76QUG+3/Gr43wZ+eouqHlldNG8+5rp8TLKn+pRZL2pKE6eDiXM
	 gioxzioj34G9u/05w8lo/AdcjBUKyLcVLxWPDB/d56xZZqYC+rnW5ZD6CUmRg4K6amp0X
	 ZrLpuXZPbSS2dg6mYMIxi/3NNvNazWL8TlSo/uPXsxs/zjzflGzvvXohcTwPb7H0lzDPh
	 2LoycfChzhcPN6WjFU5yUu3RQemWOr/pcnTY30BZc49imQ4x4hfegNxu+THksCH78lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794834039;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=3B7OyocIRHjJ2dbD2X+MT3B53RHHwGiwuhiBvqIoS8w=;
	b=BfEgD2sFUZrZCPJzNECWJFvUZ2RvMaZ7cWbUZW/co4BS+YDaMc2kw3zeRYrjIW2hLEno
	 /Vom8X0jUrsDv7mhjNJdYBQepRVnkNRNKmxEbrOXmhu5WvJrV2PxTYezEOIsXloac6ivG
	 bL8UFOxa7+4xNHzRItuygzj3lIHfRwSMGcmNTKfqvrbST36DBTQncJK8e5lhZScy8rgAO
	 B24s4Lk0JDcT4efg8mVf3D5wI21IoS+Eg+nnqICtKelskhQcXlC+8sei+U9V2psyzZ0Yy
	 Tdnbk1h4fOfIRa+tY5t67ZevOcz3+OW62tlbrfNTG0aA+m8IgSOCPjnxxdXdpQTdSxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nIdxuvzt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A19606A33A;
	Mon, 16 Nov 2026 13:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nIdxuvzt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C0F1F000C4;
	Mon, 16 Nov 2026 13:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794834038;
	bh=3B7OyocIRHjJ2dbD2X+MT3B53RHHwGiwuhiBvqIoS8w=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=nIdxuvztI9+VcvKL/NpmGo+VzFJG/gXvgbpa025zQE6xcLzZdsdZFtH7CxrCPVtSK
	 av2dHzf4ETYtjRhrH6/LEhMZ1fBteknXOZL22Y1B1p8dO39DNy+p86BIAJxOFEmlur
	 9i1pClXcTcYVJ7xXn7hDd5Vto79uO1brepfdiTy7MrtgRaOk1cd+Dkmj8S9DY0YBBA
	 +ZjgkT/DNy+vsknbFxcDWoQk/0C/38hsWSmBl3clchGyRy3wZEYmw3eecVVugg9Gbj
	 +Mot1TKSofGdo08QRAyKNWRlygtKESEOnmxckO5CyOl6dvim1JDTvTOLycXmR/xB8Y
	 zlRShn5fT4D3w==
Subject: Re: [PATCH net v9 3/6] net/smc: bound the send length to the send
 buffer in smc_tx_sendmsg()
From: netdev-bot+sashiko@kernel.org
To: hexlabsecurity@proton.me
Cc: mjambigi@linux.ibm.com, dust.li@linux.alibaba.com, edumazet@kernel.org,
 pabeni@redhat.com, davem@davemloft.net, kuba@kernel.org,
 alibuda@linux.alibaba.com, sidraya@linux.ibm.com, ubraun@linux.ibm.com,
 wenjia@linux.ibm.com, raspl@linux.ibm.com, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, guwen@linux.alibaba.com,
 tonylu@linux.alibaba.com, horms@kernel.org, guangguan.wang@linux.alibaba.com,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org, hidayath@linux.ibm.com
Date: Mon, 16 Nov 2026 13:00:37 +0000
Message-ID: <179483403722.3136.1364122923722036240@kernel.org>
In-Reply-To: <20261112-b4-disp-0287c16e-v9-3-e5e8fa688177@proton.me>
References: <20261112-b4-disp-0287c16e-v9-3-e5e8fa688177@proton.me>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The patch changes the sndbuf_space invariant comment to "can be
  out of range" in smc_cdc_tx_handler() (net/smc/smc_cdc.c:46) and after…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the clamp in
  smc_tx_sendmsg() limits writespace to sndbuf_desc->len (the allocation…
- [High] This problem wasn't introduced by this patch, but the failover
  catch-up in smc_switch_cursor() and the completion handler…

--

net/smc: bound the send length to the send buffer in smc_tx_sendmsg()

This commit clamps writespace in smc_tx_sendmsg() to sndbuf_desc->len,
negative values included. The goal is to keep the copy inside the send
buffer when conn->sndbuf_space has been over-credited after an SMC-R
link failover or through SMC-D DMB merge. It also rewrites the
sndbuf_space invariant comments in smc_cdc_tx_handler() and
smc_tx_sendmsg().

> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index e2c765ff2ba35..90a79a983b485 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -43,7 +43,7 @@ static void smc_cdc_tx_handler(struct smc_wr_tx_pend_priv *pnd_snd,
>  		/* sndbuf_space is decreased in smc_sendmsg */
>  		smp_mb__before_atomic();
>  		atomic_add(diff, &cdcpend->conn->sndbuf_space);
> -		/* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */
> +		/* can be out of range, see smc_tx_sendmsg() */

[Severity: Low]
The comment is updated here and after the atomic_sub() in
smc_tx_sendmsg(). Two other sndbuf_space credit sites in smc_cdc.c still
have the old wording.

The dmb_nocopy branch of smc_cdc_msg_recv_action():

    atomic_add(diff_tx, &conn->sndbuf_space);
    /* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */

and smcd_cdc_msg_send():

    atomic_add(diff, &conn->sndbuf_space);
    /* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */

The new comment in smc_tx_sendmsg() and the commit message both list the
DMB merge path as a way for sndbuf_space to go out of range ("with SMC-D
DMB merge it follows the peer's consumer cursor"). That makes the comment
in smc_cdc_msg_recv_action() contradict them.

Should these two comments be updated too? As far as I can see, no later
patch in the series touches smc_cdc.c, so both are still there at the
end of the series.

>  		smp_mb__after_atomic();
>  		smc_curs_copy(&conn->tx_curs_fin, &cdcpend->cursor, conn);
>  		smc_curs_copy(&conn->local_tx_ctrl_fin, &cdcpend->p_cursor,

[Severity: High]
This is a pre-existing issue and was not introduced by this patch. Is
the failover catch-up in smc_switch_cursor() serialized against this
handler at all?

smc_switch_conns() holds only the send_lock:

    spin_lock_bh(&conn->send_lock);
    smc_switch_link_and_count(conn, to_lnk);
    rc = smc_switch_cursor(smc, pend, wr_buf);
    spin_unlock_bh(&conn->send_lock);

smc_cdc_tx_handler() runs from the old link's CQ tasklet and holds only
bh_lock_sock(&smc->sk). Both read tx_curs_fin and local_tx_ctrl_fin, and
both credit conn->sndbuf_space.

Can this interleaving credit the same bytes twice?

CPU1 smc_switch_cursor()
    smc_curs_copy(&conn->tx_curs_sent, &conn->tx_curs_fin, conn);
    smc_curs_copy(&fin, &conn->local_tx_ctrl_fin, conn);

CPU2 smc_cdc_tx_handler() (late completion from the old link)
    atomic_add(diff, &cdcpend->conn->sndbuf_space);
    smc_curs_copy(&conn->tx_curs_fin, &cdcpend->cursor, conn);
    smc_curs_copy(&conn->local_tx_ctrl_fin, &cdcpend->p_cursor, conn);

CPU1
    diff = smc_curs_diff(conn->peer_rmbe_size, &fin, &cons);
    ...
    atomic_add(diff, &conn->sndbuf_space);

CPU1 computes diff from its stale fin snapshot, so it credits again the
bytes that CPU2 already credited.

In this commit, smc_switch_cursor() also updates tx_curs_fin and
local_tx_ctrl_fin with a plain read-modify-write smc_curs_add(), and
that can tear against the handler's smc_curs_copy(). The later patch in
this series, "net/smc: bound the link failover cursor advance to the
send buffer", replaces those adds with smc_curs_copy() and fixes the
tearing. Its commit message says the double credit remains:

  "The switch is still not serialized against the handler: a completion
  handled inside it is still credited more than once and can make the
  next write hand the peer bytes it has already read."

The result is an inflated sndbuf_space. The clamp in smc_tx_sendmsg()
only bounds it where it is used.

> diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> index 0f0c6df3bf2ce..3913ef103b356 100644
> --- a/net/smc/smc_tx.c
> +++ b/net/smc/smc_tx.c
> @@ -233,6 +233,14 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
>  		/* initialize variables for 1st iteration of subsequent loop */
>  		/* could be just 1 byte, even after smc_tx_wait above */
>  		writespace = atomic_read(&conn->sndbuf_space);
> +		/* sndbuf_space can be out of range: late completions of an
> +		 * old SMC-R link credit it again after a failover, and with
> +		 * SMC-D DMB merge it follows the peer's consumer cursor.
> +		 * Bound writespace, which sizes the copy; a negative value
> +		 * would become huge in the size_t min_t() below.
> +		 */
> +		if (writespace < 0 || writespace > conn->sndbuf_desc->len)
> +			writespace = conn->sndbuf_desc->len;

[Severity: High]
This isn't a bug introduced by this patch, but with writespace clamped
only to sndbuf_desc->len, can the send ring still overwrite data that
has not been sent or acknowledged?

The clamp limits the copy to the size of the allocation. It does not
limit it to the space that is actually free between tx_curs_fin and
tx_curs_prep.

Suppose sndbuf_space holds S > len. Each loop iteration copies up to len
bytes starting at tx_curs_prep.count, then does:

    atomic_sub(copylen, &conn->sndbuf_space);

That leaves S - len > 0, so this check stops neither the loop nor later
sendmsg() calls:

    if (!atomic_read(&conn->sndbuf_space) || conn->urg_tx_pend) {

A few consequences seem to follow.

First, memcpy_from_msg() overwrites [tx_curs_fin, tx_curs_prep). That
range holds bytes that are prepared but not yet sent and, for SMC-R,
bytes still being read by posted RDMA WRITEs. With SMC-D dmb_nocopy the
range is the peer's DMB. Either way, the peer silently receives the
wrong data.

Second, tx_curs_prep can get more than one ring ahead of tx_curs_sent.
smc_curs_diff() handles only a single wrap:

    if (old->wrap != new->wrap)
        return max_t(int, 0,
                     ((size - old->count) + new->count));

so to_send in smc_tx_rdma_writes() comes out wrong, and bytes get
duplicated or lost. When peer_rmbe_size > sndbuf_desc->len, a single
write can carry more than sndbuf_desc->len bytes. The source reads stay
in bounds because the second source chunk is at most prep.count, which
is less than len.

Third, smc_tx_should_cork() pushes only once sndbuf_space reaches 0:

    if ((msg->msg_flags & MSG_MORE ||
         smc_tx_is_corked(smc)) &&
        atomic_read(&conn->sndbuf_space))
        return true;

With MSG_MORE or TCP_CORK set and an inflated value, corked data can be
overwritten before it is flushed.

A conforming peer can still trigger the over-credit at the end of the
series. A late completion from the old link in smc_cdc_tx_handler()
does smc_curs_copy(&conn->tx_curs_fin, &cdcpend->cursor, conn), which
moves fin back. The next completion then credits the same bytes again.
The commit message acknowledges this: "send() can still overwrite data
in the send buffer that the peer has not received".

Could writespace also be bounded by len minus the bytes outstanding
between tx_curs_fin and tx_curs_prep? Or is a follow-up planned that
fixes the credit in smc_cdc_tx_handler()?

>  		/* not more than what user space asked for */
>  		copylen = min_t(size_t, send_remaining, writespace);
>  		/* determine start of sndbuf */

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261112-b4-disp-0287c16e-v9-0-e5e8fa688177%40proton.me
