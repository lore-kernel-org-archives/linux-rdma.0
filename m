Return-Path: <SRS0=zqf9=YA=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA2FDC47404
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Oct 2019 13:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDF3520867
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Oct 2019 13:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570456778;
	bh=EgoY6K4XF7lSrEpX97ximQ3QyNxEnI7nfyRlB5Kyj/k=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=s1BUPghyIRx+/1ZZv47iE5ljxHaGMuLkISRagZAPOs0bAlcYtZEYxmKidjLyDQAuO
	 JAScjWhti7qCBFBL9qhIXvAGVHUOy/+o9Xvtg4FewRdzAM7e9X8wywE4PFX/kAcaGX
	 2BDwWRPDIggxP55uRmiHco6hFjz9fXyGdZJd/iBM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbfJGN7i (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 7 Oct 2019 09:59:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727536AbfJGN7h (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 7 Oct 2019 09:59:37 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6C3D20684;
        Mon,  7 Oct 2019 13:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570456777;
        bh=EgoY6K4XF7lSrEpX97ximQ3QyNxEnI7nfyRlB5Kyj/k=;
        h=From:To:Cc:Subject:Date:From;
        b=L8Kk6oStL2jNDzc6VI/PEuucG/hjVvmMo1bhoU+f0xUJpg+vItlk3H85a13ns28an
         67THK81vm0vdz+SpGRWflxxGhSSk+eiUML60s7bnU8cfTURlZ1LDWqPv/UQGNldvHr
         DiyvqRMzUTxCRIJFEbIpwvJceidWEQCU3C0f+AZ4=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v2 0/3] Optimize SGL registration
Date:   Mon,  7 Oct 2019 16:59:30 +0300
Message-Id: <20191007135933.12483-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog
v1->v2: https://lore.kernel.org/linux-rdma/20191007115819.9211-1-leon@kernel.org
 * Used Christoph's comment
 * Change patch code flow to have one DMA_FROM_DEVICE check
v0->v1: https://lore.kernel.org/linux-rdma/20191006155955.31445-1-leon@kernel.org
 * Reorganized patches to have IB/core changes separated from mlx5
 * Moved SGL check before rdma_rw_force_mr
 * Added and rephrased original comment.

-----------------------------------------------------------------------------
Hi,

This series from Yamin implements long standing "TODO" existed in rw.c.

Thanks

Yamin Friedman (3):
  net/mlx5: Expose optimal performance scatter entries capability
  RDMA/rw: Support threshold for registration vs scattering to local
    pages
  RDMA/mlx5: Add capability for max sge to get optimized performance

 drivers/infiniband/core/rw.c      | 25 +++++++++++++++----------
 drivers/infiniband/hw/mlx5/main.c |  2 ++
 include/linux/mlx5/mlx5_ifc.h     |  2 +-
 include/rdma/ib_verbs.h           |  2 ++
 4 files changed, 20 insertions(+), 11 deletions(-)

--
2.20.1

