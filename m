Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FCD2F1FDF;
	Mon, 29 Jun 2026 09:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782724553; cv=none; b=VZDV280eTlY8Lud8rFqC4kI+ZV/w/DSfrTCy/9EYGFO2AAkZlgYNipxJYZgyhpp6hvYp1pu6kZcyvrZ/w1YMOCYhN3yLVAHxgyYHA/kL2+lFRAECQMGk25plg6v1iLZ0NxtwkDedI4Cc7CIx2WSF47hHe1vfFbSfceb7C0UZ1ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782724553; c=relaxed/simple;
	bh=ryRgYHkNGY972RCbgM+WZ1KdnusNCcHgvsuuHV1frnM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dGtRvQdRcopKLudRfRPDF2FtioDKc6gsjP2StDwWvKWZSbeQZnBp5ICfTLD5lq/CChisvSu+UIc+Y2xTTPC58yrsVUpNEgyYJpqb2ZYUuyGYSyn/jJa1F+l6MYz2vBS5k5g/l/XnPCYMcn8ihsO7mnQiK0uCSSJMk89rTf2PccU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aWbjssu1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aWbjssu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF2F1F000E9;
	Mon, 29 Jun 2026 09:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782724551;
	bh=sbmS330Ug5DjTgLoCdpK6srxnQsGCOiAUMojyLJi5/E=;
	h=From:To:Cc:Subject:Date;
	b=aWbjssu16Ql9MazXfsYERLBmR6utXhx9ARCl6kqgeuvt6tHfXcZHC4z1FDMQ9CocR
	 2X/++D0mfUlVFYdLm20cU/eMs4J/7Q5vsk0dK8PhSqokfg9nJVlqmMPaUr70locF0j
	 XIBiJmAnm5meu4TdZPtT0fnCSG8kfokZVH1Oa4y81FiQO/BsRaVAeBcYYtlZIi64K2
	 FC3Nd8I32s+APKZpQjy8Wjdt8i5OnHw7AGYJ63AhXmWbMhOmsL0AnTHBFwpKlGP6wQ
	 aT5YCraMLvIvOyeVplRiUprwL9ewXLV5b858WcaIVuTb6z6ll+tt10bYgWKTQ72Tss
	 v0a/SaS0Pw8Mw==
From: Leon Romanovsky <leon@kernel.org>
To: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-rc] RDMA/mlx5: Remove kernel-doc warning in umr.c
Date: Mon, 29 Jun 2026 12:15:37 +0300
Message-ID: <20260629-kdoc-fix-v1-1-735a90dede7f@nvidia.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260625-kdoc-fix-ca7adb29732d
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Remove extra asterisk to avoid the following kernel-doc warning:

  Warning: drivers/infiniband/hw/mlx5/umr.c:986 This comment starts with '/**',
  but isn't a kernel-doc comment. Refer to Documentation/doc-guide/kernel-doc.rst

Fixes: e73242aa14d2 ("RDMA/mlx5: Optimize DMABUF mkey page size")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/umr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 48cae5cc1c1b..c595b85b428c 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -978,7 +978,7 @@ static inline int _mlx5r_dmabuf_umr_update_pas(struct mlx5_ib_mr *mr,
 						     start_block, nblocks);
 }
 
-/**
+/*
  * This function makes an mkey non-present by zapping the translation entries of
  * the mkey by zapping (zeroing out) the first N entries, where N is determined
  * by the largest page size supported by the device and the MR length.

---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260625-kdoc-fix-ca7adb29732d

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>

