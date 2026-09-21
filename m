Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFDA37E300;
	Mon, 21 Sep 2026 09:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982135; cv=none; b=b8o7jGlrERHSWiC8EovRcoxHublkLbskV0EbeJ5r6HxpWSSztJJNaGTcRhRi2ERvyQS/2Q+fsrOXxGWmkSDId+sqgyXE6pgOmfyHeYuQUgIcRPWICQvI1jdo78fvHLZFuSE9UTTRwv+ozR2WLzA4yWeU+54I1L/fgOps+z6Ftok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982135; c=relaxed/simple;
	bh=1RgA59KYYb6WBR6E+5rZPiOX7cSshd7O8gb34wA7eYg=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YS6UME9XqEAJY/Y7sXk/rp7Q1gXYZv3L/toMsSzaRUBDhHmHNbmjtKwEpoEUJ/Wg1CP1pgGoMI6sdxSVDyoJRCppPUWnyBRmgpNw28nO9HDhASPViGiFMCjAH5MB/iTHIF7izn1RzDbsbgvGQ9C5vz4CN+FNI/VaSHh6m6JfPEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hyj04kc8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hyj04kc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66E71F00898;
	Mon, 21 Sep 2026 09:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789982133;
	bh=pnVV9YtlMx/E0vseiKq5absOTkqYiXyqubPJ0iqTlug=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=hyj04kc8Tpdp5gDrXn/Sv9hmR8R+aFGZXXd5hUkSBZ7JD6NMg1Ujhenj+0uUX2FzY
	 cK+Fmph53DkwxJchjxu1cqU81JysUzK2a3+32I30mrMS0bj4GLm1QEFyyrEn2UnVKa
	 BTAd8Y/mgyGmNKoPhgym5bIuC9d69XeQlUeH765tFBk5qvJf5HR2bUSgmqyB3DXI+K
	 vPF+9TULJ2JpyymT8VogdsaG8+VOKLQ+hp/obeJaPep20ln9/AH2Qtmvi6IKkroFah
	 /TKYfF58TZYS10VHdoBtF5Q0vhCt1EMXCwRec0CHbFGsYKLtN9shx7QvjxUPlfMuei
	 7K4N2PSiPi8mA==
Subject: Re: [PATCH net-next v4 02/12] net/rds: free every path's transport
 data on the passive create paths
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Mon, 21 Sep 2026 09:15:32 +0000
Message-ID: <178998213222.2160803.16683635844722571306@kernel.org>
In-Reply-To: <20260917073958.174056-3-achender@kernel.org>
References: <20260917073958.174056-3-achender@kernel.org>
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

- [Medium] Commit message misstates reachability of the leak it claims to
  fix (and carries a Fixes: tag that will pull it into stable as a leak…

Pre-existing issues:
- [High] Create/destroy npaths disagreement leaks per-path ordered
  workqueues for loopback-substituted RDS/TCP connections.

--

net/rds: free every path's transport data on the passive create paths

This moves the per-path transport-data free loop of __rds_conn_create()
into a new helper, rds_conn_free_transport_data(), and calls it from the
passive-conn exit as well as from the lost-creation-race exit.  The
changelog describes the passive exit as leaking transport data for paths
1..npaths-1 of a multipath connection.

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

[ ... ]

> @@ -316,7 +332,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
>  	if (parent) {
>  		/* Creating passive conn */
>  		if (parent->c_passive) {
> -			trans->conn_free(conn->c_path[0].cp_transport_data);
> +			rds_conn_free_transport_data(conn, npaths);
>  			free_cp = conn->c_path;
>  			kmem_cache_free(rds_conn_slab, conn);
>  			conn = parent->c_passive;

[Severity: Medium]
Can this exit ever run with npaths > 1?

The changelog says:

    RDS/TCP loopback is exactly a multipath passive connection, so this
    is reachable.

npaths comes from the caller's transport at the top of
__rds_conn_create():

	int npaths = (trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);

and t_mp_capable is set only by rds_tcp_transport in net/rds/tcp.c.

parent is only set when the initial rds_conn_lookup() finds a conn
matching:

	if (conn &&
	    conn->c_loopback &&
	    conn->c_trans != &rds_loop_transport &&
	    ipv6_addr_equal(laddr, faddr) &&
	    !is_outgoing) {

and rds_conn_lookup() also requires conn->c_trans == trans, so the found
conn's transport is the caller's transport.

c_loopback is set in only one place, and for TCP (t_prefer_loopback == 1)
that same block either rewrites the transport or fails the request:

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

Since conn->c_trans = trans is assigned afterwards, a hashed conn with
c_loopback == 1 and c_trans == &rds_tcp_transport does not seem to exist,
which is also why the in-tree comment on that lookup says "This is a
looped back IB connection".  rds_tcp_accept_one() additionally rejects a
local peer address with -EOPNOTSUPP before reaching rds_conn_create().

If that is right, the only transport reaching this branch is IB, which
has t_mp_capable == 0, so npaths == 1 and the previous single
trans->conn_free(conn->c_path[0].cp_transport_data) already freed
everything.  Would it be more accurate to describe this as an equivalent
refactor / hardening change rather than a leak fix, and to drop the
Fixes: 1c5113cf796b tag so it is not picked up for stable as a leak fix?

[Severity: High]
This isn't a bug introduced by this patch, but while looking at how
npaths is used on these rollback paths: does the create/destroy npaths
disagreement leak the per-path ordered workqueues for loopback-substituted
RDS/TCP connections?

__rds_conn_create() computes npaths from the caller's transport (8 for
TCP), then substitutes the loop transport for an outgoing connection to a
local address:

			trans = &rds_loop_transport;
	...
	conn->c_trans = trans;

npaths is not recomputed, so the init loop still allocates a workqueue for
all 8 paths:

	for (i = 0; i < npaths; i++) {
		...
		conn->c_path[i].cp_wq =
			alloc_ordered_workqueue("krds_cp_wq#%lu/%d", 0,
						rds_conn_count, i);

rds_loop_conn_alloc() only sets conn->c_transport_data, which
rds_single_path.h maps to c_path[0].cp_transport_data, so paths 1..7 keep
cp_transport_data == NULL.

rds_conn_destroy() then recomputes npaths from conn->c_trans, which is now
the loop transport:

	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);

so only path 0 is torn down, and rds_conn_path_destroy() would skip the
rest anyway:

	if (!cp->cp_transport_data)
		return;

before it reaches destroy_workqueue(cp->cp_wq).  kfree(conn->c_path) then
drops the last pointers to the 7 remaining workqueues.

The reachable sequence looks like: an AF_RDS socket using the TCP
transport sends to a local address, rds_conn_create_outgoing() ->
__rds_conn_create() builds the loop-substituted conn with 8 workqueues,
and netns exit (rds_loop_exit_net -> rds_loop_kill_conns ->
rds_conn_destroy) or module unload leaves 7 unbound ordered workqueues per
such conn.  Distinct 127.0.0.0/8 destinations create more conns, so this
repeats.

The same shape appears at the end of the series in rds_conn_destroy_fini(),
which derives npaths from conn->c_trans, while rds_conn_path_free() still
early-returns on !cp_transport_data before destroy_workqueue().

Would it make sense to store the allocated path count on the connection
(or recompute npaths after the loop-transport substitution) so create and
destroy always agree, and to destroy cp_wq independently of
cp_transport_data?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260917073958.174056-1-achender%40kernel.org
