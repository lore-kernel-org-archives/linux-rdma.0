Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EA5149C7B;
	Fri, 25 Sep 2026 00:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790297599; cv=none; b=lh1v2C68U+pts247Zdffd1lJ6GnwyKrsFCE5yL8PusaAtKHxQMCmnUTNDWAyFA52TCTIvNPA7cMU5XDnOnXAxDfApj96/a3OEn998deWpQYPPuzwsHN5M/7K2Ll1hBBSMYMjbXVowSU69d99OjMKW3QW1U3YQ1KmN1v/kxMu2zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790297599; c=relaxed/simple;
	bh=1w46t6igXMPVyyUPCnr+id+bi+B+LpLrqQkPVuUl/GQ=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jezUpJww8vV4wnjVJdtxp/z7S2sXelZxstC0h/ehkPhMkaNdEFenCtAdYaxqN1TJGELKl3CaXjB6CXyCiA2m1XmpqqgTqbv6TyUNVoYfEy5DohDCU1a1UMdaUZkLRBN3O31+iz3Zs8abx2qAe6GWOUiijunW5QVmfC/Uu32GqQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WrIXzM+N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WrIXzM+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38AD1F000FF;
	Fri, 25 Sep 2026 00:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790297597;
	bh=VyKhlM2rIvrgAMtSAJ/fnMFJQPZU0/xST4sWoySXSZY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=WrIXzM+NoJ98ceXhTIX+KhyO4EXq8zBJ5cvaIkE6wAYAZVPRva7s5vZL+JDFkvtRR
	 ccXnfdMLeDMFOA/v+XAYNRraAtUXpm3Zq4+xJDaJ8tlpPIuJFLwqc39K6imSSgHcqd
	 xB14R1aYd3aThPYitbDUxKMEi8Ik+19dx+Lf7RivZSKoPqYFZvkZK0kQZp1DZgWuEY
	 KGR4u1Gl58Ur1PcORl2EXYqlaO33DYApCsqKVRzfNeYv+OFUalM/uFukscQRNMz575
	 bva06zx7iBO1MAXX+tQCFX1kXxkz1gSNkFCGF7ZIdXmSPfxFHBIR35MGQvajb2KCUh
	 XtYYlgp3glPEw==
Subject: Re: [PATCH net] net/rds: include the scope id in the sendmsg
 connection cache check
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Fri, 25 Sep 2026 00:53:16 +0000
Message-ID: <179029759642.2160803.15910900914007089694@kernel.org>
In-Reply-To: <20260921215046.174745-1-achender@kernel.org>
References: <20260921215046.174745-1-achender@kernel.org>
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

Critical: 0 · High: 0 · Medium: 1 (1) · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] New regression for connected (destination-less) sends: the
  added `rs->rs_conn->c_dev_if == scope_id` test in rds_sendmsg()…

Pre-existing issues:
- [Medium] rds_sendmsg() validates the cached connection with plain,
  unsynchronized loads of rs->rs_conn (`rs->rs_conn &&`, `->c_faddr`,…

--

net/rds: include the scope id in the sendmsg connection cache check

The patch adds the interface index to the cached-connection test in
rds_sendmsg(), so that a send to a link-local peer through a different
interface no longer reuses the connection created for the first
interface.  Two questions below about the destination-less send case and
about the locking around the cache test.

> diff --git a/net/rds/send.c b/net/rds/send.c
> index 1afa981e5c06d..38b9cc9e0d20b 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -1342,7 +1342,8 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
>  	/* rds_conn_create has a spinlock that runs with IRQ off.
>  	 * Caching the conn in the socket helps a lot. */
>  	if (rs->rs_conn && ipv6_addr_equal(&rs->rs_conn->c_faddr, &daddr) &&
> -	    rs->rs_tos == rs->rs_conn->c_tos) {
> +	    rs->rs_tos == rs->rs_conn->c_tos &&
> +	    rs->rs_conn->c_dev_if == scope_id) {

[Severity: Medium]
Should the new comparison treat scope_id == 0 as "unspecified" rather
than as a mismatch?

For a send with msg_namelen == 0, rds_sendmsg() takes the scope from the
bound scope id:

net/rds/send.c:rds_sendmsg() {
	} else {
		/* We only care about consistency with ->connect() */
		lock_sock(sk);
		daddr = rs->rs_conn_addr;
		dport = rs->rs_conn_port;
		scope_id = rs->rs_bound_scope_id;
		release_sock(sk);
	}

and the namelen != 0 repair branch that would fill in a zero scope from
rs_bound_scope_id is skipped in that case.

rs_bound_scope_id can be 0 while rs_conn_addr is a link-local peer.
rds_connect() records the peer scope there for an unbound socket:

net/rds/af_rds.c:rds_connect() {
		if (addr_type & IPV6_ADDR_LINKLOCAL) {
			...
			rs->rs_bound_scope_id = sin6->sin6_scope_id;
		}
		rs->rs_conn_addr = sin6->sin6_addr;

and a later bind() to a non-link-local address overwrites it
unconditionally:

net/rds/bind.c:rds_add_bound() {
			*port = rs->rs_bound_port;
			rs->rs_bound_scope_id = scope_id;	/* 0 here */

With the sequence connect(fe80::x%ifA) -> bind(global address) ->
sendto(fe80::x%ifA) -> send() with no destination, the last send now
computes scope_id == 0, misses the cached ifA connection, and goes down
the else branch:

>  		conn = rs->rs_conn;
>  	} else {
>  		conn = rds_conn_create_outgoing(sock_net(sock->sk),
> 						&rs->rs_bound_addr, &daddr,
> 						rs->rs_transport, rs->rs_tos,
> 						sock->sk->sk_allocation,
> 						scope_id);

Since rds_conn_lookup() compares c_dev_if, this creates a new connection
with c_dev_if == 0 for a link-local destination.  Can that connection
ever come up?  rds_tcp_conn_path_connect() passes it on as the scope:

net/rds/tcp_connect.c:rds_tcp_conn_path_connect() {
		sin6.sin6_scope_id = conn->c_dev_if;

and tcp_v6_connect() rejects a link-local destination with no scope and
no sk_bound_dev_if:

net/ipv6/tcp_ipv6.c:tcp_v6_connect() {
		/* Connect to link-local address requires an interface */
		if (!sk->sk_bound_dev_if)
			return -EINVAL;

So the message looks like it gets queued on a connection that can never
be established, where before the patch it went out over ifA, and
rs->rs_conn is left pointing at the new connection.  Would skipping the
comparison when scope_id == 0, or keeping the connected peer's scope
separately from rs_bound_scope_id, avoid this?

[Severity: Medium]
This isn't a bug introduced by this patch, but the cache test reads
rs->rs_conn several times without any synchronization, and the new
c_dev_if comparison is one more such read.

The validation loads and the load used for the assignment are separate:

net/rds/send.c:rds_sendmsg() {
	if (rs->rs_conn && ipv6_addr_equal(&rs->rs_conn->c_faddr, &daddr) &&
	    rs->rs_tos == rs->rs_conn->c_tos &&
	    rs->rs_conn->c_dev_if == scope_id) {
		conn = rs->rs_conn;

The socket lock covering the earlier scope-id checks has already been
dropped by the release_sock(sk) before rds_rdma_bytes(), and
rds_sock_lock, which the RDS_TOS ioctl path takes when it inspects
rs->rs_conn, is not held here either.  The publishing store in the else
branch is equally unsynchronized:

		rs->rs_conn = conn;

For two concurrent sendmsg() calls on the same AF_RDS socket (threads or
a shared fd), can one thread validate the connection for fe80::x%ifA and
then reload rs->rs_conn and pick up the fe80::x%ifB connection the other
thread just stored, so that rm->m_conn_path ends up on the unvalidated
connection?  That would be the same misrouting the changelog describes.

Would it be worth folding in a single snapshot of the pointer, for
example conn = READ_ONCE(rs->rs_conn); if (conn && ...), with a matching
WRITE_ONCE() on the store, or holding the socket lock across the cache
test?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260921215046.174745-1-achender%40kernel.org
