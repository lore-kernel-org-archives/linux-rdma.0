Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB313AD515;
	Wed, 20 May 2026 22:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779316796; cv=none; b=UFu1i9NBw3ktArsktIBHwYE385aCiAJ3U1iXu1BKTh4RryjTPHyyAvQkKlGSQmBjNxaFTuD0aRp/JxzcuMUIw1YhgLpQ54Cjc1gM6ikz0AFAqp16uWkN3+fAJAP48mSeoY1dqzhKpJonOyIjbp6Ou9Nnd10so6TQR2s4wsbkZ8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779316796; c=relaxed/simple;
	bh=wEYWLLiy6TH4kQiDT/8z129iV0nErnoOepjzayT3DRc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=M577oG4Q3qhRnTcSOWHa/qp3F7LgYLakUAusoWojg1BSCnIDnzakFKzEz1iTV2wgs/vtm3daoAymjmVmVGlAhL+TxEPOTdqR42ubkB3IRx7+wut9rCX/jEfldBLvhRvxbNUhsUo3KbWQpmprTfJNnVlctVVFuntktuEvePxpZZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O6ekHXUQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O6ekHXUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5303D1F000E9;
	Wed, 20 May 2026 22:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779316795;
	bh=XSGtsfrzKTumBckBBGEQw8XsZbiZY511OduQmNqVx9g=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=O6ekHXUQt1LDYmprJa0Ql5cOR2ctPbvpz4l28bxRiZNUSCF1UDhmDlOfB9pod88LI
	 73WFuLsVd/Kgjx1ppdU4CfNdxZn3wO8IB/8dzdN5xVr7yOWMm/vHtTOgeem49JT6nF
	 Lp1tJ8HPQOncenvIujiOLjmxGhGcGUEkCgLH05T5CewzU+8Mi6Cm8AqNRCFejbrkXm
	 Pvbh4wGd36loIPblivhX16g3gIpi13HgzfU64My23RZLFeuGFqRhoWcC1JuHDJvly+
	 ApZMs31JGXpzRDGHzm1yJWji+A3a5F49Vtz8GQEK5hixyPitmRnwMbWB89cPM0KYNt
	 YxgsIwlRMXNaw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0AAF3930BB9;
	Wed, 20 May 2026 22:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v1] net/mlx5e: Fix eswitch mode block underflow on
 IPsec
 acquire SA
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177931680539.3780925.230940286721136300.git-patchwork-notify@kernel.org>
Date: Wed, 20 May 2026 22:40:05 +0000
References: <20260510225903.13184-1-prathameshdeshpande7@gmail.com>
In-Reply-To: <20260510225903.13184-1-prathameshdeshpande7@gmail.com>
To: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 cjubran@nvidia.com, borisp@nvidia.com, andrew+netdev@lunn.ch,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 10 May 2026 23:59:00 +0100 you wrote:
> mlx5e_xfrm_add_state() handles acquire-flow temporary SAs by allocating
> software state and skipping hardware offload setup.
> 
> That path jumps to the common success label before taking the eswitch mode
> block. After tunnel-mode validation was moved earlier, the common success
> label unconditionally calls mlx5_eswitch_unblock_mode(). For acquire SAs,
> this decrements esw->offloads.num_block_mode without a matching increment.
> 
> [...]

Here is the summary with links:
  - [net,v1] net/mlx5e: Fix eswitch mode block underflow on IPsec acquire SA
    https://git.kernel.org/netdev/net/c/abe003b33223

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


