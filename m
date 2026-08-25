Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3482E2EEE;
	Tue, 25 Aug 2026 23:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787699765; cv=none; b=fZLDpIyWrPUyk+W1HCBSzcPUq/WAZOptutgbM+dMBRLR8jcBdfDI7dTf+YfkuHTpKiHdPMEHY3oUooSL376SgbF1Amzayz9i5/zeUQoeYoqRR1e4/0+hbOjcsHp6v6juHiwWwTBvbl+Sn4jt47IFIhSKU5Nb7fuGHAjQckhTAWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787699765; c=relaxed/simple;
	bh=yXPRHTpNE/+r66oOJ+ybxt/YZRDn7LfNAZ1LzkF10I0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NH3rbeV+jz+D27XKJQBf+uDXEi4EzqF8gfAftUtJowGKeb53GQhmIuMNaX4HCnP+FSsdRbyuMB+6tfV2bdjSHZB8YYxLNXxceD0lK16qeYZHc343oaIhAPxG/9Ue7dTGuIkn0W0hJ4Be/CrbdjPtlja4/qYks5z4wBBtsPtvOjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AAeDkljO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AAeDkljO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5021F000E9;
	Tue, 25 Aug 2026 23:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787699764;
	bh=/cNmmNvhGlkxS7SZv8G19FI0tngiieRaSNNGyFvAoN8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=AAeDkljOs34jOG2uw25vckPNe9JYWAino/q7dBjlAZtrOwBkvXxStswpwzSBXETrg
	 YCsBeMyPRBJRwDKq+2WK9RjZfPYPLqD66PvwK0vYGy8pJ6hi4NtFjxKYdzBMogIByO
	 aeXMY7tLL3ey3YC0m17co/MapgPSd8NqSCQU2D0sNwJHuu3YJ/kUV6cPZB+0MIIxyS
	 HfYRsHkaqk9V3xvmL/5VQAXFOxUTUqkW30OqT5jZd9NRqCiXepAZkfxP/CyKcrphmg
	 BCulmzTO8VDpggeiBL5dfS815XGqsFQBdqEQN97LY9lboiVAo2mCY98p1C3ciUk6dB
	 x4nvXrBBCXUtg==
Message-ID: <9898c771fb10d2a9b774f6ec4c7c94bc7b0129f7.camel@kernel.org>
Subject: Re: [PATCH v2 net] net/rds: fix out-of-bounds write in
 rds_conn_peer_gen_update()
From: Allison Henderson <achender@kernel.org>
To: pamoutaf <paula@bynar.io>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com,  horms@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org,  rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org
Date: Tue, 25 Aug 2026 16:16:03 -0700
In-Reply-To: <20260825120132.51636-1-pamoutafpro@gmail.com>
References: <20260825120132.51636-1-pamoutafpro@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-08-25 at 13:01 +0100, pamoutaf wrote:
> From: Paula Moutafian <paula@bynar.io>
>=20
> rds_conn_peer_gen_update(), rds_start_mprds() and rds_check_all_paths()
> all iterate conn->c_path[] up to RDS_MPATH_WORKERS (8) or conn->c_npaths,
> but c_path is allocated with only
>=20
> 	npaths =3D (trans->t_mp_capable ? RDS_MPATH_WORKERS : 1)
>=20
> entries in __rds_conn_create() (net/rds/connection.c).  Only the TCP
> transport sets t_mp_capable, so for the IB/RDMA transport (and the loop
> transport) exactly one rds_conn_path is allocated.
>=20
> c_npaths is derived from the peer via the RDS_EXTHDR_NPATHS handshake
> extension header and is only clamped to RDS_MPATH_WORKERS, never to the
> transport's actual allocation.  A remote peer on an RDS/IB (RoCE) fabric
> can therefore complete the unauthenticated handshake and, by sending a
> second RDS_EXTHDR_GEN_NUM with a changed generation number, drive
> rds_conn_peer_gen_update() to walk c_path[1..7] past the end of a
> one-element allocation -- taking cp_lock, writing cp_next_tx_seq /
> cp_next_rx_seq and walking cp_retrans on neighbouring slab objects.
> rds_start_mprds() and rds_check_all_paths() are reachable the same way
> via a peer-supplied c_npaths > 1; note rds_check_all_paths() is a
> do/while and dereferences c_path[0] before testing the bound.
>=20
> Reproduced against an unmodified 7.2.0 KASAN build, triggered from a
> hand-rolled RDS/IB peer completing the handshake and sending two probes
> with differing RDS_EXTHDR_GEN_NUM:
>=20
> BUG: KASAN: slab-out-of-bounds in do_raw_spin_lock+0x55/0x9a
> Write of size 4 at addr ff1100000425a624 by task ksoftirqd/0/13
> Call Trace:
>  do_raw_spin_lock+0x55/0x9a
>  _raw_spin_lock_irqsave+0x12/0x18
>  rds_recv_hs_exthdrs+0x34a/0x52a
>  rds_recv_incoming+0x5a8/0xb33
>  rds_ib_recv_cqe_handler+0xda1/0x12b6
>  poll_rcq+0x8e/0xb1
>  rds_ib_tasklet_fn_recv+0x1c4/0x348
> Allocated by task 10:
>  __rds_conn_create+0x5b3/0x168f
>  rds_conn_create+0x18/0x1b
>  rds_ib_cm_handle_connect+0x486/0xa35
> The buggy address is located 44 bytes to the right of
>  allocated 504-byte region, cache kmalloc-512
>=20
> The corrupted neighbour's cp_retrans.next is then dereferenced on the
> next line, producing a fatal GPF (RIP: rds_recv_hs_exthdrs+0x3ba/0x52a,
> KASAN: null-ptr-deref) -- a crash, not merely a detected access.
>=20
> Fix conn->c_npaths at the source instead of guarding every reader: in
> rds_recv_hs_exthdrs() (net/rds/recv.c), clamp the peer-supplied
> RDS_EXTHDR_NPATHS value to the transport's actual per-connection
> allocation rather than to the fixed RDS_MPATH_WORKERS ceiling. c_npaths
> can then never exceed the number of rds_conn_path entries
> __rds_conn_create() allocated, which takes care of rds_start_mprds()
> and rds_check_all_paths() -- both already bound their loops by
> conn->c_npaths -- with no change at either call site.
>=20
> rds_conn_peer_gen_update() is different: its loop is bound by the fixed
> RDS_MPATH_WORKERS constant, not by conn->c_npaths, so the c_npaths fix
> above does not reach it. It still needs its own bound, computed the same
> way as the allocation site and mirroring the sibling pattern already used
> in rds_conn_destroy() (net/rds/connection.c).
>=20
> rds_conn_peer_gen_update() and rds_start_mprds() (net/rds/recv.c) were
> both correct when written, with c_path still a fixed
> RDS_MPATH_WORKERS-element array:
>=20
> commit 905dd4184e07 ("RDS: TCP: Track peer's connection generation number=
")
> commit 5916e2c1554f ("RDS: TCP: Enable multipath RDS for TCP")
>=20
> They became wrong when the allocation was made conditional on
> t_mp_capable without updating either loop or the RDS_EXTHDR_NPATHS clamp:
>=20
> commit 840df162b3eb ("rds: reduce memory footprint for RDS when transport=
 is RDMA")
>=20
> rds_check_all_paths() (net/rds/connection.c) is unrelated to that
> regression: it was added new, three years later, and was unbounded
> from the moment it was written, but is fixed by the same c_npaths clamp:
>=20
> commit 9ef845f894c9 ("rds: If one path needs re-connection, check all and=
 re-connect")
>=20
> Fixes: 840df162b3eb ("rds: reduce memory footprint for RDS when transport=
 is RDMA")
> Fixes: 9ef845f894c9 ("rds: If one path needs re-connection, check all and=
 re-connect")
> Cc: stable@vger.kernel.org
> Assisted-by: Bynario AI
> Signed-off-by: Paula Moutafian <paula@bynar.io>

Ok, this looks good to me.  Thanks Paula!
Reviewed-by: Allison Henderson <achender@kernel.org>

> ---
> v2:
> - Per Allison Henderson's review, clamp conn->c_npaths itself at the
>   point it is set from the peer's RDS_EXTHDR_NPATHS in
>   rds_recv_hs_exthdrs(), instead of adding a second bound check at
>   each of its readers. This covers rds_start_mprds() and
>   rds_check_all_paths() with no further change at either site;
>   net/rds/connection.c is unchanged from v1.
> - rds_conn_peer_gen_update()'s loop is bound by RDS_MPATH_WORKERS
>   directly, not by conn->c_npaths, so it is unaffected by the above
>   and keeps its own bound from v1.
>=20
> [v1] https://lore.kernel.org/netdev/213829b7380f1fe12aed2f2ae9ba33c2870ad=
dd5.camel@kernel.org/T/#t
>=20
>  net/rds/recv.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/rds/recv.c b/net/rds/recv.c
> index cf3884d87931..c7f575bad91c 100644
> --- a/net/rds/recv.c
> +++ b/net/rds/recv.c
> @@ -133,15 +133,16 @@ static void rds_recv_rcvbuf_delta(struct rds_sock *=
rs, struct sock *sk,
>  static void rds_conn_peer_gen_update(struct rds_connection *conn,
>  				     u32 peer_gen_num)
>  {
> -	int i;
> +	int npaths =3D (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
>  	struct rds_message *rm, *tmp;
>  	unsigned long flags;
> +	int i;
> =20
>  	WARN_ON(conn->c_trans->t_type !=3D RDS_TRANS_TCP);
>  	if (peer_gen_num !=3D 0) {
>  		if (conn->c_peer_gen_num !=3D 0 &&
>  		    peer_gen_num !=3D conn->c_peer_gen_num) {
> -			for (i =3D 0; i < RDS_MPATH_WORKERS; i++) {
> +			for (i =3D 0; i < npaths; i++) {
>  				struct rds_conn_path *cp;
> =20
>  				cp =3D &conn->c_path[i];
> @@ -210,6 +211,7 @@ static void rds_recv_hs_exthdrs(struct rds_header *hd=
r,
>  	u32 new_peer_gen_num =3D 0;
>  	int new_npaths;
>  	bool fan_out;
> +	int npaths =3D (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
> =20
>  	new_npaths =3D conn->c_npaths;
> =20
> @@ -221,7 +223,7 @@ static void rds_recv_hs_exthdrs(struct rds_header *hd=
r,
>  		/* Process extension header here */
>  		switch (type) {
>  		case RDS_EXTHDR_NPATHS:
> -			new_npaths =3D min_t(int, RDS_MPATH_WORKERS,
> +			new_npaths =3D min_t(int, npaths,
>  					   be16_to_cpu(buffer.rds_npaths));
>  			break;
>  		case RDS_EXTHDR_GEN_NUM:
>=20
> base-commit: 564973a259ec76f2dad0853420e7034cc43994c4

