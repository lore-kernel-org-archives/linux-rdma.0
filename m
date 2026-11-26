Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795660562;
	b=YQW70ky2XLguqkrPYyKYzueuNaeMOLXie5Z5aUwXpwJFqcNJz/MFQs3YteZlZdqvR1ib
	 UMm/Nb23v1bPzPYKp1ETZxUT7a0MrooLiXA+QQaQiHelEw+FZgdDUUHfS2wdcnhhQdkEE
	 elm4Wxr6EzMpzyzNFqqT0woJjunRpAQW9p2YBOKOiYB7mqtPROmiWmqBdUoFH/hsvoalu
	 vOhZQWm0v0L5/pKdSQZmBsGnFau+HFhnboTuKrlvOPnpGVmpdH10opZrL7+RlYVo6/FW0
	 7QVproa5V8C6Nt4c5z4l8HgAEgyCxRZUNDOlgyG+lRasF7zLReXKr3Ys5O+o613/uXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795660562;
	h=Received:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version;
	bh=1rKrvoY3WQO5oV4QVBaww4XVV7sR5+K7sjPbv/qUi9o=;
	b=w9XgGV+mdJg0cOeQKd2lYul6BKisgFfRUGfXwHtKbbU0Qx6G3gSZUST3SXPmRp4jGfYM
	 p2oRNtBsbv4h3zHICxgSM6HqYjEZIg/BKw1GPNthiUhki1E8zstehnsKs9r/usHH9Ci8L
	 3rJuUiSOV/WmEr9RKqKAQXwU7NfsjMTTqp5AYfN9u38QLuDejltAqFTDJUNZFAjvjegl9
	 o1X4t15FFOIfVFWhFP965/Oz94trQrYrxmXdIg3pOHYqXEUZOrChjllSZtDPIH9VVqf7C
	 L0kez+jZ8W+NeBmMWlIZUiYt0EVutvZyao2GwDw3WC2PaQlSsNiA/kNydQ/BOneTG7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IGkTdedr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA79606A323;
	Thu, 26 Nov 2026 02:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IGkTdedr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F171F000C4;
	Thu, 26 Nov 2026 02:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795660561;
	bh=1rKrvoY3WQO5oV4QVBaww4XVV7sR5+K7sjPbv/qUi9o=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=IGkTdedrVudWP4QJLJp31ozslBEaGbukaqPVjdO6AEhCNhgQKEaHFK0qozgtBGpMu
	 gqO4FafGYbDI312Y4v39l4n59RDmkCq27D8fJyakbehTLKT8EL0Nmeb1Q9IMC6Kl0f
	 B1ED4G0GVBjVRi+OyFsOfTAcqUKZXe+sVYetuC9llbIu+AU71f0j+YdaC4adfQkPaB
	 upb2c7OzQkqPjUh+zYzSYeCH44UBkr1yBJ3H4xWWhut0tr9i8SDgc4dU0VDpA/Jbdl
	 ikDP7/lUqCDw2bqw9iKyQuzB0fmiyFmHxEwkciNw6+O4+cnotFIzhd/Lmi/swofRq6
	 3dXCfmvCAKwiw==
Message-ID: <d83709308a038467b3a4849d814978b84328d2bc.camel@kernel.org>
Subject: Re: [PATCH net v4] net/rds: defer CM id destruction to a workqueue
From: Allison Henderson <achender@kernel.org>
To: netdev-bot+sashiko@kernel.org, chenaibing@cmss.chinamobile.com
Cc: davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com,  horms@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org,  rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2026 19:36:00 -0700
In-Reply-To: <179544810638.3135.8411229490217638790@kernel.org>
References: <20261122145148.1250-1-chenaibing@cmss.chinamobile.com>
	 <179544810638.3135.8411229490217638790@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Mon, 2026-11-23 at 15:35 +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
>=20
> Critical: 0 =C2=B7 High: 1 =C2=B7 Medium: 2 =C2=B7 Low: 0
>=20
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>=20
> - [High] RDS_IB_MAX_PENDING_PROBES (net/rds/ib.c:399-401) is one global
>   budget of 64 for the whole system, with no per-user or per-socket=E2=80=
=A6
> - [Medium] The new temporary errors in rds_ib_laddr_check_cm()
>   (net/rds/ib.c) never reach userspace; callers read them as "this=E2=80=
=A6
> - [Medium] The commit message calls the issue a real deadlock ("falling
>   back to the synchronous destroy, which would bring the deadlock back=E2=
=80=A6
>=20
> --
>=20
> net/rds: defer CM id destruction to a workqueue
>=20
> This patch moves rdma_destroy_id() for the probe cm_id created in
> rds_ib_laddr_check_cm() onto rds_wq, so it no longer runs under
> rds_trans_sem. A global atomic counter caps pending probe ids at
> RDS_IB_MAX_PENDING_PROBES, and the address check returns -EAGAIN above
> that cap. rds_ib_exit() flushes rds_wq before the module goes away.
>=20
> Closes: https://syzkaller.appspot.com/bug?extid=3Dccdb5058c3df2d94811c
>=20
> > diff --git a/net/rds/ib.c b/net/rds/ib.c
> > index 4ea9838d090c3..c4c10e3eabced 100644
> > --- a/net/rds/ib.c
> > +++ b/net/rds/ib.c
> > @@ -391,6 +391,30 @@ static void rds6_ib_ic_info(struct socket *sock, u=
nsigned int len,
> >  }
> >  #endif
> > =20
> > +/*
> > + * Maximum number of probe cm_ids whose destruction is still pending o=
n
> > + * rds_wq.  Each of them pins a cma_dev reference and an RDMA_PS_TCP p=
ort,
> > + * so the number of in-flight probes has to be bounded.
> > + */
> > +#define RDS_IB_MAX_PENDING_PROBES	64
> > +
> > +static atomic_t rds_ib_pending_probes =3D ATOMIC_INIT(0);
>=20
> [Severity: High]
> Is one system-wide budget of 64 safe here? Nothing splits it per user or
> per socket. The only place that releases a slot is
> rds_ib_destroy_id_work(), which runs on rds_wq. That is an ordered
> single-threaded workqueue, and other RDS work shares it:
>=20
> net/rds/threads.c:rds_threads_init() {
> 	rds_wq =3D create_singlethread_workqueue("krdsd");
> 	...
> }
>=20
> The commit message only considers a bind() loop. However,
> rds_ib_laddr_check_cm() is also reached for every new connection:
>=20
> __rds_conn_create()
>   rds_trans_get_preferred(net, faddr, conn->c_dev_if)
>     rds_ib_laddr_check()
>       rds_ib_laddr_check_cm()
>=20
> That includes incoming connect requests. There,
> rds_ib_cm_handle_connect() calls rds_conn_create(&init_net, daddr6,
> saddr6, ...), and saddr6 comes from the peer's CM private data.
>=20
> rds_ib_laddr_check() skips the probe only for v4-mapped addresses that
> rds_ib_get_device() finds. Remote peers, IPv6 addresses and uncached IPv4
> addresses each hold a slot until the worker runs.
>=20
> Can one unprivileged user, or a burst of connection setup, keep
> rds_ib_pending_probes at 64 and make every other user's IB address check
> fail? Their bind() would then be moved to RDS/TCP or fail, as described
> below for the -EAGAIN return. Before this patch, one user could not
> affect another user's IB bind.
>=20
> There also seems to be a lasting effect on connections. Take a new
> connection whose faddr is local but misses the fast path. If the probe
> returns -EAGAIN and rds_tcp is not loaded, loop_trans is NULL and
> c_loopback stays 0:
>=20
> net/rds/connection.c:__rds_conn_create() {
> 	...
> 	loop_trans =3D rds_trans_get_preferred(net, faddr, conn->c_dev_if);
> 	if (loop_trans) {
> 		rds_trans_put(loop_trans);
> 		conn->c_loopback =3D 1;
> 	...
> }
>=20
> Connections are not re-evaluated later, so the looped-back IB passive
> connection split is skipped:
>=20
> 	if (conn &&
> 	    conn->c_loopback &&
> 	    conn->c_trans !=3D &rds_loop_transport &&
> 	    ipv6_addr_equal(laddr, faddr) &&
> 	    !is_outgoing) {
>=20
> Wouldn't the incoming self-connect then find the outgoing conn itself,
> and rds_ib_cm_handle_connect() reject it as a raced connect?
>=20
> The commit message mentions neither the connection creation path nor the
> shared budget.
>=20
> [ ... ]
>=20
> > @@ -411,14 +435,39 @@ static int rds_ib_laddr_check_cm(struct net *net,=
 const struct in6_addr *addr,
>=20
> [ ... ]
>=20
> >  	isv4 =3D ipv6_addr_v4mapped(addr);
> > +
> > +	/*
> > +	 * The id is destroyed from rds_wq: rds_trans_get_preferred() calls t=
his
> > +	 * function with rds_trans_sem held for reading, and rdma_destroy_id(=
)
> > +	 * takes handler_mutex, which the CM callback path acquires before
> > +	 * taking rds_trans_sem.  Reserve a pending-probe slot first, so that=
 a
> > +	 * loop of bind() calls cannot pile up ids that pin a cma_dev referen=
ce
> > +	 * and an RDMA_PS_TCP port.
> > +	 */
>=20
> [Severity: Medium]
> The commit message, which is tagged Cc: stable, says:
>=20
>     rather than falling back to the synchronous destroy, which would brin=
g
>     the deadlock back under memory pressure.
>=20
> Can that deadlock actually happen? The handler_mutex that
> rdma_destroy_id() takes here belongs to the private probe cm_id created a
> few lines below. That id has a NULL context, is only bound, is never
> listened on, and is never shared.
>=20
> On the CM callback path in the commit message, the code holds the
> listener's handler_mutex and the new conn_id's handler_mutex, not the
> probe's:
>=20
> cma_ib_req_handler()
>   rds_rdma_cm_event_handler()
>     rds_ib_cm_handle_connect()
>       rds_conn_create()
>         rds_trans_get_preferred()
>           down_read(&rds_trans_sem)
>=20
> Those are different instances of the same lock class.
>=20
> For the probe id, the events that could hold its handler_mutex reach
> rds_rdma_cm_event_handler_cmn() with conn =3D=3D NULL, and nothing is don=
e:
>=20
> 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
> 	case RDMA_CM_EVENT_ADDR_CHANGE:
> 		if (conn)
> 			rds_conn_drop(conn);
> 		break;
>=20
> That path never waits for rds_trans_sem. Both sides also take
> rds_trans_sem only for read.
>=20
> This looks like a class-level lockdep report rather than an
> instance-level deadlock. It is still worth silencing, but could the
> commit message and this comment describe it that way?
>=20
> If no real deadlock exists, is the stable backport justified? This patch
> also brings in the global probe cap and the transport fallback described
> here.

Hi Aibing,

Thanks for sticking with this through four versions.  I think the sashiko
findings are right, so we'll need to address them. And that means we might
need to change our approach. =20

Let's drop the deferral and fix the ordering in rds_trans_get_preferred()
instead.  Take the module reference under rds_trans_sem, drop the semaphore=
, and
then call ->laddr_check().  The probe goes back to being destroyed synchron=
ously,
and rds_trans_sem is no longer held when handler_mutex is taken.  Something=
 like:

        down_read(&rds_trans_sem);
        for (i =3D 0; i < RDS_TRANS_COUNT; i++) {
                trans =3D transports[i];

                if (!trans ||
                    (trans->t_owner && !try_module_get(trans->t_owner)))
                        continue;

                /* ->laddr_check() may create and destroy an rdma_cm id, wh=
ich
                 * takes rdma_cm's handler_mutex.  Don't hold rds_trans_sem
                 * across it: the module reference keeps trans alive.
                 */
                up_read(&rds_trans_sem);
                if (trans->laddr_check(net, addr, scope_id) =3D=3D 0)
                        return trans;
                rds_trans_put(trans);
                down_read(&rds_trans_sem);
        }
        up_read(&rds_trans_sem);

That will also stop calling laddr_check() on a transport whose module
is already being unloaded.  So with this, all the changes to net/rds/ib.c
can go.

For v5, lets amend the commit message to describe it as a lockdep report ca=
used
by all handler_mutex instances sharing one lock class instead of a deadlock=
.  If you
or Eduard can, please test with lockdep on rxe with both an active and a pa=
ssive
connection and make sure there are no complaints.  It shouldn't, but it wou=
ld
be nice to know if it does.

Thanks again for working on this!
Allison

pw-bot: cr

>=20
> > +	if (atomic_inc_return(&rds_ib_pending_probes) >
> > +	    RDS_IB_MAX_PENDING_PROBES) {
> > +		atomic_dec(&rds_ib_pending_probes);
> > +		return -EAGAIN;
> > +	}
> > +
> > +	w =3D kzalloc_obj(*w, GFP_KERNEL);
> > +	if (!w) {
> > +		atomic_dec(&rds_ib_pending_probes);
> > +		return -ENOMEM;
> > +	}
>=20
> [Severity: Medium]
> Does the -EAGAIN (or -ENOMEM) ever reach userspace?
> rds_trans_get_preferred() treats any non-zero laddr_check() result as
> "not this transport" and moves on to the next slot:
>=20
> net/rds/transport.c:rds_trans_get_preferred() {
> 	...
> 	for (i =3D 0; i < RDS_TRANS_COUNT; i++) {
> 		trans =3D transports[i];
>=20
> 		if (trans && (trans->laddr_check(net, addr, scope_id) =3D=3D 0) &&
> 		    (!trans->t_owner || try_module_get(trans->t_owner))) {
> 	...
> }
>=20
> RDS_TRANS_TCP comes after RDS_TRANS_IB. rds_tcp_laddr_check() returns 0
> for any RTN_LOCAL IPv4 address and for any IPv6 address that passes
> ipv6_chk_addr(), and IPoIB addresses pass both checks.
>=20
> While the cap is hit, would the following happen?
>=20
> - bind() on an IB address succeeds but selects RDS/TCP. rds_bind() then
>   stores it in rs->rs_transport for the life of the socket, so RDMA cmsgs
>   and MR registration fail later.
>=20
> - If rds_tcp is not loaded, bind() fails with -EADDRNOTAVAIL and logs
>   "load rds_tcp or rds_rdma?".
>=20
> - With SO_RDS_TRANSPORT set to IB, bind() fails with -ENOPROTOOPT:
>=20
> 	if (rs->rs_transport) {
> 		trans =3D rs->rs_transport;
> 		if (!trans->laddr_check ||
> 		    trans->laddr_check(sock_net(sock->sk),
> 				       binding_addr, scope_id) !=3D 0) {
> 			ret =3D -ENOPROTOOPT;
>=20
> So the cap doesn't seem to give the retryable back-pressure that the
> comment and commit message describe. rdma_create_id() could already fail
> with -ENOMEM and take the same fallback, but that was rare. Any user can
> now hit the cap on purpose.
>=20
> Is it intended that hitting the cap silently moves the socket to RDS/TCP?
> If so, could the commit message mention the transport switch and the
> changed errno?
>=20
> [ ... ]
>=20

