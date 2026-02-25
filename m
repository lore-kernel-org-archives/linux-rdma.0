Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9C83B8D51;
	Wed, 25 Feb 2026 13:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772025220; cv=none; b=Pzh1ud/9COelWTOyF31mlVMefhU9POPb5IvLIjWHD7+22kJIFRAdOqeTBWyyzwTOxuTpsQtzceHieKZ21lnc+iXljoCW3g/fSOSZJApkGYmk31XGre7rStsf25xjORcD6tSmUdg1v6IqNikcXw1g7xtyqHZU0FjQCFJuj7eNuRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772025220; c=relaxed/simple;
	bh=AgWgaFVG58kU1IsiDoN0w3kEAhLdkPjZpE+1BHWPWps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g1bDJkLw1XlkLfhomIKZvtJfmgRLSLL2Kh7b3LQ1Pb5y6twGIru2rmHTme67ur+KfQ1rGVTWqnr/IoumictPkycp5LYmFanOvjSey5vONwXyrXmdhSdlQ2033/p20OoUmg+UtJAlqBoTQzFhQF/Dvr9aG6Jtic8Z+J5oHDeNRrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uzz08AfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uzz08AfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C9FC116D0;
	Wed, 25 Feb 2026 13:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772025220;
	bh=AgWgaFVG58kU1IsiDoN0w3kEAhLdkPjZpE+1BHWPWps=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uzz08AfRmuh6aMZjDVoTnlyoWiZ5zffIjQnV45grStHZJN6aDqQwQvQOQjeW7/bVz
	 01dD9RfAgpDNuHPStpEjdt2wNEh6+MaaZjSE+HeGQD4oAY8wOKkKkCwktDiHUGym2v
	 U/g8PH2rkn+po7Pd1xrkyk0dBan47ae1Xm8E/bEP21E2R86M5rVNnlb1z5Fnu4DWe5
	 MNKVXO6cWYuJHWsozQNscAmvijQv83bGkkqPMHk/MNX712N1E1Z8GIqi3K/+DuK9q8
	 YgkVfZbXv8P6L3gZXIq3JJ34ZQEScW7d2ltKOLAes2/PmPxIdWatbz+jjvWUh6ri/S
	 nlu+gZu7jorQg==
Date: Wed, 25 Feb 2026 13:13:35 +0000
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
	Dragos Tatulea <dtatulea@nvidia.com>, Shay Drory <shayd@nvidia.com>
Subject: Re: [PATCH net 0/5] mlx5 misc fixes 2026-02-24
Message-ID: <aZ71f-egacWMroom@horms.kernel.org>
References: <20260224114652.1787431-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224114652.1787431-1-tariqt@nvidia.com>

On Tue, Feb 24, 2026 at 01:46:47PM +0200, Tariq Toukan wrote:
> Hi,
> 
> This patchset provides misc bug fixes from the team to the mlx5
> core and Eth drivers.
> 
> Thanks,
> Tariq.
> 
> Jianbo Liu (1):
>   net/mlx5e: Fix "scheduling while atomic" in IPsec MAC address query
> 
> Shay Drory (4):
>   net/mlx5: DR, Fix circular locking dependency in dump
>   net/mlx5: LAG, disable MPESW in lag_disable_change()
>   net/mlx5: E-switch, Clear legacy flag when moving to switchdev
>   net/mlx5: Fix missing devlink lock in SRIOV enable error path

Thanks Tariq, all.

For the series,

Reviewed-by: Simon Horman <horms@kernel.org>
