Return-Path: <SRS0=XmsV=CZ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95CD0C2D0F6
	for <linux-rdma@archiver.kernel.org>; Wed, 16 Sep 2020 00:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46ED42064E
	for <linux-rdma@archiver.kernel.org>; Wed, 16 Sep 2020 00:25:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="Qm82T3f3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgIPAZx (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 15 Sep 2020 20:25:53 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:63284 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbgIOOPx (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 15 Sep 2020 10:15:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600179354; x=1631715354;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RnJ46rws02ePvTbcTRdlemACM1FhbC+bbXlsPleekyw=;
  b=Qm82T3f3CTt3RvC0pEznk8D8Cq/FsQE6CySWNyXLS6O085TTnBszxMbX
   bhV/Jyby1q4rIpUjk2xVaiiB/lLJc6ta2r4xbKE3GuBlKGsxD2adRZRvS
   y3ZsCaOJouB/kybOXvsFMZxiIR0FpclkjWOTScSeNolgoXFpobW5HQbj4
   I=;
X-IronPort-AV: E=Sophos;i="5.76,430,1592870400"; 
   d="scan'208";a="54138568"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 15 Sep 2020 14:14:58 +0000
Received: from EX13D19EUB003.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id 44109221B5F;
        Tue, 15 Sep 2020 14:14:56 +0000 (UTC)
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 15 Sep 2020 14:14:54 +0000
Received: from 8c85908914bf.ant.amazon.com.com (10.85.91.6) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Tue, 15 Sep 2020 14:14:52 +0000
From:   Gal Pressman <galpress@amazon.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>,
        Alexander Matushevsky <matua@amazon.com>,
        Gal Pressman <galpress@amazon.com>
Subject: [PATCH for-next 0/2] EFA messages & RDMA read statistics
Date:   Tue, 15 Sep 2020 17:14:47 +0300
Message-ID: <20200915141449.8428-1-galpress@amazon.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi all,

This small series contains a small cleanup to the way we store our
statistics and exposes a new set of counters.
The new exposed counters report send/receive work requests counters and
RDMA read work requests counters.

Regards,
Gal

Daniel Kranzdorf (1):
  RDMA/efa: Add messages and RDMA read work requests HW stats

Gal Pressman (1):
  RDMA/efa: Group keep alive received counter with other SW stats

 drivers/infiniband/hw/efa/efa.h               |  8 +--
 .../infiniband/hw/efa/efa_admin_cmds_defs.h   | 30 ++++++++-
 drivers/infiniband/hw/efa/efa_com_cmd.c       | 26 ++++++--
 drivers/infiniband/hw/efa/efa_com_cmd.h       | 16 +++++
 drivers/infiniband/hw/efa/efa_verbs.c         | 65 ++++++++++++++-----
 5 files changed, 117 insertions(+), 28 deletions(-)


base-commit: 9e054b13b2f747868c28539b3eb28256e237755f
-- 
2.28.0

