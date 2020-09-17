Return-Path: <SRS0=cNdp=C2=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCCDC433E2
	for <linux-rdma@archiver.kernel.org>; Thu, 17 Sep 2020 11:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AB5B208DB
	for <linux-rdma@archiver.kernel.org>; Thu, 17 Sep 2020 11:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600341759;
	bh=3rj72kJf5hO9EeWfjCycl+jg4WIVJRtvHyhsNiwRvKc=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=JYkBnoavjdHTbj+LwriPmGLur8JhflSpea0rJp5w/4dz/lr77UdfT+4ZkWPYzUUxA
	 ZyR+1T8fNl8IPh6mH8zX8USHQCSC2kaIYvY8vWCp5chkcWl/ZbTbZ7kb98hEsow9Vs
	 0jv+o0ds7WVHH99JjTQURG9y38vT+xW+kXuPyvqY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgIQLWa (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 17 Sep 2020 07:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbgIQLWG (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 17 Sep 2020 07:22:06 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D31DF208DB;
        Thu, 17 Sep 2020 11:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600341717;
        bh=3rj72kJf5hO9EeWfjCycl+jg4WIVJRtvHyhsNiwRvKc=;
        h=From:To:Cc:Subject:Date:From;
        b=Veur1pKhAbAZfPoG+c17pkFsMSLORR+y53c8kAE/8hpguw23ofPvbjJAlPpR8kDlD
         eQ0hwRA2YY8pBuS4DoYPRnTjm2ljVlEQrLYlo8IEy9d4XJROztlT8fieoWuKDjcUGm
         g7IxG2Cb1EyzBjMkvVkp9hThIGSZPIP3Anb9qk54=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Yishai Hadas <yishaih@nvida.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH rdma-next v1 0/4] Improve ODP by using HMM API
Date:   Thu, 17 Sep 2020 14:21:48 +0300
Message-Id: <20200917112152.1075974-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v1:
 * Cleaned code.
 * Support a potential valid dma_address of NULL by flags detection,
   note was added to clarify things as was asked.
 * Fix 80 character lines in few places.
v0: https://lore.kernel.org/lkml/20200914113949.346562-1-leon@kernel.org

Based on:
https://lore.kernel.org/lkml/20200914112653.345244-1-leon@kernel.org/

---------------------------------------------------------------------------------------
From Yishai:

This series improves ODP performance by moving to use the HMM API as of below.

The get_user_pages_remote() functionality was replaced by HMM:
- No need anymore to allocate and free memory to hold its output per call.
- No need anymore to use the put_page() to unpin the pages.
- The logic to detect contiguous pages is done based on the returned order
  from HMM, no need to run per page, and evaluate.

Moving to use the HMM enables to reduce page faults in the system by using the
snapshot mode. This mode allows existing pages in the CPU to become presented
to the device without faulting.

This non-faulting mode may be used explicitly by an application with some new
option of advice MR (i.e. PREFETCH_NO_FAULT) and is used upon ODP MR
registration internally as part of initiating the device page table.

To achieve the above, internal changes in the ODP data structures were done
and some flows were cleaned-up/adapted accordingly.

Thanks

Yishai Hadas (4):
  IB/core: Improve ODP to use hmm_range_fault()
  IB/core: Enable ODP sync without faulting
  RDMA/mlx5: Extend advice MR to support non faulting mode
  RDMA/mlx5: Sync device with CPU pages upon ODP MR registration

 drivers/infiniband/Kconfig              |   1 +
 drivers/infiniband/core/umem_odp.c      | 286 ++++++++++--------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h    |   6 +
 drivers/infiniband/hw/mlx5/mr.c         |  14 +-
 drivers/infiniband/hw/mlx5/odp.c        |  49 ++--
 include/rdma/ib_umem_odp.h              |  21 +-
 include/uapi/rdma/ib_user_ioctl_verbs.h |   1 +
 7 files changed, 176 insertions(+), 202 deletions(-)

--
2.26.2

