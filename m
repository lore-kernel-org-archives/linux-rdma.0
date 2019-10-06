Return-Path: <SRS0=nHGB=X7=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F568C4360C
	for <linux-rdma@archiver.kernel.org>; Sun,  6 Oct 2019 16:00:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CACDD20862
	for <linux-rdma@archiver.kernel.org>; Sun,  6 Oct 2019 16:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570377602;
	bh=oZiSiRSEbjLypwmX4KdWcgliuBwF3Xfc/O5gZrtjC1Y=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=qmm4almhhp71aQQrTgjlg+73/hq8+oNXFI98ivplbn90PQ1U30xtNd/IMFfQa+e91
	 4YZ60hsRXZnQbmm5J/CyFy8sgAHrI2nfZ3k1+kiOhB4dyogGmAZDD5q5sXDmZ+cjsz
	 YcdxWnN6YM8cSVBuK7bdSwYTNAaVzSbyth0sSy6I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbfJFQAC (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 6 Oct 2019 12:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726349AbfJFQAC (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 6 Oct 2019 12:00:02 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 827612084B;
        Sun,  6 Oct 2019 16:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570377601;
        bh=oZiSiRSEbjLypwmX4KdWcgliuBwF3Xfc/O5gZrtjC1Y=;
        h=From:To:Cc:Subject:Date:From;
        b=TLEEm2Qad/5dGRXoWpKOF9giR0oToew28lvvsPLDYAacP1084Ssgs9vVebvWyVg2s
         dY9w5bV/nFTIgkpE9M76QUqYXHhs+GdBCl8RSofb3wN9E4luG+cZnUO62G85NbnGXA
         rUpwyL6GTJa+2QFa3ohRKYbrvDSung9IzQ0cwEas=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 0/3] Optimize SGL registration
Date:   Sun,  6 Oct 2019 18:59:52 +0300
Message-Id: <20191006155955.31445-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This series from Yamin implements long standing "TODO" existed in rw.c.

Thanks

Yamin Friedman (3):
  net/mlx5: Expose optimal performance scatter entries capability
  RDMA/mlx5: Add capability for max sge to get optimized performance
  RDMA/rw: Support threshold for registration vs scattering to local
    pages

 drivers/infiniband/core/rw.c      | 12 ++++++------
 drivers/infiniband/hw/mlx5/main.c |  2 ++
 include/linux/mlx5/mlx5_ifc.h     |  2 +-
 include/rdma/ib_verbs.h           |  2 ++
 4 files changed, 11 insertions(+), 7 deletions(-)

--
2.20.1

