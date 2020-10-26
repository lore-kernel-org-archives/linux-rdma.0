Return-Path: <SRS0=Cmar=EB=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D86C56202
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Oct 2020 13:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86C2A24650
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Oct 2020 13:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603718573;
	bh=x2mXMTjcThmtxtMQEdE0TLiSlSsrPl4ayjuNi09gjow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=m4ml2w0Kg3pyQAp1EU0vsikjr4b3c7jbG0WOS60aWOK2VLUmqEf+5jrZC2hckJ0hn
	 EKnUQk86J2Z+OhYtIg6klMD6aTRMAXmQ5ckOQupBCAMFm+mJCo9m/JrgrFNnBRoRPY
	 SH/58pFn95RdOi/QpbPiwI8HqwYWUxxHEtVXndn8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421242AbgJZNWu (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 26 Oct 2020 09:22:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1776991AbgJZNUA (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 26 Oct 2020 09:20:00 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D33222263;
        Mon, 26 Oct 2020 13:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603718399;
        bh=x2mXMTjcThmtxtMQEdE0TLiSlSsrPl4ayjuNi09gjow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nePx52/MOqJLLSbltNsvuU2LC7juNa2NWVMKhI0cveOeduJaBnRJ0IwED2WfvrsnD
         +M6+GPA0A5ew7CFRVSypTlhZPBrKHcsqf7S8zLpN0ewQu6qdoYmvTWcGrqLUfQefnM
         IF8Em4nu7ezGsUdzH/03FCkHoiSrjrP9Vt9uy12o=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Artemy Kovalyov <artemyko@mellanox.com>,
        linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 2/7] RDMA/mlx5: Fix corruption of reg_pages in mlx5_ib_rereg_user_mr()
Date:   Mon, 26 Oct 2020 15:19:31 +0200
Message-Id: <20201026131936.1335664-3-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201026131936.1335664-1-leon@kernel.org>
References: <20201026131936.1335664-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

reg_pages should always contain mr->npage since when the mr is finally
de-reg'd it is always subtracted out.

If there were any error exits then mlx5_ib_rereg_user_mr() would leave the
reg_pages adjusted and this will cause it to be double subtracted
eventually.

The manipulation of reg_pages is inherently connected to the umem, so lift
it out of set_mr_fields() and only adjust it around creating/destroying a
umem.

reg_pages is only used for diagnostics in sysfs.

Fixes: 7d0cc6edcc70 ("IB/mlx5: Add MR cache for large UMR regions")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mr.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index c9be69fcc1ea..769c5ae4894a 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1248,10 +1248,8 @@ static struct mlx5_ib_mr *reg_create(struct ib_mr *ibmr, struct ib_pd *pd,
 }
 
 static void set_mr_fields(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr,
-			  int npages, u64 length, int access_flags)
+			  u64 length, int access_flags)
 {
-	mr->npages = npages;
-	atomic_add(npages, &dev->mdev->priv.reg_pages);
 	mr->ibmr.lkey = mr->mmkey.key;
 	mr->ibmr.rkey = mr->mmkey.key;
 	mr->ibmr.length = length;
@@ -1291,8 +1289,7 @@ static struct ib_mr *mlx5_ib_get_dm_mr(struct ib_pd *pd, u64 start_addr,
 
 	kfree(in);
 
-	mr->umem = NULL;
-	set_mr_fields(dev, mr, 0, length, acc);
+	set_mr_fields(dev, mr, length, acc);
 
 	return &mr->ibmr;
 
@@ -1421,7 +1418,9 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	mlx5_ib_dbg(dev, "mkey 0x%x\n", mr->mmkey.key);
 
 	mr->umem = umem;
-	set_mr_fields(dev, mr, npages, length, access_flags);
+	mr->npages = npages;
+	atomic_add(mr->npages, &dev->mdev->priv.reg_pages);
+	set_mr_fields(dev, mr, length, access_flags);
 
 	if (xlt_with_umr && !(access_flags & IB_ACCESS_ON_DEMAND)) {
 		/*
@@ -1533,8 +1532,6 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 	mlx5_ib_dbg(dev, "start 0x%llx, virt_addr 0x%llx, length 0x%llx, access_flags 0x%x\n",
 		    start, virt_addr, length, access_flags);
 
-	atomic_sub(mr->npages, &dev->mdev->priv.reg_pages);
-
 	if (!mr->umem)
 		return -EINVAL;
 
@@ -1555,12 +1552,17 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		 * used.
 		 */
 		flags |= IB_MR_REREG_TRANS;
+		atomic_sub(mr->npages, &dev->mdev->priv.reg_pages);
+		mr->npages = 0;
 		ib_umem_release(mr->umem);
 		mr->umem = NULL;
+
 		err = mr_umem_get(dev, addr, len, access_flags, &mr->umem,
 				  &npages, &page_shift, &ncont, &order);
 		if (err)
 			goto err;
+		mr->npages = ncont;
+		atomic_add(mr->npages, &dev->mdev->priv.reg_pages);
 	}
 
 	if (!mlx5_ib_can_reconfig_with_umr(dev, mr->access_flags,
@@ -1611,7 +1613,7 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 			goto err;
 	}
 
-	set_mr_fields(dev, mr, npages, len, access_flags);
+	set_mr_fields(dev, mr, len, access_flags);
 
 	return 0;
 
-- 
2.26.2

