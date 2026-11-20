Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795152922;
	b=dgX7UCY4rxm7xRUYo9aMxXQzWgjPb6tgV7P2sj0IrSBz8XMhWgkHdyqoSVmc1BgJt5f1
	 hOtvPbIJcMqgB9AsJiJk69ZuSJ+fQCzlAgm9yIso9Dv2TNntZcMf+pNoCExx8RDnF1Kdm
	 aN4Mj/mJRjc0jm4SeZzfxK03Us9SJnSkxVkNAGcIOs9zLeto+MSZkJs1bWK2HyhMClg25
	 eV34OspKJOYWNE+VpMnvZkg0Z3Tq1JoCEN1J2VyxVKZFCBEFitihsOah8z6DCaOvPoRb/
	 Rgfw2rQBvQ77+6WaGNlwL/5qlWDWMkbQQNzRW/MDaerY5JZuE55xVo3LosHWC5brSPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795152922;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=6NmKnHRU/piT4HLG2fbbtf+VrhiQ2Ne2vhyFekILWNQ=;
	b=HHWK1Pm0BYzsQkgg/54puDdcHi4V0ZaeiMmy5WdfavebaL+dkmX6FcoLo9vnyhz+KO6i
	 J9KebPX2dAn1jVAtI6sv8eBaV65kqNPjtp3kWcvk40mcqljAj5SuwS9gHZECysXqtWYpz
	 +5Aj9DcDdgKXfepZMshIv30ILt1cXBOr4VV337R7GTJbcH+8XZSR+VIt/Z9/Upi5qQD/y
	 eyB5bJz14svHMeQmhwLa5L4i78caBIAvMQ2BnaKKyQeyLA4bxSOHBNJI2FQFXFLCSgV8i
	 nbOXbCRlvv9MOC4YPdPQRdQrCHEb8YZSt4shm7qlOfj5RluksUDi3ah+1nZMJSf0f1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PyfVUj5V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A52B606A33A;
	Fri, 20 Nov 2026 05:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PyfVUj5V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1811F000C4;
	Fri, 20 Nov 2026 05:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795152921;
	bh=6NmKnHRU/piT4HLG2fbbtf+VrhiQ2Ne2vhyFekILWNQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=PyfVUj5VjogeatR3yXagNs4L7nS8GfD4rcRQWCafelU0Mz6dsJ4HshJGKc4iphgy4
	 PMVr4YhtnK75HUhGJowOzhWIUlmRcQUasW8ai5h1mn9TYGl07gDaXPtZ/azxLeIuKQ
	 T3NOXdo9x0JzvukzSZkc24OQCX3FzUC4Eq5uPERLUjJpiWSFWe/vjyktPnq+/nhrue
	 Uhy7azpqO6OtV+yx7WIBSGJ+zstqGddvowK7G3+Zn3Osb5c4+pT3uyr9avDod9zqSu
	 wNdtwtolUVzekPfPUJtSpDEJ0RSXxOwFCrilKCYckAsXCb9+7mLhm3pe8TBvM9UunL
	 XnWFFq7MWbARQ==
Subject: Re: [PATCH net V2 2/2] net/mlx5: DR, Fix out-of-bounds write when
 sync to HW fails
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 acassen@corp.free.fr, valex@nvidia.com, erezsh@nvidia.com, gal@nvidia.com,
 kees+treewide@kernel.org, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, moshe@nvidia.com,
 prathameshdeshpande7@gmail.com, saeedm@nvidia.com, horms@kernel.org,
 william@theesfeld.net, kliteyn@nvidia.com
Date: Fri, 20 Nov 2026 05:35:20 +0000
Message-ID: <179515292029.3136.16137473377101738953@kernel.org>
In-Reply-To: <20261118173227.1957670-3-tariqt@nvidia.com>
References: <20261118173227.1957670-3-tariqt@nvidia.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] One SYNC_STEERING failure now disables the ICM pool
  permanently.
- [Low] The 'KASAN log excerpt' in the commit message is not real KASAN
  output.

--

net/mlx5: DR, Fix out-of-bounds write when sync to HW fails

This patch adds an error_state flag to struct mlx5dr_icm_pool. The flag
is set when SYNC_STEERING fails in dr_icm_pool_sync_all_buddy_pools().
While it is set, mlx5dr_icm_free_chunk() stops queuing chunks into
hot_chunks_arr, which prevents the out-of-bounds write, and
mlx5dr_icm_alloc_chunk() returns NULL.

> The issue was discovered by a fuzzer that repeatedly triggered sync
> failure, at which point the out-of-bounds write was reported by KASAN:
>
>    KASAN log excerpt: BUG:
>      slab-out-of-bounds in mlx5dr_icm_free_chunk+0x4cd at call 2
>      (hot_chunks_num=3 > cap=2).

[Severity: Low]
Is this excerpt from an actual KASAN report? A real splat starts with
"BUG: KASAN: slab-out-of-bounds in func+0xoff/0xsize". It is followed
by "Write of size N at addr ... by task ..." and a stack trace. KASAN
doesn't print "at call N" or notes like "(hot_chunks_num=3 > cap=2)".

A capacity of 2 also looks hard to reach on real hardware.
mlx5dr_icm_pool_create() sizes the array like this:

	num_of_chunks = DIV_ROUND_UP(max_hot_size, entry_size) + 1;
	pool->th = max_hot_size;

Here max_hot_size is a percentage of the byte size of the largest chunk.
A capacity of 2 would need max_hot_size <= entry_size. Real device caps
make the array thousands of entries long.

The overflow itself looks real. Before this patch, a failed sync left
hot_chunks_num and hot_memory_size unchanged.

Could the commit message include the real KASAN splat? Or could it say
plainly that the overflow was found by injecting sync failures in a
test harness, and describe how they were injected?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c
> index 1b928b40686e5..a906a72601c4f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c

[ ... ]

> @@ -368,7 +373,15 @@ static int dr_icm_pool_sync_all_buddy_pools(struct mlx5dr_icm_pool *pool)
>  
>  	err = mlx5dr_cmd_sync_steering(pool->dmn->mdev);
>  	if (err) {
> -		mlx5dr_err(pool->dmn, "Failed to sync to HW (err: %d)\n", err);
> +		/* The hot chunks could not be flushed. Put the pool in an
> +		 * error state so that no further chunks are queued (which
> +		 * would overflow hot_chunks_arr), and no new chunks are
> +		 * served. The sync is not retried.
> +		 */
> +		mlx5dr_err(pool->dmn,
> +			   "Failed to sync to HW (err: %d), disabling ICM pool\n",
> +			   err);
> +		pool->error_state = true;
                ^^^^

[Severity: Medium]
Does one SYNC_STEERING failure now disable this pool for good? Only
mlx5dr_icm_pool_destroy() clears error_state, and the sync is never
retried.

After that, every mlx5dr_icm_alloc_chunk() call returns NULL. STE hash
table allocation in mlx5dr_ste_htbl_alloc(), modify action allocation
and pattern allocation in dr_ptrn.c all fail. No new steering rules can
be inserted until the domain is torn down by an eswitch mode change,
driver reload or health recovery. Each later mlx5dr_icm_free_chunk()
also leaves its segment reserved in the buddy.

mlx5dr_cmd_sync_steering() only skips the device internal error state:

	if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
		return 0;
	...
	return mlx5_cmd_exec_in(mdev, sync_steering, in);

That means transient host-side errors also set the flag. For example,
the SYNC_STEERING inbox is at most 16 bytes, so alloc_msg() in cmd.c
skips the message cache:

	if (in_size <= 16)
		goto cache_miss;

It then allocates with GFP_KERNEL, which can fail with -ENOMEM under
memory pressure. Command timeouts and the -ENXIO paths are passed up
the same way.

Also, error_state is per pool (STE, MODIFY_ACTION, MODIFY_HDR_PTRN), but
the sync is device-wide. A later successful sync from another pool won't
re-enable this one.

The commit message says a chunk may only return to the buddy after a
sync confirms HW no longer references it. That explains not recycling
the queued hot chunks. Does it also justify refusing to allocate from
segments that are already in the buddy free lists? Those were either
freed after an earlier successful sync or never used.

Would it work to stop queuing only when hot_chunks_num reaches the array
capacity, leaving those segments reserved, and to retry the sync on
later frees? That avoids the overflow and keeps the no-recycle rule
without disabling the pool permanently.

>  		return err;
>  	}
>  

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261118173227.1957670-1-tariqt%40nvidia.com
