Return-Path: <SRS0=bUUW=5S=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D765BC43331
	for <linux-rdma@archiver.kernel.org>; Thu,  2 Apr 2020 02:05:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38B4D2072E
	for <linux-rdma@archiver.kernel.org>; Thu,  2 Apr 2020 02:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585793118;
	bh=pD50+G67RvTnYdHaeKb2fCdRnpD/kpnt6hQ005gFHw0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=vDiF0m1AXcV65+CYckarx9pQiYQviwjTSCHSQbSe6o0XyeWMWxMLLywlkEl1VCPno
	 HIiZGFizWJCrIX0pqbnSqfn0CFzC5PvhTBvVxDOeuA9peDnPeoJU/6rFjbfSAz0Nhp
	 jCAhiQ53E7iwSevpFyynT0nzyjyplHzIiIwRv4c8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387421AbgDBCFR (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 1 Apr 2020 22:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387408AbgDBCFR (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 1 Apr 2020 22:05:17 -0400
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585793117;
        bh=pD50+G67RvTnYdHaeKb2fCdRnpD/kpnt6hQ005gFHw0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=IURR+xiMzxCVTNSfKhRqwpl62s6BqQZOP3hGT6zg7Ika1u4vhGiPkxxdRpqb7BO+0
         Gt53StEuJOKLBG4/tywO1dpP8NprauHaclFVNgy7dkedRw4vJGlq+If1iV2YfgxZf5
         bfEaTSlyYGpnZ7E7zwm8h5+OK18nykOcwQRssT94=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200401230133.GA14469@ziepe.ca>
References: <20200401230133.GA14469@ziepe.ca>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200401230133.GA14469@ziepe.ca>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: b4d8ddf8356d8ac73fb931d16bcc661a83b2c0fe
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 919dce24701f7b34681a6a1d3ef95c9f6c4fb1cc
Message-Id: <158579311701.873.13975313564510123629.pr-tracker-bot@kernel.org>
Date:   Thu, 02 Apr 2020 02:05:17 +0000
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The pull request you sent on Wed, 1 Apr 2020 20:01:33 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/919dce24701f7b34681a6a1d3ef95c9f6c4fb1cc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
