Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C9A3BE623;
	Sun,  4 Oct 2026 16:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791131704; cv=none; b=qrDsAcrWHyzqyd6lddw6X43UDQXkkeHVFvUKENm0Qr+OfMnkr8CQ7oiy/xJfa2WklEFffxvxtGbZqF7SGZaiuyvMJkca6xzB2oj8cU15FrOmFBTERidCwBJFDg05oMV3nb1zyE0hnQ2ul3z5EXzry8vZtiApLmQuaxDQdZAkReA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791131704; c=relaxed/simple;
	bh=25ovSf3ZVo1hp9jvfzzP/bz85epQv5OseCLdeNQQY7g=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=K0Z04gGZeZvezxWuX0Y3TAf5yszXDeyt6HmOdn+r68mU6n6XZN34QD0Gbj+KyaKkguhmA3kRE/CIRDIMN1Esw9JK78sZffpGbCH6VmjXFKPqUktlMzl7OoJ5Uek8x2GLh3Kt3/6NQRxLCjXlC0mBg5ADlRYKhJgnPLZi2Z7lXNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lh1n2rdy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lh1n2rdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0096A1F000FF;
	Sun,  4 Oct 2026 16:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791131702;
	bh=sHWAyHZSoA/9wsJ4w9QC0/iaiENdsX/sZg7K/rGEW2o=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Lh1n2rdyUdQx1IykwnTRWN6eNFIQTGzTasOjYl6Vk1klOCvW4kswBRyXi2musyhKg
	 cHOt8Srfm3DvYJJL8F3AZKCYH/f1jmvoLodjHxQMGEqBme+hXn7oSnQS2/UDbDCSbY
	 vshXFHfRztH+d/UmPuwrb3hWxutOPgwE3id4Rt74FWN4B5y0Aeu+f6EpOQ2z9WByT0
	 /CnYyJKz0NlIpXOCYY+FS1oa3swCGys0tAv86pbMfers+MPnzALKQTJiMVfO7iJUZd
	 bub7+IGcZLLq9Ccsm2oAoAWpmHpSxGPSa5Wo13ilElVKMytjdtuD56Uqjj4Qq6bAmd
	 fyvMO5/srhOFw==
Subject: Re: [PATCH net-next v8 08/13] net/rds: wait for connections to be
 freed on transport unload
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Sun, 04 Oct 2026 16:35:01 +0000
Message-ID: <179113170151.434549.12580197013439113648@kernel.org>
In-Reply-To: <20261003163215.250253-9-achender@kernel.org>
References: <20261003163215.250253-9-achender@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] This patch fixes two real, pre-existing unload bugs in the IB
  transport, but carries no Fixes: tag.

--

net/rds: wait for connections to be freed on transport unload

This patch adds a per-transport t_conn_count of live connections. The IB,
TCP and loop exit paths now wait for that count to reach zero before
unloading. For IB, the wait also calls rds_ib_destroy_nodev_conns() on
every poll, and rds_ib_exit() flushes rds_wq again once the connections
are gone.

> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index d9879b6129e73..7b1f611c0a3e5 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -540,7 +540,24 @@ void rds_ib_exit(void)
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
> +
> +	/* Tearing down the last connection may have dropped the final
> +	 * reference on a device, deferring rds_ib_dev_free() to rds_wq.
> +	 * Drain it before the module goes away; it queues nothing
> +	 * further on rds_wq.
> +	 */
> +	flush_workqueue(rds_wq);
> +

[Severity: Low]

The resweep and the second flush_workqueue(rds_wq) seem to fix two IB
unload bugs that already exist in the tree before this patch. Should this
patch have a Fixes: tag?

The first bug starts in rds_ib_dev_shutdown(), which queues cp_down_w on
the per-path cp_wq:

	list_for_each_entry(ic, &rds_ibdev->conn_list, ib_node)
		rds_conn_path_drop(&ic->conn->c_path[0], true);

Since commit 4716af3897e9 ("net/rds: Give each connection path its own
workqueue"), cp_wq is a private ordered workqueue instead of rds_wq. So
the flush_workqueue(rds_wq) in rds_ib_unregister_client() does not wait
for those shutdown works.

If rds_ib_remove_conn() moves a connection to ib_nodev_conns after the
single rds_ib_destroy_nodev_conns() sweep, nothing destroys it. It
outlives the module and still points at rds_ib_transport.

The second bug follows from that. rds_ib_remove_conn() then calls
rds_ib_dev_put(), which does this when it drops the last device
reference:

	if (refcount_dec_and_test(&rds_ibdev->refcount))
		queue_work(rds_wq, &rds_ibdev->free_work);

That queues rds_ib_dev_free() after the only flush of rds_wq. It could
then run after the module text is gone.

The commit message already calls the first bug "an existing hole". Of
the second it says "nothing flushed rds_wq again after
rds_ib_unregister_client() before". Other fixes in this series carry a
Fixes: tag. Would a Fixes: 4716af3897e9 tag fit here as well?

The opening paragraph of the commit message also says:

  At this point in the series the initial reference is the only one
  and the wait returns at once; the guarantee becomes load-bearing
  with those patches.

Is that accurate for IB? A connection that reaches ib_nodev_conns late
keeps t_conn_count above zero. The loop in rds_conn_wait_conns_freed()
then has to call the resweep to destroy it, so the patch already changes
behavior at this point in the series.

Could the opening paragraph be reworded so backport readers don't take
the patch as a no-op?

It may also be worth splitting out a small standalone fix that doesn't
depend on the kref/t_conn_count infrastructure. One option is to flush
the per-connection shutdown works, or loop until the device lists and
ib_nodev_conns are empty, and then flush rds_wq.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261003163215.250253-1-achender%40kernel.org
