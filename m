Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C159E185B67;
	Thu, 15 May 2025 20:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747341085; cv=none; b=G4G3E7HscXNxR5opT/aFuOuu4UoOs+5K4QNlixsLBLn2/W9pGkAVLL2t1GsseOewYbQ7pm7O/Z+PzkJ1R53pUfUQ6/Z8oUEIKgBsxODRxkRALc/2NRrlBXL63GVc9R9DCMr0zQW+sh7QM5bRGlHb88qOiu4gAQEiQqSAbBzYYj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747341085; c=relaxed/simple;
	bh=RV6stD2Wceg12X5UtH4xHMEe4GMnrSLj7LVhBEPjZkA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=soRva4hRxHSkwSOZsmdEkiVWKYY1YxqDG2Ar1RjtGKY2zkhVmzDUGRmUGQKgDD2K9BUdH20ryfDJ7fXuvrYDdfcYsVcwQF+WbPJJ1+VHQ25bUc8F0GQOg8oBIH24lMeG0OUsliVAdAeMgfbaMTT25eN7Uj+vFoWBZpEajLnH1UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vMt/a2fg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vMt/a2fg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29ED8C4CEE7;
	Thu, 15 May 2025 20:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747341085;
	bh=RV6stD2Wceg12X5UtH4xHMEe4GMnrSLj7LVhBEPjZkA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=vMt/a2fgGrN4KXQ3ROwyBarxRpnSGbel2UlCuLKjQ5jPK7Ffn7kQCkRC3Z5Qtx1FV
	 lMyCRn3pgLsV7NJDlHUgGvLWPYcvYlHqjb/5cfkry4Db2VMpPiSbQ0T8428pbBBiUk
	 YAemLxvyjQKBltPryme463j4QFQCyaX74ptY2GJ1/hy2XUPcQsE0tNXGQAK7d6+UOb
	 RZXsMtZ69zI8L7SU0CkoiRdwHCfVe+bNMmtPrAZKM7wyb1lrMHmtbDMbOciRnOopaX
	 W7l15rwHw0/Y8l7oqIamyz1JnyqyS+IsKoNRNVFaXEc43Vu9gkixHxJyI0NqxhSZGn
	 P7Tus0sBYwYNA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33FD23806659;
	Thu, 15 May 2025 20:32:03 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250515191213.GA612809@nvidia.com>
References: <20250515191213.GA612809@nvidia.com>
X-PR-Tracked-List-Id: <linux-rdma.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250515191213.GA612809@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: d0706bfd3ee40923c001c6827b786a309e2a8713
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4d0be1aa26b7dba4960c37d9f8d695eb513bb04d
Message-Id: <174734112177.3241512.2020572692437195548.pr-tracker-bot@kernel.org>
Date: Thu, 15 May 2025 20:32:01 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 15 May 2025 16:12:13 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4d0be1aa26b7dba4960c37d9f8d695eb513bb04d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
