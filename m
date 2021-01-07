Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8AFCC433DB
	for <linux-rdma@archiver.kernel.org>; Thu,  7 Jan 2021 06:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B24C422EBF
	for <linux-rdma@archiver.kernel.org>; Thu,  7 Jan 2021 06:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbhAGGr3 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 7 Jan 2021 01:47:29 -0500
Received: from relay.smtp-ext.broadcom.com ([192.19.232.172]:33964 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725959AbhAGGr3 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 7 Jan 2021 01:47:29 -0500
Received: from dhcp-10-192-206-197.iig.avagotech.net.net (dhcp-10-123-156-76.dhcp.broadcom.net [10.123.156.76])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 118897FCA;
        Wed,  6 Jan 2021 22:39:23 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 118897FCA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1610001565;
        bh=Su/6O2QNoi/dqn2QzijKijGkmBMOggGVoKuSImZTITo=;
        h=From:To:Cc:Subject:Date:From;
        b=GLq7rLhfeSPjnW7GkDgqKIvUUXYExkyClgCJeON8r2NQOGFSaYTpygq6HhokQtQDL
         6gV4LR5wkRKdEEPARblGC1jepc2xmt5gH6RMuuSw81oleDmtcB3wbnYChWwJ0ewj5L
         XPwc/MwV90PV0ogPE1cJsbUftCJFlWMJ8i4T+WWY=
From:   Selvin Xavier <selvin.xavier@broadcom.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-next 0/2] RDMA/bnxt_re: Allow bigger user MRs
Date:   Wed,  6 Jan 2021 22:39:17 -0800
Message-Id: <1610001559-13193-1-git-send-email-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.5.5
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Refactor user space MR code to handle bigger MRs. Removes couple of checks
that prevented the bigger MRs.

Selvin Xavier (2):
  RDMA/bnxt_re: Code refactor while populating user MRs
  RDMA/bnxt_re: Allow bigger MR creation

 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 47 ++++----------------------------
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 29 +++++---------------
 drivers/infiniband/hw/bnxt_re/qplib_sp.h |  2 +-
 3 files changed, 14 insertions(+), 64 deletions(-)

-- 
2.5.5

