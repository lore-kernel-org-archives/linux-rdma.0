Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95423FC5CB;
	Thu,  9 Jul 2026 11:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783598388; cv=none; b=oFCmSHElAdKwj7bHkC4GbC9Jx7VRpmxP+LtqVabhjTi/uCaLVUnF0W/9Lpo2Y6wavR83fudlBwvVX8H7LVjhZ6v25thu/SHc60isfkSdxpFC1E4OKQt2SFNOx6QkRTm5ve+9WI0V0yyrS3OTeUCCNwPILXPgEMz2rqymGneKkTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783598388; c=relaxed/simple;
	bh=mj4NPPoHKfU1LBXMCpaIFYKjB2NwXp12V19VBbPe+gY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bw+VFxVE8/kTLDMlcjCjEVkH7i7/ys4iqMRADJLzp8X0c8fssVyFS1fW0Jzhr1HiOlRn7TjYVZZ8W0s1NRwGMpLCWW8jH4UxIikfMKv86nIZD3wzPohIdScmqy9kggbt0MeaqQZGl6c4FaMINu8LYX469SUmmzg6uo9XJdM19Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=SmiMSTPW; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=+DpXqTHf; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="SmiMSTPW";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="+DpXqTHf"
Date: Thu, 9 Jul 2026 13:59:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1783598383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mj4NPPoHKfU1LBXMCpaIFYKjB2NwXp12V19VBbPe+gY=;
	b=SmiMSTPWehcxepMB7JK8+HbvhIDJ1ziOehkGc+X6RZJUlah0wZoZk7LTmGPOuHslwx4rT8
	U2m2lVNK0acbQc3Kt1B9lZbK/Xjp1fNKv2V/n/I9D1yxS4X/b8mZOCwRiWjxAgYx6Yg0um
	Tob7dV8wu9NzvLOLZbYY2modKg9Uoq6n026ii4hgwgzSm+vnytDbyihE+ymTRLnga34TN7
	QbmaaltY4meE9gO12ry3Cha6V//T6OcskUoXPjlJ9pRKGYg9hAorYu+lu9PEUutdS6w5pE
	MAxWTSYkklKsNrcwDKtbi/FOXewKSdDV9rm+757ZLWcrXZiaW0Acm0PbZewVpw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1783598383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mj4NPPoHKfU1LBXMCpaIFYKjB2NwXp12V19VBbPe+gY=;
	b=+DpXqTHfV2kIAHOrs2gRggZNnsrxrVlq6/PO3gj+UchHyc+bJf6ey3nKCHL0CaHTDLzS/r
	DhTjvJjBqIx+n/Ag==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, Petr Pavlu <petr.pavlu@suse.com>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH rdma-rc 0/3] RDMA: Prevent RCU callbacks from outliving
 modules
Message-ID: <20260709115942.al1Av6bJ@linutronix.de>
References: <20260709-unload-rcu-v1-0-fccd27211e5a@nvidia.com>
 <20260709095921.5g994Mie@linutronix.de>
 <20260709110559.GQ15188@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260709110559.GQ15188@unreal>

On 2026-07-09 14:05:59 [+0300], Leon Romanovsky wrote:
> hfi1 has an rcu_barrier() call in hfi1_free_devdata():
> https://elixir.bootlin.com/linux/v7.1.2/source/drivers/infiniband/hw/hfi1/init.c#L1176

Indeed. Sorry for the noise.

> Thanks

Sebastian
