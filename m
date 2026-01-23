Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE4E2D0C9D;
	Fri, 23 Jan 2026 21:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769203220; cv=none; b=NO2uvk8qJF2fcGsoV2lCkJIJc06csX+3wtDU8C8FQtYNxyV7gS+dFi+JdEYE2u6U0euujAJmwF3Sn7xVKEtxj3qwtditeUxMP1NlEOcYvgvIgOGvPbuGy6swi/7wOAsfW3H2XWNT3K5Ct6h0Ji76JPnzMgIt79KWmFTofmM+xjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769203220; c=relaxed/simple;
	bh=isTighoWKow4JJBrOzp/J3FQ7at5VDfiyw5ADB+Qiww=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ldBthHEOJLMNeYXp/0UkzAzAdzGCpA98skSteHYe5vTTKuqK/OOpiBe80O1F/apBHNFl8lCYOZKr1t5VxuF79I4HO96cLRrthMMkJjIplAubm4oRfVkDLlBqf+ZyQCJjjbTMpSy7TJOw5cZjq1iEngc03xCTOH8DolHG/J8VYlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fu2uuTJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fu2uuTJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0316CC4CEF1;
	Fri, 23 Jan 2026 21:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769203220;
	bh=isTighoWKow4JJBrOzp/J3FQ7at5VDfiyw5ADB+Qiww=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=fu2uuTJRCKJlfbxNA9+ro5oaSc5tyVsw1gkcuo9sMo1LXmih4aUzSI8kjuDBlY/US
	 xHEzfhbdaZincxyFKomWMXn/SAWmAF4zAm7Y+q7S4eeOxAf9lm4bk+9YAaWx6jaAzE
	 89Rp0iW2hj0DNj1m5R/ID/eDN7vFlCFRvs01SiwmM/UvOJSy0ON27XD1eMwmtGMctR
	 Pj6SZsNdx0pcDgaLNE/Wxo+gLRk453+t/l5713reVL+p8eOV7dIqArDr2LozxkLoKV
	 YXwCrXbb0IhSsdm31G6pHt02meyqd871YIOZV7WN1WIx7pNsPTI12VaqC1ypOrJ+pD
	 Z06dujWBbHH8g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 118A53808200;
	Fri, 23 Jan 2026 21:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] net/rds: RDS-TCP state machine and
 message
 loss improvements
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176920321584.2718299.3881561780744022977.git-patchwork-notify@kernel.org>
Date: Fri, 23 Jan 2026 21:20:15 +0000
References: <20260122055213.83608-1-achender@kernel.org>
In-Reply-To: <20260122055213.83608-1-achender@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
 pabeni@redhat.com, edumazet@google.com, rds-devel@oss.oracle.com,
 kuba@kernel.org, horms@kernel.org, linux-rdma@vger.kernel.org,
 allison.henderson@oracle.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 21 Jan 2026 22:52:11 -0700 you wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> Hi all,
> 
> This is subset 2 of the larger RDS-TCP patch series I posted last
> Oct.  The greater series aims to correct multiple rds-tcp issues that
> can cause dropped or out of sequence messages.  I've broken it down into
> smaller sets to make reviews more manageable.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net/rds: No shortcut out of RDS_CONN_ERROR
    https://git.kernel.org/netdev/net-next/c/ad22d24be635
  - [net-next,v2,2/2] net/rds: rds_tcp_accept_one ought to not discard messages
    https://git.kernel.org/netdev/net-next/c/db69e9b838c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


