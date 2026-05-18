Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EFC2D3EEB;
	Mon, 18 May 2026 23:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779146395; cv=none; b=Qpe/R6wZHDRktJ+qxT+ULEir/s12E9DHeUTT5rUPYQPUtdGFckJsGRwQjkGHrLzDcvl0krF7DqqbITAoKV1RZ3Q0uFl+4ly683xT2/Yhel6BbAQoi/EeF6V2dFMVrzpByIBWmSbDhjPH+huchaYVbcyh/V8t61AyN+4Vg7b9dd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779146395; c=relaxed/simple;
	bh=AVy9UXVeOUXakr8Jfjfa2468RcZGFADogY7gDwG1FCo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=EbQKNFwfxvDUcveOoK8KGZAMfaiuuAIMYKaA0UYXzFfwys2AipjLdJotn9PPUdRuJlAQmP/h8Hek73t0kaVEb64pjD+20FxGfA4fG3kapZrOwHmhulminX1C5jf7WJ1Cxwq2JSy3RXeapufkjUGzA4iKQKsoazzXcaX+Cn27vu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hTfmnKsz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTfmnKsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844DDC2BCB7;
	Mon, 18 May 2026 23:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779146394;
	bh=AVy9UXVeOUXakr8Jfjfa2468RcZGFADogY7gDwG1FCo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=hTfmnKszDOxvrWbJ3GZzpBdCHc2I7kvuM6PzGnELpqpAWI6p4uscXg6U7Vh7V+Hw7
	 Gm7gMx4SqeVO4RZAww4+glsFG1USGYC/qJCChdy8IndPXib49A1aq79sObrTNmCVMk
	 kPEzolfAyZLod6796SHJRQ+IYr6EuDMHbHo8xQNHtDUcjlq9lLa0lPC4VRCtu2ZP32
	 sP3zYljnmVJ1fjNwFSmJDdCKTp3Yh2ocWxdnyXKXVmcWtq9hVjRXbPDlPbRbM4VEnt
	 UKA2Tg8W6WTKqm1/dEJnfhDPgmTKVKWaOeSFGVRK7qIEg1ht8waU7KLtTFZMZkktCY
	 QMyMXmmFcRHeQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 199C53930CBF;
	Mon, 18 May 2026 23:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx5e: xsk: Fix unlocked writing to ICOSQ
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177914640589.2007494.16032581181637646896.git-patchwork-notify@kernel.org>
Date: Mon, 18 May 2026 23:20:05 +0000
References: <20260513064613.334602-1-tariqt@nvidia.com>
In-Reply-To: <20260513064613.334602-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, saeedm@nvidia.com,
 mbloch@nvidia.com, leon@kernel.org, tariqt@mellanox.com, maxtram95@gmail.com,
 daniel@iogearbox.net, saeedm@mellanox.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, gal@nvidia.com,
 ps@meta.com, dtatulea@nvidia.com, ps@mu.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 May 2026 09:46:13 +0300 you wrote:
> From: Dragos Tatulea <dtatulea@nvidia.com>
> 
> During napi poll, when the affinity changes and there's still XSK work
> to be done, we trigger an ICOSQ interrupt on the new CPU. However, this
> triggering on the ICOSQ is done unprotected.
> 
> There are 2 such races:
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: xsk: Fix unlocked writing to ICOSQ
    https://git.kernel.org/netdev/net/c/c326f9c68921

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


