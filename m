Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793959207;
	b=jaAQKr2OKGutwog3s9WOriZl+tPdv7a3LtDO3bv1yYH0lrau81Xi/nAf9Ivx1jt6dm64
	 oUS545QBvvvoQawNpv5aiQ/4H4ifOVb3qklVvDxxmCt3myqF7LQdUggG9OnGuZJm5DvS5
	 Ug9qGg0dcS3LOdykFHzPBbAH6HUcSzWUeAfAamUZx9FTn/P4wUxexFARxS4hGNSnRFMUt
	 DkBbBeNrru8CUpQGQJuYIwgcsPX/RTO6oOKUOvYygSPIVPvBgZbdw6lizJb7EeAEQlCmm
	 SDsXOY/+SP+ugxUVBu1RM8dhTfMiSsj6le+a9tg2VS7VvJixEePF/d/dDQIeVkiWZYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793959207;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=vow2vG/QGUSa3sk+BL7ipbjd78B1wl5dopE1viaxuxk=;
	b=C29qQ15iuGuCtC3wGrg5tPjnPrxFcpvac6CtnuvgUv7Yg7P0KnyhIZJU842hezVkORq1
	 FUuumEAQhRAC8k6pNqeYBt6SYcxhCcWap0it6IKtJluhwJD9gmpwXjzAtH6g5aHpEJP4F
	 5Z8MmBhGK4i1F2Y9Sz32dUC2e5lIHHSDhMV+/ZD77WXm0ut0lJuRdmee4RL3i37V9nVO/
	 5M+P1WBcSLh0FUv9RwnWGW75zI9UdMCl68ME79kGQxtQYVdsNTF4386mutaknsytU8W+p
	 4kjObGzOqdHsZX+mJp6tOV/5uTmpW5LdOwzS2twTc7wFDNGJ7b3kfXf5S7SU681WeKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C3y6yKXt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D274606A330;
	Fri,  6 Nov 2026 10:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C3y6yKXt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABFE51F008A6;
	Fri,  6 Nov 2026 10:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793959206;
	bh=vow2vG/QGUSa3sk+BL7ipbjd78B1wl5dopE1viaxuxk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=C3y6yKXttY1eJt3ps23frI/HFf3gHrtxrjSADU30An6bqmW2kBdWbvHFyo03zOCyu
	 +JyjjxVTEJgEQHAKjWexdHMzVkNMp47xBYyd0/BwtjGnFFlp2NsojgQTeyYxvf3jeW
	 xMbGXhlr9XduU0ZzQzfdGIKkBoeLiZURk+o3p2nAoJ24LGW+ngHh6B/Z442ENATnJX
	 9N7BPWMBO47v/Wbn1dw6S1DrLc9T/Hn4vdr+35IMp4+IGXj8lCkzOJABePO7c4CZve
	 xqDyq/I3MSh13A++3HUFinSW/H8zxnaCN8aeaONd1ph0abENDiAT1e6FxUFt7x0heB
	 0UNy3jXIanX2w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9B088392447D;
	Fri,  6 Nov 2026 10:00:06 +0000 (UTC)
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
Subject: Re: [PATCH net] net/mlx5e: TC, Fix double free of branch in failure
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179395920518.502049.12133598827190916497.git-patchwork-notify@kernel.org>
Date: Fri, 06 Nov 2026 10:00:05 +0000
References: <20261028145805.54595-3-fourier.thomas@gmail.com>
In-Reply-To: <20261028145805.54595-3-fourier.thomas@gmail.com>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, ozsh@nvidia.com, roid@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>:

On Wed, 28 Oct 2026 15:57:02 +0100 you wrote:
> When allocating the false branch fails in parse_branch_ctrl(), the
> already allocated true branch is freed but attr->branch_true is left
> pointing to it. The caller parse_tc_actions() fails the flow, and
> free_flow_post_acts(), mlx5_free_flow_attr_actions() which calls again
> free_branch_attr() on attr->branch_true.
> 
> Clear the pointer after freeing it.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: TC, Fix double free of branch in failure
    https://git.kernel.org/netdev/net/c/31f9b43a3bb3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


