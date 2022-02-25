Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F17DC433F5
	for <linux-rdma@archiver.kernel.org>; Fri, 25 Feb 2022 22:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236530AbiBYWQA (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 25 Feb 2022 17:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236694AbiBYWP7 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 25 Feb 2022 17:15:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418B018F226;
        Fri, 25 Feb 2022 14:15:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B36ED61C44;
        Fri, 25 Feb 2022 22:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2591BC36AE2;
        Fri, 25 Feb 2022 22:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645827326;
        bh=r/GgL5/YMee3eJN6gSMFNQgfSHE5lETu9MZRkSseqkU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=GredjddhcOS1Hd183qpkW3L2iuPiCyop5sPBmR7myP9RSLeY4pXMBHgUhqVLs54pe
         In6BY2koIbav0TO9zmUZUvjH3PEdsp1dxxN9wQXLc1G48ybJpXxaffyr6CFFQUVTEK
         /gr48uI0cGUeCZvT7Nmct4I5oxfGJl90N6ox7sPP3398mgXKZTkVab9qXNUAjojkwD
         3QFk4HNToPx5C2f7+Xj7z/NHAx7BUO2ZMtl6wz4FNbR4C84CMV3QYXm056jQcuIBct
         9JAD4AA63/8uGBPjxPDZ3/7skUn/CqgbTpJKiyfgoqN2YOhilCqTQnfNSeADkj2n1f
         Yp2UrOPbXbbQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 10E2EE6D4BB;
        Fri, 25 Feb 2022 22:15:26 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220225211629.GA352636@nvidia.com>
References: <20220225211629.GA352636@nvidia.com>
X-PR-Tracked-List-Id: <linux-rdma.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220225211629.GA352636@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: 22e9f71072fa605cbf033158db58e0790101928d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ca7457236d47d8748bdb6b423d148726220ec3d8
Message-Id: <164582732605.9849.1793697406867197811.pr-tracker-bot@kernel.org>
Date:   Fri, 25 Feb 2022 22:15:26 +0000
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The pull request you sent on Fri, 25 Feb 2022 17:16:29 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ca7457236d47d8748bdb6b423d148726220ec3d8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
