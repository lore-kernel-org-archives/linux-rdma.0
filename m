Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792714171;
	b=fVyqT6hHYc822lZi+PtWPrJT+SykkdEkY1HGuk/u5FJldkwaPd4YTtoYNe8j3IZVkjnW
	 xYCshsLosuO6XucoEwPJOEkz/3MVMFvqwMhKfLxqStEOqzLEaeTed4qQy3KOXDmvEdhwR
	 pPD3tjurBFbk1cS7vfxA27P4ARkYgMnz1LgW5vT5doQxxFHW5WxoE0RF/oJwLABDHgXOV
	 myfa81ypZR1W7JVBuQozAmkv4cwPEIoAzO6IGtN0AtApB4DtgbU+6lVsohFcle0Vcmu5P
	 kYuN7iVibIGqIsfX7m1i8jxNmiOlQIQJj8rxVjzN+bgOd59g58VnuOM/RppugSlheaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792714171;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=Wk/X+c4EDsEplQrQjGwO3dUzaZHAe0npXtylDB2SJYg=;
	b=WuuxjL472pscpWulm+r67gG+MF0ARfCHWUof7xjigI3fxnhFkdc4rm8RBjSTHTZ4zI/v
	 usqjSJafOhWrXosokEfV7ybXus6rAcgaD3JrCGkJEyO1uKaTXOfAtSPxv4AEH2xkvHfKp
	 iZkQlDKE797zfmET9ekL5hgIAlgO54YLFOe3ASs8cScQET//u7Sq8vSne8Zg8LjmdNTUA
	 4iPhmOd3DA9uf0ZvckbKiM+d5cq5IHTzUZ4XvZv90KtWIRG6A9B/gs9kGlcvWEUxEUBTf
	 3eXHga2kItuPoeyBqY5P2Wn8KRZyvn5ldCwA5gV5R7mlJVoGRn+OGKZz30EFwyCA3OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="b/W/umjS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3BA606A319;
	Fri, 23 Oct 2026 00:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b/W/umjS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76D71F01825;
	Fri, 23 Oct 2026 00:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792714170;
	bh=Wk/X+c4EDsEplQrQjGwO3dUzaZHAe0npXtylDB2SJYg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=b/W/umjSzewodOhzoj7Gyka6AvF72x1w/7R0mfHpujd2OJAmKCx72eky5d4lmkw5u
	 4YrAOF3KBtjKbfJFolwoTLbdhxP2uvAotPMcCRDf2kku8g+NpDw/8U1ysrqvzM7o8O
	 X5m07PJON5/xSxy2XgLcWwv76Ybv1FXwi7tuw2pTtHmIej4MUL3iStbgSe6LHZRaS4
	 9jtlYgg7PdDN9RoDH24h/bAp+nw0viR6Z2AwkmFJoK8HBcuN6RQG6CrmogT79BHQHC
	 fo+doMhsAhYkMDTf68QST76kvOo3kitp0Tz88hYGi6JbVuKIeEWJcZwE5IZO7bdSo/
	 xY5EMgAE561dA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BE539380822E;
	Fri, 23 Oct 2026 00:09:30 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261022182912.GA3745036@nvidia.com>
References: <20261022182912.GA3745036@nvidia.com>
X-PR-Tracked-List-Id: <linux-rdma.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261022182912.GA3745036@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: c3e8e9451e6f1b69f685b75e0fbf14f3d0fb2539
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fcb92ecd733e11f37c32e7485da976a40d878e72
Message-Id: <179271416938.261177.17963896392809720674.pr-tracker-bot@kernel.org>
Date: Fri, 23 Oct 2026 00:09:29 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Thu, 22 Oct 2026 15:29:12 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fcb92ecd733e11f37c32e7485da976a40d878e72

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
