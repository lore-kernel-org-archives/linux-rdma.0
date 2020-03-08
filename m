Return-Path: <SRS0=c/Wa=4Z=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75028C10F25
	for <linux-rdma@archiver.kernel.org>; Sun,  8 Mar 2020 02:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43D152073D
	for <linux-rdma@archiver.kernel.org>; Sun,  8 Mar 2020 02:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583632807;
	bh=GG2uckU09g+k7rvyZUCsLdvgOdd8dLKWmllSC50TIYo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=KU16P41DnuY/6PfUgxX15JKKAYSlmh5kC5YH9QrP0xpQqcUQBXYKXhQ1C1squjuCh
	 s/os16bSIYIHfEu5Hde/ELn0tf8960vAtaLa919FZwHYxBFQ4hTfn9mE07mAUfSPgu
	 /ES5GwXscd4EaO6k4c0yoJ+sYS0EX+vmPzOcUH4g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgCHCAG (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 7 Mar 2020 21:00:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:32982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbgCHCAG (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 7 Mar 2020 21:00:06 -0500
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583632805;
        bh=GG2uckU09g+k7rvyZUCsLdvgOdd8dLKWmllSC50TIYo=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=ng9gzc03NHjIuFZRiBMtg+idg6Ng60ypnZgSlgvaH3a/6ThL1SFRy968yAxuan/Iu
         nuLs5cPPKfooxSG5hYHJEz+pfLsh9YW2SGNE+QGU+tNlmayClQYTADFZ5RcPU9Wpiy
         tch4kts7k6tNrNb/rSdJAMW5hfolat1ncoQ5fiuk=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200308000718.GA27153@ziepe.ca>
References: <20200308000718.GA27153@ziepe.ca>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200308000718.GA27153@ziepe.ca>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: 810dbc69087b08fd53e1cdd6c709f385bc2921ad
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 61a09258f2e5b48ad0605131cae9a33ce4d01a9d
Message-Id: <158363280582.6802.15894724244872895526.pr-tracker-bot@kernel.org>
Date:   Sun, 08 Mar 2020 02:00:05 +0000
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The pull request you sent on Sat, 7 Mar 2020 20:07:18 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/61a09258f2e5b48ad0605131cae9a33ce4d01a9d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
