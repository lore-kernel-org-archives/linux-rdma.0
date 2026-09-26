Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18223DBD5E;
	Sat, 26 Sep 2026 09:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790416122; cv=none; b=LIxAMuNhF7A4JQ/yjdNMmPZ55JhHK/FkVNNR/5Ot8D5hxlxlGsIzON3plwwRixrp1kRhn9YN4BrNuYxDS7MI3LyaAWnb5e+4H64rCzZ998WOF9wKpxw6uIvhno50eLK7+YsaDSM9j0o29Q1WnwChozdP8vWSHbRx0bM8MBTWKL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790416122; c=relaxed/simple;
	bh=I6sbss97o1ajB4uJHWmnoFeN5+tpi+P/SceBXpMmNPA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jvm2ZXNto8BJ7BBa2T3DcObrQ/CBG3diz7z0DreV7A9TrrvjAAgpjMaUXXLVaH5q6ugAl/AoM7CG0TgxXNVeN24hjpGZjYq6ifl3g6PuoO8Y//FGhB76kqdwWtiCWHjG0sN5H58wXJD1rgaRED+idZ4UKTF2P9matpFNsnweIjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JxEry+dm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JxEry+dm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCDC1F00898;
	Sat, 26 Sep 2026 09:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790416120;
	bh=aK8hir9Ns6u+oqKgXWNs7makGBVovrRXDsdAfPezZJ8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=JxEry+dm4qvs62RXmaPmXCH0Ss6NtLIM34rx32FPeCWhhQHgmLeZHn/91ux6Sby5v
	 ATyeC/dksIIkpmzBTzxxhWu5FzBkwfKg/8VH8eCAQnp11ZCCi+lEib9ZUbCCd1vZzb
	 msLJyPWKASN2YKyvaGkF/esdMbTHCpXaxT12Qj30MEGV/YzvPuvmO52uftJgtv3uAn
	 bN1oAZbvPSo3eEDGQrxCYyRRBk9+zYebiM/eLsynCAhSJkbYAYbwmdDwwooGKou9ME
	 3kYo/2d70cYHhmy9K5HmbBEA6NOWaYu01sJptnkvbrVxUqFqPRtHavZjdu7jSCDYCc
	 5TqkE47oOf2Hw==
Subject: Re: [PATCH net-next v6 06/12] net/rds: wait for connections to be
 freed on transport unload
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Sat, 26 Sep 2026 09:48:39 +0000
Message-ID: <179041611970.2160803.5875916134713716958@kernel.org>
In-Reply-To: <20260922085410.391323-7-achender@kernel.org>
References: <20260922085410.391323-7-achender@kernel.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] At this commit only, the combination of `list_splice_init()`
  in net/rds/ib_rdma.c:rds_ib_destroy_nodev_conns() (line 168) and the…

--

net/rds: wait for connections to be freed on transport unload

This adds a per-transport live connection count (t_conn_count) that is
incremented when a connection is published in __rds_conn_create() and
decremented at the end of rds_conn_destroy_fini().  The transport exit
paths then poll that count until it reaches zero, with an optional
resweep callback used by the IB transport for connections that are still
detaching from a device.

[ ... ]

> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 9fe3b9951bd32..3fc2de9d19d55 100644
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

[Severity: Medium]
Passing rds_ib_destroy_nodev_conns as the resweep means the list is
emptied again on every 100 ms poll for the whole duration of the unload
wait, rather than just once.  Combined with the list_splice_init()
change below, can that widen a window where rds_ib_add_conn() takes
BUG()?

At this commit rds_ib_add_conn() still asserts that the list head is
non-empty:

net/rds/ib_rdma.c:rds_ib_add_conn() {
	/* conn was previously on the nodev_conns_list */
	spin_lock_irq(&ib_nodev_conns_lock);
	BUG_ON(list_empty(&ib_nodev_conns));
	BUG_ON(list_empty(&ic->ib_node));
	list_del(&ic->ib_node);
	...
}

A connect that was already in flight when the unload started can reach
that assert while the sweep still holds the claimed nodes on its
stack-local tmp_list:

rds_ib_cm_handle_event() (ADDR_RESOLVED/ROUTE_RESOLVED)
  rds_ib_cm_initiate_connect()
    rds_ib_setup_qp()
      rds_ib_add_conn()          <- list_empty(&ib_nodev_conns) == true

The sweep itself calls rds_conn_destroy(), which unhashes the connection
and then blocks in synchronize_rcu() before driving the path to
RDS_CONN_DISCONNECTING, so there is real time spent with the head empty
and the connections still alive.

> +
> +	/* Tearing down the last connection may have dropped the final
> +	 * reference on a device, deferring rds_ib_dev_free() to rds_wq.
> +	 * Drain it before the module goes away; it queues nothing
> +	 * further on rds_wq.
> +	 */
> +	flush_workqueue(rds_wq);
> +
>  	rds_ib_sysctl_exit();
>  	rds_ib_recv_exit();
>  	rds_trans_unregister(&rds_ib_transport);
> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index db7e92e7bd29f..a9b27f06cbfcf 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c
> @@ -165,7 +165,7 @@ void rds_ib_destroy_nodev_conns(void)
>  
>  	/* avoid calling conn_destroy with irqs off */
>  	spin_lock_irq(&ib_nodev_conns_lock);
> -	list_splice(&ib_nodev_conns, &tmp_list);
> +	list_splice_init(&ib_nodev_conns, &tmp_list);
>  	spin_unlock_irq(&ib_nodev_conns_lock);
>  
>  	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node)

[Severity: Medium]
With the old plain list_splice(), ib_nodev_conns was left stale and
non-empty, so the BUG_ON(list_empty(&ib_nodev_conns)) in
rds_ib_add_conn() could not fire during a sweep.  Does re-initializing
the head here make that assert reachable for an ic whose node the sweep
has already moved onto tmp_list?

Worth noting: the next patch in this series, "net/rds: unlink transport
nodes before a possibly deferred connection free", removes both BUG_ONs
from rds_ib_add_conn() and replaces the splice with a per-node
i_ib_node_detached claim, so the end state of the series does not have
this window - it exists only at this intermediate commit, which makes it
a bisection hazard.  Could the assert removal be folded in here, or the
list_splice_init() change moved to the later patch, so no commit in the
series has the reachable BUG()?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260922085410.391323-1-achender%40kernel.org
