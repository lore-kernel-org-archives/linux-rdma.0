Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A22C2B9F4
	for <linux-rdma@archiver.kernel.org>; Fri, 25 Jun 2021 16:24:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69B0161973
	for <linux-rdma@archiver.kernel.org>; Fri, 25 Jun 2021 16:24:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhFYQ0k (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 25 Jun 2021 12:26:40 -0400
Received: from mga06.intel.com ([134.134.136.31]:59672 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229776AbhFYQ0k (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 25 Jun 2021 12:26:40 -0400
IronPort-SDR: yZSL/zDec+3Cj4oZwXEyjUak6vRI5zhMS6jb+b4uG25EL2aLA5d4sLNlhg5rppYe7yHIz2VgBA
 sqHq9nabPE9A==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="268831259"
X-IronPort-AV: E=Sophos;i="5.83,299,1616482800"; 
   d="scan'208";a="268831259"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 09:24:18 -0700
IronPort-SDR: Fw9aDJtKca6sTXSMdO0PfVw7NcLtZD/ceu7artthTM5cI6FAUqGmxHvI9Q3qpMEJhknMlAPt/u
 wcMjYDSURSTA==
X-IronPort-AV: E=Sophos;i="5.83,299,1616482800"; 
   d="scan'208";a="624564411"
Received: from tenikolo-mobl1.amr.corp.intel.com ([10.212.85.35])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 09:24:17 -0700
From:   Tatyana Nikolova <tatyana.e.nikolova@intel.com>
To:     jgg@nvidia.com, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org, shiraz.saleem@intel.com,
        mustafa.ismail@intel.com,
        Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Subject: [PATCH v2 rdma-next 0/2] irdma coverity fixes
Date:   Fri, 25 Jun 2021 11:23:27 -0500
Message-Id: <20210625162329.1654-1-tatyana.e.nikolova@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

This is a short series of coverity fixes for irdma.

Shiraz Saleem (2):
  RDMA/irdma: Check contents of user-space irdma_mem_reg_req object
  RDMA/irdma: Fix potential overflow expression in irdma_prm_get_pbles

v1->v2
* Add u32 sums for u16 variables to show that the operations are overflow safe.
* Replace shifting ops with DIV_ROUND_UP_ULL macro to get bits_needed

 drivers/infiniband/hw/irdma/pble.h  |  2 +-
 drivers/infiniband/hw/irdma/utils.c |  4 ++--
 drivers/infiniband/hw/irdma/verbs.c | 26 ++++++++++++++++++++------
 3 files changed, 23 insertions(+), 9 deletions(-)

-- 
2.27.0

