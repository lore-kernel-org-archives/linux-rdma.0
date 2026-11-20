Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795141815;
	b=cxAv5xbw1LoPFfzq7AdwCFfEnUKIiGEFSZ8de+yi6ggrTC7zNmerTIbKJoGRopI9OZ91
	 7JZZ2sKxKAj5r9Laahhg/IlBD0whSl/EnCI49VmESgPDaBlniJW0ciHlUn3WP48YGqB76
	 Q/VpGxYmN03rVkf7BwfMWaQgVHxrmQfMsY+FoKnusUnU6iA7MgTdkl7xGuhN3c945TxIU
	 nBraoStiUPQlYV+vOyuIMMky9QUb/ATGFvXvFIv5AygJGg1ArJnd+VXdQKZb6zdPhHsoT
	 U7n+9P3fW8Zl175vEOwcvZbos5qufSGRbq1TV4myUN4m24Nw+PgmiGCFh/2QFt5HdqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795141815;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=Td+Vsqa3uWyWCc7Hm2r5ZpUErDn/P4Yv0JOR4vVhes8=;
	b=Lk/zb4rBh8873gaI3nz9cO2Z3gp1LlXKIX9g5xZj3N8ZagvrO4gYZz3DlePtVsqhEoNA
	 JgeGdGhob/TBcSUQC3WaftK1RhCR9zNt6i9sWvrpEbD44Y77yU4rsSW+qzcEw4HJqdAEW
	 9xj3RYhgh81m1FVmMC0uRAMgoDdRpXGoGTsYhlhtupqoBYABsYPx84kZnVKumCNDMzRMX
	 NWJV6+aZ6OnaohIZTdRetAqccos43p+A14reHCwxKxG2emn/o8U7kGUSlUqqwUv87OApL
	 n9gI2eQkE/FjqGjLYzeYq3lf5UXaDA7KhchmRC3+wTF5DEnYvgCL5mpa4w+rA521EVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CK+bpFFg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A3F606A331;
	Fri, 20 Nov 2026 02:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CK+bpFFg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8102E1F000C4;
	Fri, 20 Nov 2026 02:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795141814;
	bh=Td+Vsqa3uWyWCc7Hm2r5ZpUErDn/P4Yv0JOR4vVhes8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=CK+bpFFguijfJKmzZKcJNITnckMyDEzSzrTSBw1jlfKSSNwa+trNJzo89EE+CplPi
	 AsNdOW4Nn5y9ewhFEID49uhHkA/I0FLKWuIkpPF5HkXgDAPv9bgq/PfJl7v5wjOFr/
	 +UkrBfiO9YvkSg76RdN/Ef/XDEiUH+B7LPPpOeaKWzGc6c0Gczy3MwW3IZ2TPBcgvY
	 r0pStiIdEryiMhCkOo3ICb0LQss9pq8HdSvIrtw3en1kD/Ue9e/H2lnjBCKA+2aebb
	 od619LuSbfurt7sJHRCMZriS2BQV0Uj89xLr8sduLIC3VDV0scf/bxZCmWHo1GX/Kv
	 PgfVkGbE7ihww==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 773F23808209;
	Fri, 20 Nov 2026 02:30:14 +0000 (UTC)
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
Subject: Re: [PATCH net-next v2 0/5] net: annotate data-races around sysctl
 knobs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179514181302.3985754.10655105132001474225.git-patchwork-notify@kernel.org>
Date: Fri, 20 Nov 2026 02:30:13 +0000
References: <20261118045137.174026-1-jiayuan.chen@linux.dev>
In-Reply-To: <20261118045137.174026-1-jiayuan.chen@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: netdev@vger.kernel.org, dsahern@kernel.org, idosch@nvidia.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, matttbe@kernel.org, martineau@kernel.org,
 geliang@kernel.org, achender@kernel.org, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, mjambigi@linux.ibm.com,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
 linux-kernel@vger.kernel.org, mptcp@lists.linux.dev,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-s390@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 18 Nov 2026 12:51:15 +0800 you wrote:
> This series annotates data races around a few sysctl knobs under net/.
> They are read without any lock while their handlers update them with
> WRITE_ONCE(), so add READ_ONCE() to the readers, and WRITE_ONCE() to the
> handlers and netlink paths that store to the same fields with plain
> writes.
> 
> There are no Fixes tags. Done one knob per patch this would be well over
> a hundred commits, so I grouped them by subsystem and feature instead to
> keep the review manageable. If maintainers prefer, I can split it up
> further with a Fixes tag on each one, as several smaller series.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/5] inet: frags: annotate data-races around fqdir->timeout and fqdir->max_dist
    https://git.kernel.org/netdev/net-next/c/871c4d55bcc2
  - [net-next,v2,2/5] ipv6: annotate data-races around icmpv6 reply sysctls
    https://git.kernel.org/netdev/net-next/c/74a8695588fd
  - [net-next,v2,3/5] mptcp: annotate data-races around pernet sysctls
    https://git.kernel.org/netdev/net-next/c/9b01b1ed4b27
  - [net-next,v2,4/5] rds: annotate data-races around core rds sysctls
    https://git.kernel.org/netdev/net-next/c/89452de7ed3d
  - [net-next,v2,5/5] net/smc: annotate data-races around smc sysctls
    https://git.kernel.org/netdev/net-next/c/88c1e8ba3024

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


