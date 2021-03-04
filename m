Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90AA0C433E6
	for <linux-rdma@archiver.kernel.org>; Thu,  4 Mar 2021 12:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 584C464F0B
	for <linux-rdma@archiver.kernel.org>; Thu,  4 Mar 2021 12:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240157AbhCDMIt (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 4 Mar 2021 07:08:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232094AbhCDMIf (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 4 Mar 2021 07:08:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A151E64F21;
        Thu,  4 Mar 2021 12:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614859674;
        bh=gjxv/xP6fgrZipSRb/XpuixmfFS/0RYDIbRg11vSQzM=;
        h=From:To:Cc:Subject:Date:From;
        b=oZX912+jy4D8W11NOugu8EnzChBAO4qOlyDy+bpNy0qVVTWanQ9bE8P79S0jLQPqA
         KQ3mUpiOC+dn+bglWUzCgSw2zxyFzyHA3Jk408puozn7SEBqCw69mueVvGyzHOxPFK
         yTSlm/gc/V/It3/DCS4eSHmstDYMWtveB7Ytx5PFKkrIDxW10ogKEK8OwiFI0Uguo1
         wWrleO1tHrcyrd+ZghBOH0EkXnYqMEWWmoSP+7I79AMRfN7ZJR+jkrX5yHoGcsLZrI
         zONmhgXDlSuwSUV6moxeuVR14hThPQhz8Q/NoqHPITgQB7ZOKOW2a8/xVtmwA6evVr
         ID/7m9dZSux6Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next 0/4] Clean the mlx5 MR deregistration logic
Date:   Thu,  4 Mar 2021 14:07:41 +0200
Message-Id: <20210304120745.1090751-1-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

The following patchset is a cleanup of mlx5_ib_mr dereg logic.

Thanks

Jason Gunthorpe (4):
  RDMA/mlx5: Zero out ODP related items in the mlx5_ib_mr
  RDMA/mlx5: Use a union inside mlx5_ib_mr
  RDMA/mlx5: Consolidate MR destruction to mlx5_ib_dereg_mr()
  RDMA/mlx5: Rename mlx5_mr_cache_invalidate() to revoke_mr()

 drivers/infiniband/core/umem_dmabuf.c |   4 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h  | 106 +++++++++--------
 drivers/infiniband/hw/mlx5/mr.c       | 157 ++++++++++++--------------
 drivers/infiniband/hw/mlx5/odp.c      | 152 ++++---------------------
 4 files changed, 160 insertions(+), 259 deletions(-)

--
2.29.2

