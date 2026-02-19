Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692D9350D5F;
	Thu, 19 Feb 2026 17:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771522827; cv=none; b=imgB645m7Lb8mybluNE6hEUenQZvYFgVVxEHelSenTTu2vzBjiq8FMsk4SIhW0M9oyGf0SqZULnRcwqTbOYNVTb2WPv2qonNIvIBDcU0gVp85Iey+RJ6kaOxoSeG7E8/87R5HhBUjW7i7Gdr8w41IB3s7HKluQWec1GrFH0nn6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771522827; c=relaxed/simple;
	bh=lV/twQnYR6xhX7VxT/ix240QX+Hupfle+GMbus/3P5A=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=szx6hs5oJPf6uOPcFtO6zWyoP9/VKm0lloSzLfLhDqdyrGjpfpCNyiFBIE+ZctnQ4P2YGiRnJaX3KCi3CQCRSzFHd2LQiK7tXVCkSHV1mkqZ11ftEv5qwzBmJu0CbCkqbD5stXgB2Y1tyS+HX8nHe+sGeO56qWMsGcwBLZV8Eb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uZr5Kzdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uZr5Kzdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20120C4CEF7;
	Thu, 19 Feb 2026 17:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771522827;
	bh=lV/twQnYR6xhX7VxT/ix240QX+Hupfle+GMbus/3P5A=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=uZr5KzddzoPSQS3PjuS5ihTzwFXE+2757Otd7o8s+4MdYs4ZllAGiIvSXrnYzSz3y
	 5FRn06UJCWp2bMKdu0JJd3D32HRfzxkCokGMJXziSvsuEi+70x/SRKM8iFnRQ6xOuH
	 HkxxtgW50JERQW6/JFrGLuXIqI8JyY0nlZtdoBbs4DydoqXs1Qvjs7cdAqg/OxYGli
	 7XralgC/iERSWshsHqz9eaEzEkMajwlATsQPB+zV26vy6AWELmKfTXYlRdS0QzlfOp
	 nP/f47SpuAPFH69oXXzSknaymH0i8q2RtSzaCDFHQqHIkda61B+VmcUv4wVFe3vYmt
	 u8tR9EpuXO5Ag==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 48369380CEF3;
	Thu, 19 Feb 2026 17:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V2 0/6] mlx5 misc fixes 2026-02-18
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177152281807.2317554.9342671396219500693.git-patchwork-notify@kernel.org>
Date: Thu, 19 Feb 2026 17:40:18 +0000
References: <20260218072904.1764634-1-tariqt@nvidia.com>
In-Reply-To: <20260218072904.1764634-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, saeedm@nvidia.com,
 leon@kernel.org, mbloch@nvidia.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, gal@nvidia.com,
 moshe@nvidia.com, jacob.e.keller@intel.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 18 Feb 2026 09:28:58 +0200 you wrote:
> Hi,
> 
> This patchset provides misc bug fixes from the team to the mlx5
> core and Eth drivers.
> 
> Thanks,
> Tariq.
> 
> [...]

Here is the summary with links:
  - [net,V2,1/6] net/mlx5: Fix multiport device check over light SFs
    https://git.kernel.org/netdev/net/c/47bf2e813817
  - [net,V2,2/6] net/mlx5e: Fix misidentification of ASO CQE during poll loop
    https://git.kernel.org/netdev/net/c/ae3cb71e6c4d
  - [net,V2,3/6] net/mlx5: Fix misidentification of write combining CQE during poll loop
    https://git.kernel.org/netdev/net/c/d451994ebc7d
  - [net,V2,4/6] net/mlx5e: MACsec, add ASO poll loop in macsec_aso_set_arm_event
    https://git.kernel.org/netdev/net/c/9854b243ce42
  - [net,V2,5/6] net/mlx5e: Fix deadlocks between devlink and netdev instance locks
    https://git.kernel.org/netdev/net/c/83ac0304a2d7
  - [net,V2,6/6] net/mlx5e: Use unsigned for mlx5e_get_max_num_channels
    https://git.kernel.org/netdev/net/c/57a94d4b22b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


