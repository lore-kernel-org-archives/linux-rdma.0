Return-Path: <SRS0=eFdo=WK=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F8DC433FF
	for <linux-rdma@archiver.kernel.org>; Wed, 14 Aug 2019 18:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD42F208C2
	for <linux-rdma@archiver.kernel.org>; Wed, 14 Aug 2019 18:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565807119;
	bh=qWSBdV3hWg97qBnKIsAim0F+3pcIzBkHQNQrfKrwysE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=kMN/jIl/ax3CybpqB5V9P+qrrlz2gf1Ui6NyIpzn7ZJUl2O80RBRFBr+yYKL/2vcN
	 ls2EQvgthMthusD06EX6KUKSXbstaAmQt2MWSYj7gsCA1MrazBnIczcFuhENoIByD1
	 bkKbuIz2R9+XbPWRMLOXokbsPgYyd81Lc5GjqpB4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbfHNSZN (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 14 Aug 2019 14:25:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728792AbfHNSZH (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 14 Aug 2019 14:25:07 -0400
Subject: Re: [PULL REQUEST] Please pull rdma.git
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565807106;
        bh=qWSBdV3hWg97qBnKIsAim0F+3pcIzBkHQNQrfKrwysE=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=gkteLbrh1zajdgg1tkLOPvlsyNvAojzUPsKrVgrktCi/Kfzsk83dm45ApY7UbYIOY
         mngYz5/xdZeXEqQofz+M2GZsyyxjemI/zbRZvjThBe8VghefXdo6a5YiQdY9wS+g7n
         wVgAxwWldg+20/K02Xxrxx7XQhDdrxTVmdA4r+wg=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <09bcafaab07dfde728357bfe61b6a7edfa3b25c9.camel@redhat.com>
References: <09bcafaab07dfde728357bfe61b6a7edfa3b25c9.camel@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <09bcafaab07dfde728357bfe61b6a7edfa3b25c9.camel@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: 2c8ccb37b08fe364f02a9914daca474d43151453
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a8dba0531bc0ba8b65e77a4a858da4b6eeaa1b92
Message-Id: <156580710639.11871.4883886338409398105.pr-tracker-bot@kernel.org>
Date:   Wed, 14 Aug 2019 18:25:06 +0000
To:     Doug Ledford <dledford@redhat.com>
Cc:     "Torvalds, Linus" <torvalds@linux-foundation.org>,
        "Gunthorpe, Jason" <jgg@ziepe.ca>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The pull request you sent on Wed, 14 Aug 2019 10:59:07 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a8dba0531bc0ba8b65e77a4a858da4b6eeaa1b92

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
