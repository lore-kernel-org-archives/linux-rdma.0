Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F2FC4338F
	for <linux-rdma@archiver.kernel.org>; Fri, 13 Aug 2021 22:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 755ED60E78
	for <linux-rdma@archiver.kernel.org>; Fri, 13 Aug 2021 22:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbhHMW0x (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 13 Aug 2021 18:26:53 -0400
Received: from mga03.intel.com ([134.134.136.65]:41681 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235029AbhHMW0x (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 13 Aug 2021 18:26:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10075"; a="215668289"
X-IronPort-AV: E=Sophos;i="5.84,320,1620716400"; 
   d="scan'208";a="215668289"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 15:26:22 -0700
X-IronPort-AV: E=Sophos;i="5.84,320,1620716400"; 
   d="scan'208";a="470215180"
Received: from tenikolo-mobl1.amr.corp.intel.com ([10.251.143.135])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 15:26:21 -0700
From:   Tatyana Nikolova <tatyana.e.nikolova@intel.com>
To:     jgg@nvidia.com
Cc:     dledford@redhat.com, leon@kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-core] irdma: Restore full memory barrier for doorbell optimization
Date:   Fri, 13 Aug 2021 17:25:49 -0500
Message-Id: <20210813222549.739-1-tatyana.e.nikolova@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210810115933.GB5158@nvidia.com>
References: <20210810115933.GB5158@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

>> 1.	Software writing the valid bit in the WQE.
>> 2.	Software reading shadow memory (hw_tail) value.

> You are missing an ordered atomic on this read it looks like

Hi Jason,

Why do you think we need atomic ops in this case? We aren't trying to protect from multiple threads but CPU re-ordering of a write and a read.

Thank you,
Tatyana
