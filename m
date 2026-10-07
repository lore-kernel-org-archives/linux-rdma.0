Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3757349CD1;
	Wed,  7 Oct 2026 02:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338412; cv=none; b=Q/ImbflylSG0rh5ZhB3uNc/A94Cz5HIivmFLoXIf1kyfBgJvNm25gi9kYFCGsOM1VHHRfmh+Uj3TQC5UoQTet5LEnq+bT8ylWaJtLO5mEKWJgJhqyB/fv7RRYxuFCGP3kjhgNqGmc6DR0/2uxfsbITS6iDXimmvvggo5GeBSCfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338412; c=relaxed/simple;
	bh=Dxu8iyB9bO2CCybEnMoz37q3zH9EXx6ks0OFR2jheKs=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=iP8xd7RssDWosW+mY6rhzQlsQCyOgB/acOyH7iR1nmcN66UA8tgUN/5gJ8CRQ+vO6cOKH4giFSdIc0PNnal6rbolr+6vKnBpGWDY9kMFRhUqkilA7kvkeXucAphNJOZLbJy4eWEmdpXPGnTZ3alDUzFRbqoQakPwcFuHNZpxCJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i1NmfhZi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i1NmfhZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441501F0089B;
	Wed,  7 Oct 2026 02:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791338411;
	bh=+EKihp7a19oBNhixihCzWnrfCDt899n1DotDhXMENqk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=i1NmfhZimQDYchRrnvIJ1tlOf71PZnMdrnrphvPf10Y9kdYX+ob6zLp1hz3CM4TLz
	 YgHbWq8YhD85lv2nw8dCPVPhcpgJQniucMn5d8wWsCIhcIb2g+bDcoHVlywaCA8TjZ
	 BfWozZs0cboZjQJXJWcnJVgNVj3s71i0S6me8dJNtAFXrshY4OArBtobhwj5TBpHxW
	 twsif3vrfFAVfScJ84u6FGBO1MPZqu10KVPFijTLA+dJRip7q1X7PARc+fKc8nP0v8
	 nNuk4lGmCAJY+euYzFMYXltcJpGXVO7nKRWytg3Dx0OGsx0GVj1lBquJxo6m6akLX3
	 LD7rfEtEUI21Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A4AB3806541;
	Wed,  7 Oct 2026 02:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [pull-request] mlx5: Move data direct infrastructure to mlx5_core
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179133840977.2870283.2399297226648277008.git-patchwork-notify@kernel.org>
Date: Wed, 07 Oct 2026 02:00:09 +0000
References: <20261004064921.213888-1-tariqt@nvidia.com>
In-Reply-To: <20261004064921.213888-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cratiu@nvidia.com, dtatulea@nvidia.com, edumazet@google.com, gal@nvidia.com,
 jgg@ziepe.ca, leonro@nvidia.com, linux-kernel@vger.kernel.org,
 leon@kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 saeedm@nvidia.com

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 4 Oct 2026 09:49:21 +0300 you wrote:
> Hi,
> 
> The following pull-request contains common mlx5 updates
> for your *net-next* tree.
> Please pull and let me know of any problem.
> 
> Find more details below [1].
> 
> [...]

Here is the summary with links:
  - [pull-request] mlx5: Move data direct infrastructure to mlx5_core
    https://git.kernel.org/netdev/net-next/c/8e37d7bec796

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


