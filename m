Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA1DC433F5
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Sep 2021 12:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D668610E9
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Sep 2021 12:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237745AbhIOMeK (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 15 Sep 2021 08:34:10 -0400
Received: from lpdvsmtp09.broadcom.com ([192.19.166.228]:46804 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233011AbhIOMeG (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 15 Sep 2021 08:34:06 -0400
Received: from dhcp-10-192-206-197.iig.avagotech.net.net (dhcp-10-123-156-118.dhcp.broadcom.net [10.123.156.118])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 59AC722586;
        Wed, 15 Sep 2021 05:32:46 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 59AC722586
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1631709167;
        bh=Dvxy4dp58wU/IqBtBrVHgExJeimO8KzAjG+m8UAKsd4=;
        h=From:To:Cc:Subject:Date:From;
        b=ZVh+NcaTfTDDvrvEDIbEuvu/iGClZOusrx3lUFjFN7OPJOLgPQV16R+yWHXGb3uik
         Ad4u7JafU8D2BFDwRsBn5O2EtpE2cA/FwdQfVN/KB+iaQ4ICUncIsdVvIBiuJlw+8m
         jutwU/4w7T65zYpkWf7+tU9ulzXn+HXPDx0d2z84=
From:   Selvin Xavier <selvin.xavier@broadcom.com>
To:     dledford@redhat.com, jgg@nvidia.com
Cc:     linux-rdma@vger.kernel.org
Subject: [PATCH for-next v2 00/12] RDMA/bnxt_re: Driver update
Date:   Wed, 15 Sep 2021 05:32:31 -0700
Message-Id: <1631709163-2287-1-git-send-email-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.5.5
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Includes some feature updates and bug fixes for bnxt_re driver.

Please review and apply.

Thanks,
Selvin Xavier

v1->v2:
 Fixed review comments from Leon

Edwin Peer (1):
  RDMA/bnxt_re: Use separate response buffer for stat_ctx_free

Selvin Xavier (11):
  RDMA/bnxt_re: Add extended statistics counters
  RDMA/bnxt_re: Update statistics counter name
  RDMA/bnxt_re: Reduce the delay in polling for hwrm command completion
  RDMA/bnxt_re: Support multiple page sizes
  RDMA/bnxt_re: Suppress unwanted error messages
  RDMA/bnxt_re: Fix query SRQ failure
  RDMA/bnxt_re: Fix FRMR issue with single page MR allocation
  RDMA/bnxt_re: Use GFP_KERNEL in non atomic context
  RDMA/bnxt_re: Correct FRMR size calculation
  RDMA/bnxt_re: Check if the vlan is valid before reporting
  MAINTAINERS: Update Broadcom RDMA maintainers

 MAINTAINERS                                 |   1 -
 drivers/infiniband/hw/bnxt_re/bnxt_re.h     |  19 +-
 drivers/infiniband/hw/bnxt_re/hw_counters.c | 277 ++++++++++++++++++----------
 drivers/infiniband/hw/bnxt_re/hw_counters.h |  30 ++-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c    |  35 +++-
 drivers/infiniband/hw/bnxt_re/main.c        |  13 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c    |  15 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c  |   6 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h  |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c   |   5 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.h   |   9 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.c    |  51 +++++
 drivers/infiniband/hw/bnxt_re/qplib_sp.h    |  28 +++
 drivers/infiniband/hw/bnxt_re/roce_hsi.h    |  85 +++++++++
 14 files changed, 439 insertions(+), 137 deletions(-)

-- 
2.5.5

