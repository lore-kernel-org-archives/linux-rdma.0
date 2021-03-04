Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 027BBC433E6
	for <linux-rdma@archiver.kernel.org>; Thu,  4 Mar 2021 12:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4B3664F23
	for <linux-rdma@archiver.kernel.org>; Thu,  4 Mar 2021 12:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhCDMqK (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 4 Mar 2021 07:46:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:39814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231224AbhCDMqC (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 4 Mar 2021 07:46:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BB4464F2B;
        Thu,  4 Mar 2021 12:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614861922;
        bh=4ZzAOaZx/nYIaR4h1dGLEx3eDAwTI6eNCwgfrcDOXLo=;
        h=From:To:Cc:Subject:Date:From;
        b=U5WV4IPmvuQCdsgdTeapXafxdqg0DXe7upmmlwM/qEN7oztYpv6/+HmnI6VutWsRJ
         dVRz1eA1es9rNFMDPlbSiKlymEBn4CEYdOGOvXOYzt8SR5Jy/9W87Gb4zGq2MoWpEs
         +BVzVJnOYvRIXTq3fncdQ3e/5Y+UP4pcQ3BlYDIwNZ6Kphmayz8gi0D30kY887DgNo
         +Zm1CQXlyAmFV8A2HkJqoH6hzGRUWVzRuvmxFBcb+Wt7n+0r6kmdlldO3LhB96YMEU
         aT0K/Vrl7pUeTWIU/sYXMDL+JbJJdyC9RO/c1Stgfb48EneTsFLmZexsVmzgH2FwX4
         exW4nOeRvBSmw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH rdma-next 0/3] Batch independent fixes to mlx5_ib
Date:   Thu,  4 Mar 2021 14:45:14 +0200
Message-Id: <20210304124517.1100608-1-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Completely independent fixes and improvements to mlx5_ib driver.

Maor Gottlieb (1):
  RDMA/mlx5: Fix query RoCE port

Mark Zhang (1):
  RDMA/mlx5: Fix mlx5 rates to IB rates map

Shay Drory (1):
  RDMA/mlx5: Create ODP EQ only when ODP MR is created

 drivers/infiniband/hw/mlx5/main.c    |  6 +++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  7 ++++++
 drivers/infiniband/hw/mlx5/mr.c      |  3 +++
 drivers/infiniband/hw/mlx5/odp.c     | 32 +++++++++++++++++++---------
 drivers/infiniband/hw/mlx5/qp.c      | 15 ++++++++++++-
 include/linux/mlx5/driver.h          |  2 +-
 6 files changed, 50 insertions(+), 15 deletions(-)

--
2.29.2

