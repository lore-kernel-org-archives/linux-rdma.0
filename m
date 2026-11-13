Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794544785;
	b=S3/KHMaYLMwl6Hmy0lQGFqU1nzzpF0dgm4yfIbbvYv1rf81BiRpUjvRV9zS5mZj7mWzY
	 NeKJZ/xjUAu73Mqi7T3sgTFpfuETxCtj2II2L3EuNvQXA/H7/WXiihHqUY06YZ1d/z2Lr
	 5fG+Pf69EfLSJaLQePkIbDPKo9t5vFISQysjyTiPgY9DvThBVznRjMjoPIcHL+3gQmd83
	 iApd5c9XrPL8Mw4j8cpF6G2aqTUQLvfnBpVrMYW/Gs1LW19X7FzGp+e8Eis4mnTjsJbdm
	 YOt2RVbDoPu4t3nJDLpz4k0W7pBQdgDmY6gmOMnXnmds0YX77h0mSTSVqADsv9m7nhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794544785;
	h=Received:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version;
	bh=fXGKHVaiJkSmI+q7FxtmVVmezBLhB3VGu6cDO74aKuw=;
	b=jKtJnh+ik86IoydjvvOZaD7OMWx1feYwChuVJg+kDISGaD8BtiWVUfTjY8KtVFYYABSy
	 VKvDJuAT+spsmRavIjzzjv31of2Pez/8enWQ2Bd8keeUeN2VdASbb5eTLYwutE3g/TENv
	 5KKpUIONSwKpXp88b3e/kbAGG6cENmpidV4nt4ZaFbhASIoDwcJxV3qZw6OOobZW5OMSR
	 Pm85EmCnfrhog/PIrlijoSQ4G9rycvDcAoymoGbGIz+Kys3mheN8YdMItopmZwHArPjpe
	 SUXBhvwPZOY1TcKNwyZWaib4QWFoDBjqy0tlP1XBiQYt6fPAQK76kZoDK8VkzUb5wxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AkA62sIK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57B6606A31C;
	Fri, 13 Nov 2026 04:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AkA62sIK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5611F000C4;
	Fri, 13 Nov 2026 04:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794544785;
	bh=fXGKHVaiJkSmI+q7FxtmVVmezBLhB3VGu6cDO74aKuw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=AkA62sIK9hFy/QIhwKyhnns3VeUMNfNRiFM/41Tr/DcvH19g9g9PHRbj5VYeAgl2m
	 k+11s15J1+bl7ztFpwx9UggJndE2OOBid+ZSpnGra+FV69BH61t48aDC9ngIqxGorG
	 CmGxMnEFIM7dbzxPy+ifq59XjvhqlHaYH+qrdceNoe2bNEAn2s0GL2xbbG9TvZa/dx
	 jcAXvcFM9Bw0oZ1dQ9YL/X7ChOVxONrXGMGEV3EP0U2JjUittYa2PB+E3yGO9Qu0uu
	 oKBOM4QDzkYFAYO3ub0u8gt6Dusqkpt9LRnyv7F9WDw+SLYGXEPthc18mvdFqnBsgL
	 76ZTRJo43lUlw==
Message-ID: <8b6dcadbe3bad9ae0aa512c04f1aaf42755bd575.camel@kernel.org>
Subject: Re: [PATCH net-next v11 08/12] net/rds: hold a connection reference
 from struct rds_incoming
From: Allison Henderson <achender@kernel.org>
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com, 
	edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Thu, 12 Nov 2026 21:39:44 -0700
In-Reply-To: <179431907345.994134.1298028433995703002@kernel.org>
References: <20261106031615.1047052-9-achender@kernel.org>
	 <179431907345.994134.1298028433995703002@kernel.org>
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

On Tue, 2026-11-10 at 13:57 +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
>=20
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 0
>=20
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>=20
> - [Medium] With this patch, every rds_incoming holds a reference on its
>   connection.
>=20
> --
>=20
> net/rds: hold a connection reference from struct rds_incoming
>=20
> This patch makes every holder of rds_incoming->i_conn own a connection
> reference. The references are taken in rds_inc_init(), rds_inc_path_init(=
),
> rds_recv_incoming() and the three m_inc assignment sites in send.c. They
> are dropped from rds_inc_put() and from a new rds_message_free() helper,
> which fixes a use-after-free when a transport unload destroys a connectio=
n
> that queued incs still point at.
>=20
> Closes: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.d=
ev@gmail.com/
>=20
> [ ... ]
>=20
> > diff --git a/net/rds/recv.c b/net/rds/recv.c
> > index 00ab60f2d9969..e4cae82c16818 100644
> > --- a/net/rds/recv.c
> > +++ b/net/rds/recv.c
> > @@ -46,6 +46,7 @@ void rds_inc_init(struct rds_incoming *inc, struct rd=
s_connection *conn,
> >  {
> >  	refcount_set(&inc->i_refcount, 1);
> >  	INIT_LIST_HEAD(&inc->i_item);
> > +	rds_conn_get(conn);	/* put in rds_inc_put() */
> >  	inc->i_conn =3D conn;
> >  	inc->i_conn_path =3D NULL;
> >  	inc->i_saddr =3D *saddr;
>=20
> [Severity: Medium]
> With this reference, an unread inc on a socket receive queue keeps its
> connection, and so the transport's t_conn_count, elevated until the
> application reads the datagram or closes the socket. Can that block
> rmmod of a transport forever?

Yes, but the the alternative to waiting is an unclean unload.  Without the
wait, the same sequence described above unloads rds_tcp with the inc still
queued.  Then the next rds_inc_put() calls conn->c_trans->inc_free, and for
an IB inc dereferences the freed connection which turns into a uaf.  So
waiting avoids the uaf and as well as a working unload.

Also the wait cannot be made interruptible/abortable in any way useful.
By the time rds_tcp_exit() runs, delete_module() has moved the module to
MODULE_STATE_GOING and the exit function has no way to fail. An early retur=
n
on a signal would unload over the live references, which is a UAF again.
If we purged the incs from the socket receive queues, it silently discards
datagrams that have been acknowledged to the peer from sockets nobody close=
d.=C2=A0
Not discarding queued data is the one rule the teardown in this series foll=
ows
throughout, so I would rather keep it than add a drop path for a case that
today crashes.

Finally who controls the wait is not new.  The app owning the socket ends i=
t by
reading or closing, or being killed by an admin. An unprivileged socket can
already keep the transport loaded for as long as it wants, and an rmmod sim=
ply
returns -EBUSY until the socket closes. The cross-transport case differs on=
ly in
that an inc holds no module reference, so the same hold shows up as a wait =
rather
than an immediate -EBUSY.

In any case, this complaint has come up a few times in prior reviews, and w=
e've
added commentary around it as well as a warning that prints every 10 second=
s.
I will send a v12 for the other sashiko reviews on patches 4 and 11, but I =
wanted
to explain why this review wouldnt be in it.

Thanks for the reviews!
Allison

>=20
> rds_tcp_exit() and rds_ib_exit() both call rds_conn_wait_conns_freed().
> That loop exits only when t_conn_count reaches zero:
>=20
> net/rds/connection.c:rds_conn_wait_conns_freed() {
>     ...
> 	while (!wait_event_timeout(rds_conn_freed_waitq,
> 				   !atomic_read(&trans->t_conn_count),
> 				   msecs_to_jiffies(RDS_CONN_FREE_POLL_MS))) {
>     ...
> }
>=20
> The loop never checks for signals, so nobody can kill the rmmod task, and
> the module stays in MODULE_STATE_GOING. The task wakes every 100ms, so th=
e
> hung-task detector doesn't report it either. The only sign is the pr_warn
> every 10 seconds.
>=20
> rds_find_bound() matches only on address, port and scope_id. It doesn't
> compare rs->rs_transport with conn->c_trans. A socket bound with one
> transport (through SO_RDS_TRANSPORT or rds_trans_get_preferred()) can
> therefore queue incs that arrived over another transport's connection,
> without holding a module reference on that transport:
>=20
>   unprivileged process: binds an RDS socket using IB, never reads it
>   remote peer: connects to the rds_tcp listener and sends to that port
>     rds_recv_incoming()->rds_find_bound() matches the IB-bound socket
>     the inc is queued on rs_recv_queue, holding a TCP conn reference
>   admin: rmmod rds_tcp
>     rds_tcp_exit()->rds_conn_wait_conns_freed() never returns
>=20
> Before this patch, only the hash-table reference and short-lived
> references pinned a connection, so the wait added earlier in the series
> always finished.
>=20
> The commit message says this is intended:
>=20
>   "It also means the transport cannot unload while such a datagram is
>    unread ... That is the intended behaviour"
>=20
> However, it lets an unprivileged application decide how long a privileged
> unload stays stuck. Could the unload path instead purge the departing
> transport's incs from socket receive queues? Or could the wait be made
> interruptible or abortable?
>=20
> [ ... ]
>=20

