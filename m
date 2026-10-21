Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792582208;
	b=MIUwkBvTwLDaZp51f04KzF7Aej3Dd0Uyh4GAbfj9UA+fOnvsopkyF3s+8wTtHNvfxMlc
	 DcgGG554sQf0n2NDNkzeq6aBU7U6ay8v7y4utAnOyZw54q1uxHwE265/KNevoNKr0gN4K
	 r4T41SGRifJfklchfDoE+c2TaZknGB5SjETtmtlvrlYPoThzRPJ+uxIIf4oN7oKlDRvHG
	 cFheRfWskn5HR6dcTCkL7oSozDNX0zFSBgdVEyeqRP6CzV9SRadcJL2t0hgGdUlZUpTmg
	 5t+QfR4tPHXqaRxbF+iy971O73AZQ/tZ4bhDNpIgV87k4MwG+F4HPp92NONuyxo1+Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792582208;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=bwlpoZEI2gH/o8wQdqLuVVmqJThjYBiGN3e7zDsACCQ=;
	b=NRRF8sCVPIOkRJiaivi9JEbgSvGqZVagndIZqkrVL5ccci0E4AMoJPAeWVTBBk+mJqCn
	 q8eRdFmEhbOQsZWStS/HlBQk62ok6akW0yK1ZyoPVKzm7/K3ko+NyeYAYyVTRMdQ+Xdms
	 7WPWJ/hH17KQ7YXKJ6BCQY0y7UafjHNQUuFggQZfZuvpdggqIbRvvmJ5/lV9jO0nObXQ0
	 nb62c9VCQx0Lm0nY8H4ra7zNO0io/GTVChJfs90D8N6UQFGuq0Rg1XU3NbowPo9vmFAUV
	 YNHqe50deqUiSCamkgss0NkRllVa0kFyz+LrKDz/GmocS+6lAtFvJDX0sTHU36eJ3UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AiZyv5Ft;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F16606A325;
	Wed, 21 Oct 2026 11:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AiZyv5Ft
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4460B1F000C4;
	Wed, 21 Oct 2026 11:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792582207;
	bh=bwlpoZEI2gH/o8wQdqLuVVmqJThjYBiGN3e7zDsACCQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=AiZyv5FtQnWD73ogb+kevHVKs2ErFA6fLmiiS8TkJvahs4RkmJQkdaCZBYfItEjIM
	 Rz0QU8rII3/yD7onseJA+uhV1c9bqD+mSoXyTREZB1K7LRMNbu7emznyxbUrSOrQbb
	 A+h5sNfCTVU2D8psTd0x2a06CVJJ2fEpeyvZ5IcQX/4bzh57/+MuAviat5fuQh2/QD
	 MREpBw0dYAQA3p0epIHZI25lzdD311IW+db5aF4qTAg3WyMEMcG2YV1zJtz4p7d8Ud
	 /3s5VeGrBfPA2371JktSo8V2wsc8/PysoH7w91Yf3EggvoJq0SoMLtRDXRWVbsS3f/
	 jGpiyA7UzO/Dw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A2B43809A33;
	Wed, 21 Oct 2026 11:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/2] net/mlx5: HWS,
 fix modify header pattern compare
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179258220603.570254.15343304656236965586.git-patchwork-notify@kernel.org>
Date: Wed, 21 Oct 2026 11:30:06 +0000
References: <20261019133159.1742411-1-acassen@corp.free.fr>
In-Reply-To: <20261019133159.1742411-1-acassen@corp.free.fr>
To: Alexandre Cassen <acassen@corp.free.fr>
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, moshe@nvidia.com,
 kliteyn@nvidia.com, hamdani@nvidia.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 19 Oct 2026 15:31:55 +0200 you wrote:
> The fs_hws modify header pools and the HWS pattern cache decide whether
> two modify headers can share a pattern. Two bugs let different patterns
> compare equal:
> 
> - On big-endian the HWS core comparison checks the data dword of each
>   action instead of its control dword.
> - The fs_hws pool match ignores the destination of copy and add_field
>   actions.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/2] net/mlx5: HWS, fix modify header pattern compare on big-endian
    https://git.kernel.org/netdev/net/c/7eed173447fb
  - [net,v3,2/2] net/mlx5: HWS, fix modify header pool match for copy actions
    https://git.kernel.org/netdev/net/c/d425ec9bb937

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


