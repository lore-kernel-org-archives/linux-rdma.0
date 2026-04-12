Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02BC239E76;
	Sun, 12 Apr 2026 20:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776027037; cv=none; b=q+W7odHu7jtSNc13iV8Zef1dfghmDhVsMX/BDoqRcwiYHBIwE24ZRVGkQf7HlQyGiFD3LwefV2xFfiGyMuf77rmMShtXmiGTJ+7WLtdM2QafjJ0xG8xukOPCERIroYOpdrd0Z1rrB1R6fFTgWNDhn0JDctn/UCEzighS4/FBzug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776027037; c=relaxed/simple;
	bh=6Z6UNS2ebQrH305yaq3CKGzqIvM0rJkgbl+imUkZLUc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=EeaeMwWZ1ksVv9PFnzoj0DcjvHrlYFmVbZcY0fARz8Ref5j34hW7+jXjzTePVPjWmpB5sUZdpPRdonpmWLYVPBdTUii5ctN1xCqD+616vdXVsBg0Mg+qoFssFNVBBMP9wTocYj1YeakdywJLnJc9b/jssb3pU4Y44vhglo3lVK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=acMQAq1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="acMQAq1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715D7C19424;
	Sun, 12 Apr 2026 20:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776027037;
	bh=6Z6UNS2ebQrH305yaq3CKGzqIvM0rJkgbl+imUkZLUc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=acMQAq1KL8Dv5JOmUq2KjdP+9o9oI8cFjvpDhpPs87R1psEPGZAZIFQPWWaGed0we
	 nLnivfx8ABiN0q88Nwaixm8XQXEnzf181ctTvOIpDtRcHcVmRravQUoy1W3ENAtPe9
	 LyAaO8YKoaYl6VfF7nqOMw1khL8KpfXJVcc9e8oY6QXcnJVOcFELLSE6RC/uphgMKc
	 SxeyatNnn8D/TzZw93VoNA4VHgLhWe8z+bgESgkMRysrwq3U25VA+7pmBMTVxsvZmw
	 Tth9riIxS+qGB/PPqvbX1M0a0eewq7Y68dB8b9ARtSze7Elv//FFZTUo4TeF9LuZx2
	 5u/4fklhRoweg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02BDA3809A8C;
	Sun, 12 Apr 2026 20:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] net/rds: Fix use-after-free in RDS/IB for
 non-init
 namespaces
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177602700979.3405581.15178712327198304598.git-patchwork-notify@kernel.org>
Date: Sun, 12 Apr 2026 20:50:09 +0000
References: <20260408080420.540032-1-achender@kernel.org>
In-Reply-To: <20260408080420.540032-1-achender@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 rds-devel@oss.oracle.com, kuba@kernel.org, horms@kernel.org,
 linux-rdma@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Apr 2026 01:04:18 -0700 you wrote:
> This series fixes syzbot bug da8e060735ae02c8f3d1
> https://syzkaller.appspot.com/bug?extid=da8e060735ae02c8f3d1
> 
> The report finds a use-after-free bug where ib connections access an
> invalid network namespace after it has been freed.  The stack is:
> 
>     rds_rdma_cm_event_handler_cmn
>       rds_conn_path_drop
>         rds_destroy_pending
>           check_net()  <-- use-after-free
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] net/rds: Optimize rds_ib_laddr_check
    https://git.kernel.org/netdev/net/c/236f718ac885
  - [net,v2,2/2] net/rds: Restrict use of RDS/IB to the initial network namespace
    https://git.kernel.org/netdev/net/c/ebf71dd4aff4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


