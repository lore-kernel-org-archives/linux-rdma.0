Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456F83559DA;
	Fri, 13 Feb 2026 10:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770980377; cv=none; b=W1L6C/7G7GpCDUPZVPLSwt3Hv/byfx2PTw+luKRDpwcjR01B8KSrSuu75+Xzdtmxknx67nuQ47fKhruFutTO4ZNPPGMnWDxTuGCt2C3Y48xdWw35j8KSSd0WTWUzC+YNPzQwe3uUQzUMVbHGI29mLxeIdEXGtMPI4MxGrWFQe3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770980377; c=relaxed/simple;
	bh=2cJ/2G3yJQf9uq5dUHoj/dBMQbpJF7L8DGWnhKjqzU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p+1tz0gNBYzsRGlPc6koekOZdC7hQcHPBvBUiAjRDWeyQE6rZ865biKLlJh8Zst0UA72dyk8vcF+Vxb+OcaGxQyNPVNuXF0i1ScZ0OtygTQ27taAfrkHEVcCAcCgOTdJM7uyL7jFWk5zJUKCyDiwaE44U6a8X1FspTH3iOiID+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nRl5BlrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nRl5BlrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CCAC116C6;
	Fri, 13 Feb 2026 10:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770980376;
	bh=2cJ/2G3yJQf9uq5dUHoj/dBMQbpJF7L8DGWnhKjqzU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRl5BlrGaVvfG9Cs/mFmkYuol0KmH1YCBzQihNoDehDGG+6r52y6mgyuylyp2FEl1
	 99NZdX2hpBtynHOabD/lDnglkRV8Oju9SZ7yB4pXPehEjdQ/Q2hoFgR7jiQ1QEJxar
	 rH7X1tbWeNEUmIeljKaq/EzK3EYTZXx6TcmiC7d7TDdSBgeLsLWOScCF54tGiZ4nDS
	 /J3Iqz3DGprT3qYTBjVCD5KbgQrb0FuO0q24BwQwlx8NQUSAs1nmEppuUME5xLnVaQ
	 T/VVcFSubN5AAw6r9UfBoEZe9LtQ0oTDwq3fi7eo6KzTy0F8XU00+oWgYXYYEswTwT
	 p8cPEBu3sHpOA==
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
Subject: [PATCH rdma-next 10/50] RDMA/mlx5: Save 4 bytes in CQ structure
Date: Fri, 13 Feb 2026 12:57:46 +0200
Message-ID: <20260213-refactor-umem-v1-10-f3be85847922@nvidia.com>
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

There is no need to maintain separate, nearly empty create_flags and
private_flags fields. Unifying them reduces memory usage.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cq.c      | 5 +++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 2 +-
 drivers/infiniband/hw/mlx5/qp.c      | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 651d76bca114..1b4290166e87 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -983,7 +983,8 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	spin_lock_init(&cq->lock);
 	cq->resize_buf = NULL;
 	cq->resize_umem = NULL;
-	cq->create_flags = attr->flags;
+	if (attr->flags & IB_UVERBS_CQ_FLAGS_TIMESTAMP_COMPLETION)
+		cq->private_flags |= MLX5_IB_CQ_PR_TIMESTAMP_COMPLETION;
 	INIT_LIST_HEAD(&cq->list_send_qp);
 	INIT_LIST_HEAD(&cq->list_recv_qp);
 
@@ -1017,7 +1018,7 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	MLX5_SET(cqc, cqc, uar_page, index);
 	MLX5_SET(cqc, cqc, c_eqn_or_apu_element, eqn);
 	MLX5_SET64(cqc, cqc, dbr_addr, cq->db.dma);
-	if (cq->create_flags & IB_UVERBS_CQ_FLAGS_IGNORE_OVERRUN)
+	if (attr->flags & IB_UVERBS_CQ_FLAGS_IGNORE_OVERRUN)
 		MLX5_SET(cqc, cqc, oi, 1);
 
 	if (udata) {
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 4f4114d95130..ce3372aea48b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -561,6 +561,7 @@ struct mlx5_ib_cq_buf {
 enum mlx5_ib_cq_pr_flags {
 	MLX5_IB_CQ_PR_FLAGS_CQE_128_PAD	= 1 << 0,
 	MLX5_IB_CQ_PR_FLAGS_REAL_TIME_TS = 1 << 1,
+	MLX5_IB_CQ_PR_TIMESTAMP_COMPLETION = 1 << 2,
 };
 
 struct mlx5_ib_cq {
@@ -581,7 +582,6 @@ struct mlx5_ib_cq {
 	int			cqe_size;
 	struct list_head	list_send_qp;
 	struct list_head	list_recv_qp;
-	u32			create_flags;
 	struct list_head	wc_list;
 	enum ib_cq_notify_flags notify_flags;
 	struct work_struct	notify_work;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 0324909e3151..7af09e668c4c 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1274,7 +1274,7 @@ static int get_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
 		}
 		return MLX5_TIMESTAMP_FORMAT_REAL_TIME;
 	}
-	if (cq->create_flags & IB_UVERBS_CQ_FLAGS_TIMESTAMP_COMPLETION) {
+	if (cq->private_flags & MLX5_IB_CQ_PR_TIMESTAMP_COMPLETION) {
 		if (!fr_sup) {
 			mlx5_ib_dbg(dev,
 				    "Free running TS format is not supported\n");

-- 
2.52.0

