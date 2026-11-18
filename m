Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794967216;
	b=AALHrR0VYrByifHZEaUi6GJLLLTqLi5Q5dtJ/pKpB/wLfhu/sMgAXOYaOm2y2LLHmeqI
	 OJ/wx6xjJXJQBmzd+opgOWKYo1z9defIPRkFI2GTwEk6oJs+o6IAJ6veYjxvTiZiedU2w
	 zzOn0o87lVcQozmYHLAjJE+6cZCvaPTfXrfQiipkQTm1CkiAj/8Cb0XncipaJJWTcs93X
	 85JiPxb9zkfGb0T7YuxEj/FsBe3cWhg7fbQCIHnEc0t2uTrdNOh36u0P5auI1Zb2Pl69A
	 7ZI4bF5j76070fIOHptGNx9dl4Y+iXV8wUgDan7Jyf0d7WqSVmtaABP0wGb2fHGj6/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794967216;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=XCeULnaKjPm3J/sjpXZLgyBpE1CTaWW2dEFz9nnw2Xk=;
	b=usTeIQJIRy9vKVyBlkHnQI9rJioevnZz3HZpAw2dsIUoJZz/9ow5icO4nSbPky0NMHsw
	 x1n1o5+N5kBX+bj7nkFihppeAYc19wJo7HOoZys6Pv0Yn+ob5GCuXlc/AkTzrK0SzJsSe
	 1CnDiTYv6T8OceBv8JUapb7XGrCG5M7GledBNWU5c9ZUbUJJi9blnt3jh8s5wiNd796SD
	 +8Pyk3UXWO1STVRAQOLbW7graL8/TuYQhKq5wbujGEd8Me7isD+bW183w37AYVcFzhpUT
	 ljw8xiodndBsZ0xjyhFFM81VICvoRDvB+Vh+MyaMqRO/e+QEthThK3jSyIeLaZfxqYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FJhTZxlP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C97606A31C;
	Wed, 18 Nov 2026 02:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FJhTZxlP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2581F000C4;
	Wed, 18 Nov 2026 02:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794967216;
	bh=XCeULnaKjPm3J/sjpXZLgyBpE1CTaWW2dEFz9nnw2Xk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=FJhTZxlPAbuSUzyaKyS7yKcTuLCrFjDT+ltua8aNdPUDKN7dz2gsUZybWnzjUYG7y
	 GF9GEXUvVjxswSfNAShRWpM1NZVLbMMCuKjpxKOiqRpy/6BdY+rO9BQfKH5FUI39MH
	 zcPj4cUPcA3TPI2ACTgXgCuLY/t81/BzVllw8zyY/+yKvoOUe+THV+LXkREU5VYop1
	 9ypsieXrFYxkTOd4v4zo6XfkVyvjroBa3BVJkNyhuaG0elxlB6SEQuBN0LZ9tqAXYZ
	 sGixqK67a1sI/zsYFx94TemwYNiMxUOsWvyaAi8bhMvM9KPl0/zHn3dj5Y51BEXxEt
	 liMPsGaKOhldg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 772F2392B1FF;
	Wed, 18 Nov 2026 02:00:16 +0000 (UTC)
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
Subject: Re: [PATCH net-next v12 00/12] net/rds: make connection lifetime
 reference-counted
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179496721502.1405006.5342954579570038988.git-patchwork-notify@kernel.org>
Date: Wed, 18 Nov 2026 02:00:15 +0000
References: <20261113044355.2932029-1-achender@kernel.org>
In-Reply-To: <20261113044355.2932029-1-achender@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 12 Nov 2026 21:43:43 -0700 you wrote:
> Hi all,
> 
> This is v12 of the connection-lifetime set (v1 at [1], v2 at [2],
> v3 at [3], v4 at [6], v5 at [7], v6 at [8], v7 at [9], v8 at [10],
> v9 at [11], v10 at [13], v11 at [14]), following
> "net/rds: own the fastpath locks across connection teardown", which is
> in net-next.  It is targeted at net-next: although the series fixes
> real use-after-frees (one syzbot report and one report from Chengfeng
> Ye below), it does so by reworking connection lifetime rather than
> patching the individual crash sites, and that rework is too invasive
> for net.
> 
> [...]

Here is the summary with links:
  - [net-next,v12,01/12] net/rds: undo conn_alloc() the same way on every __rds_conn_create() exit
    https://git.kernel.org/netdev/net-next/c/5483e92733cb
  - [net-next,v12,02/12] net/rds: ib: refuse to attach a connection to a device being removed
    https://git.kernel.org/netdev/net-next/c/725ebc948965
  - [net-next,v12,03/12] net/rds: guard every work-requeueing site with rds_destroy_pending()
    https://git.kernel.org/netdev/net-next/c/306da594a7c3
  - [net-next,v12,04/12] net/rds: make rds_destroy_pending() report a connection's own destroy
    https://git.kernel.org/netdev/net-next/c/8e0bf84ecbdb
  - [net-next,v12,05/12] net/rds: split connection destroy into quiesce and kref-governed free
    https://git.kernel.org/netdev/net-next/c/cfa3110a44e3
  - [net-next,v12,06/12] net/rds: unlink transport nodes before a possibly deferred connection free
    https://git.kernel.org/netdev/net-next/c/9f000d125055
  - [net-next,v12,07/12] net/rds: wait for connections to be freed on transport unload
    https://git.kernel.org/netdev/net-next/c/32252168aff5
  - [net-next,v12,08/12] net/rds: hold a connection reference from struct rds_incoming
    https://git.kernel.org/netdev/net-next/c/217fac53504e
  - [net-next,v12,09/12] net/rds: take cp_lock to purge cp_send_queue in the quiesce
    https://git.kernel.org/netdev/net-next/c/d3c3a41fd3a3
  - [net-next,v12,10/12] net/rds: hold connection references in lookup, sockets and c_passive
    https://git.kernel.org/netdev/net-next/c/51ac0ecd2f81
  - [net-next,v12,11/12] net/rds: give cm_id->context a reference on its connection
    https://git.kernel.org/netdev/net-next/c/5b61d9aed8f6
  - [net-next,v12,12/12] net/rds: drop rds_conn_count in favor of t_conn_count
    https://git.kernel.org/netdev/net-next/c/e7a282d9858a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


