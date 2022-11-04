Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB3C7C4332F
	for <linux-rdma@archiver.kernel.org>; Fri,  4 Nov 2022 23:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiKDXsF (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiKDXsF (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 4 Nov 2022 19:48:05 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8542E9D3
        for <linux-rdma@vger.kernel.org>; Fri,  4 Nov 2022 16:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667605683; x=1699141683;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KgKjkB5rYuTX05QaYuX4uKsDvTsq9q9dYl+7WTdP1Gc=;
  b=TrQ2N1w5Ne0UptNpfoNRrU0FOkXw2vcLhzotoEUqNN7JylB1E2mSf0oU
   f9pc5aXs9hIeu78sBlSZailnXoqFhYs0PusgG5e1wCZDYwAjKC7ETnPBH
   tkJreXGGiDnfgybcbYj5KX1v/IdVlZZ3yBDd1OpQDNMaaDYM3sQXoxXwe
   50gbUzyJmnMX9swDF8OeJr3iytF7cgly4U34wbGtgtFg0pk9e1KQbuWRw
   NmVHtVL90/IwKuEnyPxPcuIy2Uq6G3xu5qoEe2dAUNdi8vFzKqQbdzqrx
   9rH/rrWj5UZlxpaTVXX2ME3t88hXSxaim0Yg5sBfO594Ntri9PfBd2DvH
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="289826780"
X-IronPort-AV: E=Sophos;i="5.96,139,1665471600"; 
   d="scan'208";a="289826780"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 16:48:03 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="586352304"
X-IronPort-AV: E=Sophos;i="5.96,139,1665471600"; 
   d="scan'208";a="586352304"
Received: from ssaleem-mobl1.amr.corp.intel.com ([10.255.38.106])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 16:48:02 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     jgg@nvidia.com, leon@kernel.org
Cc:     linux-rdma@vger.kernel.org, Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH for-next 0/3] irdma for-next updates 11-4-2022
Date:   Fri,  4 Nov 2022 18:47:46 -0500
Message-Id: <20221104234749.1084-1-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.35.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

This series adds inline support when multiple SGE's are used
as well fixes for WC RQ completion opcodes and to not use level 2
PBLEs for virtual CQs.

Mustafa Ismail (3):
  RDMA/irdma: Fix inline for multiple SGE's
  RDMA/irdma: Fix RQ completion opcode
  RDMA/irdma: Do not request 2-level PBLEs for CQ alloc

 drivers/infiniband/hw/irdma/uk.c    | 164 ++++++++++++++++++++++--------------
 drivers/infiniband/hw/irdma/user.h  |  19 +----
 drivers/infiniband/hw/irdma/utils.c |   2 +
 drivers/infiniband/hw/irdma/verbs.c | 163 ++++++++++++++++++-----------------
 4 files changed, 190 insertions(+), 158 deletions(-)

-- 
1.8.3.1

