Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE33B4C14FB;
	Thu, 15 Oct 2026 11:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792065550; cv=none; b=ltHXwugpvGwGo4PdVopwrAcHgk+3Ls05vw0KJYTJ949cw0Ly8jbIIjWU6j/V0QN5H0NgIX0I3Cl4Gm25HUZyFeYRCuXRZppptFYJlERBe5P4EeEpQTQyMIeRvvLRabFGasLMnJllNDqL0pSfs/iUacWABBkN1wxkXbfST+8OHcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792065550; c=relaxed/simple;
	bh=oHB+m9Em4iom6/5Lr8z5gmfr5PZ7UoFlINzQjn9aH24=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ah1SkuHJ0JIxJ6DVGMFh7u3PgvqGfCe6ghN+vSH0x4E5rS3Q5YTaHUcJJspaKFERCUBjS2w7g75D8UPQdxu9BmvQ7F7199z48ID6V06zZ1qakMKHmFZHrNfc7ZR62oRV/iW6OyIUwE45qYePFQSN7js50Bix5O90vJqg88cvhMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=grEBkmW3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="grEBkmW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C031F000C5;
	Thu, 15 Oct 2026 11:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792065549;
	bh=Lz/T6/3RXRCMtLYmODOqsjalGLRJMLnPv6r0UK8yVvM=;
	h=From:To:Cc:Subject:Date;
	b=grEBkmW3FVahBRlUL2QQrIQVpyS6WJMQ2UeRvhQoPRqooUu6Yr9XrVqpYEQksCcXh
	 GjnG5sGfl7ZWvhtvUwvSFkd/5MNVI4GamxXGdheMuC4xst4AFbsG6ersRzTAowxNFc
	 RAZFLBIw8mWEumllG6bhKCgcOBseOxj/oy47ZAiOUcBDy1WlHqZD36OmSYQ/dhHO4o
	 nsxoNVr0xs82BRE3N1n5AByTBtg4CQAz+msw8u7fml6Dm+Bja3qwfncf8cf3cY9lse
	 ZqYbAbSYoDGzfSfQwgXcM9/B+jKgManPh4OMShu6KBnpDGesuFd30qadwBbejP3Ggz
	 AMVJZubriqLDA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Maor Gottlieb <maorg@mellanox.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next 0/3] Various core fixes spotted by LLMs
Date: Thu, 15 Oct 2026 14:58:59 +0300
Message-ID: <20261015-ib-core-fixes-v1-0-60f6da3ddec3@nvidia.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20261015-ib-core-fixes-fa78b7068672
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

A batch of core fixes for various issues identified by LLMs.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Leon Romanovsky (3):
      RDMA/core: Preserve the selected source GID on failed AH modification
      RDMA/core: Free unpublished port statistics after initial-read failure
      RDMA/core: Reject LAG selection when source MAC lookup fails

 drivers/infiniband/core/lag.c   | 12 ++++++++----
 drivers/infiniband/core/sysfs.c |  9 +++++++--
 drivers/infiniband/core/verbs.c |  3 ++-
 3 files changed, 17 insertions(+), 7 deletions(-)
---
base-commit: 66196a559be5963b1ced18418c876caf9bfb76e6
change-id: 20261015-ib-core-fixes-fa78b7068672

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>

