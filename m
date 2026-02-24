Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A203644B6
	for <linux-rdma@vger.kernel.org>; Tue, 24 Feb 2026 10:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771929596; cv=none; b=kHE8eHFrVDJ57xjcoorENf1tvYsbG8JTRyELlfxWvtJygLbpsgX5pM4Y7tX/6Si8FsmaY79YmeP3694VypXn1G1rvoACKHpF/RmMvQYdrxC+IMUhJq2bafND7Ho6i6s39azaSQTiQLUuT6vrJkWfzGm8lEkCnAOGbLqqqeuIgpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771929596; c=relaxed/simple;
	bh=mXwG8eaAtnAAecPhWA1vfxqemKqqFiNftAxJdU1WhzU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=i6DZ57QYISjfpeP7xDF6bpIUHwxJ46TRaIAEbVgj9W4aFUFc83E/e1tUlATVQYgiPOq/l8vilscK44n9ffoJ1X8FMuM5Rj1R4ItCi9fCCMqiUXKiYa++/SQPS3UP7XoN5C3OjG0IRe0EdAnb7LpfiRZZnxiB69lBRtL06J3uKfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I+mMvLl+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I+mMvLl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A770C19422;
	Tue, 24 Feb 2026 10:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771929595;
	bh=mXwG8eaAtnAAecPhWA1vfxqemKqqFiNftAxJdU1WhzU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=I+mMvLl+tHPWWC+RD8MCg7QfYlWOBEXO+pP8DTJxO4tjUc2ZuJfYJezyUvj7NX0G5
	 KzpMuZGXRxdvaQOL+grFW/7onIClm+O+Qvprwtaevmf+8JG/xm3MAdWWJzYe3ssKO2
	 z9yMX+3+hy+8fIOb36uCA1NgACEPYwmnw2DeDj4gDWxbWenmckpMfTV8TzzAsDPjo3
	 tbsWTnfMA+o2n3qt/8qepYfQE3pdzcwwVOUD5npxUaoFu1xNPb+8DD787YTTkQKRGc
	 SSGnbMq0xqEfIBQ+aSucviiE3Lg4PqdVod5x3vlzrgsvga1JvyvVWPNiPOBFNdQuXz
	 YzfUP+7Dek8sA==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
In-Reply-To: <20260224003149.3175815-1-rdunlap@infradead.org>
References: <20260224003149.3175815-1-rdunlap@infradead.org>
Subject: Re: [PATCH] RDMA/restrack: fix kernel-doc indicator
Message-Id: <177192959285.751672.4961806611041724210.b4-ty@kernel.org>
Date: Tue, 24 Feb 2026 05:39:52 -0500
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-47773


On Mon, 23 Feb 2026 16:31:49 -0800, Randy Dunlap wrote:
> Use "/**" to begin kernel-doc comments. This eliminates these
> kernel-doc warnings:
> 
> Warning: include/rdma/restrack.h:123 struct member 'kref' not described in
>  'rdma_restrack_entry'
> Warning: include/rdma/restrack.h:123 struct member 'comp' not described in
>  'rdma_restrack_entry'
> 
> [...]

Applied, thanks!

[1/1] RDMA/restrack: fix kernel-doc indicator
      https://git.kernel.org/rdma/rdma/c/2865500db9339b

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

