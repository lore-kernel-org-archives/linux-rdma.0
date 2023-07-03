Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C55EB64DC
	for <linux-rdma@archiver.kernel.org>; Mon,  3 Jul 2023 12:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjGCMBz (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 3 Jul 2023 08:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjGCMBy (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 3 Jul 2023 08:01:54 -0400
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388DC109
        for <linux-rdma@vger.kernel.org>; Mon,  3 Jul 2023 05:01:53 -0700 (PDT)
Received: from buildd-manager.lp.internal (buildd-manager.lp.internal [10.131.66.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 227CB3F0E5
        for <linux-rdma@vger.kernel.org>; Mon,  3 Jul 2023 12:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
        s=20210803; t=1688385711;
        bh=qcpSRp5/llmZeVCO/Va40UWDbBOjfNm0a/Nvn0e9/vc=;
        h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
         Reply-To;
        b=iE+9PQnNwRThg6XnJcQzeO26VdE5zNX7JaWjlCon6VI2lEPv7VKhnheGS2IqRSr90
         aWV/uu+R2FEixmn8EKKyl65Mz9GeO+54JThyyHJt9mfe4/TbBjza1QelC6+K/KyCBW
         0+Ge4rn0ahN1wVBFn+mN/Y/s4EBDmNTTyhSaxjQJVFgqkQW0n7h04RSvifhTnlg7TR
         DQpj3+s+lw0FP84M3gGU3NIreQwBZUNPien8JGJFIq/CXZ3UeknuakP/mHLJzyCjgo
         /dr6n+zKz0P6w8EVJmvPXZnFHb4FUyuoIN610ma6x0Rbyq+sLSzLO89X3X8uvnJOUn
         KHFrJ0+pz/hQg==
Received: from juju-4112d9-prod-launchpad-manual-servers-4.lp.internal (localhost [127.0.0.1])
        by buildd-manager.lp.internal (Postfix) with ESMTP id 03FC0C13D8
        for <linux-rdma@vger.kernel.org>; Mon,  3 Jul 2023 12:01:51 +0000 (UTC)
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
Subject: [recipe build #3567602] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <168838571099.790.8798780794926873797.launchpad@juju-4112d9-prod-launchpad-manual-servers-4.lp.internal>
Date:   Mon, 03 Jul 2023 12:01:50 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
X-Generated-By: Launchpad (canonical.com); Revision="0574793d91fb0560c250e5488455be37b7fc4914"; Instance="buildmaster"
X-Launchpad-Hash: 6943f04000600953e01af9c8cb2bd8072e343e92
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 2 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/3567602/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-032

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/3567602
Your team Linux RDMA is the requester of the build.

