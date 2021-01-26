Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 211D8C433E9
	for <linux-rdma@archiver.kernel.org>; Tue, 26 Jan 2021 12:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F192E23121
	for <linux-rdma@archiver.kernel.org>; Tue, 26 Jan 2021 12:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392319AbhAZMId (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 26 Jan 2021 07:08:33 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:59480 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392278AbhAZMIa (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 26 Jan 2021 07:08:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1611662911; x=1643198911;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8B8tfcWJm9nCg9TV6KfQmiOU0t+HDDpOiaxs8q2A39Q=;
  b=FJ6oPIZuOq0j4i7ItPynTkLd4YRlgcwM1vz6qrwWPPYvYa6jjp/854LA
   TCYnNwZLxONwaNUIUQxnlQKGCt6Zqs8+yogFWdX+eS3O5W2fntGHds04i
   enyNtPDzdgb5Na1xb1AXGr06WceCUoK6vcj5IM0+CKTWYsixJTM+o+iC2
   I=;
X-IronPort-AV: E=Sophos;i="5.79,375,1602547200"; 
   d="scan'208";a="77442355"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 26 Jan 2021 12:07:44 +0000
Received: from EX13D02EUC004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id C6754A1AF4;
        Tue, 26 Jan 2021 12:07:42 +0000 (UTC)
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D02EUC004.ant.amazon.com (10.43.164.117) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 26 Jan 2021 12:07:41 +0000
Received: from 8c85908914bf.ant.amazon.com (10.1.213.21) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Tue, 26 Jan 2021 12:07:39 +0000
From:   Gal Pressman <galpress@amazon.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Doug Ledford <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>,
        Alexander Matushevsky <matua@amazon.com>,
        Gal Pressman <galpress@amazon.com>
Subject: [PATCH for-next 0/5] EFA cleanups 2021-01-26
Date:   Tue, 26 Jan 2021 14:06:56 +0200
Message-ID: <20210126120702.9807-1-galpress@amazon.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi,

This series contains misc cleanups to the EFA driver and device
definitions. Detailed descriptions can be found in the commit messages.

Thanks,
Gal

Gal Pressman (5):
  RDMA/efa: Remove redundant NULL pointer check of CQE
  RDMA/efa: Remove duplication of upper/lower_32_bits
  RDMA/efa: Remove unnecessary indentation in defs comments
  RDMA/efa: Remove unused 'select' field from get/set feature command
    descriptor
  RDMA/efa: Remove unused syndrome enum values

 .../infiniband/hw/efa/efa_admin_cmds_defs.h   | 25 ++++-----------
 drivers/infiniband/hw/efa/efa_admin_defs.h    |  4 +--
 drivers/infiniband/hw/efa/efa_com.c           | 31 +++++++------------
 3 files changed, 20 insertions(+), 40 deletions(-)


base-commit: f8e9a970159c7bd30429b86710397e9914fefbca
-- 
2.30.0

