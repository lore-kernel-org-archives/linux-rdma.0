Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A204B1CE8;
	Thu, 17 Sep 2026 09:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789637948; cv=none; b=OCWu7T0O8Nn6VdtBqwLL4tKPSd94ZeBbTw6IJ8/mm3NtDFllQWDyI7smgZ4cLrh55SpIHBU0ZDFVFb1uSROUu8zpjGvOz5ApFFZ1ZKVDhCdzZVcJmeSwOkaaZD81y90C1pMJAPinHE+qFhChQyL6LSO10xRJoD5vCNBDzDDa/Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789637948; c=relaxed/simple;
	bh=7t1aGIjFxQJ/+6UfoQgKG+ngxjkZFg9Yut6beP3hM7w=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I0x2zBZr7LNUWu6DM68WwT3Kpr8bWSe/8bbP/O6+Ux+hU3dnJt7ICep4hyavEGE4f7N3cwnJc+2DB9Lvem3m7o7taH3CcQSywpWkcv0THoCi1y9CQmAuehG9iinrtib6k4zZyGmMMY0HWpE+uvfVGcWISn5XlqguO8fIgFv8uFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VxU2RXFq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VxU2RXFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DCF1F008A0;
	Thu, 17 Sep 2026 09:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789637928;
	bh=KD4seJwP7ADyeK6RK+9OyVjNFyo/kIV/jfsvwiXleMU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=VxU2RXFqfztSckTtrECIPNEs45yvSNdzZUEGMAjfjQ5oJF4naZaY9ez8Xq/hbUYds
	 TrrUmveo6MnHAfzVBYyd8R9hOQ7PjX5dhMZ/pLPkycUWEHW2E2PB9aD3e/PJ5jLpir
	 SwTdZLaMPVU9ZkcjeXdqbzkOWKqiC5QW2zSJg3nHNvw3w2yeFH6mvF4DmCeNtVpXgx
	 9USvzrp3DuZ27+7e7+sjGmEh3KwpaODLE53n0BC4wBnEh7pnsprqugbT6HA/m9WqZ8
	 Bc26gfinXMFg2TB0AOST1wua1oe/IQy/vRbko1lo3uPGLwkZWRrlSZt5/Tv0e9KpA+
	 rtmCkss6547+Q==
Subject: Re: [PATCH net-next v3 10/13] net/rds: tcp: don't attach an accepted
 socket to a connection being destroyed
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Thu, 17 Sep 2026 09:38:47 +0000
Message-ID: <178963792726.22033.11883660138204996696@kernel.org>
In-Reply-To: <20260914033719.138057-11-achender@kernel.org>
References: <20260914033719.138057-11-achender@kernel.org>
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

- [Low] Incomplete at this point in the series: the identical hole in the
  IB accept path (rds_ib_cm_handle_connect(), net/rds/ib_cm.c) is left…
- [Low] The commit message describes a present-tense use-after-free plus
  socket leak ('the next byte from the peer runs the socket callbacks…

--

net/rds: tcp: don't attach an accepted socket to a connection being destroyed

rds_tcp_accept_one() now refuses an incoming accept when the target
connection's destroy has already begun, instead of claiming a DOWN path
and installing the accepted socket on it.  The refusal reuses the existing
unexpected-path-state path: drop the path claim and reset the new socket.

> commit message

>     A connection whose destroy has begun is quiesced - its paths are DOWN
>     and its old sockets released - but stays allocated while a reference
>     holder is still around, and rds_conn_create() hands out exactly such
>     a connection with a reference of its own.

[Severity: Low]
The described reachability appears to depend on earlier patches in this
same series rather than on any released kernel.

The connection surviving its own destroy while a holder exists comes from
"net/rds: split connection destroy into quiesce and kref-governed free",
rds_conn_lookup()/__rds_conn_create() handing out a reference on such a
connection comes from "net/rds: hold connection references in lookup,
sockets and c_passive", and the c_destroy_in_prog term the new test relies
on comes from "net/rds: make rds_destroy_pending() cover single-connection
destroy":

net/rds/rds.h:rds_destroy_pending() {
	return READ_ONCE(conn->c_destroy_in_prog) ||
	       !check_net(rds_conn_net(conn)) ||
	       (conn->c_trans->t_unloading && conn->c_trans->t_unloading(conn));
}

Applied on its own to a tree without those changes, the new test reduces to
the netns and unloading cases and does not close the hole described here.

There is no Fixes: tag and no note about the in-series dependency, so the
message reads as a standalone fix.  Sibling patches in the series that
close the same class of in-series hole ("net/rds: unlink transport nodes
before a possibly deferred connection free", "net/rds: refuse to queue a
message on a connection being destroyed", "net/rds: pin the connection
across RDMA-CM event handling") also carry no Fixes: tag and no stable
note, so this matches the series convention.

Would it be worth stating in the message that the reachability is created
by earlier patches in this series, so an automatic stable pick does not
land a change that cannot achieve its stated purpose there?

> diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
> index dcac10a91a67..e22ea9ca8c1c 100644
> --- a/net/rds/tcp_listen.c
> +++ b/net/rds/tcp_listen.c
> @@ -278,7 +278,15 @@ int rds_tcp_accept_one(struct rds_tcp_net *rtn)
>  	cp = rs_tcp->t_cpath;
>  	conn_state = rds_conn_path_state(cp);
>  	WARN_ON(conn_state == RDS_CONN_UP);
> -	if (conn_state != RDS_CONN_CONNECTING && conn_state != RDS_CONN_ERROR) {
> +	/* A connection whose destroy has begun has been quiesced and is
> +	 * only waiting for its last reference: its paths sit in
> +	 * RDS_CONN_DOWN, which rds_tcp_accept_one_path() happily claims.
> +	 * Installing a socket on it would leave sk_user_data pointing
> +	 * at a path that is about to be freed.
> +	 */
> +	if (rds_destroy_pending(conn) ||
> +	    (conn_state != RDS_CONN_CONNECTING &&
> +	     conn_state != RDS_CONN_ERROR)) {
>  		rds_conn_path_drop(cp, 0);
>  		goto rst_nsk;
>  	}

[Severity: Low]
Should the IB accept path get the same guard in this commit?

rds_ib_cm_handle_connect() in net/rds/ib_cm.c reaches the same place by the
same route: it takes a connection from rds_conn_create(), makes the same
DOWN -> CONNECTING claim that a quiesced-but-still-referenced connection
satisfies, and then installs transport state on it:

net/rds/ib_cm.c:rds_ib_cm_handle_connect() {
	conn = rds_conn_create(&init_net, daddr6, saddr6,
			       &rds_ib_transport, dp_cmn->ricpc_dp_toss,
			       GFP_KERNEL, ifindex);
	...
	mutex_lock(&conn->c_cm_lock);
	if (!rds_conn_transition(conn, RDS_CONN_DOWN, RDS_CONN_CONNECTING)) {
	...
	ic->i_cm_id = cm_id;
	cm_id->context = conn;
	...
	err = rds_ib_setup_qp(conn);
}

At this commit there is no rds_destroy_pending() test anywhere in
net/rds/ib_cm.c, and the hashed rds_conn_lookup() branch of
__rds_conn_create() does not filter c_destroy_in_prog - only the c_passive
branch does:

net/rds/connection.c:__rds_conn_create() {
		conn = rcu_dereference(parent->c_passive);
		if (conn && READ_ONCE(conn->c_destroy_in_prog))
			conn = NULL;
}

So can an incoming RDMA_CM_EVENT_CONNECT_REQUEST attach a fresh cm_id and
QP to a connection that is only waiting for its last reference, leaving
cm_id->context pointing at freed memory and the QP untorn-down?

The very next patch in the series, "net/rds: pin the connection across
RDMA-CM event handling" (3e53d58bba13ea8bec2e328d358bbebdacca18ef), adds
exactly that guard under c_cm_lock:

	if (rds_destroy_pending(conn))
		goto out;

so the gap closes before the end of the series.  What remains is the
bisect window: the enabling reference behaviour arrives two patches earlier
in "net/rds: hold connection references in lookup, sockets and c_passive",
which leaves three commits where a bisect lands on a tree with the IB side
open.  Would folding the IB check in here, or reordering the two patches,
avoid that window?  A note in the message that the IB sibling is handled
separately would also help.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260914033719.138057-1-achender%40kernel.org
