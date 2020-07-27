Return-Path: <SRS0=6I5V=BG=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB2DC433E0
	for <linux-rdma@archiver.kernel.org>; Mon, 27 Jul 2020 09:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAEBB20786
	for <linux-rdma@archiver.kernel.org>; Mon, 27 Jul 2020 09:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595843914;
	bh=4uWHhsGzpJwRYr72iJOu+beWwYSXnfgqhnoeoQnmswU=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=l7tRH+9ehooDgC4JOuwicjk6p5BwtwtDtVVH1IdFLY6AIUmFg3SW3bYILDhRLZNFL
	 PtIMEd93zsTwvQLbhePbJxfImlnHVLMBAGopxXxiN1hlCXutrcIDo/4fXuNBwVZzqM
	 2HqwyU2LcuUrHvu6s5MQhrY8zrDBR+ukwtP1WpRg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgG0J6e (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 27 Jul 2020 05:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgG0J6d (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 27 Jul 2020 05:58:33 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCDBB2075D;
        Mon, 27 Jul 2020 09:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595843913;
        bh=4uWHhsGzpJwRYr72iJOu+beWwYSXnfgqhnoeoQnmswU=;
        h=From:To:Cc:Subject:Date:From;
        b=ZUfha2ZvyFSijo+zmsoRalcCSql3OE9AUFt9bvhvZvng0EIPVmdolKr9MiE9nawB+
         HBJcX/uIPnVzXB9N140Asy/OEJy4GascnRn+4ULVMi983XMhptpOeslUW8YqIl2YHJ
         xhCEE64ZNm5iZ/Prw1R3fakxniNsJhBQVWeluC54=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Mark Zhang <markz@mellanox.com>, linux-rdma@vger.kernel.org,
        Majd Dibbiny <majd@mellanox.com>
Subject: [PATCH rdma-next] RDMA/netlink: Remove CAP_NET_RAW check when dump a raw QP
Date:   Mon, 27 Jul 2020 12:58:28 +0300
Message-Id: <20200727095828.496195-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

When dump QPs bound to a counter, raw QPs should be allowed to dump
without the CAP_NET_RAW privilege, which is consistent with what
"rdma res show qp" does.

Fixes: c4ffee7c9bdb ("RDMA/netlink: Implement counter dumpit calback")
Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/nldev.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 76af7ea2875d..12d29d54a081 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -759,9 +759,6 @@ static int fill_stat_counter_qps(struct sk_buff *msg,
 	xa_lock(&rt->xa);
 	xa_for_each(&rt->xa, id, res) {
 		qp = container_of(res, struct ib_qp, res);
-		if (qp->qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
-			continue;
-
 		if (!qp->counter || (qp->counter->id != counter->id))
 			continue;
 
-- 
2.26.2

