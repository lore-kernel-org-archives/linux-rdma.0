Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D2FC4332F
	for <linux-rdma@archiver.kernel.org>; Sun, 12 Nov 2023 18:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjKLScL (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 12 Nov 2023 13:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjKLScL (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 12 Nov 2023 13:32:11 -0500
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0A2100
        for <linux-rdma@vger.kernel.org>; Sun, 12 Nov 2023 10:32:07 -0800 (PST)
Received: from juju-98d295-prod-launchpad-15.localdomain (buildd-manager.lp.internal [10.131.215.202])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id C728D41550
        for <linux-rdma@vger.kernel.org>; Sun, 12 Nov 2023 18:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
        s=20210803; t=1699813925;
        bh=PtaFuKIaQboqQFp8afYTAaemzoY4e90Mc8yPopU6OJc=;
        h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
         Reply-To;
        b=PpbHpeyeWDaRIkbLJv3sDbA/+PLVo+PulboxOgu/63Rr8LoQZ5wDXazbDDWATtNkH
         81vhMnUf43IUJFvbfUtPqExriCeyb2aQQb9mfWhn7Rz90QUQS9qEmEnJBwQMxXFIYG
         ylUpAyx60G1IXQdDV0PDk/SjN98AQBbNTzz1FcC6sCKJwZYw/njjjDyYG/GX5abPMk
         fEZ8LXUXcsGUs6/pvO89zGHwL8oQe+KS7x2J+/VLkGBJROGEVuaKPImhaY4jfhbhmX
         GlopIdkas93qpAKtR8roiKrnrhVCJhPG1QYWF7ysYfuFNl9SeMbUuMliFvgfDh5fmT
         sEjqO0Ym7KYPQ==
Received: from [10.131.215.202] (localhost [127.0.0.1])
        by juju-98d295-prod-launchpad-15.localdomain (Postfix) with ESMTP id BE1AF7F049
        for <linux-rdma@vger.kernel.org>; Sun, 12 Nov 2023 18:32:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Launchpad-Message-Rationale: Requester @linux-rdma
X-Launchpad-Message-For: linux-rdma
X-Launchpad-Notification-Type: recipe-build-status
X-Launchpad-Archive: ~linux-rdma/ubuntu/rdma-core-daily
X-Launchpad-Build-State: MANUALDEPWAIT
To:     Linux RDMA <linux-rdma@vger.kernel.org>
From:   noreply@launchpad.net
Subject: [recipe build #3632356] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <169981392576.3978024.2608392566740992545.launchpad@juju-98d295-prod-launchpad-15>
Date:   Sun, 12 Nov 2023 18:32:05 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
X-Generated-By: Launchpad (canonical.com); Revision="f1e537f62ee3967c2b3f24dd10eacf1696334fe6"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: a021215e65ef2e30276c61322db5bebaaffee084
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 2 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/3632356/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-045

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/3632356
Your team Linux RDMA is the requester of the build.

