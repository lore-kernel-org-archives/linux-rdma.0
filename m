Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CEC3BE623;
	Sun,  4 Oct 2026 18:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791138868; cv=none; b=TIgnyY5cbJH9xGTHoeQOwMcElhi6Q+KVs9tr/Sh/wCEoKw4Bx6kMvAVFt4CeLy9RQXjUXmvnN0YbPze7XcKLZ2oUS0TdKXxD059YnxBEtCQGxrZVpc6AIHSwUKALmwSasCW3zWiSta4V9zSg2d86h2gO9bnKM2mQ+OtQFuE4ACs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791138868; c=relaxed/simple;
	bh=ZoUL9vFrZiqSevq5Z1f//XJFOqm1V4r8RtSTtomzUaA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HTsBelLN0rWwD0FfrrZRW25PS2HcwO6mWVG858i9ZDhtVhlFaePPkiZaQibLt0s5B2vbg9UI3D1WxQQTq5PgOvyXYH5Nk/8Fv3eAlrgaSUjHc0pG2qVGbviXXPio79lM6CpltopAWyHzk5ZNnOEtiHWGX9a/mgwWm5xRPDoph0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZoFj3AM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZoFj3AM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3404C1F00893;
	Sun,  4 Oct 2026 18:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791138867;
	bh=HJ04tlP5TSoRPXEqINwFS/UNlbWsKcgl7Yc3k992UDs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=AZoFj3AMFZYNDyAOhNP+hYrjoC7g3FwgX3Z6nDQ/q0g40EtHW5DI22Lzl6eEElldW
	 UKVIuQZmTjPk2HpXjZV5GPbo1LcSNSjTmiJ3OV7Ow9YdvLst1TONZHdJQ2+dxkMJVh
	 9w1uSMOyE0X5xDYyrVAmYT0bEtBjNT5uyQHeOH96LnA3Hr3rIHmMJ8JBU7FUWsKUai
	 wSd2q78pLSYpS9gWZDo5znk9IJKeaiKs7/YO1NyVijYguYBRwzyLms9Ju5Hu3t2C3e
	 mhY+8+sQdpYX7MbDPRbc0OM7Rg8O682czYxiYIBAiLWLB3GfsdGR1q+vxr3Kr7oBn9
	 oL0h/4dsN7mmQ==
Subject: Re: [PATCH net v2 2/2] net/smc: serialize early link group cleanup
 with termination
From: netdev-bot+sashiko@kernel.org
To: nicoyip.dev@gmail.com
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com, horms@kernel.org,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Sun, 04 Oct 2026 18:34:25 +0000
Message-ID: <179113886579.434549.12546097168507601074@kernel.org>
In-Reply-To: <20261003183237.2284245-3-nicoyip.dev@gmail.com>
References: <20261003183237.2284245-3-nicoyip.dev@gmail.com>
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

Critical: 0 · High: 1 (1) · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The new temporary hold in smc_lgr_create()/smc_conn_create()
  keeps only the struct smc_link_group memory alive across the window…
- [Low] The fix only works if the preceding series patch "net/smc:
  serialize link group free work scheduling" is also applied, and this…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the exclusive-
  teardown protocol this patch builds on is unsafe against an already-…

--

net/smc: serialize early link group cleanup with termination

This patch makes smc_lgr_cleanup_early() check lgr->freeing under the link
group list lock, so it does not tear down a group that another path
already owns. It also takes a temporary lgr reference in smc_conn_abort().
For newly created groups, it takes another temporary reference from
publication in smc_lgr_create() until registration in smc_conn_create()
finishes.

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 478c8bc2759a0..1918a79ff60e4 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -693,6 +693,10 @@ void smc_lgr_cleanup_early(struct smc_link_group *lgr)
>  
>  	smc_lgr_list_head(lgr, &lgr_lock);
>  	spin_lock_bh(lgr_lock);
> +	if (lgr->freeing) {
> +		spin_unlock_bh(lgr_lock);
> +		return;
> +	}

[Severity: Low]

This early return only gives exclusive teardown ownership in combination
with two other pieces: the lgr->freeing = 1 write later in
smc_lgr_cleanup_early(), and freeing being a standalone bool instead of a
bitfield that shares storage with sync_err and terminating.

Both of those come from the earlier series patch "net/smc: serialize link
group free work scheduling". The baseline smc_lgr_cleanup_early() never
sets freeing.

The commit body only says:

    The existing locked freeing transition then claims exclusive teardown
    ownership

The explicit dependency is stated only in the v2 changelog below the ---
line, and git am drops that part.

The context lines of this hunk don't include the lgr->freeing = 1 line,
so the hunk applies cleanly to a tree without the prerequisite. The two
patches also carry different Fixes: tags (8e316b9e7260 and f9aab6f2ce57).

Suppose a stable tree takes only this patch. smc_lgr_cleanup_early()
would then check freeing but never claim it. Couldn't
smc_lgr_terminate_sched(), smc_smcd_terminate() or
smc_smcr_terminate_all() still claim the group after the check, so that
both paths enter __smc_lgr_terminate()?

Could the body mention the dependency? Another option is a "# needs ..."
annotation on the Cc: stable line.

[Severity: High]

This is a pre-existing issue and wasn't introduced by this patch. Still,
the exclusive teardown protocol that this check builds on doesn't seem
safe against a free_work instance that is already running.

smc_lgr_free_work() holds no lgr reference. It dereferences the group
before it can see that freeing was claimed:

net/smc/smc_core.c:smc_lgr_free_work() {
    ...
	smc_lgr_list_head(lgr, &lgr_lock);
	spin_lock_bh(lgr_lock);
	if (lgr->freeing) {
    ...
}

__smc_lgr_terminate() only uses the non-synchronous cancel:

	/* cancel pending free_work; a running instance rechecks freeing */
	cancel_delayed_work(&lgr->free_work);

Neither smc_lgr_free() nor __smc_lgr_free() waits for free_work before
kfree(lgr).

Can this sequence happen on an idle group (conns_num == 0)?

CPU1 (free_work timer expired)
smc_lgr_free_work()
  <preempted before spin_lock_bh(lgr_lock)>

CPU2 (peer DELETE_LINK with SMC_LLC_FLAG_DEL_LINK_ALL)
smc_llc_process_cli_delete_link()
  smc_lgr_terminate_sched()
    lgr->freeing = 1;
    schedule_work(&lgr->terminate_work);
smc_lgr_terminate_work()
  __smc_lgr_terminate()
    cancel_delayed_work(&lgr->free_work);   <- does not wait
    smc_lgr_free()
      smc_lgr_put()
        __smc_lgr_free()
          kfree(lgr);

CPU1 resumes
  smc_lgr_list_head(lgr, &lgr_lock);   <- reads freed lgr
  spin_lock_bh(lgr_lock);

The resumed worker would take a spinlock through a pointer loaded from
freed memory. If the slab has been reused and reads freeing == 0 with an
empty tree, the worker could also run list_del_init() and smc_lgr_free()
on foreign memory.

Other terminators would reach the same window, for example an LLC protocol
violation, or smc_smcd_terminate() from an ISM event.

The smc_conn_abort()->smc_lgr_cleanup_early() path doesn't look like a
realistic trigger here. smc_lgr_schedule_free_work() is only called once
conns_num reaches zero, and the creating connection stays registered
until its own abort.

Could free_work hold its own lgr reference, taken when it is armed and
dropped when the work exits or is cancelled successfully? Alternatively,
the final put could use cancel_delayed_work_sync() when it is not running
from free_work itself.

>  	/* do not use this link group for new connections */
>  	if (!list_empty(&lgr->list))
>  		list_del_init(&lgr->list);
> @@ -999,6 +1003,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
>  		lgr->buf_type = lgr->net->smc.sysctl_smcr_buf_type;
>  		atomic_inc(&lgr_cnt);
>  	}
> +	smc_lgr_hold(lgr); /* lgr_put in smc_conn_create() */
>  	smc->conn.lgr = lgr;
>  	spin_lock_bh(lgr_lock);
>  	list_add_tail(&lgr->list, lgr_list);
> @@ -2054,10 +2059,13 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
>  		write_unlock_bh(&lgr->conns_lock);
>  		if (rc) {
>  			smc_lgr_cleanup_early(lgr);
> +			smc_lgr_put(lgr); /* lgr_hold in smc_lgr_create() */
>  			goto out;
>  		}
>  	}
>  	smc_lgr_hold(conn->lgr); /* lgr_put in smc_conn_free() */
> +	if (ini->first_contact_local)
> +		smc_lgr_put(conn->lgr); /* lgr_hold in smc_lgr_create() */

[Severity: High]

The temporary hold taken in smc_lgr_create() keeps the lgr allocation
alive between list_add_tail() and smc_lgr_register_conn(). Does it also
stop a terminator from tearing the group down in that window?

smc_conn_create() only takes lgr->conns_lock around
smc_lgr_register_conn(conn, true). Nothing rechecks lgr->freeing under
lgr_lock. For SMC-D, this sequence seems possible:

CPU1 (first-contact connect or listen)
smc_conn_create()
  smc_lgr_create()
    smc_lgr_hold(lgr);
    list_add_tail(&lgr->list, lgr_list);

CPU2 (peer ISM GID or shutdown event)
smc_smcd_terminate()
  lgr->peer_shutdown = 1;
  list_move(&lgr->list, &lgr_free_list);
  lgr->freeing = 1;
  schedule_work(&lgr->terminate_work);
smc_lgr_terminate_work()
  __smc_lgr_terminate()
    rb_first(&lgr->conns_all) is NULL, kill loop skipped
    smc_lgr_free()
      destroy_workqueue(lgr->tx_wq);
      smc_ism_put_vlan(); put_device();
      smc_lgr_put(lgr);   <- only the temporary hold remains

CPU1
  write_lock_bh(&lgr->conns_lock);
  smc_lgr_register_conn(conn, true);  <- cannot fail for SMC-D,
                                         sock_hold(), conns_num++
  smc_lgr_hold(conn->lgr);
  smc_lgr_put(conn->lgr);             <- temporary hold dropped
  return 0;

The kill loop never visited this connection, so conn->killed stays clear.
Two problems seem to follow.

First, smc_tx_consumer_update() can get -EPIPE from
smc_cdc_get_slot_and_msg_send() because peer_shutdown is set. It would
then queue work on the destroyed workqueue:

		if ((smc_cdc_get_slot_and_msg_send(conn) < 0) &&
		    !conn->killed) {
			queue_delayed_work(conn->lgr->tx_wq, &conn->tx_work,
					   SMC_TX_WORK_DELAY);

Second, smc_conn_free() sees list_empty(&lgr->list) and skips
smc_lgr_unregister_conn(). That leaks the sock_hold() taken at
registration. The final smc_lgr_put() would then free the lgr while
smc_conn_lgr_valid() still returns true for the connection.

The publication-to-registration window itself predates this patch. Before
it, the later write_lock_bh(&lgr->conns_lock) was a direct
use-after-free.

The commit message says "On success, acquire the ordinary connection
reference before releasing the temporary hold". This handoff doesn't seem
to serialize registration with the freeing claim.

Could first-contact registration take lgr_lock, fail if lgr->freeing is
set, and then take conns_lock and register? That would match the lock
order of the reuse path. Alternatively, could the group be published only
after its first connection is registered?

The SMC-R variant looks mostly blocked. smc_lgr_free() clears the links,
so registration then fails with SMC_CLC_DECL_NOACTLINK and takes the
fixed failure path. It is unclear whether a concurrent smcr_link_clear()
could still hand out a link while it is clearing.

>  	if (!conn->lgr->is_smcd)
>  		smcr_link_hold(conn->lnk); /* link_put in smc_conn_free() */
>  	conn->freed = 0;

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261003183237.2284245-1-nicoyip.dev%40gmail.com
