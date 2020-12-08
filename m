Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5AABC2BBCF
	for <linux-rdma@archiver.kernel.org>; Tue,  8 Dec 2020 07:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91E5923A7E
	for <linux-rdma@archiver.kernel.org>; Tue,  8 Dec 2020 07:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbgLHHgh (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 8 Dec 2020 02:36:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbgLHHgh (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 8 Dec 2020 02:36:37 -0500
From:   Leon Romanovsky <leon@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Leon Romanovsky <leonro@mellanox.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next 0/3] Various fixes collected over time
Date:   Tue,  8 Dec 2020 09:35:42 +0200
Message-Id: <20201208073545.9723-1-leon@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

This is set of various and unrelated fixes that we collected over time.

Thanks

Avihai Horon (1):
  RDMA/uverbs: Fix incorrect variable type

Jack Morgenstein (2):
  RDMA/core: Clean up cq pool mechanism
  RDMA/core: Do not indicate device ready when device enablement fails

 drivers/infiniband/core/core_priv.h              |  3 +--
 drivers/infiniband/core/cq.c                     | 12 ++----------
 drivers/infiniband/core/device.c                 | 16 ++++++++++------
 .../infiniband/core/uverbs_std_types_device.c    | 14 +++++---------
 include/rdma/uverbs_ioctl.h                      | 10 ++++++++++
 5 files changed, 28 insertions(+), 27 deletions(-)

--
2.28.0

