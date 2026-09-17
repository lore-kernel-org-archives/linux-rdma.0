Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFCB4B0E4B;
	Thu, 17 Sep 2026 09:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789637946; cv=none; b=FH83/NDe8D5MtAOMTzgLlbT3JjdnaVHhwAejkRoZVDxQkG+W22IDsbnYeyXWikaDHYFwkMK5Iea5xOBFBna74FyDbtaEiPUJLMgrDRp9Lh1ojQDbus9tCx4jtYY6OKIIP593b/5E4w9C05FG5s4QrAB/kUv8fNf+kjZc23OAtDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789637946; c=relaxed/simple;
	bh=FxhoFcbhZDKmpSsynxflff6bW2o6rVTWbN05Xf5OjX4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B1+UbqbP68MfVzD5GdCoU0xFcy8euc2RLwCLF/DBd/ZudQUJON5osVZRPnnkVrcbz92+Xt2sZuOA47L24qyAh4sk+jDSkREPloqL84q9VSY/mJLIl4vMHHkPm/NjMd5y/cIPUytbKzyBC5qAv3TNCGAnj9Bin6DjTi3g4JI3PDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ApP/XBOB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ApP/XBOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B8E1F00898;
	Thu, 17 Sep 2026 09:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789637919;
	bh=ryfklCT3IZu/1eHfiBMVcn3OEBjePUksi02oWbg/a40=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ApP/XBOB6Uz/ik/YAqoAkjHi0HdjRuuAl0BmFcsMJ43wOM85md7AYZEn+OW7oSZ2/
	 t/iCIpoUkZX6kgAfSsA0VSjDz4fuOHYeY7WpOQ+DXXCU+6jlhMlN8G+isuFq43ons4
	 zuyk5tGLk6FPjZ6aYR5joeIhZJhNduknIhiGPeJuUPVEbKsj+zIsLvL4l2FyUS7VgW
	 MBpmRwsxWF24j+MxKiZh9g+5kDgQTWWhNnHI0Vm4FiTNHUKSdc054DqBJzQmmwge0Q
	 3VUVxzIgcPdGi/8L11tfY8Or4oTUvuX/IN63feh1TDhI0v0OXg95Q67YgLrHXJ0zY6
	 u4pSwTxLckVWA==
Subject: Re: [PATCH net-next v3 02/13] net/rds: free every path's transport
 data on the passive create paths
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Thu, 17 Sep 2026 09:38:38 +0000
Message-ID: <178963791883.22033.13301745054394804139@kernel.org>
In-Reply-To: <20260914033719.138057-3-achender@kernel.org>
References: <20260914033719.138057-3-achender@kernel.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 (2) · Medium: 1 · Low: 0

- [Medium] The commit message of "net/rds: free every path's transport
  data on the passive create paths" claims that the passive-creation…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the patch
  encodes the correct create-time path count on the rollback exits while…
- [High] This problem wasn't introduced by this patch, but the patch
  extends the same wrong ordering to every path: on both rollback exits…

--

net/rds: free every path's transport data on the passive create paths

This moves the per-path cp_transport_data free loop out of the
lost-creation-race exit of __rds_conn_create() into a new helper,
rds_conn_free_transport_data(), and calls that helper from both the
passive-creation exit and the lost-race exit.

A few questions about the change and about the surrounding code below.

[Severity: Medium]

>     The passive-connection
>     exit right above it, taken when a loopback parent already has its
>     c_passive twin, frees only path 0 and leaks the transport data of
>     paths 1..npaths-1.  RDS/TCP loopback is exactly a multipath passive
>     connection, so this is reachable.

Can the passive-creation exit actually be reached with npaths > 1 on this
tree?

parent is only ever assigned in __rds_conn_create() here:

	conn = rds_conn_lookup(net, head, laddr, faddr, trans, tos, dev_if);
	if (conn &&
	    conn->c_loopback &&
	    conn->c_trans != &rds_loop_transport &&
	    ipv6_addr_equal(laddr, faddr) &&
	    !is_outgoing) {
		parent = conn;
		conn = parent->c_passive;
	}

rds_conn_lookup() only matches conn->c_trans == trans, and npaths comes
from that same trans:

	int npaths = (trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);

rds_tcp_transport is the only transport with t_mp_capable = 1, and it also
sets t_prefer_loopback = 1, so a hash-resident conn with
c_trans == &rds_tcp_transport and c_loopback == 1 does not seem
constructible:

	loop_trans = rds_trans_get_preferred(net, faddr, conn->c_dev_if);
	if (loop_trans) {
		rds_trans_put(loop_trans);
		conn->c_loopback = 1;
		if (trans->t_prefer_loopback) {
			if (likely(is_outgoing)) {
				trans = &rds_loop_transport;
			} else {
				...
				conn = ERR_PTR(-EOPNOTSUPP);
				goto out;
			}
		}
	}

For the outgoing case the stored conn's c_trans becomes the loop transport,
which the parent predicate explicitly excludes, and the incoming case never
creates a conn at all.  IB sets neither flag, so an IB parent gives
npaths == 1.

If that reasoning holds, the patched exit only ever runs with npaths == 1
and the new loop is equivalent to the single trans->conn_free() it
replaces.  Should the changelog describe this as hardening for future
multipath passive transports rather than a reachable leak, and should the
Fixes: 1c5113cf796b tag be dropped so this is not pulled into stable as a
leak fix?

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index b6c4beb50eaf0..a96569a3ee9ad 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c
> @@ -161,6 +161,22 @@ static void __rds_conn_path_init(struct rds_connection *conn,
>  	cp->cp_flags = 0;
>  }
>  
> +/* Undo trans->conn_alloc(): it may have allocated transport data for
> + * every path of a multipath connection, not just for path 0.
> + */
> +static void rds_conn_free_transport_data(struct rds_connection *conn,
> +					 int npaths)
> +{
> +	struct rds_conn_path *cp;
> +	int i;
> +
> +	for (i = 0; i < npaths; i++) {
> +		cp = &conn->c_path[i];
> +		if (cp->cp_transport_data)
> +			conn->c_trans->conn_free(cp->cp_transport_data);
> +	}
> +}
> +

[Severity: High]

This isn't a bug introduced by this patch, but while the rollback exits now
consistently use the create-time npaths, the teardown side still derives its
own count from conn->c_trans, which may no longer be the transport npaths
was computed from.

Creation computes npaths from the caller-supplied trans and allocates one
ordered workqueue per path:

	int npaths = (trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
	...
	for (i = 0; i < npaths; i++) {
		__rds_conn_path_init(conn, &conn->c_path[i], is_outgoing);
		conn->c_path[i].cp_index = i;
		conn->c_path[i].cp_wq = alloc_ordered_workqueue(...);

but for an outgoing RDS/TCP connection to a local address trans is replaced
before conn->c_trans is stored:

	if (trans->t_prefer_loopback) {
		if (likely(is_outgoing)) {
			trans = &rds_loop_transport;

rds_conn_destroy() then recomputes:

	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);

rds_loop_transport is not t_mp_capable, so npaths is 1 there while 8 paths
and 8 workqueues were created.  rds_conn_path_destroy() is the only caller
of

	if (cp->cp_wq != rds_wq) {
		destroy_workqueue(cp->cp_wq);
		cp->cp_wq = NULL;
	}

so does this leak the 7 remaining workqueue_structs (and their
pool_workqueues) before kfree(conn->c_path), and also skip the per-path
WARN_ON(delayed_work_pending())/BUG_ON(!list_empty(&cp->cp_retrans))
checks?

The reported trigger is: bind an RDS socket to a non-127 local address on
lo (so rds_trans_get_preferred() picks rds_tcp_transport), sendmsg to that
same address, then delete the netns so rds_loop_kill_conns() ->
rds_conn_destroy() runs.  Cycling namespaces repeats it.

rds_conn_message_info_cmn() derives the count the same way

	npaths = (conn->c_trans->t_mp_capable ?
		  RDS_MPATH_WORKERS : 1);

so does it also under-report paths for these connections?  Would it be
better to store the create-time path count in the connection (c_npaths)
and have all consumers use that?

> @@ -316,7 +332,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
>  	if (parent) {
>  		/* Creating passive conn */
>  		if (parent->c_passive) {
> -			trans->conn_free(conn->c_path[0].cp_transport_data);
> +			rds_conn_free_transport_data(conn, npaths);
>  			free_cp = conn->c_path;
>  			kmem_cache_free(rds_conn_slab, conn);
>  			conn = parent->c_passive;

[Severity: High]

This is a pre-existing ordering issue, but the patch now applies it to
every path on both exits, so it seems worth asking about here.

Both rollback exits free the transport data and the conn first, and the
per-path workqueues are only destroyed later at out:

	rds_conn_free_transport_data(conn, npaths);
	free_cp = conn->c_path;
	kmem_cache_free(rds_conn_slab, conn);
	...
out:
	if (free_cp) {
		for (i = 0; i < npaths; i++)
			if (free_cp[i].cp_wq != rds_wq)
				destroy_workqueue(free_cp[i].cp_wq);
		kfree(free_cp);
	}

destroy_workqueue() drains work already queued on those workqueues, and the
drained handlers dereference cp->cp_conn and cp->cp_transport_data, both
already freed.  Can work be pending at that point?

trans->conn_alloc() publishes the transport data on a transport-global list
before the creation race is resolved:

net/rds/ib_cm.c:rds_ib_conn_alloc() {
	...
	spin_lock_irqsave(&ib_nodev_conns_lock, flags);
	list_add_tail(&ic->ib_node, &ib_nodev_conns);
	spin_unlock_irqrestore(&ib_nodev_conns_lock, flags);
}

and an IB device add walks that list:

net/rds/ib.c:rds_ib_nodev_connect() {
	spin_lock(&ib_nodev_conns_lock);
	list_for_each_entry(ic, &ib_nodev_conns, ib_node)
		rds_conn_connect_if_down(ic->conn);
	spin_unlock(&ib_nodev_conns_lock);
}

For a conn still inside __rds_conn_create(), cp_state is RDS_CONN_DOWN,
cp_flags is 0 and rds_destroy_pending() is false, so
rds_conn_path_connect_if_down() queues immediately:

	if (rds_conn_path_state(cp) == RDS_CONN_DOWN &&
	    !test_and_set_bit(RDS_RECONNECT_PENDING, &cp->cp_flags))
		queue_delayed_work(cp->cp_wq, &cp->cp_conn_w, 0);

If the creating thread then loses the race and takes one of these exits,
destroy_workqueue() drains cp_conn_w and rds_connect_worker() reads
conn = cp->cp_conn from the freed slab object and calls
conn->c_trans->conn_path_connect(cp) through it.

Would it be safer to destroy (and thereby drain) the per-path workqueues
before freeing the transport data and the conn, so the order becomes
destroy_workqueue() -> conn_free() -> kmem_cache_free()?

Unlike rds_ib_destroy_nodev_conns() and rds_tcp_destroy_conns(), which are
ordered by set_unloading plus synchronize_rcu(), and
rds_tcp_sysctl_reset(), which skips conns with tc->t_sock == NULL,
rds_ib_nodev_connect() has neither an RCU barrier nor a state filter that
would exclude a mid-creation conn.  Is there something else that keeps it
out of that list walk?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260914033719.138057-1-achender%40kernel.org
