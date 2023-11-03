Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA5FC4332F
	for <linux-rdma@archiver.kernel.org>; Fri,  3 Nov 2023 01:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377655AbjKCB0Y (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 2 Nov 2023 21:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377805AbjKCB0Y (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 2 Nov 2023 21:26:24 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF31187;
        Thu,  2 Nov 2023 18:26:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A88AC433C8;
        Fri,  3 Nov 2023 01:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698974781;
        bh=qs1qb2XWJjnfGBZjKMFP/jGmg/NhIwwYyLWKOuodmro=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=tYR4Xb/fxNoZD2WlFra5UT6AkzOoi88ZzXWnhq3V2dXYX9XgTvZIO9Pe+uXs1EdUl
         g5pSPDgvIoD+BpELEzSKc9HciE4rZThmYHsYlTwD+wM+9eE/X8MEa6xH2N5MH3IUw9
         Il0R/OQ6lSCz/RiKMPD19PBBR+jqw4YfwKrOJ5EQk2AOuxcsHjQglsEt/YuYa+7nAL
         Vh4KHw0iZj6z5KInjDkWl5hmvz6UzteA5Z+IS9NR/eVAqbIvdbjSmFoG7pVwQBOX5x
         Fqrqh+tiLxa5zSSzPDeOrmo13ZtzsCKXOZLs0cOGLJQ1Nbe2l9HBuLrnBSw6Sx7pdW
         dIximRWF0JCFw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2FC22C43168;
        Fri,  3 Nov 2023 01:26:21 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20231102230947.GA104602@nvidia.com>
References: <20231102230947.GA104602@nvidia.com>
X-PR-Tracked-List-Id: <linux-rdma.vger.kernel.org>
X-PR-Tracked-Message-Id: <20231102230947.GA104602@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: 2ef422f063b74adcc4a4a9004b0a87bb55e0a836
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 43468456c95b9e13c0592de51a9a530caa525c1f
Message-Id: <169897478118.31710.16816449726654070656.pr-tracker-bot@kernel.org>
Date:   Fri, 03 Nov 2023 01:26:21 +0000
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The pull request you sent on Thu, 2 Nov 2023 20:09:47 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/43468456c95b9e13c0592de51a9a530caa525c1f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
