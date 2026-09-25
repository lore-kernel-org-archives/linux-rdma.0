Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3132836B915;
	Fri, 25 Sep 2026 08:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790326388; cv=none; b=JhnzNyAf6n/YeEm9H0Zzub0jOfpKsZFgj/o9topY4rr9VtXJRHRw2FUhYO8rvb3TGF/7CzLsvq9hPDlxjUbPmBzR6TK7qQxZ6Eisi7PgWvk7DYlxfPSl4fQiVVwxbAqeaQoYIB22k3JngbQEAHLzXd/z5YvxdrcKC9B9lghiA2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790326388; c=relaxed/simple;
	bh=m/8LWhNMDPXfJySmm5ONrTABdzSbFu/0AHSkD52pW7o=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YsvE7zIAvRuQ4M+32D4t/qt21Mj56cO2Yw6oz6HPRbK4RzNNPPlisyr07em++PpnB2K56TsHOUU/t8JcbpUxSqaABWKbU4zQf3Om0EIfaZRt117jKkY9oRrL/avwUFXUm7lzdlFY/n9S5CmCOrizvzS6LjK2hYTy5meroPKk8q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lh1JJHbR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lh1JJHbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2011F000FF;
	Fri, 25 Sep 2026 08:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790326386;
	bh=VCp3UdqP3jelFOY4EdYA01ieBD3r7j4p53iSbSKPiFY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Lh1JJHbRoyW74EKL6rJEU+rqzzL+3QOotnn30vuD3MXXdHs9lvaXjNPZrbsSUC6Fy
	 o/3xEOAQEKhR0ja45GEoK69L8oDxK0xbrWO/s9n0fRyXirRWw6QF8KArM2fphHA7do
	 vp9hTbT9BKykEm2OjawDTZAbP3EGfojaLZKqTp8/swBS5Di5QOiyDDQz6kvPy2n+zj
	 sgjAJVSTC15HZYan2iufklMEykiYD8WTpXkdsfy2/7OsLGh0vYdVW9IjibIf8ewQpr
	 XK4cPjoG8dHhanM5mkcHZRX/pQ0pWHu0z3ivfav2v9Q7edZyjKsqdy4t+cpn2pSWaq
	 OgnxtMzhr0c7A==
Subject: Re: [PATCH net-next] net/rds: replace tasklets with workqueue
From: netdev-bot+sashiko@kernel.org
To: sunnytiwari@google.com
Cc: santosh.shilimkar@oracle.com, achender@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, edumazet@google.com, horms@kernel.org
Date: Fri, 25 Sep 2026 08:53:05 +0000
Message-ID: <179032638569.2160803.14450306497476769745@kernel.org>
In-Reply-To: =?utf-8?q?=3C6b07af04b3ba66a09009e1a0a7b98ec5ec85d3a0=2E1790109?=
 =?utf-8?q?248=2Egit=2Esunnytiwari=40google=2Ecom=3E?=
References: =?utf-8?q?=3C6b07af04b3ba66a09009e1a0a7b98ec5ec85d3a0=2E17901092?=
 =?utf-8?q?48=2Egit=2Esunnytiwari=40google=2Ecom=3E?=
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 · High: 2 · Medium: 3 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Self-deadlock of the send completion work item: converting the
  send CQ tasklet to a work item flips the in_interrupt() test in…
- [High] TOCTOU between the CQ completion handlers and shutdown
  cancellation: rds_ib_cq_comp_handler_send()/_recv() test…
- [Medium] rds_ib_init() calls alloc_workqueue("rds_ib_wq", WQ_HIGHPRI |
  WQ_MEM_RECLAIM, 0) (net/rds/ib.c:606-607) without WQ_PERCPU or…
- [Medium] Undisclosed execution-context change: the IB send/recv
  completion handlers move from softirq (tasklet) to a fully preemptible…
- [Medium] Invalid lifetime/synchronization guard on the module-global
  rds_ib_wq.

--

net/rds: replace tasklets with workqueue

This converts the net/rds/ib send and receive completion tasklets into
work items running on a new module-global workqueue, rds_ib_wq, allocated
in rds_ib_init() and destroyed in rds_ib_exit().  Shutdown now sets
ic->i_cq_quiesce with atomic_set_release() and calls cancel_work_sync()
instead of tasklet_kill().

A few questions about the conversion below.

> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 786f39169bc14..3e3551c6a8a62 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -50,6 +50,7 @@ static unsigned int rds_ib_mr_1m_pool_size = RDS_MR_1M_POOL_SIZE;
>  static unsigned int rds_ib_mr_8k_pool_size = RDS_MR_8K_POOL_SIZE;
>  unsigned int rds_ib_retry_count = RDS_IB_DEFAULT_RETRY_COUNT;
>  static atomic_t rds_ib_unloading;
> +struct workqueue_struct *rds_ib_wq;
>  
>  module_param(rds_ib_mr_1m_pool_size, int, 0444);
>  MODULE_PARM_DESC(rds_ib_mr_1m_pool_size, " Max number of 1M mr per HCA");
> @@ -533,6 +534,8 @@ static bool rds_ib_is_unloading(struct rds_connection *conn)
>  
>  void rds_ib_exit(void)
>  {
> +	struct workqueue_struct *wq = rds_ib_wq;
> +
>  	rds_ib_set_unloading();
>  	synchronize_rcu();
>  	rds_info_deregister_func(RDS_INFO_IB_CONNECTIONS, rds_ib_ic_info);
> @@ -545,6 +548,10 @@ void rds_ib_exit(void)
>  	rds_ib_recv_exit();
>  	rds_trans_unregister(&rds_ib_transport);
>  	rds_ib_mr_exit();
> +
> +	rds_ib_wq = NULL;
> +	if (wq)
> +		destroy_workqueue(wq);
>  }

[Severity: Medium]
What does the rds_ib_wq NULL store here protect against?

The pointer is stored without any barrier and destroy_workqueue() follows
immediately, while the readers in net/rds/ib_cm.c load the global twice
with plain loads:

	if (unlikely(!rds_ib_wq || atomic_read_acquire(&ic->i_cq_quiesce)))
		return;

	queue_work(rds_ib_wq, &ic->i_recv_work);

There is no READ_ONCE(), no RCU grace period and no refcount between the
NULL store and destroy_workqueue(), so the second load can pick up NULL
(queue_work(NULL, ...) dereferences wq in __queue_work() from hardirq
context), or the old pointer of a workqueue that destroy_workqueue() is
already draining.

The guard in rds_ib_conn_path_shutdown() looks worse than the
unconditional tasklet_schedule() it replaces:

	while (!wait_event_timeout(rds_ib_ring_empty_wait,
				   rds_ib_conn_path_shutdown_check_wait(cp) == 0,
				   msecs_to_jiffies(1000))) {
		if (rds_ib_wq) {
			queue_work(rds_ib_wq, &ic->i_send_work);
			queue_work(rds_ib_wq, &ic->i_recv_work);
		}
	}

rds_ib_conn_path_shutdown_check_wait() can only reach 0 once the workers
reap completions, and the loop has no other exit, so observing a NULL
rds_ib_wq here removes the only forward-progress mechanism and the
shutdown thread spins forever, leaking the connection and its IB
resources.

If the teardown ordering already guarantees rds_ib_wq stays valid for as
long as an rds_ib_connection can exist, would it be better to drop these
tests (or turn them into a WARN_ON) rather than keep a check that suggests
a lifetime rule it cannot enforce and adds a hang path?

>  
>  static u8 rds_ib_get_tos_map(u8 tos)
> @@ -587,6 +594,7 @@ struct rds_transport rds_ib_transport = {
>  
>  int rds_ib_init(void)
>  {
> +	struct workqueue_struct *wq;
>  	int ret;
>  
>  	INIT_LIST_HEAD(&rds_ib_devices);
> @@ -595,9 +603,16 @@ int rds_ib_init(void)
>  	if (ret)
>  		goto out;
>  
> +	rds_ib_wq = alloc_workqueue("rds_ib_wq",
> +				    WQ_HIGHPRI | WQ_MEM_RECLAIM, 0);
> +	if (!rds_ib_wq) {
> +		ret = -ENOMEM;
> +		goto out_mr_exit;
> +	}
> +

[Severity: Medium]
Does this allocation trip the workqueue core warning?  Neither WQ_PERCPU
nor WQ_UNBOUND is passed, and __alloc_workqueue() in kernel/workqueue.c
has:

	if (unlikely(!(flags & (WQ_UNBOUND | WQ_PERCPU)))) {
		WARN_ONCE(1, "workqueue: %s is using neither WQ_PERCPU or WQ_UNBOUND. "
			  "Setting WQ_PERCPU.\n", wq->name);
		flags |= WQ_PERCPU;

So loading rds_rdma would emit a warning splat, and the commit message
statement:

  "Allocate per-CPU bound rds_ib_wq with WQ_HIGHPRI | WQ_MEM_RECLAIM in
   rds_ib_init()"

would only hold through that compatibility default, whose in-tree comment
says it can be removed once workqueues are unbound by default — after
which this workqueue silently becomes unbound and loses the
completion-vector locality the changelog relies on.

The sibling allocation in the same module already spells this out:

net/rds/ib_rdma.c:rds_ib_mr_init() {
	rds_ib_mr_wq = alloc_workqueue("rds_mr_flushd",
				       WQ_MEM_RECLAIM | WQ_PERCPU, 0);
}

Should WQ_PERCPU be added here too?

[Severity: Medium]
The commit message says:

  "Per-CPU binding preserves cache locality with the completion vector,
   matching original tasklet affinity without cross-core migration."

Since WQ_BH is not used, the send/recv completion handlers also move from
softirq context to fully preemptible process context, which the changelog
does not mention.  CQ notification is one-shot and is now re-armed only
after the worker is scheduled:

net/rds/ib_cm.c:rds_ib_recv_worker() {
	poll_rcq(ic, ic->i_recv_cq, ic->i_recv_wc, &state);
	ib_req_notify_cq(ic->i_recv_cq, IB_CQ_SOLICITED);
}

net/rds/ib_cm.c:rds_ib_send_worker() {
	poll_scq(ic, ic->i_send_cq, ic->i_send_wc);
	ib_req_notify_cq(ic->i_send_cq, IB_CQ_NEXT_COMP);
}

While the work item is merely pending, nothing else drains the CQ, so
credit return, ACK generation (rds_ib_set_ack()/rds_ib_attempt_ack()) and
rds_send_xmit() can be delayed by unrelated CPU load on the shared HIGHPRI
pool, which also shortens the margin of the one second retry loop in
rds_ib_conn_path_shutdown().  Per-CPU work items are also migrated when a
CPU goes offline, so affinity is not strictly preserved.

Could the changelog describe the softirq to process context change, and
are there any latency or throughput numbers for this conversion?

>  	ret = ib_register_client(&rds_ib_client);
>  	if (ret)
> -		goto out_mr_exit;
> +		goto out_wq;
>  

[ ... ]

> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 6e3110a04ae6b..976a9d7e82883 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -253,7 +253,10 @@ static void rds_ib_cq_comp_handler_recv(struct ib_cq *cq, void *context)
>  
>  	rds_ib_stats_inc(s_ib_evt_handler_call);
>  
> -	tasklet_schedule(&ic->i_recv_tasklet);
> +	if (unlikely(!rds_ib_wq || atomic_read_acquire(&ic->i_cq_quiesce)))
> +		return;
> +
> +	queue_work(rds_ib_wq, &ic->i_recv_work);
>  }

[Severity: High]
Can work still be queued after both cancel_work_sync() calls have
returned?  The test of i_cq_quiesce and the queue_work() are two separate
operations here (and in rds_ib_cq_comp_handler_send()), and the handlers
are still live during shutdown because rdma_destroy_qp()/ib_destroy_cq()
only run afterwards:

CPU0 (hardirq, rds_ib_cq_comp_handler_recv)
    atomic_read_acquire(&ic->i_cq_quiesce)  /* reads 0 */
    <delayed: preemption of the vCPU, SMI, higher priority interrupt>

CPU1 (rds_ib_conn_path_shutdown)
    atomic_set_release(&ic->i_cq_quiesce, 1);
    cancel_work_sync(&ic->i_send_work);
    cancel_work_sync(&ic->i_recv_work);
    rdma_destroy_qp(ic->i_cm_id);
    ...

CPU0 resumes
    queue_work(rds_ib_wq, &ic->i_recv_work);  /* queued after the cancels */

Release/acquire makes the flag visible but cannot make check-and-queue
atomic, so does the quiescence ordering described in the changelog
actually close this window?

Nothing appears to cancel the late work afterwards either:

net/rds/ib_cm.c:rds_ib_conn_free() {
	spin_lock_irq(lock_ptr);
	list_del(&ic->ib_node);
	spin_unlock_irq(lock_ptr);

	rds_ib_recv_free_caches(ic);

	kfree(ic);
}

Once ic is freed, queue_work()'s writes to work->data and the worker's
container_of()/atomic_read(&ic->i_cq_quiesce) touch freed slab memory, and
a still-queued item can make destroy_workqueue() hit its busy pwq
WARN_ON() on module unload.  Would a cancel_work_sync() on both work items
after the CQs are destroyed, plus one in rds_ib_conn_free(), be needed
here?

There is also a stale execution case that is not a no-op, because
rds_ib_recv_worker() drops the connection before it consults the quiesce
flag:

	if (!rds_ibdev)
		rds_conn_drop(conn);

	rds_ib_stats_inc(s_ib_tasklet_call);

	/* if cq has been already reaped, ignore incoming cq event */
	if (atomic_read(&ic->i_cq_quiesce))
		return;

After rds_ib_remove_conn() clears ic->rds_ibdev, doesn't a late worker run
spuriously drop the connection and cause reconnect churn?

>  
>  static void poll_scq(struct rds_ib_connection *ic, struct ib_cq *cq,
> @@ -279,9 +282,10 @@ static void poll_scq(struct rds_ib_connection *ic, struct ib_cq *cq,
>  	}
>  }
>  
> -static void rds_ib_tasklet_fn_send(unsigned long data)
> +static void rds_ib_send_worker(struct work_struct *work)
>  {
> -	struct rds_ib_connection *ic = (struct rds_ib_connection *)data;
> +	struct rds_ib_connection *ic =
> +		container_of(work, struct rds_ib_connection, i_send_work);
>  	struct rds_connection *conn = ic->conn;
>  
>  	rds_ib_stats_inc(s_ib_tasklet_call);

[Severity: High]
Can this worker deadlock against itself now that in_interrupt() is false?

rds_ib_free_mr() picks its branch based on exactly that:

net/rds/ib_rdma.c:rds_ib_free_mr() {
	if (invalidate) {
		if (likely(!in_interrupt())) {
			rds_ib_flush_mr_pool(pool, 0, NULL);
		} else {
			/* We get here if the user created a MR marked
			 * as use_once and invalidate at the same time.
			 */
			queue_delayed_work(rds_ib_mr_wq,
					   &pool->flush_worker, 10);
		}
	}
}

The comment says that branch is reached from the completion context, which
used to be the tasklet.  From the work item the flush now runs inline:

rds_ib_send_worker()
  poll_scq()
    rds_ib_send_cqe_handler()
      rds_message_put()          /* last ref, net/rds/ib_send.c */
        rds_message_purge()
          __rds_put_mr_final() -> rds_destroy_mr() -> free_mr()
            rds_ib_free_mr(invalidate=1)
              rds_ib_flush_mr_pool()
                rds_ib_unreg_frmr() -> rds_ib_post_inv()

and rds_ib_post_inv() then waits for a completion that only this same work
item can reap:

net/rds/ib_frmr.c:rds_ib_post_inv() {
	while (atomic_dec_return(&ibmr->ic->i_fastreg_wrs) <= 0) {
		atomic_inc(&ibmr->ic->i_fastreg_wrs);
		cpu_relax();
	}
	...
	wait_event(frmr->fr_inv_done, frmr->fr_state != FRMR_IS_INUSE);
}

The only wakeup is in rds_ib_mr_cqe_handler():

	if (frmr->fr_inv) {
		rds_transition_frwr_state(ibmr, FRMR_IS_INUSE, FRMR_IS_FREE);
		frmr->fr_inv = false;
		wake_up(&frmr->fr_inv_done);
	}

and its only caller is poll_scq(), whose only caller is
rds_ib_send_worker().  A work_struct never runs concurrently with itself,
so doesn't the send CQ stop being polled entirely, leaving the worker
blocked with pool->flush_lock held and making the drain loop and
cancel_work_sync() in rds_ib_conn_path_shutdown() never complete?

The trigger looks reachable from an ordinary RDS socket that registers an
MR with RDS_RDMA_USE_ONCE | RDS_RDMA_INVALIDATE and sends RDMA, since
mr->r_invalidate is what selects the branch above.

[ ... ]

> @@ -1099,14 +1107,15 @@ void rds_ib_conn_path_shutdown(struct rds_conn_path *cp)
>  		while (!wait_event_timeout(rds_ib_ring_empty_wait,
>  					   rds_ib_conn_path_shutdown_check_wait(cp) == 0,
>  					   msecs_to_jiffies(1000))) {
> -			tasklet_schedule(&ic->i_send_tasklet);
> -			tasklet_schedule(&ic->i_recv_tasklet);
> +			if (rds_ib_wq) {
> +				queue_work(rds_ib_wq, &ic->i_send_work);
> +				queue_work(rds_ib_wq, &ic->i_recv_work);
> +			}
>  		}
>  
> -		tasklet_kill(&ic->i_send_tasklet);
> -		tasklet_kill(&ic->i_recv_tasklet);
> -
> -		atomic_set(&ic->i_cq_quiesce, 1);
> +		atomic_set_release(&ic->i_cq_quiesce, 1);
> +		cancel_work_sync(&ic->i_send_work);
> +		cancel_work_sync(&ic->i_recv_work);
>  
>  		/* first destroy the ib state that generates callbacks */
>  		if (ic->i_cm_id->qp)

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/6b07af04b3ba66a09009e1a0a7b98ec5ec85d3a0.1790109248.git.sunnytiwari%40google.com
