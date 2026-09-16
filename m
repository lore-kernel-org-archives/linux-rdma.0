Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF7F5111AD;
	Wed, 16 Sep 2026 23:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789602162; cv=none; b=N88LkKTj7UWp5a1vTPITsoGopGuLLeOwy9i2e3+9S3sEFPXvMhr7gI5l/EovYB8a8LT/vluPh+xAJ40gbYrGJeoZBox3Wly+X7Sa8IYBsHk/dcMOXkdEugrVXqeikGKdgDqfkxTQQyhxqRyLl1b0+I9weuU/3OfJ9IjtZz1JnZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789602162; c=relaxed/simple;
	bh=z5mWlHOkP24bexN9qOHhLxsny67dBxWDJm+Xv12id1g=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GRK5cgYutBfQHV5tj9/CwZS7kI/JnDRsdghjPinyTg+hC8Drti1A5qJq8S5gxqtRvUHH2FFbD+MNNFCL97CEOUFwXkl7WWKcswYB+67tPSVUvpxm6LMWmackOHzK7fTnBziBKppF30J050jVjP+EA4V7RftKsSqwuLXFKStkKCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BXVBc4g4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BXVBc4g4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9951F00893;
	Wed, 16 Sep 2026 23:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789602160;
	bh=JnKXPAWufUaQbnx5rJlu6SKRi1/GSmVe4udVFVEJnPg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=BXVBc4g49iG5nHeymp8S3G0WGMvqmkYYoiH4W2oAZHMh79ExKEamXzsjKZyLoRIjr
	 Tw8SIojhtvoU3qpA9Lo1CGLpNZk7n4MziGSov1VpdXWcxugD4lI+VEtLxmaee3g20B
	 TIShfa7HnT+DH18x20HK29RCu/hMFgIy49ISFvI69ke5VpGoT4KeKOrGDwtRS+9mIN
	 3qcvtcgsBeor1rRO3tQQ3z7r2xVmc4Zq7w606rrHxzl1lzky2EOfF1ezWDNEDietu7
	 qPysQaYQr7wr1KS5Bte7GNhvawRwK4ZduQjGqxsY7H0+cs0XlGLatkBwsbJIUTMJ5H
	 Rdc5SRTC9gXmQ==
Subject: Re: [PATCH net-next 5/6] net/mlx5: HWS, Handle timeout draining the
 send queue for FW STEs
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, erezsh@nvidia.com,
 gal@nvidia.com, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, saeedm@nvidia.com,
 kliteyn@nvidia.com
Date: Wed, 16 Sep 2026 23:42:39 +0000
Message-ID: <178960215945.22033.3053858992155472242@kernel.org>
In-Reply-To: <20260915111912.3926585-6-tariqt@nvidia.com>
References: <20260915111912.3926585-6-tariqt@nvidia.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 1 · Medium: 0 · Low: 0

- [High] Unpropagated error: on a DRAIN_SYNC timeout the new branch in
  mlx5hws_send_stes_fw() (send.c:1338-1345) jumps to `fail_rule`…

--

net/mlx5: HWS, Handle timeout draining the send queue for FW STEs

The patch makes mlx5hws_send_stes_fw() check the return value of the
DRAIN_SYNC call to mlx5hws_send_queue_action() and jump to the fail_rule
label when the drain times out. Previously the drain result was ignored.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
> index 9ff109fc8230a..bddac018b44b8 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
> @@ -1335,10 +1335,14 @@ void mlx5hws_send_stes_fw(struct mlx5hws_context *ctx,
>  	pdn = ctx->pd_num;
>  
>  	/* Writing through FW can't HW fence, therefore we drain the queue */
> -	if (send_attr->fence)
> -		mlx5hws_send_queue_action(ctx,
> -					  queue_id,
> -					  MLX5HWS_SEND_QUEUE_ACTION_DRAIN_SYNC);
> +	if (send_attr->fence) {
> +		enum mlx5hws_send_queue_actions drain =
> +			MLX5HWS_SEND_QUEUE_ACTION_DRAIN_SYNC;
> +
> +		ret = mlx5hws_send_queue_action(ctx, queue_id, drain);
> +		if (ret)
> +			goto fail_rule;
> +	}

[Severity: High]
Can this new early exit end up reported as success to the caller?

The only site that sets send_attr.fence = 1 is
hws_action_create_dest_match_range_fill_table() in
steering/hws/action.c, and it sets rule = NULL:

	ste_attr.send_attr.user_data = &no_use;
	ste_attr.send_attr.rule = NULL;
	ste_attr.send_attr.fence = 1;

With the new goto, neither of the two hws_send_wqe_fw() calls for
ste_attr->rtc_1 and ste_attr->rtc_0 runs, so no GTA OP_ACTIVATE STE is
written into the range table.

mlx5hws_send_stes_fw() is declared void in steering/hws/send.h, so the
only failure channels are rule->status and the completion entry pushed by
mlx5hws_send_engine_gen_comp(). At fail_rule, rule is NULL:

fail_rule:
	if (likely(rule))
		rule->status = ...;

	mlx5hws_send_engine_gen_comp(queue, send_attr->user_data, MLX5HWS_FLOW_OP_ERROR);

The caller never reads queue->completed. Its only post-send check is its
own drain:

action.c:hws_action_create_dest_match_range_fill_table() {
	/* Send WQEs to FW */
	mlx5hws_send_stes_fw(ctx, queue, &ste_attr);

	/* Poll for completion */
	ret = mlx5hws_send_queue_action(ctx, ctx->queues - 1,
					MLX5HWS_SEND_QUEUE_ACTION_DRAIN_SYNC);
	if (ret) {
		mlx5hws_err(ctx, "Failed to drain control queue");
		goto error;
	}

	mutex_unlock(&ctx->ctrl_lock);

	return 0;
}

Can that second drain succeed after the first one timed out? In
mlx5hws_send_queue_action() the deadline is tested after the poll:

		while (wait_comp && !mlx5hws_send_engine_empty(queue)) {
			hws_send_engine_poll_cq(queue, NULL, &polled, 0);

			if (unlikely(time_after(jiffies, timeout))) {
				...
				return -ETIMEDOUT;
			}
		}

so -ETIMEDOUT can be returned on the very iteration whose poll emptied
the queue, and a transient stall that resolves during the second drain
gives the same result. mlx5hws_send_engine_empty() compares the SQ
cur_post against the CQ poll_wqe only, not queue->completed or
queue->err, so the FLOW_OP_ERROR entry is invisible here.

In that case hws_action_create_dest_match_range_fill_table() returns 0
and mlx5hws_action_create_dest_match_range() continues on to program an
STC pointing at the empty STE table:

	stc_attr.action_type = MLX5_IFC_STC_ACTION_TYPE_JUMP_TO_STE_TABLE;
	stc_attr.ste_table.ste_pool = table_ste->pool;

Does this leave a usable-looking MLX5_FLOW_DEST_RANGE_FIELD_PKT_LEN
action whose RTC contains no activated STE, so traffic steered into it
always misses to miss_ft while the definer, table_ste and hit_ft_action
stay allocated?

Note the behaviour change relative to the pre-patch code: previously the
drain result was ignored but the FW writes still happened (only the fence
ordering was violated), whereas now the writes are skipped while success
can still be returned. Would it make sense for
mlx5hws_send_stes_fw() to return int, or for the caller to consume and
check the generated completion, so the timeout is actually observable?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260915111912.3926585-1-tariqt%40nvidia.com
