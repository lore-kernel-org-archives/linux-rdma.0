Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7A4375F96;
	Sun, 18 Oct 2026 11:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792324791; cv=none; b=FafOCBAK8RR1TMRxhBAzTTvdD9HK9cZNLwUtYY2BJPwsOJZDtjteE3u4dGSKLsdT33ljCSnB4oJbwJigjAi0GJwqHhQsu0cZaKD2DIFkft8Z1yDz9JlUm7JIudlBYHJs91WJqKFS5IPUO5yFMo3//njXxK7zgrgh6gCJvc0Mob8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792324791; c=relaxed/simple;
	bh=9sT1efmub1RW1Gg0n0bv3/x9+e9w0l4WZqQwWFdMKnY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=OtEdTdhdNF1gbNf1ul1zPYMlEVBGqw9npG0kSs7xAu54go7zIneeD5/6L8ZcbHpAyfIBV7Bg1Dv9aRMW8uT+wSgiakB9AVT1iVcYzDXnFTjDkqNWIqr4D2pUSuMSMJkdsAzztn9Vg3IzWOob/dQ/29S2poRaIKZVnhAeceAaHjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAE21F000C4;
	Sun, 18 Oct 2026 11:59:49 +0000 (UTC)
From: Leon Romanovsky <leonro@nvidia.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Maor Gottlieb <maorg@mellanox.com>, 
 Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261015-ib-core-fixes-v1-0-60f6da3ddec3@nvidia.com>
References: <20261015-ib-core-fixes-v1-0-60f6da3ddec3@nvidia.com>
Subject: Re: [PATCH rdma-next 0/3] Various core fixes spotted by LLMs
Message-Id: <179232478713.19398.1144404660581532479.b4-ty@nvidia.com>
Date: Sun, 18 Oct 2026 07:59:47 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 15 Oct 2026 14:58:59 +0300, Leon Romanovsky wrote:
> A batch of core fixes for various issues identified by LLMs.

Applied, thanks!

[1/3] RDMA/core: Preserve the selected source GID on failed AH modification
      https://git.kernel.org/rdma/rdma/c/d01ee4c8419319
[2/3] RDMA/core: Free unpublished port statistics after initial-read failure
      https://git.kernel.org/rdma/rdma/c/d74bdcfa89fa45
[3/3] RDMA/core: Reject LAG selection when source MAC lookup fails
      https://git.kernel.org/rdma/rdma/c/fdfd099222d9de

Best regards,
-- 
Leon Romanovsky <leonro@nvidia.com>

