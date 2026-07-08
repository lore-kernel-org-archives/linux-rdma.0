Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FC52EFD95
	for <linux-rdma@vger.kernel.org>; Wed,  8 Jul 2026 13:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783517654; cv=none; b=a3/MKIsvreAciIsBMi6kAyXnBFO8qu9fwxK8oQtvKHVEjH0gADnAEiG9iuJ0X7qk/Aa5Hs8we7jhnYeyVfRfTIo5XqrQnLRD3LrrDDLvGz6E9oFhDBbuBKEAZBsCA2nGmpKvLLoUxODadF+6g4D8FIU/nycUH9mgM1ghOPZtB9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783517654; c=relaxed/simple;
	bh=HYn92Px+pIWogJrw5t0VAbNntNN2OfCTq+HzrxPaSMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rLg403YN6BQvDiu7glpO9dBgN7dm1o4SN7sSHgmBKwb5Iztg8fQvbb9yVxZaI9VTneXGHZJo+DhbkPRIS5pbfq1MgXu+ZcqYfOlby/kJIVZeupW7Xf8o9qWpu8jzmdgWHGe7apQwZESkPwtxGxeO6rYpY7B3zF/CGIfiN5eHRu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=GLxGCR22; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Iolnkz17; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="GLxGCR22";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Iolnkz17"
Date: Wed, 8 Jul 2026 15:34:10 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1783517651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jloPryHVAnyMnfUJpDwwMCTTTnvxOJ06tEhjo7rIXgU=;
	b=GLxGCR2251SUjaGJUP2ZSUEghGozut6+3zyiIFplVZWHM64iv8UsPN6P89x+G/l2OL0gO6
	V3fNgWoWD8z3ZXiGbLbsw8sDwgfSclxqq+EtY6ii4y+MeEOwPVkmhnc/JT92zlj+TBXLmI
	NoRCEy0NGKSgi77hHLeUtUg8v7Rm5JrF66UeT0toYs/9hQBYe444hhNiLMCKquiI7Y1qHT
	IplVfAIlPtfLfjlIrhZE0ZxT/sGHMNLVacom6aQUs42u2Th26qKGg9D5xo/V+/snRD7RPF
	kCs9Y7HEEyp96xU4CiGSUQjUTaSd74rBXZEXl0mN+Wj3qdvjpfW5TIgM/ycZ6w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1783517651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jloPryHVAnyMnfUJpDwwMCTTTnvxOJ06tEhjo7rIXgU=;
	b=Iolnkz17ZckY2QC/kU7PFcjib0qbxXbhB3tKLN7TKMvGYLUB26/6jDHi1ddz55WfZ3PxpM
	9y6kiwEWapDogIBQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [Q] RCU usage in infiniband
Message-ID: <20260708133410.VZR0-V_p@linutronix.de>
References: <20260708092316.Qb39F_B0@linutronix.de>
 <20260708131727.GB674038@nvidia.com>
 <20260708132105.5c0kDr8S@linutronix.de>
 <20260708132849.GC674038@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260708132849.GC674038@nvidia.com>

On 2026-07-08 10:28:49 [-0300], Jason Gunthorpe wrote:
> > Where? Within the module core or somewhere within infiniband?
> 
> Eg the uverbs path has a srcu synchronize IIRC before allowing the FDs
> to close which holds the module as well. But it probably isn't wise to
> rely on this

But this is srcu. So this takes long enough so that we have a RCU grace
period, too? But there is also RCU_LAZY which could stretch this a bit
;)

> Jason

Sebastian
