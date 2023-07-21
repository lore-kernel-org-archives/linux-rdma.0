Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E34C00528
	for <linux-rdma@archiver.kernel.org>; Fri, 21 Jul 2023 20:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjGUURc (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 21 Jul 2023 16:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjGUUR2 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 21 Jul 2023 16:17:28 -0400
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A618135A7
        for <linux-rdma@vger.kernel.org>; Fri, 21 Jul 2023 13:17:22 -0700 (PDT)
Received: from juju-98d295-prod-launchpad-15.localdomain (buildd-manager.lp.internal [10.131.215.202])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id A22003F03F
        for <linux-rdma@vger.kernel.org>; Fri, 21 Jul 2023 20:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
        s=20210803; t=1689970640;
        bh=Sr6Edhp2+Rxolbto3hXBbY/MSLqjzWxreFDxpAbOcCQ=;
        h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
         Reply-To;
        b=ZJ45XJh+PSTCx9cuJet0iPM+IqN1nrspfLnc0IHbGqpaN/5tHjZkwXHwRA8kkaTtn
         Qau1vcecnFL82Dgeu93+HJvYEouiUjVu3/XlCQ9PaCQgZGYQ2mUmJeMdqGWjdyM77m
         d3QrI0aqUILXNYUJaBPvjJ4eSloPorcK/GnGICSO3BdSv5emEpmnp82qD3OI4kVgcn
         lqd6j+tJoI8IlwplbNc37NHMxJEJ0PhJ55rwywoYJFqBrHOq/3r+slv4DnP7V/EHUD
         R7tfEwg90PVrt51hHTyHoB66+TRPJDAml/w3EjK8zxRCYFROrjnt5KGiag75Gg8Nu/
         TX9bdJwdM5G5A==
Received: from buildd-manager.lp.internal (localhost [127.0.0.1])
        by juju-98d295-prod-launchpad-15.localdomain (Postfix) with ESMTP id 8D7A87E001
        for <linux-rdma@vger.kernel.org>; Fri, 21 Jul 2023 20:17:20 +0000 (UTC)
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
Subject: [recipe build #3577014] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <168997064057.918229.8673501349804106664.launchpad@buildd-manager.lp.internal>
Date:   Fri, 21 Jul 2023 20:17:20 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
X-Generated-By: Launchpad (canonical.com); Revision="2bfac4503c7b6a57e9a8acd782035a16f97e2ddb"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 32cd43d527e0a76a89096cbe6db6955993d63ce6
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 2 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/3577014/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/bos03-amd64-030

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/3577014
Your team Linux RDMA is the requester of the build.

