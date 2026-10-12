Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3135F155C97;
	Mon, 12 Oct 2026 04:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791778668; cv=none; b=ZAE3c06tYgdQB2UnYIzjpGvpFF0+YEoR5QeV5tLAq3kxWc81N8mT++wMyn1VyloBZwp7Bhz6rO2nnNtK0MRsGDg0kQ2ACYMXPWkcWrsO7klSIguZ0yw6/1qY1eZ3a7VilSG1Vqf6B6xskvW1sVQHv7gkm2lWQgA2wD1lRz+XDfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791778668; c=relaxed/simple;
	bh=DFHFVWHuqqYhGKXZI20bh7F7yjNe5UY1cFsjAuoa7mI=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=doTh1Sxe+kfi/fNANEkcML2BO8xidQGFKjJKCCs0CvTMPCbWNkRgNrgQWaiGToJrmvHmAMj0wS/DouUYpG0Pqq5D47DNo7IF4ZEcmd9GRXFkjRlvRBbpxm2lWUhfP6PGYcGrEqfYeVr3I/zDL6tkLAPy5Xfa91NWnr4DRGX7kkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IN9+gMKh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IN9+gMKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA801F0089B;
	Mon, 12 Oct 2026 04:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791778666;
	bh=voTQcbK2rhpq4sBDXOJHyo9A6Ovzvj/afxUhhfOFDJ8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=IN9+gMKhl+5HTa8e9mCplWuLNO3ThJsbkwIdrlLLxVIxxVa7xiJvgWiPkIvmo1uvT
	 F4XcP83IXpy4ji0mK/iZT/pwiA7XYNNfy0T5GEDz6/gwFGizf1giCcv6MMM5I310ZF
	 T/YMkB844d5ECdBPXu7e49SqNIIUsN6jnpOONctrpeY3iDyN9tMRL4jpk9NhXgW6Or
	 ZW0E81P8BeqfM1gAPFU121TdOJUlt31EyrAkWFT4c2z05Q/ZBTScMJDZcW3wubXvGJ
	 NeoEVagfQw5fxgQQyD3402PKdOae6ZNvuGUaby4EhmMBkUoI2l6QYpklollxItlBMl
	 kEW7No2Gkrr/w==
Subject: Re: [PATCH net-next v9 03/13] net/rds: ib: refuse to attach a
 connection to a device being removed
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Mon, 12 Oct 2026 04:17:45 +0000
Message-ID: <179177866594.434549.1674261010768407765@kernel.org>
In-Reply-To: <20261008031333.1142174-4-achender@kernel.org>
References: <20261008031333.1142174-4-achender@kernel.org>
X-sashiko-severity: High
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

Critical: 0 · High: 2 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] In the target commit, the fix only covers half of the in-flight-
  connect race on rds_rdma unload.
- [High] The new refusal path in rds_ib_setup_qp()
  (net/rds/ib_cm.c:527-529) jumps to 'out:' and calls…

--

net/rds: ib: refuse to attach a connection to a device being removed

This patch adds a shutting_down flag to struct rds_ib_device.
rds_ib_dev_shutdown() sets it under rds_ibdev->spinlock before it walks
conn_list. rds_ib_add_conn() now refuses, with -ENODEV, to attach a
connection to a device marked that way, and rds_ib_setup_qp() fails the
connect when that happens.

> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 4ea9838d090c3..a7647ec01a115 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -86,6 +86,11 @@ static void rds_ib_dev_shutdown(struct rds_ib_device *rds_ibdev)
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&rds_ibdev->spinlock, flags);
> +	/* Close the device to new connections under the same lock that
> +	 * rds_ib_add_conn() attaches them under, so that every
> +	 * connection is either dropped by the walk below or refused.
> +	 */
> +	rds_ibdev->shutting_down = true;
>  	list_for_each_entry(ic, &rds_ibdev->conn_list, ib_node)
>  		rds_conn_path_drop(&ic->conn->c_path[0], true);

[Severity: High]
When rds_rdma is unloaded, are the connections this walk drops actually
torn down?

rds_conn_path_drop(cp, true) only queues cp_down_w on cp->cp_wq.
__rds_conn_create() gives every path its own ordered workqueue. The
connection goes back to ib_nodev_conns only when that worker reaches:

rds_ib_conn_path_shutdown()
    if (ic->rds_ibdev)
        rds_ib_remove_conn(ic->rds_ibdev, conn);

Nothing on the unload path waits for that worker:

rds_ib_exit()
    rds_ib_unregister_client()
        ib_unregister_client(&rds_ib_client);
        flush_workqueue(rds_wq);    <-- rds_wq only, not cp_wq
    rds_ib_destroy_nodev_conns();

cp_down_w can still be running when the sweep happens. For example, it
can be blocked on c_cm_lock behind a connect that attached just before
shutting_down was set, or waiting for the rings to drain. In that case
the connection is still on the device's conn_list, and the sweep misses
it.

rds_ib_destroy_nodev_conns() also does not reinitialise the global head
after the splice:

	spin_lock_irq(&ib_nodev_conns_lock);
	list_splice(&ib_nodev_conns, &tmp_list);
	spin_unlock_irq(&ib_nodev_conns_lock);

A late rds_ib_remove_conn() would then link the node through the stale
ib_nodev_conns head into the sweep's on-stack tmp_list.

Could this leave the connection, with its QP, cm_id, cp_wq and device
reference, alive after the module is gone, and late shutdown work running
rds_rdma code? If so, the new comment's claim that every connection is
"either dropped by the walk below or refused" holds at this commit only
for the refused case.

Later patches in the series appear to fix this. "net/rds: unlink
transport nodes before a possibly deferred connection free" replaces the
list_splice() with a per-entry claim under ib_nodev_conns_lock. "net/rds:
wait for connections to be freed on transport unload" adds
rds_conn_wait_conns_freed(), which sweeps again for late arrivals and
then flushes rds_wq once more. Should those changes come before this
patch, so that a bisect cannot land on this intermediate state?

[ ... ]

> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 8b16bd7c40ce5..82ecbb9a3da1f 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -524,7 +524,9 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
>  	fr_queue_space = RDS_IB_DEFAULT_FR_WR;
>  
>  	/* add the conn now so that connection establishment has the dev */
> -	rds_ib_add_conn(rds_ibdev, conn);
> +	ret = rds_ib_add_conn(rds_ibdev, conn);
> +	if (ret)
> +		goto out;

[Severity: High]
Can the rds_ib_dev_put() on this refusal path be the last put on the
device, and can it happen after the only rds_wq flush on unload?

The out label drops the reference taken by rds_ib_get_client_data():

out:
	rds_ib_dev_put(rds_ibdev);

Once shutting_down is set, rds_ib_remove_one() goes on to drop both of
the device's own references:

	synchronize_rcu();
	rds_ib_dev_put(rds_ibdev);
	rds_ib_dev_put(rds_ibdev);

A connect sitting between rds_ib_get_client_data() and rds_ib_add_conn()
then holds the last reference, and rds_ib_dev_put() does:

	if (refcount_dec_and_test(&rds_ibdev->refcount))
		queue_work(rds_wq, &rds_ibdev->free_work);

The CM handler holds c_cm_lock across rds_ib_setup_qp(). The exit sweep's
rds_conn_destroy() of the refused connection waits on that lock. So the
put can happen during the sweep, after the single flush, and
rds_ib_exit() does not flush rds_wq again:

rds_ib_exit()
    rds_ib_unregister_client()   <-- only flush_workqueue(rds_wq)
    rds_ib_destroy_nodev_conns()
    rds_ib_sysctl_exit()
    rds_ib_recv_exit()
    rds_trans_unregister(&rds_ib_transport)
    rds_ib_mr_exit()             <-- destroys rds_ib_mr_wq

rds_wq belongs to rds.ko and stays alive. Could rds_ib_dev_free()
(rds_ib_destroy_mr_pool(), ib_dealloc_pd(), kfree()) race with
destroy_workqueue(rds_ib_mr_wq), or run after the rds_rdma text has been
unloaded?

This looks new with this patch. Before it, the same connect attached and
leaked, so the device stayed referenced. The commit message says:

    rds_ib_setup_qp() has not taken anything from the
    device at that point, so the failure needs no unwinding beyond the
    client-data reference it already releases.

That release can now be the final, deferred put.

This also appears to be fixed later in the series. "net/rds: wait for
connections to be freed on transport unload" adds a second
flush_workqueue(rds_wq) after rds_conn_wait_conns_freed() in
rds_ib_exit().

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008031333.1142174-1-achender%40kernel.org
