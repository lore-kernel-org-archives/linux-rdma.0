Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94A43542C3;
	Fri, 13 Feb 2026 10:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770980365; cv=none; b=NU95e2QKCGVWdyqKdXVz9XDsDQXvgSUoz1rOW5ooYgAhBztni+I6XSK83v5agW3E9LqB74qaKExaNNNGCb3DK8VRgUpCRRxM0d93Q+63H3HH3Q4HN1Oeb0eiVx2/HQPDqu6myJWZ00W9co8YksmnpxmsHuvmkNtvY3XNG9UpLVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770980365; c=relaxed/simple;
	bh=1ErXtXjMtbxeTxtvFK/BCqEq2E/Df+Cbp/EEhtbCYwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lXZwvAygOEmnguoUqAa32dcXOHi7fLS/42+gVeqH0B7N7u8/cfihLmSz3zv3XWuGGpNnEzb13x9qFUy+mRXaH+RiRQYb5gE/4CW6y4fwvP4boiofD9DLUfEWJ3gFTZzGrh084A/kP08jmWCs6krPyjklntQ2GcaPirZrLJr4Hc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JWRlqrA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JWRlqrA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793ACC19423;
	Fri, 13 Feb 2026 10:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770980365;
	bh=1ErXtXjMtbxeTxtvFK/BCqEq2E/Df+Cbp/EEhtbCYwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JWRlqrA+hjIuJXjGlavduge9xrmc9R6N4iPtT+JKX9L3u1qXXfFnsiwXZlG6KcbpW
	 NjQMkF5wczKXvUHw4zrur1PefrhSyzQzgN5IzJTdHZigfnG9MvDd3z2BVqBOO1SnVj
	 W4MWypDpp7jPAwpqvCzUcrudHfpeg/DLXjRQNKNKNoqTThJhVeT5UyIzzS5EL/F9r1
	 tCVGg+lG+JbLXkGDoSDxpX+QKbMntxcmgI2WPCvzTrYxJDWwjFeo6IJQnA0dAXZt3Q
	 Pyq6acssg/uhjzaYODOW4S0g2lnAPIPIRarIjAMHzBzLN0XDIx7eEB6fw50tEBM/rY
	 KAhsemOP1NIQw==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Michael Margolin <mrgolin@amazon.com>,
	Gal Pressman <gal.pressman@linux.dev>,
	Yossi Leybovich <sleybo@amazon.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Kai Shen <kaishen@linux.alibaba.com>,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Allen Hubbe <allen.hubbe@amd.com>,
	Krzysztof Czurylo <krzysztof.czurylo@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Long Li <longli@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michal Kalderon <mkalderon@marvell.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Christian Benvenuti <benve@cisco.com>,
	Nelson Escobar <neescoba@cisco.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org
Subject: [PATCH rdma-next 09/50] RDMA/efa: Remove check for zero CQE count
Date: Fri, 13 Feb 2026 12:57:45 +0200
Message-ID: <20260213-refactor-umem-v1-9-f3be85847922@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213-refactor-umem-v1-0-f3be85847922@nvidia.com>
References: <20260213-refactor-umem-v1-0-f3be85847922@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-47773
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Since ib_core now handles validation, the device driver no longer needs
to verify that the CQE count is non‑zero.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/efa/efa_verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index d465e6acfe3c..e8fb99b61be8 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -1152,9 +1152,9 @@ int efa_create_user_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	if (attr->flags)
 		return -EOPNOTSUPP;
 
-	if (entries < 1 || entries > dev->dev_attr.max_cq_depth) {
+	if (entries > dev->dev_attr.max_cq_depth) {
 		ibdev_dbg(ibdev,
-			  "cq: requested entries[%u] non-positive or greater than max[%u]\n",
+			  "cq: requested entries[%u] greater than max[%u]\n",
 			  entries, dev->dev_attr.max_cq_depth);
 		err = -EINVAL;
 		goto err_out;

-- 
2.52.0

