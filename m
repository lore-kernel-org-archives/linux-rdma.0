Return-Path: <SRS0=HDkz=V4=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA6AC32751
	for <linux-rdma@archiver.kernel.org>; Wed, 31 Jul 2019 11:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4C93208C3
	for <linux-rdma@archiver.kernel.org>; Wed, 31 Jul 2019 11:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564573222;
	bh=4/3a1tEv3Us3EeT4RSsw6lgsLcr7SuHha1Rhzxd6IVs=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=j76CHHjpzJ4YvWHptCgx6F32ZQFhCN2k3KNe7SgkTB5qAzBzXrxmAt/Zx34dNCyOw
	 zX6itLp38rm+2uZTGg4l5fG/Aszaxe7wgphwNyr82jTjOVvQpURsSMEK7T7xibiArF
	 M2tW4aDEvp/ZQNUeDDVQ+HuwWK1YbLaC+sKUtUIQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfGaLkV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 31 Jul 2019 07:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbfGaLkU (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 31 Jul 2019 07:40:20 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 397BA2089E;
        Wed, 31 Jul 2019 11:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564573219;
        bh=4/3a1tEv3Us3EeT4RSsw6lgsLcr7SuHha1Rhzxd6IVs=;
        h=From:To:Cc:Subject:Date:From;
        b=YdRkUaAo203+cHAO8RoyIDZb97bPAdewiqd3U1lqEFWk5SoXOrZz2fRBudvmJ+y4s
         K+zxQwkniCxl/rDJ0YvsWlFNv5QbToJrl2tBruuaONtcZvZxZIGlplUEVTlNUYN9wt
         YzszOYho4GW4R8feIThYDDiBBvmd5NGWq1cwVL4E=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Mark Zhang <markz@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH rdma-next 0/2] Enable QUERY_LAG over DEVX
Date:   Wed, 31 Jul 2019 14:40:12 +0300
Message-Id: <20190731114014.4786-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

Enable QUERY_LAG command over DEVX. That command was added to the mlx5_core,
but were not used and hence has wrong HW spec layout which is fixed in
first patch. The second patch actually makes this command available for
DEVX users.

Thanks

Mark Zhang (2):
  net/mlx5: Fix mlx5_ifc_query_lag_out_bits
  IB/mlx5: Support MLX5_CMD_OP_QUERY_LAG as a DEVX general command

 drivers/infiniband/hw/mlx5/devx.c | 1 +
 include/linux/mlx5/mlx5_ifc.h     | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

--
2.20.1

