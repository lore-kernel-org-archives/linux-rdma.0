Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C156274FE3;
	Fri, 16 Oct 2026 01:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792115406; cv=none; b=sMFvEFGeB3UP4m5pLHCynhoVZ0WTjXrAn7on4U9DRBQQyJE22vdKOTfkZhvrdLTyz6XvpKhHKUo7AxB8kKD4a5N0WMwbGValJGgK8AtfUo6LHLyMgZ8MgmpQQV0U292XLFwxfy3fl1eP3XaZXEQK/DHJf8esbkl3QCO0QStOMW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792115406; c=relaxed/simple;
	bh=Ss7MoAUJw4G1sAUR2/Uz7luIL2KoyFRF4DV+x8yLgvA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Gm2T5t2BbdMSkU+zhjTkyJ83ySG1qYeiRXTtiELwhRALykPUpP4XU4PfQ/oUpxSjExef5hjNux1Rd8y39kNAG732PCthkGhGMOKarrycils8Y84Rpf5jgw+pBRZicl6kiB5EBuYkYkbQEZEOr9X9ysAoBqvpahTdo2yeXLY/25I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EM6W9NfX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EM6W9NfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8130B1F000C4;
	Fri, 16 Oct 2026 01:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792115405;
	bh=ZHMpW6g2AT9QmM2to29AE0RfvWtO9DZgDXdROZfYqE0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=EM6W9NfXbrVgCNSEARqWdIpq9JVvHqYK8WTsbUeAXKsFMvyeSCw9b7bIhLfmZXOz/
	 yPSd90YKZxVPHARu8OnVvwUOggIlYgm8CHMN73Q6agkc+OzXq3Ht6/Nrk/LgDd3DhW
	 qqHqs/4/aP7ih3cvauEc0MPlrF/qr2i59K1AsD2Tp95OUrRYSQNYv/7VgxOFQed28b
	 WQEPq0zAdkNjAvoS13oS+SAy2qOSxfgjHmu3a0wss7juq0RmkIDXuer2+FH0LlXnN+
	 m08J4MmiT2WEaT2xYVq1JwnVFx7boKwGuWrsZx75ocjrOQ1vQP2kpUBoSboBlHoXwT
	 O5fw8hdimgZeA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 775273808209;
	Fri, 16 Oct 2026 01:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [pull-request] mlx5-next updates 2026-10-11
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179211540429.9195.777106833416526927.git-patchwork-notify@kernel.org>
Date: Fri, 16 Oct 2026 01:50:04 +0000
References: <20261011113534.802524-1-tariqt@nvidia.com>
In-Reply-To: <20261011113534.802524-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cratiu@nvidia.com, dtatulea@nvidia.com, edumazet@google.com, gal@nvidia.com,
 jgg@ziepe.ca, leonro@nvidia.com, linux-kernel@vger.kernel.org,
 leon@kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 saeedm@nvidia.com, moshe@nvidia.com, noren@nvidia.com, ohartoov@nvidia.com,
 shayd@nvidia.com

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 11 Oct 2026 14:35:34 +0300 you wrote:
> Hi,
> 
> The following pull-request contains common mlx5 updates
> for your *net-next* tree.
> Please pull and let me know of any problem.
> 
> Regards,
> Tariq
> 
> [...]

Here is the summary with links:
  - [pull-request] mlx5-next updates 2026-10-11
    https://git.kernel.org/netdev/net-next/c/9214626223a0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


