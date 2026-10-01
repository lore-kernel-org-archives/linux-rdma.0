Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA3C1D5CC9;
	Thu,  1 Oct 2026 15:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790868363; cv=none; b=B0JjiEJH/T+5YM0epT+c+oGpcnSE5/htrTpkdXy4BZtI5Tflkhmti6sKx7m7HE1ufTbfS1W/fYgEb8TyCYaayhZiz6DoU4DM8eCNjDh1XkpuI28vZaBvsoEseolgtWALGC1J2p44DoqBbws4OkNjkWafzC8WSX+Fzx4HOf+lk0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790868363; c=relaxed/simple;
	bh=mE850PlUbkRqU2+QtQbZfcJulExdVzFCprBguF1FovY=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JAFwpZo2U84PP3z9/IZ9fQkabu66FQ8PsxqU5eBmdPSNvFtY7VLB7SD+UHzzoxyOV67dHGKJ4bDJyNaN/mdUGAuMjwvVqEvir2g85CaSbVr4A9GrsCh0RSrhLJFii2UPX5hb6VvYz1PO2l9oB9UhmTHkBPGr8kCrnOuXXHeO93g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ad2lsTWI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ad2lsTWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC281F000FF;
	Thu,  1 Oct 2026 15:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790868361;
	bh=4WPGTgmCeScvSlB2C/WkVqK6AUTVDR0VNkdPQbgxSSM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ad2lsTWIkdRnkwIVXQ5CIavUc09w4Q1IzJp9l6QBgy0Oajf5tiOvzR2mrWAH5c6Zy
	 WMfAoac0CQ1wo2xiuUoMtKzlyZX5atlY5U9+gJbTRkjkHS9fAd5M/S8EN8jfX6Tg33
	 W7Qf1XBwJOBAgG1splWezpb18wyBlRSX1j/4fbeX5QjqGtXF/oj9bnH5jcE6ZqM8gk
	 hqlhhtNetY4pciYQyD3+dK0YswmgO15Y6M4UETfDE2sKkBKeUHF+BDAmjKdCpVSYmp
	 /BZnceFttnZvck6mgcXPKItrYyINoX9ehpaTc1MwkO2e83lXVBD7eCU2kCMnt8rCcP
	 t9ozzqDJx+HEQ==
Subject: Re: [PATCH net v2] net/rds: include the scope id in the sendmsg
 connection cache check
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Thu, 01 Oct 2026 15:26:00 +0000
Message-ID: <179086836088.434549.278915211038591601@kernel.org>
In-Reply-To: <20260927062312.169097-1-achender@kernel.org>
References: <20260927062312.169097-1-achender@kernel.org>
X-sashiko-severity: High
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

Critical: 0 · High: 1 · Medium: 1 (1) · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The `!scope_id ||` wildcard added to the rs_conn cache test in
  rds_sendmsg() (net/rds/send.c:1344-1347) leaves the bug this patch…
- [Medium] The new `c_dev_if == scope_id` comparison in rds_sendmsg()
  (net/rds/send.c:1346) also applies to non-link-local destinations,…

Pre-existing issues:
- [Medium] rds_sendmsg() reads rs->rs_conn several times in the cache
  test (send.c:1344-1347: NULL check, c_faddr, c_tos, the new c_dev_if…

--

net/rds: include the scope id in the sendmsg connection cache check

This commit adds a c_dev_if comparison to the rs->rs_conn cache-hit test
in rds_sendmsg(). A send to a link-local address through a different
interface then no longer reuses the cached connection. A request with a
zero scope_id still matches the cached connection whatever its c_dev_if.

> diff --git a/net/rds/send.c b/net/rds/send.c
> index 1afa981e5c06d..393898a079c1d 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -1342,7 +1342,8 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
>  	/* rds_conn_create has a spinlock that runs with IRQ off.
>  	 * Caching the conn in the socket helps a lot. */
>  	if (rs->rs_conn && ipv6_addr_equal(&rs->rs_conn->c_faddr, &daddr) &&
> -	    rs->rs_tos == rs->rs_conn->c_tos) {
> +	    rs->rs_tos == rs->rs_conn->c_tos &&
> +	    (!scope_id || rs->rs_conn->c_dev_if == scope_id)) {

[Severity: High]
Can the !scope_id short-circuit still send a connected socket's traffic
out the wrong interface?

The commit message says:

  Such a send never named an interface, so the connection
  the socket last used is the one it means

However, connect() did name one. rds_connect() stores the peer's scope in
the bound scope field:

net/rds/af_rds.c:rds_connect() {
    ...
			rs->rs_bound_scope_id = sin6->sin6_scope_id;
    ...
}

rs_bound_scope_id is a macro for rs_bound_sin6.sin6_scope_id. So a later
bind() to a global address overwrites it with 0 in rds_add_bound():

net/rds/bind.c:rds_add_bound() {
    ...
			rs->rs_bound_scope_id = scope_id;
    ...
}

Consider this sequence on an unbound socket:

  connect(fe80::x%ifB)     rs_bound_scope_id = ifB
  bind(global L)           allowed because the new scope_id is 0,
                           rs_bound_scope_id = 0
  sendto(fe80::x%ifA)      allowed because rs_bound_scope_id is 0,
                           rs_conn = conn(L, fe80::x, dev_if ifA)
  send() with no address   daddr = rs_conn_addr = fe80::x,
                           scope_id = rs_bound_scope_id = 0

The last send() passes the new test through !scope_id and reuses the ifA
connection. rds_tcp_conn_path_connect() and the IB CM code in ib_cm.c
use c_dev_if as the peer's sin6_scope_id.

Wouldn't the datagram the application addressed to fe80::x%ifB via
connect() then go out on ifA, to whichever host answers to fe80::x on
that link? That looks like the misdelivery the commit message describes.

One option is to store the connected peer's scope separately from the
bound scope and use it on the no-destination path. Would that close this
case? It would also avoid the dev_if 0 lookup, so the !scope_id wildcard
would no longer be needed.

[Severity: Medium]
Does the c_dev_if comparison also change behavior for global
destinations, where the user never supplied scope_id?

For a non-link-local daddr, scope_id is inherited from rs_bound_scope_id
earlier in rds_sendmsg():

		if (scope_id != rs->rs_bound_scope_id) {
			if (!scope_id) {
				scope_id = rs->rs_bound_scope_id;

Consider this sequence:

  bind(global L)           rs_bound_scope_id = 0
  sendto(global G)         rs_conn = conn(L, G, dev_if 0)
  connect(fe80::x%ifB)     allowed because the bound scope is 0,
                           rs_bound_scope_id = ifB
  sendto(global G)         scope_id 0 is replaced with ifB

Before this patch, the last sendto() hit the cached conn(L, G, 0). With
the patch it misses, and rds_conn_create_outgoing(..., ifB) creates a
second conn(L, G, dev_if ifB), because rds_conn_lookup() requires an
exact c_dev_if match.

dev_if has no meaning for a global address, so the result is a second
transport connection to the same peer.

Could messages already queued on the dev_if 0 connection be reordered
with later ones on the new connection?

On the peer's passive side, rds_tcp_accept_one() uses sk_bound_dev_if,
which is normally 0. Both incoming TCP connections would therefore map to
the same conn there.

The commit message says "A request without a scope keeps matching the
cached connection" but does not mention this case. Would limiting the
c_dev_if comparison to a link-local daddr avoid it?

>  		conn = rs->rs_conn;

[Severity: Medium]
This isn't a bug introduced by this patch, but rs->rs_conn is loaded
several times in this test: the NULL check, c_faddr, c_tos, now c_dev_if,
and then conn = rs->rs_conn. No socket lock is held here and there is no
READ_ONCE() snapshot, because lock_sock() was released earlier.

A concurrent rds_sendmsg() on the same socket can store a new pointer in
the else branch, also without a lock:

		rs->rs_conn = conn;

If the compiler reloads rs->rs_conn between the checks and the
assignment, could the message be queued on a connection that was never
checked against daddr, tos or scope?

This seems unlikely with current compilers. Taking a single READ_ONCE()
snapshot into a local, with WRITE_ONCE() on the store, would avoid it.
The patch adds one more load to this sequence.

>  	} else {
>  		conn = rds_conn_create_outgoing(sock_net(sock->sk),

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927062312.169097-1-achender%40kernel.org
