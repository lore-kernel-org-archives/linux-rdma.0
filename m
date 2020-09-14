Return-Path: <SRS0=anP4=CX=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D565AC43461
	for <linux-rdma@archiver.kernel.org>; Mon, 14 Sep 2020 11:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B04A21973
	for <linux-rdma@archiver.kernel.org>; Mon, 14 Sep 2020 11:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600082884;
	bh=XlUPXf20sYSWsrDm+BbO3sfM3Q86Ei0e0831A0lcByA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=eLoADH9iOti+utfCLs7rNu7Ed3/sUfhDcBDbry0U5PpfLzS6beKvkqWEaQMqRQdpw
	 lDwNblQthCrJE7ob5+Xdfl8/LyWid9p9/kBttWAM/nfJLS9/hXPo//T7hdX0NMxJqU
	 zmI/Ozbch5n2Rd+bqjK4nft4M+MiixopdoruO7n4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgINL1n (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 14 Sep 2020 07:27:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbgINL1F (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 14 Sep 2020 07:27:05 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BD92216C4;
        Mon, 14 Sep 2020 11:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600082824;
        bh=XlUPXf20sYSWsrDm+BbO3sfM3Q86Ei0e0831A0lcByA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oA5V/9NBZFvEeGUqt135OXkRxYENcN3kcapHHZ59sgAskLzzyfskM4ZeddyjrJYHV
         Ot1LSj6rkcfaAX2Rnd8RcWV/WTzQvY8knOgYRDBcSTGuG128RMzrWruQN74LKPTrlq
         VzdcgMnjcAKH0J0kdHyC39bpjI1ICXq4OjfgzXVs=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next 2/5] RDMA/mlx5: Use set_mkc_access_pd_addr_fields() in reg_create()
Date:   Mon, 14 Sep 2020 14:26:50 +0300
Message-Id: <20200914112653.345244-3-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200914112653.345244-1-leon@kernel.org>
References: <20200914112653.345244-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

reg_create() open codes this helper, use the shared code.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mr.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 6e63c0b36872..b21eb9dec185 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1199,29 +1199,16 @@ static struct mlx5_ib_mr *reg_create(struct ib_mr *ibmr, struct ib_pd *pd,
 	MLX5_SET(create_mkey_in, in, pg_access, !!(pg_cap));
 
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+	set_mkc_access_pd_addr_fields(mkc, access_flags, virt_addr, pd);
 	MLX5_SET(mkc, mkc, free, !populate);
 	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_MTT);
-	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write))
-		MLX5_SET(mkc, mkc, relaxed_ordering_write,
-			 !!(access_flags & IB_ACCESS_RELAXED_ORDERING));
-	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read))
-		MLX5_SET(mkc, mkc, relaxed_ordering_read,
-			 !!(access_flags & IB_ACCESS_RELAXED_ORDERING));
-	MLX5_SET(mkc, mkc, a, !!(access_flags & IB_ACCESS_REMOTE_ATOMIC));
-	MLX5_SET(mkc, mkc, rw, !!(access_flags & IB_ACCESS_REMOTE_WRITE));
-	MLX5_SET(mkc, mkc, rr, !!(access_flags & IB_ACCESS_REMOTE_READ));
-	MLX5_SET(mkc, mkc, lw, !!(access_flags & IB_ACCESS_LOCAL_WRITE));
-	MLX5_SET(mkc, mkc, lr, 1);
 	MLX5_SET(mkc, mkc, umr_en, 1);
 
-	MLX5_SET64(mkc, mkc, start_addr, virt_addr);
 	MLX5_SET64(mkc, mkc, len, length);
-	MLX5_SET(mkc, mkc, pd, to_mpd(pd)->pdn);
 	MLX5_SET(mkc, mkc, bsf_octword_size, 0);
 	MLX5_SET(mkc, mkc, translations_octword_size,
 		 get_octo_len(virt_addr, length, page_shift));
 	MLX5_SET(mkc, mkc, log_page_size, page_shift);
-	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 	if (populate) {
 		MLX5_SET(create_mkey_in, in, translations_octword_actual_size,
 			 get_octo_len(virt_addr, length, page_shift));
-- 
2.26.2

