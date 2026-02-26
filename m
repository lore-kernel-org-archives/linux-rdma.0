Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41732263C9F;
	Thu, 26 Feb 2026 17:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772128422; cv=none; b=FirkggMkRxfH0xKMN0G26GgDEcUiQPZIh0uEXRnGvbcyg+aJT7eMqLW3T6g14MUFGXKXBAAzyGuQiXWDFvGe0y+NsJ5tjVA0OXidYmhrdJqiC5tH9keNeBHJEOIVThHMLM/0uILwDiEnfv/nz/dKOKQDQotyhxmgW99h+AuLa7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772128422; c=relaxed/simple;
	bh=e//X1PNdIUc8gkatTNwR9VHJM5Xr4p1mffBrWbetyuk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=GKCKBLGRaB4tX+uvWWVIOM1lbF6wqlkJXf8VHeMrKmk/UgjVOkWwAdKBY8E8+9wIj5i5bSEJErpbe97c7P0WIj5qHvdNavRl+bcRkRpNkfDBuM2zZ2OCwRDetIDXuK+TVRbC5ISkLzyTCi/Wbx0sEfaejNxTkTLY9QjQtlXATec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=brG8oYUf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="brG8oYUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260D7C19423;
	Thu, 26 Feb 2026 17:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772128422;
	bh=e//X1PNdIUc8gkatTNwR9VHJM5Xr4p1mffBrWbetyuk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=brG8oYUfhn4OTpc78lMCETKELyQxVNeCtlwrSSpOSEvQxLt2vj/GAQRO0Xp9akWZW
	 8//opos8zXB4vHOQsXwD5QlfgIdwHQFBLmXggn1jxz1Vcf2yKUgQuRudVE8SM2L7ti
	 BocJEQiySSFXheDSYCn0H531UsRDkT4emed6W94rrfSzTaojjOW9MMb8FfbxPx1Huf
	 +CzZiX2hNjoQNGzTfFxKDJ36CDecbmVZekhKeU62N+PiPcmuNcuKiU72QJQCQwnidJ
	 8/SvZSFoREF9MXngw7PFXcqwG7uQJNHD7DwbwiSlLcTgIJj+/J0vYFKxk00TQXnYjd
	 36epl/vQnn5Nw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA04C393093E;
	Thu, 26 Feb 2026 17:53:47 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260226153607.GA87547@nvidia.com>
References: <20260226153607.GA87547@nvidia.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260226153607.GA87547@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: 7c2889af823340d1d410939b9d547bf184d5fa54
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e3c81bae4f282a6be56bc22e05e2ce3dd92ae301
Message-Id: <177212842635.1769138.15260676896711243080.pr-tracker-bot@kernel.org>
Date: Thu, 26 Feb 2026 17:53:46 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 26 Feb 2026 11:36:07 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e3c81bae4f282a6be56bc22e05e2ce3dd92ae301

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
