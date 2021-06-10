Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 610E0C47094
	for <linux-rdma@archiver.kernel.org>; Thu, 10 Jun 2021 07:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 442F1613C1
	for <linux-rdma@archiver.kernel.org>; Thu, 10 Jun 2021 07:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhFJHg3 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 10 Jun 2021 03:36:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229634AbhFJHg2 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 10 Jun 2021 03:36:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1652861359;
        Thu, 10 Jun 2021 07:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623310472;
        bh=vm2Gl7de5xYeg9+YSJDCcYTIgwbQdRg5LXOXXPhgCyk=;
        h=From:To:Cc:Subject:Date:From;
        b=W8Zgb99SUiXB68aswbczN7KzYuX7dwRm31Izd4LTmr0XbCt1f2zTdBHMpLMOabfkr
         M+aYLdr4IohhirBXPhF5BH0BvWWRm49lRFsKzUvrYDWGgKionOVYRWzReCGCRnS28a
         YFm9A9Th8Y9C8uk545EZA5fOmCAqF5CcEu8RZS92LTPXJ2wrt26WKyUi3VDrp3b/Mi
         e258+KT67kWyUp9Vd37Rj+EBw97k7xV6PYXbABeXZX+AUA7TNklF+XDE7V6TB0Qju1
         GAl6fj2QuS11CNy09D7BoGZRmq/B2um70zKJtxKfb7qLHmCDBw7aTP4f5shj+wP6FK
         hLBkFayKkV3Uw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>,
        Alaa Hleihel <alaa@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>
Subject: [PATCH rdma-rc 0/3] Collection of small fixes to mlx5_ib
Date:   Thu, 10 Jun 2021 10:34:24 +0300
Message-Id: <cover.1623309971.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

This is unrelated batch of fixes to mlx5_ib.

Thanks

Aharon Landau (1):
  RDMA/mlx5: Delete right entry from MR signature database

Alaa Hleihel (1):
  IB/mlx5: Fix initializing CQ fragments buffer

Maor Gottlieb (1):
  RDMA: Verify port when creating flow rule

 drivers/infiniband/core/uverbs_cmd.c | 5 +++++
 drivers/infiniband/hw/mlx4/main.c    | 3 ---
 drivers/infiniband/hw/mlx5/cq.c      | 9 ++++-----
 drivers/infiniband/hw/mlx5/fs.c      | 5 ++---
 drivers/infiniband/hw/mlx5/mr.c      | 4 ++--
 5 files changed, 13 insertions(+), 13 deletions(-)

-- 
2.31.1

