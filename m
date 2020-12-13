Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A54D8C433FE
	for <linux-rdma@archiver.kernel.org>; Sun, 13 Dec 2020 13:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BBC820728
	for <linux-rdma@archiver.kernel.org>; Sun, 13 Dec 2020 13:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391674AbgLMNa0 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 13 Dec 2020 08:30:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:53344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgLMNa0 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 13 Dec 2020 08:30:26 -0500
From:   Leon Romanovsky <leon@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Daniel Jurgens <danielj@mellanox.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        Parav Pandit <parav@mellanox.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH rdma-rc 0/5] Fixes to v5.10
Date:   Sun, 13 Dec 2020 15:29:35 +0200
Message-Id: <20201213132940.345554-1-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

This is another series with various fixes that can easily go to -next too.

Thanks

Leon Romanovsky (1):
  RDMA/cma: Don't overwrite sgid_attr after device is released

Maor Gottlieb (2):
  RDMA/mlx5: Fix MR cache memory leak
  RDMA/ucma: Fix memory leak of connection request

Shay Drory (2):
  IB/umad: Return EIO in case of when device disassociated
  IB/umad: Return EPOLLERR in case of when device disassociated

 drivers/infiniband/core/cma.c      | 7 ++++---
 drivers/infiniband/core/ucma.c     | 4 +++-
 drivers/infiniband/core/user_mad.c | 6 +++++-
 drivers/infiniband/hw/mlx5/mr.c    | 1 +
 4 files changed, 13 insertions(+), 5 deletions(-)

--
2.29.2

