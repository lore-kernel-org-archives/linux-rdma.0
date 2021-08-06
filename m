Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FC48C4338F
	for <linux-rdma@archiver.kernel.org>; Fri,  6 Aug 2021 18:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D20E60ED6
	for <linux-rdma@archiver.kernel.org>; Fri,  6 Aug 2021 18:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242908AbhHFS12 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 6 Aug 2021 14:27:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236916AbhHFS11 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 6 Aug 2021 14:27:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BCEB560ED6;
        Fri,  6 Aug 2021 18:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628274431;
        bh=HqkGbMQ+6HmHFWSopmmgSfAdoq/upJOgHq9WPhlRrQI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=rCKI0LjG0Cy9/Iy0OWpAYKlP0tjRW6cmKPapGAG7ENomA/AZbFx4jpEwgW2I22CPv
         yS4uD4SzsDcTqjoqYT2g0sgV+OfUkRHAJRS9FD5yzfCxYQrEj7dRJUrjfU7wNRIXjI
         wfcB3g+ayMCwymx/ZqkCClmBLX7gDDlJHPnbD007r4V8dbyrzhjHRIdIjCggK/rYqW
         o+p6MV2JhwBIprhFPhzCVEUdkdeC/UnhvyXvLd6vPL/a9bUyyigZ4HkT5QEfJ8Z6q4
         EgnnXKefee2gDlbMs2lGawY/mZKnvYHXMo560KR9syuHn7o0klD5by5r6KWePFyC+6
         o/gJ45RfqB4hg==
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210806133039.GA3396590@nvidia.com>
References: <20210806133039.GA3396590@nvidia.com>
X-PR-Tracked-List-Id: <linux-rdma.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210806133039.GA3396590@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: 2638a32348bbb1c384dbbd515fd2b12c155f0188
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b4b927fcb0b2cdd344501b409f2bc68265aab45f
Message-Id: <162827443174.9282.9349396091754234660.pr-tracker-bot@kernel.org>
Date:   Fri, 06 Aug 2021 18:27:11 +0000
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The pull request you sent on Fri, 6 Aug 2021 10:30:39 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b4b927fcb0b2cdd344501b409f2bc68265aab45f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
