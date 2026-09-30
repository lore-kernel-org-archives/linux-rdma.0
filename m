Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E465D1FDA61;
	Wed, 30 Sep 2026 00:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790729128; cv=none; b=fADJUR7QEfiVwewWB4uCs7Fbh/m/nFaCyhJoKce4HiMwRUkBhJeiybCVcuOBpvhIqI6v5q3C/LDTLky7c4uMqfFrB+QGCRIlO73a4An4woq9BpqwLvpSvHtzOe5Rk3226oQmQ/HycidPTfhaaSxEijoPqOEt+YBjmfLIh2Bc54A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790729128; c=relaxed/simple;
	bh=7BOYHI88SA0DozVV0KMd7sxd3tZ1p5ofAmLGJCdIsL4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NuRAAzBlJHTyH7PWxIqjHWnrY/IeM7iK1s3EAvVqFsNg9vpXUOSHr82JaeAbzz0ak75C03frkPTVmtgs88X6LU8cgCXRfzlwOgbZsQtd+bX7nCm4MiGO3bhJvwI4wBYbuKJjFJsTkLTY0T1hLfTjNk8kIqiOmn2io+kn+EI4/hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uje6ISMF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uje6ISMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8A31F000FF;
	Wed, 30 Sep 2026 00:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790729126;
	bh=u1ktL/jKzc01ML/FizVUorthZ3kGPeOlQztsjmc/cWo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Uje6ISMFbNkEe9HMtAi5uF5TpAu19p6NF1A9TfUNzkPBOnIpunfrhnZWG0efy8vyT
	 4Q0JvSRUvFmTs+e5+09EVmhQzgGnhTaqkSSbT6A4veCvDsqZwXKWb1Zxgzy87SqR/I
	 WCbFPUTYHaGTkHBknQNer7VK9JjHfCWv/RkeFuAWzdW+OQ8eCnvRYoyO5skGdcmVfm
	 R53W2jiGR9eehwcqKcCRTb/QFQ86zQgnOamve1IhQW1+13PWTEfy4lohOS0AnRds/8
	 VL3uOUbDYyR5F1yanYBIRBSzMx63/QtTjnI5rktG8EMtC0i5fLKVp2gxWPZGccolDR
	 UqXQ+HlkJqbiQ==
Subject: Re: [PATCH net] net/smc: serialize link group free work scheduling
From: netdev-bot+sashiko@kernel.org
To: nicoyip.dev@gmail.com
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, kgraul@linux.ibm.com,
 ubraun@linux.ibm.com, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Wed, 30 Sep 2026 00:45:25 +0000
Message-ID: <179072912501.434549.7831981029772644673@kernel.org>
In-Reply-To: <20260927074520.3694663-1-nicoyip.dev@gmail.com>
References: <20260927074520.3694663-1-nicoyip.dev@gmail.com>
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

Critical: 0 · High: 1 (1) · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix is incomplete.
- [Medium] The patch treats lgr_lock as the lock for lgr->freeing (the
  new comment reads 'protects lgr->freeing').

Pre-existing issues:
- [High] Separately from the pending-timer rearm this patch fixes, a
  free_work callback that has already started can race with lgr teardown…

--

net/smc: serialize link group free work scheduling

This patch takes the link group list lock in smc_lgr_schedule_free_work()
around the lgr->freeing check and the mod_delayed_work() call. The goal is
to stop a concurrent smc_lgr_free_work() from setting freeing and cancelling
the work between the check and the rearm, which would leave a timer pending
on a freed link group.

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 9974149659c2f..8feb486ada562 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -80,6 +80,10 @@ static void smc_ibdev_cnt_dec(struct smc_link *lnk)
>  
>  static void smc_lgr_schedule_free_work(struct smc_link_group *lgr)
>  {
> +	spinlock_t *lgr_lock; /* protects lgr->freeing */

[Severity: Medium]
Is lgr_lock enough to protect lgr->freeing? freeing is a 1-bit bitfield,
and it shares a u8 with sync_err and terminating:

net/smc/smc_core.h:struct smc_link_group {
	...
	u8			sync_err : 1;	/* lgr no longer fits to peer */
	u8			terminating : 1;/* lgr is terminating */
	u8			freeing : 1;	/* lgr is being freed */
	...
}

Both neighbouring bits are written without lgr_lock. One example is
smc_clc_wait_msg():

	smc->conn.lgr->sync_err = 1;
	smc_lgr_terminate_sched(smc->conn.lgr);

Another is __smc_lgr_terminate():

	lgr->terminating = 1;

Each of these stores is a read-modify-write of the whole byte.
smc_smcd_terminate() and smc_lgr_free_work() set freeing = 1 under
lgr_lock. Can a concurrent sync_err or terminating store write back a stale
byte and lose that freeing = 1?

In the sync_err case, smc_lgr_terminate_sched() then returns early because
the lgr is already unlinked, so freeing is never set again.

Consider a later smc_conn_free() that passed its unlocked list_empty()
check before the unlink. Once __smc_lgr_terminate() has cancelled
free_work, that call could reach smc_lgr_schedule_free_work() with
conns_num == 0. It would read freeing == 0 under the new lock and rearm the
timer on an lgr that is about to be freed.

Would it work better to give freeing its own storage (for example a bool),
or to make every writer of that byte hold lgr_lock?

> +
> +	smc_lgr_list_head(lgr, &lgr_lock);
> +	spin_lock_bh(lgr_lock);
>  	/* client link group creation always follows the server link group
>  	 * creation. For client use a somewhat higher removal delay time,
>  	 * otherwise there is a risk of out-of-sync link groups.
> @@ -90,6 +94,7 @@ static void smc_lgr_schedule_free_work(struct smc_link_group *lgr)
>  						SMC_LGR_FREE_DELAY_CLNT :
>  						SMC_LGR_FREE_DELAY_SERV);
>  	}
> +	spin_unlock_bh(lgr_lock);
>  }

[Severity: High]
Does this fully close the rearm race? The commit message says a rearm
"either precedes the freeing transition and is caught by the subsequent
cancellation, or sees freeing set and is skipped". That only holds if every
teardown path sets lgr->freeing under lgr_lock before it cancels free_work.

smc_lgr_cleanup_early() unlinks the lgr under lgr_lock but never sets
freeing:

net/smc/smc_core.c:smc_lgr_cleanup_early() {
	...
	spin_lock_bh(lgr_lock);
	/* do not use this link group for new connections */
	if (!list_empty(&lgr->list))
		list_del_init(&lgr->list);
	spin_unlock_bh(lgr_lock);
	__smc_lgr_terminate(lgr, true);
}

__smc_lgr_terminate() then cancels only once, outside the lock. It sets
terminating, not freeing:

net/smc/smc_core.c:__smc_lgr_terminate() {
	if (lgr->terminating)
		return;	/* lgr already terminating */
	/* cancel free_work sync, will terminate when lgr->freeing is set */
	cancel_delayed_work(&lgr->free_work);
	lgr->terminating = 1;
	...
	smc_lgr_cleanup(lgr);
	smc_lgr_free(lgr);
}

On an SMC-D server, smc_listen_work() drops smc_server_lgr_pending after
it sends the ACCEPT. A second connection (conn2) from the same peer can
then join the first-contact lgr.

If the first connection then fails (no CONFIRM, or a DECLINE), teardown
goes through:

smc_listen_work()->smc_listen_decline()->smc_conn_abort()->
    smc_lgr_cleanup_early()->__smc_lgr_terminate()

Meanwhile conn2 can be freed on another CPU:

CPU0 (conn1 abort)                CPU1 (smc_conn_free(conn2))
                                  !list_empty(&lgr->list) is true
                                  smc_lgr_unregister_conn(conn2)
smc_lgr_cleanup_early()
  list_del_init(&lgr->list)
  __smc_lgr_terminate()
    cancel_delayed_work()
    lgr->terminating = 1
                                  lgr->conns_num == 0
                                  smc_lgr_schedule_free_work()
                                    spin_lock_bh(lgr_lock)
                                    lgr->freeing == 0
                                    mod_delayed_work()
    smc_lgr_free()
                                  smc_lgr_put() drops last reference

This would leave free_work's timer pending on a kfree'd lgr, which is the
same __run_timers use-after-free as in the KASAN report.

Should smc_lgr_cleanup_early() set lgr->freeing under lgr_lock? Or should
smc_lgr_schedule_free_work() also skip the rearm when the lgr is unlinked
or terminating?

[Severity: High]
This is a pre-existing issue and was not introduced by this patch. Can a
smc_lgr_free_work() callback that has already started running race with
lgr teardown?

smc_lgr_free_work() holds no reference on the lgr and dereferences it
straight away:

net/smc/smc_core.c:smc_lgr_free_work() {
	...
	smc_lgr_list_head(lgr, &lgr_lock);
	spin_lock_bh(lgr_lock);
	if (lgr->freeing) {
	...
}

Suppose the idle timer fires and the worker starts, but is delayed before
this point (by preemption, or on PREEMPT_RT). A teardown can then set
freeing and reach __smc_lgr_terminate(). Examples are smc_smcd_terminate()
from an ISM peer shutdown event in smcd_handle_sw_event(),
smc_lgr_terminate_sched(), and smc_smcd_terminate_all() or
smc_smcr_terminate_all(). The only cancellation there is:

	cancel_delayed_work(&lgr->free_work);

That call neither cancels nor waits for a callback that is already
running.

With no connections left, smc_lgr_free() destroys lgr->tx_wq. free_work is
on system_percpu_wq, so this does not drain it. smc_lgr_put() then calls
__smc_lgr_free(), which frees the lgr.

When the worker resumes, it takes spin_lock_bh() on a lock pointer loaded
from freed memory. If the stale freeing bit reads 0, it also calls
list_del_init() and smc_lgr_free() a second time.

Should teardown use cancel_delayed_work_sync() where the context allows,
or should the queued work hold its own lgr reference?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927074520.3694663-1-nicoyip.dev%40gmail.com
