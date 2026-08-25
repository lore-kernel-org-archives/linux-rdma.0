Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171DE49365C;
	Tue, 25 Aug 2026 00:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787616198; cv=none; b=lyCG/Vy80Gy51V2wKAAUtD+IXG6FZA1qUGvtF33MMZ0yciWL18wsQHfgwuSzpRfk9Qaqa1paHmt49d+A37EquYd1FHc//t3HQHRTzoTS3SdbnBBNoB4v3NFKUMatPBtrd0QCUEVhdXXyVKdPWWx3JOHnL4vB49oTSgrKUCSmTCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787616198; c=relaxed/simple;
	bh=xuDKjA1RbPYEMVqyCBaG1bMYHLdbqEZqRmuiSD6hffg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=O0mFYfZygNhb8OagckZILAjd0PLbSkUtWlpWGT4tsRfk9WgT3v8tHJsUtlLpOJYkj3SRI3HaDaULNBR/59VB4gWi9iKZmYcojRmOhHCtj0Q5EYBBcLyQl51Qcfc65vz1umt0lRwJCFmSBtSXRWB80xfQ1RBrOlToUbSRrOKfa/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nVt4JgZO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nVt4JgZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341301F000E9;
	Tue, 25 Aug 2026 00:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787616196;
	bh=2wmTac7FK68VNzciVgHIm+9utbcnTYWipob5ykg8eDQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=nVt4JgZOulZ7DzyfmOKkW3CVnta3bOyQI7rnqIbGFAo4nlnP5CGOjnmMM2zpQ1RlO
	 hEvrfdNuQcRuDesiblK63G1M71NYNv43gglgbNjS0xcDW7p1ZGQfjsXwA4MfOgrMUN
	 MgYIDOTXAZeC7JHRrYbwciVYky7o2ArICUtudZYG2tnZpd2q9dJ2EWHH9FxlqenbZ8
	 QwNtq/RsUTc4KvWONXQG3DUJiwsxCLqn91ey14ReUq6/852XY9jqK+PJYOccDWdQs0
	 dcEDr2/GbV+wMhcVY/83YB38ODZ4NC6kUhNfxcoP5607zytjTQbNPtjJX5oavgUpbS
	 ZXZ5D6r0ioLcA==
Message-ID: <213829b7380f1fe12aed2f2ae9ba33c2870addd5.camel@kernel.org>
Subject: Re: [PATCH net] net/rds: fix out-of-bounds write in
 rds_conn_peer_gen_update()
From: Allison Henderson <achender@kernel.org>
To: Paula Moutafian <paula@bynar.io>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com,  horms@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org,  rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org
Date: Mon, 24 Aug 2026 17:03:15 -0700
In-Reply-To: <20260824144124.64756-1-paula@bynar.io>
References: <20260824144124.64756-1-paula@bynar.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-08-24 at 15:41 +0100, Paula Moutafian wrote:
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
> Bound every loop by the number of paths actually allocated, mirroring
> the npaths computation already used in rds_conn_destroy() and
> rds_conn_message_info_cmn() (net/rds/connection.c).  For t_mp_capable
> transports the behaviour is unchanged; for single-path transports the
> loops now stay within the one allocated rds_conn_path.
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
> t_mp_capable without updating either loop:
>=20
> commit 840df162b3eb ("rds: reduce memory footprint for RDS when transport=
 is RDMA")
>=20
> rds_check_all_paths() (net/rds/connection.c) is unrelated to that
> regression: it was added new, three years later, and was unbounded
> from the moment it was written:
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
> ---
>  net/rds/connection.c |  3 ++-
>  net/rds/recv.c       | 10 ++++++----
>  2 files changed, 8 insertions(+), 5 deletions(-)
>=20
> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index 7c8ab8e973e1..282e320516f5 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c
> @@ -976,11 +976,12 @@ EXPORT_SYMBOL_GPL(rds_conn_path_connect_if_down);
>   */
>  void rds_check_all_paths(struct rds_connection *conn)
>  {
> +	int npaths =3D (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
>  	int i =3D 0;
> =20
>  	do {
>  		rds_conn_path_connect_if_down(&conn->c_path[i]);
> -	} while (++i < conn->c_npaths);
> +	} while (++i < conn->c_npaths && i < npaths);

Hi Paula,

Thanks for catching this!  I think we can tighten this patch a little bit b=
y correcting conn->c_npaths itself rather
than adding a second check everywhere conn->c_npaths is used.  conn->c_npat=
hs is set in rds_recv_hs_exthdrs().  So
applying the same fix pattern there will take care of any site where conn->=
c_npaths is used.  Just add your npaths
variable at the top, and apply it in the switch in rds_recv_hs_exthdrs():

                case RDS_EXTHDR_NPATHS:
                       new_npaths =3D min_t(int, npaths,   <----- use npath=
s here instead of RDS_MPATH_WORKERS
                                          be16_to_cpu(buffer.rds_npaths));

That should take care of the both uses in rds_start_mprds() and rds_check_a=
ll_paths() without further changes.  Other
than that I think this patch looks pretty good.

Thank you!
Allison


>  }
> =20
>  void rds_conn_connect_if_down(struct rds_connection *conn)
> diff --git a/net/rds/recv.c b/net/rds/recv.c
> index cf3884d87931..3813aa323731 100644
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
> @@ -285,12 +286,13 @@ static void rds_recv_hs_exthdrs(struct rds_header *=
hdr,
>   */
>  static void rds_start_mprds(struct rds_connection *conn)
>  {
> -	int i;
> +	int npaths =3D (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
>  	struct rds_conn_path *cp;
> +	int i;
> =20
>  	if (conn->c_npaths > 1 &&
>  	    rds_addr_cmp(&conn->c_laddr, &conn->c_faddr) < 0) {
> -		for (i =3D 0; i < conn->c_npaths; i++) {
> +		for (i =3D 0; i < conn->c_npaths && i < npaths; i++) {
>  			cp =3D &conn->c_path[i];
>  			rds_conn_path_connect_if_down(cp);
>  		}
>=20
> base-commit: 564973a259ec76f2dad0853420e7034cc43994c4
