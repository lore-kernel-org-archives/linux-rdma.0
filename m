Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17663946C
	for <linux-rdma@vger.kernel.org>; Sun, 15 Feb 2026 17:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771178231; cv=none; b=nSZG/8RU2awN0GWtGsgQiMXCAGOBmnXAm+uGjLJmlPrjUnnW7PTIRvBHkbEH8cVoTiN3sgGj7e5v9GeNHVx3p5KQiTeeuMibCZBI0B+Vu2CY9kXv004PB4tK9NJy9M61KMBlqBcjd4rX84x8ngKQIhWZ9fxO1InMC2xtRI9cPL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771178231; c=relaxed/simple;
	bh=ik1VEflRf9UGkJ6KU54m7ymaA6mHOSpnqsZBE9gtLKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qqJyS8B1QREn7y97ix2OyxZg3gPQafOX8/WikgCYx6NIGWE/AO+7SkbQMB4coC5sbx34a6dJaff9m9YFPsSMMMhCbdfkm1O+Xp2dR4k4N8w4TG60o8qyvS5sBUQSlShiWmU6oDY2llfn20k4GvZzGwU+Kr94vDe3XR23EqGf8Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=McFkhlzL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="McFkhlzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D6CC4CEF7;
	Sun, 15 Feb 2026 17:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771178230;
	bh=ik1VEflRf9UGkJ6KU54m7ymaA6mHOSpnqsZBE9gtLKo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=McFkhlzLMtmhgGMEw9YVmk15nytiX6Ga6bljhRrPTmkWSyI6IK9xdDBaifOmv8ELS
	 co3yTna21Vz7y9J/WW8TUZHhQ25QpdT8no/xYHlLTIELOcIiPmVAExs0Cstfcm3hgd
	 5lMb55EGNlPPJzMm2cNuSd69hbPmQOHVKdgAHwFtxLXuQObIhZKby6MwR+ghQtoxb5
	 wOfAfjS/24FhDWsXRTlO3a6SEGvZtcLy6mHvA3FhO+S0PMWGlLdN7KOXGrU2lt9M/h
	 o/Zv1SxW7acsAsq5MVNZoSul6GEjF6idsIKL2/WdDynP/j3967XkyTsrqc2X0BDVJi
	 mROOsrzo8potw==
Date: Sun, 15 Feb 2026 19:57:07 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Gal Pressman <gal.pressman@linux.dev>
Cc: Michael Margolin <mrgolin@amazon.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Tom Sela <tomsela@amazon.com>, linux-rdma@vger.kernel.org,
	sleybo@amazon.com, matua@amazon.com,
	Yonatan Nachum <ynachum@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Add AH usage counter with sysfs
 exposure
Message-ID: <20260215175707.GC12989@unreal>
References: <20260211131048.36217-1-tomsela@amazon.com>
 <20260211131338.GA1218606@nvidia.com>
 <ef07b718-0198-4f8c-86c1-56149c7fd239@linux.dev>
 <20260212163628.GG12887@unreal>
 <20260215134122.GA18825@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20260215171543.GB12989@unreal>
 <42c8552c-eb41-43f5-bea5-fdd46edba65a@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42c8552c-eb41-43f5-bea5-fdd46edba65a@linux.dev>

On Sun, Feb 15, 2026 at 07:23:41PM +0200, Gal Pressman wrote:
> On 15/02/2026 19:15, Leon Romanovsky wrote:
> >> Stats also doesn't seem as the right place
> >> for this.
> 
> Because?
> 
> > 
> > How can the kernel and this new counter report a different number of AH
> > objects?
> > 
> >>
> >> In a followup series we will suggest netlink counters extension to
> >> support driver specific resources.
> > 
> > bpftrace is generally the right tool, unless you can detail why it does not  
> > fit your specific debugging scenario.
> 
> I don't understand, how do you use bpftrace for this use case?
> 
> Once you get to debug a system in a certain state, bpftrace won't help
> you see events that happened in the past. You won't be able to know how
> many AH were created.

Their proposed counter can be implemented by counting calls to
efa_com_create_ah minus calls to efa_com_destroy_ah.

You have two ways to get it:
1. run bfptrace with your reproducer
2. check FW to get their internal counter

Thanks

> 
