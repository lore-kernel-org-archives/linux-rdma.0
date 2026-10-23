Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792714173;
	b=jlOFJ//NJGD2MOA/KqSt5wo/UDqUIe9/wHqWV7RJaBR04hVEGkBC2NkRFow3ANhUAVzx
	 KRpiluHOMIyQrxUdPbWQgRDDFqQ9Y4MO7Fj6ea3wmubV5UfiILTNPmIwWOVFGX+qXlvS3
	 WmrKFw+VXJCtZY7tPkA3j+F4NfgGWRAyYDp1GPxoga29gCIIFj70mwW9rkGWhhx6MJzgg
	 24siEPM1Ic89jkqsMH1Nw4sxWPB8gnM9wC0TFtFyIcGk9NxWCFb1J5LwbtwK78UPehDid
	 +L1Soz4IVev4MqjR1rABIQQlQYHMou/EZxbmL9SBHD7kYdatDGrxlqB+o3j9pxsW05g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792714173;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=u3pWT9Dm2E/AE7Ukvgc6YgoDvQyfUGCmdxDhCpXBDPs=;
	b=gtzndlgRj3EtT3wkZINfh/95C8P9IVP+VF+ypmQGeg8MNJyEYT82QMriYEve004fBFaa
	 6OABI3RFlhK0lQJ3bUi8b9dZUARACPIyBMyaYcUodCsdM8GM52nPZzaN4CE7IC4FSF9TZ
	 IUFUQY6g1dXvatg3Iyg05QYrcWxbo78P6yLKvw40jKNWytCOeJwj/55wHppoe7weFxxlB
	 bzvgSLWx5jSQ6B4LShgzBK9uq9GMlHhtlUPa/V8ouIpq+O+nhYi/cD1unO0nq1r3do4sh
	 nu/sSDeB8/xiPBE0kOayfvAY/4apl5cPAb1to75ujO7tyoOgJubLJgjYGOYmnADWK2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BFLEqXk9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA10A606A321;
	Fri, 23 Oct 2026 00:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BFLEqXk9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1AE1F01828;
	Fri, 23 Oct 2026 00:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792714172;
	bh=u3pWT9Dm2E/AE7Ukvgc6YgoDvQyfUGCmdxDhCpXBDPs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=BFLEqXk9L/V89hnROiksc7D0GfoxtPEIrXQ/dGLaOatIRA3476GPEdoa8wpQOYGMN
	 vvXZENnN3DbbxJ/6wAwQQatWCaGnFX3HqTwt5Q7yfuPbqF0rO43t2J+evGquI4Qjfk
	 lI1cuWUFkg8SsAEyNJ0DCO+m+zfxBFglEtaAWrFHTilZmk5rPDEYBIC7Z750MXYXKr
	 1Y3uxEtJmMM1F+MS4qVCj5cKJDTQZFNBSgGLVoy1YYyUrz3qjfd/6XVVRaBGE6oWx1
	 un0cyHdkfzgU1p0yay7tPOZ62J43dkTaiI06ho8KuZnLIjSwdeC89JYNDNBtt+5vGc
	 NV9eO/LVY44XA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 814E7380822E;
	Fri, 23 Oct 2026 00:09:32 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull FWCTL subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261022192726.GA3758618@nvidia.com>
References: <20261022192726.GA3758618@nvidia.com>
X-PR-Tracked-List-Id: <linux-rdma.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261022192726.GA3758618@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/fwctl/fwctl.git tags/for-linus-fwctl
X-PR-Tracked-Commit-Id: bc6f2a284c63313e789d8cd294531e1cc2dc8c99
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3ac032ef6ca8e47bb06d1e189dfcf88fa0a09c75
Message-Id: <179271417115.261177.11379581765354994499.pr-tracker-bot@kernel.org>
Date: Fri, 23 Oct 2026 00:09:31 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-rdma@vger.kernel.org, linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, Saeed Mahameed <saeedm@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Thu, 22 Oct 2026 16:27:26 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/fwctl/fwctl.git tags/for-linus-fwctl

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3ac032ef6ca8e47bb06d1e189dfcf88fa0a09c75

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
