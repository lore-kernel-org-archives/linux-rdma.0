Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67755C6FD18
	for <linux-rdma@archiver.kernel.org>; Wed, 19 Apr 2023 11:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbjDSLCs (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 19 Apr 2023 07:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbjDSLCr (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 19 Apr 2023 07:02:47 -0400
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6067297
        for <linux-rdma@vger.kernel.org>; Wed, 19 Apr 2023 04:02:41 -0700 (PDT)
Received: from buildd-manager.lp.internal (buildd-manager.lp.internal [10.131.66.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 454E14241B
        for <linux-rdma@vger.kernel.org>; Wed, 19 Apr 2023 11:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
        s=20210803; t=1681902159;
        bh=Gy091qVQdCK07jQqGx+kciYxKarRtBtyPHiFXbe7etw=;
        h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
         Reply-To;
        b=NvQuBMOezurgxerclzwReLs/S4AGO75NK9XKxO5fJ4flvxNFbVYM9W38YT+DsNmCt
         eXeUubJz1y+Dn5R3yACgtmqWMd7PBKnsiIzcMmEfYvXttojcCjK/dSGViehmE2r+Wj
         nuG9XMFOTrDf1ypvgtvfr2Tym43wsWADxgXjfoNYXSEJx1Rcv6gYzhdKrSEZ3vUyCI
         WtA0zZUoGpecon36yhbXw7bRQq5qkxVPsQdZflQ8pLK8d+pI/lV9dozwlI1Xne6gc6
         uY8n2U3IzRJzzvTwm6RwIx5GCK/38LOydslkthN4yZNXKJuKi5Q3WwehcVKuiVFxjr
         OCjK6n8IlyrPg==
Received: from juju-4112d9-prod-launchpad-manual-servers-4.lp.internal (localhost [127.0.0.1])
        by buildd-manager.lp.internal (Postfix) with ESMTP id 2F653BDEB9
        for <linux-rdma@vger.kernel.org>; Wed, 19 Apr 2023 11:02:39 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Launchpad-Message-Rationale: Requester @linux-rdma
X-Launchpad-Message-For: linux-rdma
X-Launchpad-Notification-Type: recipe-build-status
X-Launchpad-Build-State: MANUALDEPWAIT
X-Launchpad-Archive: ~linux-rdma/ubuntu/rdma-core-daily
To:     Linux RDMA <linux-rdma@vger.kernel.org>
From:   noreply@launchpad.net
Subject: [recipe build #3528689] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <168190215919.12723.739220334580666448.launchpad@juju-4112d9-prod-launchpad-manual-servers-4.lp.internal>
Date:   Wed, 19 Apr 2023 11:02:39 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
X-Generated-By: Launchpad (canonical.com); Revision="473868c1cc6b58a9bc722c23840374c93a7a274b"; Instance="buildmaster"
X-Launchpad-Hash: 31a90ac0212aa06edff78e047e7bff79fc2e01e5
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 2 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/3528689/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-101

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/3528689
Your team Linux RDMA is the requester of the build.

