Return-Path: <SRS0=anP4=CX=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4765BC43461
	for <linux-rdma@archiver.kernel.org>; Mon, 14 Sep 2020 17:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9B36214F1
	for <linux-rdma@archiver.kernel.org>; Mon, 14 Sep 2020 17:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600105914;
	bh=njTD/4eDrE5KS0pb+XkMlaM+vhP7afImNLL0FaUBSZo=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=B47j+NLa6S6LfvhCRRtEpmBZg5YJ7goBzSsFNM/DKf1xTGwt+cS6L17wcwFG8aXG3
	 HUVV5PnHoPp949wfJQX12x65+PIvOtxD8m3MbZ3Oo+bcZUTIyW4hxu03oo743uonk7
	 YyvfRDp6pcSYnFOJHC8vazHYGtnSmEXs2ODyOIVM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgINL1Q (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 14 Sep 2020 07:27:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgINL06 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 14 Sep 2020 07:26:58 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BD3C216C4;
        Mon, 14 Sep 2020 11:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600082818;
        bh=njTD/4eDrE5KS0pb+XkMlaM+vhP7afImNLL0FaUBSZo=;
        h=From:To:Cc:Subject:Date:From;
        b=ij45fDyAexKQROkxT7mQeyOK4XIc85GsQga+UrjAlkC1uRdGLwBpxOwCT9td2aTw+
         2fQfNGe4BqtqXAChcbZRxn0iswhSwEgfz2kNo68cbtHljYp0mGUFiya72j+Pz5jSf9
         OsYd9SVH6fSmjqCoSMFTtUocSrwLDzmUjmtKM6Ng=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Artemy Kovalyov <artemyko@mellanox.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Moni Shoua <monis@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-next 0/5] Reorganize mlx5 UMR creation flow
Date:   Mon, 14 Sep 2020 14:26:48 +0300
Message-Id: <20200914112653.345244-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

This flow has become crufty and confusing. Revise it so that the rules
on how UMR is used with MRs is much clearer and more correct.

Fixes a few minor bugs in ODP and rereg_mr where disallowed things were
not properly blocked.

Thanks

Jason Gunthorpe (5):
  RDMA/mlx5: Remove dead check for EAGAIN after alloc_mr_from_cache()
  RDMA/mlx5: Use set_mkc_access_pd_addr_fields() in reg_create()
  RDMA/mlx5: Make mkeys always owned by the kernel's PD when not enabled
  RDMA/mlx5: Disable IB_DEVICE_MEM_MGT_EXTENSIONS if IB_WR_REG_MR can't
    work
  RDMA/mlx5: Clarify what the UMR is for when creating MRs

 drivers/infiniband/hw/mlx5/main.c    |   4 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  45 +++++++--
 drivers/infiniband/hw/mlx5/mr.c      | 133 ++++++++++++++-------------
 drivers/infiniband/hw/mlx5/odp.c     |   9 +-
 drivers/infiniband/hw/mlx5/wr.c      |  27 +++---
 5 files changed, 127 insertions(+), 91 deletions(-)

--
2.26.2

