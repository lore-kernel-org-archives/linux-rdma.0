Return-Path: <SRS0=2Aje=6V=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA087C38A24
	for <linux-rdma@archiver.kernel.org>; Thu,  7 May 2020 14:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF3432073A
	for <linux-rdma@archiver.kernel.org>; Thu,  7 May 2020 14:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588862333;
	bh=jjPs3cCRxH2+vEM0vdqifEvxOrjpWanBt4ztyY19i1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=jnblA/+XqCwL5z1ZcMabF/QrG2rO5mmZ1ZT4mpjitOWTabv+JefWNgUUwd/F1fRaJ
	 RSEadqgS3jt4uEN4txuJBiq69LlW0TCA1bbVWwjgLHat1+VXpi/qym+G8NT7CMIFye
	 w2M9WeVra+04q8m5Te4Bi24/3vH99oK0cOtDnzyU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgEGO1b (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 7 May 2020 10:27:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgEGO1a (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 7 May 2020 10:27:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18CCC20857;
        Thu,  7 May 2020 14:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861649;
        bh=jjPs3cCRxH2+vEM0vdqifEvxOrjpWanBt4ztyY19i1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhsfnToYZjOG09t7yrBQKRvyiZHNsmhfeVyfFeypmULZs6QEqfzLMEzzTuWzESIKu
         hN0eiIkzqA0/c5Sx/IOEZ8YFUX46PdcfhUevl0lx/LAM4H6kpjo4PcchL1xzGQU2Cj
         UgxSVnZNxE7i/7tpw2HqSiFAdHB/PyjLL1HqPubQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 02/50] RDMA/siw: Fix potential siw_mem refcnt leak in siw_fastreg_mr()
Date:   Thu,  7 May 2020 10:26:38 -0400
Message-Id: <20200507142726.25751-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142726.25751-1-sashal@kernel.org>
References: <20200507142726.25751-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit 6e051971b0e2eeb0ce7ec65d3cc8180450512d36 ]

siw_fastreg_mr() invokes siw_mem_id2obj(), which returns a local reference
of the siw_mem object to "mem" with increased refcnt.  When
siw_fastreg_mr() returns, "mem" becomes invalid, so the refcount should be
decreased to keep refcount balanced.

The issue happens in one error path of siw_fastreg_mr(). When "base_mr"
equals to NULL but "mem" is not NULL, the function forgets to decrease the
refcnt increased by siw_mem_id2obj() and causes a refcnt leak.

Reorganize the flow so that the goto unwind can be used as expected.

Fixes: b9be6f18cf9e ("rdma/siw: transmit path")
Link: https://lore.kernel.org/r/1586939949-69856-1-git-send-email-xiyuyang19@fudan.edu.cn
Reported-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_qp_tx.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index ae92c8080967c..9f53aa4feb878 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -920,20 +920,27 @@ static int siw_fastreg_mr(struct ib_pd *pd, struct siw_sqe *sqe)
 {
 	struct ib_mr *base_mr = (struct ib_mr *)(uintptr_t)sqe->base_mr;
 	struct siw_device *sdev = to_siw_dev(pd->device);
-	struct siw_mem *mem = siw_mem_id2obj(sdev, sqe->rkey  >> 8);
+	struct siw_mem *mem;
 	int rv = 0;
 
 	siw_dbg_pd(pd, "STag 0x%08x\n", sqe->rkey);
 
-	if (unlikely(!mem || !base_mr)) {
+	if (unlikely(!base_mr)) {
 		pr_warn("siw: fastreg: STag 0x%08x unknown\n", sqe->rkey);
 		return -EINVAL;
 	}
+
 	if (unlikely(base_mr->rkey >> 8 != sqe->rkey  >> 8)) {
 		pr_warn("siw: fastreg: STag 0x%08x: bad MR\n", sqe->rkey);
-		rv = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
+
+	mem = siw_mem_id2obj(sdev, sqe->rkey  >> 8);
+	if (unlikely(!mem)) {
+		pr_warn("siw: fastreg: STag 0x%08x unknown\n", sqe->rkey);
+		return -EINVAL;
+	}
+
 	if (unlikely(mem->pd != pd)) {
 		pr_warn("siw: fastreg: PD mismatch\n");
 		rv = -EINVAL;
-- 
2.20.1

