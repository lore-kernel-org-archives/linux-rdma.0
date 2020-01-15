Return-Path: <SRS0=S6Iu=3E=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150F6C33CB3
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Jan 2020 12:44:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF1142467C
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Jan 2020 12:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579092254;
	bh=hHVz1+EOJDghtb5XYzAjG3za1HO2nkhRjhlUvbPoRU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0lnkmi6+PlTCEaTyEWueiCZaTHoJn3/9Jc5PcmxtyHGrx/AOB8tXXjYL1uiJd404k
	 Mn+RQz7lfV9dJmr5Ao9mKKYmI6Bk3O0G+c4j4I6nCf0P8n4+dLvkQsXig1xRoHbOF5
	 R9XCr0Upi2eUYRFbvOwN82vKgI+YV+VsiLpT52AY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgAOMoO (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 15 Jan 2020 07:44:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:57562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgAOMoO (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 15 Jan 2020 07:44:14 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3DD22467D;
        Wed, 15 Jan 2020 12:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579092253;
        bh=hHVz1+EOJDghtb5XYzAjG3za1HO2nkhRjhlUvbPoRU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=huAVmDlfYKiEDdMWe+Kj/OhliANfSbLxjbyr47wESWnezYKTKxbmBZqCXF6hCatAF
         s7ldyWK1vK7DhypyousVphUMq7XRdhzRSELKCV1lpDxc8HUH9OE3Evo/YTdb8SoxCJ
         eEju/MQB2psxZLOG4yFbTaKVfaskpn8zi0i7KQ0g=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Moni Shoua <monis@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 10/10] net/rds: Use prefetch for On-Demand-Paging MR
Date:   Wed, 15 Jan 2020 14:43:40 +0200
Message-Id: <20200115124340.79108-11-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115124340.79108-1-leon@kernel.org>
References: <20200115124340.79108-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>

Try prefetching pages when using On-Demand-Paging MR using
ib_advise_mr.

Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 net/rds/ib_rdma.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index 5a02b313ec50..5268a76e5db7 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -574,6 +574,7 @@ void *rds_ib_get_mr(struct scatterlist *sg, unsigned long nents,
 			(IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_READ |
 			 IB_ACCESS_REMOTE_WRITE | IB_ACCESS_REMOTE_ATOMIC |
 			 IB_ACCESS_ON_DEMAND);
+		struct ib_sge sge = {};
 		struct ib_mr *ib_mr;

 		if (!rds_ibdev->odp_capable) {
@@ -601,6 +602,14 @@ void *rds_ib_get_mr(struct scatterlist *sg, unsigned long nents,
 		}
 		ibmr->u.mr = ib_mr;
 		ibmr->odp = 1;
+
+		sge.addr = virt_addr;
+		sge.length = length;
+		sge.lkey = ib_mr->lkey;
+
+		ib_advise_mr(rds_ibdev->pd,
+			     IB_UVERBS_ADVISE_MR_ADVICE_PREFETCH_WRITE,
+			     IB_UVERBS_ADVISE_MR_FLAG_FLUSH, &sge, 1);
 		return ibmr;
 	}

--
2.20.1

