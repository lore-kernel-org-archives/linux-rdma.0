Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB01B38737E;
	Mon, 24 Aug 2026 19:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787598669; cv=none; b=fOMuwSseBHljeCgXDDRoG1c+sL4EqU+ZIMzKfeLmgKeOsNnixXtgFxhf2lPJEGpq7ihPXmsZ7nc4pNjjt2AJde75VqGZKLNB4jtJVO/RlMazE/wTkoir17QN1RyMFJUQGiMAJ5DPC66Gp1pcIp+lrtrw5+0nQ0JXqTJAVVVmiyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787598669; c=relaxed/simple;
	bh=mitEZn98pxBDnOUFwbQDEm/3gYZ4iN/lJWDw8XIgGVw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=KN/c65yOgzi55dypjyVf6EPR1ePG+2W2ZTeyniivWjgT/UOfL/vsUhvwowxRNH6oC+9pf5ML5HGGfyAKe0hXI3TtuNUhvz0t/k2ywURt8E6q64jhlVd3sGcNXoTGpJVwE+lgq+O7XvCZXhRvN1p4xkHZ9mjPRAli0FMJ2QsQiVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TDpWE3vh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TDpWE3vh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEF51F00A3A;
	Mon, 24 Aug 2026 19:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787598667;
	bh=ZEJWbdEIzy+Rgjf/YiOo6hMxIWf+If8R7/DjjZcYWac=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=TDpWE3vh/0fXpi5somHvI8pTWwoncG0MMf0ObCmJM5JrlDlrfU3n+Ag0XsA9U/iiT
	 YFeDSHGQhhljH12lA0UMzZUorGKrW7rjSxVLh/eShX3as4p5zsWgq/NeBZtPoHf8oU
	 j/DMHqPWLlbDfs7WwCM7mIaM9lLwGlLpAx3mUX3oy4ntSDE8LMJRYxDqXqv4wf8NUb
	 bVCYPgflkAf/VXmR+Mzc48u3lJZGoWJtzvvUDWh6zzeZMi6L4Kx0NHyWFo/xyRvavX
	 RYOKo2bs19fhzO2zAxZMYnsNcugK9QG8Gl/797pETH1XYdh7xwehZ5IlpNFI18T3/O
	 ikbuEcA5yfnEg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 8B6E83924A4C;
	Mon, 24 Aug 2026 19:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/rds: use wq_has_sleeper() in
 rds_cong_map_updated()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178759861538.3069565.16016431579626517202.git-patchwork-notify@kernel.org>
Date: Mon, 24 Aug 2026 19:10:15 +0000
References: <20260822052647.88318-1-achender@kernel.org>
In-Reply-To: <20260822052647.88318-1-achender@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, jhubbard@nvidia.com,
 woni9911@gmail.com, michal.kubiak@intel.com, leon@kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 21 Aug 2026 22:26:47 -0700 you wrote:
> rds_cong_map_updated() runs after a peer's congestion map has been
> rewritten (by rds_tcp_cong_recv() and rds_ib_cong_recv(), or the
> clear-all in the loopback and IB send-completion paths).  It bumps
> rds_cong_generation and then checks waitqueue_active() on
> map->m_waitq and on rds_poll_waitq to decide whether anyone needs
> waking.  atomic_inc() carries no ordering and waitqueue_active() is a
> plain load, so nothing orders the map and generation stores before
> the wait queue reads.  The waiters do the mirror image: rds_cong_wait()
> adds itself to m_waitq and then tests the port bit, and rds_poll()
> registers on rds_poll_waitq and then reads the generation.  That is
> the store-buffering pattern described above waitqueue_active() in
> include/linux/wait.h - the updater can observe an empty wait queue
> while the waiter still observes the port as congested, and no wake-up
> is issued.
> 
> [...]

Here is the summary with links:
  - [net] net/rds: use wq_has_sleeper() in rds_cong_map_updated()
    https://git.kernel.org/netdev/net/c/d4f484661961

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


