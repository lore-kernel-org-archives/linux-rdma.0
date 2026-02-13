Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFF03570DF;
	Fri, 13 Feb 2026 10:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770980399; cv=none; b=Pjwm9FTjBcvs1rMJ8N22Fov4f7lW25gh3tcqhsdxhq56LawaKrSV7aLggCzOZ2sQCZ6Thqoax+k4hwErQSeMqsglyK7olkeQc8wZSJUlM2DbMVLaedOdaNVD0jbOGEAIdsYBLn1b31IbQSu4uRW3Lkbv8OOhGdbvpVLRRtfSMHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770980399; c=relaxed/simple;
	bh=7fFZ6JJEIyaVScCFaDNjSIxSR73zFnfTIaDDncJUwpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XUKclqHHPNZe9NRQIeCpHoeOxqzfgMHKAnMnKumdU5RrlakqSZQc8RFy9JD2loshIaV+64AcadKuMXYadYFT4huabD6KpLJ7LC8dCo8XyJF+Xm6V5KKDX8qYeUZseV/9NR+PvX1iqZS5cZW8fqZyk0Ww0VdFnROk75LIxwtV4ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVe7uFUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVe7uFUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7176C19424;
	Fri, 13 Feb 2026 10:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770980399;
	bh=7fFZ6JJEIyaVScCFaDNjSIxSR73zFnfTIaDDncJUwpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVe7uFUXrW3mJp3+JO5L26ZW5PE4SHXRB2eV4j1ZkpFXckh9dE4IE97lf7vKYcbLg
	 mNFFEjOJR5R3XIQdKApgLb2A7XIyaq1pZ9VW+XLW/y+kzdJ4DgSdnYWNT5s5BDE/ct
	 piFZuQv0JKmJPEOZHOtPpUqiGGnubxolnxdGZ4g/cPOEhMhx56VuDPnovadS1B3p4Y
	 93Yc0MQYw5TptU/WFqKab2VR4Be+o666fDsiJtR/XGEJg67wWQ/XmqhEIKSQmtu+rm
	 TQ42dA3/SDGY0zoEI0N/p25hYRjhiTxg9FOR9IYh8qY6/+cYYt8f8Z3eTUOFOAyTK+
	 J/14cimagEmeg==
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
Subject: [PATCH rdma-next 17/50] RDMA/mthca: Split user and kernel CQ creation paths
Date: Fri, 13 Feb 2026 12:57:53 +0200
Message-ID: <20260213-refactor-umem-v1-17-f3be85847922@nvidia.com>
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

Separate the create‑CQ logic into distinct user and kernel
code paths.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mthca/mthca_provider.c | 92 ++++++++++++++++++----------
 1 file changed, 58 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index aa5ca5c4ff77..6bf825978846 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -572,9 +572,9 @@ static int mthca_destroy_qp(struct ib_qp *qp, struct ib_udata *udata)
 	return 0;
 }
 
-static int mthca_create_cq(struct ib_cq *ibcq,
-			   const struct ib_cq_init_attr *attr,
-			   struct uverbs_attr_bundle *attrs)
+static int mthca_create_user_cq(struct ib_cq *ibcq,
+				const struct ib_cq_init_attr *attr,
+				struct uverbs_attr_bundle *attrs)
 {
 	struct ib_udata *udata = &attrs->driver_udata;
 	struct ib_device *ibdev = ibcq->device;
@@ -586,47 +586,41 @@ static int mthca_create_cq(struct ib_cq *ibcq,
 	struct mthca_ucontext *context = rdma_udata_to_drv_context(
 		udata, struct mthca_ucontext, ibucontext);
 
-	if (attr->flags)
+	if (attr->flags || ibcq->umem)
 		return -EOPNOTSUPP;
 
-	if (entries < 1 || entries > to_mdev(ibdev)->limits.max_cqes)
+	if (attr->cqe > to_mdev(ibdev)->limits.max_cqes)
 		return -EINVAL;
 
-	if (udata) {
-		if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd)))
-			return -EFAULT;
+	if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd)))
+		return -EFAULT;
 
-		err = mthca_map_user_db(to_mdev(ibdev), &context->uar,
-					context->db_tab, ucmd.set_db_index,
-					ucmd.set_db_page);
-		if (err)
-			return err;
+	err = mthca_map_user_db(to_mdev(ibdev), &context->uar,
+				context->db_tab, ucmd.set_db_index,
+				ucmd.set_db_page);
+	if (err)
+		return err;
 
-		err = mthca_map_user_db(to_mdev(ibdev), &context->uar,
-					context->db_tab, ucmd.arm_db_index,
-					ucmd.arm_db_page);
-		if (err)
-			goto err_unmap_set;
-	}
+	err = mthca_map_user_db(to_mdev(ibdev), &context->uar,
+				context->db_tab, ucmd.arm_db_index,
+				ucmd.arm_db_page);
+	if (err)
+		goto err_unmap_set;
 
 	cq = to_mcq(ibcq);
 
-	if (udata) {
-		cq->buf.mr.ibmr.lkey = ucmd.lkey;
-		cq->set_ci_db_index  = ucmd.set_db_index;
-		cq->arm_db_index     = ucmd.arm_db_index;
-	}
+	cq->buf.mr.ibmr.lkey = ucmd.lkey;
+	cq->set_ci_db_index  = ucmd.set_db_index;
+	cq->arm_db_index     = ucmd.arm_db_index;
 
 	for (nent = 1; nent <= entries; nent <<= 1)
 		; /* nothing */
 
-	err = mthca_init_cq(to_mdev(ibdev), nent, context,
-			    udata ? ucmd.pdn : to_mdev(ibdev)->driver_pd.pd_num,
-			    cq);
+	err = mthca_init_cq(to_mdev(ibdev), nent, context, ucmd.pdn, cq);
 	if (err)
 		goto err_unmap_arm;
 
-	if (udata && ib_copy_to_udata(udata, &cq->cqn, sizeof(__u32))) {
+	if (ib_copy_to_udata(udata, &cq->cqn, sizeof(__u32))) {
 		mthca_free_cq(to_mdev(ibdev), cq);
 		err = -EFAULT;
 		goto err_unmap_arm;
@@ -637,18 +631,47 @@ static int mthca_create_cq(struct ib_cq *ibcq,
 	return 0;
 
 err_unmap_arm:
-	if (udata)
-		mthca_unmap_user_db(to_mdev(ibdev), &context->uar,
-				    context->db_tab, ucmd.arm_db_index);
+	mthca_unmap_user_db(to_mdev(ibdev), &context->uar,
+			    context->db_tab, ucmd.arm_db_index);
 
 err_unmap_set:
-	if (udata)
-		mthca_unmap_user_db(to_mdev(ibdev), &context->uar,
-				    context->db_tab, ucmd.set_db_index);
+	mthca_unmap_user_db(to_mdev(ibdev), &context->uar,
+			    context->db_tab, ucmd.set_db_index);
 
 	return err;
 }
 
+static int mthca_create_cq(struct ib_cq *ibcq,
+			   const struct ib_cq_init_attr *attr,
+			   struct uverbs_attr_bundle *attrs)
+{
+	struct ib_device *ibdev = ibcq->device;
+	int entries = attr->cqe;
+	struct mthca_cq *cq;
+	int nent;
+	int err;
+
+	if (attr->flags)
+		return -EOPNOTSUPP;
+
+	if (attr->cqe > to_mdev(ibdev)->limits.max_cqes)
+		return -EINVAL;
+
+	cq = to_mcq(ibcq);
+
+	for (nent = 1; nent <= entries; nent <<= 1)
+		; /* nothing */
+
+	err = mthca_init_cq(to_mdev(ibdev), nent, NULL,
+			    to_mdev(ibdev)->driver_pd.pd_num, cq);
+	if (err)
+		return err;
+
+	cq->resize_buf = NULL;
+
+	return 0;
+}
+
 static int mthca_alloc_resize_buf(struct mthca_dev *dev, struct mthca_cq *cq,
 				  int entries)
 {
@@ -1070,6 +1093,7 @@ static const struct ib_device_ops mthca_dev_ops = {
 	.attach_mcast = mthca_multicast_attach,
 	.create_ah = mthca_ah_create,
 	.create_cq = mthca_create_cq,
+	.create_user_cq = mthca_create_user_cq,
 	.create_qp = mthca_create_qp,
 	.dealloc_pd = mthca_dealloc_pd,
 	.dealloc_ucontext = mthca_dealloc_ucontext,

-- 
2.52.0

