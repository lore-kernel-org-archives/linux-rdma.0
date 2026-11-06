Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794005407;
	b=QZTsDZBezTj7gIQmo2c4T0sWRUOTTPuPz1Lc8pOClHp8y6+CRpDhJLMm9RyrjYPevOEH
	 fc+ht8gEhjkYa+7AXBsd00zrUXeWIlRyYTJhuQhWKo0nObtrC7gv9ENr/Rl6L7WlAtPeS
	 NsNjxxDIULZub+JtbZ8LaDp0l3xM4mCTa7aaAVrh/F05dbkseMXdD80/oIkXyougbsPyi
	 zhr7p4SqeZNAikjYHXj8/9s6HHIAxslPVqrcuyp3ZI0kSYs1RpND5NZOQqXfT203T8jPC
	 N/spO/0gngc0w4UnuFbOoaQU4eOXOgILgM8kti9S5Oc2zJwZpSeLTswoGsoSiyzxnhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794005407;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=RvJV1lsFFGNksUmAriwUcLx3k0PDWhwKYnfgsF2S6A4=;
	b=zsfAcCtl4WSd/3cT8ltxky7OWoO5eKAt7syQK+8ByeQW0w/tDXP3YWiKwkJvt842HkvE
	 JNi0p00VFaTIvkIVj1fO49ooFcN/rHEBEQ74a29NEvXf6xbSWgfmB5Lby3G8SbhI19A0m
	 KI1AldgxM7xjfN/WFhJ6z8Uc6jCklz6VXZMmNzg0ZOyJ8TUNqAjrQGMzdzi57W/JfgEua
	 t4X6a8KAjszVjJJhjlxptb4wlxBglwSQraj5i66fHSTWZW+x5owpXdDkAWRtEeBgkaWqV
	 Y382+67U8wt0RzA3cGE05fbNs3XqJb2ZHXrCNMfWIlC+d1ExiY3sob1yOjah066dV9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aoBpOr1S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BD4606A326;
	Fri,  6 Nov 2026 22:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aoBpOr1S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A684D1F008A3;
	Fri,  6 Nov 2026 22:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794005406;
	bh=RvJV1lsFFGNksUmAriwUcLx3k0PDWhwKYnfgsF2S6A4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=aoBpOr1S+c/CS1oP1P83KpdMWngknrtfcSsIVpUp1oM3p27hHLgehax1avtbY+xNe
	 cOIW+RSeqLjUvA0qmE09XUe+5aNjdKepxKQg+ArJH/mEaBlDkRsMqw5iZZzXLL1tiD
	 wyhetpSsT57NhKyQgwTWZVuWhyd+lE/1dNbuYFgfbwR/Q63SyJK8xnJi4cXFaTmqd4
	 l8wzNwJOPwTiWLuTzpaHyGPlPvqNwJGXJoobYGSvXzhm+tpA6cML58AtBU1awJKi/P
	 hP8hE3jjNTkfVth8a0HaxVSL8ljDkQb7TuDPc0i9Qo1vdR5rDxe2EwoOrJ0d0eWfH4
	 5b6aazax3UACg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9B1003A55EC2;
	Fri,  6 Nov 2026 22:50:06 +0000 (UTC)
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
Subject: Re: [PATCH net] net/mlx5e: Add missing Ethernet multicast octets to
 vport_rx_bytes sum
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179400540543.914342.5527714455114430455.git-patchwork-notify@kernel.org>
Date: Fri, 06 Nov 2026 22:50:05 +0000
References: <20261101065833.282261-1-tariqt@nvidia.com>
In-Reply-To: <20261101065833.282261-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, gal@nvidia.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 msanalla@nvidia.com, maorg@nvidia.com, mbloch@nvidia.com,
 ohartoov@nvidia.com, saeedm@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 1 Nov 2026 08:58:33 +0200 you wrote:
> From: Or Har-Toov <ohartoov@nvidia.com>
> 
> mlx5e_rep_update_hw_counters() adds transmitted_eth_multicast.packets
> to vport_rx_packets but does not add transmitted_eth_multicast.octets
> to vport_rx_bytes. As a result, Ethernet multicast sent by a VF/SF is
> counted in its representor's rx_packets but not in rx_bytes.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: Add missing Ethernet multicast octets to vport_rx_bytes sum
    https://git.kernel.org/netdev/net/c/9c1adbe7fa6c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


