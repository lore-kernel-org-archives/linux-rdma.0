Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 831C8C433F5
	for <linux-rdma@archiver.kernel.org>; Thu, 16 Sep 2021 12:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B67260E52
	for <linux-rdma@archiver.kernel.org>; Thu, 16 Sep 2021 12:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239331AbhIPMRF (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 16 Sep 2021 08:17:05 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:65178 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S239308AbhIPMRE (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 16 Sep 2021 08:17:04 -0400
IronPort-Data: =?us-ascii?q?A9a23=3ASklTvqgHt4zeO/24ja2aEnueX161ghIKZh0ujC4?=
 =?us-ascii?q?5NGQNrF6WrkUGn2MbD2HTPPzcY2OnfNhwPN6280kBuMTRx4Q2G1BspHw8FHgiR?=
 =?us-ascii?q?ejtX4rAdhiqV8+xwmwvdGo+toNGLICowPkcFhcwnT/wdOi8xZVA/fvQHOOkWbe?=
 =?us-ascii?q?aYnoZqTJME0/NtzoywobVvaY42bBVMyvV0T/Di5W31G2NglaYAUpIg063ky6Di?=
 =?us-ascii?q?dyp0N8uUvPSUtgQ1LPWvyF94JvyvshdJVOgKmVfNrbSq+ouUNiEEm3lExcFUrt?=
 =?us-ascii?q?Jk57wdAsEX7zTIROTzHFRXsBOgDAb/mprjPl9b6FaNC+7iB3Q9zx14MREs5OgD?=
 =?us-ascii?q?wU4FqPRmuUBSAQeGCZ7VUFD0OaefSXg65TMkSUqdFOpmZ2CFnoeJ5UV8/xsBmd?=
 =?us-ascii?q?O7fEwJzUEbxTFjOWzqJqpW+t+l8Z5dJGzFIwas3BkizreCJ4ORZ3ERY3J6MVe0?=
 =?us-ascii?q?TN2gdpBdd7caMUxbyRuYBXJJRZIPz8/DJM4gfftnHX6ehVGp1+P46k6+W7eyEp?=
 =?us-ascii?q?2yreFDTZ/UrRmXu0MxgDB+D2ApD+/X3kn2BWk4WLt2hqRaiXnx0sXgL4vKYA?=
 =?us-ascii?q?=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AF/X+fazw84IUHLUEP7ghKrPwSb1zdoMgy1kn?=
 =?us-ascii?q?xilNoH1uEvBw+PrCoB1273XJYVUqOU3I++ruBEDoexq1nqKdibNhXotKNzOLhI?=
 =?us-ascii?q?LHFu9f0bc=3D?=
X-IronPort-AV: E=Sophos;i="5.85,298,1624291200"; 
   d="scan'208";a="114572076"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 16 Sep 2021 20:15:42 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id 2EF1C4D0DC71;
        Thu, 16 Sep 2021 20:15:42 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Thu, 16 Sep 2021 20:15:42 +0800
Received: from Fedora-31.g08.fujitsu.local (10.167.220.99) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Thu, 16 Sep 2021 20:15:41 +0800
From:   Xiao Yang <yangx.jy@fujitsu.com>
To:     <linux-rdma@vger.kernel.org>, <jgg@nvidia.com>
CC:     <rpearsonhpe@gmail.com>, <zyjzyj2000@gmail.com>, <leon@kernel.org>,
        "Xiao Yang" <yangx.jy@fujitsu.com>
Subject: [PATCH v3 5/5] RDMA/rxe: Remove duplicate settings
Date:   Thu, 16 Sep 2021 20:46:52 +0800
Message-ID: <20210916124652.1304649-6-yangx.jy@fujitsu.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210916124652.1304649-1-yangx.jy@fujitsu.com>
References: <20210916124652.1304649-1-yangx.jy@fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 2EF1C4D0DC71.A985A
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@fujitsu.com
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Remove duplicate settings for vendor_err and qp_num.

Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index c850f8b0080d..6102ea36ed28 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -876,7 +876,6 @@ static enum resp_states do_complete(struct rxe_qp *qp,
 		wc->opcode = (pkt->mask & RXE_IMMDT_MASK &&
 				pkt->mask & RXE_WRITE_MASK) ?
 					IB_WC_RECV_RDMA_WITH_IMM : IB_WC_RECV;
-		wc->vendor_err = 0;
 		wc->byte_len = (pkt->mask & RXE_IMMDT_MASK &&
 				pkt->mask & RXE_WRITE_MASK) ?
 					qp->resp.length : wqe->dma.length - wqe->dma.resid;
@@ -897,8 +896,6 @@ static enum resp_states do_complete(struct rxe_qp *qp,
 				uwc->ex.invalidate_rkey = ieth_rkey(pkt);
 			}
 
-			uwc->qp_num		= qp->ibqp.qp_num;
-
 			if (pkt->mask & RXE_DETH_MASK)
 				uwc->src_qp = deth_sqp(pkt);
 
@@ -930,7 +927,6 @@ static enum resp_states do_complete(struct rxe_qp *qp,
 			if (pkt->mask & RXE_DETH_MASK)
 				wc->src_qp = deth_sqp(pkt);
 
-			wc->qp			= &qp->ibqp;
 			wc->port_num		= qp->attr.port_num;
 		}
 	}
-- 
2.25.1



