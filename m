Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D969119CC0F;
	Wed, 16 Sep 2026 04:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789533406; cv=none; b=iPMqrcnIVa2JEScNGCIjFJQRrm/QBH7yL9L8DIlz+XagoiI41G7Hl8miWMPyllrWaU6LpTCp13/3JpFR2Q4g33GPZghT719FQfkNN9aptCJQwiKf7uofFTvtK43jtySkuxXU6+MyKaqIVrknI9aQouisl/dlcvBGHjJNMvwgbxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789533406; c=relaxed/simple;
	bh=Rmpp7gTqh/iJTO5mly/LIl9PCZamd9tjdqdP8u0eSZM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c9U4laE6a1AL2/hC4paQiYCWTlgU0+n2iiFBZOBzG4dnD+7hi8sGmKiIMHKvS4vQkAsm29Ux90lAeNFtarS7+UqnrffbbUOIE28r+dCDRbK2d/3vEBMQXqC85XYYlvM2R72YKdn5C1hf2tK3MYBLUi3wRz8iLWGgiMrv9afQcHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MxWfSh9/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MxWfSh9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27291F000FF;
	Wed, 16 Sep 2026 04:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789533404;
	bh=d3ABrzm4AUcWw6NUesJa4Jr1/9+Y2u4W+SKqAEZtE0U=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=MxWfSh9/UZHomfFqGK2AzkPl47OIzpaFUa3WNdOexNJ/jsZ+hJuF9vFPCOhkHHgwf
	 QS/naPPxDSxzBdWHR+f3f/j2x6xPwgHIBkyo5SEHovtWBOqwvuEZxZZrcZIMKskRdL
	 jb4DABk09baItk2UDx8OiVjmKhPB1MNwRPamGKudvqcg7QY6cmL4kiwdfmgE1iIQnx
	 B/9OZH21LmXCeu/0Ku0RGy45GPLfv2L9PQHQaj0Y0Jtqinhf2V/MPktxHQisH0wqVJ
	 8t1tF1yYVrQCvcGrbdk5VdElfSQmrWbNhMURJqGe4EJ4+GI9uoaxozcvmlHwa76mGy
	 MVTP4LfKl69gw==
Subject: Re: [PATCH net-next v2 1/9] net/rds: guard every work-requeueing site
 with rds_destroy_pending()
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Wed, 16 Sep 2026 04:36:43 +0000
Message-ID: <178953340335.22033.8574444684748203869@kernel.org>
In-Reply-To: <20260912035027.27447-2-achender@kernel.org>
References: <20260912035027.27447-2-achender@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 0 · Low: 2

- [Low] At this commit the five newly added `rcu_read_lock() +
  rds_destroy_pending()` guards (net/rds/ib_send.c:302-306 and :429-433,…
- [Low] The subject claims to guard "every work-requeueing site" and the
  body states exactly "Five arming sites never got that guard", but four…

--

net/rds: guard every work-requeueing site with rds_destroy_pending()

This adds rcu_read_lock() + rds_destroy_pending() guards around five
queue_delayed_work() sites that re-arm cp_send_w, cp_recv_w and cp_conn_w:
two in net/rds/ib_send.c, one in net/rds/ib_recv.c, one in
net/rds/tcp_listen.c and one in net/rds/send.c.  The stated goal is that no
new path work can be queued once rds_conn_path_destroy() has started
cancelling works and is about to call destroy_workqueue().

A couple of questions on the changelog and on the effect of the guards at
this commit.

> net/rds: guard every work-requeueing site with rds_destroy_pending()

[ ... ]

>     Five arming sites never got that guard:

[Severity: Low]
Are those five really all of the requeueing sites?  net/rds/threads.c has
four more queue_delayed_work() calls on the same works that stay unguarded.

rds_send_worker():

	switch (ret) {
	case -EAGAIN:
		rds_stats_inc(s_send_immediate_retry);
		queue_delayed_work(cp->cp_wq, &cp->cp_send_w, 0);
		break;
	case -ENOMEM:
		rds_stats_inc(s_send_delayed_retry);
		queue_delayed_work(cp->cp_wq, &cp->cp_send_w, 2);

rds_recv_worker() has the matching pair for cp_recv_w.

These four are self-requeues issued from inside the running work item, and
in this tree cancel_delayed_work_sync() -> __cancel_work_sync() disables the
work with WORK_CANCEL_DISABLE before __flush_work(), so a requeue from the
still-running callback is rejected while the cancel is in progress and no
use-after-free follows.

The subject says "every work-requeueing site" and the body gives an exact
count of five, and the following patch in the series repeats that "all of
those sites guard the queueing with rds_destroy_pending() under
rcu_read_lock() (the last stragglers were converted by the previous patch)".
Could the changelog either convert the threads.c sites too, or say that
in-callback self-requeues are exempt and why?

The Fixes: tag points at ebeeb1ad9b8a, and on trees before
cancel_delayed_work_sync() gained the disable semantics a self-requeue from
the callback was not rejected, so a backporter reading this message cannot
tell whether those sites were considered.

> diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
> index bd6cb3ffaa571..7d45808544a0d 100644
> --- a/net/rds/ib_recv.c
> +++ b/net/rds/ib_recv.c
> @@ -458,7 +458,11 @@ void rds_ib_recv_refill(struct rds_connection *conn, int prefill, gfp_t gfp)
>  	    (must_wake ||
>  	    (can_wait && rds_ib_ring_low(&ic->i_recv_ring)) ||
>  	    rds_ib_ring_empty(&ic->i_recv_ring))) {
> -		queue_delayed_work(conn->c_path->cp_wq, &conn->c_recv_w, 1);
> +		rcu_read_lock();
> +		if (!rds_destroy_pending(conn))
> +			queue_delayed_work(conn->c_path->cp_wq,
> +					   &conn->c_recv_w, 1);
> +		rcu_read_unlock();
>  	}

[Severity: Low]
Can these guards close the cancel -> destroy_workqueue() window as of this
commit?  rds_destroy_pending() in net/rds/rds.h carries no per-connection
destroy state here:

static inline bool rds_destroy_pending(struct rds_connection *conn)
{
	return !check_net(rds_conn_net(conn)) ||
	       (conn->c_trans->t_unloading && conn->c_trans->t_unloading(conn));
}

and rds_conn_destroy() publishes nothing that the guards can observe before
the grace period:

	spin_lock_irq(&rds_conn_lock);
	hlist_del_init_rcu(&conn->c_hash_node);
	spin_unlock_irq(&rds_conn_lock);
	synchronize_rcu();

For a single-connection teardown with a live netns and the module loaded,
for example the protocol version mismatch path
rds_ib_cm_connect_complete() -> rds_conn_destroy(), the predicate reads
false, so a completion landing in rds_ib_recv_refill() or
rds_ib_send_cqe_handler() can still arm cp_recv_w/cp_send_w between
cancel_delayed_work_sync() and destroy_workqueue() in
rds_conn_path_destroy().

The next patch in the series, "net/rds: make rds_destroy_pending() cover
single-connection destroy", adds conn->c_destroy_in_prog, sets it under
rds_conn_lock before hlist_del_init_rcu() and synchronize_rcu(), and tests
it first in rds_destroy_pending(), which is what gives these five guards
their effect, so at the end of the series the window is closed.

Given the Fixes: tag invites a standalone backport, would it help to state
in this changelog that the guards only take effect together with the
c_destroy_in_prog change, or to reorder the two patches?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260912035027.27447-1-achender%40kernel.org
