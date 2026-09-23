Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6704C4483B9;
	Wed, 23 Sep 2026 07:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790147497; cv=none; b=WGA1Dh7QfJ/CQF3EA4Khh/HXbUusF09bKmby77nqCInlOnVCvzY6RsmFQAbmtRhpRQAx2t6CR3rkJ/tibD2fsq7Fah6CMPY/lRYvtUagbVCVCXkVL/SeHtNSL8qdpQQ5DBq5F2xrtft5fiS732j6SOyQvbnc9enIpWMNqx94t2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790147497; c=relaxed/simple;
	bh=7p9rR1sxhQycrLO5h74+EX9IBchNHaUr4NIokE1hsWc=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PCHt7FR7brOdUFqO3EDteRbIXSCVxmnSC5fvHfYpLRdIZwhTu2ogVeOzpeEqY3PKmv8bsE/wSyOqqGU00rBwm1UAnrvAWjwE9XojVcrFjEZ6/u7mqh11bOztOjyknqDNxHKjpRxyVarx1UTZ/ced5CLYgA6p3Gj66rXongOpRYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VsQtuuoS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VsQtuuoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B001F000FF;
	Wed, 23 Sep 2026 07:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790147494;
	bh=tNyukpwEhoxMwMyIrbWbSTm0cphWY8fkKS4O0m0X19c=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=VsQtuuoScJTIqyMCsvQRRDcV52X6IiQAM8HzaRuqFSePil3tabuKF0cgHYQG8xAC9
	 tux/E+s9CrxfUtuCkRFTWsY24PyoiwpwAK5+JWd8jUx9DR3L3T6eGCtNOEO3vcSj86
	 B+IaApru1bInRmgybkF/ZQq8UOfzcL4pg0yPmEBq2aHD9DTlrA5su9JK+q/nbTLtjB
	 DKT67qQjPWniBFnxCgVaUpXWJX3F5EmuJYyhHMsFkwDlbq9SUpLgPmRsm9/QOK8LtJ
	 F802mHflAMjFc0VLXNqkpoEvtPYRHFo7imWLxxZe/sJNayFKgB5J+jyTU7vPAurTXj
	 FX05aWCwoq6OQ==
Subject: Re: [PATCH net-next v5 02/12] net/rds: free every path's transport
 data on the passive create paths
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Wed, 23 Sep 2026 07:11:33 +0000
Message-ID: <179014749356.2160803.6655240720808313063@kernel.org>
In-Reply-To: <20260919061149.250658-3-achender@kernel.org>
References: <20260919061149.250658-3-achender@kernel.org>
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
issue(s) to consider.

Critical: 0 · High: 0 (1) · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] Commit message misstates reachability: the passive-create exit
  changed by this patch can never run with npaths > 1, so the advertised…

Pre-existing issues:
- [High] Per-path workqueue leak from the create-vs-destroy npaths
  asymmetry that this patch generalizes on the create side but leaves…

--

net/rds: free every path's transport data on the passive create paths

This moves the per-path cp_transport_data free loop from the
lost-creation-race exit of __rds_conn_create() into a new helper,
rds_conn_free_transport_data(), and calls that helper from the
passive-connection exit as well as the race exit.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index b6c4beb50eaf..a96569a3ee9a 100644
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
This isn't a bug introduced by this patch, but while looking at the
create-side npaths handling that this helper generalizes, the teardown side
looks asymmetric for the same reason.

__rds_conn_create() computes npaths from the caller's transport, before
trans can be swapped:

	int npaths = (trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
	...
		if (trans->t_prefer_loopback) {
			if (likely(is_outgoing)) {
				trans = &rds_loop_transport;
	...
	conn->c_trans = trans;

	for (i = 0; i < npaths; i++) {
		...
		conn->c_path[i].cp_wq =
			alloc_ordered_workqueue("krds_cp_wq#%d/%d", 0, seq, i);

So a conn created with trans == rds_tcp_transport (t_mp_capable, npaths ==
RDS_MPATH_WORKERS) but whose c_trans ends up as rds_loop_transport has a
workqueue on every one of the 8 paths.

rds_conn_destroy() then recomputes the bound from the stored transport:

	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);

which is 1 for rds_loop_transport, so c_path[1..7] are never passed to
rds_conn_path_destroy() before kfree(conn->c_path).  Does this leak the
ordered workqueues allocated for paths 1..7 on every loopback connection
teardown, for example when rds_loop_kill_conns() runs on netns exit?

There also looks to be a second obstacle even if the destroy bound were
widened, since rds_conn_path_destroy() returns before it reaches the
workqueue release:

	static void rds_conn_path_destroy(struct rds_conn_path *cp)
	{
		struct rds_message *rm, *rtmp;

		if (!cp->cp_transport_data)
			return;
	...
		if (cp->cp_wq != rds_wq)
			destroy_workqueue(cp->cp_wq);

rds_loop_conn_alloc() only sets c_path[0].cp_transport_data (through the
c_transport_data macro), so paths 1..7 hold a workqueue and no transport
data.  Should that early return move below the cp_wq teardown?

The same pattern appears later in the series, in rds_conn_destroy_fini()
and rds_conn_path_free() at 9157f3187071.

>  /*
>   * There is only every one 'conn' for a given pair of addresses in the
>   * system at a time.  They contain messages to be retransmitted and so
> @@ -316,7 +332,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
>  	if (parent) {
>  		/* Creating passive conn */
>  		if (parent->c_passive) {
> -			trans->conn_free(conn->c_path[0].cp_transport_data);
> +			rds_conn_free_transport_data(conn, npaths);

[Severity: Medium]
Can npaths ever be greater than 1 at this exit?

The commit message says:

    The passive-connection exit right above it, taken when a loopback
    parent already has its c_passive twin, frees only path 0 and leaks
    the transport data of paths 1..npaths-1.  RDS/TCP loopback is
    exactly a multipath passive connection, so this is reachable.

npaths comes only from the caller's transport:

	int npaths = (trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);

and t_mp_capable = 1 is set only by rds_tcp_transport in net/rds/tcp.c.

parent is set only here:

	conn = rds_conn_lookup(net, head, laddr, faddr, trans, tos, dev_if);
	if (conn &&
	    conn->c_loopback &&
	    conn->c_trans != &rds_loop_transport &&
	    ipv6_addr_equal(laddr, faddr) &&
	    !is_outgoing) {
		parent = conn;

rds_conn_lookup() additionally requires conn->c_trans == trans, so the
parent's transport is the same transport that produced npaths.

c_loopback = 1 is assigned in exactly one place, and since
rds_tcp_transport sets t_prefer_loopback = 1 that block either swaps trans
for &rds_loop_transport (is_outgoing), which the parent test excludes and
which a lookup with trans == tcp cannot match, or bails out with
-EOPNOTSUPP (!is_outgoing) before any conn is installed:

		conn->c_loopback = 1;
		if (trans->t_prefer_loopback) {
			if (likely(is_outgoing)) {
				trans = &rds_loop_transport;
			} else {
				...
				conn = ERR_PTR(-EOPNOTSUPP);

That seems to leave only a non-prefer-loopback transport (IB, which does not
set t_mp_capable) able to reach the parent branch, i.e. npaths == 1, where
the previous single free of c_path[0].cp_transport_data already covered
everything.

The in-tree incoming TCP path also rejects a local peer before
rds_conn_create() is reached:

	net/rds/tcp_listen.c:rds_tcp_accept_one() {
		if (!rds_tcp_laddr_check(sock_net(listen_sock->sk), peer_addr, dev_if)) {
			/* local address connection is only allowed via loopback */
			ret = -EOPNOTSUPP;

If that analysis holds, the new loop is a no-op on the reachable passive
path.  Should the changelog and the Fixes: 1c5113cf796b tag be adjusted so
this is described as consolidation rather than a memory leak fix, to avoid
an unnecessary stable backport?

>  			free_cp = conn->c_path;
>  			kmem_cache_free(rds_conn_slab, conn);
>  			conn = parent->c_passive;

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260919061149.250658-1-achender%40kernel.org
