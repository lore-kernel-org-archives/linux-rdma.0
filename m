Return-Path: <SRS0=RpEd=CL=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2EF1C433E2
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Sep 2020 08:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A5252084C
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Sep 2020 08:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599034591;
	bh=yj8OOvccQaiqRmK7MEwY/O2yYzeTUJvINFDbg0Sp4MY=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=UulCHZqW8byMidAEeUYhxLgRTQWLSTUZ5+1kQZG5u35Xkpb06uMRtWddl2HQo1H6Z
	 AgR+bRpfbcuwKoGZnrLYixW57vAdGP63Z/qPS46wHt/6ICJXWuXXe2G/gmk7fuE8wI
	 mES7PQIGtjRJ9e0EacZTieIM5FKE4nUJiLENPawc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgIBIQa (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 2 Sep 2020 04:16:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbgIBIQ2 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 2 Sep 2020 04:16:28 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 690C72078B;
        Wed,  2 Sep 2020 08:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599034588;
        bh=yj8OOvccQaiqRmK7MEwY/O2yYzeTUJvINFDbg0Sp4MY=;
        h=From:To:Cc:Subject:Date:From;
        b=jx1VMYiSeVCXrKeyGWzDEvFGbHSye35GO05OD1KsR+olJt9aLpzHqW/OpfmF4deUd
         4auo8dC+INy4LGHfTRfNB1wPsjhkfUB290m/u2UYTKiFT952tB/jjKavkQJg/4rrHq
         rDj5DMQb5CGEiEAvOFeExgjXWDGHQKjQpJlH8WYc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Lijun Ou <oulijun@huawei.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Weihang Li <liweihang@huawei.com>,
        "Wei Hu(Xavier)" <huwei87@hisilicon.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH rdma-next 0/2] Convert RWQ and MW to general allocation scheme
Date:   Wed,  2 Sep 2020 11:16:21 +0300
Message-Id: <20200902081623.746359-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Continue with allocation patches.

Leon Romanovsky (2):
  RDMA: Clean MW allocation and free flows
  RDMA: Convert RWQ table logic to ib_core allocation scheme

 drivers/infiniband/core/device.c            |  2 +
 drivers/infiniband/core/uverbs_cmd.c        | 45 +++++++++++++--------
 drivers/infiniband/core/uverbs_main.c       |  7 +++-
 drivers/infiniband/core/uverbs_std_types.c  | 12 +++++-
 drivers/infiniband/core/verbs.c             | 23 -----------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h      |  3 +-
 drivers/infiniband/hw/cxgb4/mem.c           | 32 +++++----------
 drivers/infiniband/hw/cxgb4/provider.c      |  4 +-
 drivers/infiniband/hw/hns/hns_roce_device.h |  3 +-
 drivers/infiniband/hw/hns/hns_roce_main.c   |  2 +
 drivers/infiniband/hw/hns/hns_roce_mr.c     | 28 ++++---------
 drivers/infiniband/hw/mlx4/main.c           |  5 +++
 drivers/infiniband/hw/mlx4/mlx4_ib.h        | 20 +++++----
 drivers/infiniband/hw/mlx4/mr.c             | 30 +++++---------
 drivers/infiniband/hw/mlx4/qp.c             | 40 +++++-------------
 drivers/infiniband/hw/mlx5/cmd.c            |  4 +-
 drivers/infiniband/hw/mlx5/cmd.h            |  2 +-
 drivers/infiniband/hw/mlx5/main.c           |  5 +++
 drivers/infiniband/hw/mlx5/mlx5_ib.h        |  9 ++---
 drivers/infiniband/hw/mlx5/mr.c             | 40 +++++++-----------
 drivers/infiniband/hw/mlx5/qp.c             | 41 +++++++------------
 include/rdma/ib_verbs.h                     | 13 +++---
 22 files changed, 158 insertions(+), 212 deletions(-)

--
2.26.2

