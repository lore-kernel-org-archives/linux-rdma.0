Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4892798EA;
	Sun, 27 Sep 2026 06:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790491963; cv=none; b=tu3xlGj3uRo2fOCHCV8tk40VR7ABC4EzRWZOd0Cms/anmvr8DpoK0TCd8KVwW2IyTRIRQeeUD/YzOdnENaj+yfWGfsJ91IwgREKxz4t4h4SnAS6KA19pfOx6Qj4F5wABsR5q6KKxELUKhpYn6r3v3mHCViCvAHPQuXHymgShtio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790491963; c=relaxed/simple;
	bh=8b+ba7cP0mKb9nydYGMwbkm+rjWPgC1gVlUN/XKf7aE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RjIoC6319j/BIQ4iycsOuCF/uhlOzw+AlfPAdEE4URDmd8ofrXrlqMrHW/3uJUBmNXUKT0vcqRAwXYtS1IjeN4YzPcF/Ju6GeP3VC0+1GUZN6O8BXpB/GNy1kEHcc17zvfD3HlrctCdmeye+SxhjkmmWVboFDsWCZ7m9BfzoZRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oW2+6gSt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oW2+6gSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8864A1F000FF;
	Sun, 27 Sep 2026 06:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790491961;
	bh=9BFjujG7UrM/VNu8U0Xhn89xpgrvzW5+cWnolvEyVHs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=oW2+6gStzL8UT6doSDJA+NF8/a4LlpNE3b0vq3hWx+O9TfHkDbk11l6BLTzoGoIAn
	 Vgh3quCFMyabe1WY7Oj7NF8OYRMaJhQ5vbp4tUTP0t50TR9gHz+8AUW+TcFD9jXwlK
	 +wihCbXX5sJrhNXNWqDP3PNJlXErx4OQxtF3hOoISogYQl4tML96/TecQjh+WAZlex
	 gltv9TNrGNEkMqKqN/aJfRcP2Me0RXx8EjzzhCW6Kb813XrUwJeGnIFxs6hAGCfQtd
	 7Le5r8hABIdfFkVVzpHQ1x4rwDC8efY36qhaBa7z8Pgzd2KE64k6LxX6CUoxMKb8yi
	 UPjIKBDv2kWJQ==
Message-ID: <12c79c59ff1e55fd82ce2af0b8fd1c8feff66767.camel@kernel.org>
Subject: Re: [PATCH net] net/rds: include the scope id in the sendmsg
 connection cache check
From: Allison Henderson <achender@kernel.org>
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com, 
	edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Sat, 26 Sep 2026 23:52:40 -0700
In-Reply-To: <179029759642.2160803.15910900914007089694@kernel.org>
References: <20260921215046.174745-1-achender@kernel.org>
	 <179029759642.2160803.15910900914007089694@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-09-25 at 00:53 +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
>=20
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 (1) =C2=B7 Low: 0
>=20
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>=20
> - [Medium] New regression for connected (destination-less) sends: the
>   added `rs->rs_conn->c_dev_if =3D=3D scope_id` test in rds_sendmsg()=E2=
=80=A6
>=20
> Pre-existing issues:
> - [Medium] rds_sendmsg() validates the cached connection with plain,
>   unsynchronized loads of rs->rs_conn (`rs->rs_conn &&`, `->c_faddr`,=E2=
=80=A6
>=20
> --
>=20
> net/rds: include the scope id in the sendmsg connection cache check
>=20
> The patch adds the interface index to the cached-connection test in
> rds_sendmsg(), so that a send to a link-local peer through a different
> interface no longer reuses the connection created for the first
> interface.  Two questions below about the destination-less send case and
> about the locking around the cache test.
>=20
> > diff --git a/net/rds/send.c b/net/rds/send.c
> > index 1afa981e5c06d..38b9cc9e0d20b 100644
> > --- a/net/rds/send.c
> > +++ b/net/rds/send.c
> > @@ -1342,7 +1342,8 @@ int rds_sendmsg(struct socket *sock, struct msghd=
r *msg, size_t payload_len)
> >  	/* rds_conn_create has a spinlock that runs with IRQ off.
> >  	 * Caching the conn in the socket helps a lot. */
> >  	if (rs->rs_conn && ipv6_addr_equal(&rs->rs_conn->c_faddr, &daddr) &&
> > -	    rs->rs_tos =3D=3D rs->rs_conn->c_tos) {
> > +	    rs->rs_tos =3D=3D rs->rs_conn->c_tos &&
> > +	    rs->rs_conn->c_dev_if =3D=3D scope_id) {
>=20
> [Severity: Medium]
> Should the new comparison treat scope_id =3D=3D 0 as "unspecified" rather
> than as a mismatch?
Yes, the analysis is right, I've sent a V2 that keeps the cached connection=
 when
the request names no interface and only checks c_dev_if when it does.
>=20
> For a send with msg_namelen =3D=3D 0, rds_sendmsg() takes the scope from =
the
> bound scope id:
>=20
> net/rds/send.c:rds_sendmsg() {
> 	} else {
> 		/* We only care about consistency with ->connect() */
> 		lock_sock(sk);
> 		daddr =3D rs->rs_conn_addr;
> 		dport =3D rs->rs_conn_port;
> 		scope_id =3D rs->rs_bound_scope_id;
> 		release_sock(sk);
> 	}
>=20
> and the namelen !=3D 0 repair branch that would fill in a zero scope from
> rs_bound_scope_id is skipped in that case.
>=20
> rs_bound_scope_id can be 0 while rs_conn_addr is a link-local peer.
> rds_connect() records the peer scope there for an unbound socket:
>=20
> net/rds/af_rds.c:rds_connect() {
> 		if (addr_type & IPV6_ADDR_LINKLOCAL) {
> 			...
> 			rs->rs_bound_scope_id =3D sin6->sin6_scope_id;
> 		}
> 		rs->rs_conn_addr =3D sin6->sin6_addr;
>=20
> and a later bind() to a non-link-local address overwrites it
> unconditionally:
>=20
> net/rds/bind.c:rds_add_bound() {
> 			*port =3D rs->rs_bound_port;
> 			rs->rs_bound_scope_id =3D scope_id;	/* 0 here */
>=20
> With the sequence connect(fe80::x%ifA) -> bind(global address) ->
> sendto(fe80::x%ifA) -> send() with no destination, the last send now
> computes scope_id =3D=3D 0, misses the cached ifA connection, and goes do=
wn
> the else branch:
>=20
> >  		conn =3D rs->rs_conn;
> >  	} else {
> >  		conn =3D rds_conn_create_outgoing(sock_net(sock->sk),
> > 						&rs->rs_bound_addr, &daddr,
> > 						rs->rs_transport, rs->rs_tos,
> > 						sock->sk->sk_allocation,
> > 						scope_id);
>=20
> Since rds_conn_lookup() compares c_dev_if, this creates a new connection
> with c_dev_if =3D=3D 0 for a link-local destination.  Can that connection
> ever come up?  rds_tcp_conn_path_connect() passes it on as the scope:
>=20
> net/rds/tcp_connect.c:rds_tcp_conn_path_connect() {
> 		sin6.sin6_scope_id =3D conn->c_dev_if;
>=20
> and tcp_v6_connect() rejects a link-local destination with no scope and
> no sk_bound_dev_if:
>=20
> net/ipv6/tcp_ipv6.c:tcp_v6_connect() {
> 		/* Connect to link-local address requires an interface */
> 		if (!sk->sk_bound_dev_if)
> 			return -EINVAL;
>=20
> So the message looks like it gets queued on a connection that can never
> be established, where before the patch it went out over ifA, and
> rs->rs_conn is left pointing at the new connection.  Would skipping the
> comparison when scope_id =3D=3D 0, or keeping the connected peer's scope
> separately from rs_bound_scope_id, avoid this?
>=20
> [Severity: Medium]
> This isn't a bug introduced by this patch, but the cache test reads
> rs->rs_conn several times without any synchronization, and the new
> c_dev_if comparison is one more such read.

Yes, but I'm handling that in the larger connection lifetime series=20
("net/rds: make connection lifetime reference-counted").  It=C2=A0moves
rs_conn cache under rs_lock and gives the cache a real reference.  If=20
we did the READ_ONCE() here would still leave the pointer unreferenced
across the test, so I'd rather not let this patch feature creep into
something the ref counting series is already handling.

Thanks!
Allison

pw-bot: cr
>=20
> The validation loads and thpw-bot: crpw-bot: cr
> e load used for the assignment are separate:
>=20
> net/rds/send.c:rds_sendmsg() {
> 	if (rs->rs_conn && ipv6_addr_equal(&rs->rs_conn->c_faddr, &daddr) &&
> 	    rs->rs_tos =3D=3D rs->rs_conn->c_tos &&
> 	    rs->rs_conn->c_dev_if =3D=3D scope_id) {
> 		conn =3D rs->rs_conn;
>=20
> The socket lock covering the earlier scope-id checks has already been
> dropped by the release_sock(sk) before rds_rdma_bytes(), and
> rds_sock_lock, which the RDS_TOS ioctl path takes when it inspects
> rs->rs_conn, is not held here either.  The publishing store in the else
> branch is equally unsynchronized:
>=20
> 		rs->rs_conn =3D conn;
>=20
> For two concurrent sendmsg() calls on the same AF_RDS socket (threads or
> a shared fd), can one thread validate the connection for fe80::x%ifA and
> then reload rs->rs_conn and pick up the fe80::x%ifB connection the other
> thread just stored, so that rm->m_conn_path ends up on the unvalidated
> connection?  That would be the same misrouting the changelog describes.
>=20
> Would it be worth folding in a single snapshot of the pointer, for
> example conn =3D READ_ONCE(rs->rs_conn); if (conn && ...), with a matchin=
g
> WRITE_ONCE() on the store, or holding the socket lock across the cache
> test?
>=20

