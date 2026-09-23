Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A863BCD01;
	Wed, 23 Sep 2026 07:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790147501; cv=none; b=nsGGWqI7yXo5QI6SP96h4sGsgJ8xpu4Q94aaruuDJSIaSnnc6Guged2fQEI7rBFdGLqg3iRus+/hr5w4DmIl2KZ+EbSpop0GtLy0YLQY9LVjMYeeV184sPTn7MSqJqAhg3lCqb3Sk8prwhMd0xNYB/2CtjkukRo2UvM7azYQ8iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790147501; c=relaxed/simple;
	bh=xElmhn+KpF/VN82SgjHDlVaatELIx2n2r/wMh3y8nZg=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KdiJ/DgpXRvRNB3FAjtg5MLNTZ+4yoeJVr+3M4ZeXHw6J6do+M+Xfesy3NKgNW1U1KSrpbuo0Y3LYRb4/4Z5fc5uOhx2R6PFFcIddhNYVdiJlM2fON07+i915ohf2DdDpPUyFNmZfCm4K+8R6XMDkR+kgFvmZO628tx+W/1Bcpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bb7nioTm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bb7nioTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2A41F00898;
	Wed, 23 Sep 2026 07:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790147496;
	bh=Y5RJRfDLV2DCu1mvj4kQlpcYKc5OtRT6QjEgLN/vozU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Bb7nioTmrs0MXZ98Mu2H48iLQfHa2veLl1Af4QqDJI0BYM4Fzws684mK6h8V6ZZRs
	 LSRkArD2SayzrPpN0k3qjbbLw2JHBHb56pBlMFWYSG+cehjKgJNxfAYuW7QGMoMnvb
	 7f+5W8VXcGweBInSETECyVFhgL473DS6Zelb8pq5Pq08VXFtXAosYC6pbNffOjkUIe
	 ehl3yRLma5lgS1s5LUhAAwxL2e1BlAz2M90wikdT49n/X7ggUplQtnFsT7l6Ldcj/n
	 /8kESyUJCrZ8c2OCmASM/3TaLMJIrT1rSbPk92NqE+W9MEGxx7X7PbyxwVlusO8NCg
	 ZkIX+ffY+H0KQ==
Subject: Re: [PATCH net-next v5 04/12] net/rds: make rds_destroy_pending()
 cover single-connection destroy
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Wed, 23 Sep 2026 07:11:35 +0000
Message-ID: <179014749553.2160803.17759217962531390520@kernel.org>
In-Reply-To: <20260919061149.250658-5-achender@kernel.org>
References: <20260919061149.250658-5-achender@kernel.org>
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

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] Commit message justification does not exist in this tree: the
  message states "rds_ib_cm_connect_complete() destroys a single…
- [Low] The two comments added by this patch state an unconditional
  contract that three in-tree arming sites do not honour.

--

net/rds: make rds_destroy_pending() cover single-connection destroy

This adds a conn->c_destroy_in_prog flag, set by rds_conn_destroy() before
the unhash + synchronize_rcu() sequence, and tests it in
rds_destroy_pending() so that the work-arming sites stop queueing on the
path workqueues while a single connection is being torn down.  The dead
RDS_DESTROY_PENDING cp_flags bit and its remaining test in
rds_ib_is_unloading() are removed.

Two comments on the changelog and the new code comments below.

>     rds_conn_destroy() is not limited to the global paths:
>     rds_ib_cm_connect_complete() destroys a single connection whose peer
>     negotiated an unsupported protocol version.  (The other per-transport
>     caller, rds_ib_destroy_nodev_conns(), is only reached from
>     rds_ib_exit(), where ->t_unloading already covers it.)  While that
>     destroy runs, a concurrent rds_cong_queue_updates() can
>     still find the connection on the congestion map's m_conn_list (the
>     conn is only removed from it after the paths are torn down) and call
>     queue_delayed_work() on a cp_wq that destroy_workqueue() has already
>     freed.

[Severity: Medium]
Does rds_ib_cm_connect_complete() still call rds_conn_destroy()?  At the
baseline (8830e65) and at this commit, the version-mismatch arm in
net/rds/ib_cm.c reads:

	if (conn->c_version < RDS_PROTOCOL_VERSION) {
		if (conn->c_version != RDS_PROTOCOL_COMPAT_VERSION) {
			pr_notice("RDS/IB: Connection <%pI6c,%pI6c> version %u.%u no longer supported\n",
				  ...);
			rds_conn_drop(conn);
			return;
		}
	}

git grep rds_conn_destroy in net/rds/ matches only connection.c, rds.h,
ib_rdma.c, loop.c and tcp.c - ib_cm.c has no call at all.  The later patch
in this series ("net/rds: pin the connection across RDMA-CM event
handling") also states that this path "has meanwhile been switched to
rds_conn_drop() by commit f97d8c7bab78".

If that is right, can the described rds_cong_queue_updates() race against a
freed cp_wq be reached at all through the named caller?

Looking at the five remaining callers, four already satisfy one of the two
old terms:

  rds_ib_destroy_nodev_conns()  - only from rds_ib_exit(), after
                                  rds_ib_set_unloading()
  rds_tcp_destroy_conns()       - only from rds_tcp_exit(), after
                                  rds_tcp_set_unloading()
  rds_loop_exit()               - after rds_loop_set_unloading()
  rds_tcp_kill_sock()           - from rds_tcp_exit_net(), where either
                                  check_net() is false or ->t_unloading is
                                  already set

The one caller that does appear to escape the old predicate is the loop
pernet exit, which the changelog does not mention:

	rds_conn_exit()
	  rds_loop_net_exit()		/* unregister_pernet_device() */
	    rds_loop_exit_net()
	      rds_loop_kill_conns()
	        rds_conn_destroy()
	  rds_loop_exit()		/* sets the loop unloading flag */

rds_loop_kill_conns() runs for every live netns, so check_net() is still
true, and the unloading flag is only set afterwards by rds_loop_exit().

Given that, is the Fixes: cdc306a5c9cd3 ("rds: make v3.1 as compat
version") attribution correct?  RDS_DESTROY_PENDING was never set on the
loop path, so removing its last set_bit does not look like what left this
caller unguarded.  Would it make sense to re-point the changelog (and the
Fixes: tag, or drop it) at the rds_loop_net_exit() path instead, so that a
stable backport is not requested for the version-mismatch path?

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index a96569a3ee9a..242ca0570a47 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c
> @@ -579,6 +579,14 @@ void rds_conn_destroy(struct rds_connection *conn)
>  		 "%pI4\n", conn, &conn->c_laddr,
>  		 &conn->c_faddr);
>  
> +	/* Make rds_destroy_pending() true for this conn.  Together with
> +	 * the synchronize_rcu() below this stops the work-requeueing
> +	 * sites (which all test rds_destroy_pending() under
> +	 * rcu_read_lock()) from queueing new work on the path
> +	 * workqueues once we start cancelling and destroying them.
> +	 */

[Severity: Low]
This isn't a bug, but is the "which all test rds_destroy_pending() under
rcu_read_lock()" claim accurate?  There are three arming sites in tree that
do not.

rds_send_worker() and rds_recv_worker() in net/rds/threads.c re-arm with a
bare queue:

	case -EAGAIN:
		rds_stats_inc(s_send_immediate_retry);
		queue_delayed_work(cp->cp_wq, &cp->cp_send_w, 0);
		break;

The previous patch's changelog explains that these self-requeues are
covered by the cancel_delayed_work_sync() calls in
rds_conn_path_destroy(), but nothing in the code says so.

rds_conn_path_drop() skips the predicate entirely when destroy is true:

	rcu_read_lock();
	if (!destroy && rds_destroy_pending(cp->cp_conn)) {
		rcu_read_unlock();
		return;
	}
	queue_work(cp->cp_wq, &cp->cp_down_w);
	rcu_read_unlock();

That bypass is needed by rds_conn_path_destroy() itself, but it is also
used from outside the destroy path, by rds_ib_dev_shutdown() on IB device
removal:

	list_for_each_entry(ic, &rds_ibdev->conn_list, ib_node)
		rds_conn_path_drop(&ic->conn->c_path[0], true);

There, neither check_net(), ->t_unloading nor the new c_destroy_in_prog can
suppress the queue_work().

Could the comment be reworded to name the exceptions, so a later reader
does not conclude the new flag closes the whole window?  The same wording
appears in the rds.h comment below.

> +	WRITE_ONCE(conn->c_destroy_in_prog, true);
> +
>  	/* Ensure conn will not be scheduled for reconnect */
>  	spin_lock_irq(&rds_conn_lock);
>  	hlist_del_init_rcu(&conn->c_hash_node);

[ ... ]

> diff --git a/net/rds/rds.h b/net/rds/rds.h
> index 2db49573dacd..50b08c28ab86 100644
> --- a/net/rds/rds.h
> +++ b/net/rds/rds.h
> @@ -148,6 +147,14 @@ struct rds_connection {
>  				c_pad_to_32:29;
>  	int			c_npaths;
>  	bool			c_with_sport_idx;
> +	/* Set once, by rds_conn_destroy(), before it cancels the path
> +	 * works; read through rds_destroy_pending().  A site that arms
> +	 * a path work must test the predicate and queue the work inside
> +	 * one rcu_read_lock() section: the synchronize_rcu() that
> +	 * follows the store is what keeps a queue issued after the
> +	 * cancellation from landing on a destroyed workqueue.
> +	 */
> +	bool			c_destroy_in_prog;
>  	struct rds_connection	*c_passive;
>  	struct rds_transport	*c_trans;
>  
> @@ -994,7 +1001,8 @@ void __rds_put_mr_final(struct kref *kref);
>  
>  static inline bool rds_destroy_pending(struct rds_connection *conn)
>  {
> -	return !check_net(rds_conn_net(conn)) ||
> +	return READ_ONCE(conn->c_destroy_in_prog) ||
> +	       !check_net(rds_conn_net(conn)) ||
>  	       (conn->c_trans->t_unloading && conn->c_trans->t_unloading(conn));
>  }

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260919061149.250658-1-achender%40kernel.org
