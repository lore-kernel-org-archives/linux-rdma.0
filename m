Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A4A4477FD;
	Wed, 23 Sep 2026 07:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790147504; cv=none; b=LV0QtRfhdKsHMbr6slIUxxhgtmqwKZX0eXPK7W/Tf/Y/yWlXW8eTi/lhKhghmF4Md6bqJB92NFsePnTRqANczxpF5QmwjGxA1K5kcjmbFPxO6sFZS9zhKVB4sZY6JfjTedhbu4Pua+YQ3yL1OxertBmh6lzUVwbl4vFbMCU+1M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790147504; c=relaxed/simple;
	bh=Y5JWNo6q6XpnMlzT0YqMdr8FZrRigCQ59VoksfVY/L0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DUH85ysVP3a5pWDlUAkj8ysIe1bzfNkOR0Z4prg6R2C/ZGZ1ZrS1CmCijhFx9uUneyzy6+MDJJjnIn2Ft4rPw9jtFe6gWKpvkVQVzpSCjiw3kQcoGPok1oa218o+q1nAPE6r8cPD3tcwLmT+8QW6pW1V3837wBPuuIkDTq+dEoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lwWZi/w2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lwWZi/w2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035871F000FF;
	Wed, 23 Sep 2026 07:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790147498;
	bh=ocOVWbHn9oxRnNEYo0BnO1C3F8xDZUcsYZ8CSX4RWAY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=lwWZi/w2fV5YXhu8kDEy4uym8suph5eFgVjLs6g3AZLQ65kwHyqtjDt//BCw5iqxS
	 DJM3aG2ErYmVu/X1gV7oswM8ZPukT3clgjn95DchJG6RRrs1gJnt3HzG/U0O4FkCj8
	 Hj0xaVBDs4YNFGAS1WepUv6gqsOf+/1A/aciqQI4RMk6Y6hoHbN9DeQiiQ5/vZZMYr
	 3pdUWJ1qgkpYgXDErRJ1wyEkNQzNzALmF/ZJFAuvdN58Wtvj9X6hnbOerPICcs2jdM
	 X29WNKeZ7GPXfBkBvAdhTEAtq1n59L1D8KQPDBEadtioOHA3kiQsVzUYzHBbjX5BUJ
	 h7FMGeecU1tIw==
Subject: Re: [PATCH net-next v5 06/12] net/rds: wait for connections to be
 freed on transport unload
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Wed, 23 Sep 2026 07:11:37 +0000
Message-ID: <179014749757.2160803.18035512577859783810@kernel.org>
In-Reply-To: <20260919061149.250658-7-achender@kernel.org>
References: <20260919061149.250658-7-achender@kernel.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] This patch makes rds_ib_destroy_nodev_conns() leave
  ib_nodev_conns genuinely empty (list_splice_init(),…
- [Low] At this commit nothing makes a queued incoming datagram hold a
  connection reference: rds_inc_init()/rds_inc_path_init()…
- [Low] The commit message justifies the new wait with reference holders
  that do not exist at this commit and describes them in the present…

--

net/rds: wait for connections to be freed on transport unload

This adds a per-transport live connection count (t_conn_count), bumped when
a connection is published in __rds_conn_create() and dropped as the last
step of rds_conn_destroy_fini(), and makes rds_ib_exit(), rds_tcp_exit()
and rds_loop_exit() poll-wait for that count to reach zero before
unloading.  rds_ib_exit() passes rds_ib_destroy_nodev_conns() as a resweep
callback so connections that migrate to ib_nodev_conns late still get
destroyed, and flushes rds_wq afterwards.

A couple of questions below, one on the commit message and two on the code.

[Severity: Low]
The commit message describes two reference holders in the present tense:

    "so a free that is still pending (a racing lookup-style holder, or
     simply the destroyer's own put not yet run when destroy was invoked
     from another context earlier) would execute transport module code
     after that module's text is gone."

and

    "a CM event handler's reference is always dropped before the
     rdma_destroy_id() in the connection's own shutdown returns"

Do either of those holders exist at this commit?  At 130d1507 the kref is
initialized to 1 in __rds_conn_create(), and grepping net/rds finds no
caller of rds_conn_get() or rds_conn_get_unless_zero() at all - only the
definition in net/rds/connection.c and the declaration in net/rds/rds.h.

The lookup references arrive with "net/rds: hold connection references in
lookup, sockets and c_passive" and the CM handler reference with "net/rds:
pin the connection across RDMA-CM event handling", both later in the
series.

The inc dependency is already flagged as future work ("once the following
patches make incs hold a connection reference"), so would it be worth
qualifying these two the same way, since the wait is effectively a no-op at
this commit?

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index a44aa4d2a5e8..1d48da1a794f 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c

[ ... ]

> @@ -596,7 +601,52 @@ static void rds_conn_destroy_fini(struct kref *kref)
>  	spin_lock_irqsave(&rds_conn_lock, flags);
>  	rds_conn_count--;
>  	spin_unlock_irqrestore(&rds_conn_lock, flags);
> +
> +	/* only after everything the transport module owns has been
> +	 * freed above may its unload proceed
> +	 */
> +	if (!atomic_dec_return(&trans->t_conn_count))
> +		wake_up_all(&rds_conn_freed_waitq);
> +}
> +
> +/* Wait for all of @trans's connections to be freed; the free runs
> + * asynchronously once rds_conn_destroy() has quiesced a connection.
> + * Called on transport module unload, after the transport has destroyed
> + * all of its connections.  A connection reference can be held for an
> + * application-controlled time - once incs hold one, an unread datagram
> + * pins the inc that carries it, and thus the connection - so the wait
> + * is unbounded: the
> + * frees that run after unload call into this module's text (conn_free,
> + * inc_free) and free into its slabs, so proceeding while any remain
> + * would be a use-after-free, not a leak.  Warn periodically so a stuck
> + * count is diagnosable, but never stop waiting.  This matches the
> + * historical RDS contract that teardown does not discard queued data.
> + */

[Severity: Low]
Does this comment describe a guarantee that is not yet in force at this
commit?  It states that the wait covers inc_free and the transport's slabs,
but nothing here makes a queued incoming datagram hold a connection
reference yet.

net/rds/recv.c:rds_inc_path_init() only stores the pointer:

    inc->i_conn = cp->cp_conn;

and rds_inc_put() dereferences it without a matching put:

    inc->i_conn->c_trans->inc_free(inc);

So t_conn_count does not account for unread datagrams at this commit, and
rds_conn_wait_conns_freed() can return with incs still queued, after which
rds_tcp_exit()/rds_ib_exit() go on to rds_trans_unregister() and slab
teardown (rds_ib_recv_exit() even WARN_ONs on rds_ib_allocation and
destroys rds_ib_incoming_slab/rds_ib_frag_slab).

The gap is closed later in the series by "net/rds: hold a connection
reference from struct rds_incoming", which adds the rds_conn_get() in
rds_inc_init()/rds_inc_path_init() and the matching rds_conn_put() in
rds_inc_put().  Would it read better to phrase the inc part of this comment
the same way the commit message does, as something the following patches
establish?

Also, the line wrapping in the middle of that comment looks accidental:

    * is unbounded: the
    * frees that run after unload call into this module's text

> +void rds_conn_wait_conns_freed(struct rds_transport *trans,
> +			       void (*resweep)(void))
> +{
> +	unsigned long warn_interval =
> +			msecs_to_jiffies(RDS_CONN_FREE_WARN_INTERVAL_MS);
> +	unsigned long warn_at = jiffies + warn_interval;
> +
> +	while (!wait_event_timeout(rds_conn_freed_waitq,
> +				   !atomic_read(&trans->t_conn_count),
> +				   msecs_to_jiffies(RDS_CONN_FREE_POLL_MS))) {
> +		/* A transport whose teardown is asynchronous (IB moves a
> +		 * connection off its device from the shutdown work) gives
> +		 * us a resweep to destroy what has arrived since.
> +		 */
> +		if (resweep)
> +			resweep();

[ ... ]

> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 9fe3b9951bd3..3fc2de9d19d5 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -537,7 +537,24 @@ void rds_ib_exit(void)
>  	rds_info_deregister_func(RDS6_INFO_IB_CONNECTIONS, rds6_ib_ic_info);
>  #endif
>  	rds_ib_unregister_client();
> +
> +	/* rds_ib_dev_shutdown() only dropped the connections still
> +	 * attached to a device; each moves itself to ib_nodev_conns
> +	 * from its shutdown work.  Destroy what is there now and keep
> +	 * sweeping the list while the wait sees connections outstanding,
> +	 * so a late arrival is destroyed rather than waited on forever.
> +	 */
>  	rds_ib_destroy_nodev_conns();
> +	rds_conn_wait_conns_freed(&rds_ib_transport,
> +				  rds_ib_destroy_nodev_conns);

[ ... ]

> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index db7e92e7bd29..a9b27f06cbfc 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c
> @@ -165,7 +165,7 @@ void rds_ib_destroy_nodev_conns(void)
>  
>  	/* avoid calling conn_destroy with irqs off */
>  	spin_lock_irq(&ib_nodev_conns_lock);
> -	list_splice(&ib_nodev_conns, &tmp_list);
> +	list_splice_init(&ib_nodev_conns, &tmp_list);
>  	spin_unlock_irq(&ib_nodev_conns_lock);

[Severity: Medium]
Can this panic a machine that is establishing an IB connection while
rds_rdma is unloading?  rds_ib_add_conn() in the same file still opens
with:

    spin_lock_irq(&ib_nodev_conns_lock);
    BUG_ON(list_empty(&ib_nodev_conns));
    BUG_ON(list_empty(&ic->ib_node));

Before this change, list_splice() left the ib_nodev_conns head pointing at
the spliced entries, so it never looked empty and the first BUG_ON could
not fire.  With list_splice_init() the head is genuinely empty after a
sweep.

A connect still in flight can reach rds_ib_add_conn() after that point.
rds_ib_get_client_data() drops the RCU section as soon as it has the
device reference:

    rcu_read_lock();
    rds_ibdev = ib_get_client_data(device, &rds_ib_client);
    if (rds_ibdev)
            refcount_inc(&rds_ibdev->refcount);
    rcu_read_unlock();

so the synchronize_rcu() in rds_ib_remove_one() does not wait for that
caller, and rds_ib_setup_qp() then calls:

    /* add the conn now so that connection establishment has the dev */
    rds_ib_add_conn(rds_ibdev, conn);

The resweep callback passed from rds_ib_exit() re-empties ib_nodev_conns on
every 100 ms poll for the whole unbounded wait, so this is not a single
instant but the full duration of the wait.

The BUG_ONs in rds_ib_add_conn() are removed later in the series by
"net/rds: unlink transport nodes before a possibly deferred connection
free", which replaces them with the ic->i_ib_node_detached check, so only
this intermediate commit is exposed.  Would it make sense to order those
two changes the other way around, so the tree does not panic at this step
of a bisect?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260919061149.250658-1-achender%40kernel.org
