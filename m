Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A346C48BE5
	for <linux-rdma@archiver.kernel.org>; Tue, 22 Jun 2021 17:53:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A6AA61289
	for <linux-rdma@archiver.kernel.org>; Tue, 22 Jun 2021 17:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhFVRz0 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 22 Jun 2021 13:55:26 -0400
Received: from mga05.intel.com ([192.55.52.43]:40104 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231352AbhFVRzZ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 22 Jun 2021 13:55:25 -0400
IronPort-SDR: izlLB0gj203z5c2xxIMgSc7iJgaqA7yU5+66hbPc3bMeqMV9xBDOLaQ3JUqft0UMA82QpKKRdE
 dhkJh0q1zImg==
X-IronPort-AV: E=McAfee;i="6200,9189,10023"; a="292738727"
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="292738727"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 10:53:09 -0700
IronPort-SDR: J24ErgRilD4lLUrsK5Wa04Qo3XX0KFkrleup8LPL5+dZFIAqypE8zigv2/bWzEQSEaYSn/oeDM
 UGy8udwXELSg==
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="555863804"
Received: from tenikolo-mobl1.amr.corp.intel.com ([10.212.1.140])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 10:53:08 -0700
From:   Tatyana Nikolova <tatyana.e.nikolova@intel.com>
To:     jgg@nvidia.com, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org, shiraz.saleem@intel.com,
        mustafa.ismail@intel.com,
        Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Subject: [PATCH rdma-next 0/3] irdma coverity fixes
Date:   Tue, 22 Jun 2021 12:52:29 -0500
Message-Id: <20210622175232.439-1-tatyana.e.nikolova@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

This is a short series of coverity fixes for irdma.

Shiraz Saleem (3):
  RDMA/irdma: Check contents of user-space irdma_mem_reg_req object
  RDMA/irdma: Check return value from ib_umem_find_best_pgsz
  RDMA/irdma: Fix potential overflow expression in irdma_prm_get_pbles

 drivers/infiniband/hw/irdma/pble.h  |  2 +-
 drivers/infiniband/hw/irdma/utils.c |  4 ++--
 drivers/infiniband/hw/irdma/verbs.c | 26 +++++++++++++++++++++-----
 3 files changed, 24 insertions(+), 8 deletions(-)

-- 
2.27.0

