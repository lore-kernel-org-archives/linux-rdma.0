Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F67A5013D6;
	Wed, 16 Sep 2026 23:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789602161; cv=none; b=hekSNstSaUl2bSyMuXRUKvPDfg5/3EpjwGcEKhCdVmWukMReT0l3nxGtOtS1xnYt8qlzoHsWWnmvQ1JoujnimCt14n8l0JoMaow91XwOoMCoNHzZixJHgzmLz+koNoL2q0MJwzEbcbxYufKAKDT+ow+feolIyxNj64j7maTPtv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789602161; c=relaxed/simple;
	bh=OM75Uq06iSJyXmyDdbzdVBgHK4Vh/nHh4a51swHl2Eg=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WoCbW6vudYnowIvYsuXETd85+0FFkZim/BvVrkcUhEPfTycCPDuUxBoQ8pY6wa9vRjtK1ZhhIrEHarxz54FOWVkPhwC3pkJmeh5al29jXEcmTkXlxj6wlV9hr/u1/he7K1Kwh7Uq1BRS3PsYGYhiY4/mpuuy3MwFZvSSUZerhVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A9Sfo/1/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A9Sfo/1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A44E1F000FF;
	Wed, 16 Sep 2026 23:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789602159;
	bh=ua3+JR+zXORANOrL5anq/4aVX9dEU2uLbLhTDBFT1wQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=A9Sfo/1/H3Z0aM/3AePKp6s9COiB2yrtxQB5YOY5onSmQOA661Q7I8A/0f06sGW5o
	 QrTgVaeKoMMULbOxYpuoKvmlEWWXqn+6IYebSAd7RobcKxJGFk7oz2HLaByqP1OhpC
	 4kpnX2mb7VHMg0ERMPASX8woS7yUZ4oJisRp0k0YcPZ4bQxhwY1UMOAuemcEu/B9/J
	 lByfAL0SbpzLKtFhz51lqHuq6fkUQizZMhi7o7ITSrKfYq2HmXKnGhuh1hDss5cO8O
	 n2wle5t/pjujah2v1A2qajCgC1QCCkfvOZgv5qRwhq2gquVud/hEZIpaxH7OKQCb6D
	 BL+NdCx2xlIHw==
Subject: Re: [PATCH net-next 4/6] net/mlx5: HWS, Add timeout mechanism to
 draining send queues
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, erezsh@nvidia.com,
 gal@nvidia.com, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, saeedm@nvidia.com,
 kliteyn@nvidia.com
Date: Wed, 16 Sep 2026 23:42:38 +0000
Message-ID: <178960215805.22033.5661773040766220983@kernel.org>
In-Reply-To: <20260915111912.3926585-5-tariqt@nvidia.com>
References: <20260915111912.3926585-5-tariqt@nvidia.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 2 · Low: 3

- [Medium] The new drain timeout in mlx5hws_send_queue_action()
  (send.c:1218-1228) does not mirror the…
- [Medium] The new -ETIMEDOUT return from mlx5hws_send_queue_action()
  (send.c:1226) abandons the drain while WQEs are still owned by the HW…
- [Low] RESOLVED LATER IN THIS SERIES (retained only per the validation-
  experiment directive): at this commit, mlx5hws_send_stes_fw()…
- [Low] This change converts a previously unbounded (infinite)
  synchronous drain loop into one that fails with -ETIMEDOUT, i.e. it…
- [Low] In mlx5hws_send_queue_action() (send.c:1218-1228) the new
  deadline test is evaluated unconditionally after…

--

net/mlx5: HWS, Add timeout mechanism to draining send queues

This adds a 60 second deadline (MLX5HWS_BWC_POLLING_TIMEOUT) to the
synchronous drain loop in mlx5hws_send_queue_action(), which previously
polled until the send engine became empty with no exit condition. It
also extends the existing BWC poll timeout message with the timeout
value.

A few questions below.

> net/mlx5: HWS, Add timeout mechanism to draining send queues
>
> HWS has a timeout mechanism for usual polling for completion,
> but it was missing such a mechanism for draining the send queues.

[Severity: Low]
Should this carry a Fixes: tag?

The DRAIN_SYNC arm of mlx5hws_send_queue_action() had no exit other than the
queue emptying, so callers such as mlx5hws_arg_write_inline_arg_data() and
hws_action_create_dest_match_range_fill_table() could spin indefinitely with
ctx->ctrl_lock held when the device stops generating completions.

git blame points at 2ca62599aa0b ("net/mlx5: HWS, added send engine and
context handling") for that loop.

The commit message describes the change as adding a missing mechanism rather
than fixing an indefinite hang, which makes it harder for stable maintainers
to pick this up.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
> index 49dee44d0bef5..9ff109fc8230a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
> @@ -1192,6 +1192,8 @@ int mlx5hws_send_queue_action(struct mlx5hws_context *ctx,
>  			      u16 queue_id,
>  			      u32 actions)
>  {
> +	unsigned long timeout = jiffies +
> +				secs_to_jiffies(MLX5HWS_BWC_POLLING_TIMEOUT);
>  	struct mlx5hws_send_ring_sq *send_sq;
>  	struct mlx5hws_send_engine *queue;
>  	bool wait_comp = false;
> @@ -1213,9 +1215,18 @@ int mlx5hws_send_queue_action(struct mlx5hws_context *ctx,
>  			mlx5hws_send_engine_flush_queue(queue);
>  
>  		/* Poll queue until empty */
> -		while (wait_comp && !mlx5hws_send_engine_empty(queue))
> +		while (wait_comp && !mlx5hws_send_engine_empty(queue)) {
>  			hws_send_engine_poll_cq(queue, NULL, &polled, 0);
>  
> +			if (unlikely(time_after(jiffies, timeout))) {

[Severity: Medium]
Should this loop also short-circuit on MLX5_DEVICE_STATE_INTERNAL_ERROR the
way its sibling in bwc.c does?

mlx5hws_bwc_queue_poll() aborts immediately when the device is down:

	if (unlikely(ctx->mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)) {
		/* If the device is down for any reason (e.g. FLR), the HW will
		 * no longer generate completions.
		 ...
		return -ETIMEDOUT;
	}

The drain loop has no equivalent. hws_send_engine_poll_cq() returns before
reaching any device-state check when the CQ is empty:

	cqe = mlx5_cqwq_get_cqe(&cq->wq);
	if (!cqe)
		return;

The device-state test lives in mlx5hws_cq_poll_one(), which is only reached
after a CQE has already been found, so it never fires on a dead device.

So in exactly the FLR / health-failure case where the hardware is documented
to stop producing completions, doesn't every DRAIN_SYNC call now spin on CQ
memory for the full MLX5HWS_BWC_POLLING_TIMEOUT of 60 seconds?

There is also no cond_resched() or cpu_relax() in the loop body, and both
callers hold ctx->ctrl_lock across the drain:

  mlx5hws_arg_write_inline_arg_data() -> mlx5hws_send_queue_action()
  hws_action_create_dest_match_range_fill_table() -> mlx5hws_send_queue_action()

On CONFIG_PREEMPT_NONE or PREEMPT_VOLUNTARY, can a 60 second spin here trip
the soft lockup detector (2 * watchdog_thresh, 20 seconds) and the RCU CPU
stall timeout, while every other task waiting on ctrl_lock is blocked?

[Severity: Low]
Can this report a timeout for a drain that actually completed?

The deadline test runs unconditionally after the poll and returns before the
while condition is re-evaluated. hws_send_engine_poll_cq() advances
cq->poll_wqe:

	cq->poll_wqe = (wqe_cnt + priv->num_wqebbs) & sq->buf_mask;

and mlx5hws_send_engine_empty() compares exactly that field against
send_sq->cur_post:

	return ((send_sq->cur_post & send_sq->buf_mask) == send_cq->poll_wqe);

So if the poll that empties the queue lands on the same iteration in which
jiffies crosses the deadline, -ETIMEDOUT is returned for a drained queue.

The sibling loop in mlx5hws_bwc_queue_poll() gates its check on lack of
progress:

	if (unlikely(!got_comp && time_after(jiffies, timeout))) {

Would re-testing mlx5hws_send_engine_empty() (or adding a progress
qualifier) before returning be worth doing here?

> +				mlx5hws_err(ctx,
> +					    "Error draining send queue %d - TIMEOUT (%d sec)\n",
> +					    queue_id,
> +					    MLX5HWS_BWC_POLLING_TIMEOUT);
> +				return -ETIMEDOUT;

[Severity: Medium]
This return abandons the drain while cur_post != cq->poll_wqe, that is while
WQEs are still owned by the hardware, without setting queue->err and without
reaping the matching sq->wr_priv entries.

The bad-CQE path in hws_send_engine_poll_cq() does fence the engine off:

	if (unlikely(cqe_opcode != MLX5_CQE_REQ))
		queue->err = true;

Since queue->err stays clear on the timeout path, mlx5hws_send_engine_err()
keeps reporting the queue as healthy and it continues to be used with a
skewed cur_post / poll_wqe pair.

Callers treat the new error as an ordinary failure and free the objects the
outstanding WQEs still reference. In mlx5hws_arg_create():

	ret = mlx5hws_arg_write_inline_arg_data(ctx, id, data, data_sz);
	if (ret) {
		mlx5hws_err(ctx, "Failed writing arg data\n");
		mlx5hws_cmd_arg_destroy(ctx->mdev, id);
		return ret;
	}

while the MOD_ARG WQEs posted by mlx5hws_arg_write() still target that id:

	send_attr.id = arg_idx++;
	mlx5hws_send_engine_post_end(&ctrl, &send_attr);

Similarly, hws_action_create_dest_match_range_fill_table() propagates the
drain failure and mlx5hws_action_create_dest_match_range() unwinds:

	destroy_hit_ft_action:
		mlx5hws_action_destroy(hit_ft_action);
	destroy_table_ste:
		hws_action_destroy_dest_match_range_table(ctx, table_ste);

freeing the STC offset and destroying the RTCs and STE pool that
un-completed control queue work still refers to.

If the timeout is caused by a stalled but still live device that later
resumes executing those WQEs, can the argument id / STC offset / RTC id have
been reallocated to an unrelated object by then, so the late execution writes
into the new owner? Before this patch the DRAIN_SYNC arm could only return 0,
so these caller error paths were not reachable from this call.

Would setting queue->err on the timeout path, or otherwise quiescing the
queue before letting callers destroy objects, address this?

[Severity: Low]
One caller discards the new return value. In mlx5hws_send_stes_fw():

	/* Writing through FW can't HW fence, therefore we drain the queue */
	if (send_attr->fence)
		mlx5hws_send_queue_action(ctx,
					  queue_id,
					  MLX5HWS_SEND_QUEUE_ACTION_DRAIN_SYNC);

The drain is the software substitute for a hardware fence here, and the path
is live: hws_action_create_dest_match_range_fill_table() sets
ste_attr.send_attr.fence = 1. With -ETIMEDOUT ignored, the firmware STE/RTC
write proceeds and MLX5HWS_FLOW_OP_SUCCESS is generated even though the
fence never completed.

This is addressed by the following patch in the series, "net/mlx5: HWS,
Handle timeout draining the send queue for FW STEs", which checks the return
value and goes to fail_rule, so it is only an issue at this commit.

> +			}
> +		}
> +
>  		break;
>  	default:
>  		return -EINVAL;

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260915111912.3926585-1-tariqt%40nvidia.com
