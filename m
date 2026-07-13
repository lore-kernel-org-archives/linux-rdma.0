Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA2326E165;
	Mon, 13 Jul 2026 16:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783961915; cv=none; b=oSg020pHraeMjdk4E13xBhhgnOk7/jbMvxbBrQ9YzoAzGCJo7leboS70IrPliWlxfqEj5CmNaE0ihLqQp+gKTuOPqtJaUIoyYL6aOLwpyRr2d/xX7ksTHvdZOTMirQNETD01fwcqsBuNkbW15Ri00FzVS16Z78WFZIRc5mGcotQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783961915; c=relaxed/simple;
	bh=41LNvfl7nzywguoI/dIUECYIGy5Q9V7Cjxc3djCPsi8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=U0aJqO4K/MvMTji2jmA8BRLYU6WAli4NXFP70yAUAiGPL9w91lp/npib2eQfsxDR6VvhiN13NU8IQ9TGnIJdioTAe6jbEy0ctaA7J1ZD7HMoSKIbwC7EV/p/78Sn4LzYgzQ01j/xD7pttiUVmz9W554xxNnLPjhEjHu4C6Bct5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GXP3A8eJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GXP3A8eJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C291F000E9;
	Mon, 13 Jul 2026 16:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783961914;
	bh=wSejJnyfdLyFdD/lgL1N6KK1dEiBT0efOAQgTJ/QwGU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=GXP3A8eJCXJ7lAqQgOPSvptycamZlbay4wCE6/NNwo7fRf1xjByW/PK+5zJpxpAf+
	 VYWEddouDn23pSFYB5YlFr1e5cApZE+CSU6PyIEtyM+X1IdkenO8ZPFaPR4fgmfPaR
	 2vw37DEarUACvs/SyoSASQJZEuYVglGRJP0zCZ4Z4MMQ5T42iIYWDe3cNAoiNkRGCC
	 3dZE7Lvoyx01tIx06lJFZV6N1Ps3yH/4lWPE7oxwRzufLek25tup2Hf7jaSJd8PNnq
	 2KgeL4yHwY7gGtEVnLbFEUdSfRlFsmbtchGBLQf3uynWQxz65CPYDR2rgHEd5bYgPd
	 a1sknU5FzxFaA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 199CC3924F84;
	Mon, 13 Jul 2026 16:58:11 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260713130149.GA3130810@nvidia.com>
References: <20260713130149.GA3130810@nvidia.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260713130149.GA3130810@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: 3cda0dfe8c651dcbb9e38977905d3d3b1750c4ab
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0fd8b67e27ff7115b98aa09b9a22eb06e5370d2b
Message-Id: <178396188962.2325401.7879971320175383252.pr-tracker-bot@kernel.org>
Date: Mon, 13 Jul 2026 16:58:09 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 13 Jul 2026 10:01:49 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0fd8b67e27ff7115b98aa09b9a22eb06e5370d2b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
