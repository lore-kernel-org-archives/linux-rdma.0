Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054C9483BFC;
	Thu,  1 Oct 2026 06:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790835373; cv=none; b=i5PqYpUFHv067PokFeF9mS+6DeBKHGlmNBY1Q9eoro11X6em2B4MuqGBQExrynIh2tQwhTksgkQlswFb+YArTlqvlSw2mEBLb9TlsEyT11UGSyMamMCgOpo5h3j2j7xTRE0lvqWxKrB8e/q0gtvECeGAGn8xRNmXvosQ9Rw+5xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790835373; c=relaxed/simple;
	bh=WAXt1dJvfoV7Xbsv9/ZWgDkoNId53ObsIBjsgAc0l4M=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=beM+bMPURO3t0U5Y7m6z1Ee1bZ4Yeta9nzZy/IVxgT8FgH3ABw39GPXb2Fg8Sh3qTO/KxUhSFquYk91t+FfEUxzmdBF2Ce5y+tYFHv5leLdofRXOepi7oQW2wzyZEP4OAxH5BP5wK+WaIZ6Ls+uGNPu/ib21ogbcbwNWrQ5tPFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YiUp0QKv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YiUp0QKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6E01F00898;
	Thu,  1 Oct 2026 06:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790835371;
	bh=N1Y8j6q9nd4xyIdfJwLyQhPae9aLxoVQ/oxlPDdwJHk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=YiUp0QKv4QD1J0486mZDsZ6IJ61fPg8T9u9/HtZeggAUMeG9XKuei1OHsWUmgpXqe
	 wPasMpHwzCfqEP4EZry6HbBbBe9zY5dgqOaQPUd7L12VzHs21BtFwUkj56PGDZXNCB
	 SN02f78MwGWH1O1CRfsDV59N8e9WWCgrxVD7UlK9gnWCbnVPtriRa/jGfr7YId2XIf
	 MZUOuTJNB8G6GefFeE9Gx1jFJ332HfOYU44rNjJMAQ9p7KUYg5L6xGumfweK2GQjv+
	 qeKDi3WMCyPK3ePwNQICtFlrcdEH96ci3FX8ykOA+mhefKFS1ngHMzwWf+IcljQPtH
	 JwZKYEDkb+yEg==
Subject: Re: [PATCH net-next v7 07/12] net/rds: unlink transport nodes before
 a possibly deferred connection free
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Thu, 01 Oct 2026 06:16:11 +0000
Message-ID: <179083537102.434549.10470705307811098986@kernel.org>
In-Reply-To: <20260927061448.167862-8-achender@kernel.org>
References: <20260927061448.167862-8-achender@kernel.org>
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

- [Low] The rds_conn_destroy() comment in net/rds/connection.c gives a
  reason that this patch makes false, and the comment is still there,…
- [Low] The commit message does not describe the IB changes accurately.

--

net/rds: unlink transport nodes before a possibly deferred connection free

This patch changes the RDS TCP, IB and loopback teardown helpers so each
gathered transport node comes off the on-stack list before
rds_conn_destroy() runs. A deferred conn_free() then cannot write into a
dead stack frame. The gather also takes a connection reference, and a new
i_ib_node_detached flag makes rds_ib_add_conn(), rds_ib_remove_conn() and
rds_ib_conn_free() leave a claimed IB node alone.

> Unlink each node under the transport lock right before its
> rds_conn_destroy(), so that nothing is left on the stack list for a
> later free to touch.

[Severity: Low]
This matches loop (loop_conns_lock) and TCP (rds_tcp_conn_lock). It does
not match IB: rds_ib_destroy_nodev_conns() takes the node off tmp_list
with no lock held:

	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node) {
		conn = ic->conn;
		list_del_init(&ic->ib_node);

Only the later IB paragraph says that the walk is lockless.

> Those movers used to assert that the node is linked (and
> rds_ib_add_conn() that the nodev list is non-empty); a connect or
> shutdown worker can still be running for a connection the sweep has
> claimed, and such a connection is about to be destroyed anyway, so
> the assertions go.

The nodev-list assertion in rds_ib_add_conn() was already removed by the
previous patch, "net/rds: wait for connections to be freed on transport
unload". That patch's message says:

  rds_ib_add_conn() loses its assertion that the nodev list is
  non-empty

This patch only drops the two BUG_ON(list_empty(&ic->ib_node)) checks in
rds_ib_add_conn() and rds_ib_remove_conn().

Could the commit message be updated to match what the IB changes do?

> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index 0c91f1b85c9b7..71926f8ada41a 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c

[ ... ]

> @@ -162,13 +173,40 @@ void rds_ib_destroy_nodev_conns(void)
>  	struct rds_ib_connection *ic, *_ic;
>  	LIST_HEAD(tmp_list);
>  

[ ... ]

>  	spin_lock_irq(&ib_nodev_conns_lock);
> -	list_splice_init(&ib_nodev_conns, &tmp_list);
> +	list_for_each_entry_safe(ic, _ic, &ib_nodev_conns, ib_node) {
> +		if (rds_conn_get_unless_zero(ic->conn)) {
> +			ic->i_ib_node_detached = true;
> +			list_move_tail(&ic->ib_node, &tmp_list);
> +		}
> +	}
>  	spin_unlock_irq(&ib_nodev_conns_lock);
>  
> -	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node)
> -		rds_conn_destroy(ic->conn);
> +	/* rds_conn_destroy() can return before the connection is freed,
> +	 * and it is the free - rds_ib_conn_free() - that would unlink
> +	 * ib_node.  tmp_list lives on this stack frame, so take each node
> +	 * off it before its destroy; the free then leaves it alone.
> +	 */
> +	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node) {
> +		conn = ic->conn;
> +		list_del_init(&ic->ib_node);
> +
> +		rds_conn_destroy(conn);
> +		rds_conn_put(conn);
> +	}
>  }

[Severity: Low]
After this change, is the rds_conn_destroy() comment in
net/rds/connection.c still accurate? It says:

net/rds/connection.c:rds_conn_destroy() {
	 * Now that the transport state stays discoverable (e.g. on the
	 * transports' connection lists) until the final rds_conn_put(),
	 * a conn can be handed to rds_conn_destroy() more than once -
	 * the IB unload path re-sweeps its connection list until every
	 * connection is gone.  Only the first caller proceeds; the
	 * unhash also happens under rds_conn_lock, so a looked-up conn
	 * can never be quiesced twice.  (With the initial reference the
	 * only one, as it is at this point in the series, nothing can
	 * reach a second call yet; this is the contract the following
	 * patches rely on.)
}

In the sweep above, each gathered node gets i_ib_node_detached set under
ib_nodev_conns_lock and is list_del_init()'d before rds_conn_destroy().
rds_ib_add_conn() and rds_ib_remove_conn() never put a claimed node back
on ib_nodev_conns.

So the resweep that rds_ib_exit() passes to rds_conn_wait_conns_freed()
cannot find a connection it has already destroyed. That is the
double-destroy case the comment gives as the reason for the
c_destroy_in_prog test-and-set.

The other transports behave the same way.
rds_loop_destroy_gathered_conns() list_del_init()s the node and nothing
links it again. In rds_tcp_exit(), unregister_pernet_device() calls
rds_tcp_kill_sock() before the only rds_tcp_destroy_conns(), and nothing
sweeps after that.

Each sweep also holds its own extra reference when it calls
rds_conn_destroy(). So "the initial reference the only one" no longer
matches these callers, and "at this point in the series" means nothing
once the series is merged.

The comment is still unchanged at the end of the series. The guard itself
is harmless. Could the comment be updated to give the real reason for
keeping c_destroy_in_prog, or say that the IB re-sweep no longer reaches
it?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927061448.167862-1-achender%40kernel.org
