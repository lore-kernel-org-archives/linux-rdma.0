Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022B31C2AA;
	Sun, 27 Sep 2026 08:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790499190; cv=none; b=GtTw33XP0nJXLXq0hch7tIm9Qw0bgzgnqnm2KnmKa9H6ezmPkp5LBcezgKCjIM95FAZbCyASO7uVdXD//5lqvnNdjVPVOqVRh0F/t2zWPMGeNiT+6c/0tweVJ8dk8rLUKlYnfI23QS1bAaENclJZJl9daLJ70aHTbrSxWR+clI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790499190; c=relaxed/simple;
	bh=RE5KvbNOR9F0lWLBYDA0FTuNjPviqAarJIiKS/ogrWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vB8qDyOSMfoLotH6XU+/uNNa+8J3gkvNdBLATJGlvEqAFhdE+wZExn9aI5bBT09TKNnBWJgbNkpyh4W4KqaSfkVRJ0bTo2pVmMoNcQs2RWf1LwDOQA8GHsFk6aAiZo1vqKVhTRRo5ZAOwyu0LJn9DEoApNKdjw4NGgTxxddpPI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/sdtxTh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/sdtxTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0DD1F000FF;
	Sun, 27 Sep 2026 08:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790499188;
	bh=7DC87U949zK80OM5Df9MdhIZs83b7YvzK4d7Tw6CCSk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h/sdtxTh8F2j6QM5LHTfmplsdInxTA/lOzRky8R36ylNbdq1mOOa2IPGlvTfrsxmw
	 RDZOFE0izjskJ+Y31hoBlkJnKku/jilhvTZe/RXZP2Pmh9X8V3fLcXUQF9xbdSvNXk
	 +dpzidlLEMKqk3vyegpQMQfs8a+9Scp6I52v9h9/3lKiqKTBnCCnktsDcRA5C6jwjo
	 bhZ97943qPyrMX2fZeSEAenH6AHwGsUP1X0FwJu3DXT7gRa6bLZiYVxj2arnC4YeLm
	 UC5RBthhItidF4xbGddXxLXVyXqEWNg2u0oI30ZJKsjMNjQVqOAIjfJA8UR6s48zBt
	 sAIV03KUOKP7g==
Date: Sun, 27 Sep 2026 09:53:04 +0100
From: Simon Horman <horms@kernel.org>
To: netdev-bot+sashiko@kernel.org
Cc: ginger.jzllee@gmail.com, saeedm@nvidia.com, leon@kernel.org,
	tariqt@nvidia.com, mbloch@nvidia.com, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	kuba@kernel.org
Subject: Re: [PATCH net] net/mlx5: HV VHCA: Fix the agent registration race
Message-ID: <20260927085304.GD13925@horms.kernel.org>
References: <20260922074246.20411-1-ginger.jzllee@gmail.com>
 <179032217859.2160803.16820194707566685207@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <179032217859.2160803.16820194707566685207@kernel.org>

On Fri, Sep 25, 2026 at 07:42:58AM +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).

With a view to move things along, I took a look a this.

> - [Medium] The patch's second hunk does not achieve its stated purpose
>   and leaves the lock coverage of…
> 
> --
> 
> net/mlx5: HV VHCA: Fix the agent registration race
> 
> This keeps agents_lock held across the duplicate-type check, the agent
> allocation and the publish into hv_vhca->agents[] in
> mlx5_hv_vhca_agent_create(), so two concurrent create calls for the same
> type can no longer both pass the check.  It also wraps the read of
> hv_vhca->agents[MLX5_HV_VHCA_AGENT_CONTROL] in mlx5_hv_vhca_cleanup()
> with agents_lock.
> 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
> > index 4c4cf6da519fa..eac8afdfc67a3 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
> > @@ -228,7 +228,10 @@ void mlx5_hv_vhca_cleanup(struct mlx5_hv_vhca *hv_vhca)
> >  	if (!hv_vhca)
> >  		return;
> >  
> > +	mutex_lock(&hv_vhca->agents_lock);
> >  	agent = hv_vhca->agents[MLX5_HV_VHCA_AGENT_CONTROL];
> > +	mutex_unlock(&hv_vhca->agents_lock);
> > +
> >  	if (agent)
> >  		mlx5_hv_vhca_control_agent_destroy(agent);
> 
> [Severity: Medium]
> What does this new critical section in mlx5_hv_vhca_cleanup() actually
> protect?  The lock is dropped immediately after the load, and the pointer
> is consumed afterwards:
> 
> 	mutex_lock(&hv_vhca->agents_lock);
> 	agent = hv_vhca->agents[MLX5_HV_VHCA_AGENT_CONTROL];
> 	mutex_unlock(&hv_vhca->agents_lock);
> 
> 	if (agent)
> 		mlx5_hv_vhca_control_agent_destroy(agent);
> 
> So the only guarantee gained over the previous code is a non-torn load of
> an aligned pointer, which a plain load already provides.  Nothing is
> serialized against the destroy itself.  Extending the lock over the call
> is not an option either, since mlx5_hv_vhca_agent_destroy() takes
> agents_lock itself and that would self-deadlock.
> 
> The changelog says:
> 
>     While at it, read hv_vhca->agents[MLX5_HV_VHCA_AGENT_CONTROL] under
>     the lock in mlx5_hv_vhca_cleanup() as well, since that slot is
>     written under the lock.
> 
> Is that accurate?  mlx5_hv_vhca_init() still stores to the same slot with
> no lock held:
> 
> 	agent = mlx5_hv_vhca_control_agent_create(hv_vhca);
> 	if (IS_ERR_OR_NULL(agent)) {
> 		mlx5_hv_unregister_invalidate(hv_vhca->dev);
> 		return;
> 	}
> 
> 	hv_vhca->agents[MLX5_HV_VHCA_AGENT_CONTROL] = agent;
> 
> That store is now fully redundant with the locked publish that
> mlx5_hv_vhca_agent_create() already performs:
> 
> 	hv_vhca->agents[type] = agent;
> 	mutex_unlock(&hv_vhca->agents_lock);
> 
> and it contradicts the field's own contract:
> 
> 	struct mutex                agents_lock; /* Protect agents array */
> 
> Can it also race with the locked reader?  mlx5_hv_register_invalidate()
> has already run by that point, and mlx5_hv_vhca_agent_create() queues
> work before returning to init:
> 
> mlx5_hv_vhca_agent_create()
>   mlx5_hv_vhca_agents_update()
>     mlx5_hv_vhca_invalidate()
>       queue_work(hv_vhca->work_queue, &work->invalidate_work);
> 
> while the worker reads the array under the mutex:
> 
> 	mutex_lock(&hv_vhca->agents_lock);
> 	for (i = 0; i < MLX5_HV_VHCA_AGENT_MAX; i++) {
> 		struct mlx5_hv_vhca_agent *agent = hv_vhca->agents[i];
> 
> Since the value stored by init() is identical to the one already
> published under the lock, the practical effect today looks like a benign
> data race that KCSAN would flag rather than a functional failure.  Would
> it be cleaner to drop the unlocked assignment in mlx5_hv_vhca_init()
> instead, so agents[] has exactly one locked writer per slot, drop the
> no-op lock/unlock in mlx5_hv_vhca_cleanup(), and adjust the changelog
> wording accordingly?

This analysis appears to be correct to me.
For this issue I believe you can just drop the assignment
in mlx5_hv_vhca_init().

But I believe there is another issue in your patch, which is
that it extends the mutex critical section in mlx5_hv_vhca_agent_create()
to cover kzalloc_obj, which may sleep.

I think the correct approach here is to:
1. Speculatively create the agent object outside the critical section
2. Try to install the agent inside the critical section
3. Free the agent, if that fails, outside the critical section

IOW, move the type check and assignment to the same critical section,
after allocating agent.

I came up with this (compile tested only!)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
index 4c4cf6da519f..e07c2bdcc12a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
@@ -216,8 +216,6 @@ void mlx5_hv_vhca_init(struct mlx5_hv_vhca *hv_vhca)
 		mlx5_hv_unregister_invalidate(hv_vhca->dev);
 		return;
 	}
-
-	hv_vhca->agents[MLX5_HV_VHCA_AGENT_CONTROL] = agent;
 }
 
 void mlx5_hv_vhca_cleanup(struct mlx5_hv_vhca *hv_vhca)
@@ -265,13 +263,6 @@ mlx5_hv_vhca_agent_create(struct mlx5_hv_vhca *hv_vhca,
 	if (type >= MLX5_HV_VHCA_AGENT_MAX)
 		return ERR_PTR(-EINVAL);
 
-	mutex_lock(&hv_vhca->agents_lock);
-	if (hv_vhca->agents[type]) {
-		mutex_unlock(&hv_vhca->agents_lock);
-		return ERR_PTR(-EINVAL);
-	}
-	mutex_unlock(&hv_vhca->agents_lock);
-
 	agent = kzalloc_obj(*agent);
 	if (!agent)
 		return ERR_PTR(-ENOMEM);
@@ -287,12 +278,19 @@ mlx5_hv_vhca_agent_create(struct mlx5_hv_vhca *hv_vhca,
 		WRITE_ONCE(*ctx_update, agent);
 
 	mutex_lock(&hv_vhca->agents_lock);
+	if (hv_vhca->agents[type])
+		goto err_unlock_and_free;
 	hv_vhca->agents[type] = agent;
 	mutex_unlock(&hv_vhca->agents_lock);
 
 	mlx5_hv_vhca_agents_update(hv_vhca);
 
 	return agent;
+
+err_unlock_and_free:
+	mutex_unlock(&hv_vhca->agents_lock);
+	kfree(agent);
+	return ERR_PTR(-EINVAL);
 }
 
 void mlx5_hv_vhca_agent_destroy(struct mlx5_hv_vhca_agent *agent)

-- 
pw-bot: changes-requested
