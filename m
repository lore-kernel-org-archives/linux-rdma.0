Return-Path: <SRS0=Cmar=EB=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E5AC4363A
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Oct 2020 13:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF1EB20809
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Oct 2020 13:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603718604;
	bh=Wqyhlt/zYMpL8iZMsoMxIRDiAqiLMR+CelNVahqUIow=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=sbrnrV7cI4m2iQY44uGPKdaf0ULadsrBpXaBYYgEiP/FU/GC578VWcaG20+bUMO0C
	 2FLeJmwgjuBF9NIzl1Fvz//epmPLs49xKOOTqF+FDBUwLryuwrSGt62zxoqvL9Bd7k
	 6TqPbYWKRbPcNc/EpOKLDANES0h2riYLAPXkDQDk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421363AbgJZNXV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 26 Oct 2020 09:23:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1421312AbgJZNXT (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 26 Oct 2020 09:23:19 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AE4F207DE;
        Mon, 26 Oct 2020 13:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603718598;
        bh=Wqyhlt/zYMpL8iZMsoMxIRDiAqiLMR+CelNVahqUIow=;
        h=From:To:Cc:Subject:Date:From;
        b=1ZQYMT2NJa9lTsguGJvVAaQvqxNHRDc53YNS3VCWSFKeweT7hh2MYV1oqvkW28jxu
         nYwBnQcVGvJCbXowZ9V0S0TY51BqSqW80pXZZRRoqFYIDq5/Zna9m8cPWThPkPOiyb
         3zEkzayrJhE90t7pszv9rQqKYvJQVwDLXcz0/WNY=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next 0/5] Use ib_umem_find_best_pgsz() when creating MRs
Date:   Mon, 26 Oct 2020 15:23:09 +0200
Message-Id: <20201026132314.1336717-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

From Jason:

The new common code does a better job finding large page sizes. Use it in
mlx5 for MRs.

This requires moving the MTT population for mailboxes and UMR over to
rdma_for_each_dma_block().

Thanks

Jason Gunthorpe (5):
  RDMA/mlx5: Change mlx5_ib_populate_pas() to use rdma_for_each_block()
  RDMA/mlx5: Move xlt_emergency_page_mutex into mr.c
  RDMA/mlx5: Split the WR setup out of mlx5_ib_update_xlt()
  RDMA/mlx5: Split mlx5_ib_update_xlt() into ODP and non-ODP cases
  RDMA/mlx5: Use ib_umem_find_best_pgsz() for mkc's

 drivers/infiniband/core/umem.c       |   9 +
 drivers/infiniband/hw/mlx5/cq.c      |   6 +-
 drivers/infiniband/hw/mlx5/devx.c    |   4 +-
 drivers/infiniband/hw/mlx5/main.c    |  26 +-
 drivers/infiniband/hw/mlx5/mem.c     |  73 +-----
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  37 ++-
 drivers/infiniband/hw/mlx5/mr.c      | 364 ++++++++++++++++++---------
 drivers/infiniband/hw/mlx5/qp.c      |   6 +-
 drivers/infiniband/hw/mlx5/srq.c     |   2 +-
 9 files changed, 312 insertions(+), 215 deletions(-)

--
2.26.2

