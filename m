Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BADECAAA1
	for <linux-rdma@archiver.kernel.org>; Fri,  9 Sep 2022 19:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiIITN4 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 9 Sep 2022 15:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiIITNy (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 9 Sep 2022 15:13:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE19AA98FA;
        Fri,  9 Sep 2022 12:13:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E65BB8261A;
        Fri,  9 Sep 2022 19:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09AC1C433C1;
        Fri,  9 Sep 2022 19:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662750831;
        bh=FRorE2tqhivaqaiXvxumMf91B+pC0jEFrqK7ogJh1m8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=faeVX0sKA6LaeYFKMej/kIxhebnPzLJZOoSDBZ7kbm5bsQbPCiO3UOTNHti33YNBX
         Ac/R0cYIZyP2RzPy/2GTgjk7ZCwEhfGNwmccOhgy3vEcGmyfIDIGVXf9J6p/c8zrlW
         9ULQmyRSTxvc1OcgN/GPA35MgA5UB+8Kt8hegp+9L7yg1HC+V3q+pXLHeCvWdthIao
         9GHJuzHYl1qS1nvAmmYav4cnVWn0lCovpFH/vvz7uG3uYIPcpjbpVDLkqmop0zoBXF
         fBTvMRHXXUg1KxhL2xUc8Kl76tCflDWldvqDQl1GbRN/WbSToZmEetazKOD7UuazKt
         cW26h6UJQMYvg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EDB0FC4166E;
        Fri,  9 Sep 2022 19:13:50 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <YxtnD/fPifXhPxc/@nvidia.com>
References: <YxtnD/fPifXhPxc/@nvidia.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <YxtnD/fPifXhPxc/@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: a261786fdc0a5bed2e5f994dcc0ffeeeb0d662c7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0099baa87962799d19b05d12f39ff13600482645
Message-Id: <166275083096.6812.4422087407209852.pr-tracker-bot@kernel.org>
Date:   Fri, 09 Sep 2022 19:13:50 +0000
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The pull request you sent on Fri, 9 Sep 2022 13:17:19 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0099baa87962799d19b05d12f39ff13600482645

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
