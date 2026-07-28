Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A4929AB07;
	Tue, 28 Jul 2026 01:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785201646; cv=none; b=SnlQTqKdGReCoI4R8rjOK9NgJdEMKApdUlpQCZ2xJH+Or3zwnO5csCWoueL/3gcmsDXCY2gMMkiBHayHsmmc+BbLz01uvsLFWGmbzDvmtRn6jvr4IwXWzbDTIQf4/U/oWHgGZZbNu8ioRU/pmiXBrV+gtV0A27+M5BL+GMbJnbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785201646; c=relaxed/simple;
	bh=Gbv4ribjfgYE4O3hGTwhwog47clxIp8D1F8RFLEabDA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=TUOc8L514kUya85IDaUj0nA1ujcvuwWh2dGtIxyJmH1OT4kk6lp40piZ1yTpcnZbU18tiEaQcXF9uSUEFLR97864pAF/ho5bhOT1R3257HudUmhISpOe4xC6VxqOqHKDOyLCK6WRD1xOFXvIWKkPUdTm4X3zT5ZvhH6KZ6RlY2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A6p+F9Uj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A6p+F9Uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D8B1F000E9;
	Tue, 28 Jul 2026 01:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785201644;
	bh=n7AL4bqhd8Ndybe014NdoMMZBEvr1T8ARDNNc0f42MQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=A6p+F9Uju0lfGCcudLBQgFWKyb7MI4siQMOiy6ew5CPm8QX50iAb0aHqutDYMEqE1
	 9vi+xiWkouLMu3a9DHwWhcXwYmswnpvu6oHIgPUsZfL554A3W70f6LxA8/g83aNj4W
	 PwMJi1QXjuCay00eYrVHCx88zUBCkCv4Tsmu+/4C+PFNgedvT4YNGzGM5DC5DSa+5G
	 yqtys3A8HHPnclYFFCh82YfAhWrjbY+dQQ0MUNWT10s7JHbUXqwidcuW3847pD38zN
	 z4c4Vhx3OZbJdpCflLvjGllxgbsQP82Vb8eJCt7ZmRE0bCxg8q4vD43kaQIw8rbKpD
	 HIVnEWcGwWJsg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19AFE380CED9;
	Tue, 28 Jul 2026 01:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx5e: Fix indentation in
 mlx5e_free_mpwqe_rq_drop_page()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178520160964.1489434.986474261426318489.git-patchwork-notify@kernel.org>
Date: Tue, 28 Jul 2026 01:20:09 +0000
References: <20260723094452.1888786-1-tariqt@nvidia.com>
In-Reply-To: <20260723094452.1888786-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cratiu@nvidia.com, dtatulea@nvidia.com, gal@nvidia.com, lkp@intel.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, saeedm@nvidia.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Jul 2026 12:44:52 +0300 you wrote:
> Remove a stray leading space before __free_pages() call.
> 
> Fixes: 0285cc3dac1b ("net/mlx5e: Alloc rq drop page based on calculated page_shift")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202607142323.qm25Crps-lkp@intel.com/
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: Fix indentation in mlx5e_free_mpwqe_rq_drop_page()
    https://git.kernel.org/netdev/net-next/c/41ff498d3392

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


