Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B07277C9D;
	Wed, 29 Apr 2026 20:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777494542; cv=none; b=Qp/ZAtG0Wp5MwVYzvngJNlB139n8Prlsaoyabtdit2wBs1LUdLhUqrCQNE2VEAnHBK5gcdg980PKxbAmbUYzzoqxS7zgdkJXF8aD9HeNjfML0W3kKT8uUhkQRxpSp+rbhG9hSPjyWEQlBbq53Rd7471XCAU7E8mgIWHXoWdtZHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777494542; c=relaxed/simple;
	bh=J2PFnD/NV18v3AfaqxJrphZGLmYuYp6QBT86kPzCczI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Dih3VUKU56hhgv1X/NuEP/yQyHd7mGaTY/9m0i+KGHCHjBZY0oJH26gzJnGXzabCWvP2G+lOORAmVg46ThyVbPs/Mccl80Q1szPhDaTjAyxHwvrs6LOwIwIlgVpk4wR7a1IB9pmoWVMqfL8jzpu14aKvKOJ4DeCYcWeMr9Bz1r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u0yTZDnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u0yTZDnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99055C19425;
	Wed, 29 Apr 2026 20:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777494542;
	bh=J2PFnD/NV18v3AfaqxJrphZGLmYuYp6QBT86kPzCczI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=u0yTZDnB9gQgilOVjBPykFjbFWwJkykiZp5LJWAs9IgJ5Lpnj/2jvubvWWdiaYg1K
	 y8uF98Jo6wcjGK/n5uDg7IXBeeHOma7K/po00E9552slH75LdgP+YK2IwlYBwvv5sB
	 9B5FIdnzh/bH1OACU2QEWzKJqtJdf+apHtJITFDIziPkhdD5YI5u/3dUSMHCWKkUNu
	 C16u9tgWBzd6IyBFH+tJwWEnMTP+QgukcKAW+bbOtFQA71I+xcXqXXGN/0f0novGSy
	 OpOHCWnIB+yp9Jfu0Mhrt1BPK/KO21eLMbSCLHp/TVwKUZo2NgvaXIoQe6W6RbZdjh
	 nAQoG0xORVjRA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Saeed Mahameed <saeedm@nvidia.com>, 
 Tariq Toukan <tariqt@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Mark Bloch <mbloch@nvidia.com>, 
 Moshe Shemesh <moshe@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
 Shay Drori <shayd@nvidia.com>, Kees Cook <kees@kernel.org>, 
 Daniel Jurgens <danielj@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, 
 Simon Horman <horms@kernel.org>, Jiri Pirko <jiri@resnulli.us>, 
 Adithya Jayachandran <ajayachandra@nvidia.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
 Gal Pressman <gal@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20260428053851.220089-1-tariqt@nvidia.com>
References: <20260428053851.220089-1-tariqt@nvidia.com>
Subject: Re: [PATCH mlx5-next 0/4] mlx5-next updates 2026-04-28
Message-Id: <177749453897.1883585.177725828094234820.b4-ty@kernel.org>
Date: Wed, 29 Apr 2026 16:28:58 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 28 Apr 2026 08:38:47 +0300, Tariq Toukan wrote:
> This series by Moshe contains mlx5 shared updates as preparation for
> upcoming features.
> 
> Regards,
> Tariq
> 
> Moshe Shemesh (4):
>   mlx5: Rename the vport number enums for host PF and VF
>   net/mlx5: Add function_id_type for enable/disable_hca cmds
>   net/mlx5: Remove unused host_sf_enable field
>   net/mlx5: Extend query_esw_functions output for multi-function support
> 
> [...]

Applied, thanks!

[1/4] mlx5: Rename the vport number enums for host PF and VF
      https://git.kernel.org/rdma/rdma/c/5ffd937ea4050e
[2/4] net/mlx5: Add function_id_type for enable/disable_hca cmds
      https://git.kernel.org/rdma/rdma/c/a750f4674a6338
[3/4] net/mlx5: Remove unused host_sf_enable field
      https://git.kernel.org/rdma/rdma/c/e2337517e127b7
[4/4] net/mlx5: Extend query_esw_functions output for multi-function support
      https://git.kernel.org/rdma/rdma/c/02c54621e81ccd

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

