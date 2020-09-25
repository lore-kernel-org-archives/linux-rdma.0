Return-Path: <SRS0=psLl=DC=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4035C4363D
	for <linux-rdma@archiver.kernel.org>; Fri, 25 Sep 2020 17:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C95A22B2D
	for <linux-rdma@archiver.kernel.org>; Fri, 25 Sep 2020 17:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601056125;
	bh=bHlnn4IQXNupVlYjh86GBHqX/lDGIr1TpYhM+/Cd+pk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=kOhngO6fOW20s83th0kbx9fMKYclfT02mkJHmBSVMC646ZisL4k/vBX5Qh4Iy3oMl
	 98lSkGZTw46cEpIK6sA55lUdzvopHVzzQghskhyXc5M4NxOO1jkrNYgm9/0N1Im3WB
	 d/jnI7CMRnKOh6KBpIYQ4aa/im2ZVFke3moT4VYk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgIYRsp (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 25 Sep 2020 13:48:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgIYRso (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 25 Sep 2020 13:48:44 -0400
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601056124;
        bh=bHlnn4IQXNupVlYjh86GBHqX/lDGIr1TpYhM+/Cd+pk=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=d72oN/bforNBKUaYrL6nwy4t4L60nngVBHVDVn4nVGCEYZn8BuDSWFHWRWJog0dXg
         nRlv8QvdOeTf89q5w6ty2MW7oP0OveKKJ/36c9VuIGApUiQNhcrevKHwO90VCNt9mn
         HsvGS5Xp26TKkwGWOKpi8wW1QgfdsVeLBAMhKBg8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200925125729.GA241108@nvidia.com>
References: <20200925125729.GA241108@nvidia.com>
X-PR-Tracked-List-Id: <linux-rdma.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200925125729.GA241108@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: 4aa1615268a8ac2b20096211d3f9ac53874067d7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 33d04c66f5799befa7c0c618be387541d0c311a3
Message-Id: <160105612449.19145.11391097152783968386.pr-tracker-bot@kernel.org>
Date:   Fri, 25 Sep 2020 17:48:44 +0000
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The pull request you sent on Fri, 25 Sep 2020 09:57:29 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/33d04c66f5799befa7c0c618be387541d0c311a3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
