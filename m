Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8403444330F;
	Fri, 31 Jul 2026 15:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785511962; cv=none; b=bBW0Bu4LIrV2rj4UEKSFKMxcSGcXg3ehTCioWygVZ5RVKmGV08uZACO4Yo96ypY1bd3ZujZC0awnTQFZGsMel48R7O5Mczy5SXcF9c+k6F22e+hx8SbqpQv3iBKK7COgLDqXjoILYDfHwPYpT6ZJl0rU3Dx4/y+MUdiznV4ZHMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785511962; c=relaxed/simple;
	bh=Vtnr1uAY9Y/vbPc1mZMPaeloBgUeICu0ayEzJVeCjfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hzpuJEHbjjpouwqSvjgKkR00ltz9l9DqT2zAhAsgvCngPMODe0BqLbEkrGq1o05JGW7cWy5y75EkMp3AInUdNlsdfW/+Q7zd82X+glBcyrnO4+HUCEamqOI3Qx/pavbSwlYq8sZXh9B2ZRpNEx37TPqML/UZhEeENtgI9e7gLnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FFvFO/bc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FFvFO/bc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DC81F000E9;
	Fri, 31 Jul 2026 15:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785511950;
	bh=Z5YeMV3FGm0DZBIC4BnPhcRsvnnTDUj64Tp6zkanyz4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FFvFO/bcnqc523irs7ybSl+hIijLyhYzf5Ar+a1i0fed3XjJ16E/4NqxWquB+XbZU
	 AAA+lR09/YE9g8QyrVM6l1FkPyVpLsbGhu3GD1GvvLjBeGVZgT4CA56WuHvis4bQZO
	 q1Z/If4vv0zhWqb56ilWS2ZB8TIj1Rnw3r6i75U78oxjnOBMV0ImmLCe3k5I3tR+GH
	 wre34vBAYNMKcwPEC4TtBJT2snVzw1n7sccznqn2g03r5pfp4dEJP6wI4FOdu/Rcrs
	 X5llidCh/gVFWiw9vaTCMZTG62RYSPlCKAlRHM/VDQ/lmafMJVv3HFhT//h1Vh8DfB
	 A+MePAPH1ubig==
Date: Fri, 31 Jul 2026 16:32:25 +0100
From: Simon Horman <horms@kernel.org>
To: hexlabsecurity@proton.me
Cc: Tony Lu <tonylu@linux.alibaba.com>, Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Hans Wippel <hwippel@linux.ibm.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	Wenjia Zhang <wenjia@linux.ibm.com>, linux-rdma@vger.kernel.org,
	Ursula Braun <ubraun@linux.ibm.com>
Subject: Re: [PATCH net v4] net/smc: order the CDC receive path against
 buffer publication
Message-ID: <20260731153225.GJ51943@horms.kernel.org>
References: <20260728-b4-disp-52ee4e7d-v4-1-0dda94b0f397@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728-b4-disp-52ee4e7d-v4-1-0dda94b0f397@proton.me>

ch This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
Full review at: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260728-b4-disp-52ee4e7d-v4-1-0dda94b0f397@proton.me?part=1
---
--- Patch [1]: [PATCH net v4] net/smc: order the CDC receive path against buffer publication ---
commit 221fd4242cf1b76d00283aa9272cd20d40792017
Author: Bryam Vargas <hexlabsecurity@proton.me>

net/smc: order the CDC receive path against buffer publication

The patch initialises the receive accounting first and then publishes
conn->rmb_desc and the SMC-D DMB-nocopy ghost conn->sndbuf_desc with
smp_store_release(), consuming both with smp_load_acquire() in the CDC
receive handlers and bailing while a buffer is unset.  It also gates the
whole sndbuf consumer trigger in smc_cdc_msg_recv_action() on the send
buffer instead of only the nocopy accounting.

Closes: https://sashiko.dev/#/patchset/20260714-b4-disp-835288a6-v2-1-581555ef2145@proton.me?part=1

A couple of questions about the changelog first.

> Gate the whole sndbuf consumer trigger on the send buffer, not just the
> nocopy accounting: smc_tx_prepared_sends() and smc_tx_pending() dereference it
> too. Conforming peers are unaffected.

Simon says: I believe the issue below is a false-positive

[Severity: Medium]
Is "Conforming peers are unaffected" accurate for the SMC-D nocopy half?

On the server, smc_listen_work() publishes the RMB and calls
smc_ism_set_conn() during smc_listen_ism_init(), then sends the CLC accept
carrying our token, and only reaches smcd_buf_attach() after parsing the
client's CLC confirm:

net/smc/af_smc.c:smc_listen_work() {
	...
	smc_conn_save_peer_info(new_smc, cclc);
	...
	if (ini->is_smcd && smc_ism_support_dmb_nocopy(new_smc->conn.lgr->smcd)) {
		rc = smcd_buf_attach(new_smc);
	...
}

The client (smc_connect_ism()) attaches and goes active as soon as it has
sent its confirm, so its very first CDC can legitimately land while the
server's conn->sndbuf_desc is still NULL - which pre-patch is a NULL
dereference of conn->sndbuf_desc->len via smc_tx_pending() ->
smc_tx_sndbuf_nonempty() -> smc_tx_prepared_sends() when the CDC carries
cons_curs_upd_req or urg_data_pending.  Would it be more accurate to
describe that half as a plain setup race rather than peer misbehaviour?

> Fixes: 69cb7dc0218b ("net/smc: add common buffer size in send and receive buffer descriptors")

Simon says: I didn't look closely into this, but I do susspect a 2nd
            fixes tag is unnecessary.

Since the ghost sndbuf_desc hunks address code introduced by ae2be35cbed2,
should there be a second machine-readable Fixes: tag for it, or the split
into two patches offered in the cover notes?  As it stands the dependency
information for the SMC-D half only exists in the non-persistent notes.

> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index 32d6d03df321..ea61b1e75c72 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -332,8 +332,20 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
>  {
>  	union smc_host_cursor cons_old, prod_old;
>  	struct smc_connection *conn = &smc->conn;
> +	struct smc_buf_desc *sndbuf_desc;
>  	int diff_cons, diff_prod, diff_tx;
>  
> +	/* Acquire the send buffer once, pairing with the smp_store_release() in
> +	 * __smc_buf_create()/smcd_buf_attach().  On the SMC-D DMB-nocopy path
> +	 * the ghost sndbuf_desc is attached only after the connection is already
> +	 * reachable to the ISM device, so it can still be unset here; every
> +	 * sndbuf_desc consumer below (the nocopy accounting and the sndbuf
> +	 * consumer trigger, which dereferences it via smc_tx_prepared_sends())
> +	 * is skipped while it is NULL to avoid a NULL deref and a load of an
> +	 * uninitialised buffer.
> +	 */
> +	sndbuf_desc = smp_load_acquire(&conn->sndbuf_desc);
> +

Simon says: I would appreciate it if you could look into the concern
            described below.

[Severity: High]
Does this single snapshot hold as a guard in the teardown direction too?
The comment says every consumer below "is skipped while it is NULL", but


the value tested is the snapshot while the consumers re-read the live
field:

net/smc/smc_tx.h:smc_tx_prepared_sends() {
	...
	return smc_curs_diff(conn->sndbuf_desc->len, &sent, &prep);
}

and smc_tx_pending() -> smc_tx_sndbuf_nonempty() -> smc_tx_rdma_writes()
dereference conn->sndbuf_desc again as well.

conn->sndbuf_desc is not monotone.  smcd_buf_detach() frees it and clears
the field:

net/smc/smc_core.c:smcd_buf_detach() {
	...
	smc_ism_detach_dmb(smcd, peer_token);

	kfree(conn->sndbuf_desc);
	conn->sndbuf_desc = NULL;
}

and it is called before the tasklet is stopped:

net/smc/smc_core.c:smc_conn_free() {
	...
	if (lgr->is_smcd) {
		if (!list_empty(&lgr->list))
			smc_ism_unset_conn(conn);
		if (smc_ism_support_dmb_nocopy(lgr->smcd))
			smcd_buf_detach(conn);
		tasklet_kill(&conn->rx_tsklet);
	...
}

smc_ism_unset_conn() only stops smcd_handle_irq() from scheduling new work,
and conn->killed is 0 on a normal close, so the early bail in
smcd_cdc_rx_tsklet() does not help.  smc_cdc_msg_recv() takes only
bh_lock_sock(), which does not exclude a process-context lock_sock() owner
(that is why the function itself tests sock_owned_by_user()).

So can an already running smcd_cdc_rx_tsklet() take a non-NULL snapshot
here, have smcd_buf_detach() kfree() the descriptor underneath it, and then
read freed slab memory in the diff_tx computation below and/or NULL-deref
conn->sndbuf_desc inside smc_tx_prepared_sends()?

The underlying teardown race predates the patch, but two things change
here: the comment now documents protection that only exists for the
NULL -> non-NULL setup transition, and moving the load to function entry
means sndbuf_desc->len can be dereferenced even after the live field has
already been set to NULL, so the freed-pointer read window is wider than
before.  Would loading and testing conn->sndbuf_desc at each point of use
(or fixing the ordering, see the smcd_buf_attach() hunk below) be closer to
what the comment claims?

>  	smc_curs_copy(&prod_old, &conn->local_rx_ctrl.prod, conn);
>  	smc_curs_copy(&cons_old, &conn->local_rx_ctrl.cons, conn);
>  	smc_cdc_msg_to_host(&conn->local_rx_ctrl, cdc, conn);
> @@ -351,14 +363,17 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
>  
>  		/* if local sndbuf shares the same memory region with
>  		 * peer RMB, then update tx_curs_fin and sndbuf_space
> -		 * here since peer has already consumed the data.
> +		 * here since peer has already consumed the data.  The ghost
> +		 * sndbuf_desc (acquired above) may still be unset in the SMC-D
> +		 * DMB-nocopy setup window, so skip the update while it is NULL.
>  		 */
>  		if (conn->lgr->is_smcd &&
> -		    smc_ism_support_dmb_nocopy(conn->lgr->smcd)) {
> +		    smc_ism_support_dmb_nocopy(conn->lgr->smcd) &&
> +		    sndbuf_desc) {
>  			/* Calculate consumed data and
>  			 * increment free send buffer space.
>  			 */
> -			diff_tx = smc_curs_diff(conn->sndbuf_desc->len,
> +			diff_tx = smc_curs_diff(sndbuf_desc->len,
>  						&conn->tx_curs_fin,
>  						&conn->local_rx_ctrl.cons);
>  			/* increase local sndbuf space and fin_curs */
> @@ -391,10 +406,15 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
>  			conn->urg_state = SMC_URG_NOTYET;
>  	}
>  

Simon says: The concern below seems to be pre-existing and
            I don't think it should block progress of this patch.

[Severity: Critical]
This isn't a bug introduced by this patch, but the urgent-data arm of the
same receive path looks like it reads outside the RMB.  In
smc_cdc_handle_urg_data_arrival():

net/smc/smc_cdc.c:smc_cdc_handle_urg_data_arrival() {
	smc_curs_copy(&conn->urg_curs, &conn->local_rx_ctrl.prod, conn);
	...
	base = (char *)conn->rmb_desc->cpu_addr + conn->rx_off;
	if (conn->urg_curs.count)
		conn->urg_rx_byte = *(base + conn->urg_curs.count - 1);
	else
		conn->urg_rx_byte = *(base + conn->rmb_desc->len - 1);
	...
}

conn->local_rx_ctrl.prod comes straight from the peer's CDC, and the only
validation applied is a monotonicity test:

net/smc/smc_cdc.h:smc_cdc_cursor_to_host() {
	temp.count = ntohl(net.count);
	temp.wrap = ntohs(net.wrap);
	if ((old.wrap > temp.wrap) && temp.wrap)
		return;
	if ((old.wrap == temp.wrap) && (old.count > temp.count))
		return;
	smc_curs_copy(local, &temp, conn);
}

Nothing bounds count against conn->rmb_desc->len, and smc_curs_diff() only
clamps the difference to >= 0.  Can a peer that advances prod.count to an
arbitrary value with prod_flags.urg_data_present set make the kernel read
one byte up to ~4 GiB past the RMB, which is then handed to userspace by
smc_rx_recv_urg() via memcpy_to_msg(msg, &conn->urg_rx_byte, 1) - or fault
on an unmapped address?  Should the cursor magnitude be validated against
conn->rmb_desc->len in smc_cdc_cursor_to_host()/smcd_cdc_msg_to_host()?

> -	/* trigger sndbuf consumer: RDMA write into peer RMBE and CDC */
> -	if ((diff_cons && smc_tx_prepared_sends(conn)) ||
> -	    conn->local_rx_ctrl.prod_flags.cons_curs_upd_req ||
> -	    conn->local_rx_ctrl.prod_flags.urg_data_pending) {
> +	/* trigger sndbuf consumer: RDMA write into peer RMBE and CDC.
> +	 * smc_tx_prepared_sends() and smc_tx_pending() dereference sndbuf_desc,
> +	 * so skip the whole trigger while it is unset (the SMC-D DMB-nocopy
> +	 * setup window): there is nothing to send without a send buffer.
> +	 */
> +	if (sndbuf_desc &&
> +	    ((diff_cons && smc_tx_prepared_sends(conn)) ||
> +	     conn->local_rx_ctrl.prod_flags.cons_curs_upd_req ||
> +	     conn->local_rx_ctrl.prod_flags.urg_data_pending)) {

Simon says: The issue raised below does seem to be of concern.
            Could you take a look?

[Severity: High]
This is the check-vs-use split described above: the gate tests the entry
snapshot, while smc_tx_prepared_sends(conn) and smc_tx_pending(conn) both
re-read conn->sndbuf_desc.  Is there anything preventing the live field
from having become NULL (and the snapshot dangling) between the two?

>  		if (!sock_owned_by_user(&smc->sk))
>  			smc_tx_pending(conn);
>  		else
> @@ -443,13 +463,21 @@ static void smcd_cdc_rx_tsklet(struct tasklet_struct *t)
>  {
>  	struct smc_connection *conn = from_tasklet(conn, t, rx_tsklet);
>  	struct smcd_cdc_msg *data_cdc;
> +	struct smc_buf_desc *rmb_desc;
>  	struct smcd_cdc_msg cdc;
>  	struct smc_sock *smc;
>  
>  	if (!conn || conn->killed)
>  		return;
> +	/* Pair with smp_store_release() in __smc_buf_create(): the connection
> +	 * is published before its RMB is allocated, so bail while rmb_desc is
> +	 * unset to avoid a NULL deref and a load of an uninitialised buffer.
> +	 */
> +	rmb_desc = smp_load_acquire(&conn->rmb_desc);
> +	if (!rmb_desc)
> +		return;

Simon says: I don't think the concern below should block progress of this patch.

[Severity: Low]
Can this branch ever be taken on the SMC-D path?  The tasklet is only
scheduled from smcd_handle_irq():

net/smc/smc_ism.c:smcd_handle_irq() {
	...
	conn = smcd->conn[dmbno];
	if (conn && !conn->killed)
		tasklet_schedule(&conn->rx_tsklet);
	...
}

and that array slot is only ever filled by smc_ism_set_conn(), which itself
reads conn->rmb_desc->sba_idx and which this patch keeps after the release
store in __smc_buf_create().  Both the slot store and the slot load happen
under smcd->lock, so rmb_desc is already visible by the time the tasklet
runs.

On the teardown side there is no conn->rmb_desc = NULL assignment anywhere
in net/smc, and smc_ism_unset_conn() plus tasklet_kill()/
tasklet_unlock_wait() precede smc_buf_unuse().

So is the comment's rationale ("the connection is published before its RMB
is allocated") describing the SMC-R token-tree window rather than this
path?  For a Cc: stable patch, would it be better to either state the real
reason or drop this hunk, given that the genuine unpublished-buffer window
on SMC-D is the ghost sndbuf_desc?

>  
> -	data_cdc = (struct smcd_cdc_msg *)conn->rmb_desc->cpu_addr;
> +	data_cdc = (struct smcd_cdc_msg *)rmb_desc->cpu_addr;
>  	smcd_curs_copy(&cdc.prod, &data_cdc->prod, conn);
>  	smcd_curs_copy(&cdc.cons, &data_cdc->cons, conn);
>  	smc = container_of(conn, struct smc_sock, conn);
> @@ -483,7 +511,11 @@ static void smc_cdc_rx_handler(struct ib_wc *wc, void *buf)
>  	lgr = smc_get_lgr(link);
>  	read_lock_bh(&lgr->conns_lock);
>  	conn = smc_lgr_find_conn(ntohl(cdc->token), lgr);
> -	if (!conn || conn->out_of_sync) {
> +	/* Pair with smp_store_release() in __smc_buf_create(): bail while the
> +	 * RMB is unset (smc_cdc_msg_recv_action() dereferences it) to avoid a
> +	 * NULL deref and a stale-buffer read in the connection setup window.
> +	 */
> +	if (!conn || conn->out_of_sync || !smp_load_acquire(&conn->rmb_desc)) {
>  		read_unlock_bh(&lgr->conns_lock);
>  		return;
>  	}

Simon says: ditto

[Severity: Low]
This isn't a bug today, but the rmb_desc invariant now lives in the two
entry points while the dereferences stay in the callees:
smc_cdc_msg_recv_action() reads conn->rmb_desc->len with a plain load, and
smc_cdc_handle_urg_data_arrival() reads conn->rmb_desc->cpu_addr and
conn->rmb_desc->len.  That is also inconsistent with the sndbuf_desc
handling in the same patch, which loads and checks locally.

Would a single load plus check inside smc_cdc_msg_recv_action(), or one
helper used by both entry points, keep the invariant next to the
dereference?

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index b4208cb186c5..33bf9cc979ef 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -2499,15 +2499,26 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
>  	}
>  
>  	if (is_rmb) {
> -		conn->rmb_desc = buf_desc;
>  		conn->rmbe_size_comp = bufsize_comp;
>  		smc->sk.sk_rcvbuf = bufsize * 2;
>  		atomic_set(&conn->bytes_to_rcv, 0);
>  		conn->rmbe_update_limit =
>  			smc_rmb_wnd_update_limit(buf_desc->len);
> +		/* Publish the receive buffer last, with release semantics: the
> +		 * connection is already in the link group's token tree, so a
> +		 * concurrent CDC receive handler must observe the fully
> +		 * initialised receive state above (and the buffer) once it sees
> +		 * a non-NULL rmb_desc.  Pairs with the smp_load_acquire() in the
> +		 * CDC receive path.
> +		 */
> +		smp_store_release(&conn->rmb_desc, buf_desc);

Simon says: ditto

[Severity: Medium]
Is "the fully initialised receive state" too strong here?  It looks true
only for the four assignments immediately above the release store.

conn->peer_rmbe_size, conn->peer_rmbe_idx, conn->tx_off and the initial
atomic_set(&conn->peer_rmbe_space, ...) are assigned later, in
smcr_conn_save_peer_info()/smcd_conn_save_peer_info(), which run after
smc_buf_create() on the SMC-D connect path and on the listen path; on both
connect paths smc_rx_init()/smc_tx_init() also run after publication.

A CDC that now passes the new rmb_desc gate in that window still executes:

net/smc/smc_cdc.c:smc_cdc_msg_recv_action() {
	...
	diff_cons = smc_curs_diff(conn->peer_rmbe_size, &cons_old,
				  &conn->local_rx_ctrl.cons);
	...
}

with conn->peer_rmbe_size == 0, still atomic_add()s into
conn->peer_rmbe_space which setup then clobbers with atomic_set(), can
still set conn->urg_state = SMC_URG_NOTYET before smc_rx_init() overwrites
it with SMC_URG_READ, can still call the pre-SMC sk_data_ready
(sock_def_readable rather than smc_rx_wake_up), and can leave peer-chosen
cursors in conn->local_rx_ctrl that setup never re-initialises.

So the "lost update by setup" class the changelog describes appears to be
eliminated only for bytes_to_rcv and sndbuf_space.  Would a single
readiness flag published once setup completes, or deferring the token-tree
insertion and smc_ism_set_conn() until the connection is fully
initialised, cover the buffers and the remaining state with one barrier?
At minimum, could the comment be narrowed to the fields it actually
orders?

>  		if (is_smcd)
>  			smc_ism_set_conn(conn); /* map RMB/smcd_dev to conn */
>  	} else {
> +		/* Plain store: this send-buffer pass runs before the RMB pass,
> +		 * whose smp_store_release(&conn->rmb_desc) then publishes this
> +		 * store too, and the CDC receive path is gated on rmb_desc.
> +		 */
>  		conn->sndbuf_desc = buf_desc;
>  		smc->sk.sk_sndbuf = bufsize * 2;
>  		atomic_set(&conn->sndbuf_space, bufsize);
> @@ -2599,9 +2610,16 @@ int smcd_buf_attach(struct smc_sock *smc)
>  	buf_desc->cpu_addr =
>  		(u8 *)buf_desc->cpu_addr + sizeof(struct smcd_cdc_msg);
>  	buf_desc->len -= sizeof(struct smcd_cdc_msg);
> -	conn->sndbuf_desc = buf_desc;
> -	conn->sndbuf_desc->used = 1;
> -	atomic_set(&conn->sndbuf_space, conn->sndbuf_desc->len);
> +	buf_desc->used = 1;
> +	atomic_set(&conn->sndbuf_space, buf_desc->len);
> +	/* Publish the ghost send buffer last, with release semantics: the
> +	 * connection is already reachable to the ISM device (smc_ism_set_conn()
> +	 * ran in __smc_buf_create()), so the CDC receive tasklet must observe
> +	 * the fully initialised ghost buffer once it sees a non-NULL
> +	 * sndbuf_desc.  Pairs with smp_load_acquire() in
> +	 * smc_cdc_msg_recv_action().
> +	 */
> +	smp_store_release(&conn->sndbuf_desc, buf_desc);

Simon says: I would appreciate it if you could take a look into
            the issue raised below.

[Severity: High]
This is a pre-existing issue, but should the unpublish side be fixed in
the same series, since this patch establishes the publication protocol for
the ghost buffer?  Only the publish side gains ordering; the free side
gets neither ordering nor a wait for the consumer:

net/smc/smc_core.c:smcd_buf_detach() {
	...
	smc_ism_detach_dmb(smcd, peer_token);

	kfree(conn->sndbuf_desc);
	conn->sndbuf_desc = NULL;
}

and both callers free before cancelling the consumer:

net/smc/smc_core.c:smc_conn_free() {
	...
		if (smc_ism_support_dmb_nocopy(lgr->smcd))
			smcd_buf_detach(conn);
		tasklet_kill(&conn->rx_tsklet);
	...
}

net/smc/smc_core.c:smc_conn_kill() {
	...
		if (smc_ism_support_dmb_nocopy(conn->lgr->smcd))
			smcd_buf_detach(conn);
		if (soft)
			tasklet_kill(&conn->rx_tsklet);
		else
			tasklet_unlock_wait(&conn->rx_tsklet);
	...
}

smc_conn_kill() runs from the link group terminate worker with no socket
lock at all, and smc_cdc_msg_recv() only takes bh_lock_sock(), so there is
no common lock serialising conn->sndbuf_desc against an in-flight
smcd_cdc_rx_tsklet().

Would stopping the tasklet before detaching and freeing the ghost buffer,
mirroring the publish-last ordering introduced here, close this?

>  	return 0;
>  
>  free:
