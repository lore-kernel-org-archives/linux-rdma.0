Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E26CAC00528
	for <linux-rdma@archiver.kernel.org>; Sat, 29 Jul 2023 00:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236019AbjG2A1O (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 28 Jul 2023 20:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236016AbjG2A1N (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 28 Jul 2023 20:27:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F282719;
        Fri, 28 Jul 2023 17:27:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4D8462204;
        Sat, 29 Jul 2023 00:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59BF8C433C8;
        Sat, 29 Jul 2023 00:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690590431;
        bh=SwdOc4rz663oEDuD3x6CQZq/2cxmz1J15PHjUZJzhy4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=swYLctjINOutMd9LOcn3ZBHAZIjRi+wOfHgkHV/hUgCdR2iUu801IjeV0jECucIf6
         l9NgAhxPvDu2aBdl57aUgkGtnLzyFY1DD4/jscJmeCeTAMBKRfjka/7IHSnyc7nwf5
         HG84TFW4/erZ5X/CesBu5iEIgeXGQeJ1IfN3US6NKIsjFBCKkU5Dnb0KaQ+b5rxF6b
         o1QUMFz5ABSOFMR1siLSbrDzYHxuZMCycAwmUiKkX6GmwV5jwOM8IfM6JX0ZZITh3z
         PtsEtO65LdJ6nj/KHzxLGmqBF4EyRLLvGqH9iVHVL+fi5IqfZt6Jnejue55H4XcX3N
         fiLD1ZS5C5H7Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4727DC4166F;
        Sat, 29 Jul 2023 00:27:11 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <ZMQOiZ9p1nStFHk/@nvidia.com>
References: <ZMQOiZ9p1nStFHk/@nvidia.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZMQOiZ9p1nStFHk/@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: ae463563b7a1b7d4a3d0b065b09d37a76b693937
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c06f9091a2913f9f76e68ce3e0a7f781546034b6
Message-Id: <169059043128.2110.3005672585789113126.pr-tracker-bot@kernel.org>
Date:   Sat, 29 Jul 2023 00:27:11 +0000
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The pull request you sent on Fri, 28 Jul 2023 15:52:57 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c06f9091a2913f9f76e68ce3e0a7f781546034b6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
