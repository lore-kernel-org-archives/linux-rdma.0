Return-Path: <SRS0=pCwc=B7=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC8AC433E1
	for <linux-rdma@archiver.kernel.org>; Fri, 21 Aug 2020 17:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C8D420748
	for <linux-rdma@archiver.kernel.org>; Fri, 21 Aug 2020 17:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598030347;
	bh=q6rfVjn0yYm6ThxeEtdzNfNV7StWYionyldIVlJ8C5I=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=ORAmWa4zdCcLJcHALcD5c0dQgAKk1BcZgoKQNfv7f0TYrGvUwwE5WIRzTYKy3iB+t
	 x4BuChPRwJTxqXFwE2EFlk/7WL3vtt/qTnf3g+WBMCe3RSwuWrDCwubkCCd533Kg4o
	 hPJsgg3uPuClSfHQ7N6yzP8+qZnf6eivn+HwPuDI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbgHURQw (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 21 Aug 2020 13:16:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728935AbgHURQV (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 21 Aug 2020 13:16:21 -0400
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598030180;
        bh=q6rfVjn0yYm6ThxeEtdzNfNV7StWYionyldIVlJ8C5I=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=f9bz0sbcpokVFDROQn1sw4RpkvwN6hA8K+gR+QVzoLXaYLz96CQVWIRYaR7mxJwse
         73Gp4KA8qEV0eFTPO77xKjkdwrOv+YqIqZlbwOu+AqxFOzF4h2UOgIPiLICulDxw0D
         vea5mOT/Cb6VAKYK4POdCPwxbg8vA7j2J2asmAg8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200821140612.GA2665062@nvidia.com>
References: <20200821140612.GA2665062@nvidia.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200821140612.GA2665062@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: f6da70d99c96256f8be0cbb4dd72d45d622c7823
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cd02217a5d813e2bbec984a9eeb8280ff290a150
Message-Id: <159803018077.29562.10055519306729526899.pr-tracker-bot@kernel.org>
Date:   Fri, 21 Aug 2020 17:16:20 +0000
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The pull request you sent on Fri, 21 Aug 2020 11:06:12 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cd02217a5d813e2bbec984a9eeb8280ff290a150

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
