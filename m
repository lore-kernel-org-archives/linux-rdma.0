Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60758342C8C;
	Thu, 19 Feb 2026 15:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771513817; cv=none; b=ZFEunqb46mINH5CW0vAHgK3yhW+ShFF0r6ZIxZM9/i6+hW/EGsko/54yExuA02M/EsyuwSNSM+/cfk/X74eDlYaOmydJB0A1y+xSLNl4eTOUk+y4/HPeNAXGfpcozbPGlJxpWfs0khNGLLvzKK4VrTwqdNXWhw0iUpneCtRMlFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771513817; c=relaxed/simple;
	bh=gCXPjl4Q083bZmtzwYrwYlYwH9dpfuKhtmHUAdA8akw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=E4AQ19BKK2y1vHyYBQPodu1YVe/+pnL9cSyNd+hFgxFf4kJDea39AM0V/Lj4x2L3w7S93te3HYKNa10CNYikEkZRskAJ+XGW17FMqhKbaYUn8Ovify3v9pwdnfeatghSZMs6WuqiLfynvhVY8hl5+5rd5qXX4S/yxBew4a9VJBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nR4rizrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nR4rizrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8E5C4CEF7;
	Thu, 19 Feb 2026 15:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771513817;
	bh=gCXPjl4Q083bZmtzwYrwYlYwH9dpfuKhtmHUAdA8akw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=nR4rizrNvdAyWqeJJg5qzTAoCYsM92OBfYBnay+vtfTRNjv3JmqQ8VM24m/vyD4Ow
	 CPD3Dh2kwCI3gJ9ADpNrgrYX1TTTW2hWXXZxEKMQk7adM4JOneytDvHMvv6IWP5zLc
	 cfDduMMXsYpF0jOD9zxslXMtbO8Igz9AGRXQN0dvvZAKlMbHMWEitpOqSC8MLP8LWI
	 7+DXI2usAH1pOiMdEgBXdnhU3GkpgMVPxQM5a8uSmcqOVpxHszG2rpbdu+mbhTOW45
	 4Y0uv35AuoB8JwG1nHDsgU4EW/iVo4Zz7bZJ1O/2JZEegd3TlT3v6qhpkoPU6lSBCi
	 HXSbMstP9yIFA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 480B2380CEF3;
	Thu, 19 Feb 2026 15:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] rds: tcp: fix uninit-value in __inet_bind
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177151380807.2260009.1744602698417176136.git-patchwork-notify@kernel.org>
Date: Thu, 19 Feb 2026 15:10:08 +0000
References: <20260217135350.33641-1-tabreztalks@gmail.com>
In-Reply-To: <20260217135350.33641-1-tabreztalks@gmail.com>
To: Tabrez Ahmed <tabreztalks@gmail.com>
Cc: allison.henderson@oracle.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, gerd.rausch@oracle.com,
 charmitro@posteo.net, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+aae646f09192f72a68dc@syzkaller.appspotmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 17 Feb 2026 19:23:49 +0530 you wrote:
> KMSAN reported an uninit-value access in __inet_bind() when binding
> an RDS TCP socket.
> 
> The uninitialized memory originates from rds_tcp_conn_alloc(),
> which uses kmem_cache_alloc() to allocate the rds_tcp_connection structure.
> 
> Specifically, the field 't_client_port_group' is incremented in
> rds_tcp_conn_path_connect() without being initialized first:
> 
> [...]

Here is the summary with links:
  - [net,v2] rds: tcp: fix uninit-value in __inet_bind
    https://git.kernel.org/netdev/net/c/7b821da55b3f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


