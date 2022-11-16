Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB588C4332F
	for <linux-rdma@archiver.kernel.org>; Wed, 16 Nov 2022 11:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbiKPLYm (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 16 Nov 2022 06:24:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237359AbiKPLYY (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 16 Nov 2022 06:24:24 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181CA2DF5
        for <linux-rdma@vger.kernel.org>; Wed, 16 Nov 2022 03:14:20 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668597258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=J+1ohFX7RGpAwny5hyMn2fUyi2S+OeGx6kdzZEFSssM=;
        b=uKZuRd3LNsCBLMOk/3oavcnf4jpskji0gkSN3jWBMNA4djxxD9hCHFE2eJ5xJAtp3KyFBE
        ddpUNncXk4HinoGqw3//u7kbIzrQb4U7YuvYlIvuiD0sOkGPjfWOQnJfQR1JTUSw78B5bp
        eHUsUKIB5wjr54FFBVKbH+TGW9irldo=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     haris.iqbal@ionos.com, jinpu.wang@ionos.com, jgg@ziepe.ca,
        leon@kernel.org
Cc:     linux-rdma@vger.kernel.org
Subject: [PATCH 0/8] Misc patches for rtrs
Date:   Wed, 16 Nov 2022 19:13:52 +0800
Message-Id: <20221116111400.7203-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi,

Pls review the latest version which has below changes.

1. drop 4 patches (one of them breaks compatibility which
   can do later after we collect similar changes to update
   proto version).

2. collect tags from Haris, thanks!

3. address other comments.

Thanks,
Guoqing

Guoqing Jiang (8):
  RDMA/rtrs-srv: Refactor rtrs_srv_rdma_cm_handler
  RDMA/rtrs-srv: Refactor the handling of failure case in map_cont_bufs
  RDMA/rtrs-srv: Correct the checking of ib_map_mr_sg
  RDMA/rtrs-clt: Correct the checking of ib_map_mr_sg
  RDMA/rtrs-srv: Remove outdated comments from create_con
  RDMA/rtrs: Clean up rtrs_rdma_dev_pd_ops
  RDMA/rtrs-srv: Fix several issues in rtrs_srv_destroy_path_files
  RDMA/rtrs-srv: Remove kobject_del from
    rtrs_srv_destroy_once_sysfs_root_folders

 drivers/infiniband/ulp/rtrs/rtrs-clt.c       |  6 +-
 drivers/infiniband/ulp/rtrs/rtrs-pri.h       |  3 -
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c | 13 ++--
 drivers/infiniband/ulp/rtrs/rtrs-srv.c       | 72 ++++++++------------
 drivers/infiniband/ulp/rtrs/rtrs.c           | 22 ++----
 5 files changed, 44 insertions(+), 72 deletions(-)

-- 
2.31.1

