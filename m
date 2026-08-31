Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57BA3A75A3;
	Mon, 31 Aug 2026 02:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788144768; cv=none; b=fko3AhezUV4+G0AkDCbab4+hAPyUJReXqEp+5DjnDhAR+tpAD9Wz2KfTgHYH5bhSJeorSlm+kC6Wdq51WgRmJgxALJ6P4pXY3qdOygd/07PaEnpLmxqwe0/pBjELzXxOZhB5BgvcytY48X/VJw17xmNfaX0MREuJPpU0A3mWS54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788144768; c=relaxed/simple;
	bh=jkyJ5ysUNY8S9FUlKYtCNX2ubGYV9IE+C4l7q8myHdY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OcnAODb4V4Fs59YyfpiuXYj50eX5mjg5Mfr8GGF0VfroeH4mZlQLXx6/FIslqybx8sVjlbNJiQzdZ2k2xOg8H5tLXbvG7WJcC2p2D4eM9dtiR1DL3VUfFdB2SAWdlpdlM42+Ki69fb446Y+XMprTvptdNd9ydlwuxvufzp5TboY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QJcunut3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QJcunut3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486A31F000E9;
	Mon, 31 Aug 2026 02:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788144764;
	bh=xUBgiYYWjvm5yjSPg8f6OOHgAbkPIATum75OuDCh+M0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=QJcunut3t6MmYiRLrDBemrVFWEbSRpdgfAmLq19mHesJoaqCQEByQ8osf1S9pFTLj
	 KmpWaYJ78ncMQdExJz3j3zD9CWxkciUuYH4feYL8Ydo8ybqbjPSfTBqCJU0Ywv0P8U
	 W/wjRBdKU0yAHy96ZqmgMfpQ2OoF/PR52jUKwMMLhQnBb5P63qpZPi2gU8vE8BGR1Y
	 zvxRorfIBTU0aMgcNngCjI3ly1pCC3KbO1ipsDposKQdEKnZmqfdplCTHE/xXZIrUz
	 DkpoimMPPuEt7t6B13OZbD9NyUAswd3tkwDIZc3KYRresLBD3m3HCCYfLDF8h9ooJA
	 q80mCrX+rpJVg==
Message-ID: <514cfa94e605a2623a8850d1fd309d1c71cf5da6.camel@kernel.org>
Subject: Re: [PATCH v2 net] net/rds: fix out-of-bounds write in
 rds_conn_peer_gen_update()
From: Allison Henderson <achender@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>, paula@bynar.io
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 horms@kernel.org,  netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 rds-devel@oss.oracle.com,  linux-kernel@vger.kernel.org
Date: Sun, 30 Aug 2026 19:52:43 -0700
In-Reply-To: <20260828230506.385788-1-kuba@kernel.org>
References: <20260825120132.51636-1-pamoutafpro@gmail.com>
	 <20260828230506.385788-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-08-28 at 16:05 -0700, Jakub Kicinski wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> net/rds: fix out-of-bounds write in rds_conn_peer_gen_update()
>=20
> This clamps the peer-supplied RDS_EXTHDR_NPATHS value in
> rds_recv_hs_exthdrs() to the number of rds_conn_path entries the transpor=
t
> actually allocated, and gives the loop in rds_conn_peer_gen_update() the
> same bound instead of the fixed RDS_MPATH_WORKERS constant.
>=20
> Reference to the earlier posting:
> [v1] https://lore.kernel.org/netdev/213829b7380f1fe12aed2f2ae9ba33c2870ad=
dd5.camel@kernel.org/T/#t
>=20
> > diff --git a/net/rds/recv.c b/net/rds/recv.c
> > index cf3884d879319..c7f575bad91c8 100644
> > --- a/net/rds/recv.c
> > +++ b/net/rds/recv.c
> > @@ -133,15 +133,16 @@ static void rds_recv_rcvbuf_delta(struct rds_sock=
 *rs, struct sock *sk,
> >  static void rds_conn_peer_gen_update(struct rds_connection *conn,
> >  				     u32 peer_gen_num)
> >  {
> > -	int i;
> > +	int npaths =3D (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
> >  	struct rds_message *rm, *tmp;
> >  	unsigned long flags;
> > +	int i;
>=20
> [Severity: High]
> This isn't a bug introduced by this patch, but is
> conn->c_trans->t_mp_capable really equivalent to the count used at the
> allocation site?
>=20
> __rds_conn_create() derives npaths from the incoming trans, allocates
> c_path plus one ordered workqueue per path, and only afterwards may repla=
ce
> the transport:
>=20
> net/rds/connection.c:__rds_conn_create() {
> 	int npaths =3D (trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
> 	...
> 				trans =3D &rds_loop_transport;
> 	...
> 	conn->c_trans =3D trans;
> 	for (i =3D 0; i < npaths; i++) {
> 		...
> 		cp->cp_wq =3D alloc_ordered_workqueue(...);
>=20
> For an outgoing TCP connection to a local non-loopback address
> (rds_tcp_transport has t_prefer_loopback set) the conn therefore ends up
> with 8 paths and 8 workqueues while conn->c_trans is rds_loop_transport,
> which has t_mp_capable clear.
>=20
> rds_conn_destroy() recomputes the count exactly the way this hunk does:
>=20
> net/rds/connection.c:rds_conn_destroy() {
> 	int npaths =3D (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
> 	...
> 	for (i =3D 0; i < npaths; i++) {
> 		cp =3D &conn->c_path[i];
> 		rds_conn_path_destroy(cp);
> 	...
> 	kfree(conn->c_path);
>=20
> Does that leak the cp_wq workqueues belonging to paths 1..7 in this case?
> Note rds_conn_path_destroy() also returns early before destroy_workqueue(=
):
>=20
> net/rds/connection.c:rds_conn_path_destroy() {
> 	if (!cp->cp_transport_data)
> 		return;
> 	...
> 	if (cp->cp_wq !=3D rds_wq) {
> 		destroy_workqueue(cp->cp_wq);
>=20
> so simply widening the destroy loop would not reach the workqueues either=
.
> The failure path in __rds_conn_create() uses the pre-swap npaths to destr=
oy
> all the workqueues, which suggests npaths, not the post-swap transport, i=
s
> the real allocation count.
>=20
> The derivation is harmless in this patch (1 is always <=3D the allocation=
),
> but would recording the allocated path count in struct rds_connection and
> using that here avoid duplicating the derivation in a third place?
>=20
> > =20
> >  	WARN_ON(conn->c_trans->t_type !=3D RDS_TRANS_TCP);
> >  	if (peer_gen_num !=3D 0) {
> >  		if (conn->c_peer_gen_num !=3D 0 &&
> >  		    peer_gen_num !=3D conn->c_peer_gen_num) {
> > -			for (i =3D 0; i < RDS_MPATH_WORKERS; i++) {
> > +			for (i =3D 0; i < npaths; i++) {
> >  				struct rds_conn_path *cp;
> > =20
> >  				cp =3D &conn->c_path[i];
>=20
> [Severity: High]
> The new bound stops the walk past the end of c_path[], but does the rest =
of
> this function stay reachable from the same non-TCP peer described in the
> changelog?
>=20
> rds_recv_incoming() dispatches to the handshake parser purely on
> peer-supplied header fields, with no transport check:
>=20
> net/rds/recv.c:rds_recv_incoming() {
> 	if (be16_to_cpu(inc->i_hdr.h_dport) =3D=3D  RDS_FLAG_PROBE_PORT &&
> 	    inc->i_hdr.h_sport =3D=3D 0) {
> 		rds_recv_hs_exthdrs(&inc->i_hdr, cp->cp_conn);
>=20
> and rds_recv_hs_exthdrs() calls rds_conn_peer_gen_update() unconditionall=
y.
> rds_ib_process_recv() hands the wire header straight to rds_recv_incoming=
(),
> and rds_ib_transport sets .t_type =3D RDS_TRANS_IB, so the WARN_ON above =
is
> true for every crafted probe on an IB connection.
>=20
> Can that flood dmesg from a remote peer, or panic the box on
> panic_on_warn=3D1 kernels? Would ratelimiting it, or refusing handshake
> extension headers on non mp-capable transports, be preferable?
>=20
> With npaths =3D=3D 1 the i =3D=3D 0 iteration is still executed. Two prob=
es with
> differing non-zero RDS_EXTHDR_GEN_NUM let the same peer reset
> c_path[0].cp_next_tx_seq to 1 and cp_next_rx_seq to 0 and set RDS_MSG_FLU=
SH
> on every message queued on c_path[0].cp_retrans of a live IB connection.
>=20
> rds_send_probe() only ever emits these headers for t_mp_capable transport=
s:
>=20
> net/rds/send.c:rds_send_probe() {
> 	if (RDS_HS_PROBE(be16_to_cpu(sport), be16_to_cpu(dport)) &&
> 	    cp->cp_conn->c_trans->t_mp_capable) {
>=20
> so on IB both NPATHS and GEN_NUM are always forged. Would an early return=
 in
> rds_recv_hs_exthdrs() for transports without t_mp_capable remove both the
> WARN and the c_path[0] state mutation, and make the new bound here
> unnecessary?

I think this part can be corrected by porting the uek fix here:
 https://github.com/oracle/linux-uek/commit/2fdeb0513f18

That will gate both rds_recv_hs_exthdrs() call sites in the receive path on
conn->c_trans->t_mp_capable which should resolve the complaint.

Allison

>=20
> [Severity: Medium]
> This is a pre-existing issue, but the compare-then-store of
> conn->c_peer_gen_num in this function happens outside any lock =E2=80=94 =
cp_lock
> only covers the per-path queue walk:
>=20
> 	if (peer_gen_num !=3D 0) {
> 		if (conn->c_peer_gen_num !=3D 0 &&
> 		    peer_gen_num !=3D conn->c_peer_gen_num) {
> 			...
> 		conn->c_peer_gen_num =3D peer_gen_num;
>=20
> For a t_mp_capable conn each path has its own cp_wq and receive worker, s=
o
> two lanes can run rds_recv_hs_exthdrs(cp->cp_conn) for the same conn at t=
he
> same time. Can two probes carrying different generation numbers then eith=
er
> double-flush or skip the RDS_MSG_FLUSH marking entirely, leaving stale
> cp_retrans messages after a peer restart?
>=20
> > @@ -210,6 +211,7 @@ static void rds_recv_hs_exthdrs(struct rds_header *=
hdr,
> >  	u32 new_peer_gen_num =3D 0;
> >  	int new_npaths;
> >  	bool fan_out;
> > +	int npaths =3D (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
>=20
> [Severity: Low]
> This isn't a bug, but the new declaration is the longest one in the block
> and is placed last, which does not follow the reverse xmas tree ordering
> netdev asks for. The first hunk of this patch moves int i; below
> unsigned long flags; for exactly that reason, so the two hunks disagree.
>=20
> > =20
> >  	new_npaths =3D conn->c_npaths;
> > =20
> > @@ -221,7 +223,7 @@ static void rds_recv_hs_exthdrs(struct rds_header *=
hdr,
> >  		/* Process extension header here */
> >  		switch (type) {
> >  		case RDS_EXTHDR_NPATHS:
> > -			new_npaths =3D min_t(int, RDS_MPATH_WORKERS,
> > +			new_npaths =3D min_t(int, npaths,
> >  					   be16_to_cpu(buffer.rds_npaths));
> >  			break;
> >  		case RDS_EXTHDR_GEN_NUM:
>=20
> [Severity: Medium]
> This is a pre-existing issue, but conn->c_npaths =E2=80=94 now the single
> authoritative bound for rds_start_mprds() and rds_check_all_paths() =E2=
=80=94 is
> read, tested and published here with no lock, no atomics and no
> READ_ONCE()/WRITE_ONCE():
>=20
> net/rds/recv.c:rds_recv_hs_exthdrs() {
> 	new_npaths =3D conn->c_npaths;
> 	...
> 	if (new_npaths > 1 && new_npaths !=3D conn->c_npaths) {
> 	...
> 	conn->c_npaths =3D max_t(int, new_npaths, 1);
>=20
> Since each path of an mp-capable conn has its own receive worker, two lan=
es
> can be in this function for the same conn concurrently. Can one CPU publi=
sh
> c_npaths =3D 8 and take the fan-out branch while a second CPU, processing=
 a
> probe with no NPATHS extension, writes c_npaths =3D 1 and silently revert=
s it
> while lanes are still coming up?
>=20
> The lane mapping in rds_sendmsg() reads the same field with no
> synchronisation:
>=20
> net/rds/send.c:rds_sendmsg() {
> 		cpath =3D &conn->c_path[RDS_MPATH_HASH(rs, conn->c_npaths ? : 1)];
>=20
> so the local and peer lane hashing could disagree. Every stored value sti=
ll
> passes through max_t(int, new_npaths, 1) with new_npaths already clamped,=
 so
> this looks like a consistency problem rather than an indexing one =E2=80=
=94 is that
> the intended reading?
>=20
> The comment above rds_recv_hs_exthdrs() only promises serialisation again=
st
> other receives on "this specific conn", which for mprds is per-path. Woul=
d
> WRITE_ONCE()/READ_ONCE() plus per-conn serialisation of handshake
> processing be the right follow-up?
