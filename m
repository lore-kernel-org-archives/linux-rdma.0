Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A2D3A9D8D;
	Fri, 28 Aug 2026 22:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787956619; cv=none; b=JZ8TU9gmz+n+x0AtAyPVSg6IidpbUQFxDSxnhP2z4X5qFC72hlYd0Hq6YHyJe3xPJexQT+fuj6voBjQZEkVP51L5wehpaoDNFrWY8NruagPO6ToWKratuQKJVkLnzld+onyW8muBua0Tu2sShgyZM0ZiExvyTF5ONuazI9Gc86o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787956619; c=relaxed/simple;
	bh=TufNf6BicKpSZX6jq8E8RofYKVB0Ylp3MazNpFPtoc4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=POgZ5QcTa1XaCQk2Ok7SVoJBhga5MahKrtmVVT3BCyLNhzQSptV0a39mgQiM/lNKBoFPYNqVVEfUUmZy1cgCfcw0ntU0uvYx6n7VE0PZHtpl6khX/XbsRNRj/xfRQctYE7UOxD7R+oppfjgTbZpob43oBHc6csILKfCxQmA4ELE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bhhzl2rT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bhhzl2rT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3DC1F000E9;
	Fri, 28 Aug 2026 22:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787956617;
	bh=XG7xnmpqIX1iM2Kdgk0iSAjPWmZn+X0fH70ic4wIImE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Bhhzl2rTLjalaFt00/2WTILg/4nVngXKgYaj1sOkSzb7KrM/53K+Vl9mpuOGOoRxQ
	 PK1ykGDRp2e94evh3B4VZaR7azQ34xSwlMKnM5VggGdglvfoOPk/MC6Qy9EIe38xDw
	 /heussb4ArB6DlTxOALYcxuIbvhKVPLjXpyaLA8SFZcQpa9X9dm2exUopMpsIzognm
	 DvvLDtU42LV3HxmLtw5PYcJJAhAnItcnASBfktosGEcUxbstrMC9K2rJNi5fOH3Z0I
	 9KmMap1DfI0uSqyl0+JXx3ldBBqPMUrRcV0rg3mVHqJHjc5zoZY76MxQWlY6aMGyPG
	 cq2nJlMpkrSjQ==
Message-ID: <223ae1242385c9b74f4a2051a00f699390c4f415.camel@kernel.org>
Subject: Re: [PATCH net v4 6/7] net/rds: acquire the fastpath locks in
 rds_conn_shutdown()
From: Allison Henderson <achender@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com, 
 edumazet@google.com, horms@kernel.org, jhubbard@nvidia.com,
 woni9911@gmail.com,  michal.kubiak@intel.com, leon@kernel.org
Date: Fri, 28 Aug 2026 15:36:56 -0700
In-Reply-To: <20260827180220.3951003-1-kuba@kernel.org>
References: <20260824003759.127353-7-achender@kernel.org>
	 <20260827180220.3951003-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-08-27 at 11:02 -0700, Jakub Kicinski wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> net/rds: acquire the fastpath locks in rds_conn_shutdown()
>=20
> This changes rds_conn_shutdown() from waiting for RDS_IN_XMIT and
> RDS_RECV_REFILL to be observed clear into acquiring both bits as locks,
> holding them across the transport shutdown and rds_conn_path_reset(), and
> releasing them with clear_bit_unlock() plus a wake-up.  Related comments =
in
> rds_send_xmit(), rds_ib_recv_refill() and rds_tcp_reset_callbacks() are
> updated to describe the new ownership rules.
>=20
> > diff --git a/net/rds/connection.c b/net/rds/connection.c
> > index 46ac72088f842..fbbac55a0e818 100644
> > --- a/net/rds/connection.c
> > +++ b/net/rds/connection.c
>=20
> [ ... ]
>=20
> > @@ -414,14 +417,35 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
> >  		}
> >  		mutex_unlock(&cp->cp_cm_lock);
> > =20
> > +		/* Quiesce the transmit and receive-refill paths by
> > +		 * acquiring their bit locks, not merely waiting for
> > +		 * them to be released: with a plain wait, either path
> > +		 * can re-take its lock the instant after we sample it
> > +		 * clear and then run concurrently with the transport
> > +		 * shutdown and the path reset below.  Holding both
> > +		 * locks across the teardown makes that structurally
> > +		 * impossible.
> > +		 */
> >  		wait_event(cp->cp_waitq,
> > -			   !test_bit(RDS_IN_XMIT, &cp->cp_flags));
> > +			   !test_and_set_bit_lock(RDS_IN_XMIT, &cp->cp_flags));
>=20
> [Severity: Medium]
>=20
> How long can this ownership window be in practice?  Both bits are now hel=
d
> across conn->c_trans->conn_path_shutdown(), which blocks.  For TCP that i=
s
> the drain loop in rds_tcp_conn_path_shutdown():
>=20
> 	} while (!wait_event_timeout(tc->t_recv_done_waitq,
> 				(sk->sk_state =3D=3D TCP_CLOSING || ...) &&
> 				skb_queue_empty_lockless(&sk->sk_receive_queue),
> 				msecs_to_jiffies(100)) &&
> 			 ++rounds < 50);
>=20
> which is the up to ~5 s the changelog mentions, with the exit condition
> driven by the peer's TCP state and receive queue.
>=20
> For IB, rds_ib_conn_path_shutdown() has no iteration cap:
>=20
> 	while (!wait_event_timeout(rds_ib_ring_empty_wait,
> 				   rds_ib_conn_path_shutdown_check_wait(cp) =3D=3D 0,
> 				   msecs_to_jiffies(1000))) {
>=20
> so the window there is unbounded, and rds_ib_flush_mrs() and tasklet_kill=
()
> run inside it too.
>=20
> The only blocking waiter for RDS_IN_XMIT is rds_tcp_reset_callbacks(), ca=
lled
> from rds_tcp_accept_one() on rds_wq, which rds_threads_init() creates as:
>=20
> 	rds_wq =3D create_singlethread_workqueue("krdsd");
>=20
> and it parks there holding rtn->rds_tcp_accept_lock and tc->t_conn_path_l=
ock.
> While it is parked the single krdsd worker is occupied, so accept process=
ing
> for other connections and other namespaces, rds_ibdev->free_work, rds_mes=
sage
> unpin work, and the flush_workqueue(rds_wq) in rds_tcp_listen_stop() duri=
ng
> namespace teardown all wait behind it.  Before this patch that wait was
> bounded by a single rds_send_xmit() batch, since teardown never owned the=
 bit.
>=20
> Is the uncapped IB retry loop meant to be covered by the "up to 5 s" boun=
d
> stated in the changelog?

The reason this doesnt concern the krdsd-parking concern is because the onl=
y
*blocking* acquirer of these bits is rds_tcp_reset_callbacks().  So the wai=
t only
happens on the TCP path, not the IB path.

Both transports' fastpaths are trylock-and-back-off.  So an uncapped IB dra=
in
lengthens that path's quiesce as it always has, but it doesnt park anything=
 else
(the drain behavior predates this series).

I'll add an extra bit to the commit message to clarify though

>=20
> >  		wait_event(cp->cp_waitq,
> > -			   !test_bit(RDS_RECV_REFILL, &cp->cp_flags));
> > +			   !test_and_set_bit(RDS_RECV_REFILL, &cp->cp_flags));
>=20
> [Severity: Low]
>=20
> RDS_RECV_REFILL is now taken as a lock here, and the release comment belo=
w
> describes an ordered handoff of the bit.  The release side of that handof=
f is
> release_refill() in net/rds/ib_recv.c, which only gained release semantic=
s in
> the earlier series patch "net/rds: use clear_bit_unlock() in
> release_refill()".
>=20
> The backport paragraph in the changelog names only two prerequisites:
>=20
>     "For anyone backporting this patch standalone: it depends on
>     "net/rds: clear cp_flags bits individually in rds_conn_path_reset()"
>     and "net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()"
>     earlier in this series."
>=20
> Without the release_refill() patch, that function reads:
>=20
> 	clear_bit(RDS_RECV_REFILL, &conn->c_flags);
> 	smp_mb__after_atomic();
>=20
> with the barrier after the clear, which does not order the refill path's
> preceding ring and recv stores before the bit clear.
>=20
> Should the release_refill() patch be listed as a prerequisite as well?

Sure, I'll update the change log to add patches 2 and 7 to the list

>=20
> > =20
> >  		conn->c_trans->conn_path_shutdown(cp);
> >  		rds_conn_path_reset(cp);
> > =20
> > +		/* Release the two locks and wake any waiter (e.g.
> > +		 * rds_tcp_reset_callbacks()) that blocked on them while
> > +		 * we held them.  The unlock orders the transport's ring
> > +		 * re-initialization and the path reset above before
> > +		 * either bit is seen clear.  rds_conn_path_reset() leaves
> > +		 * both bits alone: ownership ends here, not inside the
> > +		 * reset.
> > +		 */
> > +		clear_bit_unlock(RDS_IN_XMIT, &cp->cp_flags);
> > +		clear_bit_unlock(RDS_RECV_REFILL, &cp->cp_flags);
> > +		wake_up_all(&cp->cp_waitq);
> > +
> >  		if (!rds_conn_path_transition(cp, RDS_CONN_DISCONNECTING,
> >  					      RDS_CONN_DOWN) &&
> >  		    !rds_conn_path_transition(cp, RDS_CONN_ERROR,
>=20
> [Severity: Medium]
>=20
> This is a pre-existing behaviour rather than something this patch introdu=
ces,
> but the new ownership window makes it reachable deterministically, so it
> seems worth a question.
>=20
> rds_tcp_reset_callbacks() does its state check before it blocks on
> RDS_IN_XMIT, so a duelling SYN accepted in the window before the teardown
> moves the path to RDS_CONN_DISCONNECTING now resumes only after
> conn_path_shutdown() and rds_conn_path_reset() have run.  The accept then
> installs the new socket:
>=20
> net/rds/tcp_listen.c:rds_tcp_accept_one() {
> 	...
> 	if (rs_tcp->t_sock) {
> 		rds_tcp_reset_callbacks(new_sock, cp);
> 		rds_connect_path_complete(cp, RDS_CONN_RESETTING);
> 	...
> }
>=20
> and rds_connect_path_complete() cannot match RDS_CONN_RESETTING from
> DISCONNECTING/ERROR:
>=20
> net/rds/threads.c:rds_connect_path_complete() {
> 	if (!rds_conn_path_transition(cp, curr, RDS_CONN_UP)) {
> 		printk(KERN_WARNING "%s: Cannot transition to state UP, ...");
> 		rds_conn_path_drop(cp, false);
> 	...
> }
>=20
> At this commit the RDS_CONN_ERROR set by that drop can be consumed by the
> second arm above, so the shutdown pass the drop queued becomes a no-op an=
d
> the freshly accepted socket stays attached to a path the teardown already
> reset.
>=20
> The last patch of this series, "net/rds: don't let rds_conn_shutdown()
> consume a concurrent drop", replaces that arm with
>=20
> 	if (rds_conn_path_state(cp) =3D=3D RDS_CONN_ERROR)
> 		return;
>=20
> so at the end of the series the queued pass survives and finishes the
> teardown.  Since the new deterministic resume point depends on that, shou=
ld
> the standalone-backport paragraph name that patch too?
>=20
> > diff --git a/net/rds/send.c b/net/rds/send.c
> > index 8aad185e4b1aa..b90e0586f818c 100644
> > --- a/net/rds/send.c
> > +++ b/net/rds/send.c
> > @@ -244,8 +244,9 @@ int rds_send_xmit(struct rds_conn_path *cp)
> >  	WRITE_ONCE(cp->cp_send_gen, send_gen);
> > =20
> >  	/*
> > -	 * rds_conn_shutdown() sets the conn state and then tests RDS_IN_XMIT=
,
> > -	 * we do the opposite to avoid races.
> > +	 * rds_conn_shutdown() sets the conn state and then acquires
> > +	 * RDS_IN_XMIT; we take the lock first and then check the state,
> > +	 * so one of us is guaranteed to see the other's update.
> >  	 */
> >  	if (!rds_conn_path_up(cp)) {
>=20
> [Severity: Low]
>=20
> This isn't a bug, only a note on the wording.  Read on its own, "guarante=
ed
> to see the other's update" looks like a cross-variable ordering claim, wh=
ich
> neither acquire_in_xmit() (test_and_set_bit_lock, acquire only) nor the p=
lain
> atomic_read() behind rds_conn_path_up() provides.
>=20
> Checking it against the code, the claim holds for a different reason: bot=
h
> sides RMW the same bit of the same cp_flags word, so the modification ord=
er
> of that word serializes them.  If the sender's test_and_set_bit_lock() wi=
ns,
> the teardown's returns 1 and it blocks in wait_event(); if the teardown w=
ins,
> acquire_in_xmit() fails and the sender backs off.
>=20
> Would it be clearer to say that ownership is decided by the RMW on cp_fla=
gs,
> as the changelog does, rather than by ordering between the two variables?

Sure, I'll rework the comment to clarify the guarantee actually comes from =
both
sides doing an atomic RMW on the same cp_flags.

>=20
> > diff --git a/net/rds/tcp.c b/net/rds/tcp.c
> > index f4c83e3683905..826e620b2dd14 100644
> > --- a/net/rds/tcp.c
> > +++ b/net/rds/tcp.c
> > @@ -144,8 +144,10 @@ void rds_tcp_reset_callbacks(struct socket *sock,
> >  	 * so we must quiesce any send threads before resetting
> >  	 * cp_transport_data.  Setting cp_state to something other
> >  	 * than RDS_CONN_UP stops new senders, and owning RDS_IN_XMIT
> > -	 * excludes any thread already inside rds_send_xmit() for the
> > -	 * whole socket swap and the rds_send_path_reset() below.
> > +	 * excludes any thread already inside rds_send_xmit() - or a
> > +	 * teardown in rds_conn_shutdown(), which holds the same lock
> > +	 * for the duration of the transport shutdown - for the whole
> > +	 * socket swap and the rds_send_path_reset() below.
>=20
> [Severity: Low]
>=20
> The changelog states:
>=20
>     "It cannot deadlock: the teardown runs on the path's own ordered
>     workqueue and never waits on krdsd, so it always completes the drain
>     and releases the bit"
>=20
> Is that accurate as written?  After this patch rds_conn_shutdown() blocks=
 in
> wait_event() until it can acquire RDS_IN_XMIT, and rds_tcp_reset_callback=
s()
> running from the krdsd accept worker can already own that bit, so the
> teardown does wait for a krdsd work item to make progress.  The dependenc=
y
> looks bidirectional.
>=20
> While holding RDS_IN_XMIT, rds_tcp_reset_callbacks() does:
>=20
> 	cancel_delayed_work_sync(&cp->cp_send_w);
> 	cancel_delayed_work_sync(&cp->cp_recv_w);
> 	lock_sock(osock->sk);
>=20
> cp_send_w and cp_recv_w live on cp->cp_wq, the same workqueue whose singl=
e
> execution slot the blocked cp_down_w occupies.  That appears safe only
> because __rds_conn_create() allocates it as:
>=20
> 		conn->c_path[i].cp_wq =3D
> 			alloc_ordered_workqueue("krds_cp_wq#%lu/%d", 0,
> 						rds_conn_count, i);
> 		if (!conn->c_path[i].cp_wq)
> 			conn->c_path[i].cp_wq =3D rds_wq;
>=20
> with max_active =3D=3D 1, so those items cannot be running and the sync c=
ancels
> return without flushing.
>=20
> Could that invariant be stated, either in the changelog or next to the ne=
w
> blocking wait, given that a non-ordered cp_wq or any added flush inside t=
he
> RDS_IN_XMIT section here would turn it into a hang?

Sure, we can expand the explaining so more.  I think this is re-hitting som=
e
of the same things explained in v2. The waits point at each other but the h=
older
never needs anything the teardown owns.=C2=A0

To further clarify: the canceled syncs target cp_send_w/cp_recv_w on the
path's ordered cp_wq.  But since they are single threaded, the slot is
occupied by the blocked cp_down_w itself.  So anything still queued behind
it cancels with out flushing.  We wouldn't want to stop and wait for an
explicit flush because the thing at the head of the queue that everyone's
waiting on is itself.

But I'll add a comment in the change log next to those cancels stating the
ordered-cp_wq reliance. So if, for example, another patch were to add a
non-ordered cp_wq or a flush inside the held-bit section, then yes, this wo=
uld
indeed turn this into a hang in that case.

Thanks!
Allison

>=20
> [ ... ]

