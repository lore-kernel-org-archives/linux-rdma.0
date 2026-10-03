Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E37849553A;
	Sat,  3 Oct 2026 16:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791045884; cv=none; b=mxw41rdnYi9tpgRt5kke8Cyu3UhBAXuKsUpPd4Fu83CS7YP/h2ByWX/UTeZ7/rIEzyRGWPS8oxKANkoNLCjGXjTBtEDdFtMb86O8DRNLaH/iprDE3EGHs9ZtCkyzcrqpiKrxxR8BIxZLx6ViIIa3lYQwonC+3B2fvGDTwwdn4eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791045884; c=relaxed/simple;
	bh=s5IaQGZ74RODjpGha2O2jmbDjZP7UTIBgMwx4/msZCg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FDYY5v7YkhV0t2ATk+CwQVb4BbK5c0n01P1uYj/vpZuJmRDSdNIywRP8Zk2VFClpXV4eNEkCm3jkjNQESuiAKQS/vxuGgF+k/ZZIM2Rgr9DZheWzRJWbMaUyB6NtWmzyAf0k6COBLJTTQNhDyUorjMVxWdlmU5kphVFy7kqfCTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UAUhaZlb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UAUhaZlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52B21F0089B;
	Sat,  3 Oct 2026 16:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045882;
	bh=FDVopPAE2+YS0/aRnX28/anexQiOUjkPIKwW7u1qcjY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=UAUhaZlbQvbv/SLVdWE3qCniUZryr8pCcTtuRz32XwflqASRuRf5AqN8kHVP1SJK8
	 cKjtoEuVGGtFYXexuC97/TkgKXSs3UCnTK9hLhMpNLHGARv+YdCgx9rIGnhT0vfRw6
	 Xfab3dC/eE/En4ZV4Pvxo5frhsBWhhKFSM2VT+oqUDfRH0u4YuF4t5On7YiAMXV3/u
	 H4j1MGlrWliPp/W43nIEPP11JXGF84EcqXFspd9GAHSe/f0DdF2cv2iZQNZseAsbmI
	 JKxxoskEdOfByjMUMUnvaDxq7jnt8w/b6pDsMXmAR2ArCKxaaYNJS94M6WrJNRq9nf
	 yEE5Hj710Ve5A==
Message-ID: <aa8bb40b1ac7882375660c8aa3853bd62767831d.camel@kernel.org>
Subject: Re: [PATCH net v2] net/rds: include the scope id in the sendmsg
 connection cache check
From: Allison Henderson <achender@kernel.org>
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com, 
	edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Sat, 03 Oct 2026 09:44:40 -0700
In-Reply-To: <179086836088.434549.278915211038591601@kernel.org>
References: <20260927062312.169097-1-achender@kernel.org>
	 <179086836088.434549.278915211038591601@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-10-01 at 15:26 +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
>=20
> Critical: 0 =C2=B7 High: 1 =C2=B7 Medium: 1 (1) =C2=B7 Low: 0
>=20
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>=20
> - [High] The `!scope_id ||` wildcard added to the rs_conn cache test in
>   rds_sendmsg() (net/rds/send.c:1344-1347) leaves the bug this patch=E2=
=80=A6
> - [Medium] The new `c_dev_if =3D=3D scope_id` comparison in rds_sendmsg()
>   (net/rds/send.c:1346) also applies to non-link-local destinations,=E2=
=80=A6
>=20
> Pre-existing issues:
> - [Medium] rds_sendmsg() reads rs->rs_conn several times in the cache
>   test (send.c:1344-1347: NULL check, c_faddr, c_tos, the new c_dev_if=E2=
=80=A6
>=20
> --
>=20
> net/rds: include the scope id in the sendmsg connection cache check
>=20
> This commit adds a c_dev_if comparison to the rs->rs_conn cache-hit test
> in rds_sendmsg(). A send to a link-local address through a different
> interface then no longer reuses the cached connection. A request with a
> zero scope_id still matches the cached connection whatever its c_dev_if.
>=20
> > diff --git a/net/rds/send.c b/net/rds/send.c
> > index 1afa981e5c06d..393898a079c1d 100644
> > --- a/net/rds/send.c
> > +++ b/net/rds/send.c
> > @@ -1342,7 +1342,8 @@ int rds_sendmsg(struct socket *sock, struct msghd=
r *msg, size_t payload_len)
> >  	/* rds_conn_create has a spinlock that runs with IRQ off.
> >  	 * Caching the conn in the socket helps a lot. */
> >  	if (rs->rs_conn && ipv6_addr_equal(&rs->rs_conn->c_faddr, &daddr) &&
> > -	    rs->rs_tos =3D=3D rs->rs_conn->c_tos) {
> > +	    rs->rs_tos =3D=3D rs->rs_conn->c_tos &&
> > +	    (!scope_id || rs->rs_conn->c_dev_if =3D=3D scope_id)) {
>=20
> [Severity: High]
> Can the !scope_id short-circuit still send a connected socket's traffic
> out the wrong interface?
>=20
> The commit message says:
>=20
>   Such a send never named an interface, so the connection
>   the socket last used is the one it means
>=20
> However, connect() did name one. rds_connect() stores the peer's scope in
> the bound scope field:
>=20
> net/rds/af_rds.c:rds_connect() {
>     ...
> 			rs->rs_bound_scope_id =3D sin6->sin6_scope_id;
>     ...
> }
>=20
> rs_bound_scope_id is a macro for rs_bound_sin6.sin6_scope_id. So a later
> bind() to a global address overwrites it with 0 in rds_add_bound():
>=20
> net/rds/bind.c:rds_add_bound() {
>     ...
> 			rs->rs_bound_scope_id =3D scope_id;
>     ...
> }
>=20
> Consider this sequence on an unbound socket:
>=20
>   connect(fe80::x%ifB)     rs_bound_scope_id =3D ifB
>   bind(global L)           allowed because the new scope_id is 0,
>                            rs_bound_scope_id =3D 0
>   sendto(fe80::x%ifA)      allowed because rs_bound_scope_id is 0,
>                            rs_conn =3D conn(L, fe80::x, dev_if ifA)
>   send() with no address   daddr =3D rs_conn_addr =3D fe80::x,
>                            scope_id =3D rs_bound_scope_id =3D 0
>=20
> The last send() passes the new test through !scope_id and reuses the ifA
> connection. rds_tcp_conn_path_connect() and the IB CM code in ib_cm.c
> use c_dev_if as the peer's sin6_scope_id.
>=20
> Wouldn't the datagram the application addressed to fe80::x%ifB via
> connect() then go out on ifA, to whichever host answers to fe80::x on
> that link? That looks like the misdelivery the commit message describes.
>=20
Yes, the wildcard traded one misdelivery for another.  I've send a v3
that gives the connected peer its own scope field as suggested.  That shoul=
d
also take care of the global-destination case in the second point as well.


> One option is to store the connected peer's scope separately from the
> bound scope and use it on the no-destination path. Would that close this
> case? It would also avoid the dev_if 0 lookup, so the !scope_id wildcard
> would no longer be needed.
>=20
> [Severity: Medium]
> Does the c_dev_if comparison also change behavior for global
> destinations, where the user never supplied scope_id?
>=20
> For a non-link-local daddr, scope_id is inherited from rs_bound_scope_id
> earlier in rds_sendmsg():
>=20
> 		if (scope_id !=3D rs->rs_bound_scope_id) {
> 			if (!scope_id) {
> 				scope_id =3D rs->rs_bound_scope_id;
>=20
> Consider this sequence:
>=20
>   bind(global L)           rs_bound_scope_id =3D 0
>   sendto(global G)         rs_conn =3D conn(L, G, dev_if 0)
>   connect(fe80::x%ifB)     allowed because the bound scope is 0,
>                            rs_bound_scope_id =3D ifB
>   sendto(global G)         scope_id 0 is replaced with ifB
>=20
> Before this patch, the last sendto() hit the cached conn(L, G, 0). With
> the patch it misses, and rds_conn_create_outgoing(..., ifB) creates a
> second conn(L, G, dev_if ifB), because rds_conn_lookup() requires an
> exact c_dev_if match.
>=20
> dev_if has no meaning for a global address, so the result is a second
> transport connection to the same peer.
>=20
> Could messages already queued on the dev_if 0 connection be reordered
> with later ones on the new connection?
>=20
> On the peer's passive side, rds_tcp_accept_one() uses sk_bound_dev_if,
> which is normally 0. Both incoming TCP connections would therefore map to
> the same conn there.
>=20
> The commit message says "A request without a scope keeps matching the
> cached connection" but does not mention this case. Would limiting the
> c_dev_if comparison to a link-local daddr avoid it?
>=20
> >  		conn =3D rs->rs_conn;
>=20
> [Severity: Medium]
> This isn't a bug introduced by this patch, but rs->rs_conn is loaded
> several times in this test: the NULL check, c_faddr, c_tos, now c_dev_if,
> and then conn =3D rs->rs_conn. No socket lock is held here and there is n=
o
> READ_ONCE() snapshot, because lock_sock() was released earlier.

Yes, but that is baseline, and I have a fix for that in the connection-life=
time
series ("net/rds: hold connection references in lookup, sockets and c_passi=
ve")
targeted to net-next.  A snapshot here would still leave the pointer
unreferenced across the test, so I'd rather not grow a net fix into a
partial copy of that.

Thanks!
Allison

>=20
> A concurrent rds_sendmsg() on the same socket can store a new pointer in
> the else branch, also without a lock:
>=20
> 		rs->rs_conn =3D conn;
>=20
> If the compiler reloads rs->rs_conn between the checks and the
> assignment, could the message be queued on a connection that was never
> checked against daddr, tos or scope?
>=20
> This seems unlikely with current compilers. Taking a single READ_ONCE()
> snapshot into a local, with WRITE_ONCE() on the store, would avoid it.
> The patch adds one more load to this sequence.
>=20
> >  	} else {
> >  		conn =3D rds_conn_create_outgoing(sock_net(sock->sk),
>=20

