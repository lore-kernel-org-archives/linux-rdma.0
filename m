Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263DA416871;
	Thu, 24 Sep 2026 17:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790270482; cv=none; b=dnjhi4e6hfcMrqwY5tTNuiTh3wATMQWrmkKRRiiH+/9UKPt7srdTQRNNiL7DrY0cvl4gInN/WSZ18eAQaKnaBZAYVF+rMN1NJ8Pkc9NUXxgAfHcR/Id20FSOOb92dccT9w0fey2MNZ8F+5dqz9qW/Hy8tz2+/bp7SRsQkEqzDUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790270482; c=relaxed/simple;
	bh=SQl6WpnlTZn4/HGYPIS6UbZXWzXgzrBiw2nnb0NOLsc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=TqNTy/3q+6nZzHbt1761eoE1R8Lpb5Tujn+mWNg/6V3yytOmS4z7PRpvzjLKbJ7jpdFF3oM1tgR599KDWsVmazBQPAbEiEVs4HILVlY8CmgV0z9x0jqQXL+3jl5ewgb2o8j9vWyFS12xN50zOxOkvWvXj+HutWP00r84OcvD038=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jJUXwW59; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jJUXwW59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B1C1F000FF;
	Thu, 24 Sep 2026 17:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790270480;
	bh=Lc/cqGNmS5BAfBB3tohrhnS9GNdBOVMIbu4D35pwB8E=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=jJUXwW59X+wG0dJOShSuL44EWusq3vIg8ZRdVRXgcycKgZl6owT4tLRlk0IIPu7qH
	 0Hm02IiYIu7P20FYO4VwPSP/7DYgDRm3je2zIJuOYjHvVltzGiLmL42AC7zTIuv5+d
	 bAbWgVhOUTHcFiVIywvvMK4pSpQucHITUBiVaueXQ+AfAaYRc7QcmEHoJGik3W5Vgy
	 lOhhzaB5jfBL/SqdbG+AAo2vztVQQxESHcGCq5CEPhZjRkuW30UxwRaf+tL4GvkFbP
	 oXuZEhPAnwGEjwnbHhTy8TkjgufLdZfPn/Yz/mPelGQlX7vp2cR4JKgDaZkWL/XOJp
	 KiBn+NU4LP2uA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D09903A566D9;
	Thu, 24 Sep 2026 17:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/rds: size a connection's path set by the
 transport it
 ends up with
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179027040953.1664959.5709477689952932392.git-patchwork-notify@kernel.org>
Date: Thu, 24 Sep 2026 17:20:09 +0000
References: <20260921215027.174657-1-achender@kernel.org>
In-Reply-To: <20260921215027.174657-1-achender@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 21 Sep 2026 14:50:27 -0700 you wrote:
> __rds_conn_create() computes npaths from the caller's transport before
> it decides whether a connection to one of the host's own addresses is
> to be handled by the loopback transport instead.  That substitution is
> what an RDS/TCP socket sending to a local address gets, and after it
> the path init loop still runs for the TCP transport's RDS_MPATH_WORKERS
> paths and allocates an ordered workqueue for each, while
> rds_loop_conn_alloc() only ever provides transport data for path 0.
> 
> [...]

Here is the summary with links:
  - [net] net/rds: size a connection's path set by the transport it ends up with
    https://git.kernel.org/netdev/net/c/ba3d1f480c7a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


