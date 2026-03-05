Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD71223702;
	Thu,  5 Mar 2026 14:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721452; cv=none; b=ePMypGe3UpqdAM+7nap1KBxYQq6nKBYfp92nA/cHMkugJyThwywL/PXQ//cyEPer9o9sbmh75x+G9fmHjXNKZSp+vDxlfCax5vYtvYrgh3Jhtn8jM7xgQs2ff8jN9VuJlMEspJ4GfQ849+07e12F4sGHmIEM22ixMAMC/gFhXlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721452; c=relaxed/simple;
	bh=hydBV9IBNGLgutex0pxGm+Z79BQWju5lSIVQ6eQRkwE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uihdmy08RQQmRVa9nwGEKaPrkBIChTyLf6DVfUaLvwr9UUFjIh+ZrWB0/WGl2ZkSifULJxVh5EuVDBOZxuBfpD5Vu2pMB7bbOB/J5PD9RCCaPiF6EO7nS/FuQ5FsWf5v8gtPQsY4WGbjhqanEbRpDibrlPun5wHuGFV97S1TLpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KrN7lwbL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KrN7lwbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B77C116C6;
	Thu,  5 Mar 2026 14:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721451;
	bh=hydBV9IBNGLgutex0pxGm+Z79BQWju5lSIVQ6eQRkwE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KrN7lwbLfNoQJYzuLMdjDvbZCrS7+wvGBPeA8mSxwxcUWfbiE0ZFxkmJ0TcZiFx5U
	 NXGS5NKsjAQ+2Y+68yEaKFbUIz/S7ZyPIL2yoDhR6TEYK8JYon1J6g4pouBsbyACEa
	 SpCwTbqeE3JPJbSbYKlt9Jmk2g484JJ60TB2i9Wc7d+EkKw3xGyHOtLFWoqYGZGdW6
	 vAuw5HgG7G5Gk4FGDGeMsca4kRHPO+u8HFvLCYDw9zql57cgKEB4oily6bfc8SEgLC
	 N9+q/TmYoQnXZ7DFJYcGPqO3NzeZh6l9asdYodxLz371jzw64QHk9fFTx1n6uQi9qc
	 FqRfFORCV3GSg==
Date: Thu, 5 Mar 2026 06:37:29 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Tariq Toukan <tariqt@nvidia.com>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Donald Hunter
 <donald.hunter@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Saeed Mahameed
 <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Mark Bloch
 <mbloch@nvidia.com>, Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org, Gal Pressman
 <gal@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, Shay Drory
 <shayd@nvidia.com>, Jiri Pirko <jiri@nvidia.com>, Moshe Shemesh
 <moshe@nvidia.com>
Subject: Re: [PATCH net-next V3 00/10] devlink: add per-port resource
 support
Message-ID: <20260305063729.7e40775d@kernel.org>
In-Reply-To: <np44uzfn6jea56uht4yq4te5clapgj7pk6ygyvkl22wxumwnvt@nrpvzjqzxenq>
References: <20260226221916.1800227-1-tariqt@nvidia.com>
	<20260302192640.49af074f@kernel.org>
	<pmxkihhtsskkwsvdia4z2ss4wxpfc4a4kqxkjv5wk3mwdmpzii@6go7pizk2nst>
	<jssifysprwuafkinc3dguspngxmplrngqxvotp76vhvu4e5lp6@e7mdrjqc5rme>
	<20260304101522.09da1f58@kernel.org>
	<np44uzfn6jea56uht4yq4te5clapgj7pk6ygyvkl22wxumwnvt@nrpvzjqzxenq>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 5 Mar 2026 08:56:42 +0100 Jiri Pirko wrote:
> Wed, Mar 04, 2026 at 07:15:22PM +0100, kuba@kernel.org wrote:
> >On Wed, 4 Mar 2026 11:34:13 +0100 Jiri Pirko wrote:  
> >> On a second thought, if we merge multiple objects into one dump, how
> >> does this extend? I mean, the userspace has to check there are no extra
> >> attributes, as they may be used as a handle to another new object
> >> introduced in the future... Idk, it's a bit odd.  
> >
> >That's true, the user space must be able to interpret the object
> >identifier. So if we extend the command to add more identifiers
> >we will have to add the bitmask to the dump request, and have
> >the user space tell the kernel which objects it can recognize.
> >I was just saying that we don't have to add such attribute now,
> >maybe leave a comment in a strategic place for our future selves?  
> 
> Or, alternatively, we can have per-object dumps as we have for all
> objects and command right now and leave things simple and
> straightforward? I mean, I don't really see a benefit of a single dump
> for more objects :/

What do you mean by straightforward, exactly?

User will most likely want to see all resources of a device in a single
dump / command.

The objects themselves are identical, they only differ by the handle,
and yet we'd have two separate commands to access them.

It's as if we had separate GETLINK commands in rtnetlink for devices on
the PCIe bus vs connected via USB.
