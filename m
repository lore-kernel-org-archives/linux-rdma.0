Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023426;
	b=PgjBFjQ8R4ti1hWw6kRCXf+1bo2X2dgQ3kOoOz2FB86k9ImziGJWlSzrrnMqmy4Hn5za
	 JQZex2Jc8y1LCfW/a2E5t9w5wnh0397a6NXJ70MQkopEw6gkZMEbGgF5CX5USIvNl4GYS
	 MPSRhO7Bv2tVjM10SKtpv4RT2+JtFOdHEY+rOAga8dJ3QkhtFg7dwCr9hvtVPB3iBiNIS
	 dOi+KM2ErLtBBZ0bxFP2SHmLBVrG48ZlbrgsI958ntH5UgGg4VOCGrN0FI78Kk1rHUKfW
	 01VhSjZrFTr0Oso4pegmay4qOC80zy6yOzI+L4O8kdHRIft8ZyM1R7DRrpJSbjaapug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Uwqp7Bz8a5D3/B2xkBHbhP2Bh4hQYQFs0RxyAqY1Gn8=;
	b=QXdiX5vBpiyo0JOg4UTjpGvH+Qm8qGQofcAxTVU5vTCHMDNbBGMjfrZvK4KWFy4m4cuD
	 hgVGUJmKIJxPYK499t+F/9XPMn3PWHTIcbvsYWKWLKdQHTFF4vMGushVxGdp/k4fEKtZx
	 Uo+IR3Za4slGBE3TbXT+mQZZchoNZlf3UI7NalfFuhaaQe6ChYhM1fLn/W8wpuVZ7/fba
	 WSAshZrquoAwZKacf92NumCXZwh7dv+75vDPb3WkYBJ6Z9JnqJJfsEEwzCgiEdv2UsdXF
	 67/L+aqWBGUXcCDDeYN3NvcMQ8WcgX2axn3glv/4NU1kaGE4TTOau0Q1/LYme/lJ7yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GUi1vQRX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF86606A33B;
	Wed, 18 Nov 2026 17:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GUi1vQRX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D001F000C4;
	Wed, 18 Nov 2026 17:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795023426;
	bh=Uwqp7Bz8a5D3/B2xkBHbhP2Bh4hQYQFs0RxyAqY1Gn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GUi1vQRXRiwRHiofp0wZWns3oBZPdpG0dwxu+MIwGFyhqyoEJp6GV/zo6EDgwFXYC
	 q3C1Ra7Hj/pHqBAslJTTEDLdsUixh1i24VFVLtgK2rfP1OSWgDGMfRtHqaGVjhh0uB
	 ZO35dQ8qJgqLLyNGJQqDSNnQh7Yny75fVEgs5n0/Zt4uM78kGgxCJEK03vhWVrZ89E
	 VB3OB7CT3++am3pOwVdwdkNMyIdQ0yu2p4mU8XdMefhi/N8LuPaN9gy9GkIwEYnE+K
	 s+LZrPgvOhNt0B2rI6HmuoW8Cg5IkwAdh0eta/rEAa/0NTWF6cxkTGI2nijYfnTkE0
	 hbHIC4Z0HQZPw==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Alexandre Cassen <acassen@corp.free.fr>,
 Alex Vesker <valex@nvidia.com>, Erez Shitrit <erezsh@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Kees Cook <kees+treewide@kernel.org>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Moshe Shemesh <moshe@nvidia.com>,
 Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>,
 William Theesfeld <william@theesfeld.net>,
 Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: 
 Re: [PATCH net V2 0/2] net/mlx5: Fix HWS and DR steering memory safety bugs
Date: Wed, 18 Nov 2026 17:37:04 +0000
Message-ID: <179502342456.3291.16504409032311811352@kernel.org>
In-Reply-To: <20261118173227.1957670-1-tariqt@nvidia.com>
References: <20261118173227.1957670-1-tariqt@nvidia.com>
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

 - What hardware the change was tested on. For driver fixes please
   mention the device (and if relevant firmware version) used for
   testing, or say that the change was not tested on real hardware.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account.

*IMPORTANT*: If you do repost (for other reasons) - please include
the relevant info in the cover letter or commit messages.
-- 
The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
