Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A90B3101BC
	for <linux-rdma@vger.kernel.org>; Wed,  8 Jul 2026 13:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783516869; cv=none; b=FTceMtr0AjS6KC8jgpt/eEnO+AYB423p9r1HRCpLIGh1cWVEpDgZ5FAfy7r5r4WqU/DvVOeqFMQlfwI+xQd0veHsyf0xKynl5XN0I8HByVfahQfv3CQ3etNyu2/GQVEktOZPGtLe65M6XlC73ukW2JaOjYToO9PkwJObRHejXgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783516869; c=relaxed/simple;
	bh=kQ3Ff64wTTv0Oaz/zP+Flds9BRxcZ4dVXB+cZWF4Q7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lDVYS/rHTMcO1m9why36GDaGx/AhrzYZEiomlMhFrGFf3zQ/E9mC3P9/+hZTQT/8NzshEyqQnOf3OtaU5U+4o/F8pHS3IXJ8dYjUyhKZth/HJ94/NiOwWN4koaRoXGdt5BQbzGz+AdUvrHY6S4duXyHbkwSe4FKruflSuajoPz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=UTbjmiSD; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=7mT9xM5G; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="UTbjmiSD";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="7mT9xM5G"
Date: Wed, 8 Jul 2026 15:21:05 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1783516866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GMKx3JLi5tOjocRQCFFKP0gP/SbBr3DhsdXQkd4uNiU=;
	b=UTbjmiSD4eYfuyvzattQeOg947zXwp6iyyNgoUwoo8nmoYaG35Zj1PVdn5LdJX9Uc1hCE/
	qGvjjQ48XjtpAwu1S9fX4sBvuA7QyanIkABr0Xg6SYuGCWoXZDpwepokprt9eA41gkDliY
	BqSxy5Kw57ZcGvpzYIZtrQT2G+V5O2E3TtVraZS9Ktktudh78X4w9WaVX0LFtwUtl4YrGN
	xReDIHrbWsTXh7Oze6HUNqBBoBb/PqwF3SSu2BS+oJYa/2PcVHFvM7KdgHYlklTTrZJkB/
	PWFM25yxT/6wN1yqCDHXwmXBV2XtXA1N6yGuQun9M6C0aqjfwlyXkd2dtl1+Kg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1783516866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GMKx3JLi5tOjocRQCFFKP0gP/SbBr3DhsdXQkd4uNiU=;
	b=7mT9xM5GrTGrYj+bchCi5xcV52vpIdpuDrPvf84ObYXsnIvOyeDgxWj/S0COhAwbaDALbj
	bZmylkJLqUhSchAw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [Q] RCU usage in infiniband
Message-ID: <20260708132105.5c0kDr8S@linutronix.de>
References: <20260708092316.Qb39F_B0@linutronix.de>
 <20260708131727.GB674038@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260708131727.GB674038@nvidia.com>

On 2026-07-08 10:17:27 [-0300], Jason Gunthorpe wrote:
> On Wed, Jul 08, 2026 at 11:23:16AM +0200, Sebastian Andrzej Siewior wrote:
> > Hi,
> > 
> > I've been randomly starting at infiniband code and noticed it uses
> > call_rcu() with a callback from its module. 
> > 
> > | drivers/infiniband/hw/mlx5/devx.c:         call_rcu(&event_sub->rcu, devx_free_subscription);
> > | drivers/infiniband/ulp/ipoib/ipoib_main.c: call_rcu(&neigh->rcu, ipoib_neigh_reclaim);
> > 
> > I don't see synchronize_rcu() and rcu_barrier() there so I've been
> > asking myself what ensures that the callback completes before module is
> > gone (via rmmod)? I would expect a rcu_barrier() in
> > ipoib_cleanup_module() for instance.
> > 
> > Is the unload path so "late" that the callbacks run before the module is
> > unmapped or is there something between the APIs that ensures this?
> 
> It wouldn't hurt to have a more explicit unload synchronize call, but
> there are already some existing ones on the path to unload a module
> that would cover anyhow

Where? Within the module core or somewhere within infiniband?

> Jason

Sebastian
