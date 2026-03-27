Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577F8395261;
	Fri, 27 Mar 2026 20:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774644004; cv=none; b=YBcDTGDkUaDUgUBVAeYxqMdnH5D7iwrf1GkFs2f+vbhjc0Q/dqNlTmz5HxXhg7mi9FTuXNYsRsqm6zY/6AEqux7Bq80svDes92dqhI9p27T7ise6dJrs+W9Sy4P7ZQgG8TlTOMc40SQbJM2fiKDlsPdTg+7bPxVZDlK0YSieXXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774644004; c=relaxed/simple;
	bh=RQMAAZwY0bq/NFWwUwY26cDuBhb/pYkHTZ9ga8dwFYw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=j87e9Y8k60668WGMqm7ApeVBJUM1+2YRa8YsWBVzimIBvwhFfNWJUXb+S003RK+u5EW7hoAIO/00wXooVqcemnW13ovY1G2cRGBPF87MGGxhEszutyzWn1L9umwAsMpgWJ167clDFFYS+6SffWeWl0Gh4IiLPdT/8vvXMxRR+jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eUMieCM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eUMieCM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6D5C19423;
	Fri, 27 Mar 2026 20:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774644004;
	bh=RQMAAZwY0bq/NFWwUwY26cDuBhb/pYkHTZ9ga8dwFYw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=eUMieCM4Ohw6swwOc0aRoUDLjMwtgXVChloG8ba0msdjtDK9EK9dZ6bCexDtk3zkd
	 Y/UqHYWTLm8pjMIOH8UGySew1SYDB4wagAJzcsARR2y3tYvTrgUbV29870CmXVuHF1
	 54QfE3MgGWzKeuwb/uWB5O/MSvlWplnR7rCBVe5KBcbqF7IJlaQE81tA/tRcSV977V
	 qaZxnrWZP0kOJHXk0GOBJDcWgHp/QOfd31WFx2vNw9Qskyq6VOeX7FGzNOeWID1Y4f
	 0VHjIdbq2+rNq1XSA7ItyQh5MG5njSDdOk8EowH293V90vlrXBhWP91AHrGSCPdTky
	 N/6GnCe/HUfnA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FE7C3806928;
	Fri, 27 Mar 2026 20:39:51 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260327150924.GA361486@nvidia.com>
References: <20260327150924.GA361486@nvidia.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260327150924.GA361486@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: e37afcb56ae070477741fe2d6e61fc0c542cce2d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7df48e36313029e4c0907b2023905dd7213fd678
Message-Id: <177464398980.3654421.7108849590572451979.pr-tracker-bot@kernel.org>
Date: Fri, 27 Mar 2026 20:39:49 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 27 Mar 2026 12:09:24 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7df48e36313029e4c0907b2023905dd7213fd678

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
