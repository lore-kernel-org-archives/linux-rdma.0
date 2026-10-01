Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90EF4825D2;
	Thu,  1 Oct 2026 06:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790835376; cv=none; b=cPjXX45z5akydQ1YjMt/LPdzDfp2canijhSILq4xYy143WTWak+0r5tXIcebddt0dvQqt6D73SGPErHBVHqogNWcnxo1aNm2n15lvQ60vvLCkuixf/dn2e95DBi0NmBqrKUk9RZ03OTyVlR3oOkj/BoqaIyzuwu9icO997eGfqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790835376; c=relaxed/simple;
	bh=RzWMrx3ihKEdXI7wMaY87M9MebLkf3hfhPYhzrPmWS0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QolOhKrDluL8v38u/OkVRn+VvjAvz+lvMpzQ8gbxWW+yxxcC0c3wRhYRuVlElFHOSmBhSvjJNx9u/c1xUoh472yyFY5stWWPsYbc2ufeZMqf+X3RYflj8P0HIj/+PbOwsSFSsaNFT/WHeL7iyAULTIerMXo14xm2d+h+MdFhy/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cbkbw5yv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cbkbw5yv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC901F000FF;
	Thu,  1 Oct 2026 06:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790835374;
	bh=baq5mSQfIzOvx05EcvwaDNlkBOXQbfXWy20asSPxGho=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Cbkbw5yvgVOx6vEqhZD5+POVdEdgWm7ngHcfXSZ3XJlIizR836hrPj2qDlbOzGEcn
	 4iczfFacAzXGxIZGkA7gDGDAvWRXCy7Zk8xJZu6VJSKfLZ82fNb3V/rTmFtp0yuPV3
	 YyR+IF/WNRQ8Z6XYdH924zLo6Yp2SpCg5bglRZ7+TScVspynsoCMeuW8ArKTli6Gth
	 gmFbZIU+NdDlyFVdKLk+fTVXZGc/ewi4Bhlj5L33pTfi88axV8iPs7VmiMBRnLHTaW
	 NQhCv05b15UdMxuawDDAtAGelQ+q5Id3YiyF4Lc5DIy2kiYTrC5ovp/ME9TIAGohqC
	 v0yO/RekwF34g==
Subject: Re: [PATCH net-next v7 10/12] net/rds: hold connection references in
 lookup, sockets and c_passive
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Thu, 01 Oct 2026 06:16:14 +0000
Message-ID: <179083537402.434549.13318345829356882517@kernel.org>
In-Reply-To: <20260927061448.167862-11-achender@kernel.org>
References: <20260927061448.167862-11-achender@kernel.org>
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

- [Low] Two new comments in net/rds do not match the c_passive code in
  __rds_conn_create().
- [Low] The commit message lists "a cache that no longer sticks to a
  quiesced connection" as something the reference "buys today".
- [Low] The updated rs_lock comment in struct rds_sock
  (net/rds/rds.h:693-695) says rs_lock protects "rs_conn and rs_tos…
- [Low] The rds_conn_destroy() comment (connection.c:794-797) still says
  "With the initial reference the only one, as it is at this point in…
- [Low] rds_sendmsg() reads rs->rs_tos without rs_lock, as
  READ_ONCE(rs->rs_tos), for the rds_conn_create_outgoing() call…

Pre-existing issues:
- [Medium] This problem wasn't introduced by this patch, but the patch
  rewrites the affected code.

--

net/rds: hold connection references in lookup, sockets and c_passive

This patch makes rds_conn_lookup() and __rds_conn_create() return
referenced connections. It also makes the rs->rs_conn sendmsg cache and
parent->c_passive own references, and serializes rs_conn and the ToS
ioctls under rs_lock. c_passive becomes an RCU-annotated pointer, and the
rs_lock serialization addresses a syzbot KCSAN report on rs->rs_conn.

Closes: https://syzkaller.appspot.com/bug?extid=879c1877016972360186

> No destroy trigger in this tree - netns teardown, module unload -
> can run while a socket is still sending, since a socket holds its
> netns and pins its transport module; what the reference buys today
> is the data race fix below and a cache that no longer sticks to a
> quiesced connection, and it is the discipline the later patches
> rely on.

[Severity: Low]

Does the patch really give "a cache that no longer sticks to a quiesced
connection" today? If no destroy trigger can run while the socket exists,
this new branch in rds_sendmsg() does not look reachable for user sockets
in this tree:

    if (conn && rds_destroy_pending(conn)) {
        ...
        rs->rs_conn = NULL;

rds_conn_destroy() is only called from three places:

    rds_ib_destroy_nodev_conns() (module exit)
    rds_tcp_kill_sock(), via rds_tcp_exit_net()
    the loop gather/destroy path

t_unloading is only set at module exit.

The cached conn's netns is sock_net(sk), which sk_alloc() pins. Its
c_trans is either the socket's pinned rs_transport or rds_loop_transport.

Could the commit message say that today the only benefit is the rs_lock
serialization that closes the KCSAN report?

> diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
> index d5defe9172e36..1cc20b5cfd213 100644
> --- a/net/rds/af_rds.c
> +++ b/net/rds/af_rds.c

[ ... ]

> @@ -267,18 +276,23 @@ static int rds_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
>  		else
>  			return -ENOIOCTLCMD;
>  
> -		spin_lock_bh(&rds_sock_lock);
> +		/* rs_conn is serialized by rs_lock (see rds_sendmsg());
> +		 * hold it across the "no connection yet" check and the
> +		 * rs_tos store so a racing sendmsg cannot cache a conn
> +		 * whose c_tos then disagrees with rs_tos.
> +		 */
> +		spin_lock_irqsave(&rs->rs_lock, flags);
>  		if (rs->rs_tos || rs->rs_conn) {
> -			spin_unlock_bh(&rds_sock_lock);
> +			spin_unlock_irqrestore(&rs->rs_lock, flags);
>  			return -EINVAL;
>  		}
>  		rs->rs_tos = tos;

[Severity: Low]

rds_sendmsg() now reads rs_tos without rs_lock:

    conn = rds_conn_create_outgoing(sock_net(sock->sk),
                                    &rs->rs_bound_addr, &daddr,
                                    rs->rs_transport,
                                    READ_ONCE(rs->rs_tos),
                                    ...

Taking rs_lock here does not exclude that lockless reader. Should this
store be WRITE_ONCE(rs->rs_tos, tos) to pair with the READ_ONCE()?

The race needs a concurrent sendmsg (with rs_conn still NULL) and a
SIOCRDSSETTOS on the same socket. KCSAN with
CONFIG_KCSAN_ASSUME_PLAIN_WRITES_ATOMIC=n would report it. The c_tos
re-check under rs_lock stops a wrong ToS from being cached, so only the
annotation is missing.

> -		spin_unlock_bh(&rds_sock_lock);
> +		spin_unlock_irqrestore(&rs->rs_lock, flags);
>  		break;

[ ... ]

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index 1d7932cac0358..960fc5732c6e6 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c

[ ... ]

> @@ -697,6 +769,9 @@ EXPORT_SYMBOL_GPL(rds_conn_put);
>  void rds_conn_destroy(struct rds_connection *conn)
>  {
>  	int i;
> +	struct rds_connection *passive, *parent;
> +	struct hlist_head *head;
> +	bool was_passive = false;
>  	struct rds_conn_path *cp;
>  	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
>  

[Severity: Low]

This isn't a bug, but the existing comment further down in
rds_conn_destroy() still says:

    * can never be quiesced twice.  (With the initial reference the
    * only one, as it is at this point in the series, nothing can
    * reach a second call yet; this is the contract the following
    * patches rely on.)

After this patch, rds_conn_lookup() and __rds_conn_create() hand out
references, and rs->rs_conn and parent->c_passive each own one.
rds_incoming already held one.

Should the "initial reference the only one" wording be updated, since a
conn can now outlive its destroy while other holders keep it?

The "nothing can reach a second call yet" part still seems correct.
rds_ib_destroy_nodev_conns() marks swept nodes i_ib_node_detached and
unlinks them before it calls rds_conn_destroy().

[ ... ]

> diff --git a/net/rds/rds.h b/net/rds/rds.h
> index 84c5f76508177..04e5852697b2c 100644
> --- a/net/rds/rds.h
> +++ b/net/rds/rds.h
> @@ -156,7 +156,10 @@ struct rds_connection {
>  	/* Set once, by rds_conn_destroy() under rds_conn_lock - a
>  	 * test-and-set, so a second destroy of the same connection
>  	 * returns at once - before it cancels the path works.  Read
> -	 * through rds_destroy_pending().  A site that arms
> +	 * through rds_destroy_pending(), which also reports netns
> +	 * teardown and module unload; the c_passive handling reads the
> +	 * flag directly, since only this connection's own destroy
> +	 * matters there.  A site that arms

[Severity: Low]

Does the c_passive handling read the flag directly? All three c_passive
checks in __rds_conn_create() go through rds_destroy_pending():

    conn = rcu_dereference(parent->c_passive);
    if (conn && rds_destroy_pending(conn))
        conn = NULL;
    ...
    if (rds_destroy_pending(parent)) {
    ...
    if (rds_destroy_pending(passive)) {

rds_destroy_pending() also returns true for !check_net() and for
t_unloading, which this comment says do not matter there.

The new comment in rds_conn_destroy() makes the same claim: "refuses to
install a new one once c_destroy_in_prog is set, which it checks under
this lock".

There is a second mismatch. The comment on the locked branch in
__rds_conn_create() describes a state that does not seem possible:

    if (rds_destroy_pending(passive)) {
        /* Its destroy will clear the parent's
         * pointer under this lock shortly; until
         * then there is no usable passive conn.
         */

rds_conn_destroy() sets c_destroy_in_prog and clears parent->c_passive in
the same rds_conn_lock critical section. So, under that lock, a passive
still stored in parent->c_passive never has c_destroy_in_prog set.

Is rds_destroy_pending(passive) only ever true here because of netns
teardown or unload? If so, the rds_destroy_pending(parent) check just
above would already have caught those cases.

Could the comments or the checks be changed so the two agree?

[ ... ]

> @@ -684,7 +690,9 @@ struct rds_sock {
>  	/* seen congestion (ENOBUFS) when sending? */
>  	int			rs_seen_congestion;
>  
> -	/* rs_lock protects all these adjacent members before the newline */
> +	/* rs_lock protects all these adjacent members before the newline,
> +	 * as well as rs_conn and rs_tos above
> +	 */

[Severity: Low]

This isn't a bug, but rs_tos is not above rs_lock. It is the last member
of struct rds_sock, after rs_zcookie_queue.

Also, rds_sendmsg() reads rs_tos without rs_lock, via
READ_ONCE(rs->rs_tos), when it calls rds_conn_create_outgoing(). Could
the comment mention that exception?

[ ... ]

> diff --git a/net/rds/send.c b/net/rds/send.c
> index 7235974343dda..bedcd8b836f66 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c

[ ... ]

> +	spin_lock_irqsave(&rs->rs_lock, flags);
> +	conn = rs->rs_conn;
> +	if (conn && rds_destroy_pending(conn)) {
> +		/* drop the cache's reference right here, or the socket
> +		 * would pin the quiesced connection until it is closed
> +		 */
> +		rs->rs_conn = NULL;
> +		spin_unlock_irqrestore(&rs->rs_lock, flags);
> +		rds_conn_put(conn);
> +		conn = NULL;
>  	} else {
> +		if (conn && ipv6_addr_equal(&conn->c_faddr, &daddr) &&
> +		    rs->rs_tos == conn->c_tos)
> +			rds_conn_get(conn);

[Severity: Medium]

This isn't a bug introduced by this patch, but the test is being
rewritten here anyway. Should the cache hit also compare conn->c_dev_if
against scope_id?

Take a socket bound to a non-link-local IPv6 address, so
rs_bound_scope_id == 0. The earlier scope check in rds_sendmsg() then
allows explicit sends with any nonzero sin6_scope_id:

    if (scope_id != rs->rs_bound_scope_id) {
        if (!scope_id) {
            scope_id = rs->rs_bound_scope_id;
        } else if (rs->rs_bound_scope_id) {

A send to fe80::1%A creates and caches a conn with c_dev_if = A.

A later send to fe80::1%B matches here on c_faddr and c_tos alone and
reuses that conn. This skips rds_conn_lookup(), which does key on
c_dev_if.

The transport then uses conn->c_dev_if as the destination scope, for
example in rds_tcp_conn_path_connect():

    sin6.sin6_scope_id = conn->c_dev_if;

Could the message meant for the peer on link B then be delivered to a
different host at fe80::1 on link A?

Adding conn->c_dev_if == scope_id to this test should avoid that. The
baseline predicate had the same gap.

> +		else
> +			conn = NULL;
> +		spin_unlock_irqrestore(&rs->rs_lock, flags);
> +	}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927061448.167862-1-achender%40kernel.org
