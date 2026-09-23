Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF66D44C50E;
	Wed, 23 Sep 2026 07:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790147505; cv=none; b=JYq9HA6hE/8qtc98XUaZhMBcK0U/VUIaDodzDb8iAM/kgYefQKQ6rki6NlhCTztQFXb93wHJTZnCmt3QRl9Uu4iMdwWM/2VRP6rzqvrtGGpR6dm4XNwEnh95KNysYa4nTPrdt++9EBbSU9GlycJ6sTTK/kFg7Q0C9noUWe7wU40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790147505; c=relaxed/simple;
	bh=csXXt9PlErmFsum9abhDWfvLtDfpFx9yr8dmu2qPmew=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dAZGgPF2MgT319eqfiEexRfJXFndE+tu3n5NLklpn3E6Q9GMQ3nw59jlA0VVd/6e4T66UiWdBCAmMY8lk2+CDneQ/ntE4DrHg4SYim4V1qAeJp0HGghoM1Zs0xQY3D9YRWPxAVsFQ3qQeWp3Qf1C2T4Jwlzj7iMnlt75IqBdcjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xqls9thQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xqls9thQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BD41F0089C;
	Wed, 23 Sep 2026 07:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790147503;
	bh=KDeGd0k5M2qQos7MbfV7qpFjjecHWphsOT0Yr9vZUWU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Xqls9thQuJR0f9QK/mOd5dHj9cjwvZDsdsmiLcz9iz6HwJ6YNT1+XvPreUt1nsUWQ
	 G4rmNC8VtL7D1X+uKay1aRPQ8nnXailwRQ+EqeVffWmP4vVrUxovLaQIvkgsmDL5k+
	 quk3sadZoEev7CnNm+K4E06lTbKi++2Zctv7t7MajcnHQQZhgSe7MTlpHNk9Eznl3E
	 VZUrze7q53soBMpHz+o8NvqgY4eIv+4+94x2xMxGSLEebjQ3d8MwYYyFdZTmpoB8+C
	 0B6IHnVfMy6iOQXypf0vhpQ42jlbS5j9WgN4ZfS/pzWOqPOcZsYlf6mwM5M794v1FC
	 awmH7pelcjTEg==
Subject: Re: [PATCH net-next v5 12/12] net/rds: hold a connection reference
 from struct rds_incoming
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Wed, 23 Sep 2026 07:11:42 +0000
Message-ID: <179014750256.2160803.7768011493453297137@kernel.org>
In-Reply-To: <20260919061149.250658-13-achender@kernel.org>
References: <20260919061149.250658-13-achender@kernel.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] Making every socket-queued `rds_incoming` own a connection
  reference (`rds_inc_init()`/`rds_inc_path_init()`,…
- [Low] The patch fixes a real, user-visible use-after-free
  (`rds6_inc_info_copy()` reading `inc->i_conn` after…

--

net/rds: hold a connection reference from struct rds_incoming

Every site that stores a connection pointer in rds_incoming->i_conn now
takes a connection reference, and the reference is dropped from
rds_inc_put() and from a new rds_message_free() helper.  This closes the
reported use-after-free where an inc queued on a socket outlives the
connection it points at.

Closes: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/

Two questions below, one about the commit trailers and one about the
lifetime this introduces.

The changelog documents a confirmed KASAN slab-use-after-free and carries
Reported-by:/Closes: for it:

>     Reported-by: Chengfeng Ye <nicoyip.dev@gmail.com>
>     Closes: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/

[Severity: Low]
Should this also carry a Fixes: tag naming the commit that introduced the
bare receive-side assignment in rds_inc_init()?

Other bug fixes in this series do carry one, for example "net/rds: guard
every work-requeueing site with rds_destroy_pending()" with
Fixes: ebeeb1ad9b8a and "net/rds: make rds_destroy_pending() cover
single-connection destroy" with Fixes: cdc306a5c9cd3, so the omission
looks inconsistent within the series.

The explanation for why this is not stable material could stay in the
changelog next to the tag.

> diff --git a/net/rds/recv.c b/net/rds/recv.c
> index 6204e577a90a..1fcd4483d3be 100644
> --- a/net/rds/recv.c
> +++ b/net/rds/recv.c
> @@ -46,6 +46,7 @@ void rds_inc_init(struct rds_incoming *inc, struct rds_connection *conn,
>  {
>  	refcount_set(&inc->i_refcount, 1);
>  	INIT_LIST_HEAD(&inc->i_item);
> +	rds_conn_get(conn);	/* put in rds_inc_put() */
>  	inc->i_conn = conn;
>  	inc->i_conn_path = NULL;
>  	inc->i_saddr = *saddr;
> @@ -61,6 +62,7 @@ void rds_inc_path_init(struct rds_incoming *inc, struct rds_conn_path *cp,
>  {
>  	refcount_set(&inc->i_refcount, 1);
>  	INIT_LIST_HEAD(&inc->i_item);
> +	rds_conn_get(cp->cp_conn);	/* put in rds_inc_put() */
>  	inc->i_conn = cp->cp_conn;
>  	inc->i_conn_path = cp;
>  	inc->i_saddr = *saddr;

[Severity: Medium]
With a reference now attached to every received inc, does this hand an
unprivileged reader control over how long rds_conn_wait_conns_freed()
blocks?

The reference taken here is released only from rds_inc_put(), which runs
from rds_recvmsg() or from rds_clear_recv_queue() on close, so an
application that simply never reads a queued datagram keeps the
connection allocated.

rds_conn_wait_conns_freed() then has no way out:

net/rds/connection.c:rds_conn_wait_conns_freed() {
	while (!wait_event_timeout(rds_conn_freed_waitq,
				   !atomic_read(&trans->t_conn_count),
				   msecs_to_jiffies(RDS_CONN_FREE_POLL_MS))) {
		...
		if (time_after_eq(jiffies, warn_at)) {
			pr_warn("RDS/%s: still waiting for %d connection(s) to be freed before unload\n",
				...
}

That wait is uninterruptible and is reached from module unload paths,
rds_tcp_exit() -> rds_conn_wait_conns_freed(), rds_ib_exit() and
rds_loop_exit(), so the unloading task sits in D state until the
application reads or closes, and the module stays in MODULE_STATE_GOING
in the meantime.

A bound socket holds a module reference on its own transport through
rds_trans_get_preferred(), but rds_find_bound() does not filter on
transport.  Can a datagram that arrived over, say, a TCP connection sit
unread on a socket whose rs_transport is a different module, so that
rmmod rds_tcp hangs rather than failing with -EBUSY?

Would it make sense to bound the wait, discard or quarantine the incs
still queued at teardown, or hold a module reference for queued incs so
unload fails instead of blocking?

>  	memset(inc->i_rx_lat_trace, 0, sizeof(inc->i_rx_lat_trace));
>  }
> @@ -81,9 +83,19 @@ void rds_inc_put(struct rds_incoming *inc)
>  {
>  	rdsdebug("put inc %p ref %d\n", inc, refcount_read(&inc->i_refcount));
>  	if (refcount_dec_and_test(&inc->i_refcount)) {
> +		struct rds_connection *conn = inc->i_conn;
> +
>  		BUG_ON(!list_empty(&inc->i_item));
>  
> -		inc->i_conn->c_trans->inc_free(inc);
> +		/* inc_free() can free the memory @inc lives in, so the
> +		 * connection reference has to be dropped through the
> +		 * copy taken above.
> +		 */
> +		conn->c_trans->inc_free(inc);
> +		/* get in rds_inc_init(), rds_inc_path_init() or
> +		 * rds_recv_incoming()
> +		 */
> +		rds_conn_put(conn);
>  	}
>  }
>  EXPORT_SYMBOL_GPL(rds_inc_put);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260919061149.250658-1-achender%40kernel.org
