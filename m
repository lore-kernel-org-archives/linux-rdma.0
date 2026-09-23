Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250333B19B2;
	Wed, 23 Sep 2026 07:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790147503; cv=none; b=SpJy4LeQFHTYbyiftKqFKMkAQQVjyoQ8mh9hxkXjIHGr3HWV4nkPkbOaefzq6qS+TzkfYZmRi0wNbTAfCOPYp8i80Ak42SPhtiBnIfTfEGTnM+5+zyJzLftrTPWSjglAsQ/uueq0jp/wIVVMJVWA/8O+0UuOONyzzud11rO2yBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790147503; c=relaxed/simple;
	bh=Il5pkYkfqxliWdiY+OCaRzuZtwzelQwn+03CxLMgc24=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R75LkwwCThALi2qXfZhA/+C55mIFTlmsLRGiWIV0BJBLrq3uGptURVihwLuDiTxXbFUc1EQNeJ6I88GtUaLxyCRgZsQ3g4NoZILmEYjvlVjUnI9JV++yC4WWUmJoPOaqp0Q7CBSId0uFPoWxMRkY2JRmcLb8fJnMLVwNaI3XRp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YizWrFVc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YizWrFVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB901F0089A;
	Wed, 23 Sep 2026 07:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790147497;
	bh=zIWgK2mOvKhYzSQuHLuXltYmSK+S9kfIld/8TkquniI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=YizWrFVcHHLyM34UbdeVTrHWtRRKetg/FCBsC9VYUp4noT2AHvYfQeR2veYo3J2Zt
	 ZF/BTUXgK1GNgu4DYDiG8TDRArm/Xf/cKDXBYyfOkZtCTqf5fVmG2ix1S8t1AWAMZL
	 toROPonzgG5KnZ4UwYAGW4zjC8pCb89tqEttdCtwlKxDDaJ0Tr5QeDq7x/1yMhxe18
	 jYO/ZqQuZwRnJny7wJqEjjcVu3VPTXg5Ft0i9XCGJtBIbBlbZmT3kokLa4JViz7eFT
	 veVigdCh6cWtWek7FR+WtbwW1kjOmBdNxFKdQlVPVWSlMUpN0Hp7sXVlcWja7MLHwK
	 a0aOMG+PgzmNQ==
Subject: Re: [PATCH net-next v5 05/12] net/rds: split connection destroy into
 quiesce and kref-governed free
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Wed, 23 Sep 2026 07:11:36 +0000
Message-ID: <179014749651.2160803.5225026361201856725@kernel.org>
In-Reply-To: <20260919061149.250658-6-achender@kernel.org>
References: <20260919061149.250658-6-achender@kernel.org>
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

- [Medium] Undisclosed behavioural change plus a comment whose premise is
  false at this commit: rds_conn_destroy()…
- [Low] The commit message's motivating example is stale, and the stale
  claim is copied into a new in-tree comment.

--

net/rds: split connection destroy into quiesce and kref-governed free

This adds a kref to struct rds_connection, keeps the synchronous quiesce
work in rds_conn_destroy() and moves the actual frees (transport
conn_free, path workqueues, c_path array, slab object) into
rds_conn_destroy_fini(), which runs on the last rds_conn_put().  It also
exports rds_conn_get()/rds_conn_put() and adds rds_conn_get_unless_zero().

A couple of questions about the new duplicate-destroy guard and the
descriptions around it.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index 242ca0570a47..a44aa4d2a5e8 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c
> @@ -231,6 +231,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
>  		goto out;
>  	}
>  
> +	kref_init(&conn->c_refcount);
>  	INIT_HLIST_NODE(&conn->c_hash_node);
>  	conn->c_laddr = *laddr;
>  	conn->c_isv6 = !ipv6_addr_v4mapped(laddr);

[ ... ]

> @@ -561,16 +575,52 @@ static void rds_conn_path_destroy(struct rds_conn_path *cp)
>  	cp->cp_conn->c_trans->conn_free(cp->cp_transport_data);
>  }
>  
> +/* Free a connection.  This runs from rds_conn_put() when the last
> + * reference is dropped, after rds_conn_destroy() has quiesced the
> + * connection and dropped the initial reference.
> + */
> +static void rds_conn_destroy_fini(struct kref *kref)
> +{
> +	struct rds_connection *conn = container_of(kref, struct rds_connection,
> +						   c_refcount);
> +	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
> +	unsigned long flags;
> +	int i;
> +
> +	for (i = 0; i < npaths; i++)
> +		rds_conn_path_free(&conn->c_path[i]);
> +
> +	kfree(conn->c_path);
> +	kmem_cache_free(rds_conn_slab, conn);
> +
> +	spin_lock_irqsave(&rds_conn_lock, flags);
> +	rds_conn_count--;
> +	spin_unlock_irqrestore(&rds_conn_lock, flags);
> +}
> +
> +void rds_conn_get(struct rds_connection *conn)
> +{
> +	kref_get(&conn->c_refcount);
> +}
> +EXPORT_SYMBOL_GPL(rds_conn_get);
> +
> +void rds_conn_put(struct rds_connection *conn)
> +{
> +	kref_put(&conn->c_refcount, rds_conn_destroy_fini);
> +}
> +EXPORT_SYMBOL_GPL(rds_conn_put);
> +
>  /*
>   * Stop and free a connection.
>   *
> - * This can only be used in very limited circumstances.  It assumes that once
> - * the conn has been shutdown that no one else is referencing the connection.
> - * We can only ensure this in the rmmod path in the current code.
> + * Quiesces the connection synchronously (workers cancelled, transport
> + * connections shut down, queued messages dropped) and drops the
> + * initial reference.  The memory - including the transport's
> + * per-connection state and the path workqueues - is freed once the
> + * last rds_conn_put() runs, which may be after this returns.
>   */
>  void rds_conn_destroy(struct rds_connection *conn)
>  {
> -	unsigned long flags;
>  	int i;
>  	struct rds_conn_path *cp;
>  	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
> @@ -584,11 +634,23 @@ void rds_conn_destroy(struct rds_connection *conn)
>  	 * sites (which all test rds_destroy_pending() under
>  	 * rcu_read_lock()) from queueing new work on the path
>  	 * workqueues once we start cancelling and destroying them.
> +	 *
> +	 * Now that the transport state stays discoverable (e.g. on the
> +	 * transports' connection lists) until the final rds_conn_put(),
> +	 * a conn can be handed to rds_conn_destroy() more than once -
> +	 * e.g. dropped for a protocol version mismatch and then found
> +	 * again at module unload.  Only the first caller proceeds; the
> +	 * unhash also happens under rds_conn_lock, so a looked-up conn
> +	 * can never be quiesced twice.
>  	 */

[Severity: Low]
Is the "dropped for a protocol version mismatch" example still accurate?
The changelog makes the same claim:

    "Today, connections are also destroyed on network namespace teardown
    (rds_tcp_kill_sock() and rds_loop_kill_conns()) and, one at a time,
    when a peer negotiates an unsupported protocol version
    (rds_ib_cm_connect_complete())."

In the current tree that branch of rds_ib_cm_connect_complete() only drops
the connection:

net/rds/ib_cm.c:rds_ib_cm_connect_complete() {
	...
			pr_notice("RDS/IB: Connection <%pI6c,%pI6c> version %u.%u no longer supported\n",
				  ...);
			rds_conn_drop(conn);
			return;
	...
}

and rds_conn_drop() -> rds_conn_path_drop(cp, false) only sets
RDS_CONN_ERROR and queues cp_down_w, so nothing is destroyed or freed
there.  That was changed by commit f97d8c7bab78 ("rds: ib: use
rds_conn_drop() on protocol version mismatch"), which is already in the
baseline, and a later patch in this series ("net/rds: pin the connection
across RDMA-CM event handling") acknowledges it.

A grep for rds_conn_destroy() callers at this commit finds only
rds_ib_destroy_nodev_conns(), rds_tcp_destroy_conns(),
rds_tcp_kill_sock(), rds_loop_exit() and rds_loop_kill_conns(), all
module- or netns-teardown paths.  Could the changelog and this new
comment be updated to drop the per-connection version-mismatch example?

> +	spin_lock_irq(&rds_conn_lock);
> +	if (conn->c_destroy_in_prog) {
> +		spin_unlock_irq(&rds_conn_lock);
> +		return;
> +	}
>  	WRITE_ONCE(conn->c_destroy_in_prog, true);

[Severity: Medium]
This new early return changes the semantics of an EXPORT_SYMBOL_GPL
teardown interface into "first caller wins", but the changelog lists only
kref_init(), the destroy/fini split and the new exports, and says:

    "rds_conn_destroy() still quiesces synchronously exactly as before"

    "With no additional reference holders yet, this only sets up the
    refcounting framework and is functionally equivalent to the current
    code (the initial reference is the only one), so every free still
    completes inside rds_conn_destroy()."

Would it be worth calling the guard out explicitly?  A second caller now
returns without quiescing anything and without waiting for the first
caller's synchronize_rcu()/quiesce to finish, while the function comment
added just above and the new c_refcount comment in net/rds/rds.h both
describe the quiesce and the reference drop unconditionally.

The justification in the comment also seems to rest on a property this
patch does not yet provide.  It says the conn "stays discoverable ...
until the final rds_conn_put()", but with the initial reference being the
only reference, the rds_conn_put() at the end of rds_conn_destroy() runs
rds_conn_destroy_fini() inline:

net/rds/connection.c:rds_conn_destroy_fini() {
	...
	kfree(conn->c_path);
	kmem_cache_free(rds_conn_slab, conn);
	...
}

So at this commit a hypothetical second rds_conn_destroy() on the same
pointer would read conn->c_destroy_in_prog out of freed slab memory
rather than be rejected by the guard.  c_destroy_in_prog is written only
by rds_conn_destroy() itself, and all five in-tree callers unlink the
transport node under the transport lock before destroying, so the branch
looks like dead code here.

Would it make more sense to move the guard to the patch that actually
lets a conn outlive rds_conn_destroy() ("net/rds: unlink transport nodes
before a possibly deferred connection free" / "net/rds: hold connection
references in lookup, sockets and c_passive"), or otherwise to say in the
changelog and in the comment that it is forward-looking scaffolding and
inert at this point in the series?

>  
>  	/* Ensure conn will not be scheduled for reconnect */
> -	spin_lock_irq(&rds_conn_lock);
>  	hlist_del_init_rcu(&conn->c_hash_node);
>  	spin_unlock_irq(&rds_conn_lock);
>  	synchronize_rcu();

[ ... ]

> @@ -607,12 +669,10 @@ void rds_conn_destroy(struct rds_connection *conn)
>  	 */
>  	rds_cong_remove_conn(conn);
>  
> -	kfree(conn->c_path);
> -	kmem_cache_free(rds_conn_slab, conn);
> -
> -	spin_lock_irqsave(&rds_conn_lock, flags);
> -	rds_conn_count--;
> -	spin_unlock_irqrestore(&rds_conn_lock, flags);
> +	/* drop the initial reference; the connection is freed from
> +	 * rds_conn_destroy_fini() once every holder has dropped theirs
> +	 */
> +	rds_conn_put(conn);
>  }
>  EXPORT_SYMBOL_GPL(rds_conn_destroy);
>  
> diff --git a/net/rds/rds.h b/net/rds/rds.h
> index 50b08c28ab86..defda3ddefa3 100644
> --- a/net/rds/rds.h
> +++ b/net/rds/rds.h
> @@ -137,6 +137,12 @@ struct rds_conn_path {
>  /* One rds_connection per RDS address pair */
>  struct rds_connection {
>  	struct hlist_node	c_hash_node;
> +	/* rds_conn_destroy() quiesces the connection synchronously;
> +	 * freeing it - the connection memory, the path workqueues and
> +	 * the transport's per-connection state - is deferred until the
> +	 * last reference is dropped via rds_conn_put().
> +	 */
> +	struct kref		c_refcount;

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260919061149.250658-1-achender%40kernel.org
