Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5143E31691A;
	Sat, 23 May 2026 16:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779553425; cv=none; b=D5nzsDBtD7gIpOlXR8rCVlgmuEP62xNI7PSxBsEtoD3tOlF7/F05cG18vV69YZVJgQ1RGnFkPHqpQ7pDmn3HsL4sb1NO5iPvzne1IM4d5AtJbZgtuymWKrQ2f0gKceJE3W3LtB9YSmQZlau4c3NdQDIo5P2BLJxXwaO8crOQaTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779553425; c=relaxed/simple;
	bh=P1ybCvjTi5J0TLP4buBP9nNIJpT7fYWW9L+400t0IMk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=MkWV2dUlTgkpEXyiwDlJt3N8h0NyGSQEgBjo3H+Du+SUkDlpoTUPXPvYMKvtz/uU+xdWEj6agB0VdYCyfJDT7quotUwnJPGo2Q5f+yErCrkudhuGon/YC2G2wTUANyTQAT/vZLoN7IbAzYPHIh+nW9qafCQLP2BCOFLOHJPBG/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=liQ5+GXl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="liQ5+GXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E5E1F000E9;
	Sat, 23 May 2026 16:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779553424;
	bh=/xmyvceKB+9yptdtmZuMNZEjeVd+BPCRy5lZBdtJy30=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=liQ5+GXli3QJHF+Q5ShEPhmvVfk9479gwd+WjWzz8NY1lhI/eDr6Hbv6Kj9e8JNSp
	 +4cnRZ+2YVJhqmpxc93spX336w4Wp54nJuq0Ru1FJTtDgFIDXMpKBsayuPOApjcNk0
	 v8dqYtLQ6+3+iE/WlMbiRr4icqz8wlrJVLSrRB9GhyV40ZQDWjIKscEg390on36dmx
	 KijTWnrFZxpIwWC/34kioXKRqBakTntid4zgsgvNGrX2kXXbsDanA6rIBq77Z3F7h9
	 //txJ6yJVXkmMNwz5wFUv2t0Lvib7QDsjfYVWrtwE9XktVCqwxd2VbvrLdJguEjKme
	 BFjZDEVLVZ8XA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93BA03808205;
	Sat, 23 May 2026 16:23:53 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260522234424.GA1208882@nvidia.com>
References: <20260522234424.GA1208882@nvidia.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260522234424.GA1208882@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: 5b74373390113fba798a76b483837029ab010fef
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ab868c10971c5d2cd27b3709d11225941eabe78e
Message-Id: <177955343226.1611769.6033063807496194713.pr-tracker-bot@kernel.org>
Date: Sat, 23 May 2026 16:23:52 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 22 May 2026 20:44:24 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ab868c10971c5d2cd27b3709d11225941eabe78e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
