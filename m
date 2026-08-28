Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7E0361962;
	Fri, 28 Aug 2026 23:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787958309; cv=none; b=l8ErfLkrMQ333097sSOHl2o9sU6aWgQuPJ/0+8niQUOfepxo6+XbuC+jXFBuy69OTriP4h6sUlHJSDwusbIjYSmjzrfBDa6NOi5FWF0RlVzkF9biR/scIZJF1RHcgfe9Ac5R00mZu+ip2NK/9hW5c0G9Md69bv5qTmIUWuItsWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787958309; c=relaxed/simple;
	bh=XDIHOFvCCvxHF5hdsNMG6Tf8Sg3nMuh7l0XVlwVNZ9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QOrhr4T0Xnnt35tALiZIBNv4LFQa7jMn9DZk+CWW4LsDrle6xMGxFfmIoPvYdys/w1osNCw8EUqrTIMQmCxxVOUzHmQ1onl9o+8TE4waczsOdJwD+Le0o5WOsr/53RRhlHLlBDkdZiO2v9IdEG6jL7odLUyuqFekidbECGLjcVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mu25Iyy2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mu25Iyy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BE61F000E9;
	Fri, 28 Aug 2026 23:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787958307;
	bh=xe1RRjKX6sTnVNfl/UocF3kwe4aI7U/HwszYxhAfe+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mu25Iyy2GAkJar4xd/FioYGs6/7kbsf7iDZ0HrmZo5eiuhBEC5cbAbUbnKXLBGJwz
	 vagGjYzhRT9Cq5S6oYWxApyJ9Kgws0QSFROgYsLXf0V0ts+c1GFhswD4n3GV9DiC0X
	 150oySd0GRvc0oeTR7W9lwGLmzG7DBg9sgBTEIGohhtptA3y2D7SzeIqcPkIB0sQQ4
	 WzbVEE5oRz+BJkVkflTnChXwfSilsEF1gPeI8xHmNMZq3MQ5C73lOn4buRitCSwHqz
	 /dJ4miaabk7j/+gACU0ySYrVoowVhMm4tQTw/6bz3csYX6LCRDCO2cUPU3ZVqTHypo
	 9x2ijLL3S9KOA==
From: Jakub Kicinski <kuba@kernel.org>
To: paula@bynar.io
Cc: Jakub Kicinski <kuba@kernel.org>,
	achender@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	horms@kernel.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] net/rds: fix out-of-bounds write in rds_conn_peer_gen_update()
Date: Fri, 28 Aug 2026 16:05:04 -0700
Message-ID: <20260828230506.385788-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825120132.51636-1-pamoutafpro@gmail.com>
References: <20260825120132.51636-1-pamoutafpro@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
net/rds: fix out-of-bounds write in rds_conn_peer_gen_update()

This clamps the peer-supplied RDS_EXTHDR_NPATHS value in
rds_recv_hs_exthdrs() to the number of rds_conn_path entries the transport
actually allocated, and gives the loop in rds_conn_peer_gen_update() the
same bound instead of the fixed RDS_MPATH_WORKERS constant.

Reference to the earlier posting:
[v1] https://lore.kernel.org/netdev/213829b7380f1fe12aed2f2ae9ba33c2870addd5.camel@kernel.org/T/#t

> diff --git a/net/rds/recv.c b/net/rds/recv.c
> index cf3884d879319..c7f575bad91c8 100644
> --- a/net/rds/recv.c
> +++ b/net/rds/recv.c
> @@ -133,15 +133,16 @@ static void rds_recv_rcvbuf_delta(struct rds_sock *rs, struct sock *sk,
>  static void rds_conn_peer_gen_update(struct rds_connection *conn,
>  				     u32 peer_gen_num)
>  {
> -	int i;
> +	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
>  	struct rds_message *rm, *tmp;
>  	unsigned long flags;
> +	int i;

[Severity: High]
This isn't a bug introduced by this patch, but is
conn->c_trans->t_mp_capable really equivalent to the count used at the
allocation site?

__rds_conn_create() derives npaths from the incoming trans, allocates
c_path plus one ordered workqueue per path, and only afterwards may replace
the transport:

net/rds/connection.c:__rds_conn_create() {
	int npaths = (trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
	...
				trans = &rds_loop_transport;
	...
	conn->c_trans = trans;
	for (i = 0; i < npaths; i++) {
		...
		cp->cp_wq = alloc_ordered_workqueue(...);

For an outgoing TCP connection to a local non-loopback address
(rds_tcp_transport has t_prefer_loopback set) the conn therefore ends up
with 8 paths and 8 workqueues while conn->c_trans is rds_loop_transport,
which has t_mp_capable clear.

rds_conn_destroy() recomputes the count exactly the way this hunk does:

net/rds/connection.c:rds_conn_destroy() {
	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
	...
	for (i = 0; i < npaths; i++) {
		cp = &conn->c_path[i];
		rds_conn_path_destroy(cp);
	...
	kfree(conn->c_path);

Does that leak the cp_wq workqueues belonging to paths 1..7 in this case?
Note rds_conn_path_destroy() also returns early before destroy_workqueue():

net/rds/connection.c:rds_conn_path_destroy() {
	if (!cp->cp_transport_data)
		return;
	...
	if (cp->cp_wq != rds_wq) {
		destroy_workqueue(cp->cp_wq);

so simply widening the destroy loop would not reach the workqueues either.
The failure path in __rds_conn_create() uses the pre-swap npaths to destroy
all the workqueues, which suggests npaths, not the post-swap transport, is
the real allocation count.

The derivation is harmless in this patch (1 is always <= the allocation),
but would recording the allocated path count in struct rds_connection and
using that here avoid duplicating the derivation in a third place?

>  
>  	WARN_ON(conn->c_trans->t_type != RDS_TRANS_TCP);
>  	if (peer_gen_num != 0) {
>  		if (conn->c_peer_gen_num != 0 &&
>  		    peer_gen_num != conn->c_peer_gen_num) {
> -			for (i = 0; i < RDS_MPATH_WORKERS; i++) {
> +			for (i = 0; i < npaths; i++) {
>  				struct rds_conn_path *cp;
>  
>  				cp = &conn->c_path[i];

[Severity: High]
The new bound stops the walk past the end of c_path[], but does the rest of
this function stay reachable from the same non-TCP peer described in the
changelog?

rds_recv_incoming() dispatches to the handshake parser purely on
peer-supplied header fields, with no transport check:

net/rds/recv.c:rds_recv_incoming() {
	if (be16_to_cpu(inc->i_hdr.h_dport) ==  RDS_FLAG_PROBE_PORT &&
	    inc->i_hdr.h_sport == 0) {
		rds_recv_hs_exthdrs(&inc->i_hdr, cp->cp_conn);

and rds_recv_hs_exthdrs() calls rds_conn_peer_gen_update() unconditionally.
rds_ib_process_recv() hands the wire header straight to rds_recv_incoming(),
and rds_ib_transport sets .t_type = RDS_TRANS_IB, so the WARN_ON above is
true for every crafted probe on an IB connection.

Can that flood dmesg from a remote peer, or panic the box on
panic_on_warn=1 kernels? Would ratelimiting it, or refusing handshake
extension headers on non mp-capable transports, be preferable?

With npaths == 1 the i == 0 iteration is still executed. Two probes with
differing non-zero RDS_EXTHDR_GEN_NUM let the same peer reset
c_path[0].cp_next_tx_seq to 1 and cp_next_rx_seq to 0 and set RDS_MSG_FLUSH
on every message queued on c_path[0].cp_retrans of a live IB connection.

rds_send_probe() only ever emits these headers for t_mp_capable transports:

net/rds/send.c:rds_send_probe() {
	if (RDS_HS_PROBE(be16_to_cpu(sport), be16_to_cpu(dport)) &&
	    cp->cp_conn->c_trans->t_mp_capable) {

so on IB both NPATHS and GEN_NUM are always forged. Would an early return in
rds_recv_hs_exthdrs() for transports without t_mp_capable remove both the
WARN and the c_path[0] state mutation, and make the new bound here
unnecessary?

[Severity: Medium]
This is a pre-existing issue, but the compare-then-store of
conn->c_peer_gen_num in this function happens outside any lock — cp_lock
only covers the per-path queue walk:

	if (peer_gen_num != 0) {
		if (conn->c_peer_gen_num != 0 &&
		    peer_gen_num != conn->c_peer_gen_num) {
			...
		conn->c_peer_gen_num = peer_gen_num;

For a t_mp_capable conn each path has its own cp_wq and receive worker, so
two lanes can run rds_recv_hs_exthdrs(cp->cp_conn) for the same conn at the
same time. Can two probes carrying different generation numbers then either
double-flush or skip the RDS_MSG_FLUSH marking entirely, leaving stale
cp_retrans messages after a peer restart?

> @@ -210,6 +211,7 @@ static void rds_recv_hs_exthdrs(struct rds_header *hdr,
>  	u32 new_peer_gen_num = 0;
>  	int new_npaths;
>  	bool fan_out;
> +	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);

[Severity: Low]
This isn't a bug, but the new declaration is the longest one in the block
and is placed last, which does not follow the reverse xmas tree ordering
netdev asks for. The first hunk of this patch moves int i; below
unsigned long flags; for exactly that reason, so the two hunks disagree.

>  
>  	new_npaths = conn->c_npaths;
>  
> @@ -221,7 +223,7 @@ static void rds_recv_hs_exthdrs(struct rds_header *hdr,
>  		/* Process extension header here */
>  		switch (type) {
>  		case RDS_EXTHDR_NPATHS:
> -			new_npaths = min_t(int, RDS_MPATH_WORKERS,
> +			new_npaths = min_t(int, npaths,
>  					   be16_to_cpu(buffer.rds_npaths));
>  			break;
>  		case RDS_EXTHDR_GEN_NUM:

[Severity: Medium]
This is a pre-existing issue, but conn->c_npaths — now the single
authoritative bound for rds_start_mprds() and rds_check_all_paths() — is
read, tested and published here with no lock, no atomics and no
READ_ONCE()/WRITE_ONCE():

net/rds/recv.c:rds_recv_hs_exthdrs() {
	new_npaths = conn->c_npaths;
	...
	if (new_npaths > 1 && new_npaths != conn->c_npaths) {
	...
	conn->c_npaths = max_t(int, new_npaths, 1);

Since each path of an mp-capable conn has its own receive worker, two lanes
can be in this function for the same conn concurrently. Can one CPU publish
c_npaths = 8 and take the fan-out branch while a second CPU, processing a
probe with no NPATHS extension, writes c_npaths = 1 and silently reverts it
while lanes are still coming up?

The lane mapping in rds_sendmsg() reads the same field with no
synchronisation:

net/rds/send.c:rds_sendmsg() {
		cpath = &conn->c_path[RDS_MPATH_HASH(rs, conn->c_npaths ? : 1)];

so the local and peer lane hashing could disagree. Every stored value still
passes through max_t(int, new_npaths, 1) with new_npaths already clamped, so
this looks like a consistency problem rather than an indexing one — is that
the intended reading?

The comment above rds_recv_hs_exthdrs() only promises serialisation against
other receives on "this specific conn", which for mprds is per-path. Would
WRITE_ONCE()/READ_ONCE() plus per-conn serialisation of handshake
processing be the right follow-up?
