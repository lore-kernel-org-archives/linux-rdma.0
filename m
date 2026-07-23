Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152C94477F1;
	Thu, 23 Jul 2026 15:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784820664; cv=none; b=dzMVlf0tEz15yZU+khRy1ZLy2PkWMOCOqqwEidGrBTEmeqBQFoD1k1ZkhQD811GUcbm4a2WU7sfY+yAa0DB1HlD/vHUvk3TGEqk6EzGCCe9gAPgsXZXncBcYKsoj3F84bjkgRrMDNnnxMpj544PDtjgVql78UXjRKyO8cUdqtrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784820664; c=relaxed/simple;
	bh=S+feFNt8cXGy08sZQdIhu2kyxWvPw533dNVjxSqFevY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=UahTwvopF7nlkWI0Os3U8QqKB47Y9PC/gdUE5mgvS8CFyp27uW7gIhDQXYRKpaEhA+N50tpKToyk6Uj4xGx66HuPBikzLZ94cu1/8u2vi+UOJp/jWupFymF3ijZ54mvlwv84taPPpG24E21DvC/0fFBG+fTRbhelvDalJ3M91EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B401F00A3E;
	Thu, 23 Jul 2026 15:30:59 +0000 (UTC)
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 198533924456;
	Thu, 23 Jul 2026 15:30:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx5: Fix MCIA register buffer overflow on 32
 dword
 reads
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178482062264.2321119.13619503555012926129.git-patchwork-notify@kernel.org>
Date: Thu, 23 Jul 2026 15:30:22 +0000
References: <20260717072338.1240582-1-tariqt@nvidia.com>
In-Reply-To: <20260717072338.1240582-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 alazar@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 maxtram95@gmail.com, saeedm@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 17 Jul 2026 10:23:38 +0300 you wrote:
> From: Gal Pressman <gal@nvidia.com>
> 
> The MCIA register can return up to 32 dwords (128 bytes) when the device
> advertises the mcia_32dwords capability, but struct
> mlx5_ifc_mcia_reg_bits only defines dword_0..11, leaving room for just
> 12 dwords (48 bytes) of data.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5: Fix MCIA register buffer overflow on 32 dword reads
    https://git.kernel.org/netdev/net/c/11c057d23465

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


