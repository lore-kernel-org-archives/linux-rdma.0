Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81FE30BF69;
	Tue, 27 Jan 2026 17:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769535505; cv=none; b=gO7xRTXK/Y1INi5gG+KieDySf2mEjw+q7y/u2A+C9487IZyTNQLEjVXj/OQzolCxzoNEbgo1kFAHJstwex1H3uGGSA0eWcPju+cPqSlSaTK7wdkW8hSA4HsgujfGit8I7sppcpF1ans4X5awG38aaPlENCZ+Fui4J7cTnL6KUdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769535505; c=relaxed/simple;
	bh=1sORWrip5h6GNkhsP9WIl4kdoR8RvObly6DZBUxgvTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iCxXYc5/1Dn5B9uXDfverQ4S6dIQ0kOm1dL+lc0x3BL2vU+T/BEGxgdgD3YEA/p7FrnrCLRcJ4MIWdRQ7vEio8fEPneu6TJBQ8Y3QaA1L/zX55IK64Tb8CUHzGzuxhILUCtE9MkEVoRQg60e99PYIvHPfC6WCfGuJpz2d8URQEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZgXLaWun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZgXLaWun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933A8C116C6;
	Tue, 27 Jan 2026 17:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769535505;
	bh=1sORWrip5h6GNkhsP9WIl4kdoR8RvObly6DZBUxgvTk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZgXLaWun9sMrq5KJ0SaGzj5XTqZK0BSObFq1hUCfnmNHC/cXT/wsoueX43VMXECMt
	 ODvvxFIGdS3TcYix6deKoFmT1jJgAFWjHRG1MRss0+HeUvhtYFtHXMqYBbZS+Jy3ZM
	 lf7KIFTn0WvKF7gr5uUvjICUyS9nVfW3mr0cX6rOGj3eCdnhBIQYtjHO2iao7jRNVp
	 Ln30/m6R/6lpLJJe/aGx36zklndO9Ss4RwXiXLS/WvoWvvDCopHaC1ho/3el4oIqyK
	 WAxoAX7VCNHNfsCzAgBKfhmlZT++JPWgo8bGXs0HTRk8nIkJpOq/K83U57VZT6fqjg
	 y5OBGa4YSd/kg==
Date: Tue, 27 Jan 2026 17:38:20 +0000
From: Simon Horman <horms@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [PATCH net 0/3] mlx5 misc fixes 2026-01-26
Message-ID: <aXj4DJFkgUpL6ad8@horms.kernel.org>
References: <1769411695-18820-1-git-send-email-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1769411695-18820-1-git-send-email-tariqt@nvidia.com>

On Mon, Jan 26, 2026 at 09:14:52AM +0200, Tariq Toukan wrote:
> Hi,
> 
> This patchset provides misc bug fixes from the team to the mlx5 core and
> Eth drivers.
> 
> Thanks,
> Tariq.
> 
> 
> Gal Pressman (1):
>   net/mlx5e: Account for netdev stats in ndo_get_stats64
> 
> Mark Bloch (1):
>   net/mlx5e: TC, delete flows only for existing peers
> 
> Shay Drory (1):
>   net/mlx5: Fix Unbinding uplink-netdev in switchdev mode

Thanks,

For the series:

Reviewed-by: Simon Horman <horms@kernel.org>

