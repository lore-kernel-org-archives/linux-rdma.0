Return-Path: <SRS0=fADM=YW=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B75BBCA9EB9
	for <linux-rdma@archiver.kernel.org>; Tue, 29 Oct 2019 06:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DC172086D
	for <linux-rdma@archiver.kernel.org>; Tue, 29 Oct 2019 06:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572330497;
	bh=+1LzwztoRXq5YJ0iVmTikTB6HkVy52XFiWc73wweips=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=eVwP7bRtqxjGS5fjSXT/s9U8JcZ1by21g7OPDD70md5AjMmggM7/ECiHDGF/vxDmi
	 vD5+HQmperexA4hoEg43eEaedEpsHGEvfR4iaMZou2rs+g6vb4GLPlDoq0O5/w8nxE
	 X1BTI6S8RxMTez9HsO4Y4TGLhCJm6XRghvV13LIY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732510AbfJ2G2R (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 29 Oct 2019 02:28:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730609AbfJ2G2Q (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 29 Oct 2019 02:28:16 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCDBB20862;
        Tue, 29 Oct 2019 06:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572330496;
        bh=+1LzwztoRXq5YJ0iVmTikTB6HkVy52XFiWc73wweips=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yt97LSijZfg/6dGb/PjXjVVMsHudTJpAH3+PP8b++SmJ8w5l2ULPumOrp5foMdXBF
         zKvHnz4nzS/pQlc4jvGP+kixC6vpOHjB7pS+LpyJDarQ4RJW35RhpW71swT6rGwsMF
         xt8YFFy0rRcYQPsy5JfqRT3cVgkwzeCR05sWq+TI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Ralph Campbell <ralph.campbell@qlogic.com>
Subject: [PATCH rdma-next 08/16] RDMA/mlx4: Delete unreachable code
Date:   Tue, 29 Oct 2019 08:27:37 +0200
Message-Id: <20191029062745.7932-9-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191029062745.7932-1-leon@kernel.org>
References: <20191029062745.7932-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

All callers allocate MAD structures with proper sizes,
there is no need to recheck it.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx4/mad.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 985cced5d509..c6ea4c50da1e 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -992,10 +992,6 @@ int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	struct ib_mad *out_mad = (struct ib_mad *)out;
 	enum rdma_link_layer link = rdma_port_get_link_layer(ibdev, port_num);
 
-	if (WARN_ON_ONCE(in_mad_size != sizeof(*in_mad) ||
-			 *out_mad_size != sizeof(*out_mad)))
-		return IB_MAD_RESULT_FAILURE;
-
 	/* iboe_process_mad() which uses the HCA flow-counters to implement IB PMA
 	 * queries, should be called only by VFs and for that specific purpose
 	 */
-- 
2.20.1

