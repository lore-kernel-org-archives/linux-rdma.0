Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD6A3C3C09;
	Thu,  8 Oct 2026 19:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791488319; cv=none; b=EvGRxl/HzgTdqSJYQhWEuiSvzGNMCW39p+3PkFjx/bl1rUn/NrFTsQB/EqD4nj4me3BuGR6c38KyKredv5ZwJ2c0RfKyBpMgEBcIgqYUYPzbZB46XsBiR/tPU9NrMkznu8G4izd4NlWEgXFdD+fQQ09tjBj9qt/flTAT0nUafAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791488319; c=relaxed/simple;
	bh=mQIazJIqR3/WyQmnb2Q8AmSqL7274j9UgAzqzoexPxI=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rVobL9aU/Wu1R/5fw6QUaxwXCuceqvA0d23+C4W3abO3Buvxkgk2ecbCKe+BsRbmtZp6iSQAcflSbF9m5WAUEXlRXR6UEDTWrYtyJ7NL7lBV5e3irdYz3zL8YDIC6z5rijgo1hetBrW6KL1Fzyh2meV/oJ/HFoM8GcoSTxvAiwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ECpmsvdX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ECpmsvdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B491F000FF;
	Thu,  8 Oct 2026 19:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791488317;
	bh=sCzqnBefz7UooLlE97V5EqoPp7jO57vXhAVsV4fF8ag=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ECpmsvdXhSyc6vRoh8djA5wuYMDkZRAeVyK8B1aSGVFuJebZjrmiqTUojcT1v6v0v
	 ETrWhVcZwoZpDt1VRua7c9YBY9UCjV16Ok7UQAq12ANLvjz/ybsbNEr9Kb25ZOrk/8
	 KBAhe9OZWcg0dDqq7XCXyO99C2NCPgcRjve4gBLxy/fYxSisKIDhYMFJp/Xxd+cVlw
	 6jcvS9ICQ3I8SJC9RHBmPgLsidCYGI5de88pbAbYdOf1IE9X+CkFmtFg5wAjQ/rBSI
	 Uiei9Y6M6hXEjRacFJCsOkyzGnXw8TrWI9MPwb1fDIYTynIc0ymS8KRm/5bbuwSTLA
	 iCbM0p5OS1hkA==
Subject:
 Re: [PATCH net v3] net/smc: fix abort_work termination in smc_conn_free()
From: netdev-bot+sashiko@kernel.org
To: hidayath@linux.ibm.com
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, andrew+netdev@lunn.ch,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 pasic@linux.ibm.com, linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Thu, 08 Oct 2026 19:38:36 +0000
Message-ID: <179148831634.434549.5613903090885439829@kernel.org>
In-Reply-To: <20261006073550.1595003-1-hidayath@linux.ibm.com>
References: <20261006073550.1595003-1-hidayath@linux.ibm.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 (1) · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Resetting conn->freed in smc_conn_create() re-arms a stale
  abort_work, so the new disarm scheme fails when one socket gets a…

Pre-existing issues:
- [High] smc_cdc_msg_validate() (net/smc/smc_cdc.c:319-323) sets
  conn->out_of_sync = 1, local_tx_ctrl.conn_state_flags.peer_conn_abort…

--

net/smc: fix abort_work termination in smc_conn_free()

The patch replaces cancel_work_sync() in smc_conn_free() with a
non-blocking cancel_work(). When cancel_work() removes a pending item, the
patch drops that item's socket reference. smc_conn_abort_work() now skips
smc_conn_kill() once conn->freed is set. INIT_WORK() for abort_work also
moves from smc_conn_create() to smc_sk_init().

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 9974149659c2f..907530e1d6464 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c

[ ... ]

> @@ -1276,8 +1280,13 @@ void smc_conn_free(struct smc_connection *conn)
>  			smcd_buf_detach(conn);
>  	} else {
>  		smc_cdc_wait_pend_tx_wr(conn);
> -		if (current_work() != &conn->abort_work)
> -			cancel_work_sync(&conn->abort_work);
> +		/* Do not wait here: the work takes the socket lock this
> +		 * caller holds. An instance that is already running is
> +		 * parked on that lock and will find conn->freed set; only a
> +		 * still-pending one has to give its reference back.
> +		 */
> +		if (cancel_work(&conn->abort_work))
> +			sock_put(&smc->sk);
>  	}
>  	if (!list_empty(&lgr->list)) {
>  		smc_buf_unuse(conn, lgr); /* allow buffer reuse */

[ ... ]

> @@ -1750,7 +1759,12 @@ static void smc_conn_abort_work(struct work_struct *work)
>  	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
>  
>  	lock_sock(&smc->sk);
> -	smc_conn_kill(conn, true);
> +	/* smc_conn_free() sets freed with this lock held and before it
> +	 * releases anything, so an instance that was queued or parked by
> +	 * then has nothing left to do.
> +	 */
> +	if (!conn->freed)
> +		smc_conn_kill(conn, true);

[Severity: High]
Can a stale abort_work still run smc_conn_kill() on a later connection of
the same socket?

cancel_work() does not wait for an instance that is already running, and it
does not block a later requeue. That leaves conn->freed as the only thing
disarming the work. However, smc_conn_create() clears it unconditionally:

net/smc/smc_core.c:smc_conn_create() {
    ...
	smc_lgr_hold(conn->lgr); /* lgr_put in smc_conn_free() */
	if (!conn->lgr->is_smcd)
		smcr_link_hold(conn->lnk); /* link_put in smc_conn_free() */
	conn->freed = 0;
    ...
}

On the listen side, the socket can get a second connection while
smc_listen_work() still holds the socket lock:

smc_listen_work()
  smc_listen_find_device()
    smc_find_rdma_v2_device_serv()
      smc_listen_rdma_init()
        smc_conn_create()              /* conn A, maybe reused lgr */
      smc_listen_rdma_reg()
        smcr_lgr_reg_rmbs()
          smc_llc_do_confirm_rkey()    /* peer times out or RKEY_NEG */
      smc_conn_abort()
        smc_conn_free()                /* conn->freed = 1 */
    smc_find_rdma_v1_device_serv()     /* when prfx_rc == 0 */
      smc_listen_rdma_init()
        smc_conn_create()              /* conn B, conn->freed = 0 */

A failover_validation CDC for conn A can arrive in this window.
smc_cdc_rx_handler() looks up conn A, drops lgr->conns_lock, and
smc_cdc_msg_validate() queues abort_work. That work is either parked in
lock_sock() or queued after the cancel_work() in smc_conn_free(A).

In both cases it can only proceed after smc_listen_out() releases the socket
lock. By then conn->freed is 0 again, so smc_conn_kill(conn, true) runs on
conn B. That sends an abort, unregisters conn B and closes the socket.

smc_conn_create() also never clears conn->out_of_sync or
local_tx_ctrl.conn_state_flags.peer_conn_abort. smc_cdc_msg_validate() set
both for conn A, so does conn B inherit them? If so, every CDC for conn B
would be dropped by the out_of_sync check in smc_cdc_rx_handler().

Triggering this needs a validation CDC with conn A's alert token before the
CLC accept is sent. So it would take a misbehaving SMC-R peer that shares an
existing link group, rather than a well-behaved one.

Before this patch, the same sequence ran into cancel_work_sync() or re-ran
INIT_WORK() on a pending item. So this looks like a gap in the fix rather
than something new compared to the baseline.

The commit message says:

  "An instance that is running is parked on that lock and will find the
  flag set; an instance queued afterwards finds the same."

The new comment above smc_conn_free() also says conn->freed "disarms a
pending or running abort_work".

Do these statements still hold when the connection is re-created on the same
socket? The commit message itself notes that smc_listen_find_device()
creates a connection once per device it tries.

Would a per-lifetime guard be needed here instead of the freed flag alone?
For example, a generation number recorded when the work is queued and
checked in smc_conn_abort_work(). Another option would be to reset the abort
state and drain safely before re-creating the connection.

>  	release_sock(&smc->sk);
>  	sock_put(&smc->sk); /* sock_hold done by schedulers of abort_work */
>  }
> @@ -2059,7 +2073,6 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
>  	conn->local_tx_ctrl.len = SMC_WR_TX_SIZE;
>  	conn->urg_state = SMC_URG_READ;
>  	init_waitqueue_head(&conn->cdc_pend_tx_wq);
> -	INIT_WORK(&smc->conn.abort_work, smc_conn_abort_work);
>  	if (ini->is_smcd) {
>  		conn->rx_off = sizeof(struct smcd_cdc_msg);
>  		smcd_cdc_rx_init(conn); /* init tasklet for this conn */

[Severity: High]
This is a pre-existing issue, not one introduced by this patch. The same
late-receiver window also lets smc_cdc_msg_validate() write connection
state directly, without the socket lock and without taking link references:

net/smc/smc_cdc.c:smc_cdc_msg_validate() {
    ...
		conn->out_of_sync = 1;	/* prevent any further receives */
		spin_lock_bh(&conn->send_lock);
		conn->local_tx_ctrl.conn_state_flags.peer_conn_abort = 1;
		conn->lnk = link;
		spin_unlock_bh(&conn->send_lock);
    ...
}

smc_conn_create() and smc_conn_free() set and use conn->lnk under
lock_sock() and never take conn->send_lock.

Suppose a receiver that found conn A in smc_cdc_rx_handler() does these
writes after smc_conn_free(A) and smc_conn_create(B), via the v2 -> v1
device search above. Could conn B then end up with conn->lnk pointing at a
link in conn A's link group that it never held?

If so, __smc_lgr_unregister_conn() would decrement the wrong link's
conn_cnt, and smc_conn_free(B) would then run:

	smcr_link_put(conn->lnk); /* link_hold in smc_conn_create() */

on a link with no matching hold. Can that drop the link's refcount to zero
early and run __smcr_link_clear() while the link is still in use? The hold
on conn B's real link would also be leaked, and its link group never freed.

The race window is narrow, but it is driven by input from the remote link
peer.

The race aside, changing conn->lnk here skips the pairing that
smc_switch_link_and_count() uses:

	atomic_dec(&conn->lnk->conn_cnt);
	/* link_hold in smc_conn_create() */
	smcr_link_put(conn->lnk);
	conn->lnk = to_lnk;
	atomic_inc(&conn->lnk->conn_cnt);
	/* link_put in smc_conn_free() */
	smcr_link_hold(conn->lnk);

Does a validation CDC that arrives on a link other than conn->lnk unbalance
the link refcounts as well?

The patch only makes the work item harmless. These direct writes from the
receiver are still reachable in the window the commit message describes.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261006073550.1595003-1-hidayath%40linux.ibm.com
