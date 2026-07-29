Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F7B476CF3;
	Wed, 29 Jul 2026 11:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325259; cv=none; b=T4/VnVxivgdmXIqAzo+g/rO04PmMiYC20MIzSaA+vd/lrb4nlDhepnczw1+aNDmb4A/5Tz/wNMpLVRwACFNOWQtUhepbM/X6ogemHWAzgMEnY8IDg3SBuppNY45l62G4lZdmMM65SFp2BaC7Bu6ERw56Te9UNpdiRPOT76BS9j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325259; c=relaxed/simple;
	bh=nYhEraE24NtIvnvxvWYdwPv5aUfrS8ZV/jb7kwA0+kU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=rHXGIhDMGu+njQZ1+CnMxyVQNsmK6NBFdG9wCITvnxKiCfVKwbXfkO9exv6XKzp5lE25iKfIEmYrbFrdxqIPyVxFejsP9xXV7yz1dH90ZnRwOJlxEBXHEiKylekFckqnyb6GMbspCJnpJPHuEGAUfsrNfqDYIAt/u9jq4AILA2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF791F00A3A;
	Wed, 29 Jul 2026 11:40:55 +0000 (UTC)
From: Leon Romanovsky <leonro@nvidia.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260726-mlx5-ib-set-cc-params-applies-conges-v1-1-a253edafe1f3@nvidia.com>
References: <20260726-mlx5-ib-set-cc-params-applies-conges-v1-1-a253edafe1f3@nvidia.com>
Subject: Re: [PATCH rdma-next] RDMA/mlx5: Send cong param changes to the
 resolved port mdev
Message-Id: <178532525341.1588207.16933731856946411542.b4-ty@nvidia.com>
Date: Wed, 29 Jul 2026 07:40:53 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sun, 26 Jul 2026 12:22:11 +0300, Leon Romanovsky wrote:
> mlx5_ib_set_cc_params() resolves the port-specific mlx5_core_dev via
> mlx5_ib_get_native_port_mdev() but issued MLX5_CMD_OP_MODIFY_CONG_PARAMS
> through dev->mdev. On an affiliated secondary RoCE port those pointers
> refer to different devices, so a write to the secondary port's cc_params
> debugfs file either altered the master port or failed with a master-side
> command error, while the read path already used the resolved mdev and
> returned the unchanged secondary value.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: Send cong param changes to the resolved port mdev
      https://git.kernel.org/rdma/rdma/c/033a79e308e4fe

Best regards,
-- 
Leon Romanovsky <leonro@nvidia.com>

