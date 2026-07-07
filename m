Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FDC23BD1D;
	Tue,  7 Jul 2026 09:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783417248; cv=none; b=SsFPUhuyIhXXXRMjR+Qtq0m4lItGvs9j9go376fcorEPD4dj1zccHdgA8X3UhSOOOyVqAcHprZLuxQ1BNbKbHgGintgvyEuzcpe2ELeXY0cjuezgwFUKmcZEiaAktNg0a959R1pxSUXPhQWeNFT3/HGpt2mH5Hoqs0Fq4pxvXzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783417248; c=relaxed/simple;
	bh=2SvJG9DL3UqCvuRg7Vo6qhQ4H7IzR1naPKn5y4+0hpI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=UZg3avxRiUeNs4QYADgLutU0pUM6Z3xULRodJ6oHA+ds7L6M6Ne5QN89ut8aT6WVDfnkmuLVafVkBcpfOwRjXwMwmO6DAdR93+IH8Akdigt/4RkPGM8VC9CD9Qjf+G4mmgPMNwbUFGQGfuY86KaN/uzpEoLRloLQXSMRhlzE1qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=maIQV6fr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="maIQV6fr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8761F000E9;
	Tue,  7 Jul 2026 09:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783417247;
	bh=6uJPozj/uhbrq91wleQ/hPHYt4I/QFVwHZxnDm65VnU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=maIQV6frxWzq57q2+mzWiIBsx546dKVfAEfuRxFY3qTAYTBdavS1NcqcIlgKNF7fl
	 DPhrbrl6/3XvFUDXQ+qQd9yDqZYra3fHxiIVJdd6jKJl5J8E8YPSsypeZitq0lu+Ni
	 jEDtfFnua+72m+Pena7SLoubtroRQFPrX/4UQsyaOEPjopE7RcVi8BbfTqN0SBmApH
	 hqog+vLCxpLf1DsQA2lAvAolJtd7L2WHCEh64aV75WgOzVb0p0AQ33FO0W4qE9PBYm
	 fvf8K9SFL9LpHZ6AEpaQfqIzpIv6ccJHLEyfux4ZJ3DXSDuSSGcbKccvtZJnFI6Ykd
	 8yB3eclpGVDZQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0CB03925473;
	Tue,  7 Jul 2026 09:40:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V10 00/14] devlink and mlx5: Support
 cross-function
 rate scheduling
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178341722764.1458887.13873598911208666533.git-patchwork-notify@kernel.org>
Date: Tue, 07 Jul 2026 09:40:27 +0000
References: <20260701073254.754518-1-tariqt@nvidia.com>
In-Reply-To: <20260701073254.754518-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 ajayachandra@nvidia.com, bobbyeshleman@meta.com, cjubran@nvidia.com,
 cratiu@nvidia.com, daniel@iogearbox.net, danielj@nvidia.com,
 daniel.zahka@gmail.com, dw@davidwei.uk, donald.hunter@gmail.com,
 dtatulea@nvidia.com, jiri@nvidia.com, jiri@resnulli.us, joe@dama.to,
 corbet@lwn.net, kees@kernel.org, leon@kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, moshe@nvidia.com,
 ohartoov@nvidia.com, parav@nvidia.com, petrm@nvidia.com,
 rkannoth@marvell.com, saeedm@nvidia.com, shshitrit@nvidia.com,
 shayd@nvidia.com, shuah@kernel.org, skhan@linuxfoundation.org,
 horms@kernel.org, sdf@fomichev.me, willemb@google.com, gal@nvidia.com

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 1 Jul 2026 10:32:40 +0300 you wrote:
> Hi,
> 
> This series by Cosmin adds support for cross-function rate scheduling in
> devlink and mlx5.
> See detailed explanation by Cosmin below [0].
> 
> Regards,
> Tariq
> 
> [...]

Here is the summary with links:
  - [net-next,V10,01/14] devlink: Update nested instance locking comment
    https://git.kernel.org/netdev/net-next/c/3bf4c5970ca8
  - [net-next,V10,02/14] devlink: Add a helper for getting a nested-in instance
    https://git.kernel.org/netdev/net-next/c/9f2d908cc34e
  - [net-next,V10,03/14] devlink: Migrate from info->user_ptr to info->ctx
    https://git.kernel.org/netdev/net-next/c/e48abacd6e83
  - [net-next,V10,04/14] devlink: Decouple rate storage from associated devlink object
    https://git.kernel.org/netdev/net-next/c/db078bc2b031
  - [net-next,V10,05/14] devlink: Add parent dev to devlink API
    https://git.kernel.org/netdev/net-next/c/b5f90fd4580c
  - [net-next,V10,06/14] devlink: Allow parent dev for rate-set and rate-new
    https://git.kernel.org/netdev/net-next/c/58132b6fc4a5
  - [net-next,V10,07/14] devlink: Allow rate node parents from other devlinks
    https://git.kernel.org/netdev/net-next/c/6bbd1bce3099
  - [net-next,V10,08/14] net/mlx5: qos: Use mlx5_lag_query_bond_speed to query LAG speed
    https://git.kernel.org/netdev/net-next/c/f8128b13df66
  - [net-next,V10,09/14] net/mlx5: qos: Refactor vport QoS cleanup
    https://git.kernel.org/netdev/net-next/c/89a0881183d1
  - [net-next,V10,10/14] net/mlx5: qos: Model the root node in the scheduling hierarchy
    https://git.kernel.org/netdev/net-next/c/22d32def3ced
  - [net-next,V10,11/14] net/mlx5: qos: Remove qos domains and use shd
    https://git.kernel.org/netdev/net-next/c/450ed6b182de
  - [net-next,V10,12/14] net/mlx5: qos: Support cross-device tx scheduling
    https://git.kernel.org/netdev/net-next/c/2bc38232047c
  - [net-next,V10,13/14] selftests: drv-net: Add test for cross-esw rate scheduling
    https://git.kernel.org/netdev/net-next/c/b2aa7390967e
  - [net-next,V10,14/14] net/mlx5: Document devlink rates
    https://git.kernel.org/netdev/net-next/c/403ac520e893

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


