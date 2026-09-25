Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACDE4279E3;
	Fri, 25 Sep 2026 07:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790322181; cv=none; b=dOgcBN5MgRJYGvZj/rCogvvE3mpT0i+EaQPDSsAaPryM4H0/R5xVkoQ+tiF+Tsya/xw9URZ32wVmM4kYuMSZpPRXmUGFiNT9qt76hoy/B4XlzLs0TmsWK0jFljkURQuFugkipIml0BA4a2H4Ln1aqW6mX1pj5C9pUHBPoAcHMYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790322181; c=relaxed/simple;
	bh=faKLy99jfXh5Bdw9bgAz5BVyXtyH14SJgh3PYPr2L+U=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=N1ii3EzJBOtUN6qkQuNYw24lzdJ810wyMUs9fVfjd81a6BBvhKa+i67NZfHcZgMcvnuIwxS0/jNKlQFU3LHCvf2l1Jppj94sq/KOz5f+QV3QhguKqbD9ZuWWglOa0NADD6cs/dorXa3osklfV96cW7eG0IvNO56z/WCoUY3QQxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wnlz4Jbj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wnlz4Jbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E141F000FF;
	Fri, 25 Sep 2026 07:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790322179;
	bh=vjsg4Wj+K6OrOCo4Yqdu+MiECMz9xX2jvzxJRIo10mc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Wnlz4JbjmIce14GtOMBFOEB87hINaCwgWrhbq6lFd63F/0JbLjY/e7KlnBSdB06fm
	 RbhCIRML+fIA0BZJPtGA1hMLtzsNM6LwMqQhG9K/wGJKnqwFgGpGnilaWgnvX8gcOZ
	 Ufj+oRLgwmnTXrjXU6+DAzDNGjlCbYxg3irrZXFMDJdXxCzLL6q0ePUO93gzTkNF5W
	 /iylKP3PUXhr6evAQLevxuSHTvcEe8jXdpgNDm1//cAhqPIAY9ydtSYyhoskLQyv6q
	 ou5DtoS3aetApF+V1mwBYNpu6S9JGqIMZ9xihd1sBfDPTTars3hAuq82e+LPkIKDmQ
	 oBq+dTlA4tocg==
Subject: Re: [PATCH net] net/mlx5: HV VHCA: Fix the agent registration race
From: netdev-bot+sashiko@kernel.org
To: ginger.jzllee@gmail.com
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, kuba@kernel.org
Date: Fri, 25 Sep 2026 07:42:58 +0000
Message-ID: <179032217859.2160803.16820194707566685207@kernel.org>
In-Reply-To: <20260922074246.20411-1-ginger.jzllee@gmail.com>
References: <20260922074246.20411-1-ginger.jzllee@gmail.com>
X-sashiko-severity: Medium
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

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The patch's second hunk does not achieve its stated purpose
  and leaves the lock coverage of…

--

net/mlx5: HV VHCA: Fix the agent registration race

This keeps agents_lock held across the duplicate-type check, the agent
allocation and the publish into hv_vhca->agents[] in
mlx5_hv_vhca_agent_create(), so two concurrent create calls for the same
type can no longer both pass the check.  It also wraps the read of
hv_vhca->agents[MLX5_HV_VHCA_AGENT_CONTROL] in mlx5_hv_vhca_cleanup()
with agents_lock.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
> index 4c4cf6da519fa..eac8afdfc67a3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
> @@ -228,7 +228,10 @@ void mlx5_hv_vhca_cleanup(struct mlx5_hv_vhca *hv_vhca)
>  	if (!hv_vhca)
>  		return;
>  
> +	mutex_lock(&hv_vhca->agents_lock);
>  	agent = hv_vhca->agents[MLX5_HV_VHCA_AGENT_CONTROL];
> +	mutex_unlock(&hv_vhca->agents_lock);
> +
>  	if (agent)
>  		mlx5_hv_vhca_control_agent_destroy(agent);

[Severity: Medium]
What does this new critical section in mlx5_hv_vhca_cleanup() actually
protect?  The lock is dropped immediately after the load, and the pointer
is consumed afterwards:

	mutex_lock(&hv_vhca->agents_lock);
	agent = hv_vhca->agents[MLX5_HV_VHCA_AGENT_CONTROL];
	mutex_unlock(&hv_vhca->agents_lock);

	if (agent)
		mlx5_hv_vhca_control_agent_destroy(agent);

So the only guarantee gained over the previous code is a non-torn load of
an aligned pointer, which a plain load already provides.  Nothing is
serialized against the destroy itself.  Extending the lock over the call
is not an option either, since mlx5_hv_vhca_agent_destroy() takes
agents_lock itself and that would self-deadlock.

The changelog says:

    While at it, read hv_vhca->agents[MLX5_HV_VHCA_AGENT_CONTROL] under
    the lock in mlx5_hv_vhca_cleanup() as well, since that slot is
    written under the lock.

Is that accurate?  mlx5_hv_vhca_init() still stores to the same slot with
no lock held:

	agent = mlx5_hv_vhca_control_agent_create(hv_vhca);
	if (IS_ERR_OR_NULL(agent)) {
		mlx5_hv_unregister_invalidate(hv_vhca->dev);
		return;
	}

	hv_vhca->agents[MLX5_HV_VHCA_AGENT_CONTROL] = agent;

That store is now fully redundant with the locked publish that
mlx5_hv_vhca_agent_create() already performs:

	hv_vhca->agents[type] = agent;
	mutex_unlock(&hv_vhca->agents_lock);

and it contradicts the field's own contract:

	struct mutex                agents_lock; /* Protect agents array */

Can it also race with the locked reader?  mlx5_hv_register_invalidate()
has already run by that point, and mlx5_hv_vhca_agent_create() queues
work before returning to init:

mlx5_hv_vhca_agent_create()
  mlx5_hv_vhca_agents_update()
    mlx5_hv_vhca_invalidate()
      queue_work(hv_vhca->work_queue, &work->invalidate_work);

while the worker reads the array under the mutex:

	mutex_lock(&hv_vhca->agents_lock);
	for (i = 0; i < MLX5_HV_VHCA_AGENT_MAX; i++) {
		struct mlx5_hv_vhca_agent *agent = hv_vhca->agents[i];

Since the value stored by init() is identical to the one already
published under the lock, the practical effect today looks like a benign
data race that KCSAN would flag rather than a functional failure.  Would
it be cleaner to drop the unlocked assignment in mlx5_hv_vhca_init()
instead, so agents[] has exactly one locked writer per slot, drop the
no-op lock/unlock in mlx5_hv_vhca_cleanup(), and adjust the changelog
wording accordingly?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260922074246.20411-1-ginger.jzllee%40gmail.com
