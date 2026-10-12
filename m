Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD182390C85;
	Mon, 12 Oct 2026 03:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791776209; cv=none; b=ZYsiMy1VzyXC/P/1vcymHJdFJemkSizRDuPA4Cz6pkZq5TNbQIqKKi7tRYpxfxX81FnxLBM8m5s4oekfZf1GEYaqgARb60HLhlCQUu6FtOJYzrYwj22HaQxxJ0ZPFwl0ozRDURzZgxQdeRLzLubV4o3s7q7BuszrXoJoXW8T6vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791776209; c=relaxed/simple;
	bh=RaIS4K4eD/k3PSU1VMev4OZ6uBj715eqdXJwB+GBSYk=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sGBUYCxpxyqIwR7S/CfIAulWKXTdDC3TQvkr/46UhAXywgCCY9LsTYkcAvh06seCdOAFHRqrWq09K8M+dLQVOuJoWEkYKT+cnkWKebnksr39n636A85BU9Jsg9vbqW3fR9xbStil07c9UWi2a1N0wdsYuasEbka1+oDHB/AE+PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L9mdNHXs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L9mdNHXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105EB1F0089B;
	Mon, 12 Oct 2026 03:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791776207;
	bh=KXZcZAyAqxrfCGqEWM1ZFKc6NFfrGE9kbPKdBDXLd4U=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=L9mdNHXsZ15Th+N19Fl798cP28Ik7M6o/kaM+f1+wKgWT7ufNy/H7r4uJxehh56KB
	 GnxJ3+QAVIip6L5jXR7iaUPZPEQX/QC7upfA+B6Iq1z1+aLir/5Bzb91um2XsfUTPU
	 lNjRFAbxpCBIBf2rwStIUevYFOAGtWHZM5PYPSkj7k8jddUo1mGUXe/HzJxaGDtOp+
	 +asf8vo2UT8b6yZBvqrVF5Y55XIOhdEeNQF8uDrohvJQ9CqXOdIxLKTP9rb9SbPok2
	 PqHKKvC5O/QfyxMW2STeNFqXBfKu70BD39kGb9olGF7RJEgQormzdQWdNN0JK53UmM
	 w7whEetVTmrWA==
Subject: Re: [PATCH net v4 1/2] net/rds: keep the connected peer's scope id
 apart from the bound one
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Mon, 12 Oct 2026 03:36:46 +0000
Message-ID: <179177620650.434549.17283279919489983910@kernel.org>
In-Reply-To: <20261008031426.1142344-2-achender@kernel.org>
References: <20261008031426.1142344-2-achender@kernel.org>
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

Critical: 0 · High: 0 · Medium: 1 · Low: 1 (2)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] rds_recvmsg() (net/rds/recv.c:792-793) now sets the IPv6
  source sockaddr's sin6_scope_id from socket state:…
- [Low] After this patch, getpeername() and recvmsg() can report
  different sin6_scope_id values for the same connected peer.

Pre-existing issues:
- [Low] Baseline decision: discarded as a pre-existing Low issue.
- [Low] Baseline decision: discarded as a pre-existing, explicitly
  accepted race.

--

net/rds: keep the connected peer's scope id apart from the bound one

This patch adds rs_conn_scope_id to struct rds_sock. rds_connect() now
stores the link-local peer's scope there instead of overloading
rs_bound_scope_id. The rds_bind() check, the destination-less send,
getpeername() and recvmsg() are updated to use the new field.

> diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
> index d5defe9172e36..e84d00bbe9a15 100644
> --- a/net/rds/af_rds.c
> +++ b/net/rds/af_rds.c
> @@ -136,8 +136,7 @@ static int rds_getname(struct socket *sock, struct sockaddr *uaddr,
>  			sin6->sin6_port = rs->rs_conn_port;
>  			sin6->sin6_addr = rs->rs_conn_addr;
>  			sin6->sin6_flowinfo = 0;
> -			/* scope_id is the same as in the bound address. */
> -			sin6->sin6_scope_id = rs->rs_bound_scope_id;
> +			sin6->sin6_scope_id = rs->rs_conn_scope_id;

[Severity: Low]
This isn't a bug introduced by this patch, but rds_connect() writes
rs_conn_scope_id under lock_sock(). This line and rds_recvmsg() read it
without the lock. Could a concurrent connect() hand back an old
address with a new scope?

The same race was already there with rs_bound_scope_id, and
rds_getname() already starts with "racey, don't care". The field is an
aligned u32, so reads can't tear. Adding READ_ONCE()/WRITE_ONCE()
would only silence KCSAN, if that is wanted.

>  			uaddr_len = sizeof(*sin6);
>  		}
>  	} else {

[ ... ]

> diff --git a/net/rds/recv.c b/net/rds/recv.c
> index 6204e577a90ae..9d81c76320ea7 100644
> --- a/net/rds/recv.c
> +++ b/net/rds/recv.c
> @@ -789,7 +789,8 @@ int rds_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>  				sin6->sin6_port = inc->i_hdr.h_sport;
>  				sin6->sin6_addr = inc->i_saddr;
>  				sin6->sin6_flowinfo = 0;
> -				sin6->sin6_scope_id = rs->rs_bound_scope_id;
> +				sin6->sin6_scope_id = rs->rs_conn_scope_id ?:
> +						      rs->rs_bound_scope_id;

[Severity: Medium]
Can this report the wrong scope for senders other than the connected
peer?

connect() doesn't filter incoming traffic. rds_recv_incoming() picks
the socket by local address, port and c_bound_if only:

net/rds/recv.c:rds_recv_incoming() {
    ...
	rs = rds_find_bound(daddr, inc->i_hdr.h_dport, conn->c_bound_if);
    ...
}

__rds_conn_create() sets c_bound_if to 0 when the local address is not
link-local:

	if (ipv6_addr_type(laddr) & IPV6_ADDR_LINKLOCAL)
		conn->c_bound_if = dev_if;
	else
		conn->c_bound_if = 0;

So a connected socket bound to a global address receives from every
peer on every interface.

Take connect(fe80::x%ifA) followed by bind(2001:db8::a). Before this
patch, bind() overwrote rs_bound_scope_id with 0, so recvmsg reported
scope 0. Now rs_conn_scope_id stays at ifA, and every IPv6 sender is
reported with scope ifA.

That includes global senders. It also includes a link-local sender
fe80::z whose connection arrived on ifB. rds_tcp_accept_one() takes
c_dev_if from sk_bound_dev_if, which is the incoming interface for a
link-local peer.

Suppose the application replies with sendto(fe80::z%ifA).
rds_sendmsg() takes scope_id = ifA. This check passes because
rs_bound_scope_id is 0:

		if (scope_id != rs->rs_bound_scope_id) {
			if (!scope_id) {
				scope_id = rs->rs_bound_scope_id;
			} else if (rs->rs_bound_scope_id) {
				...
				ret = -EINVAL;

rds_conn_create_outgoing(..., ifA) then sends the reply out the wrong
link. It either sits on a connection that never comes up, or reaches
whatever host owns fe80::z on ifA. Before the patch, the equivalent
sendto(fe80::z%0) failed with -EINVAL.

The commit message says:

  recvmsg() reports a sender with the connected peer's scope when there
  is one and the bound scope otherwise, as before.

Does that hold for the connect-then-bind order?

Could the scope come from the connection the message arrived on
instead? That would be inc->i_conn->c_dev_if for a link-local sender
and 0 otherwise. inc->i_conn is already dereferenced a few lines
earlier for inc_copy_to_user().

[Severity: Low]
Can getpeername() and recvmsg() now report different scopes for the
same connected peer?

rds_getname() with peer set reports only rs_conn_scope_id. This line
falls back to rs_bound_scope_id. Take bind(fe80::l%ifC) followed by
connect(2001::p). rs_conn_scope_id is 0 and rs_bound_scope_id is ifC:

  getpeername()  -> 2001::p, scope 0
  recvfrom()     -> 2001::p, scope ifC

Before the patch both read rs_bound_scope_id and agreed (ifC).
Userspace that compares the full sockaddr_in6 from getpeername() and
recvfrom() to spot datagrams from its connected peer will now see a
mismatch.

The getpeername() value follows the inet6_getname() convention of 0
for a global address. The bound-scope fallback in recvmsg is the odd
one out. Taking the scope from the sender, as suggested above, would
fix this too.

>  				msg->msg_namelen = sizeof(*sin6);
>  			}
>  		}
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
> +		release_sock(sk);

[Severity: Low]
This is a pre-existing issue, but does the new comment still hold if
bind() runs between the two lock_sock() sections?

scope_id is sampled here. The lock is then dropped and taken again:

	lock_sock(sk);
	if (ipv6_addr_any(&rs->rs_bound_addr) || ipv6_addr_any(&daddr)) {
		...
	} else if (namelen != 0) {
		...
		if (scope_id != rs->rs_bound_scope_id) {

The bound-scope fixup only runs when namelen != 0. Take a socket that
is connected to a global peer but not yet bound. It calls send() with
no destination while another thread runs bind(fe80::a%ifA) in that
window.

The send then sees a bound socket but keeps scope_id = 0. It calls
rds_conn_create_outgoing() with laddr fe80::a and dev_if 0, and
rds_tcp_conn_path_connect() can't bind that address with scope 0.

The code before this patch read rs_bound_scope_id in the same first
section, so the race isn't new. Merging the two critical sections
would close it.

>  	}
>

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008031426.1142344-1-achender%40kernel.org
