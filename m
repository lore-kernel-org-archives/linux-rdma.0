Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792752759;
	b=PbfbxkqblJDK30VwGTBHLrru2H3DIdA2M7giCygAAxQS0EQqrX4ND8N86Pvs3VukhC6T
	 OX7ONAoVQL0nW/oIxRTJBHH0r1XK2vd3zIhqw6rcLTJkQZbV1bxszt8Oj3A0P6qC0cCPq
	 uy/GbOnKoxhWdaov8rlXjf1TuRCyTVJArf8i7SulPw9QAWgbdrPHcKYmHQq+dT6XZJjaV
	 AJBjF0xCZf2Gcbn54pdUmImd67MiCXkNL+LYdQ8XMRAY7jB0s8XQRrSUBUTF+yqLSVCqb
	 Ej0DB0oWueL0/afph6UxW7tHcONUa1OH49tfQYGGqCpQE2TC6oPNVB7iGHbWrsTzxww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792752759;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=KsVEsBPcGVK4EAwjzqdM3Y1x7rQhCpb3ibnQ5cA96g0=;
	b=hEjRHBr7iV95oZfoIlHorWWpAoGO6offpi6aveYt126AfTkT/ujwOwDGRPSRsyuCSl77
	 9uZzQBCb+NELTVTYVBaPb+NFXHeGr1h5X2zGxLfpatxCdjzGM8HRcwpQXZossFMZKMBLH
	 m31lWYpgRxCfq0hOrU+gg+77MIyJJarZH9zAm9TGviY2O7nIOV+FpvPAg3+ZHoWqAZ/cq
	 SxvtyhCzSc5rP/BQKkK2dTAo1mtRfMxRXCFV9i9CV0CibxA+aJfZ0Wg5QpGjRI5rAKh6V
	 vi48TwJrcdKhz+F3xzM0zbb0l/GLIpxzln4++8aLIPiFS1ki3CSvlpNY9ni0MckHPHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="hvwJ/5lF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9438C606A32F;
	Fri, 23 Oct 2026 10:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hvwJ/5lF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9831F01825;
	Fri, 23 Oct 2026 10:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792752759;
	bh=KsVEsBPcGVK4EAwjzqdM3Y1x7rQhCpb3ibnQ5cA96g0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=hvwJ/5lFaTSWVxSsk2Dhy466WEayc7Aokq8UUSPIBA9Fge6UFKUNNqQWEN22+M7Ei
	 CmE2nXhegKd0hBSRdRi1jF55rQvMkP3wC5YqNpANmz69ZUAw3OpesRKZapgfsSWYrr
	 124yl1va2uDTEEmY6HbbJKVKjfFZ6s93Z9PsG5axng2mFdMIjID4QicBwMv3taW8Pp
	 V4wSfm/FL+pNheFSooM0/+/2czuf7YUc/n/TtIEtj1K8vrwxokJZhxWb8FQQeZHJLl
	 jvXfORFkZ3mnuGHWRjfKGZtSXF9wh3jmM8ICwkBqlo7BIr7+Xm5+vg+QCI5mo/H6Zj
	 o32rRXG+fN8EQ==
Subject: Re: [PATCH net 3/3] net/mlx5: DR, Fix out-of-bounds write when sync
 to HW fails
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 acassen@corp.free.fr, valex@nvidia.com, erezsh@nvidia.com, gal@nvidia.com,
 igozlan@nvidia.com, kees@kernel.org, kees+treewide@kernel.org,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, moshe@nvidia.com, prathameshdeshpande7@gmail.com,
 saeedm@nvidia.com, william@theesfeld.net, kliteyn@nvidia.com
Date: Fri, 23 Oct 2026 10:52:37 +0000
Message-ID: <179275275762.3134.7548579754182364985@kernel.org>
In-Reply-To: <20261021074949.3471704-4-tariqt@nvidia.com>
References: <20261021074949.3471704-4-tariqt@nvidia.com>
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

Critical: 0 · High: 0 · Medium: 2 · Low: 0 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The new comments promise that a failed pool stops serving
  chunks, but nothing enforces this.
- [Medium] After a single SYNC_STEERING failure the pool latches into a
  permanent error state while allocation stays open, so device SW ICM…

Pre-existing issues:
- [Low] This problem wasn't introduced by this patch, but the patch now
  relies on it.

--

net/mlx5: DR, Fix out-of-bounds write when sync to HW fails

If the sync to HW fails, mlx5dr_icm_free_chunk() keeps appending to
hot_chunks_arr past its end. This patch adds a sync_failed flag to the
ICM pool. A failed sync sets it, and once it is set, freed chunks are
no longer queued and their ICM stays reserved until the pool is
destroyed.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c
> index 1b928b40686e5..375ab8c2043f9 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c
> @@ -33,6 +33,10 @@ struct mlx5dr_icm_pool {
>  	u64 hot_memory_size;
>  	/* hot memory size threshold for triggering sync */
>  	u64 th;
> +	/* Set when a sync to HW fails - no new chunks are served,
> +	 * and freed chunks are no longer queued.
> +	 */
> +	bool sync_failed;
>  };
>  
>  struct mlx5dr_icm_dm {
> @@ -369,6 +373,12 @@ static int dr_icm_pool_sync_all_buddy_pools(struct mlx5dr_icm_pool *pool)
>  	err = mlx5dr_cmd_sync_steering(pool->dmn->mdev);
>  	if (err) {
>  		mlx5dr_err(pool->dmn, "Failed to sync to HW (err: %d)\n", err);
> +		/* The hot chunks could not be flushed. Put the pool in an error
> +		 * state so that no further chunks are queued (which would
> +		 * overflow hot_chunks_arr) or served (which could reuse ICM
> +		 * that HW may still reference).
> +		 */
> +		pool->sync_failed = true;
>  		return err;
>  	}

[Severity: Medium]

This comment and the comment on the new sync_failed field both say that
no new chunks are served once the flag is set. What enforces that?

mlx5dr_icm_alloc_chunk() never reads pool->sync_failed:

	mutex_lock(&pool->mutex);
	/* find mem, get back the relevant buddy pool and seg in that mem */
	ret = dr_icm_handle_buddies_get_mem(pool, chunk_size, &buddy, &seg);

When the existing buddies are full, dr_icm_handle_buddies_get_mem() goes
on to call dr_icm_buddy_create(). The only reader of the flag is
mlx5dr_icm_free_chunk().

The reason given for not serving chunks also looks inaccurate. The
segments of the hot chunks, and any segments freed after the failure,
stay allocated in the buddy bitmap. For freed chunks, mlx5dr_buddy_free_mem()
is only reached through dr_icm_pool_clear_hot_chunks_arr(), so the
buddy cannot hand that ICM out again anyway.

Should these comments be changed, or is mlx5dr_icm_alloc_chunk() missing
a sync_failed check?

[ ... ]

> @@ -475,6 +485,14 @@ void mlx5dr_icm_free_chunk(struct mlx5dr_icm_chunk *chunk)
>  	/* move the chunk to the waiting chunks array, AKA "hot" memory */
>  	mutex_lock(&pool->mutex);
>  
> +	/* If a previous sync to HW failed, the pool is in an error state.
> +	 * The chunk must not be queued. ICM memory is not returned to the
> +	 * buddy allocator - it is reclaimed only when the pool is destroyed.
> +	 * Just free the chunk's bookkeeping struct.
> +	 */

[Severity: Low]

This is a pre-existing issue and was not introduced by this patch, but
the new error handling now depends on it.

The commit message says ICM may only be returned after a sync has
confirmed that HW no longer references it. At teardown,
mlx5dr_domain_destroy() ignores the result of its own sync:

	/* make sure resources are not used by the hardware */
	mlx5dr_cmd_sync_steering(dmn->mdev);
	...
	dr_domain_uninit_resources(dmn);

mlx5dr_icm_pool_destroy() then calls dr_icm_pool_clear_hot_chunks_arr()
unconditionally. After that, dr_icm_buddy_destroy()->dr_icm_pool_mr_destroy()
gives the SW ICM back to the device through mlx5_dm_sw_icm_dealloc().

So when the patch says the quarantined ICM is reclaimed "when the pool
is destroyed", that ICM can go back to the device even though no sync
has ever succeeded.

Teardown behaved the same way before this patch. Also,
mlx5dr_domain_destroy() returns -EBUSY unless dmn->refcount is 1, so
the tables and matchers that referenced this ICM are already gone by
that point.

Is it acceptable to rely on teardown here, given that it doesn't check
whether the final sync succeeded?

> +	if (pool->sync_failed)
> +		goto out;
> +

[Severity: Medium]

Once sync_failed is set, can this pool keep growing device SW ICM and
host memory with no limit?

Nothing clears the flag. mlx5dr_icm_free_chunk() is the only runtime
caller of dr_icm_pool_sync_all_buddy_pools(), and it now jumps to out
before reaching the sync. A transient SYNC_STEERING failure, such as a
FW timeout or an error status, is therefore never retried.

mlx5dr_cmd_sync_steering() returns 0 when the device is in
MLX5_DEVICE_STATE_INTERNAL_ERROR. A non-zero return therefore means the
command failed on a device that is still running, and the pool can stay
in service for a long time.

In this state, every mlx5dr_icm_free_chunk() frees only the kmem_cache
object. The segment never reaches mlx5dr_buddy_free_mem(), and
buddy->used_memory is never decremented. This also applies to chunks
that were allocated after the failure.

Meanwhile mlx5dr_icm_alloc_chunk() keeps serving chunks. When the
buddies fill up, it takes this path:

mlx5dr_icm_alloc_chunk()
  dr_icm_handle_buddies_get_mem()
    dr_icm_buddy_create()
      dr_icm_pool_mr_create()
        mlx5_dm_sw_icm_alloc()

That path also allocates a new mkey, buddy bitmaps and, for STE pools,
the kvzalloc'd ste_arr/hw_ste_arr/miss_list caches.

With ongoing rule add/delete or hash table rehash, each alloc/free cycle
permanently uses up more ICM. Eventually mlx5_dm_sw_icm_alloc() fails
and the domain can no longer insert rules until it is destroyed.

The commit message covers reclaim being deferred to pool destruction,
but it doesn't mention that allocation keeps going in the meantime.

Would it make sense to either fail allocation once sync_failed is set,
or retry the sync on later frees and clear the flag when it succeeds?

>  	pool->hot_memory_size += mlx5dr_icm_pool_get_chunk_byte_size(chunk);
>  
>  	hot_chunk = &pool->hot_chunks_arr[pool->hot_chunks_num++];

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261021074949.3471704-1-tariqt%40nvidia.com
