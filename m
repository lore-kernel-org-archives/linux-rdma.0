Return-Path: <SRS0=alaQ=VQ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97623C76195
	for <linux-rdma@archiver.kernel.org>; Fri, 19 Jul 2019 04:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DFE9218B8
	for <linux-rdma@archiver.kernel.org>; Fri, 19 Jul 2019 04:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563509174;
	bh=CAoix3qP2jnrbO20MujvnszQJy01ASlC9QjPR7Q5lxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=jT2XIA5mKf5xT+sZiyXcRAtNP54sdfygEc/yrpeXDZggmieIugN+bp1arOXYYQz6A
	 Xk9FZS349T272mJm6zQsNRpIiZqaVe+mNckDuSmzm52hf5orxocAaAjTrSDlYVfs9r
	 tYasrvHe2NZW1a/3uUZ6kMSISuLSuRRIdWCVL+mQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732041AbfGSEGM (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 19 Jul 2019 00:06:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730836AbfGSEGL (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 19 Jul 2019 00:06:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FF20218C5;
        Fri, 19 Jul 2019 04:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509170;
        bh=CAoix3qP2jnrbO20MujvnszQJy01ASlC9QjPR7Q5lxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDKcvMYkjZ6oHAT73P76O4NZaciTnik7968WbHeayd1jMWNxT0zoxtYfM03RT96pk
         ZAiyfDhB9Sogviu/SpQ5LU7HrYZ3tyOpxMR7/tlkJUGeDdF4UyvhEerWQzwtzvrf8+
         PTD986HyAOVcUJnChu6FsNBfytNhr80X6o0qrgH4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konstantin Taranov <konstantin.taranov@inf.ethz.ch>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 104/141] RDMA/rxe: Fill in wc byte_len with IB_WC_RECV_RDMA_WITH_IMM
Date:   Fri, 19 Jul 2019 00:02:09 -0400
Message-Id: <20190719040246.15945-104-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Konstantin Taranov <konstantin.taranov@inf.ethz.ch>

[ Upstream commit bdce1290493caa3f8119f24b5dacc3fb7ca27389 ]

Calculate the correct byte_len on the receiving side when a work
completion is generated with IB_WC_RECV_RDMA_WITH_IMM opcode.

According to the IBA byte_len must indicate the number of written bytes,
whereas it was always equal to zero for the IB_WC_RECV_RDMA_WITH_IMM
opcode, even though data was transferred.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Konstantin Taranov <konstantin.taranov@inf.ethz.ch>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c  | 5 ++++-
 drivers/infiniband/sw/rxe/rxe_verbs.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index aca9f60f9b21..1cbfbd98eb22 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -431,6 +431,7 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 			qp->resp.va = reth_va(pkt);
 			qp->resp.rkey = reth_rkey(pkt);
 			qp->resp.resid = reth_len(pkt);
+			qp->resp.length = reth_len(pkt);
 		}
 		access = (pkt->mask & RXE_READ_MASK) ? IB_ACCESS_REMOTE_READ
 						     : IB_ACCESS_REMOTE_WRITE;
@@ -856,7 +857,9 @@ static enum resp_states do_complete(struct rxe_qp *qp,
 				pkt->mask & RXE_WRITE_MASK) ?
 					IB_WC_RECV_RDMA_WITH_IMM : IB_WC_RECV;
 		wc->vendor_err = 0;
-		wc->byte_len = wqe->dma.length - wqe->dma.resid;
+		wc->byte_len = (pkt->mask & RXE_IMMDT_MASK &&
+				pkt->mask & RXE_WRITE_MASK) ?
+					qp->resp.length : wqe->dma.length - wqe->dma.resid;
 
 		/* fields after byte_len are different between kernel and user
 		 * space
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index 157e51aeb1e1..f99eab4da78b 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -213,6 +213,7 @@ struct rxe_resp_info {
 	struct rxe_mem		*mr;
 	u32			resid;
 	u32			rkey;
+	u32			length;
 	u64			atomic_orig;
 
 	/* SRQ only */
-- 
2.20.1

