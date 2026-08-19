Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC703CBE91;
	Wed, 19 Aug 2026 19:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787169287; cv=none; b=eE9U0bKCPbClhxrcn9McIOqQTtThr3b/y6yeod7yvGCTMPqil2CGq7JFTQM/hRVD3PfhArE0GKFBCta+ZT9sE+fRmy50LMhxnv2CzeaOxv32ElYqwZzpycmYP50Blp9fCqTtyqmBEaoN0VhaJlX+asrinL/xMpK9w0AuGAOexCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787169287; c=relaxed/simple;
	bh=3o4rULNPExOXDwnszxRZvRXFBZZwib55o1AW0cPxD/8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=sZtaHKEvoChQXms8H9TtuG7/pHQmQsdJfcqz/pri3S2ow85sayBAhIuqHD/nx8KYxzm8DFVXEmh8U8LBCywBA8XJROWaYy2xBijP6BVzckGtgynbqeXwbE0e0ofDtSVJ90JDNyBbc/K0dGvDztXF9Mey3S3RqkG2hC1lQpuE9wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y0XqJroC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y0XqJroC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52531F000E9;
	Wed, 19 Aug 2026 19:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787169286;
	bh=s2eS5nmm9fjBBuEMdL/VUu1Uvy98ox65PHIFMXTMd7c=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Y0XqJroC4Wtf9EE2C1UWO6zs2m6eSSYuCRs7tLCvCHCAnnAAP4rWUiJhr0sacGy3U
	 3R46nLAVHBPKmNZr3lJIs5+u7sinZikxNUxQZAj2gOnTSi9uGRPmHLivtv0WRJGJPl
	 EoOQmH2N/TI7OKzOpmluE5zAkLoG98TRLpr5tLSpYpND/34OlSA6eQIv64ojcoaGJZ
	 wbbhWWN/z0p++WBWPUh+f6oqQyWO71k+bypf1YmfW9j4YSfTDiFslDhTk4dAEJIkos
	 OehIpun1WZ4enxPJC/U5Nb8YcqnARG6hKzTLQWYJcu4KAw7bUa8TTWlTowJyZquXCS
	 dg67GiufxwdCA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0C113811A47;
	Wed, 19 Aug 2026 19:53:58 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull FWCTL subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260819001112.GA200468@nvidia.com>
References: <20260819001112.GA200468@nvidia.com>
X-PR-Tracked-List-Id: <linux-rdma.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260819001112.GA200468@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/fwctl/fwctl.git tags/for-linus-fwctl
X-PR-Tracked-Commit-Id: e052daab94ee8c4081c91de3549772bd1c235729
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 98f21c54f99519329c18e2625b0ea6db14524d09
Message-Id: <178716923735.3672948.8687587922607388249.pr-tracker-bot@kernel.org>
Date: Wed, 19 Aug 2026 19:53:57 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-rdma@vger.kernel.org, linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, Saeed Mahameed <saeedm@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 18 Aug 2026 21:11:12 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/fwctl/fwctl.git tags/for-linus-fwctl

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/98f21c54f99519329c18e2625b0ea6db14524d09

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
