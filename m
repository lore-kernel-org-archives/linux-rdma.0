Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1335B3B6BEE;
	Sun,  4 Oct 2026 18:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791138867; cv=none; b=WDAnmFYCV3QJQH6Rxey+221Mx5mlh5eAvN0MNFP08khSoO/OrcLXw+o/beSRA9FOKMRUAsxLn8ifpa/m6DqNzZXhu6qTDKP5NYXVWjZcwkkbX+X3dKqniyCg5iAt6pXGyUZEgvITY8krSOmmu95qdZvOp6tONR3NfAbWyn7tXsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791138867; c=relaxed/simple;
	bh=gLw90hxFsa/ClkQtbv9ZCyhLYqtMx55ygEUZgw/PJf0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YtqwqZ/ZzaMbFlR3wuohDRP233JTq3kdwynT6h2ByO5m4EVOCaetVHosz0C8yVSrVF7D2PVwZWizj3HzAaW5PGaVHMpLbYFfqol/VpydVzUk+/d/t2E2fq8A7MkOAv9L3r+0pSutldXDYqGyT+2s97MXsr9MPiCkVyZRiLiB8Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FC383d7Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FC383d7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61C01F000FF;
	Sun,  4 Oct 2026 18:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791138865;
	bh=Sjya9qHx6cALlHzqDrLnhEqFfoUxcFbm1p3mIJcgqOs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=FC383d7YrT9ccBTOd31LNQfpPi48xb3msmKvXUk8uDBuBx44FRe7wT0mJxjrqlyGq
	 tXV6T6c9X++i8bkuqkXwKUIANUfyyoMaj10dqwgOu/BYZpZsqN3Hi67X05xl4O/jlV
	 Y/AjGYoFsaKUOPpBKDI+4GZEd9snep+/ksgb8ubiL/Ex/flwgHCErgAHie+3yKRwwJ
	 9ZtdeQC6UHMW3pcPUfcsRphZ5HmzwpTix4ebjqcQTSPdOxEsJn0Wpa7Dir1WSvSp0c
	 hVSTjm/wst9sv568DMdLN072p4UfbIPWFXZwajdYWe3U9ZbVg7FOePJzaCwK1IgIyP
	 iuSqvjYeqZZIw==
Subject:
 Re: [PATCH net v2 1/2] net/smc: serialize link group free work scheduling
From: netdev-bot+sashiko@kernel.org
To: nicoyip.dev@gmail.com
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com, horms@kernel.org,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Sun, 04 Oct 2026 18:34:24 +0000
Message-ID: <179113886433.434549.10069135669585050618@kernel.org>
In-Reply-To: <20261003183237.2284245-2-nicoyip.dev@gmail.com>
References: <20261003183237.2284245-2-nicoyip.dev@gmail.com>
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

Critical: 0 · High: 1 · Medium: 0 · Low: 0 (3)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] __smc_lgr_terminate() (net/smc/smc_core.c) still cancels
  free_work with cancel_delayed_work(), which does not wait for a…

Pre-existing issues:
- [Low] Baseline decision: not a valid finding for the final state of the
  series.
- [Low] Baseline decision: not reported (a pre-existing, low-impact race
  the patch does not claim to fix).
- [Low] Baseline decision: not a valid finding for the final state of the
  series.

--

net/smc: serialize link group free work scheduling

This patch holds the link group list lock across the freeing check and
mod_delayed_work() in smc_lgr_schedule_free_work(). It also sets
lgr->freeing under that lock in smc_lgr_cleanup_early(). Finally, it moves
freeing out of the shared bitfield byte and gives it its own bool.

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 9974149659c2f..478c8bc2759a0 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c

[ ... ]

> @@ -691,6 +696,7 @@ void smc_lgr_cleanup_early(struct smc_link_group *lgr)
>  	/* do not use this link group for new connections */
>  	if (!list_empty(&lgr->list))
>  		list_del_init(&lgr->list);
> +	lgr->freeing = 1;
>  	spin_unlock_bh(lgr_lock);
>  	__smc_lgr_terminate(lgr, true);
>  }

[Severity: Low]
This is a pre-existing issue, but is lgr still guaranteed to be alive when
smc_lgr_cleanup_early() is reached from smc_conn_abort()?

net/smc/af_smc.c:smc_conn_abort() {
    ...
	smc_conn_free(conn);
	if (local_first && lgr_valid)
		smc_lgr_cleanup_early(lgr);
}

smc_conn_free() drops the connection's reference:

	smc_lgr_put(lgr); /* lgr_hold in smc_conn_create() */

After that, smc_lgr_list_head(), spin_lock_bh(), list_del_init() and the
new freeing store all run without a reference held.

The unreferenced access was already there before this patch. The next
patch in the series, "net/smc: serialize early link group cleanup with
termination", adds smc_lgr_hold()/smc_lgr_put() around smc_conn_free()
and smc_lgr_cleanup_early(). It does the same on the registration
failure path in smc_conn_create().

Both patches carry Cc: stable. Could this changelog say that the
follow-up patch has to be backported with it?

[Severity: Low]
This isn't a bug introduced by this patch, but should lgr->freeing be
tested before it is set here?

At this commit, smc_lgr_cleanup_early() sets freeing unconditionally and
always calls __smc_lgr_terminate(). Suppose smc_lgr_free_work() has
already claimed the group:

smc_lgr_free_work()
    lgr->freeing = 1; /* this instance does the freeing, no new schedule */
    ...
    smc_lgr_free(lgr);

__smc_lgr_terminate() only checks lgr->terminating, and
smc_lgr_free_work() never sets it. The second teardown would then go into
smc_lgr_free() again. The same applies to a group already claimed by
smc_lgr_terminate_sched() or smc_smcd_terminate().

Can this end in a second destroy_workqueue() of lgr->tx_wq, a second
put_device(), and an lgr refcount underflow?

The baseline smc_lgr_cleanup_early() did not test freeing either. The
follow-up patch "net/smc: serialize early link group cleanup with
termination" adds the check under lgr_lock:

	if (lgr->freeing) {
		spin_unlock_bh(lgr_lock);
		return;
	}

[ ... ]

> @@ -1565,7 +1571,7 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
>  
>  	if (lgr->terminating)
>  		return;	/* lgr already terminating */
> -	/* cancel free_work sync, will terminate when lgr->freeing is set */
> +	/* cancel pending free_work; a running instance rechecks freeing */
>  	cancel_delayed_work(&lgr->free_work);
>  	lgr->terminating = 1;

[Severity: High]
Can a running free_work instance safely do that recheck?

smc_lgr_free_work() holds no reference on lgr, and the recheck itself
dereferences lgr:

smc_lgr_free_work() {
    ...
	smc_lgr_list_head(lgr, &lgr_lock);
	spin_lock_bh(lgr_lock);
	if (lgr->freeing) {
    ...
}

cancel_delayed_work() does not wait for a callback that is already
running. smc_lgr_free() only drains tx_wq before it drops the base
reference.

Could this sequence free lgr while the worker is still using it?

CPU 0 (kworker)                     CPU 1 (terminator)
smc_lgr_free_work() starts
  (PENDING already cleared)
  preempted before
  smc_lgr_list_head()
                                    set lgr->freeing under lgr_lock
                                    __smc_lgr_terminate()
                                      cancel_delayed_work() returns false
                                      smc_lgr_cleanup()
                                      smc_lgr_free()
                                        smc_lgr_put()
                                          __smc_lgr_free()
                                            kfree(lgr)
  smc_lgr_list_head(lgr, ...)
  spin_lock_bh(lgr_lock)
  reads lgr->freeing

free_work is only scheduled when the group has no connections. So the put
in smc_lgr_free() drops the last reference.

The terminator could be any of these:

  terminate_work after a peer-triggered smc_smcd_terminate()
  smc_lgr_terminate_sched() after a CLC DECLINE with the first contact flag
  smc_smcr_terminate_all() or smc_smcd_terminate_all()

If the freed memory reads freeing == 0, the worker also goes on to
list_del_init() and a second smc_lgr_free() on the freed object.

The asynchronous cancel predates this patch. However, the new comment
describes running instances as safe, and the v2 notes say the patch keeps
"asynchronous cancellation without adding work-owned references".

Does this need cancel_delayed_work_sync() on the terminate paths that can
drop the last reference, or a reference owned by the work item?

> diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
> index 5c18f08a4c8a5..b8c67f277337a 100644
> --- a/net/smc/smc_core.h
> +++ b/net/smc/smc_core.h
> @@ -303,7 +303,7 @@ struct smc_link_group {
>  	struct workqueue_struct	*tx_wq;		/* wq for conn. tx workers */
>  	u8			sync_err : 1;	/* lgr no longer fits to peer */
>  	u8			terminating : 1;/* lgr is terminating */
> -	u8			freeing : 1;	/* lgr is being freed */
> +	bool			freeing;	/* lgr is being freed */

[Severity: Low]
This is a pre-existing issue, but sync_err and terminating still share a
byte after freeing moves out.

smc_clc_wait_msg() does:

	smc->conn.lgr->sync_err = 1;
	smc_lgr_terminate_sched(smc->conn.lgr);

and __smc_lgr_terminate() does:

	lgr->terminating = 1;

The two writes have no common lock. Can one read-modify-write overwrite
the other?

The impact looks limited. freeing and list membership still prevent
reuse or a double teardown. If terminating = 1 is lost, the main effect
is that smc_wr_tx_get_free_slot() waits instead of failing fast on:

	if (in_softirq() || lgr->terminating) {

That wait ends when the link stops being sendable or after
SMC_WR_TX_WAIT_FREE_SLOT_TIME. The changelog only claims to protect
freeing, so this could be handled in a separate patch.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261003183237.2284245-1-nicoyip.dev%40gmail.com
