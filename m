Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795209226;
	b=Uwwpzm4PCHEsD5nx1cWoIH6iqnKBN0hchOdsQ6d9jhsR9BMT+IB5NojvuzRKFgqIbfdw
	 fJmAKid6XYI7Y8sIf0h1GryMLbdd9tmdE/X8SaxZ8iZmyxdnWy2dIlG7Cs2E+u3DkMErj
	 jCpFkhssZZT9o8+wrnrspq7sO7/i5VvElRJ0D47wPioCVBBKN2r3LVD2/pxJS0aX/jh/J
	 OSxUR1DrfTIGEeFstSv8eOzz7Ez4JBWn442fU4uRtaIB1VJMnJBRXIS3wELrxt1DzU+Wx
	 YkSmZKk/SmOMc3wj8tkF3p51ADGm2DEguJBbXZViUmVznNNcOFwimopDSkXYR5KAFNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795209226;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=udUmcL8OS/qZ6Xc2/3Hxm/Oebllgp5jOdtKTK6H4flA=;
	b=wsjsgeie1WLlPlSaBB25q/PqxMvfwmozzjjHNQgzxNpRkWXNiiPYVxosp+l6dGhNHPOD
	 0NkKZKOOW0EvfiCOi7mLIAXMf/UQXmn+7/CT1osxjhltVGqFsTzXUkQvkQBQHn/I7TTLb
	 Lc8m1xanOpv6zaCL18kpbt/W7aAjjLErbXPUZ/+1RneYAvP9Tpu3mxMH1EWTmc0XZFjo0
	 rMDRvRXn+qM9+yn938VwK+FSmWKG3GrT6pi33zDW1qZOtrBt7PEeE+M6MohUiMRPfxCW8
	 1/F+tymMoZHbcQwNz+4BGXBfoFLLKwKSWCdcYP5s92sDoHxu3vBC9E/o9lvFUParCfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aq9DeN3c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2505D606A334;
	Fri, 20 Nov 2026 21:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aq9DeN3c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF6A1F000C4;
	Fri, 20 Nov 2026 21:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795209225;
	bh=udUmcL8OS/qZ6Xc2/3Hxm/Oebllgp5jOdtKTK6H4flA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=aq9DeN3c+Kc+ObzaJjaumhZfjqiPevpShpBAYdGtMlyEjjITiw5c9s32KRkhzyADJ
	 21EGTgxxozcNsCm5hgXDd9tjPj2t9t2lSvyGSBCM9tkusuRnuhhS+BazWevPY8ZB8D
	 4/Ds+oH45t1aPmjS5tB9nLDETMgqfmGmVgad+QlJwY7SEm29Q5JDVRZn76NyZd8grD
	 exZtMZv17ILkdFRqqf6+t7I/w078fJ7QnUBSfhTGc6yS2/fFmLRQwriTk6wsjgADb/
	 JQHjkxfWupwjLNeWGOsjeL/4JQhc6BKre+1Xr+gv+B8p3KRRwyt+sScPv9zdVpTuoF
	 SEHRaHCxKH1Tw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B4684380A964;
	Fri, 20 Nov 2026 21:13:45 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261120181351.GA1094775@nvidia.com>
References: <20261120181351.GA1094775@nvidia.com>
X-PR-Tracked-List-Id: <linux-rdma.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261120181351.GA1094775@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: e7732ec135b501e87ab060d992b3b5f2ec4396c9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ddefe07f600b89762853a50a61bb4ee0e3f864ed
Message-Id: <179520922432.792202.5010705704919249333.pr-tracker-bot@kernel.org>
Date: Fri, 20 Nov 2026 21:13:44 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Fri, 20 Nov 2026 14:13:51 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ddefe07f600b89762853a50a61bb4ee0e3f864ed

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
