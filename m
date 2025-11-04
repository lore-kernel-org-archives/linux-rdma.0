Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78CB31BCAA;
	Tue,  4 Nov 2025 19:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762283498; cv=none; b=b1lIssAp1qgNoAdfhf0PzlDMXIkwOcnRoqkk+vIkY+WZaCLU09Fvf06Hic5lG2GO15tCaU6VXvIB4TpdeeoWzz+FKLLEu77tOgRpMQjhLgmwhfjbvKaz0/WmuLw4nP4iEB1890j4xyAL7IIbun4iOlvL8oRw2xEtVb4xC1Con4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762283498; c=relaxed/simple;
	bh=zCdcTye47JCH80txxVSMO3sm3p6SzKIMsQQEIEAZnEo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=bFFzBNNKTOmmM5TpPCyZDARDNdLTuKs4i3akISDUBN4gHbEkbx+K7SV+PbimvZEJhb3WmLpejAagNUOeJO1tSjdoaHg/ql03G3SsaVDoBxuHhkl94+JlEYJlwLgRWJelP6GTi8o9ogIdZTtqrMvqUzC0sbQexbTnTrE/PUZ59Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QspvYmCH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QspvYmCH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EB1C4CEF7;
	Tue,  4 Nov 2025 19:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762283497;
	bh=zCdcTye47JCH80txxVSMO3sm3p6SzKIMsQQEIEAZnEo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=QspvYmCHcVR2oGI+ZXvRKTc1iW95okk0ynefRnXP0KDb4P2M8IPbu2PQU/RE1QMnX
	 LRp0JlR4UYAh9vKo/LUb6SKlHYp6ZoJjlBdrX8Kl5o5qqxk2xONYRI+T/7asXr7DIS
	 CMOLHPLgZTH2CWiNFnPvoss1dpXFuRjSwSs9aeGL0MKp0fyvfz1m9kEKZlsCNlzZXA
	 oCSfMQ6PXUaHOSYHYgltI5ZV8aZ+YYABWYwsvrH0ECaVZrnTtPwf+tGKrsWo51PLP5
	 HxfCxmDOOYkShA922qeIcNbmfe4dQ8YgVU+U/fV4vbpak1x82Orjl1OKb3PqYwrOLK
	 acDTw6kHs16yw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADFC6380AA44;
	Tue,  4 Nov 2025 19:11:12 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251104143118.GA1641561@nvidia.com>
References: <20251104143118.GA1641561@nvidia.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251104143118.GA1641561@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: b8126205dbe01e22b0d10c8be132bb53bf3399c1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 17d85f33a83b84e7d36bc3356614ae06c90e7a08
Message-Id: <176228347129.2966965.394760249066916928.pr-tracker-bot@kernel.org>
Date: Tue, 04 Nov 2025 19:11:11 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 4 Nov 2025 10:31:18 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/17d85f33a83b84e7d36bc3356614ae06c90e7a08

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
