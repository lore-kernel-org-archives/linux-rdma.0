Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A1C495AF3;
	Mon, 21 Sep 2026 12:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994937; cv=none; b=Ro3+os++gpuZTVWiKhwQ4aoZp4jW4qfs/KU8j07Nkla5X6kNrDW/Y0Hf5kWTe8kX5i9spRwyuJ7dghOxhIiwjrLn2c19/u3zk8KLqEyzE1hnfXgofmLCWT9/1RUFraTuFD4YIWLkGNBxHf2wkzq/NdUMPE86olamuQPD2eoEbio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994937; c=relaxed/simple;
	bh=Lvz1+adIfTVALde6cIc9D2krFiJkrABbwz95Yp9nPFQ=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FnDrstjamqQ1kKbSOZUqHxT6zVrmbsfJKxqCza3P4sgPqFj6Px7fP969B5YjLR9+UGYRYHfoZg4Q386sbCxVpae3Ck5UqGEx3ZjvXPgzxwjnGxqeMpIMLDzskg8T00kbCF0TFpIvivlyObW46n2C6ZuPdfomEhAw08YRQs6AjT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UE6SO3WY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UE6SO3WY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BBE1F000FF;
	Mon, 21 Sep 2026 12:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789994932;
	bh=NFKSxMIgnM898Y7oTLkz3ataAvKd+EhOD1s4RO4tj3U=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=UE6SO3WY/k6pXgr3BejY0rHDo2ynd6BaUlT/AIlFdd8aM5xlG+04BJet4FBMpEqek
	 691IzMIrJ/nI62ercdIsl436gXX0iawHxYoUNOSeNwSih0MzvVY4bT+DcEwhi0CK7d
	 xJDnvQkwpPONuQIiiIieNvXQ4eJ1P8yzOvY+6dsPe1XCqPv8Zr4EeWsVkE9BW8XAdI
	 nTau/53RsFNf51Of017LHrMAJA6VvxCvV9LBZoBrCgvbz0ASLW+z7g8NA7ZZpVEE7w
	 CUbEdzSPxRJXNg05JbI0IyixBTS+7gHUCrhfd2Yp9gVq5OwJ89i1U2wZvKuwM007fU
	 hnmOSsIuC7Xpg==
Subject: Re: [PATCH] net/mlx5: Fix rev_entry reference leak in
 mlx5_tc_ct_shared_counter_get()
From: netdev-bot+sashiko@kernel.org
To: vulab@iscas.ac.cn
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, netdev@vger.kernel.org,
 ozsh@mellanox.com, pabeni@redhat.com, roid@nvidia.com, saeedm@nvidia.com,
 tariqt@nvidia.com, stable@vger.kernel.org
Date: Mon, 21 Sep 2026 12:48:50 +0000
Message-ID: <178999493051.2160803.6214466192510331412@kernel.org>
In-Reply-To: <20260917113131.2149024-1-vulab@iscas.ac.cn>
References: <20260917113131.2149024-1-vulab@iscas.ac.cn>
X-sashiko-severity: Medium
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

Critical: 0 · High: 0 · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message misidentifies the condition that makes the
  leak reachable.
- [Medium] The Fixes: tag points at the wrong commit.

--

net/mlx5: Fix rev_entry reference leak in mlx5_tc_ct_shared_counter_get()

This adds a mlx5_tc_ct_entry_put() on the fall-through path of
mlx5_tc_ct_shared_counter_get() so that the reverse entry reference taken by
mlx5_tc_ct_entry_get() is dropped when the shared counter cannot be reused.
The put itself looks correct; the questions below are about the described
trigger condition and the Fixes tag.

> Fixes: 1edae2335adf ("net/mlx5e: CT: Use the same counter for both directions")
> Cc: stable@vger.kernel.org

[Severity: Medium]
Is this the right commit to blame?  What this patch balances is the entry
reference taken by mlx5_tc_ct_entry_get() in
mlx5_tc_ct_shared_counter_get(), and that reference-taking lookup plus the
matching put on the success path came from a2173131526d ("net/mlx5e: CT:
manage the lifetime of the ct entry object"), not from 1edae2335adf.

git blame on the pre-patch file attributes this whole block to
a2173131526d:

	spin_lock_bh(&ct_priv->ht_lock);
	rev_entry = mlx5_tc_ct_entry_get(ct_priv, &rev_tuple);

	if (IS_ERR(rev_entry)) {
		spin_unlock_bh(&ct_priv->ht_lock);
		goto create_counter;
	}

	if (rev_entry && refcount_inc_not_zero(&rev_entry->counter->refcount)) {
		...
		mlx5_tc_ct_entry_put(rev_entry);
		return shared_counter;
	}

1edae2335adf only contributed the tuple-reversal code above it; at that
point the reverse tuple was looked up with a plain rhashtable_lookup_fast()
and no entry reference was taken, so there was nothing to leak.

With Cc: stable, does the current tag select the wrong backport range?
Trees that contain 1edae2335adf but not a2173131526d (1edae2335adf landed
in v5.9, a2173131526d in v5.12) would be picked, and there
mlx5_tc_ct_shared_counter_get() holds no rev_entry reference at all, so the
hunk cannot apply as written and a hand-resolved backport that added the put
anyway would underflow the rev_entry refcount.

> When the reverse entry is found but its counter is already being
> released, refcount_inc_not_zero() fails and the reference taken by
> mlx5_tc_ct_entry_get() is never dropped before falling through to
> create_counter.

[Severity: Medium]
Can the "counter is already being released" case actually happen for a
non-NULL rev_entry?

mlx5_tc_ct_entry_get() only returns a non-NULL, non-ERR entry after both the
valid test and the entry refcount succeed:

	if (entry && mlx5_tc_ct_entry_valid(entry) &&
	    refcount_inc_not_zero(&entry->refcnt)) {
		return entry;

So the returned rev_entry is VALID and holds a live reference, which means
it cannot be inside mlx5_tc_ct_entry_del() - the only teardown site calling
mlx5_tc_ct_counter_put().  The other mlx5_tc_ct_counter_put() call, in the
err_orig path of mlx5_tc_ct_entry_add_rules(), runs before
MLX5_CT_ENTRY_FLAG_VALID is set, so such an entry is never returned by the
lookup either.  A shared counter owned by a live VALID entry therefore
always has refcount >= 1.

Is the reachable trigger instead the private-counter case?
mlx5_tc_ct_counter_create() kzallocs the counter and never calls
refcount_set():

	counter->is_shared = false;
	counter->counter = mlx5_fc_create(ct_priv->dev, true);

so private counters keep refcount == 0 permanently, and
mlx5_tc_ct_entry_add_rules() picks between the two kinds at runtime:

	if (nf_ct_acct_enabled(dev_net(ct_priv->netdev)))
		entry->counter = mlx5_tc_ct_counter_create(ct_priv);
	else
		entry->counter = mlx5_tc_ct_shared_counter_get(ct_priv, entry);

nf_ct_acct_enabled() reads net->ct.sysctl_acct, the writable per-netns
net.netfilter.nf_conntrack_acct sysctl, so both counter kinds coexist after
accounting is toggled from enabled to disabled.  A new entry then takes the
shared path, finds a live reverse entry owning a private refcount == 0
counter, refcount_inc_not_zero() fails, and the rev_entry reference is
leaked.

Could the changelog describe that path instead?  As written the fixed branch
reads like dead code, which makes reachability hard to judge for stable, and
it hides the companion cleanup question: should
mlx5_tc_ct_counter_create() refcount_set() the private counter, or should
the consumer test is_shared explicitly?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> index 6c87a1c7db095..c1841ce74d9ac 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> @@ -1082,6 +1082,9 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
>  
>  	spin_unlock_bh(&ct_priv->ht_lock);
>  
> +	if (rev_entry)
> +		mlx5_tc_ct_entry_put(rev_entry);
> +
>  create_counter:
>  
>  	shared_counter = mlx5_tc_ct_counter_create(ct_priv);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260917113131.2149024-1-vulab%40iscas.ac.cn
