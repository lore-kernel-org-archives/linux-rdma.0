Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794279281;
	b=JxVrCId+zS9tIG4anF84yaQIjENdR3j0L5hUzL14g1C7c4KuwD3X/pMfiJRHaDIUIo9k
	 YURVGYekoi2RJS4QNRHkrnCUSRPjqILtTkFrQEmQlimZZJcMu/vgltLD6JHtMOlwcvAuP
	 20VxO8JtS9JRP8sDGtArWlEw0jwl2hGrTXg7nDMtZmUm09SnbIkV9WWKz3JT6j3YOYGAW
	 z7TAm1YVLqA3H/6OM+y9pqFUtok3AVr8Tf8vj4qqxQWeSWN+jHBS/qib0UeP+XgR0dH5c
	 xuDMYBrLxq1Op8Yk6g3eSa44ttbtZZNjSPi4H/JfhTHLN8VtRZRkKJLi447Lilok9xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794279281;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=g6oh1GoprNv8OEu1mMLaHSeLJSaPWmtGwyTS29b62m0=;
	b=Ut9I6jw7j00iQzKDNE65m6DwucnkWyni8GIferSc0Pt/7AUnVGkhX0EE32fH5Ym2r/1L
	 lhzICvxF749dZDKSYAvEK4s3RI3XemEYp7gUtEzSokIOn+Xg4as+6H9FKRAhYMNWFvpnO
	 g8UKMgKQ82RM82Axr/67WU/BZz4S00XBzKWiO3ADPcVE/F9hqWamCslPfojKpqELwaw5J
	 K9yhPFZDXxT+krGX9ve1rjw2P2JsO0awHITh4hZgD0miP7xdBwuCPVvc8L28aQaXrq/Qk
	 l5QEcyZfQsqec7kCXU+ueMoa2AbXoSnNTP7tS4gsZYjB0nGDI98IpbCH+18uHGmN4aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pd1+6Se3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9563606A33E;
	Tue, 10 Nov 2026 02:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pd1+6Se3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A341A1F008A3;
	Tue, 10 Nov 2026 02:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794279280;
	bh=g6oh1GoprNv8OEu1mMLaHSeLJSaPWmtGwyTS29b62m0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Pd1+6Se3XsSQmJy7AoxFfMVztTEnHzIt+mAhG5+WX7qBSm78fgJVSB+ElozxDSTtv
	 NyfAc2SzR+VbCsKYxdk83xzLC3jicMTDQD0FmmyyiMDvyhkwTuLyb8emkyZOqtTZUo
	 KpjvX5VnQHPBbhIFOQys4HZfaq6/LtXR+XJDwFKbCzwFt3g1Jjy0DmvhDTGpwTbfDs
	 henjDJcEhjBA8l0ncTH9+KKyEnU2c1fY5er4Xv/gaIydtA5pJZBS6I1Q4gGc/Zv1jX
	 OJyulIKlQDbogds6d0phQ4HtQgU+WQpVJ6X3DyOyJUqM7ElGUP+KFejRuX/Up08Yrv
	 eTkKssOK0ICtA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9B1A7391AFCB;
	Tue, 10 Nov 2026 02:54:40 +0000 (UTC)
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
Subject: Re: [PATCH net] net/mlx5e: Fix queue stats access to queues without
 stats
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179427927917.3612825.16915849545369463140.git-patchwork-notify@kernel.org>
Date: Tue, 10 Nov 2026 02:54:39 +0000
References: <20261104-mlx5e-qstats-null-v1-1-a6a003245cec@debian.org>
In-Reply-To: <20261104-mlx5e-qstats-null-v1-1-a6a003245cec@debian.org>
To: Breno Leitao <leitao@debian.org>
Cc: saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, joe@dama.to, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 04 Nov 2026 09:04:11 -0800 you wrote:
> I am seeing the following mlx5e crash in the Meta fleet:
> 
>   pc : mlx5e_get_queue_stats_rx+0x4c/0xc8
>   Call trace:
>    mlx5e_get_queue_stats_rx+0x4c/0xc8 (P)
>    netdev_stat_queue_sum+0x78/0x480
>    netdev_nl_qstats_get_dump_one+0xf0/0x268
>    netdev_nl_qstats_get_dumpit+0x7c/0x1f8
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: Fix queue stats access to queues without stats
    https://git.kernel.org/netdev/net/c/9a24799e219b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


