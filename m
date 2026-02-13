Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2603F224AFA;
	Fri, 13 Feb 2026 01:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770945526; cv=none; b=KFO6N149x78HCFRtOVDTiTQ2pWtQEjJcBrAFKSvbvZp0wrthZV16ae+UmfX/J7pecbA4zlUJg0/1N57wk+BWIMItsNGjKZYM/NkVQT42AyujMjUJ2YWF7qRbFjd0oRAInQOyT630rD50CGigNqFS9N86AKlpb/zU+csxNWq9mmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770945526; c=relaxed/simple;
	bh=xKPTG2mO2FEbwCwUNogHrGXJ/mhnIeAseDVAxd5XgNs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=BhgbZA3P5Y3R5PCaf5Ro4UKU9j8dG3YN8QSoBGhrodCkxrpOYkT1OwLa7f0flndQxpKa0vf57u/xS+LTXzeLjqM/fh80/fhscjNWIuqyeX76B8fKWkc33VhMsfMWkBYFpBLTnHlzR7O/xfNZhBF7XF163Jbrr/iS+bYD1sutpHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TLJYS0aN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TLJYS0aN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BD3C19422;
	Fri, 13 Feb 2026 01:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770945525;
	bh=xKPTG2mO2FEbwCwUNogHrGXJ/mhnIeAseDVAxd5XgNs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=TLJYS0aNlxcP3q2KQQSNnnfuYk0IZUROLVO5fHQX5Guzmm8IGP9VwfHxxdCzO0WBH
	 TMv/Z2YC9qdm0H7TcImqaZozcjvyYGnWSQoZQRPwpl10ZByxetd9rNk2ThD+tDnihq
	 E8bEJ28vyzoFG9AUTxNNRsi3qNf/VUxN5y3GMBXEXlc9JaJ4mF4h8ZVcqFCaJaDSHy
	 D1Jgpzpns3eT2/WAKR4LlCzodP2JzrAO+dIcLwVTFUC5/YzvsTBO3RKKBL21EsCRHa
	 wEZqPgCkX3pKtPjQ833Y8LbGBEyuoDG/RF3UxOLjcFkZsrx7qdGT7lpTKm41uxf/h6
	 bydy12+f6MMYw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 480DD393108D;
	Fri, 13 Feb 2026 01:18:41 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260213003420.GA1062479@nvidia.com>
References: <20260213003420.GA1062479@nvidia.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260213003420.GA1062479@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: d6c58f4eb3d00a695f5a610ea780cad322ec714e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 311aa68319f6a3d64a1e6d940d885830c7acba4c
Message-Id: <177094551994.1792804.1378842482319486390.pr-tracker-bot@kernel.org>
Date: Fri, 13 Feb 2026 01:18:39 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 12 Feb 2026 20:34:20 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/311aa68319f6a3d64a1e6d940d885830c7acba4c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
