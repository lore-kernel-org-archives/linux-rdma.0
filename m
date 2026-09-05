Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE19136A342;
	Sat,  5 Sep 2026 20:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788640271; cv=none; b=GkLr5fHF3ARxg5WA0rERW9nQXrijeIaj64IzU0CcjZ+BcA2eIUx3XAT41vhpMY6FonVMvrf6W7fwxQYqpAIKfekIqOsxoaWpWb+DM6hP+Sma+lV69/Vkju6JdArlvWDKdyTfIYs88hIHF0VFdGVv5ncMJGla9AwB65MxGHaqkao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788640271; c=relaxed/simple;
	bh=0kMYsct4g4NuH108f0ysTw/aN4IrMp/kjfxzrxp5yWU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=gnqk47sdQTOZK+6yfq2M378xrWKnLbg+CTUJgvW+NAGIzIj3PsDKpQELg0ZwKoNC+YiQIy7PyJTxjstypjYuq6I8lYuh0xIWdz1w7XJhy2ua0MfEKo8FmqtbzKUNvaWFEAQKyzFCBpe81xiYH3eglXcczN23ETzjDt6pTpYaYHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iweq/IWg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iweq/IWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21E61F00A3D;
	Sat,  5 Sep 2026 20:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788640270;
	bh=nd1XVqCeJ776sTUNdI/GXh5sz+Onx4QwyGOlDkrT6B4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=iweq/IWgM6Eqw1sPbpKQQBTascycDtzUIyF6fRMP8p389SbDhxwCOItylFE+YdbDr
	 KbCk5EXoRmhZMcwD5uhlB3dFKFtng8oe2DJQrhO4g5t0x2igSkJhvXeotq4LiJ+Sa4
	 eftUgwn9sCtnpeQkrJQ2VoTE5GHePF7QaVS53w8Oujbgr4wGxvCboJwxArM4u+Q1Yq
	 AQXLa9fJk/XAvov5ev0ERgO4XQzZGfV4+M0lc7namUSiQxYua9Rb2tWUxeQtgjvnz2
	 Gu5CnKqPpTgwyd+Z+Zkq+pyD8gJWpE/fBTr4mSbBUi7qCuGZEMHXoMXt0lhNiwjYTg
	 7s2ISsVn/KT/w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 197EC3924FED;
	Sat,  5 Sep 2026 20:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx5e: Keep HW timestamp stats monotonic across
 reconfiguration
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178864021064.1345393.1396917263218162840.git-patchwork-notify@kernel.org>
Date: Sat, 05 Sep 2026 20:30:10 +0000
References: <20260902193731.3668958-1-tariqt@nvidia.com>
In-Reply-To: <20260902193731.3668958-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cjubran@nvidia.com, dtatulea@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 rrameshbabu@nvidia.com, richardcochran@gmail.com, saeedm@nvidia.com,
 shshitrit@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 2 Sep 2026 22:37:31 +0300 you wrote:
> From: Carolina Jubran <cjubran@nvidia.com>
> 
> `mlx5e_stats_ts_get()` currently selects either DMA or port timestamp
> counters based on `tx_ptp_opened`. This flag is intentionally kept set
> once the PTP TX queues have been opened so their statistics remain
> available after queue teardown. As a result, DMA timestamps are no
> longer reported after switching from port timestamping back to DMA
> timestamping.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: Keep HW timestamp stats monotonic across reconfiguration
    https://git.kernel.org/netdev/net/c/df99553f840e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


