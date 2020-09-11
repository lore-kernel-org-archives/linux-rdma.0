Return-Path: <SRS0=TzmY=CU=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29055C433E2
	for <linux-rdma@archiver.kernel.org>; Fri, 11 Sep 2020 18:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE9E821D92
	for <linux-rdma@archiver.kernel.org>; Fri, 11 Sep 2020 18:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599849442;
	bh=/E2pss7VAMWLoLXBfSFfkC0KoS0AbiwrOCSGwVjNc/s=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=2KFgR+klGrfkdORXJQzYy8UiPw7NWiu+T2VJqfAhkWL9anoINZW+qJYG5ZqSTFH1+
	 KMt9kqC0Iv+CPgHnaaG0XgTC0/tgFmzOmvWNc6Sk1x2SgG5PCMF9cRzOrzz79tHZoa
	 GRQ8r+UlQn6vrVACwjpT28zHgi+AT9ZCEH2kL7T8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgIKShT (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 11 Sep 2020 14:37:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgIKShN (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 11 Sep 2020 14:37:13 -0400
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599849432;
        bh=/E2pss7VAMWLoLXBfSFfkC0KoS0AbiwrOCSGwVjNc/s=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=qaaENzTuVbWEz439fl4vRj+R1h4B4PBe46JHo3k4MCFnTpPb1i8Qs9LpG8IcFKBV+
         pQU1Cf3WTkpcCwFDAh0B7cOYJmYVkN/zCS0hzBrIwvnqvr1t4sj0UIIynyQVz/8ag9
         GRoHgPGyvgwNceoPBvOQq9eV/0fZ4LMoVQyq9ooo=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200910233810.GA1105033@nvidia.com>
References: <20200910233810.GA1105033@nvidia.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200910233810.GA1105033@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: 0b089c1ef7047652b13b4cdfdb1e0e7dbdb8c9ab
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b1df2a0783f3d80d6d37102eb90f06727113c7dc
Message-Id: <159984943257.11596.11187194091004907407.pr-tracker-bot@kernel.org>
Date:   Fri, 11 Sep 2020 18:37:12 +0000
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The pull request you sent on Thu, 10 Sep 2020 20:38:10 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b1df2a0783f3d80d6d37102eb90f06727113c7dc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
