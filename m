Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130E635A92B;
	Fri, 13 Feb 2026 11:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770980457; cv=none; b=WMlLNdWstPmtq7vKa9RsA2WVIDosrjRXmnNKtulgVggxanUccC3Tr3xGOyo/2QcW6YwCDRZcYXqfYimMN8LHNzKfG9h6MUX4x9mfrAtcRIYbM9sCvpM4AwmYedL4xjrpiNeeKnfhaQJKo+63Wqlb/JflLv+TTYkXE6V/9gQf9ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770980457; c=relaxed/simple;
	bh=BLfJ8z/WpaD4K6sejQn96Wb7dREUsgFWZySiBeQGF9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qpa5zaxzACKHYxkb1kmWHtcS6jen3hm1ajtqNgcc3dC5mZPerQFIrCFv5SdEBzvKoiw14UkKhUu+TVtrwwzeqGaktNLwkxcjOoyqD7GV3YTR0rmGr/nEyz4ewxaPzQ8fquNFnQVRtwmj+HQqIZKkSAbNwbJ578m1W9yaK11xu/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EPYdIPJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EPYdIPJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58A7C116C6;
	Fri, 13 Feb 2026 11:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770980456;
	bh=BLfJ8z/WpaD4K6sejQn96Wb7dREUsgFWZySiBeQGF9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPYdIPJBMbg5urgKDzfQeMyEA2s+G6InhG9YxUmme1Z1gXjttYwTpANTnGCF81Rvb
	 kQqFo4Zp6YYsbhlY9LpC4/e/bML7aH4u25piPRXi5+y/IJLgnuRnqu50l5MTo2vsue
	 FZg+m3AtEe3I5kqFSEpqr0LG2Ao0vRJ0oVca427aSsyLQj//08Oj/SgQbNhAv0ssDK
	 Ye4fjm1ts5N1dfq1tnFSc+Biz1ZO9F9CTu1nb1wiEiIR3KZgjU/qhJfIngnSF1okww
	 VdNW9Ib7zFUpQ5C0ptbPDGjWo1htRv0utxrKnqqI8TIaGaSbZyJWwdom4GFkH2J0oR
	 oNFagAdf3tmRw==
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
Subject: [PATCH rdma-next 33/50] RDMA/bnxt_re: Drop support for resizing kernel CQs
Date: Fri, 13 Feb 2026 12:58:09 +0200
Message-ID: <20260213-refactor-umem-v1-33-f3be85847922@nvidia.com>
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

There are no ULP callers that use the CQ resize functionality, so remove it.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index b8516d8b8426..16bb586d68c7 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3338,10 +3338,6 @@ int bnxt_re_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
 	cq =  container_of(ibcq, struct bnxt_re_cq, ib_cq);
 	rdev = cq->rdev;
 	dev_attr = rdev->dev_attr;
-	if (!ibcq->uobject) {
-		ibdev_err(&rdev->ibdev, "Kernel CQ Resize not supported");
-		return -EOPNOTSUPP;
-	}
 
 	if (cq->resize_umem) {
 		ibdev_err(&rdev->ibdev, "Resize CQ %#x failed - Busy",
@@ -3375,7 +3371,7 @@ int bnxt_re_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
 		ibdev_err(&rdev->ibdev, "%s: ib_umem_get failed! rc = %pe\n",
 			  __func__, cq->resize_umem);
 		cq->resize_umem = NULL;
-		goto fail;
+		return rc;
 	}
 	cq->resize_cqe = entries;
 	memcpy(&sg_info, &cq->qplib_cq.sg_info, sizeof(sg_info));
@@ -3399,13 +3395,11 @@ int bnxt_re_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
 	return 0;
 
 fail:
-	if (cq->resize_umem) {
-		ib_umem_release(cq->resize_umem);
-		cq->resize_umem = NULL;
-		cq->resize_cqe = 0;
-		memcpy(&cq->qplib_cq.sg_info, &sg_info, sizeof(sg_info));
-		cq->qplib_cq.dpi = orig_dpi;
-	}
+	ib_umem_release(cq->resize_umem);
+	cq->resize_umem = NULL;
+	cq->resize_cqe = 0;
+	memcpy(&cq->qplib_cq.sg_info, &sg_info, sizeof(sg_info));
+	cq->qplib_cq.dpi = orig_dpi;
 	return rc;
 }
 

-- 
2.52.0

