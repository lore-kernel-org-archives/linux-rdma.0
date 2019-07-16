Return-Path: <SRS0=vSG6=VN=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32D7C76192
	for <linux-rdma@archiver.kernel.org>; Tue, 16 Jul 2019 04:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC5CE2173C
	for <linux-rdma@archiver.kernel.org>; Tue, 16 Jul 2019 04:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563251734;
	bh=50fmNU3ziyqCRmp663QLiOmaXMoDkqZAiM4c1gJQvG0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=bRH+hUWHNEdaWsfpil7xvVHmEtFkbgOawbbciTeRUlZbxtxjI8qQ+AklrOKHci59R
	 V8egoeBv6cGaHZaY7uriBl6BJY3RtvdQlbDhyly06K29T3X1Diq9vQScFMPcbnYeqP
	 0CsEP62aHl7N7IKQm4N/GNZDw5gWZGiAwXm3tyEQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733200AbfGPEfT (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 16 Jul 2019 00:35:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733198AbfGPEfT (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 16 Jul 2019 00:35:19 -0400
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563251718;
        bh=50fmNU3ziyqCRmp663QLiOmaXMoDkqZAiM4c1gJQvG0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=LJGYGNvECtunQ4c68jZDRaiufj5ln4liiHrS5Cesrb2O1R8ATf3zvsDCRfNlGMWiG
         tHqZqCJAZCpB8/mW6VFxWj5QuJ8t6XwIz6SOSbQgnxRN+ZzE9L93A2BmDdBDUJupF8
         r5J4+GaegObA6PIAYTexusiw2bRjwfZslVF4PHeA=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190715152618.GA32337@ziepe.ca>
References: <20190715152618.GA32337@ziepe.ca>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190715152618.GA32337@ziepe.ca>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: 0b043644c0ca601cb19943a81aa1f1455dbe9461
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2a3c389a0fde49b241430df806a34276568cfb29
Message-Id: <156325171855.15429.15040584849312932393.pr-tracker-bot@kernel.org>
Date:   Tue, 16 Jul 2019 04:35:18 +0000
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Doug Ledford <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The pull request you sent on Mon, 15 Jul 2019 15:26:22 +0000:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2a3c389a0fde49b241430df806a34276568cfb29

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
