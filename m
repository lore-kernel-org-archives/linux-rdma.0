Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794920009;
	b=4+KWeoK2CAtmV56aaHYGi4Tt+2e+/EY1NUnA7ryuhUcEjM/mUYudm1b7j9bdaih3TaMH
	 ysTbm//s8Z7jM5+y2Mg3IQLy8v0SpV6YctwaL5kO4wWuXGBLqrbBIe+FykI3M8Y6gLSOt
	 kpXgzae82eJXxPzEaULzSmyQguYX6TIVNNrmf2FzjeNJxhXl/CZLHLhEIKBDeOFNjKjRE
	 nWmxjJyEVYKBYhEKnw9KhKErFlRRbemuxCyWxVN2eCcxQ/jjKORzSEILcJpbmRoDKb6Ek
	 TPJ4xozG7TOwVqWKCe9hQy6hTF73e9z9feXSr6yTbshWYMv2pQiX4SoO5iaUPZXH8FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794920009;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=t3dRoJQydQmoIfLEL2raJ08udX4rjgQu0oxWPVzl5eU=;
	b=JXsol7+VMkXYQF/ziB3rxLevxTxouv0OV/PzaWfJ4rF3pIgB+LEHzgXwAhZiysjJ+MFh
	 CrD9c/lQ6V3CmTjUShpPiMe/6xyNw6Q9/AGr1jgGhue8K9nZ4nyUmGdO1BNWyFpKJT309
	 EDZrNtY6GKAccOU6+emG0xGK/8gJYQPnuNEylBi6+sqcmVpf7XdkGrabmBhVu7ms4mo+s
	 IEKwGxtRHimJGiZbypi5wFAfc15u5P2nFV+rwsT55bpQtZgZWOhspVnBtk8D9OsC/pJyN
	 dNIQlEmTatIteZEDu+/C6S+GhkgatXtLm+Ny7xYWOhl1tZlJp9EUIqIAtE3J90fW2Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O6LpKvy7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAD0606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 12:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O6LpKvy7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02FC1F000C4;
	Tue, 17 Nov 2026 12:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920009;
	bh=t3dRoJQydQmoIfLEL2raJ08udX4rjgQu0oxWPVzl5eU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O6LpKvy7LvQ+91exAqfFdRkoMFs9fsrkpIsG/P0mhevSJv80Gp7DwmgYt50nYVqNI
	 21dGxVpdssqD+OMTQ1RbuDYZlDSLrYxf6cKSZSjRYA37I6ndeCUdx0Afk6P6hMeAxq
	 gnEOhjGcK7Gwt/hNZIVwZjK6Pjw/ExglCvKMeU7PEO+rG/ZFkolWouY/7OLN6NVTFz
	 pKI47qGCTvL9XlzbCECWTAI22lTVVeojnaJXFRHLsLmx10vImKOnXqGB+NKnTprEg8
	 JiGid99fJL1Nh8Kg/kJlWbcNWL6dfBjAXWNmKJ1TrNTDhrc5v96AU7VfyPWgQzvSyz
	 3cTRtAngZav5g==
Date: Tue, 17 Nov 2026 14:53:25 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Michael Margolin <mrgolin@amazon.com>
Cc: Ilia Kolominsky <ikolomin@amazon.com>, jgg@nvidia.com,
	linux-rdma@vger.kernel.org, sleybo@amazon.com, matua@amazon.com,
	gal.pressman@linux.dev
Subject: Re: [PATCH for-next 0/3] RDMA/efa: Add Completion Actions support
Message-ID: <20261117125325.GE124972@unreal>
References: <20261109081349.27316-1-ikolomin@amazon.com>
 <20261116112913.GI11319@unreal>
 <20261117081850.GA18565@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117081850.GA18565@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>

On Tue, Nov 17, 2026 at 08:18:50AM +0000, Michael Margolin wrote:
> On Mon, Nov 16, 2026 at 01:29:13PM +0200, Leon Romanovsky wrote:
> > On Mon, Nov 09, 2026 at 08:13:46AM +0000, Ilia Kolominsky wrote:
> > > EFA Completion actions let an application observe work request
> > > completions without polling a completion queue: when a work request
> > > completes, locally or at the remote side, the device performs an action
> > > that the work request names, such as writing a value to a user buffer.
> > 
> > Why are these verbs EFA-specific? This looks like extension of already
> > generic UVERBS_METHOD_COMP_CNTR_* code and probably should be general too.
> 
> It is indeed an extension of Completion Counters, and later we plan to
> connect the two by allowing a Completion Counter to be used as a
> Completion Action, but unlike counters, actions mostly matter for
> unordered transports where a completion count alone doesn't tell the
> application which requests have completed, so it needs an efficient way
> to track completion of specific requests.
> 
> Do you think these semantics can be useful for other providers at this
> stage, or can we start with an EFA-specific interface and add a common
> ABI later if required?

I think the idea and implementation is general enough to be picked by
anyone who will decide to implement it later. Let's do it in common ABI,
please.

Thanks

> 
> Michael
> 
