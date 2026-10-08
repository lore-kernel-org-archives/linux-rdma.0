Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275921F3B8A;
	Thu,  8 Oct 2026 17:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791481809; cv=none; b=sW2D47471YeI0Jks4358xiuXI+2KiJAcXxVDr3FRnmacdY6LP5A4q1lFcS5PcI5gZ+qeofci/vwifQ7AvJL6HFpONX/5QVihmRutfnArW0RUQWDTT/xJkfb4DCoLdRFpJ1DFaZGPT2u99G7itTdhgvuDLk5NUWUoeeVLQ3jORzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791481809; c=relaxed/simple;
	bh=evzu52sRf4E4MfuYooNPxr0c6h/Ue42kuHN4LdJeEtw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=YMwk8AdbxWCo5T07+vnWGyTWJDPcaNhR7Fh0PmpvfKrn0AJquRAKPKCxGyWG5163Wmg3fyFCnoSF6V2kyTSsRnZw4Lz81aZiTT0NfR5R3OZcVj2YIVEJSa/2M3SiZJTDBPx+XHZDlZ0odRRvnpC906Ya8QVgMw3e9EM/1yXKcn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KhT90FIg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KhT90FIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3511F000FF;
	Thu,  8 Oct 2026 17:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791481807;
	bh=5ey2jstpU/4G+vKN1InvTPyAxlqltMOmMzX7C3DVOxI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=KhT90FIg796neY2BOHVkcIWX7l3OWFUcLef8u5Q8pBbt6a4N6Xpw1XjFLnrgzOfYX
	 t+Ws078xYD5TFYUdKThAF+5Ihk5UDVotLu+xq61jDUKtSN1wroLgTDtCTWK9mzDevq
	 t368Hn+92xTgADtvU4Ewz2aLjFDthGLzmqAkrwCjtb23WJJgpBF04nZWhD735KUQN+
	 s/yi258aE723BrUOV0WWIVEEoKkOh9AzuSSbPAMuZUy5oNTqdGqclFzMP9yliWS2ta
	 P/scCQ4C92prbxPlVpmJDQr2+adRoIJvyqieftIjYK4/mFVwWKKvQXIPa3eSbJeOlg
	 VtR3mVUZbw0WA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B443E380AAFF;
	Thu,  8 Oct 2026 17:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V2] net/mlx5e: Order ICOSQ cc update after CQ doorbell
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179148180652.369078.13220137982989518639.git-patchwork-notify@kernel.org>
Date: Thu, 08 Oct 2026 17:50:06 +0000
References: <20261006105820.257208-1-tariqt@nvidia.com>
In-Reply-To: <20261006105820.257208-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 dtatulea@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 lirongqing@baidu.com, mbloch@nvidia.com, saeedm@mellanox.com,
 saeedm@nvidia.com, tariqt@mellanox.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 6 Oct 2026 13:58:20 +0300 you wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> mlx5e_poll_ico_cq() requires sq->cc to be updated only after
> mlx5_cqwq_update_db_record(), otherwise a CQ overrun may occur.
> 
> The current implementation updates sq->cc before the CQ doorbell
> record, violating this ordering requirement.
> 
> [...]

Here is the summary with links:
  - [net,V2] net/mlx5e: Order ICOSQ cc update after CQ doorbell
    https://git.kernel.org/netdev/net/c/b056ca4d3742

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


