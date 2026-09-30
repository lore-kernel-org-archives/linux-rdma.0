Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065A535A398;
	Wed, 30 Sep 2026 12:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790770694; cv=none; b=aUqj7r895lTR5EY7bIT2TArjlZuJu9541wi2BuLgzFAplrnK/eBIrE1vQN22mu2Xn8NPtPrRexl6ayHCui1Tt0ppNqGy9BDZyyMnjMPbTw1XAV2FJgtTZuiSXDenor2a8aotiyNQyVDo7wdPHPCBczFK1D8uOa6HXnr739aN8pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790770694; c=relaxed/simple;
	bh=DxOA3K04TdGKgV9RBzwq7NMB042SfZvdvrNpiga7nYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i0oIZ+UyF1hfnjySFNTRrN/mPdP2jRzJdV/yvshzjuvwI88TBigYS1/nZ6lbs49kUf/bUkUPbynCGLYZ7QqAC2f/v3MCC6TDS8MscqGU6iVtgGqsCteBOC4G4B+a76gBtSuFtUmOBqw038flaGXwsWugCKiUHINcVsg7M4iI1bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QKxElZWK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QKxElZWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634891F000FF;
	Wed, 30 Sep 2026 12:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790770692;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKxElZWKS0Ys6WNvATHRL7YGjMvgZrF9T1oOHM6i9xogbDfnVWzMYSVrlSa3yoVBL
	 Xe6m1CsStqmhHcd4Xq5glEVGxN7Zhxls9PRuHszuYQCOpO9S/3Nh+iibn4s4SBSB5l
	 so96+IW9Bm+E20FtGK7hBJGTLKEW6+FRO4v1gj9kLQcVwFGZXJ9Hre7BL9Hxj91XxJ
	 iozvAGyX+FaFDIfolWfkZ13pelUSYEVSbNiF55PRGbIqnG738muohias1HPntQApwx
	 LrOG3fe9nmGI37uV0RmK2RmjIKpfM2zOVtxedT81OUoSo3WSHzLc31Z5+wVYbebux3
	 cu1nMRHZ/8mgA==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Andrea Parri <parri.andrea@gmail.com>,
 Boris Pismenny <borisp@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
 Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 Fernando Fernandez Mancera <fmancera@suse.de>, Gal Pressman <gal@nvidia.com>,
 Jianbo Liu <jianbol@nvidia.com>, Kees Cook <kees@kernel.org>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Parav Pandit <parav@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>,
 Raed Salem <raeds@nvidia.com>, Roi Dayan <roid@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>,
 Steffen Klassert <steffen.klassert@secunet.com>
Subject: 
 Re: [PATCH net V2 0/4] net/mlx5e: Fix offload lifetime and exclusion bugs
Date: Wed, 30 Sep 2026 12:18:10 +0000
Message-ID: <179077069088.31693.17490982550974749256@kernel.org>
In-Reply-To: <20260930121119.141953-1-tariqt@nvidia.com>
References: <20260930121119.141953-1-tariqt@nvidia.com>
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

 - What hardware the change was tested on. For driver fixes please
   mention the device (and if relevant firmware version) used for
   testing, or say that the change was not tested on real hardware.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
