Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B773E317F;
	Thu, 15 Oct 2026 15:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792078768; cv=none; b=Q6KqSnxOgRMXYVWFFqEYaLkR3kJjTcbY+0cqba2XeJ2gTpOA+mwj3d1IVHUFXB0O5tlYmiJLTHPI3UQw7DPrfAPJcY8TNM8xd88JnF7Pe3ODX9NL5n9X8rj8hls/ijD3Zh//9zVy9ofOZZ3HOG/n1aeNTEWNxB2X6bhQymJoi3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792078768; c=relaxed/simple;
	bh=+dHgy3N/7gLS1Qh9qig6x46n+yZUjDiqsiVq+rHySdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fpsEuQXuZWrRAerj4bclDKogZQKLm7158BGkgmZiBRFoW0r8X9Z2q7VImWHXjznitcvHcVIdBxkHl+PL97RciPFe8uRvxjtBnfRvLAYIEZMHhABWcpRxZSz1OJU1bT6gFOCs4WyFl3eNLh3ml3sgYtZanwNVH/xXZ1t3Oq2Pg+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jN7ROiVe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jN7ROiVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC171F000C4;
	Thu, 15 Oct 2026 15:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792078757;
	bh=clDnXgxlukUJgyNafFQbgSdwRfqCNaCIb5WhZlQOEAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jN7ROiVeST/l6I5kKRVzvkIdwzfTWzii7v7nxX40LXf/KzJWS2QfO4aYf/3oSlSqz
	 UakhmzpNopiedNKGrII9giQlTHjQXtIPpg4WV6C6Hr8E7WmNRy35QXaCfv0I/2jPcm
	 oUYfSc8waj3mLvs7E3TKmNwN6hWW8Gn2qbfh3+jXOxRw2Rm7nUvfU0032NRtg6mWlV
	 OAQDEr0ctPRZHzLfHLvQmOm0f3lArZvjyHlB63LmnAlHDmgDqoE26v44QHgdKhWe4T
	 t+PxfDFHNMHoP7aIDVE5alttoEuCiO6PyOFP6wKKeTYibFiQbZGqy+VLzBQJ3CeGoD
	 Tl38NVCuzkQPA==
Date: Thu, 15 Oct 2026 18:39:13 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Dongliang Qin <cccccccccccc777777@gmail.com>
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bob Pearson <rpearsonhpe@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 0/4] RDMA/rxe: Fix MW/MR lifetime races
Message-ID: <20261015153913.GA219304@unreal>
References: <20260928171756.3254016-1-cccccccccccc777777@gmail.com>
 <20261014061223.1547823-1-cccccccccccc777777@gmail.com>
 <20261015085034.GY219304@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015085034.GY219304@unreal>

On Thu, Oct 15, 2026 at 11:50:34AM +0300, Leon Romanovsky wrote:
> On Wed, Oct 14, 2026 at 02:12:23PM +0800, Dongliang Qin wrote:
> > Any comments on this patch ?
> 
> It is hard to say anything meaningful for AI-generated RXE patches.

And it doesn't apply.

Thanks

> 
> Thanks
> 
