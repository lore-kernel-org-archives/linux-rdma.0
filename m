Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D1B2750E6;
	Tue, 11 Aug 2026 12:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786452253; cv=none; b=d5G78x2nM1Rx3hkuPAmUh4UKFfFQd3gGklP3kpxCzG5aDd5bl99M/RzZp+NMLdMiS5rZAYoqoRZgfl0prea/ziHJrnD64GohsY69Psn0kUC+mwjvGARLfIFz6osi57crkqwnXwm1VOWDEGwBoWdHBHEayrOlvGLYUsNCA350qr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786452253; c=relaxed/simple;
	bh=YOKxPk4UQU8Q/YqmNgjD4VvTLlLmDER9b/ME3Rc29ow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jXOeHoNDLb5K8sXEtt4M7RrTmhZAmH1Ul5/5mhJR2pMg3F4IXPMcYghB2tyj+7aN3YzerR9KWK77SHo4W4ERkFar/QZGwpt2pJZZLMZubh6jy6W1WWHuKvQvDnTwG13p42t9K8RYbgCJOAEiuVZkVve7Qvt+kjSz0twMwn7UT0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bX/Tz0ld; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bX/Tz0ld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED6C1F000E9;
	Tue, 11 Aug 2026 12:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786452252;
	bh=bICxtWvih/S0Zn8lu7m4XsNzSKeJtNKZQV3DRHBuIHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bX/Tz0ldP0UhviuWyFbredbIbk2ct9oGdMnQ9m94dFB8Q2Bu8+2pCfIJqnXlJaU3t
	 DAqpJZwgXC0DDYCfNAKsL2qsSJ56h4UOlxBxJWU/agopcyZAzSYQT+fW2hIoNI5COZ
	 LZE6kuC0jyrwhmCz+ae9we/RrYYsXe2s+Ek7NB/VNe8evfWUVFAsynJu2EJNxCigfp
	 YQ0Rz/SBv+ACsXmqzEhx0b9PvbIkDYKMJDxuq3e/yRwag5XhcJHOxnlD8cj3XRtotO
	 KAN6/hPk4jgKbvcD9s+MjT6Kj1pRi0Zyregj5igUnBJGatA/G/h6FGafyEPw7zbbWj
	 H1j8qmMiU4D2w==
Date: Tue, 11 Aug 2026 13:44:07 +0100
From: Simon Horman <horms@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>
Subject: Re: [PATCH net-next] net/mlx5: SD, prefer sd_group_size from vport
 context
Message-ID: <20260811124407.GF51943@horms.kernel.org>
References: <20260810093037.3138197-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810093037.3138197-1-tariqt@nvidia.com>

On Mon, Aug 10, 2026 at 12:30:37PM +0300, Tariq Toukan wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> Newer FW reports the SD group size directly in the NIC vport context
> via the sd_group_size field, gated by the sd_group_size capability.
> Switch sd_init() to source the group size from there and fall back to
> the MPIR-based host_buses query only when the cap is absent.
> sd_group_size might return 1 in some FW configuration. Add explicit
> check to disable SD creation in this case.
> 
> While here, rename host_buses to group_size throughout sd.c to follow
> the new name on capable FW.
> 
> issue: 4680618
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Hi,

I'd appreciate it if you could take a look over the AI-generated review
of this patch at https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260810093037.3138197-1-tariqt%40nvidia.com

But my feeling is that this patch is good as-is.

Reviewed-by: Simon Horman <horms@kernel.org>
