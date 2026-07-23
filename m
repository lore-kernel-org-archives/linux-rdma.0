Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312BC31AAAF;
	Thu, 23 Jul 2026 16:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784823651; cv=none; b=GgXQvP4fFRLEI7Y16ywvms9/Dw5Ea4lXA3sh7P3eSLK2A2lRtLYUnCVr6KE3/0big9B4nBiQXkSz8ubM5avssFIP6qesfUWnfs1flnpSzi3uEkyUQC/AlOc4PMRQQiliemEn+3NXYDAZk0O1VSot9ySaiUF4PjIZyG3qIK6k86M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784823651; c=relaxed/simple;
	bh=k9aorv6dV2haJpSIKyyS1eYvQb6XbrFrHK5NsMJaY9s=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=sUgCvVKKyYz6zh46SCnbfHhPP4xMQm4DLFeO9BL6uNVjSJNMS4I2dRTMARqNjmz/8X/TTgFOjdPWEW0ppAYSXdq/h6pwIRK8VFgIgtXUArwzYHnJJkZdKgQh7g4Ud7wWndpY8/9RK5InJo1mdhNTyVuwIlrVWUspVOntzx8gx4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WC/1pW0E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WC/1pW0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE6A1F000E9;
	Thu, 23 Jul 2026 16:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784823642;
	bh=XkjpYQMMFl6vr7hDYTyRqzqMtX7dEx23rp5elTGIefc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=WC/1pW0E1o0RYP2uMoOD/S4PYmN3C0mzNA8q1t4yUlBVop7IbOEOt9hiivrrOs0/t
	 PrTk7VRS1a1VZaZYBzilKJTVBw12DFIC8VS2sK5nPrg8E9zR6gCMCUVhs9YPiXYxd8
	 8QlMDxEeRXwTaFlPTg3+bJN8pemY3HO6v7JPsE+qHCvlUPYtCNxyxEPizSl2Fzdd5S
	 wmPr8onA/ap0cDMlU9lD+CIJ+vK7B9cLlOTLEg4GlcBFoeVrT/Lj0JWIKY1Rw17mm2
	 Tg8zPJd75biK+KplDz+kSt+J0lVbTOaOgWJufpOQPDtuMaDZIEY82H4YcTrIcep3mx
	 TbISgwfNTKB9Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 569CB3924478;
	Thu, 23 Jul 2026 16:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] rds: tcp: unregister sysctl before tearing down
 listen
 socket
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178482361015.2769750.11692897293921872988.git-patchwork-notify@kernel.org>
Date: Thu, 23 Jul 2026 16:20:10 +0000
References: <20260719210357.10179-1-blbllhy@gmail.com>
In-Reply-To: <20260719210357.10179-1-blbllhy@gmail.com>
To: Cen Zhang <blbllhy@gmail.com>
Cc: achender@kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org, AutonomousCodeSecurity@microsoft.com,
 tgopinath@linux.microsoft.com, kys@microsoft.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 19 Jul 2026 17:03:57 -0400 you wrote:
> rds_tcp_exit_net() frees the per-netns RDS TCP listen socket via
> rds_tcp_kill_sock() before unregistering the per-netns sysctl table.  Since
> rds_tcp_skbuf_handler() derives the netns from
> rtn->rds_tcp_listen_sock->sk, a concurrent sysctl write can race with
> netns teardown and dereference the freed socket/sk.
> 
> KASAN reports the race as:
> 
> [...]

Here is the summary with links:
  - [net,v2] rds: tcp: unregister sysctl before tearing down listen socket
    https://git.kernel.org/netdev/net/c/167e54c703cc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


