Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792952867;
	b=lNnlZj0n7gfhH52GdIOpISB8WVKUa7HEyvvz2ISHymQA3i/frX+30hR2zuzYZdGR/57g
	 7C/4TM+t1O14VlwH2ZR6G8FkzWpCx+gvRE140P0T9AVE3LWzggZ1QDeRId0KpIvHChKfl
	 5oeHwiusuM9YSLlbmd7vy/7mwqnM39Vv64T7K+AJrTr9Lqb+kdgWvkOIWz0vmvAmFF06+
	 4E4P7UNRgT3vxv6LU2fYYYhYtNRugx4uzQR+h/jlIe39gFFKzqWTy5M4dqBPQfz613wrf
	 kCuRpImY+tj+C+5QfsPJVhmLO+s+oKzoUzp+cewi6UcyO395bjQH8IBKqqU6bSIrqtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792952867;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Mh5dFoOMS3PFvBK0c6CVtn5720vChxrpeNVPd+FGBTw=;
	b=h5LWmxmZ7YqjB4PjYscEDZH+U7Rpb7AZEF9S8Un29ReOUkpoxw0ynnnAKl/W6XYcrPx1
	 w03RX8kjMV1qPL1DY63AHuKNO+g4QREZF3rJeCrBtwFfbEZm7AEx6pofP4fo3L/TCgnJh
	 X6vlN+3xj8/3MKZ5CDjxO3eH8qfbH5yMiG2JNjZ3mNrPGSQDgrJDbb3v4xVMVvpyr//qt
	 huT1A87nvh2jwBOKJIPO0sG0kpMVWn+mNY2cG9QqJI8t8Hr6vZnb4PIK8e4wviT1OpgiJ
	 RwqjkCUCN5Ya96ER+TN7780EfCRSN9pQNY5Nrc0MmdN6zHAQNHs8Aw6LCB086ytGNhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PqfjWbHb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6C9606A31A;
	Sun, 25 Oct 2026 18:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PqfjWbHb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2F41F01825;
	Sun, 25 Oct 2026 18:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792952867;
	bh=Mh5dFoOMS3PFvBK0c6CVtn5720vChxrpeNVPd+FGBTw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=PqfjWbHbp7LQUfC2jTCzoRsSeoj7+ifstqWaZaHf/+8weXcVAiJ4VFoabyKPPIVYW
	 cscO90qDX/JqMl7Q2al3fURaXwW9kPEeh+4rusMim8eHv/JmV8qpzXtNhEOKkYX+jv
	 5lDA82BIhjiRtZGoOzcLoWHenFSOXX7UqxOtRRjIVLF36XuEJ7e8pQQuagKneF235c
	 bbbTxq/HC5ZPP02BbTMP6U+SrL0yreb4l5FZC6ByayyDKsRgvAcUv7tApD5Z/SuxO5
	 9BpTSPYESiaGyqnJJbDxUx3NOlRNBZltBSS4eIRDInxuKVOokG2U3J6CzUvL5md1vv
	 UK3JuzYMVnHyw==
Subject: Re: [PATCH] net/smc: reject CDC messages after connection teardown
From: netdev-bot+sashiko@kernel.org
To: bestswngs@gmail.com
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, ubraun@linux.ibm.com,
 kgraul@linux.ibm.com, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, xmei5@asu.edu,
 stable@vger.kernel.org
Date: Sun, 25 Oct 2026 18:27:45 +0000
Message-ID: <179295286564.3134.7940509551259167742@kernel.org>
In-Reply-To: <20261021171256.166870-2-bestswngs@gmail.com>
References: <20261021171256.166870-2-bestswngs@gmail.com>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 (2) · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix is incomplete, so the use-after-free it targets can
  still happen.

Pre-existing issues:
- [Medium] This problem wasn't introduced by this patch, but
  smc_cdc_rx_handler() has a second post-lookup branch that the new…
- [Medium] This problem wasn't introduced by this patch, but
  smc_conn_free() (net/smc/smc_core.c:1279-1280) calls…

--

net/smc: reject CDC messages after connection teardown

This patch adds a conn->freed check in smc_cdc_msg_recv() after
bh_lock_sock(). The goal is to discard CDC messages that passed the
connection lookup before close(2) tore the connection down. That avoids a
use-after-free of a registration-failed RMB descriptor released by
smc_conn_free().

> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index 32d6d03df3214..499a2473b79b4 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -428,7 +428,8 @@ static void smc_cdc_msg_recv(struct smc_sock *smc, struct smc_cdc_msg *cdc)
>  {
>  	sock_hold(&smc->sk);
>  	bh_lock_sock(&smc->sk);
> -	smc_cdc_msg_recv_action(smc, cdc);
> +	if (!smc->conn.freed)
> +		smc_cdc_msg_recv_action(smc, cdc);

[Severity: High]
Does this check serialize against smc_conn_free()?

bh_lock_sock() only takes sk->sk_lock.slock. The close path calls
smc_conn_free() while it owns the socket through lock_sock().
lock_sock_nested() sets sk_lock.owned and then drops slock, or it takes
the cmpxchg fast path. Either way, the owner does not hold slock while
smc_conn_free() runs, and smc_conn_free() never takes slock itself.

The sock_owned_by_user() branch already in smc_cdc_msg_recv_action() also
shows that this tasklet is expected to run while a process owns the socket.

On SMC-R, could this sequence still happen?

CPU0 (smc_wr_rx tasklet)
smc_cdc_rx_handler()
  smc_lgr_find_conn()
  read_unlock_bh(&lgr->conns_lock)
  smc_cdc_msg_recv()
    bh_lock_sock()          /* slock is free */
    if (!smc->conn.freed)   /* sees 0 */
      smc_cdc_msg_recv_action()

CPU1 (close, owns the socket via lock_sock())
smc_release()->__smc_release()->smc_conn_free()
  conn->freed = 1;
  smc_cdc_wait_pend_tx_wr()        /* only waits for TX */
  cancel_work_sync(&conn->abort_work)
  smc_buf_unuse()->smcr_buf_unuse()->smc_buf_free()
    /* is_reg_err rmb_desc is kfree()d */

CPU0
smc_cdc_msg_recv_action()
  smc_curs_diff(conn->rmb_desc->len, ...)

That last read is the same one shown in the KASAN report. If urgent data is
present, smc_cdc_handle_urg_data_arrival() also reads
conn->rmb_desc->cpu_addr.

smc_lgr_unregister_conn() takes write_lock_bh(&lgr->conns_lock). However,
it runs after smc_buf_unuse() and only waits for the lookup section. The
tasklet's sock_hold() keeps the smc_sock alive, but it does not protect
rmb_desc.

On SMC-D, tasklet_kill(&conn->rx_tsklet) in smc_conn_free() drains RX
processing. There does not seem to be an equivalent on SMC-R.

conn->freed is also written and read without a shared lock, and without
READ_ONCE()/WRITE_ONCE().

The commit message says:

    Both smc_conn_free() and CDC message processing run under the socket lock.

Is that accurate, given that the two sides use different parts of the
socket lock?

One option is for smc_conn_free() on SMC-R to set conn->freed under
bh_lock_sock() / spin_lock_bh(&sk->sk_lock.slock) before it releases any
buffers. A tasklet that already saw freed == 0 would then finish first.
Another option is to wait for in-flight RX processing before rmb_desc is
freed. Would either of these work?

>  	bh_unlock_sock(&smc->sk);
>  	sock_put(&smc->sk); /* no free sk in softirq-context */
>  }

[Severity: Medium]
This is a pre-existing issue and was not introduced by this patch.
smc_cdc_rx_handler() has a second path after the lookup that the new check
does not cover:

net/smc/smc_cdc.c:smc_cdc_rx_handler() {
    ...
	sock_hold(&smc->sk);
	read_unlock_bh(&lgr->conns_lock);

	if (cdc->prod_flags.failover_validation) {
		smc_cdc_msg_validate(smc, cdc, link);
		goto out;
	}
    ...
}

smc_cdc_msg_validate() runs without the socket lock and without a
conn->freed check. If the seqno sent by the peer makes diff < 0, it does
this:

	conn->lnk = link;
	spin_unlock_bh(&conn->send_lock);
	sock_hold(&smc->sk); /* sock_put in abort_work */
	if (!queue_work(smc_close_wq, &conn->abort_work))

Suppose the lookup lands while smc_conn_free() is inside smc_buf_unuse().
That is after cancel_work_sync(&conn->abort_work) and before
smc_lgr_unregister_conn(), and smc_buf_unuse() can sleep in the LLC
delete-rkey flow. Can abort_work then be queued after it was already
cancelled?

If so, smc_conn_abort_work()->smc_conn_kill() reads conn->lgr->is_smcd with
no freed check. By then smc_conn_free() has dropped the connection's lgr
and link references through smc_lgr_put() and smcr_link_put(), and
conn->lgr is never cleared. Could this be a use-after-free of the link
group if the link group is torn down at the same time?

The conn->lnk = link assignment also takes no reference with
smcr_link_hold(). Could it race with smcr_link_put(conn->lnk) in
smc_conn_free() and drop the reference on the wrong link?

The commit message says "Discard messages which passed the lookup before
teardown", but only the smc_cdc_msg_recv() path does that.

[Severity: Medium]
This is also a pre-existing issue and was not introduced by this patch.
smc_conn_free() ignores the return value of cancel_work_sync():

net/smc/smc_core.c:smc_conn_free() {
    ...
		smc_cdc_wait_pend_tx_wr(conn);
		if (current_work() != &conn->abort_work)
			cancel_work_sync(&conn->abort_work);
    ...
}

smc_cdc_msg_validate() calls sock_hold() before it queues abort_work. The
only matching sock_put() is in smc_conn_abort_work():

	sock_put(&smc->sk); /* sock_hold done by schedulers of abort_work */

If abort_work is still pending when smc_conn_free() cancels it, the callback
never runs. Does that leak the smc_sock reference taken in
smc_cdc_msg_validate(), so the socket is never freed?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261021171256.166870-2-bestswngs%40gmail.com
