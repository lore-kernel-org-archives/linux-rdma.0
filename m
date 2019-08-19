Return-Path: <SRS0=Wuup=WP=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4659C3A59D
	for <linux-rdma@archiver.kernel.org>; Mon, 19 Aug 2019 11:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A57C2086C
	for <linux-rdma@archiver.kernel.org>; Mon, 19 Aug 2019 11:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566213473;
	bh=RqqwixJFdLXzbyX/SBdbIcbTYnHS72+OZtDom+QJt4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=CU49uT+lELsFcicZ2iWR6cAkFiPAImSwqlM3jQ0sybHRqTK29DhiRsDvRJz/2LKh4
	 mlM8I20pzQgH5XKVmp+IP+/HR30LG8jUViUAZV8ImAA+8W2Jkoz+ouJQIwvAENNKqr
	 vl3wGk6eK5YIhXZ/TgLT7RtOsgIn69hyOGhga7Q4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfHSLRx (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 19 Aug 2019 07:17:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727339AbfHSLRw (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 19 Aug 2019 07:17:52 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 412732085A;
        Mon, 19 Aug 2019 11:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566213471;
        bh=RqqwixJFdLXzbyX/SBdbIcbTYnHS72+OZtDom+QJt4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MzjohZYlR06ewAUQXiTTt/uL0uZR0rSSP5EG+BbNeQjvINBBUfwPd6aK2YNsbEcL1
         t3phfFlP/7iTnRhMgivfDv+axI0bhoIys+Va1CL0DOISu/9GkVeL9o7t2emaRxcp6a
         GqUa0M2QK/BUBK9PXZZWJoksN1DqM3Eb86NU89Ew=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Guy Levi <guyle@mellanox.com>, Moni Shoua <monis@mellanox.com>
Subject: [PATCH rdma-next 11/12] RDMA/mlx5: Use ib_umem_start instead of umem.address
Date:   Mon, 19 Aug 2019 14:17:09 +0300
Message-Id: <20190819111710.18440-12-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190819111710.18440-1-leon@kernel.org>
References: <20190819111710.18440-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

These are subtly different, the address is the original VA requested
during umem_get, while ib_umem_start() is the version that is rounded to
the proper page size, ie is the true start of the umem's dma map.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/odp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index c755c76729bc..70e0a3555f11 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -184,7 +184,7 @@ void mlx5_odp_populate_klm(struct mlx5_klm *pklm, size_t offset,
 	for (i = 0; i < nentries; i++, pklm++) {
 		pklm->bcount = cpu_to_be32(MLX5_IMR_MTT_SIZE);
 		va = (offset + i) * MLX5_IMR_MTT_SIZE;
-		if (odp && odp->umem.address == va) {
+		if (odp && ib_umem_start(odp) == va) {
 			struct mlx5_ib_mr *mtt = odp->private;
 
 			pklm->key = cpu_to_be32(mtt->ibmr.lkey);
@@ -494,7 +494,7 @@ static struct ib_umem_odp *implicit_mr_get_data(struct mlx5_ib_mr *mr,
 	addr += MLX5_IMR_MTT_SIZE;
 	if (unlikely(addr < io_virt + bcnt)) {
 		odp = odp_next(odp);
-		if (odp && odp->umem.address != addr)
+		if (odp && ib_umem_start(odp) != addr)
 			odp = NULL;
 		goto next_mr;
 	}
@@ -664,7 +664,7 @@ static int pagefault_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr,
 
 		io_virt += size;
 		next = odp_next(odp);
-		if (unlikely(!next || next->umem.address != io_virt)) {
+		if (unlikely(!next || ib_umem_start(next) != io_virt)) {
 			mlx5_ib_dbg(dev, "next implicit leaf removed at 0x%llx. got %p\n",
 				    io_virt, next);
 			return -EAGAIN;
-- 
2.20.1

