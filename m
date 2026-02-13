Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA625357A37;
	Fri, 13 Feb 2026 11:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770980509; cv=none; b=XXA48fOctLEkyp/Bx/HESkSuRMLF60SA1RSjQW5j5ufY4r00D2YMwu3PxDVnbMGrnkhngBfidSEUMZOTC3V2Cu8Xg8P0aRthvus6+b1B+N1uW5ganq7DuVAZFrP8ARDRJ95TqOcGLfnIHjV5SFeX5vKo6wF2AR4DCznJieFekR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770980509; c=relaxed/simple;
	bh=lLHCx9P2BGRiklcIEpDq8X8RZoaLfrXAcvZBoAlyAtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nDblARFQqLvlcgjANbQrOODAR+qCcasOYymevjXX+kBdqo7GmFat6rmZ/pLdo0QFDMysaM8Fd+7i8qR8Ja1l67h/WC5Ky4YLVYYdgUuAhqjSaWQpk1trcJGxVZNHUkb7f2cn5OcSxo47CjCatwfXkHCD+atMpMG0knwITXeSR70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YHIyne8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YHIyne8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A2DC116C6;
	Fri, 13 Feb 2026 11:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770980509;
	bh=lLHCx9P2BGRiklcIEpDq8X8RZoaLfrXAcvZBoAlyAtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHIyne8uJHWl2oQrXX9a8i0T+gEfSU4DbwT5MkL9tbvrlHnCpXaeWg1fWMW2DAy/O
	 T4U383e/7A3coRlaSbJk8qDhyfY45qLdaiMDZwcmn7Tm7vMn7YMyWWtcbUtNF09HcA
	 4MsY663jgdfIpOnjgr9MWhATxlOJdTN4ZVxJ3gjmG1Y8WHsm/D/QchOT0c+DfeTfaD
	 TPf1ZbthhZRqI1dR4TgzueYzhMYkVwX7bOJbMnHRsOJk8OXNBYzlJcuf1FRL+/jaiI
	 IJ9m+o4gwrwdYhK6KYu5Br8GR7IDRX1foHsfwCQMWQs2ZluChz5vlgujeKMIrwrJ8K
	 PNsrHPtO4CzDQ==
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
Subject: [PATCH rdma-next 47/50] RDMA/mlx5: Use generic resize-CQ lock
Date: Fri, 13 Feb 2026 12:58:23 +0200
Message-ID: <20260213-refactor-umem-v1-47-f3be85847922@nvidia.com>
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

Replace the open‑coded resize‑CQ lock with the standard core
implementation for better consistency and maintainability.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cq.c      | 8 +-------
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 3 ---
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 78c3494517d7..f7fb6f4aef7d 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -972,7 +972,6 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
 		return -EINVAL;
 
 	cq->ibcq.cqe = entries - 1;
-	mutex_init(&cq->resize_mutex);
 	spin_lock_init(&cq->lock);
 	if (attr->flags & IB_UVERBS_CQ_FLAGS_TIMESTAMP_COMPLETION)
 		cq->private_flags |= MLX5_IB_CQ_PR_TIMESTAMP_COMPLETION;
@@ -1057,7 +1056,6 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		return -EINVAL;
 
 	cq->ibcq.cqe = entries - 1;
-	mutex_init(&cq->resize_mutex);
 	spin_lock_init(&cq->lock);
 	INIT_LIST_HEAD(&cq->list_send_qp);
 	INIT_LIST_HEAD(&cq->list_recv_qp);
@@ -1284,10 +1282,9 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 	if (entries == ibcq->cqe + 1)
 		return 0;
 
-	mutex_lock(&cq->resize_mutex);
 	err = resize_user(dev, cq, entries, udata, &cqe_size);
 	if (err)
-		goto ex;
+		return err;
 
 	page_size = mlx5_umem_find_best_cq_quantized_pgoff(
 		cq->resize_umem, cqc, log_page_size, MLX5_ADAPTER_PAGE_SHIFT,
@@ -1339,7 +1336,6 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 	ib_umem_release(cq->ibcq.umem);
 	cq->ibcq.umem = cq->resize_umem;
 	cq->resize_umem = NULL;
-	mutex_unlock(&cq->resize_mutex);
 
 	kvfree(in);
 	return 0;
@@ -1350,8 +1346,6 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
 ex_resize:
 	ib_umem_release(cq->resize_umem);
 	cq->resize_umem = NULL;
-ex:
-	mutex_unlock(&cq->resize_mutex);
 	return err;
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index e99a647ed62d..7b34f32b5ecb 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -574,9 +574,6 @@ struct mlx5_ib_cq {
 	 */
 	spinlock_t		lock;
 
-	/* protect resize cq
-	 */
-	struct mutex		resize_mutex;
 	struct mlx5_ib_cq_buf  *resize_buf;
 	struct ib_umem	       *resize_umem;
 	int			cqe_size;

-- 
2.52.0

