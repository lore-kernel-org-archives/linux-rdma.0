Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACD23D1CAA;
	Wed, 25 Feb 2026 13:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772027347; cv=none; b=P9Cjr4tsNsuGGlLlHFD4PXhqYRfBuxxHPZeJVxC8LtfJ+jeDvPIkxEJTwGcjTQNMR0g14eXIhBz2C4Q85kFw3Sw7KggaEDZrUkmdL5pcu7mNT27lBYbPTQAyJ5xpjuHBIjtbyeNd5gS1BS7B9929FsOZ4uRA5aqabOSmxasYDp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772027347; c=relaxed/simple;
	bh=L+FXSfFVZTWw/7cJ1b6EmaymixfTwFa7Sq/2AoPzxuU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ieVlqO29yyXjQ7TbcceqGfHAhIyPNPVXOc72iyLuRBogH3FR8WeDUuy4S8YOlF5DFof2tOoWSZK5ob12UWdGIzYZoIsG+34vw9SjTQYqI7Q8/06fzUAM05oBYhNSx3tgXEfvUqu+0lTwr+jh1rZud1VEuDJQXakg9QaoXZL2ir8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TsESe6Pz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TsESe6Pz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4518CC116D0;
	Wed, 25 Feb 2026 13:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772027346;
	bh=L+FXSfFVZTWw/7cJ1b6EmaymixfTwFa7Sq/2AoPzxuU=;
	h=From:To:Cc:Subject:Date:From;
	b=TsESe6PzhNEfVeu3a7vQ0RepTaIFoo4H5lQS2CVqzHApBGO+59XbSAs2uxnf2fHME
	 PUhARIusFn4T9f92JcehJoTCJyGAwJRt3+qf9PipXaWif4M3Rn3WwU156rY7xaaDtm
	 32ufrKw42UV8Mi62HJC1z7WtmAv62qLoWOVXhjttyGEH7Oa0r+AravnfsUnTEGtzmt
	 s0EL12VKeW3wHXAHV+/Q/KWGbvnsSd4NLPfeaWuVuk2zRxmSgVpFrhYukUBB8cTFoN
	 aR2LIQNZcZVfNjPXaW/MpTykXs+Gz6sysmJod8N0ul+blIO4ZZA80484emZqHFdana
	 yUQPOhPnIEoPg==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-rc] RDMA/uverbs: Import DMA-BUF module in uverbs_std_types_dmabuf file
Date: Wed, 25 Feb 2026 15:48:59 +0200
Message-ID: <20260225-fix-uverbs-compilation-v1-1-acf7b3d0f9fa@nvidia.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260225-fix-uverbs-compilation-d6668390275b
X-Mailer: b4 0.15-dev-47773
Content-Transfer-Encoding: quoted-printable

From: Leon Romanovsky <leonro@nvidia.com>=0D
=0D
Fix the following compilation error:=0D
=0D
ERROR: modpost: module ib_uverbs uses symbol dma_buf_move_notify=0D
	from namespace DMA_BUF, but does not import it.=0D
=0D
Fixes: 0ac6f4056c4a ("RDMA/uverbs: Add DMABUF object type and operations")=
=0D
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>=0D
---=0D
 drivers/infiniband/core/uverbs_std_types_dmabuf.c | 2 ++=0D
 1 file changed, 2 insertions(+)=0D
=0D
diff --git a/drivers/infiniband/core/uverbs_std_types_dmabuf.c b/drivers/in=
finiband/core/uverbs_std_types_dmabuf.c=0D
index dfdfcd1d1a44..4a7f8b6f9dc8 100644=0D
--- a/drivers/infiniband/core/uverbs_std_types_dmabuf.c=0D
+++ b/drivers/infiniband/core/uverbs_std_types_dmabuf.c=0D
@@ -10,6 +10,8 @@=0D
 #include "rdma_core.h"=0D
 #include "uverbs.h"=0D
 =0D
+MODULE_IMPORT_NS("DMA_BUF");=0D
+=0D
 static int uverbs_dmabuf_attach(struct dma_buf *dmabuf,=0D
 				struct dma_buf_attachment *attachment)=0D
 {=0D
=0D
---=0D
base-commit: 104016eb671e19709721c1b0048dd912dc2e96be=0D
change-id: 20260225-fix-uverbs-compilation-d6668390275b=0D
=0D
Best regards,=0D
--  =0D
Leon Romanovsky <leonro@nvidia.com>=0D
=0D
