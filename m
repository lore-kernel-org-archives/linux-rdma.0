Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0563B71B1;
	Wed, 26 Aug 2026 08:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787731655; cv=none; b=fDwPGlwD1rP8eve5j6WqIp5kYXeRxkkgFrzabVImPFhNYOryvCs1K3K4hOw8NyLnawDxz40B6vPhwIvt/5Sj1Wu9ZR/oJ+NrYDmR6AJL7BvW2TjaGgh5fRFH8t7dCepLYhmBn10tUeedNVFkZG+6OUNt+XCuIsDo7FO9DB3eUu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787731655; c=relaxed/simple;
	bh=Na+hM2wqIe+x1iSSlrnmbc8gCl4Y+1kYtURrp1WaE2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K2X00mJurbrxjFwJ/ny9Bp4epCbl2OhP42xFwZsNgRoaiF6e7BfpStERd4M31M+kwazG+sX6kBpXeMH+RMAbJ6H50heg6unPO6ojK13RqmXmOPonztzYlt0T1de3379ekXGiSCHXFkF8IWjZq7ahGluwBB1HKw3XBXxue2GFqRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ljEK6VPY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ljEK6VPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525431F000E9;
	Wed, 26 Aug 2026 08:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787731654;
	bh=OL2qKXD2a3hLZiL4PnD+sXth26pEZ4d9s0c+PwQlMgc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ljEK6VPYJByOvio68wXbsZc44mKqYXjolYENTrngPMYOFdPZ0QsMQJlBJ57U6eHo8
	 xeKCdT5n9HFk41JIZA94pbBOcjvuQ+9eHli/a7I+xl/5fmVh/cVG2EkgtDe7nfi3bf
	 5++L/oDsaesv1+TjPwfeQCuaJlgg3bTyjjT94087Ig4nA1DoGmG/oERDq7XZmd5AQy
	 X6opwexPxItbSOXjd5MWYUkvvvfzwvvDO3G/qmRtnHB22cr+mSIHvlWQ2aYK4M4NvC
	 OSG3qIR2Zz9tP9Kxz/5f9JGauMsHOKTyLq0LiXWLrOoiLTSP8YRg1LQ6LOOzPavhIl
	 mJ7XxR8IOG56A==
Date: Wed, 26 Aug 2026 11:07:29 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Eric Joyner <eric.joyner@amd.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	Brett Creeley <brett.creeley@amd.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Allen Hubbe <allen.hubbe@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	"Nikhil P . Rao" <nikhil.rao@amd.com>
Subject: Re: [PATCH net-next 4/4] RDMA/ionic: Add DCQCN parameter
 configuration via debugfs
Message-ID: <20260826080729.GA42790@unreal>
References: <20260506041935.1061-1-eric.joyner@amd.com>
 <20260506041935.1061-5-eric.joyner@amd.com>
 <bb6f164e-5f95-48ab-a22c-5582dcef721d@amd.com>
 <c940bf1d-11d0-4564-ab1e-e423b0c8ceae@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c940bf1d-11d0-4564-ab1e-e423b0c8ceae@amd.com>

On Thu, Aug 20, 2026 at 05:24:30PM -0700, Eric Joyner wrote:
> On 7/28/2026 4:16 PM, Eric Joyner wrote:
> > 
> > Leon,
> > 
> > From this thread for Patch 3:
> > https://lore.kernel.org/linux-rdma/20260514163540.GT15586@unreal/, I understand
> > that it's too large and it's exposing too much information; I can shrink that
> > down and remove the entries there.
> > 
> > But before I make changes and resubmit, is what this patch is doing okay? It
> > adds DCQCN configuration parameters so that they can be written to in debugfs
> > and propagated to the firmware? Would this be considered too much meddling with
> > the firmware in debugfs, too? We want to have a driver-configured mode for DCQCN
> > and possibly other congestion control profiles.
> > 
> > - Eric
> 
> Hi Leon,
> 
> Can you tell me what an acceptable approach would be in terms of the DCQCN
> configuration? It didn't get mentioned as part of the debugfs discussion on the
> other patch in this series, and I want to know if it's ok if I can modify the
> debugfs implementation to have these DCQCN tuning knobs in there, but to drop
> everything else from the rdma driver debugfs that looks offensive.

Yes, see the HNS driver. It added several debugfs knobs for configuring
DCQCN.

Thanks

> 
> - Eric
