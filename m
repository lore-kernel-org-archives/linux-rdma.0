Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795152920;
	b=uqdyp/BJq0+cp2hGqC7nTkubq8nk9TzNDqH8nvRf8zshMFooQkZacYTBJAAhZrWcRlEu
	 lbBbhyGMQcxrJwvGY14Iw7FbG7pXij2gaG3y1tPXN0TxP+ftMyftCPrwZOBp/679sV8EU
	 fZtJEkeXiHvMFE2OI9nA3LpTDGnCt7MFz/RiJYbVGVRKtzds6++YH6iaL7btQ7EQv3FAg
	 mQGm2/YsotsrjGJ5mjQiS9TpQfdMAf6+PK7jrx0s6NEcW6fZu4lA+foOajQe46wZ+tnV7
	 fLPZYzYdhMZShuFpxZJCg7iBNKejZQEY7u/7NNJa9o5z0wdha5LNGHhLFBTxT22mi5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795152920;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=DjvQqhMP94B6pkXRIu5JFvHLBpFWSNq39QBHFx2ALQo=;
	b=mY/x0Uw8MTllHmplbRfN6QjklaWYZUn4U/LEIorDIOF4js5xNatMpMVt0fkxW0l/mdRx
	 iXdI6WXwBDc7yuilI2OWdsp8vqJ54rigpr5LYgHyV03EyUK5sb4daxoEu29DEe/fgQ+2t
	 EQes9V+quSl5L1qOlNs/jOAfi+KO8Rqcclj54UXuHxzFyEUDYak7VZjR4+YgxXxhdAOba
	 u79mt6LySm+0IWGkzAhMoTVA6Uv5kt5xsIA9GCmmWd+Pv+1XMVWeTlRVezrzzr57Ic2O/
	 Yo8AIxdfXFTZ+6mlF9cMIIBOmta0mYhIIZmnJjoIRZBvuUyLw4quy7slLgQ+Nzqforw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RCEB3UZK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4C6606A325;
	Fri, 20 Nov 2026 05:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RCEB3UZK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7491F000CF;
	Fri, 20 Nov 2026 05:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795152920;
	bh=DjvQqhMP94B6pkXRIu5JFvHLBpFWSNq39QBHFx2ALQo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=RCEB3UZK6ItV1J7msmiXhKwoSjJicjoK64DETqry3RWzERBhCySCWTHn6pHPAMLa8
	 64ccoS23cyFcaV6pMJbIAIE/FkoklawGt4WxBQxDKuHeSGk+sPpTxDGg+FC70dADQv
	 JcYK3K/TKWEOEf+xWg7BWfYc63cUFAxQQlX09SeP2fiaiEjpYXGsyZCAxjZWdlGYee
	 MASAd07hZ5mw0vkubQ6eNortOTClyNqUhZ3naLqCi+YTmCasQmYYpYMfvV0YVYxydp
	 zICzsEQxBNuzLH3E/QO19rVj8QLd+7CyDYYW5iZqoR87HRnwq3XrIwIxbmdHzJ7UhW
	 NBWNqOI+p08AA==
Subject: Re: [PATCH net V2 1/2] net/mlx5: HWS, Handle NULL in vport
 destination action creation
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 acassen@corp.free.fr, valex@nvidia.com, erezsh@nvidia.com, gal@nvidia.com,
 kees+treewide@kernel.org, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, moshe@nvidia.com,
 prathameshdeshpande7@gmail.com, saeedm@nvidia.com, horms@kernel.org,
 william@theesfeld.net, kliteyn@nvidia.com
Date: Fri, 20 Nov 2026 05:35:18 +0000
Message-ID: <179515291858.3136.13333642056498222976@kernel.org>
In-Reply-To: <20261118173227.1957670-2-tariqt@nvidia.com>
References: <20261118173227.1957670-2-tariqt@nvidia.com>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message for "net/mlx5: HWS, Handle NULL in vport
  destination action creation" describes only part of what the bug did.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the same
  caller, mlx5_fs_fte_get_hws_actions() in…

--

net/mlx5: HWS, Handle NULL in vport destination action creation

This patch makes mlx5_fs_get_dest_action_vport() return NULL as soon as
mlx5hws_action_create_dest_vport() fails. A NULL entry is therefore never
inserted into the vport destination xarray. Before this change, inserting
NULL could later cause a NULL dereference in hws_action_destroy_hws().

> The next mlx5hws_action_create_dest_vport() failure will try to
> insert NULL again, but xa_insert() will return -EBUSY, because
> we already have NULL entry. In such case the code will go into
> error flow of action creation, and eventually will cause NULL
> dereference at hws_action_destroy_hws().

[Severity: Low]
This isn't a bug, but does this describe the whole impact? The text covers
a later creation for the same idx failing again. What about a later
creation that succeeds?

When the entry is NULL, __xa_insert() stores XA_ZERO_ENTRY instead:

lib/xarray.c:__xa_insert() {
    ...
	if (!entry)
		entry = XA_ZERO_ENTRY;
    ...
}

xa_load() turns that back into NULL. The slot looks empty but stays
reserved.

Suppose a later mlx5hws_action_create_dest_vport() call succeeds, for
example once a transient kzalloc or STC pool failure has cleared. The old
code then appears to loop:

mlx5_fs_get_dest_action_vport()
  dest_load:
    xa_load() returns NULL
    mlx5hws_action_create_dest_vport() returns a valid action
    xa_insert() returns -EBUSY
    mlx5hws_action_destroy(dest)
    goto dest_load

Wouldn't this spin forever and hang rule insertion for that vport?

The fix covers both outcomes, since NULL is never inserted now. Could the
commit message also mention the livelock?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> index cbcbc2b62809d..de22e7279a312 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> @@ -441,6 +441,8 @@ mlx5_fs_get_dest_action_vport(struct mlx5_fs_hws_context *fs_ctx,
>  
>  	dest = mlx5hws_action_create_dest_vport(ctx, vport_num,	vhca_id_valid,
>  						dest_attr->vport.vhca_id, flags);
> +	if (!dest)
> +		return NULL;
>  
>  	err = xa_insert(dests_xa, idx, dest, GFP_KERNEL);
>  	if (err) {

[Severity: High]
This is a pre-existing issue, but can the same caller,
mlx5_fs_fte_get_hws_actions(), still oops on a NULL action in other
destination cases?

In three cases the result goes into fs_actions[] and is counted before
the NULL check. These are FLOW_TABLE_NUM (when the action has to be
created), RANGE and FLOW_SAMPLER:

drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c:mlx5_fs_fte_get_hws_actions() {
    ...
				dest_action = mlx5_fs_create_dest_action_table_num(fs_ctx,
										   dst);
				fs_actions[num_fs_actions++].action = dest_action;
				break;
			case MLX5_FLOW_DESTINATION_TYPE_RANGE:
				dest_action = mlx5_fs_create_dest_action_range(ctx, dst);
				fs_actions[num_fs_actions++].action = dest_action;
				break;
    ...
			case MLX5_FLOW_DESTINATION_TYPE_FLOW_SAMPLER:
				dest_action =
					mlx5_fs_get_dest_action_sampler(fs_ctx,
									dst);
				fs_actions[num_fs_actions].action = dest_action;
				fs_actions[num_fs_actions++].sampler_id =
							dst->dest_attr.sampler_id;
				break;
    ...
			if (!dest_action) {
				err = -ENOMEM;
				goto free_actions;
			}
    ...
}

Each of these can return NULL:

  mlx5hws_action_create_dest_table_num(): allocation failure or STC pool
  exhaustion

  mlx5hws_action_create_dest_match_range(): invalid range parameters, or
  allocation, definer or STC failure

  mlx5_fs_get_dest_action_sampler(): GFP_ATOMIC allocation or
  __xa_insert() failure, or failure to create the sampler action

The free_actions path then calls teardown on every counted entry:

mlx5_fs_destroy_fs_actions()
  mlx5_fs_destroy_fs_action()
    mlx5hws_action_get_type(fs_action->action)
      return action->type;   <-- NULL dereference

The other patch in this series, "net/mlx5: DR, Fix out-of-bounds write
when sync to HW fails", only touches sws/dr_icm_pool.c and does not fix
this.

Could dest_action be checked before it goes into fs_actions[]?
Alternatively, mlx5_fs_destroy_fs_actions() could skip NULL entries.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261118173227.1957670-1-tariqt%40nvidia.com
