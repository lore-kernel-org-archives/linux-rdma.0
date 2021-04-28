Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D18E2C43460
	for <linux-rdma@archiver.kernel.org>; Wed, 28 Apr 2021 11:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 958EA61422
	for <linux-rdma@archiver.kernel.org>; Wed, 28 Apr 2021 11:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhD1Lny (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 28 Apr 2021 07:43:54 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:33932 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhD1Lnx (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 28 Apr 2021 07:43:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619610189; x=1651146189;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VBBZFbAzu2PBgR1EAR3eDRzzrtbVM3trmZB3iMA+zxc=;
  b=b76rltgnmlB295oOsZubrWL/VAEu9q37Ux4toR1kyEmP+jybm+ay1WRO
   RlAFNqam3GFSb2ZHN4hXUU2/upJzoH1Aa6s7em59LKhJoXgG5mGQdhEiL
   cnavAAyFXynG221w3sax3klWxFByy12D/b/2SNn9hqvFaTvyDKgTUprEk
   k=;
X-IronPort-AV: E=Sophos;i="5.82,258,1613433600"; 
   d="scan'208";a="929710388"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 28 Apr 2021 11:43:00 +0000
Received: from EX13D02EUB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id C0376A06B5;
        Wed, 28 Apr 2021 11:42:59 +0000 (UTC)
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D02EUB002.ant.amazon.com (10.43.166.170) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 28 Apr 2021 11:42:57 +0000
Received: from 8c85908914bf.ant.amazon.com.com (10.85.90.101) by
 mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 28 Apr 2021 11:42:54 +0000
From:   Gal Pressman <galpress@amazon.com>
To:     David Ahern <dsahern@gmail.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Yossi Leybovich <sleybo@amazon.com>,
        Alexander Matushevsky <matua@amazon.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Gal Pressman <galpress@amazon.com>
Subject: [PATCH iproute2-next 1/2] rdma: update uapi headers
Date:   Wed, 28 Apr 2021 14:42:30 +0300
Message-ID: <20210428114231.96944-2-galpress@amazon.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210428114231.96944-1-galpress@amazon.com>
References: <20210428114231.96944-1-galpress@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Update rdma_netlink.h file upto kernel commit
6cc9e215eb27 ("RDMA/nldev: Add copy-on-fork attribute to get sys command")

Signed-off-by: Gal Pressman <galpress@amazon.com>
---
 rdma/include/uapi/rdma/rdma_netlink.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index 4aef76ae317b..37f583ee58fc 100644
--- a/rdma/include/uapi/rdma/rdma_netlink.h
+++ b/rdma/include/uapi/rdma/rdma_netlink.h
@@ -293,6 +293,10 @@ enum rdma_nldev_command {
 
 	RDMA_NLDEV_CMD_RES_MR_GET_RAW,
 
+	RDMA_NLDEV_CMD_RES_CTX_GET, /* can dump */
+
+	RDMA_NLDEV_CMD_RES_SRQ_GET, /* can dump */
+
 	RDMA_NLDEV_NUM_OPS
 };
 
@@ -533,6 +537,18 @@ enum rdma_nldev_attr {
 
 	RDMA_NLDEV_ATTR_RES_RAW,	/* binary */
 
+	RDMA_NLDEV_ATTR_RES_CTX,		/* nested table */
+	RDMA_NLDEV_ATTR_RES_CTX_ENTRY,		/* nested table */
+
+	RDMA_NLDEV_ATTR_RES_SRQ,		/* nested table */
+	RDMA_NLDEV_ATTR_RES_SRQ_ENTRY,		/* nested table */
+	RDMA_NLDEV_ATTR_RES_SRQN,		/* u32 */
+
+	RDMA_NLDEV_ATTR_MIN_RANGE,		/* u32 */
+	RDMA_NLDEV_ATTR_MAX_RANGE,		/* u32 */
+
+	RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK,	/* u8 */
+
 	/*
 	 * Always the end
 	 */
-- 
2.31.1

