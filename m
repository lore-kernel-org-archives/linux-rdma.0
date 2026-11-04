Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793759595;
	b=rg13lzrlZw2wz3jwo4pa4TZFpYzjkR3qfB1zjGpshLNP0c2NzdhZugzbW7jJQ2+npcAO
	 PdyzS0S6Cd/Sz14/sCEJa2NQIOIh7xMlrjXYA0aUpG9xjBBpRO93GVi2Zz6NB1EULZ9uU
	 g2QxP86gEdQwUs+uTiP3IGbhimeVPKEalKbcrijlEnydAflUsp2DzilEUqsDdNhDN7cDj
	 2kJcqG6NWwsdCKMIQW3xtrqDEsSgK8ystIlkLfo58Frxv/Ix+SIeO2UI/UtVM9gZFHAAK
	 raxBfgd8436YIMbFqSoTX1+cyQdfUR5kN2jwwKDjYMyWJc7rTX43Y2X+otkZ1MCUZjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793759595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=xliCspLLAblI91+fpYE1WH7XztcLioagfZLdmX96XyfXaNs4Ga+1fKaNrACI+8sS9uP1
	 Y79/G4gLvKAUnRAryqe2mrjMX4UqplQDdE8I+ufsizLg9e9/A9NWgPJTTvGmY97wgmTE3
	 CnFNVnyCcg1XVbXs92HCNyA0Ha4LzyNSPpy4sEao6E6YrGIKXk1DgaUjvqh3pYnX251rO
	 NnnIaL7U7Ie2SkYiqXhQviZRxA01SC9+DuJTKI6qTliaqU19Nhgt5XV4Y9kcEMPCJ6fcv
	 Pw/QVqp6eb23CKwrPQtslyIlVUN/TdSgeadp9Edj0CcEEqImNBp8O7zGscYHptam52A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iuhQ9NKe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EB5606A31B;
	Wed,  4 Nov 2026 02:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iuhQ9NKe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB031F000C1;
	Wed,  4 Nov 2026 02:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793759594;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iuhQ9NKeIKcXa+uAqxZquNcESHV+jQwkQZ3XFZl28S98fMfvwJbzbBpFHB/Nj4b4J
	 gB1NYAbOaCs+ytxYP4ATnvtVJgsXtIMQbM9LhzXeGz75x9TEigKI0IHdLjEbAj7uDl
	 GluJLhFLvAqs6Qxa7cYoFj4/uDjGKWjZechnnQX27NMDB4+SbJmg4Gav6Aqo2ot0LY
	 94sIAQqf/lRzMDenVwKp9GJtAWJy6JSPtx9dGy9/vqh7AfhFLgn84z/ZH/meHFVNZv
	 iK/miuBe5csYguqU3CZT6Z1ZQ4HZR9VVrArHjVOlnAhLWRdpScrk/pUlDN5gkrG+Fi
	 RcQBx9yjfhodQ==
From: netdev-bot+sinfo@kernel.org
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: Allison Henderson <achender@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: Re: [PATCH] net/rds: drop the device reference for ODP memory regions
Date: Wed, 04 Nov 2026 02:33:13 +0000
Message-ID: <179375959332.488859.6396947278520787166@kernel.org>
In-Reply-To: <20261104022810.1484182-1-vulab@iscas.ac.cn>
References: <20261104022810.1484182-1-vulab@iscas.ac.cn>
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
