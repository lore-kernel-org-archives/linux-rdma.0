Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DE340DFC8;
	Thu,  9 Jul 2026 11:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783595167; cv=none; b=frpGqB4hKwKyvpZ2pA0NmYCu2C0w4iJUW/bdSGKV1iLaVFWb6I9n5aMew+yTrQgM7yHDOu/GashZy6B+rGf9z6qXvjTbFoYMzQS6lWZNzbSSac04K8xzI5qeZEKwHipZhEVafmMhKHHbZQ0/Wl2rS/+mGnL6tR+ZSsuaStfH6bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783595167; c=relaxed/simple;
	bh=08vwsrdQCaRcEHIEfr06IigCJL+ztAlXLsk0cOd/CRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qko2ybTpStTx9WaiYUUbbqoZF1COfrs8ALFwOUKSqamuSAfDl00ZaBX5RhghL3jD3qerVkklKhozCIrF/Pld7aiFzoMHzpF4Fp1TlI3n5nBMRx/g1IJWZebRXARMzptJfnNFYNtF1PEl04a0lON0bs1NsJjfJV6+p6mp8tNRz0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UM7kRDpw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UM7kRDpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017061F00A3A;
	Thu,  9 Jul 2026 11:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783595166;
	bh=Ky+6uCxSv9Zr/aV9OtkO5yFvJGmNqI+CYoheCFDMxWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UM7kRDpwhMwYpTUPS2AaikWBN0B77ZLdqhGCK/HkIY/n9ObHr/3JF7BTxftSeOqob
	 ml5YQl+1H8yRE+pZF3MuwISMogFTwH8S72IV1hXIUoG3sCwT4AhZOmSsq4dE8sutuJ
	 loUMMyfOfyTckC3JVO4HaM/2/kHaG+WsG0zhpmCYRYd5uz/UYJhflIYXS+YifPmQsG
	 8aVF9vNCuVnyIQUaiEQXIaOeaZQAP0At7DY0nF1FyZl9KKWzy2AM7dwi527VewROEC
	 UmaatNF4fO0YUzHvkN7mD/N5YwDlV6EVKBdrSypKM1jwEAgH50LNQBwRuRYSnc/qFg
	 vp5QRW2GmBtGg==
Date: Thu, 9 Jul 2026 14:05:59 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, Petr Pavlu <petr.pavlu@suse.com>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH rdma-rc 0/3] RDMA: Prevent RCU callbacks from outliving
 modules
Message-ID: <20260709110559.GQ15188@unreal>
References: <20260709-unload-rcu-v1-0-fccd27211e5a@nvidia.com>
 <20260709095921.5g994Mie@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709095921.5g994Mie@linutronix.de>

On Thu, Jul 09, 2026 at 11:59:21AM +0200, Sebastian Andrzej Siewior wrote:
> On 2026-07-09 12:06:46 [+0300], Leon Romanovsky wrote:
> > ib_core, mlx5_ib, and ib_ipoib use call_rcu() with callbacks implemented by
> > their modules. Stopping callback producers does not drain callbacks already
> > queued. If module unload completes first, RCU can later invoke code that has
> > been unloaded. synchronize_rcu() and SRCU waits do not wait for queued
> > callbacks.
> > 
> > IPoIB reclamation completions are signaled from inside the callbacks, so
> > they can wake teardown before a callback returns. Initialization unwind
> > also needs protection because registration can attach existing devices and
> > undo their setup on failure.
> > 
> > Wait for queued callbacks after all producers have stopped.
> > 
> > Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > Closes: https://lore.kernel.org/linux-rdma/20260708092316.Qb39F_B0@linutronix.de/
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> Thank you. This makes sense. drivers/infiniband/hw/hfi1 might need the
> same.

hfi1 has an rcu_barrier() call in hfi1_free_devdata():
https://elixir.bootlin.com/linux/v7.1.2/source/drivers/infiniband/hw/hfi1/init.c#L1176

Thanks
