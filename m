Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3ED4D9F9A;
	Fri,  9 Oct 2026 13:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791551072; cv=none; b=crQ1x0NKIOjAgCM+2BgoF6ta4ELUz4yIgmkTDpmNnUaZlCYrQjTyBS8l8hoEAjIexMmM+ogbQAwZ1Wh1SwfaHt008UyusF03cPMMwSa5raxTXT28QY/GAwo7K0rc/R8uJJPKvz4m/EiGdTGM4lSjwzxwNML+EIpbLuueuPlPxb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791551072; c=relaxed/simple;
	bh=DxOA3K04TdGKgV9RBzwq7NMB042SfZvdvrNpiga7nYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pEsf2lT71yfUhqCswqKc++L0UGxWqPttkpxTRsIiBbqrplWcork4JjMpZieMEwWUnf8Setnl2TewRhlNjrQz1JIQAfnFhRB735xtQkhhxdyqALCf4f3e3fEpp7wR2QT4xNRq2X9fjimCWS3CXaBqcVvIoMAtqxkQdpNVLpO41zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CfjPpDhI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CfjPpDhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0411F000FF;
	Fri,  9 Oct 2026 13:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791551070;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CfjPpDhIc+ejnd5B0GpmXyDzSr5LWlerg7YWzuysWGoVW2l21OfHxkkw78ixYDwzJ
	 d5V8MM1qi/iGr5ecY7hNjS902svzuAPQ4LCQpDzBzeBAeGgJYCF8igMBfrXtG4HLoO
	 Terwks/BCK5jtOu3PfDKvvuP18HZ76ucqZ2qpFt6Xc/zse0zV/iRe6qqz3JtkdlcTF
	 SbGBNIP28bPzJR7UjvB5I/zLL7kX5TBbXcNPiG4FvLPQXOIXWP0Xdq7dja6/lrOvHS
	 BxApms9J+RSPyksrv9V3gcirlnjZYaOETaF9/mdStj7ybo4aQ5AR/n3ufGQkkhABGF
	 TN3q6x2wHJPrA==
From: netdev-bot+sinfo@kernel.org
To: Binbin Deng <18983559317@163.com>
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, sd@queasysnail.net, horms@kernel.org,
 raeds@nvidia.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v1] net: mlx5e: Fix use-after-free of the MACsec
 xarray entry on RX SC deletion
Date: Fri, 09 Oct 2026 13:04:29 +0000
Message-ID: <179155106940.2527009.13517095133041758866@kernel.org>
In-Reply-To: <20261009130050.37694-1-18983559317@163.com>
References: <20261009130050.37694-1-18983559317@163.com>
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
