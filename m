Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 336E8C433C1
	for <linux-rdma@archiver.kernel.org>; Thu, 25 Mar 2021 19:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6E29619B6
	for <linux-rdma@archiver.kernel.org>; Thu, 25 Mar 2021 19:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhCYTNo (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 25 Mar 2021 15:13:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229669AbhCYTNP (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 25 Mar 2021 15:13:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B909061A24;
        Thu, 25 Mar 2021 19:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616699594;
        bh=G/lqRqVKS0KLYQxs/OWRpN9Wm5iRVoI9HJhW3X9iEbo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=XozA3pzugAaR6imPPV27PPHyULuXR/OTrXyd+wlp7l1iUy+mcjUVqJhjusJ7bwfzl
         /yZUEcGbBB2z0gnpWElQeYkedjUnOkDhngrQYVOUyrj6vTQzivo8m+/wbHginvaO0l
         /60lvvCfK9J+OV95KGhZhAGUIiFChIoOYYPJySPZu6rENntp4yVwhEo9x24u7Za5Dq
         7YWygyFpDBRvIQ3uxX7p2keX6C+8xN785qUXlopBoJE7Ui/bw7laEwncHsKNBR3z5y
         YHQrgce6E+IoFvaHhVGYZ0hVKvfxeeSknY5RUIxavsL2zbiLRw562U/EPUa48FR5BJ
         4NFhBJ/ySkHjg==
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210325180421.GA702731@nvidia.com>
References: <20210325180421.GA702731@nvidia.com>
X-PR-Tracked-List-Id: <linux-rdma.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210325180421.GA702731@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: 3408be145a5d6418ff955fe5badde652be90e700
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2ba9bea2d3682361f0f22f68a400bcee4248c205
Message-Id: <161669959460.4184.7406357255941789148.pr-tracker-bot@kernel.org>
Date:   Thu, 25 Mar 2021 19:13:14 +0000
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The pull request you sent on Thu, 25 Mar 2021 15:04:21 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2ba9bea2d3682361f0f22f68a400bcee4248c205

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
