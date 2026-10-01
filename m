Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470494825B8;
	Thu,  1 Oct 2026 06:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790835371; cv=none; b=ENitZmjqvD+6CJmMgEKvy5toosvvYoDoIIX67lPIJ1RB6k8piPMFwg7qHTGVToDYuaw/HQg9+RNAEY8Iz5X3rWJ64zcryopyVXaBhZmmYHB6Op79WdAtBWIMIEBZ4FceG7TOJTuuK5pnIi+NRV5N31STsP4KxEj7aP/1AKuValM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790835371; c=relaxed/simple;
	bh=wb3Zo+MUdQP5LZ5gesCVv1BDQ7SzH6BIxv3CinlsHlw=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lA7kAn4HRHcGDzvwijhb1ikWngqXGQ9JvWK0YhymokPCpJkvD84CiauJRxgJ8l4OyuNfufdwZFtn3DNwNYH3nheoW/g3Q6/xNwsuWpC3cydjrHArcFZW2oHzHJpLxBk/M+tu1RpJ/8c9NKAnssjYxswBPKUyL1l+VF6jIQHDAcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UYxBm261; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UYxBm261"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC901F00899;
	Thu,  1 Oct 2026 06:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790835369;
	bh=DWrTXi2a6IhIMmpLO01GjI1Wiom4vJ2OoQjjXi73/4M=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=UYxBm2617Q1UaKa2gC4JcB5zAoUk4pGSEIy6c9V4wrHurchNxyVvmAU2gVuNdD9d1
	 LZ9NXxlUXI3oxTeUX3jIZanHG1JPP0vkmTvbPauBzfBrzSKKNi2fO16ZrTTHbvlHk/
	 UjHg3f28UWupU4wqDIt51gsCgLytk7tINbjbgK39ZT6cPk2850sRHqpXptsFa38Ifi
	 5jFZmvxQuKRNo22GjE40h/D9d1dXkY2MUkL5TN9vHDincUm1n1zFOGkxHfn/sQzsAV
	 PyEHHD68if4jevFPlgOiRFqd2zZV8v9DA47GBwbncdHgv6R60GwqEztOov/fDgViKD
	 SBB4yt9FfeaxA==
Subject: Re: [PATCH net-next v7 05/12] net/rds: split connection destroy into
 quiesce and kref-governed free
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Thu, 01 Oct 2026 06:16:09 +0000
Message-ID: <179083536914.434549.11226632845050388483@kernel.org>
In-Reply-To: <20260927061448.167862-6-achender@kernel.org>
References: <20260927061448.167862-6-achender@kernel.org>
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

- [Low] The comment added to rds_conn_destroy()
  (net/rds/connection.c:647-656) and this commit's message justify the…

--

net/rds: split connection destroy into quiesce and kref-governed free

This commit adds a kref to struct rds_connection. It splits
rds_conn_destroy() into a synchronous quiesce step and a deferred free in
rds_conn_destroy_fini(), which runs on the final rds_conn_put(). It also
adds a first-caller-wins guard on c_destroy_in_prog, so a second
rds_conn_destroy() of the same connection returns at once.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index cbc49426ba085..638e9f3140e28 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c

[ ... ]

> @@ -590,11 +643,26 @@ void rds_conn_destroy(struct rds_connection *conn)
>  	 * sites (which all test rds_destroy_pending() under
>  	 * rcu_read_lock()) from queueing new work on the path
>  	 * workqueues once we start cancelling and destroying them.
> +	 *
> +	 * Now that the transport state stays discoverable (e.g. on the
> +	 * transports' connection lists) until the final rds_conn_put(),
> +	 * a conn can be handed to rds_conn_destroy() more than once -
> +	 * the IB unload path re-sweeps its connection list until every
> +	 * connection is gone.  Only the first caller proceeds; the
> +	 * unhash also happens under rds_conn_lock, so a looked-up conn
> +	 * can never be quiesced twice.  (With the initial reference the
> +	 * only one, as it is at this point in the series, nothing can
> +	 * reach a second call yet; this is the contract the following
> +	 * patches rely on.)
>  	 */
> +	spin_lock_irq(&rds_conn_lock);
> +	if (conn->c_destroy_in_prog) {
> +		spin_unlock_irq(&rds_conn_lock);
> +		return;
> +	}

[Severity: Low]
Is this comment accurate? At this commit, rds_ib_exit() calls
rds_ib_destroy_nodev_conns() once, and that function makes a single pass
over its list:

net/rds/ib_rdma.c:rds_ib_destroy_nodev_conns() {
    ...
	list_splice(&ib_nodev_conns, &tmp_list);
	spin_unlock_irq(&ib_nodev_conns_lock);

	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node)
		rds_conn_destroy(ic->conn);
    ...
}

So nothing re-sweeps the list and passes the same conn to
rds_conn_destroy() a second time.

Later in the series, rds_conn_wait_conns_freed() does call
rds_ib_destroy_nodev_conns() again on each poll. However, "net/rds: unlink
transport nodes before a possibly deferred connection free" makes the sweep
claim each node under ib_nodev_conns_lock before the destroy:

	ic->i_ib_node_detached = true;
	list_move_tail(&ic->ib_node, &tmp_list);

Nothing ever clears i_ib_node_detached. rds_ib_add_conn(),
rds_ib_remove_conn() and rds_ib_conn_free() all skip a detached node, so a
gathered conn can't show up on ib_nodev_conns again for a later sweep to
find. The TCP and loop sweeps also unlink and detach each node before
destroying it.

That seems to contradict "the transport state stays discoverable (e.g. on
the transports' connection lists) until the final rds_conn_put()". The
commit message makes the same claim:

  so that a connection handed to it a second time - which the IB unload
  re-sweep added later in the series does - is not quiesced twice

If no caller can reach a second rds_conn_destroy() on the same conn,
should the c_destroy_in_prog guard be dropped? If it stays, could this
comment, the rds_conn_destroy() header comment, the c_destroy_in_prog
comment in rds.h ("so a second destroy of the same connection returns at
once") and the commit message be reworded? As written, they describe a
double destroy that no path produces.

>  	WRITE_ONCE(conn->c_destroy_in_prog, true);
>  
>  	/* Ensure conn will not be scheduled for reconnect */
> -	spin_lock_irq(&rds_conn_lock);
>  	hlist_del_init_rcu(&conn->c_hash_node);
>  	spin_unlock_irq(&rds_conn_lock);
>  	synchronize_rcu();

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927061448.167862-1-achender%40kernel.org
