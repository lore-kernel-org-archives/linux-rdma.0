Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1C33A6EEC;
	Thu,  6 Aug 2026 01:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785978057; cv=none; b=YW5xCGnCf46fzdUKfi8hV4F7I8rmy2zh0Qp8hJNN3DADLAKUz5jpEVzZeQ7oL5KTwz9ZGxTtv7TL4F9xwyrqzmb5TGxiQ7y0RpsXLmR/7MjiCz3+9f1rG58gz4wTzYc8ezBEpTaYvnVT/xtwuzOzSBXm/bmtfppU5iETBhp+B3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785978057; c=relaxed/simple;
	bh=4woX4+9dkyjM9UVwzF9fExMebNxWYe2D2EtkbdADTYw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=QG4CLxzGkCqHktIn6KCkmL/SeD0nBmZhfY2RuFlc6D432f8PHqaX2l/rFdh5AjakEPH0k/rrWQp8Ky9vRio3xpAoXngiq7HXPNkIwI8UGU/VzEW+yyu4kmJ4KyNaNl3HnZVgckZfeo9cqa9IVxIXrU7OXSEisUbb/ifQiKPBDpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VZLi5oMk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VZLi5oMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAE31F00A3A;
	Thu,  6 Aug 2026 01:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785978053;
	bh=Tu+zp+ckYDn7HvDWM+yhl6MoyFNKTT/ZAPb6SzIxetg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=VZLi5oMkqyg5wmN8QHc5RNRg+PL2f+M4Vk+eDSRBPUg+AKk8GmE16UnyLWKQgayzA
	 KL8KCQx3fL5pE1pl63xLRWB8Hr0ZTQWPAg513HAzTgAm/+jOvNqUC5bUQ5Vj2QdgUo
	 O5bikHBm8ZLEALJTxhnkikJRFS8ys5ET5aZj1QU3M1+L+v/dBNHae0VDo1ypwxdTK7
	 KBMBEnrz+5856SHg8Yu3RTsW7jcPzQG3cYB/IFknY2SGkA1WF48WnqZv1yNXTR1QTv
	 ApigI/Vj3LdeRJMvWYGThGijQ5NyNC71jq5+c3t/beLuHFWXO4MI/4tby3WpkMEOFB
	 6nX1s81TwazEQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A59392FFED;
	Thu,  6 Aug 2026 01:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4] rds: synchronize info callbacks with module
 unload
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178597801313.587098.5601309790539637183.git-patchwork-notify@kernel.org>
Date: Thu, 06 Aug 2026 01:00:13 +0000
References: <20260801054234.3535077-1-nicoyip.dev@gmail.com>
In-Reply-To: <20260801054234.3535077-1-nicoyip.dev@gmail.com>
To: Chengfeng Ye <nicoyip.dev@gmail.com>
Cc: achender@kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 santosh.shilimkar@oracle.com, ka-cheong.poon@oracle.com, error27@gmail.com,
 netdev@vger.kernel.org, kuniyu@google.com, linux-rdma@vger.kernel.org,
 rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  1 Aug 2026 13:42:34 +0800 you wrote:
> rds_info_getsockopt() reads a callback from rds_info_funcs and invokes it
> without protecting the callback's lifetime.  Transport modules register
> functions stored in this array.  For example, rds_tcp.ko registers
> rds_tcp_tc_info() for RDS_INFO_TCP_SOCKETS.
> 
> This permits the following interleaving:
> 
> [...]

Here is the summary with links:
  - [net-next,v4] rds: synchronize info callbacks with module unload
    https://git.kernel.org/netdev/net-next/c/2bb824660ef8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


