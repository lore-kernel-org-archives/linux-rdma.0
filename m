Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D27C48BE5
	for <linux-rdma@archiver.kernel.org>; Wed, 16 Jun 2021 07:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4525861159
	for <linux-rdma@archiver.kernel.org>; Wed, 16 Jun 2021 07:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhFPH7u (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 16 Jun 2021 03:59:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231645AbhFPH7u (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 16 Jun 2021 03:59:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BEA6611BE;
        Wed, 16 Jun 2021 07:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623830265;
        bh=OxVsmrCHtykrZQjFCj85NdY0/Jh2cm6EQb5bJJSRVY8=;
        h=From:To:Cc:Subject:Date:From;
        b=sjPmT/7EaroZ+wfhvfLxm1Il9F7bzQPFQNLry7okjhswSJEtc5FKS5wyz3TN/02I9
         pXsqYGXKMZBd9hPDqLi1FGu5CcgQzWC1oq9ex2oODwv+NafsqI22p/J2z/CDR17vFJ
         NIp8qUjO4Fm9wFt4PNO2KNRyB5p7peyxyHROQ6wYRJEe7vC50BRBYaxjslL5pD2qDY
         HWzjTXLsOXnJOnipx925lSGpgINUZwYNDUHH6UQGqwnM01BX82lmQLQUtoTWhqNtRi
         uD7gdoIls3P/otXu7sdmsZZT+9JkgnJo74fakirO57zMHYUgVyJphNRb+FD2YA51pw
         u9Z+hc38/ozAA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next 0/2] Provide already supported real-time timestamp
Date:   Wed, 16 Jun 2021 10:57:37 +0300
Message-Id: <cover.1623829775.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

In case device supports only real-time timestamp, the kernel will
fail to create QP despite rdma-core requested such timestamp type.

It is because device returns free-running timestamp, and the conversion
from free-running to real-time is performed in the user space.

This series fixes it, by returning real-time timestamp.

Thanks

Aharon Landau (2):
  RDMA/mlx5: Refactor get_ts_format functions to simplify code
  RDMA/mlx5: Support real-time timestamp directly from the device

 drivers/infiniband/hw/mlx5/cq.c               |   6 +-
 drivers/infiniband/hw/mlx5/main.c             |   6 ++
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   7 ++
 drivers/infiniband/hw/mlx5/qp.c               | 102 ++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   8 +-
 .../ethernet/mellanox/mlx5/core/lib/clock.h   |  10 +-
 include/linux/mlx5/mlx5_ifc.h                 |  36 ++-----
 include/linux/mlx5/qp.h                       |   4 +-
 include/uapi/rdma/mlx5-abi.h                  |   2 +
 9 files changed, 94 insertions(+), 87 deletions(-)

-- 
2.31.1

