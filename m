Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3A3EC433ED
	for <linux-rdma@archiver.kernel.org>; Sun, 18 Apr 2021 13:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CAE461354
	for <linux-rdma@archiver.kernel.org>; Sun, 18 Apr 2021 13:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhDRN41 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 18 Apr 2021 09:56:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229630AbhDRN41 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 18 Apr 2021 09:56:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ECA061278;
        Sun, 18 Apr 2021 13:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618754159;
        bh=SXlb86Bwtf3yK5dvUTLBvq0yc2SThnd7/EjKGW5Mw1s=;
        h=From:To:Cc:Subject:Date:From;
        b=BCVz9VikUzrF47EW7Vttc7g6y6bIuETyt3fW5ZeRCOeLeF4yW13JGTBsjKaZOb/kc
         tejpZlcZOaDuNiEl3e4B9qqzgEoaEssAr3I7Re9fyD+UGDIbkMkrz1+n014Biod/xA
         PISDgXMPQNU9FippZoJAU69njjsR6+q3Q/MatwR2Vpp5MOlL31bmEQ72osjgB/LHrt
         s9aD20yrf9cs5a5tcU/0wQvvrr/gRoNMP5rYb4f0nWYyjy1/upfu8uqad3Hcep5MqI
         i0hL6nTtQcpj630t77b4yPxPvUXA+b5TOO1XLq0UjvGaoKS0Lx4WKLxqpSQjvyBE9r
         zjlUmnJjV61dg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Krishna Kumar <krkumar2@in.ibm.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH rdma-next 0/3] CMA fixes
Date:   Sun, 18 Apr 2021 16:55:51 +0300
Message-Id: <cover.1618753862.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Another round of fixes to cma.c

Parav Pandit (1):
  RDMA/cma: Skip device which doesn't support CM

Shay Drory (2):
  RDMA/core: Fix check of device in rdma_listen()
  RDMA/core: Add CM to restrack after successful attachment to a device

 drivers/infiniband/core/cma.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

-- 
2.30.2

