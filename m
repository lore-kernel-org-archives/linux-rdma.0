Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3688E322B74;
	Thu,  5 Feb 2026 05:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770269413; cv=none; b=CGDR4VspOsKxfyfaazB2qFxSoiJa2dIjYqdGdovpnSrSUw5X94Um+IRCBJ/qOp/JDgdUAnRUf6wWZwFtejcQHujDZb3OJ56gS9G3DdLARYkKVQjWkJF1YIEBZZ3QSufRHN3ll0313FdsS6fGvSUW1e/9uSe3lQ8nH8ScGY571Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770269413; c=relaxed/simple;
	bh=j0O53GkvykPsyGoxYL0l01wdR+a4rE72qbq2lZ5ZUd0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=qQKcmrE4yEzhQjtIT/UBSkAyy1ctPUzjjRlohMS0rXdidUdt80vkAxNMQYr0rD+mB006ZxE/mP/T5HHdEqu99mPDQvl0jnU7EU32DTQshNTMH7DJr37RjVu4al0tlZ6KM0LaISLSvz2qPl/jh28PGLW7KM9ZJ/oAuMJHAQ8aGcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E0fsOE/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E0fsOE/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5BBC19421;
	Thu,  5 Feb 2026 05:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770269412;
	bh=j0O53GkvykPsyGoxYL0l01wdR+a4rE72qbq2lZ5ZUd0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=E0fsOE/oCTK8JiaTuigTv5IiY2tXoBSjzWc5HL6p6hFWP+Eg0Gxgm6CYUORUrzN6d
	 fK68icLR/lKdwaVAIADvtKfDTWx43hXK1LJ2xKiSqP/UWUMjXA3DId05J2dg1kCWOz
	 1fCUzaEmedOp18UyTpzVBx6OyY/wAOFsZbvuoqEnteW4ldiX2G1tS3gO1xiyaDCv2e
	 PS3UAln1kA5g1Xr159nzTzhzUe79ewHKsK2cNOas5CSdhPG0Y6nEUKVNRFeS/E3yos
	 /SzJKV/gpYvtB5gx/dD8E0GUuD1RhC2kvaA6nsfsYbcWpKNqJr6mGKdjxuPhTpyy72
	 DeOwTITRSen6w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 0B0923808200;
	Thu,  5 Feb 2026 05:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx5e: Extend TC max ratelimit using
 max_bw_value_msb
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177026941083.174316.10167696398445606820.git-patchwork-notify@kernel.org>
Date: Thu, 05 Feb 2026 05:30:10 +0000
References: <20260203073021.1710806-2-tariqt@nvidia.com>
In-Reply-To: <20260203073021.1710806-2-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, saeedm@nvidia.com,
 leon@kernel.org, mbloch@nvidia.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, gal@nvidia.com,
 moshe@nvidia.com, alazar@nvidia.com, dtatulea@nvidia.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 3 Feb 2026 09:30:21 +0200 you wrote:
> From: Alexei Lazar <alazar@nvidia.com>
> 
> The per-TC rate limit was restricted to 255 Gbps due to the 8-bit
> max_bw_value field in the QETC register.
> This limit is insufficient for newer, higher-bandwidth NICs.
> 
> Extend the rate limit by using the full 16-bit max_bw_value field.
> This allows the finer 100Mbps granularity to be used for rates up to
> ~6.5 Tbps, instead of switching to 1Gbps granularity at higher rates.
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx5e: Extend TC max ratelimit using max_bw_value_msb
    https://git.kernel.org/netdev/net-next/c/3e5aa52b45c7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


