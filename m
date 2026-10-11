Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082D44477F6;
	Sun, 11 Oct 2026 12:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791720164; cv=none; b=QmlFZYEUDXoUbI00M3nnCnSmNID5TN9/m0TEWyAiw01hWZQRUkcoqJMdTjIVvdMK6pnTKp0fGSE/l20mUvnux0wyg/BlUmmnDb6JsUxYIXQN0pZjPfG3AJmkVcRqQmuUebwc7oMp2U9frMS75BfRW7u7IAgVczsSYiuXwT0zZ1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791720164; c=relaxed/simple;
	bh=v1RwKlMrACowwS5vVjB0ys5BgeDYRMBfSl6tg3QPtP8=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dJJG3kve3CzgQcYVFkI3+8vk5UQmi8Fo967Mx3NO/IYDp1/54OUQsz/pTWUy7xFQ1kPQErpQjDqs7hxx1LeWKPEUz7DmRKglyxlet1kEetBjwlyzcb6xCV27ORMasPARqFeGUypHCUajHhSpY0QtGxznCqZLUZOJnYgAJN90GSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fwmhVqJk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fwmhVqJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88BAC1F0089B;
	Sun, 11 Oct 2026 12:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791720152;
	bh=Y/eNks/oUcLXUhYub3eXxgbnRhbF2SJ7hDb+WjvV0BY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=fwmhVqJkmEbHmWmF4VV5eYqdiKbM/gNn2favBrMZWTLUiIbu0gsz+MNHl+hW7vpFR
	 MSY4rEfBlonjPJfN0GkK7G0iN1TAFeKaQqJ3xYIaEsvwW720ukQLBlprWsuICRrsb7
	 3l56PyCJ71s2IjxOaFeYgKzLgCPHNW5FGjM5vOfESRrdOxEaA2cqHa37It1GnuSNI4
	 rk1aGuxkbgU3T1wcjiXiy8Az8X158vfWp7tAMIbFYW+h/kf3YygU3rLDs5VYUcwPUN
	 23qd47SbPth6kZdPGzgQ5d2gVJbpZQ1FkHRFTnlcQj58diCF7ntgVBO1wh5o0GVQTX
	 mql74xqq3XvqQ==
Subject:
 Re: [PATCH net] net/mlx5: HWS, fix modify header pool match for copy actions
From: netdev-bot+sashiko@kernel.org
To: acassen@corp.free.fr
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, moshe@nvidia.com, kliteyn@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Sun, 11 Oct 2026 12:02:31 +0000
Message-ID: <179172015106.434549.17424370509568875552@kernel.org>
In-Reply-To: <20261010120147.135825-1-acassen@corp.free.fr>
References: <20261010120147.135825-1-acassen@corp.free.fr>
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
issue(s) to consider.

Critical: 0 · High: 1 (1) · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] On big-endian CPUs, the comparator this fix now relies on still
  lets modify headers with different control words share a pool.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but
  mlx5_cmd_hws_modify_header_alloc() (fs_hws.c:1459-1515) has a use-…

--

net/mlx5: HWS, fix modify header pool match for copy actions

This patch changes mlx5_fs_hws_mh_pool_match() to call the HWS core
helper mlx5hws_pat_compare_pattern() in place of its own loop. The goal
is to compare COPY and ADD_FIELD actions in full. The helper is no
longer static, and its prototype with kernel-doc is added to mlx5hws.h.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c
> index 86828e329187d..cd888756e9421 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c
> @@ -389,7 +389,7 @@ bool mlx5_fs_hws_mh_pool_match(struct mlx5_fs_pool *mh_pool,
>  			       struct mlx5hws_action_mh_pattern *pattern)
>  {
>  	struct mlx5hws_action_mh_pattern *pool_pattern;
> -	int num_actions, i;
> +	int num_actions;
>  
>  	pool_pattern = mh_pool->pool_ctx;
>  	if (WARN_ON_ONCE(!pool_pattern))

[Severity: High]
This is a pre-existing issue, but can mh_pool already be freed when it is
dereferenced here?

mlx5_cmd_hws_modify_header_alloc() walks hws_pool->mh_pools without any
lock:

    xa_for_each(&hws_pool->mh_pools, i, pool) {
        if (mlx5_fs_hws_mh_pool_match(pool, &pattern)) {

mlx5_fs_create_mh_pool() publishes the new pool with xa_insert() before
mlx5_fs_hws_mh_pool_acquire_mh() and kmemdup() run. If either of those
fails, the error path frees the pool right away:

    destroy_pool:
        if (!known_pattern)
            mlx5_fs_destroy_mh_pool(pool, &hws_pool->mh_pools, cnt);

mlx5_fs_destroy_mh_pool() {
    xa_erase(mh_pools, index);
    mlx5_fs_hws_mh_pool_cleanup(pool);
    kfree(pool);
}

Nothing here takes a refcount or waits for an RCU grace period.

Suppose a second caller got the same pool pointer from xa_for_each(). It
could then read the freed pool->pool_ctx, pool_pattern->sz and
pool_pattern->data in mlx5_fs_hws_mh_pool_match(). If the match succeeds,
it would call mlx5_fs_hws_mh_pool_acquire_mh() on the freed pool and store
the dangling pointer in modify_hdr->fs_hws_action.fs_pool.

Concurrent callers look reachable. mlx5_tc_ct_entry_create_mod_hdr() calls
mlx5_modify_header_alloc() directly, without a mod_hdr_tbl lock. It runs
from the WQ_UNBOUND nf_ft_offload_add workqueue under
down_read(&flowtable->flow_block_lock), so several CT entries can be
offloaded in parallel.

This patch only changes the comparison inside the matcher, so the race is
no more or less exposed than before.

[ ... ]

> @@ -398,12 +398,8 @@ bool mlx5_fs_hws_mh_pool_match(struct mlx5_fs_pool *mh_pool,
>  	if (pattern->sz != pool_pattern->sz)
>  		return false;
>  	num_actions = pattern->sz / MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto);
> -	for (i = 0; i < num_actions; i++) {
> -		if ((__force __be32)pattern->data[i] !=
> -		    (__force __be32)pool_pattern->data[i])
> -			return false;
> -	}
> -	return true;
> +	return mlx5hws_pat_compare_pattern(num_actions, pool_pattern->data,
> +					   num_actions, pattern->data);

[Severity: High]
On big-endian hosts, does mlx5hws_pat_compare_pattern() actually compare
the control dword?

For actions other than COPY and ADD_FIELD, it does this:

    /* Compare just the control, not the values */
    if ((__force __be32)actions[i] !=
        (__force __be32)cur_actions[i])
        return false;

The elements are __be64, so this cast keeps the low 32 bits of the loaded
value:

- On little-endian, those are memory bytes 0-3. That is PRM dword 0, which
  holds action_type, field, offset and length.
- On big-endian, they are bytes 4-7. That is dword 1, which holds the
  immediate data for SET and ADD.

The device never sees that data dword in the pattern. From
mlx5hws_cmd_header_modify_pattern_create():

    if (type != MLX5_MODIFICATION_TYPE_COPY &&
        type != MLX5_MODIFICATION_TYPE_ADD_FIELD)
        /* Action typ-copy use all bytes for control */
        MLX5_SET(set_action_in, &pattern_data[i], data, 0);

So on big-endian, two SET or ADD patterns that write the same value into
different fields would compare equal. mlx5_cmd_hws_modify_header_alloc()
would then reuse the first pool's mh_data->bulk->hws_action, and the
second rule would write to the wrong field. That is the symptom the commit
message describes.

Also, the helper picks the full 64-bit compare based only on the opcode of
the requested action:

    u8 action_id =
        MLX5_GET(set_action_in, &actions[i], action_type);

Could an existing COPY pool then match an incoming SET whose data dword
equals the COPY's dst dword? In that case the NIC would run a COPY instead
of the SET. That would leave a copy action pool mismatch open on
big-endian.

MLX5_HW_STEERING does not seem to depend on !CPU_BIG_ENDIAN.

The commit message says the old loop "compares only the first half of each
action". The new kernel-doc in mlx5hws.h says "Return: true if the
patterns differ only in values". Neither statement holds on big-endian.

The truncating cast was already in the old fs_hws loop and in
mlx5hws_pat_find_cached_pattern(). This patch, however, sends pool
matching through the helper and documents it as a control-only compare.

Would it be safer to read the first dword explicitly, for example
((__be32 *)&actions[i])[0], or to use MLX5_GET on the control fields?

>  }
>  
>  struct mlx5hws_action *mlx5_fc_get_hws_action(struct mlx5hws_context *ctx,

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261010120147.135825-1-acassen%40corp.free.fr
