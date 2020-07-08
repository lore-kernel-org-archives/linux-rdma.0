Return-Path: <SRS0=5lGU=AT=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E09ACC433DF
	for <linux-rdma@archiver.kernel.org>; Wed,  8 Jul 2020 11:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB09520739
	for <linux-rdma@archiver.kernel.org>; Wed,  8 Jul 2020 11:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594206359;
	bh=rUUV2KBbwjv8A21d6d/CePQZmxxt3POOAgfI6UnG9FA=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=UQ2NCUnXazyJQMJBicd53xuqGQYJDV44pzEA/zlaRG72BJLjc5bnMLlaVZLVeV4L+
	 y+zaB+e8FUmuWtgIcgBGvnuorbgHT90F61DenkbKHW2OhFS6fY1rZ9DRQYbfBJJhse
	 d5VviMw9z7RTN5LzlhZCQ+vjdtGLckGUs8C7LJ6s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgGHLF7 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 8 Jul 2020 07:05:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728385AbgGHLF7 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 8 Jul 2020 07:05:59 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBCCC206F6;
        Wed,  8 Jul 2020 11:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594206358;
        bh=rUUV2KBbwjv8A21d6d/CePQZmxxt3POOAgfI6UnG9FA=;
        h=From:To:Cc:Subject:Date:From;
        b=emCbJxN+V7GiUA+2j6XOj4UsvGfkWXrCSKfyuCE6s9wY0Gn6kQf5uTK+vis3XqWNr
         EwIga8DvMJ6trH3bmGKcqjS5EB1ku7bxNDWRmeiQuZiEAHzlYEw9yp6GGqlACR6qq/
         zDIW7phIZ5LWAOal/63re0QcOR1lDXxg+MMicqZI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next 0/2] Align write() and ioctl() paths
Date:   Wed,  8 Jul 2020 14:05:52 +0300
Message-Id: <20200708110554.1270613-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

The discussion about RWQ table patch revealed incosistency with use of
usecnt, complex unwind flows without any reason and difference between
write() and ioctl() paths.

This series extends infrastructure to be consistent, reliable and
predicable in regards of commit/desotry uobject.

Thanks

Leon Romanovsky (2):
  RDMA/core: Align abort/commit object scheme for write() and ioctl()
    paths
  RDMA/core: Update write interface to use automatic object lifetime

 drivers/infiniband/core/uverbs_cmd.c          | 299 ++++++------------
 drivers/infiniband/core/uverbs_main.c         |   4 +
 .../infiniband/core/uverbs_std_types_device.c |   7 +-
 include/rdma/uverbs_ioctl.h                   |   1 +
 include/rdma/uverbs_std_types.h               |  14 +
 5 files changed, 115 insertions(+), 210 deletions(-)

--
2.26.2

