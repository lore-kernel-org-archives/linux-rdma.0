Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E30A3FD969;
	Fri, 21 Aug 2026 19:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787339492; cv=none; b=aE7+Kykk8UQOZytZSrFQhWJgyjdVA54OQet727bn7bOoTbNmTbxmzqwM6UXzg8zXivRkuSUogHOcTloN2Sln4qVd7Q3SgBBz9MyCxU9piNO9h098PLgxKI5vN1F6p8/sK95DU99oNi9OCYgQO7/2rKeWGqj4e/YRQek4MJ657yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787339492; c=relaxed/simple;
	bh=Kuk5VicZsgC5QQKj6cwyQ6KyvsdJExjem4NHlD+yC5g=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=vAKKxqbqPnFJvNwsk0iVmK9Fe2YGYINuVeBHH1BA0GfgGc++G8Le/IVqrni+Q3WwpT0mFJNnaJETfnwdza5p9NB0Pb0u7j0A630ClUtmaD3gyHKQYpN6uSJXnTNrK2y9px0xxTuNGpdUi5K7/Aj5zfKoFChkRrF63MRemXnjRgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d9lmf1mb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d9lmf1mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7783F1F01571;
	Fri, 21 Aug 2026 19:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787339473;
	bh=6aHG0RqP7RKmJFdonHgiLgztFQ4ZaY46f1vdYVxmcI4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=d9lmf1mbmoT4cdCtiOzyXS0Du2xf8yK7j3xirkQwFdV/Sk1p7pjK8qTjUXoKYnIhJ
	 4FmxmWpVrwXYfdK4x38KT7xHjzXmFG6wr69fWctbOGHlenWI/emRpjjs20Zju7A9C2
	 jkPWwZGW53QFmxb5UbZ+BPbxcYpedWa1LHXZGF0vImhB0XAif7+qaCzVKa8KB78D6i
	 bN1Pn0ebv7eX9vLoT5Ra68dywpPs9+o0P6eluFAVtuoMPCZ4Kdkx2Z+L26eKlkCPzw
	 +YYM6BIzftoiviGnDwQyqQ5xOKjXzYnf1ccUNATMeLXbW4M8DLBo4GQ+ehqWBHIWwF
	 yJdf8AlO1OQHQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3CA3F380CEC4;
	Fri, 21 Aug 2026 19:10:24 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260821005507.GA1172051@nvidia.com>
References: <20260821005507.GA1172051@nvidia.com>
X-PR-Tracked-List-Id: <linux-rdma.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260821005507.GA1172051@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: 8049741ac93acd3a590dac070e12571fddf0e294
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 21bd0802cd3f58b656065f1be236694c40588c3a
Message-Id: <178733942311.1438271.15195754497657024784.pr-tracker-bot@kernel.org>
Date: Fri, 21 Aug 2026 19:10:23 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 20 Aug 2026 21:55:07 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/21bd0802cd3f58b656065f1be236694c40588c3a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
