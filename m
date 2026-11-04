Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793817825;
	b=NH4BayJYl3Agj3LHr0t5bYJXkqhTdxg++OzqXr1T39Ku5cjVE/ixuxjXxCj9YG6fG3W9
	 NM+YFLGV+nl9w33DfU+rTxXRM8AM0UtETkUf5+DFFRUSAaVMwl6zC95pkF3XLugwbohUy
	 hoQ+MuSLAJ44qUySkdcSQcS7ywVDi/VmBJnpSYr+s29uEqJQ0Hcky/k7/00rRyp6vfnyd
	 9tRNAuPKdK0tUseJPhiWOU/BdAKX4GFYaCQLGnt8HE5eWaAesFZWKWUfALWYrD/wDRDEf
	 vaMP1Gx2KcX2JRv4J4H8HFvuy4y3znNUGiKfWwGy2imqQcyqjx8esQZQ7BMrJ3rPvaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=P8UVkgKEKIT8I2zSRY0WaROV49xC5psel7DXfhXPuk2lmK9rwNnZcfrYbCkHSYqK+qli
	 m3tZW7brG1OtD++WAppnJJhRoHZIVbIUR3HC3pRM3i5DNojTU36vN6KMpaTI9xLI/nmvL
	 jipS01A5FH+niuCjRmcUTFqm4MzyWlGxuYQOBoNHjCs2HSZZAMDM1gPecKIsHeElENJZl
	 NgIVo784JyuAyl8COh2hKtmZIRerKJp2H9fy/u51I46Fb3Msn+ogNEAgQz0EuMQOYeB4j
	 gmEQkFOKPiCJxpZqjYAhhtJ/zFJLYsrp1HoTrUonyvxHeZdJoLD+D0uOjjGAlVEtiUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bPCQ0+Zf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB003606A335;
	Wed,  4 Nov 2026 18:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bPCQ0+Zf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836CC1F000C1;
	Wed,  4 Nov 2026 18:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793817824;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bPCQ0+Zf2M9u5krL4ca2bMpC+dcsRJuuq4x1QfAryryKjw36gimNN+0un5cfyJOp9
	 qCMBCwnwywhFR371qRD57+GZeaFviQare/RADKr3ID+AOAoCsKi8do+KyjcNhkFMl+
	 8ihEFO++am8InLS22W8QqF5/Bic9uKuqYc68v6EROxDIW9HQPlcv/yG44ys8+ZQuoW
	 X7B+3F9ix5YYbKQd1Ny77dR5tAHm8ErNsyYKU5CIdxU+OJZOXs1R3UE6D8sYWBpf/z
	 Lh4iEKv9LLvXKboIfqUPr3YTZQc70dI0644qekcxI3//1ClgsZgUi8ArEgtRsxuk/f
	 7TOhcuyJ6ACHw==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>
Subject: 
 Re: [PATCH net] net/mlx5: Lag, free steering resources on LAG destroy failure
Date: Wed, 04 Nov 2026 18:43:42 +0000
Message-ID: <179381782296.488859.16541309313569380579@kernel.org>
In-Reply-To: <20261104183947.772195-1-tariqt@nvidia.com>
References: <20261104183947.772195-1-tariqt@nvidia.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
