Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB9D3B19BA;
	Sun,  4 Oct 2026 16:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791131702; cv=none; b=eWgYR+8KMqeDFOntDqJLjWeD2ZBT91IWNX3NZUvXIjB/hHVN1i4UeR7MJsIekw2YVeyCGK2J0urDFe4nFpmK5+Gjc4bmcUBSPBlnH87XNlrIOIb2JegzhbW1NiPS7t0LKxfk5AWYEd6zJ9zaLuhVQjo7y5yNw9ap8myJhrNZMoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791131702; c=relaxed/simple;
	bh=BqBSsAq2b2OT3dWH7VuxmHzGH+GOrchx12zq2nv5dC4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MIvw50kFm8AMG0PhrhepAHDZrQxLTtWOfq5xncTrLDYlnMkr56UaK+V9Bpk4iQ+ChwRqAXucMstpeTC3esZJBVwdqS+Xp+6E0uNDsFb4o0bjItviyaEx/js5yKeJZoF2QNDPksxG3cH28g9sRWJf3K/yX2ZiKqvbCUMa/KGrhvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GeU3+N9o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GeU3+N9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFB91F00898;
	Sun,  4 Oct 2026 16:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791131701;
	bh=YTiMsZSIRqVhWtkBEu+zHvWareT/FipK9JH2bHKtWxk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=GeU3+N9oz1X99AUtCuSttRRqlcFVSgyWIoCzgwo2+/xgK06pmqMrhLAnYMIG34HwW
	 8I6yU0Zv1i5w1ms0PeKTMMLuGeMZ357lIZIwRLsPC8q4pEGTcohUBHkP54pgqKNVsx
	 ed9XfA7orIVSP3Fnkb8WKOwrFbKBFXKvyQwC0kwquDo05t/nW1Wkw9smgntRkIWTV4
	 AHwaD3rFyHmdl9Q5fe/Jara4FCH/OZtO7lgLL8WIinI0eGJatAqbXGcEZC2IPl8wIv
	 cAaCd9HUKfEmtduggfJEDxH4L3KBXabReQgh8IG/1UovnVHddqoC9zz4wYnEHm48Jp
	 VzKooXRUOSjEQ==
Subject: Re: [PATCH net-next v8 07/13] net/rds: unlink transport nodes before
 a possibly deferred connection free
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Sun, 04 Oct 2026 16:35:00 +0000
Message-ID: <179113170054.434549.13137467723025145804@kernel.org>
In-Reply-To: <20261003163215.250253-8-achender@kernel.org>
References: <20261003163215.250253-8-achender@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message says the whole change is groundwork: the old
  helpers were "fine for as long as rds_conn_destroy() frees the…
- [Low] After this patch, rds_ib_add_conn() (net/rds/ib_rdma.c) has a
  third outcome.

--

net/rds: unlink transport nodes before a possibly deferred connection free

This patch changes the RDS TCP, loopback and IB teardown helpers. Each
helper now takes a reference on every connection it gathers and unlinks
the transport node from the on-stack list before calling
rds_conn_destroy(), so a deferred conn_free() later in the series does not
touch a dead stack frame. IB also gains an i_ib_node_detached flag, which
makes rds_ib_add_conn(), rds_ib_remove_conn() and rds_ib_conn_free() leave
a node alone once the sweep has claimed it.

> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index 50c02f47cf683..34e09525a10b2 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c

[ ... ]

> @@ -136,14 +137,15 @@ int rds_ib_add_conn(struct rds_ib_device *rds_ibdev,
>  	 * the caller to fail and the transport exit to find.
>  	 */
>  	if (rds_ibdev->shutting_down) {
> -		spin_unlock(&rds_ibdev->spinlock);
> -		spin_unlock_irq(&ib_nodev_conns_lock);
> -		return -ENODEV;
> +		ret = -ENODEV;
> +	} else if (!ic->i_ib_node_detached) {
> +		list_del(&ic->ib_node);
> +		list_add_tail(&ic->ib_node, &rds_ibdev->conn_list);
>  	}
> -	list_del(&ic->ib_node);
> -	list_add_tail(&ic->ib_node, &rds_ibdev->conn_list);
>  	spin_unlock(&rds_ibdev->spinlock);
>  	spin_unlock_irq(&ib_nodev_conns_lock);
> +	if (ret)
> +		return ret;
>  
>  	ic->rds_ibdev = rds_ibdev;
>  	refcount_inc(&rds_ibdev->refcount);

[Severity: Low]
Take the case where the device is not shutting_down but the sweep has
already set i_ib_node_detached. Here ret stays 0 and the node is not
moved onto rds_ibdev->conn_list. The function still sets ic->rds_ibdev,
takes a device reference and returns success.

Does that third outcome fit the promise made in rds_ib_dev_shutdown()?

    /* Close the device to new connections under the same lock that
     * rds_ib_add_conn() attaches them under, so that every
     * connection is either dropped by the walk below or refused.
     */

As far as I can tell, this branch can't be reached at the moment.
rds_ib_destroy_nodev_conns() only runs from rds_ib_exit(), after
rds_ib_unregister_client(). That call runs
rds_ib_remove_one()->rds_ib_dev_shutdown() for every device, which sets
shutting_down under rds_ibdev->spinlock. rds_ib_add_conn() tests
shutting_down first, under the same lock, so a claimed connection always
gets -ENODEV.

Would it be more robust to return -ENODEV for the detached case as well?
The commit message already says "such a connection is about to be
destroyed anyway", and that change would make the invariant hold by
construction.

The existing comment above, "leave the connection on the nodev list for
the caller to fail and the transport exit to find", is also slightly
inexact for a claimed node. Such a node is on the sweep's stack list or
already unlinked.

[ ... ]

> @@ -176,13 +185,40 @@ void rds_ib_destroy_nodev_conns(void)
>  	struct rds_ib_connection *ic, *_ic;
>  	LIST_HEAD(tmp_list);
>  
> -	/* avoid calling conn_destroy with irqs off */
> +	struct rds_connection *conn;
> +

[ ... ]

>  	spin_lock_irq(&ib_nodev_conns_lock);
> -	list_splice(&ib_nodev_conns, &tmp_list);
> +	list_for_each_entry_safe(ic, _ic, &ib_nodev_conns, ib_node) {
> +		if (rds_conn_get_unless_zero(ic->conn)) {
> +			ic->i_ib_node_detached = true;
> +			list_move_tail(&ic->ib_node, &tmp_list);
> +		}
> +	}
>  	spin_unlock_irq(&ib_nodev_conns_lock);

[Severity: Low]
The commit message describes the whole change as groundwork:

    That is fine for as long as rds_conn_destroy() frees the connection
    before it returns

and:

    nothing in this tree destroys a connection behind the sweep's back
    today, so this is preparation for those patches rather than a fix.

For IB, does this hunk also fix a race that exists before this patch?

The old list_splice() never re-initialised ib_nodev_conns. Loopback, by
contrast, follows its splice with INIT_LIST_HEAD(&loop_conns). After the
splice, ib_nodev_conns.next and .prev still point at nodes that now sit
on the stack tmp_list.

In rds_ib_exit(), rds_ib_unregister_client() leads to
rds_ib_dev_shutdown()->rds_conn_path_drop(cp, true), which queues the
shutdown on the per-path cp_wq. The flush_workqueue(rds_wq) in
rds_ib_unregister_client() doesn't flush cp_wq, so this path can overlap
the sweep:

rds_ib_conn_path_shutdown()
  rds_ib_remove_conn()
    list_add_tail(&ic->ib_node, &ib_nodev_conns);

Because it goes through the stale head, that insert links the node after
the last entry of tmp_list. That entry's ->next then points to
&ib_nodev_conns rather than &tmp_list.

The lockless walk in rds_ib_destroy_nodev_conns() would then treat the
global head as an rds_ib_connection and pass garbage to
rds_conn_destroy().

In the same way, a connect worker's rds_ib_add_conn() could list_del() a
spliced node off tmp_list during the unlocked walk. The commit message
mentions this overlap itself ("Either can run while the sweep holds the
node on its stack list").

Both cases are closed by the per-entry list_move_tail() under
ib_nodev_conns_lock together with the i_ib_node_detached claim.

Could the commit message say that the IB part fixes an existing list
corruption race on module unload? It may also be worth adding a Fixes:
tag so stable backporters can find it.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261003163215.250253-1-achender%40kernel.org
