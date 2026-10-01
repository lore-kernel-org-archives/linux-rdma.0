Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA5B43498B;
	Thu,  1 Oct 2026 06:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790835370; cv=none; b=TSCQ12ZEUBeCyzb4aVlZvQcKl86MEGNQZL2YvWBoR5K6Co06ahtr0LPRdQu/KaGBiEDF0GKgvbCvHyv55aWKyqZ5mH/dv3n+5rpDF02TJwi8cLXeqjFoZs+BHk088UmCqKRUhhqKVFvAnb8Xe5TOk0scp69g/us2FLrg8ovGdyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790835370; c=relaxed/simple;
	bh=d11/yzb5+nWIAhAZGhtsyLLLK/pT5H9DN1cGybQvbqY=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fXvblKIjtf24PZmuLNb4OhwTgIUPAqQ1d7vja1WoPVOJ2gFuNBAUyuMSz0Rm75VygYxWWSxl4zd8vTovYhdHarLX6KmM5wsaERKwLr/Nq2zE2NzM/pBtDFzw0OF8jCDG8L1NXhSuRAC2qXAnWro0KlUCuxaiOAdx1AFPpZaJ6Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D0+R7Zry; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D0+R7Zry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5D71F00898;
	Thu,  1 Oct 2026 06:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790835369;
	bh=sjLF9c9PN6TiPRkZSXkpbopzdtUTiQygApbBXdYkLAA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=D0+R7ZrypeIIQ23OQWOrI8UGwmDLW19yJ4yknLhLO7ljhwe47alSsCn4WxV4kWy5v
	 TEdaBqbfNLJwMIuHGuoLckAsFFZLPxr38OaioPL0qRJX5MRYvy8g75VELUZ+hkSMfP
	 msm2QN3Pxw53mKGaEQE8rRsynoQDW0ZyE2fLZFP8LysllLav0qjjFNfwA51fxFsBrv
	 dwGBdYGDcVpPzk8TXyRXT4zR/hveENM8DiKeu0pnrpbxXcSpEbn+NQSscyk8SeGO0g
	 GKSjbkEwZwnZAZFzG9eagv6NiNVLQUIfRWpXCZ0BiA1E4K1ynYPv1TcJiznCaB5Ry5
	 uIOKoe0HJ35bA==
Subject: Re: [PATCH net-next v7 04/12] net/rds: make rds_destroy_pending()
 report a connection's own destroy
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Thu, 01 Oct 2026 06:16:08 +0000
Message-ID: <179083536822.434549.15537094652989538353@kernel.org>
In-Reply-To: <20260927061448.167862-5-achender@kernel.org>
References: <20260927061448.167862-5-achender@kernel.org>
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

- [Medium] The commit message's only concrete justification for the
  `Fixes: c809195f5523` tag cannot happen.
- [Low] The new comment on struct rds_connection::c_destroy_in_prog
  (net/rds/rds.h) says the destroy == true rds_conn_path_drop() is…

--

net/rds: make rds_destroy_pending() report a connection's own destroy

This patch adds a c_destroy_in_prog flag to struct rds_connection.
rds_conn_destroy() sets it before the unhash and synchronize_rcu()
sequence, and rds_destroy_pending() now tests it first. The patch also
removes the unused RDS_DESTROY_PENDING cp_flags bit and its dead test in
rds_ib_is_unloading().

> One caller escapes both terms.  When the core rds module unloads,
> rds_conn_exit() runs rds_loop_net_exit() first, and unregistering the
> pernet operations invokes rds_loop_exit_net() -> rds_loop_kill_conns()
> -> rds_conn_destroy() for the loopback connections of every network
> namespace that is still alive: check_net() is true for all of them,
> and the loop transport's unloading flag is only set afterwards, by
> rds_loop_exit().  For the duration of those destroys the predicate is
> false, so a concurrent rds_cong_queue_updates() can still find the
> connection on the congestion map's m_conn_list (the conn is only
> removed from it after the paths are torn down) and call
> queue_delayed_work() on a cp_wq that destroy_workqueue() has already
> freed, and the other requeueing sites can likewise re-arm works that
> live in the about-to-be-freed connection.

[ ... ]

> Fixes: c809195f5523 ("rds: clean up loopback rds_connections on netns deletion")

[Severity: Medium]
Can this race with rds_cong_queue_updates() actually happen during
rds_exit()?

rds_cong_queue_updates() has only two callers, rds_recv_rcvbuf_delta() and
rds_cong_remove_socket(). Both of them run on behalf of a live rds_sock:

  rds_recv_incoming() (after rds_find_bound()), rds_still_queued(),
  rds_clear_recv_queue() -> rds_recv_rcvbuf_delta()

  rds_release(), rds_cong_monitor() -> rds_cong_remove_socket()

Every rds_sock pins the rds module. rds_proto has:

net/rds/af_rds.c:rds_proto {
	.owner	  = THIS_MODULE,
}

and the socket allocation does:

net/core/sock.c:sk_prot_alloc() {
    ...
	if (!try_module_get(prot->owner))
    ...
}

That reference is only dropped in sk_prot_free(). Also, rds_tcp and
rds_rdma import rds symbols, so they have to be unloaded before rds.

So when rds_exit() -> rds_conn_exit() runs, no RDS sockets should be
left, and only loopback connections remain.

The paragraph also says "the other requeueing sites can likewise re-arm
works", but doesn't name any. There may be a narrower path, for example a
cp_conn_w still in flight from a sendmsg just before the last close:

  rds_connect_worker()
    rds_loop_conn_path_connect()
      rds_connect_path_complete()

This re-queues cp_send_w and cp_recv_w after rds_conn_path_destroy() has
already cancelled them.

Could the commit message cite a trigger that can actually happen, such as
this one, as the reason for the Fixes tag? Or could it describe the patch
as hardening and a prerequisite for the following patches? Stable
backporters will rely on the reason given here.

> diff --git a/net/rds/rds.h b/net/rds/rds.h
> index 2db49573dacd5..d595fb78c61f4 100644
> --- a/net/rds/rds.h
> +++ b/net/rds/rds.h

[ ... ]

> @@ -148,6 +147,18 @@ struct rds_connection {
>  				c_pad_to_32:29;
>  	int			c_npaths;
>  	bool			c_with_sport_idx;
> +	/* Set once, by rds_conn_destroy(), before it cancels the path
> +	 * works; read through rds_destroy_pending().  A site that arms
> +	 * a path work must test the predicate and queue the work inside
> +	 * one rcu_read_lock() section: the synchronize_rcu() that
> +	 * follows the store is what keeps a queue issued after the
> +	 * cancellation from landing on a destroyed workqueue.  Two kinds
> +	 * of site are exempt: the workers' own self-requeues, which the
> +	 * sync cancel in the destroy path rejects, and the destroy == true
> +	 * rds_conn_path_drop(), which the destroy itself (and IB device
> +	 * removal) issues and then flushes.
> +	 */
> +	bool			c_destroy_in_prog;

[Severity: Low]
Is the IB device removal part of this comment accurate?

rds_ib_remove_one() calls rds_ib_dev_shutdown(), which does this for each
connection on rds_ibdev->conn_list:

net/rds/ib.c:rds_ib_dev_shutdown() {
    ...
	rds_conn_path_drop(&ic->conn->c_path[0], true);
    ...
}

With destroy == true, rds_conn_path_drop() skips the predicate and always
queues:

net/rds/connection.c:rds_conn_path_drop() {
    ...
	if (!destroy && rds_destroy_pending(cp->cp_conn)) {
	...
	}
	queue_work(cp->cp_wq, &cp->cp_down_w);
}

Neither rds_ib_dev_shutdown() nor rds_ib_remove_one() flushes cp_down_w
afterwards. The only flush_work(&cp->cp_down_w) is in
rds_conn_path_destroy().

Two other places have the same gap:

- The new comment above the WRITE_ONCE() in rds_conn_destroy() says the
  requeueing sites "all test rds_destroy_pending() under rcu_read_lock()".
- The commit message says the destroy itself "and IB device removal,
  issue and then flush".

The code looks safe today, but that comes from ordering. IB connections
are only destroyed by rds_ib_destroy_nodev_conns() from rds_ib_exit().
That runs after rds_ib_unregister_client() has finished every remove_one
callback. Any cp_down_w queued earlier is then flushed by
rds_conn_path_destroy().

Could the comments and commit message describe that ordering instead?
Later patches in the series build on this reasoning, and the rds.h comment
is unchanged at the end of the series.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927061448.167862-1-achender%40kernel.org
