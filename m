Return-Path: <SRS0=hjws=EL=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E1FC4741F
	for <linux-rdma@archiver.kernel.org>; Thu,  5 Nov 2020 20:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9743C20735
	for <linux-rdma@archiver.kernel.org>; Thu,  5 Nov 2020 20:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604607686;
	bh=g0HNgZM1j+nqby7FWFlTAh5Tnd3g735kkQ+i4YA1wKc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=pRFudeTeB89Bb7lYiH/u5HWhrVmz2pEN845EcO4t/+5WRfSJSMChTuvAoEnrPsAb8
	 Y8NcWLmAiu+CQUZuy+05EGMxPYi+wDbhDu+WjQPsESC33d8hqpXcmNgMlhhLxwnsSC
	 CAmHowLNzSx7/1ucUQJUuW2MaYc9BT7XAmAQsm04=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732136AbgKEUVV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 5 Nov 2020 15:21:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:34538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbgKEUVU (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 5 Nov 2020 15:21:20 -0500
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604607679;
        bh=g0HNgZM1j+nqby7FWFlTAh5Tnd3g735kkQ+i4YA1wKc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=t2XOU+VCeSFgshKlq9IEBNqzIAiA6tS1p3kB9V/4PVKuaTosh8aoYB1va95hV/s8N
         hvXy/4Bg/aKKP1PAZf+gwkO7ukt0IkQ7q6k62Z6FgJuZgU3OsyxeofBWXQBvMvCBHf
         Saxi1bmq8JZpK2ugSongdvRtTehAuF1hc7/ersRo=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201105181636.GA80666@nvidia.com>
References: <20201105181636.GA80666@nvidia.com>
X-PR-Tracked-List-Id: <linux-rdma.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201105181636.GA80666@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: 21fcdeec09ff461b2f9a9ef4fcc3a136249e58a1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6f3f374ac05d05cfa63d04f4479ead7e3cb6d087
Message-Id: <160460767991.18865.15076452265074271780.pr-tracker-bot@kernel.org>
Date:   Thu, 05 Nov 2020 20:21:19 +0000
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The pull request you sent on Thu, 5 Nov 2020 14:16:36 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6f3f374ac05d05cfa63d04f4479ead7e3cb6d087

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
