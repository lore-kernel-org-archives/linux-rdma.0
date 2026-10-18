Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6BF397B1C;
	Sun, 18 Oct 2026 03:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792294028; cv=none; b=CA/ucnkS7tjzP3/xP8VnAM4WNIGOBBjluEWY/2sQln2bggEY33tfPIVAcCTEy1Ge8CK2//ZBcgfzeSnHX2Kbb1LfOtLyBPZj/pt7UafROKIxH/mYb5ZupnR8mZR/iauAbFLvBHaAhJB5crLZwtNvBVf/Kw/WuG3BArk453dUF9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792294028; c=relaxed/simple;
	bh=4qBW/eAhXI8S9EJJ+INb/Wstzy0FXar2ojgqHZFgLbo=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=r4SppcczQeW4vJ+j38bcGpG4r2MH7xtrnKaPuSd38NQAbzZWeTuLGnhFAMUrqbVlk0ek5X7prwG9G22OdjppOD8tdzSBsUAWlnlgjXvW33bJgZXgpgT8QYKMMIWLsYP8ZpU79qbcS70kVgqHa0rvyw1HYvdVVH16Lx3GRznkukQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iSjqTc20; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iSjqTc20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E891F000C4;
	Sun, 18 Oct 2026 03:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792294021;
	bh=zmyBVvu4JiIs0y0s2xwxCb22u3J0cPb2ljZdZxuuBgo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=iSjqTc20OpvEYtTiK7gXee4G38ZXQOlvS9HgrDiULki7FmUgJEuurCr7dbqQ7Tn+u
	 jkhy8uhndc7br816/7aCsENrZC7q7JtlnkMZJfFecr/Zs4tYEyYpKCCPKdxhenQY9T
	 tnN9w4SSqsKJJDPAyOjtdcsYuCga26VzECQhzGoMoNVP1+z0o5JKlrv4OCopwcVYOd
	 QXw0QZPPVYJ1cSdtlHQ6ikiB2S/u4BhnfqXtLHbN2Qqi9T1FnEOhYBsR6PVrdTambi
	 c9AXNNnqxHyik7dXtPC7r1j2nsPopI37l2Z+uu74jev2AMSxmULBAZHP1IaBaKrlrn
	 CutSzP8QpmTUg==
Subject: Re: [PATCH net-next v5 1/2] net/rds: keep the connected peer's scope
 id apart from the bound one
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Sun, 18 Oct 2026 03:27:00 +0000
Message-ID: <179229402073.3135.15507555061447027446@kernel.org>
In-Reply-To: <20261017032358.2563121-2-achender@kernel.org>
References: <20261017032358.2563121-2-achender@kernel.org>
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

Critical: 0 · High: 0 · Medium: 1 (1) · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In rds_sendmsg() (net/rds/send.c), the rs_conn cache-hit test
  at this commit compares only c_faddr and c_tos.
- [Low] rds_recvmsg() (net/rds/recv.c:792-799) now reports a link-local
  sender's sin6_scope_id as inc->i_conn->c_dev_if, with the comment 'A…

Pre-existing issues:
- [Medium] rds_sendmsg() (net/rds/send.c:1256-1264) reads the scope for a
  send with no destination in one lock_sock() section and checks that…

--

net/rds: keep the connected peer's scope id apart from the bound one

This patch adds rs_conn_scope_id to struct rds_sock. With it,
rds_connect() no longer stores a link-local peer's scope in
rs_bound_scope_id. A send without a destination, getpeername() and the
connected-socket check in rds_bind() now use the connected peer's scope,
and recvmsg() takes a link-local sender's scope from the incoming
connection's c_dev_if.

[ ... ]

> diff --git a/net/rds/recv.c b/net/rds/recv.c
> index 6204e577a90ae..a036162539e5e 100644
> --- a/net/rds/recv.c
> +++ b/net/rds/recv.c
> @@ -789,7 +789,14 @@ int rds_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>  				sin6->sin6_port = inc->i_hdr.h_sport;
>  				sin6->sin6_addr = inc->i_saddr;
>  				sin6->sin6_flowinfo = 0;
> -				sin6->sin6_scope_id = rs->rs_bound_scope_id;
> +				/* A link-local sender is reached through the
> +				 * interface its connection came in on; any
> +				 * other sender has no scope.
> +				 */
> +				sin6->sin6_scope_id =
> +					(ipv6_addr_type(&inc->i_saddr) &
> +					 IPV6_ADDR_LINKLOCAL) ?
> +					inc->i_conn->c_dev_if : 0;

[Severity: Low]
Is c_dev_if always the interface the connection came in on? For RDS/TCP it
is, because the accept path takes it from the accepted socket's
sk_bound_dev_if. For RDS/IB it looks more like a guess.

In rds_ib_cm_handle_connect(), when the peer address is link-local and our
local address is global, the ifindex is looked up from our own address:

net/rds/ib_cm.c:rds_ib_cm_handle_connect() {
    ...
	} else if (ipv6_addr_type(saddr6) & IPV6_ADDR_LINKLOCAL) {
		/* Use our address to find the correct index. */
		ifindex = __rds_find_ifindex(&init_net, daddr6);
    ...
}

__rds_find_ifindex() returns the first netdev that carries that address.
The comment above it says the incoming interface of an RDMA connect
request cannot be determined.

So on the IB transport, can recvmsg() on a globally bound socket return
fe80::peer%ifX where ifX is not the peer's link?

Replies sent through RDS still look fine. A sendto() to the reported
address uses scope_id ifX, which matches the key of the incoming IB
connection, so rds_conn_lookup() returns that same connection.

What's left is that the new comment and the commit message describe
c_dev_if as the arrival interface. That only holds for TCP. Could the
comment say that for IB this is a best-effort guess?

> diff --git a/net/rds/send.c b/net/rds/send.c
> index 1afa981e5c06d..7b525a6f7eac2 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -1256,7 +1256,11 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
>  		lock_sock(sk);
>  		daddr = rs->rs_conn_addr;
>  		dport = rs->rs_conn_port;
> -		scope_id = rs->rs_bound_scope_id;
> +		/* The connected peer's scope for a link-local peer, else
> +		 * the bound scope, as an explicit send to that peer would
> +		 * compute below.
> +		 */
> +		scope_id = rs->rs_conn_scope_id ?: rs->rs_bound_scope_id;
>  		release_sock(sk);
>  	}

[Severity: Medium]
At this commit, does the rs_conn cache in rds_sendmsg() respect this
scope_id? Further down, the cache-hit test still compares only the peer
address and tos:

	if (rs->rs_conn && ipv6_addr_equal(&rs->rs_conn->c_faddr, &daddr) &&
	    rs->rs_tos == rs->rs_conn->c_tos) {
		conn = rs->rs_conn;

rds_conn_lookup(), on the other hand, treats c_dev_if as part of a
connection's identity.

This patch also makes a new sequence possible on a socket bound to a
global address:

  connect(fe80::1%ifA)
  send()
  connect(fe80::1%ifB)
  send()

Before this patch, the second connect() failed with -EINVAL, because the
first one had stored ifA in rs_bound_scope_id and rds_connect() compared
against it. Now the second connect() succeeds, and the second send() seems
to reuse the cached ifA connection instead of one for ifB.

The next patch in the series, "net/rds: include the scope id in the
sendmsg connection cache check", adds rs->rs_conn->c_dev_if == scope_id to
the cache test, so the final tree is fine. Could that patch go before this
one, so this intermediate commit doesn't send on the wrong interface?

[Severity: Medium]
This isn't a bug introduced by this patch, but the scope is read here in
one lock_sock() section, and the bound check is done in a second one:

	lock_sock(sk);
	if (ipv6_addr_any(&rs->rs_bound_addr) || ipv6_addr_any(&daddr)) {
	...
	} else if (namelen != 0) {

Could a concurrent bind() run between the two sections?

Take a socket connected to a global peer. If rds_bind()->rds_add_bound()
binds fe80::a%ifA after scope_id has already been read as 0, the send
continues with scope_id 0 against a link-local bound address. The
namelen == 0 path skips the scope reconciliation that sendto() gets.

The result would be a connection with c_dev_if 0, which the TCP transport
cannot bring up.

The baseline had the same split, with scope_id = rs->rs_bound_scope_id
read in the first section, so this patch changes neither the window nor
the outcome.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261017032358.2563121-1-achender%40kernel.org
