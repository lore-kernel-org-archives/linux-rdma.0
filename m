Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795359449;
	b=l6Blh+wERC5ZfALSsIVX5HdYNfqbzJWKiTm9HCF/2Je8Sg8B0BOZbBOvaFtbAKzztyOh
	 bo35Jxq1G9qPM4Ygqxy/vd+QXCdS4NS30F8SCdR7n7A7ndkGghi2BW5x6RDElTm+WtsaM
	 yEOsB8Pt8/l36pTpcRwpnVpA0G7KczpBKCDQKIysehMO4ZoiQcL9VqM/HAmXNIyiipj2L
	 kW6+eAAHiI9dMxUzGxf1Jpkno4udkTv23QUokZi3y40/M9wIZii8tEKRQQz5KOV6C4jTZ
	 BcAeyyg4hWNNNqqjsH8K5MUYqkdWrWyMgXfGiR85E9LEgFNrFMc+lSn7M9SSI5VjB9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795359449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Ld9+YyGfs/W/wYUchYl+G0tuTdeNOsMW/DqiAiz5bT8=;
	b=dgr77IBaG36yPrVvVHp5fb9PwWOhrPlImk/xbQSfQ91e19Ve2Z8ez4rqBIKDjO8neAFf
	 FAAoO5TGOpLmeeyJmUQyPbcwyitjrPSIlN/jb2YdCBXPN0GhlHR7WTaaWSkFXpyRw1rba
	 JIb8JHDrMjbJibP85iMXC+E7tuHNzLpGKZJ6p7z51h5q+RY4re6SMKS8enI3/bHK1pN9K
	 N3WDx43vJAT7asp1aS8fnbisCyg+d32vB9n7c7ZHhv35IRekzdOw6U8YHxTmIKt/kg6ea
	 UAXif5UbexWm/urkr3yXLFOdHJl0MNIAbrh/qjdMeL60JXadUbitZ7OceZbYFBWtNJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nbIoYxIg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B18606A320;
	Sun, 22 Nov 2026 14:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nbIoYxIg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD891F000C4;
	Sun, 22 Nov 2026 14:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795359448;
	bh=Ld9+YyGfs/W/wYUchYl+G0tuTdeNOsMW/DqiAiz5bT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbIoYxIgMEEvmV/IselpUHfe912DaaXVtVVUkweDRzYMmg3rBab3HYWHLEsqVLUKW
	 932HSa7mEBLx5c3/RVOm5ZY7XadKa/q7D45l/WrrBIea+qwGSGGn2vdwnxdGMcSdsC
	 r1ddJUSeWPyQ/NCM9sEzlPK+iKuov0030cfZyGn8EIjt1sZGWSq/1smAKW4vfWznAG
	 aRfXB9jUNVe6FXNv7bvC2fpFp/EczASWAutgJul3LH3da4pV29fRlgX4xitFM+X5rd
	 T72GCrU4LzUkq7svySp4vMjZHhsAZOqS5+atSVZZVMMsgtSCCwOM/5mW9fzlJ9W7of
	 27EnZLxDGJp3Q==
From: netdev-bot+sinfo@kernel.org
To: Aibing Chen <chenaibing@cmss.chinamobile.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net/mlx5: fix a stack over-read in the QP debugfs
Date: Sun, 22 Nov 2026 14:57:27 +0000
Message-ID: <179535944764.3294.7333899043008623652@kernel.org>
In-Reply-To: <20261122145152.1473-1-chenaibing@cmss.chinamobile.com>
References: <20261122145152.1473-1-chenaibing@cmss.chinamobile.com>
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
   (e.g. found by LLM and not proven at runtime). If it was triggered
   please include the symptoms, like the stack trace or kernel messages.

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
