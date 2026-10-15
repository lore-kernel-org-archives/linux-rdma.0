Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE13C47F79B;
	Thu, 15 Oct 2026 08:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792051783; cv=none; b=c+Sd8Rp6F6q87RBtjX2uPErp4fJCAGERCFsEQmZofA9EPp+djO18V6iQCAs+VwnNLbL+BA/BT7LIGva1XAficaV1OWWroNj0+j4Rdg1/BBjWN1XnoIOQTpUp5RgcX4GrktErNLqcqBACVRCiAPs2tCRlE29QksoDl+jz0dvZ2xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792051783; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bjqSD8C7MDUIFqm2Bf2xQofA6PIhKhJ9gOcjrIvHhk6Y/TcYKvmGmiuICmd3yH/8z1ynkvnvMDgQeW7ewq595g49rVhcnzuMFYOXPJu01wHcRlCaQuEzR9X/YEoNMUyQpOTyRAd8g8ZeRwEpFC8Y3d0XlCgg4QNZHINLlmbogPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GlSIYaMn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GlSIYaMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461291F000C4;
	Thu, 15 Oct 2026 08:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792051782;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GlSIYaMnzOqXLt4ERkB23djhcjITbTnv3qlZenzf7zo3MajqrE9FXsnsq8LDXJ6/J
	 78SY/bWLHigtpz7D+p6p0pFw9pKkr699Ga/RSpIB+sRo4CWWHr8DZWFkk7NNmaMDtB
	 dPGthuG/y2RxXJDx2n+1wiWzfStvmwRCbLcjAoVQTlfRVLAoTTvguuzhenLxtwnnw7
	 7MSwoChwTw6m46CtOIBl2NpB2Q3naei3TzwO2bHeXqgr18zo368qODzl5GSmUSRSYC
	 EUkgWknEAgFFLhYezvcKG/H7h8hauJ2/XlNDVPgtoYXZxHCwK7RS8gjkvKSeHhrtbf
	 OQT/7h0pSPpfA==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Alex Lazar <alazar@nvidia.com>,
 Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Kees Cook <kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 open list <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
 Mark Bloch <mbloch@nvidia.com>, Richard Cochran <richardcochran@gmail.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Shahar Shitrit <shshitrit@nvidia.com>
Subject: 
 Re: [PATCH net] net/mlx5e: Fix NULL deref in PTP TX timestamp recovery warn
Date: Thu, 15 Oct 2026 08:09:40 +0000
Message-ID: <179205178078.408196.12399315538524843906@kernel.org>
In-Reply-To: <20261015080218.1102172-1-tariqt@nvidia.com>
References: <20261015080218.1102172-1-tariqt@nvidia.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
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
