Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793516656;
	b=J7g4SLNTLMyCX2cOkHP+g/Iwosn9+LraxyPT2Z3QNTLBUHtMPW/ZZBRfv9fOIsjYJiqj
	 fYfGDLT/avFseiCXuvEDjQsmTJiB3Br1qPCWiLEz+D16NwuElV+Ff2OxNwhkkrelwk5Ss
	 yaYKkfQtDPnxO503xyHxsSAW4IKer6fzCEOKV7UScrovuiR9RkaV76zJKnV+se7+LOKwm
	 nFgMkP42yM9boer42IX5jmTwXjEdVpe+vjms0f9OaMNcedyg/lnvhRYGRJJODKuz6XUBE
	 hY5mECHQXE1Nxbt+jgbendz/wxWQ6GsQggjg3TBokgxAX9Wqi3swzs1GChwgIWhmd9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793516656;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=QHoyp28TlNhklwGqim9yBS4drJHpMYig9famUTvwi9pSFRHCjbOJ9VB49y8xvrVuNRap
	 vzjYlEZc4NHpCx/RgYeBeXKnDzLshs2D1hZ3B+HoEKUKMsVkFNQOnYFuPqt1T4IgabGg4
	 NkY1RmJU4m8KroSkPCiNFACU62+xhPqnAgikh331Yi31bJW+U5bos+yNz+ALcb51Re1fC
	 lzg2TVS29vYn4IphYntswQdKWw0itdlQzvb837pZ45Fpq+OCXHtWgx3wE+//Qkz35xeXD
	 wxUvnUGHIa6wxlecRT5LNCcNLhg2q8g6+LUeaxlQRDI2TocNopEaScV4vguh8kiWKQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ouSGbOFs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AF1606A330;
	Sun,  1 Nov 2026 07:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ouSGbOFs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E781F00A18;
	Sun,  1 Nov 2026 07:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793516656;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ouSGbOFsXJ6vwZQ0tUopzz5TnGyxCL7cOO7PIPCSZ7yM3ZgNeJhZ39x7mg0+vAmac
	 JZHfnInxpINS/dJ8hgh/g6wrsUpPxm+7ktAYhQXMvCyNq1DkcxzLlzI14bWlD/kIAt
	 nkCcZyuyXb+HtPxpnCJ4GNzZvayH+tZ40K75cXJaISnrzcVsMkZpGEnYU6iXrvIhwk
	 fwUVpGKuIBovPeCQecwq6nr3Oq3ea5n6BEChiBc8eqbP6pmUWNkKhIhdrRzPZg9mS3
	 CLitjfQ1EhV/KmYzH3PfDp/5xrAN4/0Wi86e1oJBYaBWItT5vdJxKLpLO9FTn2S/U2
	 UzfrDned3wZkA==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Maher Sanalla <msanalla@nvidia.com>,
 Maor Gottlieb <maorg@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net] net/mlx5e: Add missing Ethernet multicast octets to
 vport_rx_bytes sum
Date: Sun, 01 Nov 2026 07:04:14 +0000
Message-ID: <179351665490.3286.7144844476208891525@kernel.org>
In-Reply-To: <20261101065833.282261-1-tariqt@nvidia.com>
References: <20261101065833.282261-1-tariqt@nvidia.com>
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
