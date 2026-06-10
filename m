Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5490846F;
	Wed, 10 Jun 2026 00:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781049956; cv=none; b=ivT939NmUtWA2BXi4KqNCkPUv3PWzCU9/G5n0jFT4rpzriXxaC3DBSZIqZfIJx6DegfuU7TZ3QTH/U1Xdwciww6YshkceIC1raUVwM8t60s7QZ4Q6TGl/ZZddHf3FGlIBbEL2BaLi2eYHk9VlXrJw3rZul5D6Bm4cS7yaI2t0z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781049956; c=relaxed/simple;
	bh=2ZKesxxd3AgyVDtfd/hsg1ZOSvM2yapfRlgx7TeXXEc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=IwfMvyJyphOn4NbiBJTH073TVbwIfLgw/Jc16Qv4w1WtNJGNLqkS1/mZpRu9u3QGg/Dve2spugcekV+lq5CubQ9GWBJ7JFjpP2N1QjlQLfqJi2EknLpYs1d6MY7pMCxO2QHTNm+UGHvVCGdRm4iUi+c+GsgZZAzxMHMtrxz6rts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NXgP41SU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NXgP41SU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6961F00893;
	Wed, 10 Jun 2026 00:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781049955;
	bh=hoYTJV05+NgGeswcLPtzI/oXE2U3eBXPQS3I4ondShU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=NXgP41SUWEN7yTAK58spfTgFSumoXCSsY8g2dhdHPDgRM4/mD53H7ToFFth9K+u3H
	 KDBSKfhY7PKSPW21WH9KyoNzTgKkxQQtbTnFNvqTonu5yjVfcEs5t6eEWQnHmmwAxO
	 MLsc5S/hxb5LlfrDDXlRvCIbag72MdNdUlM24pQNA9qG3/ROOGBbseMCNvQLftNVBZ
	 N3bwBlMzXiSTgL5SpkVNbnZTBWyWXbmBE2+zT4jvS5e2E9kEMLyVRMiyMuwQm8GTc3
	 jl4GPTe0ZUJ1Hf2JqpHOsB+W4esa79X1AU4X/UPb+VgJ7Ke1o7KAPveC6dPtLabq+t
	 n7BGINujDqJsw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19A623930A0F;
	Wed, 10 Jun 2026 00:05:55 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260609125007.GA450183@nvidia.com>
References: <20260609125007.GA450183@nvidia.com>
X-PR-Tracked-List-Id: <linux-rdma.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260609125007.GA450183@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: 13e91fd076306f5d0cdfa14f53d69e37274723c4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fed2efe803e014e5c419bc7592caa8633683603e
Message-Id: <178104995361.2756347.6115932380409505243.pr-tracker-bot@kernel.org>
Date: Wed, 10 Jun 2026 00:05:53 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 9 Jun 2026 09:50:07 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fed2efe803e014e5c419bc7592caa8633683603e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
