Return-Path: <SRS0=c33x=BJ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E0C5C433E0
	for <linux-rdma@archiver.kernel.org>; Thu, 30 Jul 2020 08:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47BAC2075F
	for <linux-rdma@archiver.kernel.org>; Thu, 30 Jul 2020 08:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596097648;
	bh=+0qo7nII31n02JTQKlu75w7rMt+fEgKby7nngVbDqKA=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=QbXfVRSF1ZjYtaHHTXvrxK0sMDOZEwyJa0sODRP4vc367ohTHA0NXYWPAMSLUl5uE
	 lXXULwsMr9GefqKWgpNkdthFqoB2imkobuS3mFZjXukLj2d2au3KXSObkrMoW0MaCp
	 okoETy96HYeHFxoE9SaUSR7vTh/K8pPBU98V2XKo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbgG3I11 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 30 Jul 2020 04:27:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:32794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728883AbgG3I10 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 30 Jul 2020 04:27:26 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D21E7204EA;
        Thu, 30 Jul 2020 08:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596097646;
        bh=+0qo7nII31n02JTQKlu75w7rMt+fEgKby7nngVbDqKA=;
        h=From:To:Cc:Subject:Date:From;
        b=Wlj8nCFazBL9KR/8DTQYgQc0tFHvLfWvxIuK9U/b9O/TQIlj+v6o/9Glhz2ulMnOt
         u7TxsvWqKUlrarodvYVZFQ2kNwdolZOkmAAykl/xN9zjGXsIvNVxStTEDDsTFOo9im
         FJZtLEfbCVxfkYafhflmjT8YOaXdQEsANc1/JjBo=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Yamin Friedman <yaminf@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-rc 0/3] Simple fixes to DIM and mlx5
Date:   Thu, 30 Jul 2020 11:27:16 +0300
Message-Id: <20200730082719.1582397-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

First patch fixes an issue observed after auto-PID series was merged,
but because the bug that not-initialized mutex existed before, the
patch is sent to -rc.

Other two patches are fixing unwind flows and appropriate for -rc.

Thanks

Leon Romanovsky (3):
  RDMA/mlx5: Initialize QP mutex for the debug kernels
  RDMA/core: Stop DIM before destroying CQ
  RDMA/core: Free DIM memory in error unwind

 drivers/infiniband/core/cq.c    | 14 +++++++++++---
 drivers/infiniband/hw/mlx5/qp.c |  5 +----
 2 files changed, 12 insertions(+), 7 deletions(-)

--
2.26.2

