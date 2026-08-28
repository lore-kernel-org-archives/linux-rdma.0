Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666B819046E;
	Fri, 28 Aug 2026 23:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787958073; cv=none; b=pjpxuQBsFeloCO1K/6q6V2YDL8ybVTf6cslsVEUq4E8e5G/s6pMUQow6O+xuc3d5/66UNFZ5/69AS88vMhk3dns6gA6iwLyWt6VToaEaA83kKwEmeBrtz0+ijDzbggB4eKHZM6XvgIvbqMGTeipg7oRThjB8PLFSgK4TmM7A384=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787958073; c=relaxed/simple;
	bh=AyOfdqylbqy79k8gPuR8ZfF5LOCt5cr0GizLY4ZlaZI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=UHLcwWLolwVo21e6j7m2aS5cGQI5lEKjc1SNKhRiHMC3XXe+p9FJq638FsCJS01uYAc2keLldy3EDsXo4u/KdZPPyuJhNzOSaGoXPiREHi8huVe+s6FR3Jazyh2eGApt9dXOdf0hsXquUcm3rk848aGqJegmeimMOq6AZweaKbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NOJkOT+w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NOJkOT+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080331F000E9;
	Fri, 28 Aug 2026 23:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787958072;
	bh=vbIx9zePN5daChdGR3aA9cPo4unNjYH36mSJGTyO8RI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=NOJkOT+wOK0pWdqA6sb9YUSdQKjJGbwaTKD9BoZfvTKadPEFQsy801VcZNNU6T9H2
	 zxKzJGH54nW8ArwAMt5GBMK5jpaPGwIyp2BvJeA8R9bylUn89NJ2SPCovFbUC87R/j
	 6C1BK2kusUpyk73gSIPq4WdPhud/pA7sqpktJoNoos2lxDxBkoMajgoslS2bTCMqwj
	 050bkRAbYle1Q52Txhj1gXbTNQP+7CYG/lkazCYcAsJ+FLv1F+TgdNkuM/8Pc6rt78
	 a/vXAa54+mPVFyANWoRJT5X248DoARODNEFu1VBc37i/TGlkX7jYXhvhEfQ5nEYw2p
	 nhBqT0Bq6zfJA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id E3A5A380AA69;
	Fri, 28 Aug 2026 23:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4 0/2] net/mlx5e: Prevent stale XSK buffer release on
 refill retries
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178795801656.2832451.1703867259147824417.git-patchwork-notify@kernel.org>
Date: Fri, 28 Aug 2026 23:00:16 +0000
References: <20260824141645.23700-1-jtollet@cisco.com>
In-Reply-To: <20260824141645.23700-1-jtollet@cisco.com>
To: Jerome Tollet <jtollet@cisco.com>
Cc: netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, leonro@nvidia.com, dtatulea@nvidia.com,
 daniel@iogearbox.net, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
 hawk@kernel.org, john.fastabend@gmail.com, sdf@fomichev.me,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 24 Aug 2026 16:16:43 +0200 you wrote:
> Prevent duplicate XSK buffer release when a deferred RX refill fails and
> the same WQE is retried.
> 
> Patch 1 fixes legacy cyclic RQ. It is unchanged from v3 and retains
> Dragos' Reviewed-by tag.
> 
> Patch 2 fixes the analogous striding-RQ MPWQE path. Following Dragos'
> review, it now fills skip_release_bitmap in the common error path of
> mlx5e_xsk_alloc_rx_mpwqe(), consistently with mlx5e_alloc_rx_mpwqe().
> 
> [...]

Here is the summary with links:
  - [net,v4,1/2] net/mlx5e: Prevent stale XSK buffer release on refill retry
    https://git.kernel.org/netdev/net/c/e01620844c5c
  - [net,v4,2/2] net/mlx5e: Prevent stale XSK buffer release on MPWQE refill retry
    https://git.kernel.org/netdev/net/c/63811edf5125

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


