Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E656346ACE;
	Sat,  1 Aug 2026 01:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785548447; cv=none; b=dzPoyhTKUJ74ylVjcNTdnjcze1RhaJeKaPErLdPmWfbkkWsTf5tXdxrA+McCH3+Xf74oK8pthiPJCM3fKzvMU3D+/dDEeZLHrAr4xUS3AqbG4PFk0duMhIVGBkhWQYub/csdQGtqYSkyrdIEr/rNpQ4230uARmGP3XFCbr2ZmhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785548447; c=relaxed/simple;
	bh=G8H34J3xZ0BmNGKP3UaNWHEj/3jMl52QBXypxUsVob4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=PWeEf3W6Nhi/Lqt+kPZi1ghNjcxWoiCTOxPx5QLdhLl6PZD+OQEBMUGS0bpxq5Ma5+DAwmFF0dYMDsQIzLyL40BGpmpjb/+mNIDpxGCMyRAlwFdkozksH8dhn/S2I2Ax7DBMirDahDkdNr/Rm+UV1Ng3KUw90rmCV3fOwriogeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i9Qvkjum; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i9Qvkjum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FAF1F00AC4;
	Sat,  1 Aug 2026 01:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785548446;
	bh=8VVAt+1+YyEZ38uqAX6829rA/pEJlLLOhX7LXvtRTTw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=i9Qvkjumwuef3H6WQyna59rn8fwGFqOAToZWPHVEqGt2t+1uATSjaSp0xI9lC5Hee
	 ZqjP39VGLXfkYpEK5mAmsK+yNMdEMFXkBe3A3Ce3Og1T1cxx8CtkPj8IiocGWz3wRH
	 ZGO1cGS8ZZlwYt3I5VcNTPOKEXtuthkhcYKl+aiWF3JCWLCeDqOzRpzou6Vf+rinmh
	 TVR9EjtHXkptRMXhUd5F49EJCSu09WdbCMqN1qLzPT3ndUlrnENztxHGff3V09Xdpe
	 z1bmHc7CGa9Vd+QwcZrnsBA2Z9CzZ+cDSDIWSyPu2SNrsX3CcY5IE2GMf857Q8nlqt
	 00ZyWaWi+frxg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1993C392665F;
	Sat,  1 Aug 2026 01:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx5: fw_tracer, return NULL on create error
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178554840864.979996.15714749578017407397.git-patchwork-notify@kernel.org>
Date: Sat, 01 Aug 2026 01:40:08 +0000
References: <20260729080402.2427184-1-tariqt@nvidia.com>
In-Reply-To: <20260729080402.2427184-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, gal@nvidia.com,
 kees@kernel.org, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, michaelgur@nvidia.com,
 moshe@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Jul 2026 11:04:02 +0300 you wrote:
> From: Michael Guralnik <michaelgur@nvidia.com>
> 
> Tracer creation can fail by returning either NULL or ERR_PTR.
> The return value is stored without a check on the device, and users
> treat ERR_PTR and NULL the same way.
> This also causes a crash in the core dump logic, which is missing the
> ERR_PTR check and ends up dereferencing it, as shown in the trace below.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5: fw_tracer, return NULL on create error
    https://git.kernel.org/netdev/net/c/af39eb111ce6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


