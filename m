Received: from mail-m3274.qiye.163.com (mail-m3274.qiye.163.com [220.197.32.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079B62E03F1;
	Wed, 12 Aug 2026 05:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.32.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786514369; cv=none; b=c1H0cS326dxLKzuHCiYZTOWaLZrR1bnkWSnG9gRgDo1RAOx0T6E0vF1ZI43pZccBNwEkaeVep5y+SwNkQb/fEIkno+FbPH1VEp6kjv0DEiFMfRCFEAGshQ/8Azi4ZJ1BiQDNd0zsUP3Wcu9xCcq80cCgnn5ljegauz8JIVOD+Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786514369; c=relaxed/simple;
	bh=L4fm2+/1gDktIeXIBNv8QxMzpkNjnBrmVzcMd3xPK4Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=INpdZg4CM4nXHEnnlvKjFXK9Mk+ML96cqPl5KvRJi6VZZq/Lluz2S8Vu5Kk/cYGKnjBFTfxSFWJb82rNbgDnI8I4FlqJeF/VTvzzMk5ZGiBy1fpd6v/C/JAhDEbqjYjhS275o6oAxacE1tecBWzI0o1F2AgSdfeOp6QfT321sz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnics.com; spf=pass smtp.mailfrom=resnics.com; arc=none smtp.client-ip=220.197.32.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnics.com
Received: from localhost.localdomain (unknown [125.122.194.151])
	by smtp.qiye.163.com (Hmail) with ESMTP id 49a9ad22c;
	Wed, 12 Aug 2026 11:36:55 +0800 (GMT+08:00)
From: Ruizhe Zhou <zhouruizhe@resnics.com>
To: linux-rdma@vger.kernel.org
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-kernel@vger.kernel.org,
	Ruizhe Zhou <zhouruizhe@resnics.com>
Subject: [PATCH 0/2] RDMA: Remove obsolete 32-bit DMA mask fallbacks
Date: Wed, 12 Aug 2026 11:36:45 +0800
Message-Id: <20260812033647.2281547-1-zhouruizhe@resnics.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9ff40b671503ackunm50c275441ed2a6
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZThhJVkIeH08aGE1MTUwfS1YVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU5VSklJVUpCT1VKTkpZV1kWGg8SFR0UWUFZS1VLVU
	tVS1kG

hfi1 and mlx5 data direct both set a 64-bit DMA mask and retry with a
32-bit mask if the first call fails. This treats the return value of
dma_set_mask_and_coherent() as an indication that the platform requires
a narrower DMA width.

That is not a correct interpretation of dma_set_mask_and_coherent().
The mask describes the DMA addresses the device can accept and constrains
subsequent mappings to that range. A 64-bit mask includes every address
permitted by a 32-bit mask, including addresses from a platform that only
produces 32-bit DMA addresses. Retrying with 32 bits therefore adds a stricter
constraint and cannot correct a failure to establish the 64-bit mask.
The DMA API HOWTO explicitly calls this fallback pattern incorrect [1].
See [2] and [3] for details.

This series removes both fallbacks while retaining the return-value
checks. DMA setup errors are still reported and still abort device
initialization.

Testing was compile-only. No hardware testing was performed.

[1] DMA API HOWTO, "DMA addressing capabilities"
https://docs.kernel.org/core-api/dma-api-howto.html#dma-addressing-capabilities

[2] DMA direct addressability change, commit 91ef26f91417
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=91ef26f914171cf753330f13724fd9142b5b1640

[3] DMA HOWTO correction, commit f7ae20f2fc4e
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f7ae20f2fc4e

Ruizhe Zhou (2):
  RDMA/hfi1: Remove obsolete 32-bit DMA mask fallback
  RDMA/mlx5: Remove obsolete 32-bit DMA mask fallback

 drivers/infiniband/hw/hfi1/pcie.c        | 14 +++-----------
 drivers/infiniband/hw/mlx5/data_direct.c | 10 +++-------
 2 files changed, 6 insertions(+), 18 deletions(-)


base-commit: a12d9145145b21c50531afb6e3f711b1f34e1465
--
2.27.0
