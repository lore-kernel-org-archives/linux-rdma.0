Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027AA226D18;
	Tue, 18 Aug 2026 17:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787074745; cv=none; b=m19hjx4EgH3cjbg6k+QSQqVWgIJNZJSXQ0Gvwt7mBNeX1+iWnFlu+SV999rwj6a+82UdAQ5emOwTwJUZzi+/9LVaFEYRDFxNoX//dZTK91D3e050r7hnVOIznYkfpH3SooI62vEU4Umw9ZcU0qaHyOSORZJmRPVvT/6FElSAEOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787074745; c=relaxed/simple;
	bh=loAphD++F5F+ODofjKZuk4fwTC6hvA11p5sJDFFfoVI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=p/OKpF5shQyFOtq3GzpzUQnTMWe4N3FuZyhjIP43Y9BoZ+PkLcm4/bsJoqJsMR/r0Qyu65z9iJm02Wc6ocCHXkBDAZfEv8U8DsrncClRIFHFDjFjI/L+QUuHLeF4EYvOomo9U/EcCddNws8SaOED994WaA8YTLrVQV/GciKCT0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BigtRrJK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BigtRrJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63531F000E9;
	Tue, 18 Aug 2026 17:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787074743;
	bh=cBUG/aFVbnBvexeXKOjJQTo/Cdbax88oUFNJ1PI6Tgs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=BigtRrJKMJrucZXyv+0Er46Ava4IsE3aSX1OMxdLNmwlJdPDAGQ9++rMNvvy4CzXZ
	 Yys/Dik74lKzxqhvV5liz/6x1RPRroB/QzdZE6sGsWKm4D2Dphm4pYX4ou87GvqaWq
	 BBARJOpTtc22wyj3DF4qf6E9RM5HGCTr/YM7RqPwGrHp/cjOc/TmjIhnV1tNEHtlUt
	 LfKRU7hhzHkpUC21ujzO0uhu8OSEEQFQ+YUAtRLwpuLswpxevxAFAFBpwKC4XmHQ7E
	 1MZxoMfNj/gj8py/EVyaMBe0YZ3pakw+moqqX/BHhbUfVEoIxH4apth4VrdwwHeoCb
	 3bekxPKHBN+Dw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A8F3927043;
	Tue, 18 Aug 2026 17:38:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V3 RESEND] net/mlx5e: do not HW-GRO coalesce small
 frames
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178707469522.2194892.9488420568567548375.git-patchwork-notify@kernel.org>
Date: Tue, 18 Aug 2026 17:38:15 +0000
References: <20260816064259.3279548-1-tariqt@nvidia.com>
In-Reply-To: <20260816064259.3279548-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 benishay@nvidia.com, gal@nvidia.com, gmj@meta.com, khalidm@nvidia.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, saeedm@nvidia.com, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 16 Aug 2026 09:42:59 +0300 you wrote:
> From: Glenn Judd <gmj@meta.com>
> 
> When hardware GRO (SHAMPO) coalesces a small IPv4/TCP segment that was
> padded up to the 60-byte minimum Ethernet frame, the trailing padding is
> folded into the merged payload causing padding to be delivered
> to the user as payload.
> 
> [...]

Here is the summary with links:
  - [net,V3,RESEND] net/mlx5e: do not HW-GRO coalesce small frames
    https://git.kernel.org/netdev/net/c/e2466392a0b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


