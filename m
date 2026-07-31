Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639FC35C6A4;
	Fri, 31 Jul 2026 22:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785538308; cv=none; b=BK8bvrZ90Ir/qxUgYYGNl8ENq8CSqWIn5/3LaZn/kvrerdmlQ3vnGwkCMplxPNkoRfc6riii5egCF9SXMGXytM49vsB5LrUXBaCVTWC/DONgBG9GK9zcf1iYLAJvyjZrBNp3PchObvuxpV8hYwG36ctGOsrUvbPk1pPbgxVGlHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785538308; c=relaxed/simple;
	bh=4lnxS/ZRLgrhqueWnn7x/aSqKk3pEnt2jKZP/4C10rM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ng4/9djYrxYB+j71myNvMU0NqxHda4o52xFIwiigpQ4AM/OfGCt/ipAdZTGzZZ1t+VZ8Ful68HPWaHLSXqVnqweQ6yEtdbHfSfZLONo/J5jhKfvCwH7WGGlbA0xuzpoNLd+MuLDnFwyiilqUSVzFFa8N2r5/WeYXnK09kC67594=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e/E/Aed7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e/E/Aed7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18FA1F00AC4;
	Fri, 31 Jul 2026 22:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785538307;
	bh=FN9o6ge/8QiKsnO0JTsQSdweDjv4TeuUQif+W0oi/Ew=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=e/E/Aed7lN3wBN2soujFSiy3BLXQwncDLhl8lsVEBFCkTFORRsVDFjrJiyog2u5YB
	 KlTMTuiVbXMl2UXRsWmiXi48laCTZvy2iovAo5izUmHHuepK7zFKWElZCEUBTDxRWD
	 Zq+WHmwX0UeqaM42JLnJwuyNnBMDIdKS/euZXO7n+KbQIYfpyevNWjdm9/O9GqrNFL
	 y8+m2S5Oy5uFfnIGf1ZoDPOOdppiSeLO6pEPNJQk0jd67tOR1/KwZNddZp/XWQOc0L
	 Sog3F7i5++zXBSx8r4OPEjbtKBNPCUCaQJ6fUdgssg/7YbvnSzlUC2yCXiV7/KhNsn
	 gdW6slR5e6wjg==
Date: Fri, 31 Jul 2026 15:51:46 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Mark Bloch <mbloch@nvidia.com>
Cc: Jiri Pirko <jiri@resnulli.us>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Saeed Mahameed
 <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Tariq Toukan
 <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-doc@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next V7 4/4] devlink: Apply eswitch mode boot
 defaults
Message-ID: <20260731155146.21c05157@kernel.org>
In-Reply-To: <716eaf68-6168-41fb-b705-e14e84910ea2@nvidia.com>
References: <20260716084852.549909-1-mbloch@nvidia.com>
	<20260716084852.549909-5-mbloch@nvidia.com>
	<20260724161111.2ac47089@kernel.org>
	<c6c0d67c-d832-49a1-b62a-57fa6ee56a47@nvidia.com>
	<20260727131033.237f70b6@kernel.org>
	<amnDfSmMVzpiH2gE@FV6GYCPJ69>
	<20260729160608.3c491568@kernel.org>
	<amsu3mbWht_pc4KJ@FV6GYCPJ69>
	<716eaf68-6168-41fb-b705-e14e84910ea2@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 31 Jul 2026 16:52:25 +0300 Mark Bloch wrote:
> >> Maybe "after_init()" ? "in" sounds like we can release it multiple
> >> times but I think the idea is that it's the final, single "release 
> >> into the wild" unlock.  
> > 
> > ack  
> 
> Just to make sure I understand the proposal.
> 
> AFAIU devl_unlock_after_init() can be used in one of two ways:
> 
> Convert all devlink drivers to use it for the final unlock, including
> drivers which don't support eswitch mode setting.
> 
> That's a lot of churn for the few drivers which need this.
> We'd also need to make sure existing drivers are converted and new
> drivers use the right helper.

We can add a WARN_ON(!registered) to the normal unlock and it will
be impossible to miss the use of the wrong one?

> Convert only drivers which support eswitch mode setting.
> 
> Then applying the default becomes driver opt-in, which AFAIU we were
> trying to avoid. For this feature it also looks very similar to the
> explicit apply API Jiri objected to.

Well, it would be a change to the init flow into which more things
can be hooked. We could also make it a separate "driver ready" call,
I guess, instead of packing it with the unlock. The point is that it's
not a eswitch-mode dedicated callback that's easy to miss in a driver.

> Which one do you have in mind?
> 
> I don't think either option is great. Wouldn't it be simpler to queue
> work from devl_register(), as before? That keeps the logic out of
> devl_unlock() and doesn't require driver opt-in.

Having to edit the drivers is not a concern to me. That said, I do agree
that the API is somewhat awkward. It's a compromise. IDK.
