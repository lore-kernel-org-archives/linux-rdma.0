Return-Path: <SRS0=S6Iu=3E=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 782A0C33CB1
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Jan 2020 14:55:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ACEA214AF
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Jan 2020 14:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579100105;
	bh=ULCZARslRUGY7TV6q4M9XJdmnROqrCPxMcB6blJlsW4=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=hRasADiXJ4hXSMBKBLVnGVL59AtdzgmLzngVhTWuVtcCn2RYmPA19684M5Y89UAYj
	 UCY2kd2dieCpjbHUhJBFQIgWUgekANP4dQaG8VD4Sq6zZpCx3nZCoA45gtuHJfYfad
	 ThBOSyEOsFc8X5lMEd6kFILi3brli00E951TkohQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgAOOzE (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 15 Jan 2020 09:55:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbgAOOzE (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 15 Jan 2020 09:55:04 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5827D2084D;
        Wed, 15 Jan 2020 14:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579100103;
        bh=ULCZARslRUGY7TV6q4M9XJdmnROqrCPxMcB6blJlsW4=;
        h=From:To:Cc:Subject:Date:From;
        b=Ht0R9YX4B+nxv3DML4SsZOfhEhNyYmVvWKyZ1qrpqJ9Zfm5+Qq0sqcaQihv/teKZj
         N4VULAIOwnPcV3GJenyypuv2IInNE2t5/LwhQgKvEJJMRbqWHI2iE+E0F5DzR0jgOg
         uuUI14w/WIeGrzm5BiOW2wHrsqhIjEIKZ4Yqo5PE=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Avihai Horon <avihaih@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 0/2] RoCE accelerator counters
Date:   Wed, 15 Jan 2020 16:54:57 +0200
Message-Id: <20200115145459.83280-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

Very small change, separated to two patches due to our shared methodology.

Thanks

Avihai Horon (1):
  IB/mlx5: Expose RoCE accelerator counters

Leon Romanovsky (1):
  net/mlx5: Add RoCE accelerator counters

 drivers/infiniband/hw/mlx5/main.c | 18 ++++++++++++++++++
 include/linux/mlx5/mlx5_ifc.h     | 17 +++++++++++++++--
 2 files changed, 33 insertions(+), 2 deletions(-)

--
2.20.1

