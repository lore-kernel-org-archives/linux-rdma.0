Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3345C38145
	for <linux-rdma@archiver.kernel.org>; Tue,  6 Sep 2022 22:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiIFWdI (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 6 Sep 2022 18:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiIFWdI (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 6 Sep 2022 18:33:08 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC218A7FE
        for <linux-rdma@vger.kernel.org>; Tue,  6 Sep 2022 15:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662503587; x=1694039587;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AXEooA5fm4VUUfEHd8ioq1brS4cGo8w9IY68+WarCgM=;
  b=XdpMtbQeMeh0IdcCIeVlHf+bs6Kq25PnUxFiNL+HxjhqVBMvJgcUqFpE
   +Y0i2lurLnz7C8qzttZiQDYzz7JHBDnCGwD7ccRhW4+01VIud/XDSLONX
   gAIyz18Z72l0uiLXOzrytFWfqgnHQot1Fb/2CEMenn0QxuoCsAa5xWIyM
   RrMqpvP+PpseuD7UqEWa3B4uQhuBPIYxkc77h+f12zSK+g8daIsi2j05U
   1inmgWsz5HeklVDIoCVv9dBaduANY7e5T9bc8pk0OWL3N8BrEJLgAeFrN
   0UvbgrENBG9kmz6pUgUagyeZXupU4GkWc3seMG9fiDolrFeIRJp5IazjT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="296724553"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="296724553"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 15:33:07 -0700
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="675898207"
Received: from ssaleem-mobl1.amr.corp.intel.com ([10.255.34.147])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 15:33:06 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     jgg@nvidia.com, leon@kernel.org
Cc:     linux-rdma@vger.kernel.org, Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH for-rc 0/5] irdma for-rc updates 9-6-2022
Date:   Tue,  6 Sep 2022 17:32:39 -0500
Message-Id: <20220906223244.1119-1-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.35.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

This series contains a small set of -rc fixes for 6.0 cycle.

Sindhu-Devale (5):
  RDMA/irdma: Report the correct max cqes from query device
  RDMA/irdma: Return error on MR deregister CQP failure
  RDMA/irdma: Return correct WC error for bind operation failure
  RDMA/irdma: Use s/g array in post send only when its valid
  RDMA/irdma: Report RNR NAK generation in device caps

 drivers/infiniband/hw/irdma/uk.c    |  7 +++++--
 drivers/infiniband/hw/irdma/utils.c | 13 ++++++++-----
 drivers/infiniband/hw/irdma/verbs.c | 13 ++++++++++---
 3 files changed, 23 insertions(+), 10 deletions(-)

-- 
1.8.3.1

