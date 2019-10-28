Return-Path: <SRS0=4Nee=YV=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65580CA9EC0
	for <linux-rdma@archiver.kernel.org>; Mon, 28 Oct 2019 21:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3829D217D6
	for <linux-rdma@archiver.kernel.org>; Mon, 28 Oct 2019 21:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbfJ1Vkh convert rfc822-to-8bit (ORCPT
        <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 28 Oct 2019 17:40:37 -0400
Received: from smtp-internal.canonical.com ([91.189.90.122]:43867 "EHLO
        erinyes.canonical.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726834AbfJ1Vkh (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 28 Oct 2019 17:40:37 -0400
X-Greylist: delayed 993 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Oct 2019 17:40:36 EDT
Received: from alphecca.canonical.com ([91.189.89.254])
        by erinyes.canonical.com with esmtp (Exim 4.86_2 #2 (Debian))
        id 1iPCUc-0001zi-T3
        for <linux-rdma@vger.kernel.org>; Mon, 28 Oct 2019 21:24:02 +0000
Received: from alphecca.canonical.com (localhost [IPv6:::1])
        by alphecca.canonical.com (Postfix) with ESMTP id D89E5E00185
        for <linux-rdma@vger.kernel.org>; Mon, 28 Oct 2019 21:24:02 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-Launchpad-Message-Rationale: Requester @linux-rdma
X-Launchpad-Message-For: linux-rdma
X-Launchpad-Notification-Type: recipe-build-status
X-Launchpad-Archive: ~linux-rdma/ubuntu/rdma-core-daily
X-Launchpad-Build-State: FAILEDTOBUILD
To:     Linux RDMA <linux-rdma@vger.kernel.org>
From:   noreply@launchpad.net
Subject: [recipe build #2430482] of ~linux-rdma rdma-core-daily in bionic:
 Failed to build
Message-Id: <157229784288.24187.1374883879562344915.launchpad@alphecca.canonical.com>
Date:   Mon, 28 Oct 2019 21:24:02 -0000
Reply-To: noreply@launchpad.net
X-Generated-By: Launchpad (canonical.com);
 Revision="469f241f4e73cc0bdffa4e30654052a2af068e06";
 Instance="buildmaster-secrets-lazr.conf"
X-Launchpad-Hash: e89d38f4298d1772eadfd061c0cbdd8cf7e96aa7
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

 * State: Failed to build
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: bionic
 * Duration: 9 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebuild/2430482/+files/buildlog.txt.gz
 * Upload Log: 
 * Builder: https://launchpad.net/builders/lgw01-amd64-057

-- 
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebuild/2430482
Your team Linux RDMA is the requester of the build.
