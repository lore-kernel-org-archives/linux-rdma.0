Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77EF49B5DC;
	Mon, 14 Sep 2026 18:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789409318; cv=none; b=rIcfSqSYzCE3jt2YVENjDwC/FNOs0J5EmZnaX1zHO+MtFxZVDxj91EPK6y4gcCdv74b7ANEAlJDxNv8JBYzgACHd7HAuIoMyKLxbpiVIO3SJxqUw+4VyqKqaAMPxDqY52nPA/f7I8msm99DPau31gFVjiSSLQRNl4mjsTkvE/E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789409318; c=relaxed/simple;
	bh=sf7ipr2QkRZfmQH/qIgHGlKZ5hiIDkZH3TtlTy9BTPI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=u2xR78OWjy5qLlyceQgDmQmhQXRgP9AjKdRJ3B8//XrTLWVxOYkPUtW6D8BPLxpe65PG13EwQCNBq/Xu6uvzo0vrcX4luHTW2nq2geidEs4bqhGiQVFOQAa8eZ7y+7AbEUhb7fv4swsdgqbe59JCzVvzb+GVN+4Z3HXRKubxjRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DkLsSy/6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DkLsSy/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF201F0089C;
	Mon, 14 Sep 2026 18:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789409311;
	bh=COdzCKbl7G3sxY7yIgHzs4LOxZq4G6fs9cDZVvuSTy8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=DkLsSy/6wL9jcR9M1x3vmleQPWy4jT1cN9cB9N9Tl6TgIdB95tD2sVNBcqVSPBBCW
	 9HNuaIqC6jPSYsmnIEJ1OQKYxcUiX1Vuut7nUNIDk497og/6q9MJ4VhMO/h6Ym1XwY
	 nMgIouzupIcCjl8wm9IbqrftZHBHy13wgGSGPhjqwjtFQOLcfX/EfWvivzCTR0rVSo
	 oMJk/gQH1qrD7Elpkl9UvlRXFdX2aUK79SK4YCNxTGbEvEKzP9feSLLbqpi36uxU0A
	 SE6QIcspAbaJQhEchVxMDI1KhZjv9WGbt2rx2zMO776y0pmkKhdu9tKJ6rPMVKn4Fs
	 cRwJiSWFViaYg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 199673924FD1;
	Mon, 14 Sep 2026 18:07:28 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260914134756.GA192443@nvidia.com>
References: <20260914134756.GA192443@nvidia.com>
X-PR-Tracked-List-Id: <linux-rdma.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260914134756.GA192443@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: 9ff797e516dbc1ecb73701ec4c24055712d44411
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 01414b70cb6f7a5911b65de0cc97225061f60a59
Message-Id: <178940924653.1155813.14654914457431084156.pr-tracker-bot@kernel.org>
Date: Mon, 14 Sep 2026 18:07:26 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 14 Sep 2026 10:47:56 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/01414b70cb6f7a5911b65de0cc97225061f60a59

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
