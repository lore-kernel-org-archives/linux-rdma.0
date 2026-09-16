Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA053B635B;
	Wed, 16 Sep 2026 01:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789522945; cv=none; b=omSnc06o1Y0iXMaVRvHbrT+hBb9264bXEBldqQcfK0yc8ZYhkY/BfTPr477Wh9X0TWne/JA8VREhsmFsadOVQboFJb5oFCD9H0NQyok9c19BF+ZnwK0GOvmIDFTkIBpV68LpEom31O9sVLFvNnkaRIlzBVswPGnEoI9k4TsFRNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789522945; c=relaxed/simple;
	bh=AwrVRBPhDpXcKY0iy5b/cYsIpuJy4/5nyi2xLmjXP6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OS3CjDbA2B4ZcaaNSdFL239bVnKLft0cl8DZAjkLK4BuYoF7q9lxo/3Gd1qOI1Y/dWsk5TaOjm/F3/otdLADav7R+hBKC5wZdAfM6YIEm6ToxgwQ9eWrktjz6FLm/DiLV0Wpe4roc/hssYIOw9uGP4q5lOfnNeV5rfx7JXEzGp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IBaQMYBA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IBaQMYBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BDA1F000FF;
	Wed, 16 Sep 2026 01:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789522919;
	bh=5cmq7j5dFWsdJe8vMEZudPayoONeU3vLTPoQkNIm2SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IBaQMYBAG9t5BbSgkVwPxHhryDu5MkSpM8JUf03ouItPuemw0Fng3zCZBMveZ0HUu
	 BJhYy1CeDg9IXAnEdD1DDuQDckscR4jlj7eIcCRAck1EyZlyvEH/Qo4yg3Nk6GAwxy
	 jtO+w+CmRXCL7hRTVuXJR1iLkthNjLhYrnb6CUce2D8/3QEaMa54Fv1iQvWVcHgd5W
	 +9213rnqiEiQym/Bo/eOZc/+qf42SG9PGJYcNIC4u5uzGKuEa+pVJfvRdrXFrfHn+7
	 4fFgoBarf2JS1EclNgdJrEXfKjnL8321N5FIZu0+QGGxTDcErMakOi+SqsBOxzaOaa
	 C9Fkvuk9t5Icg==
From: Jakub Kicinski <kuba@kernel.org>
To: alibuda@linux.alibaba.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	mjambigi@linux.ibm.com,
	wenjia@linux.ibm.com,
	wintera@linux.ibm.com,
	dust.li@linux.alibaba.com,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	leonro@nvidia.com,
	pabeni@redhat.com,
	edumazet@google.com,
	sidraya@linux.ibm.com,
	jaka@linux.ibm.com,
	oliver.yang@linux.alibaba.com
Subject: Re: [PATCH net-next 2/2] net/smc: reduce TX slot contention with exclusive wait
Date: Tue, 15 Sep 2026 18:41:57 -0700
Message-ID: <20260916014157.1670940-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910104446.41423-3-alibuda@linux.alibaba.com>
References: <20260910104446.41423-3-alibuda@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
net/smc: reduce TX slot contention with exclusive wait

This replaces the wait_event_interruptible_timeout() in
smc_wr_tx_get_free_slot() with an open-coded loop built on
prepare_to_wait_exclusive(), so a wake_up() on link->wr_tx_wait only wakes
one waiter per freed TX slot.  It also changes the return value on a
pending signal from -EPIPE to -ERESTARTSYS.

A few questions below about the new wait loop and about the changed return
code.

The commit message says:

  This also corrects the return value on a pending signal: the previous
  wait_event_interruptible_timeout() path fell through to the "no free
  slot" case and returned -EPIPE, masking the signal as a connection
  error.

[Severity: Low]

Should this part carry a Fixes: tag?  git blame on the baseline points the
wait_event_interruptible_timeout() call and the timeout-only "if (!rc)"
handling at f38ba179c6ca ("smc: work request (WR) base for use by LLC and
CDC"), with later touches in 15e1b99aadfb27 and 87523930a16eb5.  The
corrected value is user visible via smc_shutdown() -> smc_close_active()
-> smc_close_final() -> smc_wr_tx_get_free_slot().

Also, would it make sense to split the return-code correction from the
wait-queue rework?  As it stands both live in the same hunk, so the
corrected error code cannot be backported without the performance change.

> diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
> index def2ab84b0c71..64413008f9c17 100644
> --- a/net/smc/smc_wr.c
> +++ b/net/smc/smc_wr.c
> @@ -198,11 +198,13 @@ int smc_wr_tx_get_free_slot(struct smc_link *link,
>  			    struct smc_rdma_wr **wr_rdma_buf,
>  			    struct smc_wr_tx_pend_priv **wr_pend_priv)
>  {
> +	unsigned long timeout = SMC_WR_TX_WAIT_FREE_SLOT_TIME;
>  	struct smc_link_group *lgr = smc_get_lgr(link);
>  	struct smc_wr_tx_pend *wr_pend;
>  	u32 idx = link->wr_tx_cnt;
>  	struct ib_send_wr *wr_ib;
>  	u64 wr_id;
> +	DEFINE_WAIT(wait);
>  	int rc;
>  
>  	*wr_buf = NULL;
> @@ -212,17 +214,31 @@ int smc_wr_tx_get_free_slot(struct smc_link *link,
>  		if (rc)
>  			return rc;
>  	} else {
> -		rc = wait_event_interruptible_timeout(
> -			link->wr_tx_wait,
> -			!smc_link_sendable(link) ||
> -			lgr->terminating ||
> -			(smc_wr_tx_get_free_slot_index(link, &idx) != -EBUSY),
> -			SMC_WR_TX_WAIT_FREE_SLOT_TIME);
> -		if (!rc) {
> -			/* timeout - terminate link */
> -			smcr_link_down_cond_sched(link);
> -			return -EPIPE;
> +		rc = 0;
> +		for (;;) {
> +			prepare_to_wait_exclusive(&link->wr_tx_wait, &wait,
> +						  TASK_INTERRUPTIBLE);
> +			if (!smc_link_sendable(link) || lgr->terminating ||
> +			    smc_wr_tx_get_free_slot_index(link, &idx) != -EBUSY)
> +				break;
> +			timeout = schedule_timeout(timeout);
> +			/* re-check */
> +			if (!smc_link_sendable(link) || lgr->terminating ||
> +			    smc_wr_tx_get_free_slot_index(link, &idx) != -EBUSY)
> +				break;

[Severity: Medium]

Can a freed TX slot end up unclaimed while another waiter keeps sleeping?

prepare_to_wait_exclusive() queues the entry with WQ_FLAG_EXCLUSIVE and sets
TASK_INTERRUPTIBLE before the condition is evaluated, and the condition here
is not cheap - smc_wr_tx_get_free_slot_index() scans up to wr_tx_cnt bits:

net/smc/smc_wr.c:smc_wr_tx_get_free_slot_index() {
	...
	for_each_clear_bit(*idx, link->wr_tx_mask, link->wr_tx_cnt) {
		if (!test_and_set_bit(*idx, link->wr_tx_mask))
			return 0;
	}
	*idx = link->wr_tx_cnt;
	return -EBUSY;
}

Both slot producers use plain wake_up(), which is nr_exclusive = 1, so
exactly one exclusive waiter is woken per freed slot:

net/smc/smc_wr.c:smc_wr_tx_process_cqe() {
	...
	wake_up(&link->wr_tx_wait);
}

net/smc/smc_wr.c:smc_wr_tx_put_slot() {
	...
	test_and_clear_bit(idx, link->wr_tx_mask);
	wake_up(&link->wr_tx_wait);
}

The interleaving I have in mind:

  1) all slots busy, waiter W sleeps on link->wr_tx_wait
  2) a CQE frees slot i, wake_up() wakes W, autoremove_wake_function()
     dequeues W, the credit is consumed
  3) before W runs, a fresh process-context caller T enters the loop,
     prepare_to_wait_exclusive() queues T, T's first scan takes slot i
     (a bare test_and_set_bit(), no reservation) and T breaks out
  4) W re-checks, finds nothing free, requeues and sleeps again
  5) slot j is freed, wake_up() walks the queue, reaches T first (still
     queued and TASK_INTERRUPTIBLE), T absorbs the credit and returns

Slot j is now free while W sleeps.  Since the loop never issues another
wake_up(&link->wr_tx_wait) when it exits without consuming the announced
slot, is that credit simply dropped by finish_wait()?  Would a
wake_up(&link->wr_tx_wait) on the paths that leave the queue without
claiming the announced slot be appropriate here?

With the previous non-exclusive wait_event_interruptible_timeout(), every
wake_up() re-evaluated the condition for all waiters, so a free slot could
not coexist with sleeping waiters.

> +			if (!timeout) {
> +				/* timeout - terminate link */
> +				smcr_link_down_cond_sched(link);
> +				break;
> +			}

Related to the above: if a waiter misses its wakeup and no further slot is
released within SMC_WR_TX_WAIT_FREE_SLOT_TIME, does it reach this branch and
call smcr_link_down_cond_sched(), tearing down the link for the whole link
group even though a TX slot was actually available?

> +			if (signal_pending(current)) {
> +				rc = -ERESTARTSYS;
> +				break;
> +			}

[Severity: Medium]

Is returning raw -ERESTARTSYS to all callers of
smc_wr_tx_get_free_slot() safe?  The sibling blocking helper in the same
file converts it:

net/smc/smc_wr.c:smc_wr_reg_send() {
	...
	if (rc == -ERESTARTSYS)
		return -EINTR;
	...
}

The path I traced is shutdown(fd, SHUT_RDWR) on an SMC_ACTIVE socket:

  smc_shutdown() -> smc_close_active() -> smc_close_final() ->
  smc_cdc_get_slot_and_msg_send() -> smc_cdc_get_free_slot() ->
  smc_wr_tx_get_free_slot()

smc_close_active() advances the state machine before it looks at the return
value, setting local_tx_ctrl.conn_state_flags.peer_conn_closed = 1 and
sk->sk_state = SMC_PEERCLOSEWAIT1.  With all TX slots busy and a signal
pending, -ERESTARTSYS now reaches smc_shutdown(), which returns it verbatim.

With SA_RESTART the syscall is restarted transparently, re-enters
smc_shutdown() in state SMC_PEERCLOSEWAIT1 where smc_close_sent_any_close()
is already true, so nothing is sent and shutdown() returns 0.  Does this
report success to the application although the SMC close message was never
transmitted?  The baseline returned -EPIPE here, so the failure was visible.

The commit message states the new value is "matching the standard
interruptible-wait semantics and letting the syscall restart machinery
handle it" - does that hold for a call site that has already committed side
effects before the error is returned?

Other callers only special-case -EBUSY, for example:

net/smc/smc_tx.c:smcr_tx_sndbuf_nonempty() {
	...
	rc = smc_cdc_get_free_slot(conn, link, &wr_buf, &wr_rdma_buf, &pend);
	if (rc < 0) {
		smc_wr_tx_link_put(link);
		if (rc == -EBUSY) { ... }
		return rc;
	}
	...
}

so -ERESTARTSYS is propagated as a hard error with no retry queued.

For completeness on what I could not confirm: on the connect path every
error is converted to an SMC_CLC_DECL_* code before reaching
"smc->sk.sk_err = -rc", so -ERESTARTSYS does not appear to leak out through
SO_ERROR or poll, and I could not demonstrate signal_pending() becoming true
inside workqueue workers.

>  		}
> +		finish_wait(&link->wr_tx_wait, &wait);
> +		if (rc)
> +			return rc;
>  		if (idx == link->wr_tx_cnt)
>  			return -EPIPE;
>  	}

[ ... ]
