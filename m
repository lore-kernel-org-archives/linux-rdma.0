Return-Path: <SRS0=Wuup=WP=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B8CAC3A59D
	for <linux-rdma@archiver.kernel.org>; Mon, 19 Aug 2019 11:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0352C2086C
	for <linux-rdma@archiver.kernel.org>; Mon, 19 Aug 2019 11:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566213438;
	bh=csnJZ6MsVLbw7hnSmiX+VvK9xz9F76vZ/AL72whL450=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Tpk/ZwBz1srH+h28XUAHLHIUvknk4MNO7Rr6R/HRC3cPjqTkh2lq6xHhSuA3c1SV4
	 3iZpfUJ63axbRGyf1LPm/VUxdWADghbrg2a5qfy7QBkIFoNvGIwfmNHYHh+j3eR+Rk
	 8pN2ifyCdQRLW/lqj9vdYiqOrWNHASdD2TkoJkVg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfHSLRR (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 19 Aug 2019 07:17:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:32772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726987AbfHSLRR (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 19 Aug 2019 07:17:17 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96F4D2085A;
        Mon, 19 Aug 2019 11:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566213436;
        bh=csnJZ6MsVLbw7hnSmiX+VvK9xz9F76vZ/AL72whL450=;
        h=From:To:Cc:Subject:Date:From;
        b=HQMxhC4F1r717xD3b7830Ojrd7+6OsXfiOyK4NR1rl2icPxMS3U5uGsQ96lPkPr3A
         7aCW+tgrQ9JYAttchp3Ow/4eOYIovbvGZJrjrJvZ8PvubQWF9zKOOM6t2bJxoaZCbB
         72TixlNUoyDpZUnB4ICDo2REBD1FkD4ps6q0/Bg0=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Guy Levi <guyle@mellanox.com>, Moni Shoua <monis@mellanox.com>
Subject: [PATCH rdma-next 00/12] Improvements for ODP
Date:   Mon, 19 Aug 2019 14:16:58 +0300
Message-Id: <20190819111710.18440-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This series from Jason is a collection of general cleanups for
ODP to clarify some of the flows around umem creation and use
of the interval tree.

It is based on patch "RDMA/mlx5: Fix MR npages calculation for
IB_ACCESS_HUGETLB"
https://lore.kernel.org/linux-rdma/20190815083834.9245-5-leon@kernel.org

Thanks

Jason Gunthorpe (11):
  RDMA/odp: Use the common interval tree library instead of generic
  RDMA/odp: Iterate over the whole rbtree directly
  RDMA/odp: Make it clearer when a umem is an implicit ODP umem
  RMDA/odp: Consolidate umem_odp initialization
  RDMA/odp: Make the three ways to create a umem_odp clear
  RDMA/odp: Split creating a umem_odp from ib_umem_get
  RDMA/odp: Provide ib_umem_odp_release() to undo the allocs
  RDMA/odp: Check for overflow when computing the umem_odp end
  RDMA/odp: Use kvcalloc for the dma_list and page_list
  RDMA/mlx5: Use ib_umem_start instead of umem.address
  RDMA/mlx5: Use odp instead of mr->umem in pagefault_mr

Moni Shoua (1):
  RDMA/core: Make invalidate_range a device operation

 drivers/infiniband/Kconfig           |   1 +
 drivers/infiniband/core/device.c     |   1 +
 drivers/infiniband/core/umem.c       |  50 +--
 drivers/infiniband/core/umem_odp.c   | 448 +++++++++++++++------------
 drivers/infiniband/core/uverbs_cmd.c |   2 -
 drivers/infiniband/hw/mlx5/main.c    |   4 -
 drivers/infiniband/hw/mlx5/mem.c     |  13 -
 drivers/infiniband/hw/mlx5/mr.c      |  38 ++-
 drivers/infiniband/hw/mlx5/odp.c     |  88 +++---
 include/rdma/ib_umem_odp.h           |  48 ++-
 include/rdma/ib_verbs.h              |   4 +-
 11 files changed, 370 insertions(+), 327 deletions(-)

--
2.20.1

