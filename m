Return-Path: <SRS0=S6Iu=3E=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A122EC33CB2
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Jan 2020 12:43:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EEAB2465A
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Jan 2020 12:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579092233;
	bh=9+VTtQRn4BN0SwTlA0aCwnQ461txTVqxYUvJ4f+j/Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=tdPI0ocTYx4MK3wh0mjiFXNx9hjfk9dPGPVALE1rSzjxvAzdC4uAj8Io0RWjydA2t
	 Q4xvG9Jt/g4kCUrkmORQP3yx1FNi919E1pZlrC8iBvuUIAmVF8JI8tLIftLmmVQMdS
	 j/x0CoLX4rjeimHr3pxmnEJYo6t/zPrPQprpWFhs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbgAOMnw (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 15 Jan 2020 07:43:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:57202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgAOMnw (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 15 Jan 2020 07:43:52 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7F26222C3;
        Wed, 15 Jan 2020 12:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579092231;
        bh=9+VTtQRn4BN0SwTlA0aCwnQ461txTVqxYUvJ4f+j/Xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ASx6m93ajkzrmxxsPAAna258hfOj6cvCPxyTgMTfNvnbm1V2+dOqgxHD4EouSoJ6I
         /kAvCJbjWOfrL5cRZeuhLC6MHtXMtp5tIsoGuhe69cLe3+LB8Es/HI3NrQ+uwGIW4L
         M368pVOsfkAVDI6Swq2zoqdBzNzEsF9j5+0dsiHg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Moni Shoua <monis@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 03/10] IB/core: Add interface to advise_mr for kernel users
Date:   Wed, 15 Jan 2020 14:43:33 +0200
Message-Id: <20200115124340.79108-4-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115124340.79108-1-leon@kernel.org>
References: <20200115124340.79108-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

Allow ULPs to call advise_mr, so they can control ODP regions
in the same way as user space applications.

Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/verbs.c | 11 +++++++++++
 include/rdma/ib_verbs.h         |  3 +++
 2 files changed, 14 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 23d9911f7365..3ebae3b65c28 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2023,6 +2023,17 @@ struct ib_mr *ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 }
 EXPORT_SYMBOL(ib_reg_user_mr);

+int ib_advise_mr(struct ib_pd *pd, enum ib_uverbs_advise_mr_advice advice,
+		 u32 flags, struct ib_sge *sg_list, u32 num_sge)
+{
+	if (!pd->device->ops.advise_mr)
+		return -EOPNOTSUPP;
+
+	return pd->device->ops.advise_mr(pd, advice, flags, sg_list, num_sge,
+					 NULL);
+}
+EXPORT_SYMBOL(ib_advise_mr);
+
 int ib_dereg_mr_user(struct ib_mr *mr, struct ib_udata *udata)
 {
 	struct ib_pd *pd = mr->pd;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 1aeb92609279..1f779fad3a1e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -4172,6 +4172,9 @@ static inline void ib_dma_free_coherent(struct ib_device *dev,
 struct ib_mr *ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			     u64 virt_addr, int mr_access_flags);

+/* ib_advise_mr -  give an advice about an address range in a memory region */
+int ib_advise_mr(struct ib_pd *pd, enum ib_uverbs_advise_mr_advice advice,
+		 u32 flags, struct ib_sge *sg_list, u32 num_sge);
 /**
  * ib_dereg_mr_user - Deregisters a memory region and removes it from the
  *   HCA translation table.
--
2.20.1

