Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792564421;
	b=hN3Z5I91K3YfaBxHvTmVLhf5TEhKjLERZgOcbZnvPO+bHcR9v0XA8yY2n4X+nHaL716r
	 8LIYo+CAeFbZXT8eeC5H937XMRH/T6s6H1kHDC136nlz51vDnI9AIzbQIiioZhUw20Epn
	 TcjIqfHFEqW/wJWRmNCiYCCpdKajPXIBbVVCwNg2xRnH8g79oKy4m8ry7FtxccSnrxlYM
	 5i+knDrk4+3+ybo94EBC65lY6Y61rrm9fGcVFGKLRgwLVP7yucSOCvMBcHymbUfjrP+mC
	 MFPtuGrgMM+ChDXuqxZZm7GSirVwDqWmC9a7j0sofL0m3i+nFukD6VzqI3MCo8HWq9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792564421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=gPh8nTkwbYVZNk/ptzGsoNEQbfcEI7z4o+KzYRNqwicIajzKqSFW/BaTTuJwE4aXUvER
	 rrJl8yBdlcXPLyE1WkY1Pp2Bx1YxnHd1vjw5BPJXD9X4259VbCANHhyNsFaZBzEMT7NQK
	 spT+1w63wF+PpDPkfyPOgo/3HKY5K1KCn3aGtnpI4vveNg3kX7p15Y58XC0ocP42/B1Od
	 7/McVmpw1ZLW0ZJ/hLBEiUzGWS93AdPZRuQd90gNOuZYetccPvqd3HcFFBmqjEFGB0u+1
	 ngY3w6BspZh5twP/RVV6wJ9TaqHsJkMga68R/pS+UA/rwLUYU7rDxokpL446gb4oMgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nICia3SX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE525606A322;
	Wed, 21 Oct 2026 06:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nICia3SX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670A11F000CD;
	Wed, 21 Oct 2026 06:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792564420;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nICia3SXTL71H9FiOSBdgjgYRDQB84m4+NEdPerzZ2/GYPOqhYGHBIbMJxtBAiaHd
	 cnbfiDkbq0I/v2ffJe3wEAkX+cXKqIhopT0whEHh5mXYbRr/wMvWY+zE+pFVs2AOLl
	 eoMXvhpMVoEs3SB0xK4IPDjXsZWK4V/SPG0gNFVXLGUyG0gkRzUzLZ5uuz/crr9sUl
	 cvOXdt/9NMryRosFDIN/fFrsmPXnhegLm26DWvrlL16pYmp/BkALZQNqfzttdRZhZA
	 vws+mmQbSDD/OIb0GaH6wqsAznxH9IwSATwvcf0xBSTTjdalKwq3aTPvrGAOhbsDCU
	 2l4bCqxEXU18g==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Boris Pismenny <borisp@nvidia.com>,
 Cosmin Ratiu <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>,
 Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net V2] net/mlx5e: SHAMPO: Do not merge PSP packets
Date: Wed, 21 Oct 2026 06:33:38 +0000
Message-ID: <179256441889.3290.18335317676458309584@kernel.org>
In-Reply-To: <20261021062805.3466208-1-tariqt@nvidia.com>
References: <20261021062805.3466208-1-tariqt@nvidia.com>
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
