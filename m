Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCE0380FF4
	for <linux-rdma@vger.kernel.org>; Wed,  8 Jul 2026 13:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783519131; cv=none; b=hDlrM9OhH/+CydfRz1j7p+gx9k76I5jWAKkBEt4t7HYKD5wtHDrBJvMC9mvGE4fLOCWzt7ZKp/lF4v4cMUStVKO1x9KXhqvyb5coMo1hrrKESPTK2sAVYQOC36TuTJT/HQqTOZ0jaECKxCCfYjhU6wvzNGDYT7/rWbtekKfbcmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783519131; c=relaxed/simple;
	bh=daVzIBbukoWLoBCsRNnHFcyvFTsgKx7Z+34RsPaTKUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WfF+xbuQYzUROzKL0gi7PD05lHmdCy9xdgqZJl+jj3T81kOzmdHXmYx/uzqzMqDPtmoh4QXjPZNOuNVVFkq6zbGAP/PWXr43Hckqda/Juajl9MZhc7creh1x3veeUUn8T276Ag6xybCVu60k5V/PaBgA+Yv9vmPNeeMR6vNy3UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QD3FWQWd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QD3FWQWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8681F000E9;
	Wed,  8 Jul 2026 13:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783519129;
	bh=DCc7WuoFYjY2qxNpWvM9hG0Ya1pVxG11XBXwq0PONNI=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=QD3FWQWdE1kec9MBslfG9SaoDSltC1cyT2ed3CQ1zQHbEXF2jFv6xlrX3yaSvlU04
	 eXB5xfOupcY9PV1SuJBN0FX8tRJHze7zV54lZYtfB+QPVY875b7tWrIA+W7YD23Uif
	 HCa6zSakfs/xZkbp7DRmyXL7zTZ92L0qMnky9OXz0A78lhmkT5jWtRTO5Io7ZRYBHs
	 4YtCO8ozzu1it51FGW/+c5zwpplrEtwgYBTVY234IKSwF1R/2VnyNaKnLBbF9J8n9n
	 jtU08feRHY0cX+TPP25e75nzr+fRgHC7o1P+lnPqnC8DaD3DZMiIh9/upehv8DKXkR
	 I9qDYz83hVtYQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 4BB79CE04B1; Wed,  8 Jul 2026 06:58:49 -0700 (PDT)
Date: Wed, 8 Jul 2026 06:58:49 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
	Leon Romanovsky <leonro@nvidia.com>,
	Petr Pavlu <petr.pavlu@suse.com>
Subject: Re: [Q] RCU usage in infiniband
Message-ID: <95768d78-3316-4971-9fbf-141136a0a9bb@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260708092316.Qb39F_B0@linutronix.de>
 <20260708131727.GB674038@nvidia.com>
 <20260708132105.5c0kDr8S@linutronix.de>
 <20260708132849.GC674038@nvidia.com>
 <20260708133410.VZR0-V_p@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708133410.VZR0-V_p@linutronix.de>

On Wed, Jul 08, 2026 at 03:34:10PM +0200, Sebastian Andrzej Siewior wrote:
> On 2026-07-08 10:28:49 [-0300], Jason Gunthorpe wrote:
> > > Where? Within the module core or somewhere within infiniband?
> > 
> > Eg the uverbs path has a srcu synchronize IIRC before allowing the FDs
> > to close which holds the module as well. But it probably isn't wise to
> > rely on this
> 
> But this is srcu. So this takes long enough so that we have a RCU grace
> period, too? But there is also RCU_LAZY which could stretch this a bit
> ;)

Just to emphasize Sebastian's point here...

If a module uses call_rcu(), there needs to either be an rcu_barrier()
or some explicit synchronization with the callbacks themselves before
module-unload time.  Any explicit synchronization must also include
a wait for existing softirq handlers to complete, so rcu_barrier()
is simpler and more maintainable.

Please note the rcu_barrier().  And that synchronize_rcu() is not a
legitimate substitute for that rcu_barrier().

Similarly, if that module uses call_srcu(), there needs to either be an
srcu_barrier() or explicit synchronization with the callbacks as mentioned
above.  Please note that neither rcu_barrier(), synchronize_rcu(),
nor synchronize_srcu() are legitimate substitutes for that srcu_barrier().

The difference is that while rcu_barrier() waits for the completion of the
callbacks queued by prior invocations of call_rcu(), synchronize_rcu()
instead waits only for prior RCU readers to complete.  So rcu_barrier()
does not care about RCU readers and synchronize_rcu() does not care
about RCU callbacks.  And the same holds for SRCU.

Also, RCU does not wait for SRCU and vice versa.

Does that help?

							Thanx, Paul
