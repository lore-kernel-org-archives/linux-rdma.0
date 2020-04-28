Return-Path: <SRS0=o1Ax=6M=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 637B0C83008
	for <linux-rdma@archiver.kernel.org>; Tue, 28 Apr 2020 20:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F0CE208E0
	for <linux-rdma@archiver.kernel.org>; Tue, 28 Apr 2020 20:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588106418;
	bh=jQJ8NzfnAGQnbM0MzVH1OciL2juYiBUJU2CbelN3t0A=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=awAQ0i4zF/a/vjxhGT4e454b5a6eZ9rX/qYf/Zs6sRczCS9fowQw2429fUkaQ3pIZ
	 mY2pVwyzrSQPIVJeUgqWqNbMrXih8jmeBbXYgU3yvAzOeZuTT1gytyUzG6xJKFPMF9
	 MlLU9k+K9+CnccOx4Kgjk+GSXQDVC/4doUkXqBRA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgD1UkO (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 28 Apr 2020 16:40:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgD1UkN (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 28 Apr 2020 16:40:13 -0400
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588106413;
        bh=jQJ8NzfnAGQnbM0MzVH1OciL2juYiBUJU2CbelN3t0A=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=b6zWkxV4LQ6UxZNmSfXa1Ts68g+jnEF9b6QmZfngkR/XZ+FgpLh6pEOQ+8CoEVgTT
         qN+Vz9RXqM5AtBuwQzaIKfPGBxeygTzM+j66H+ktjixMdMkwV2T7E7utvHIjJ9abfX
         uiD8meSvmRH0ZkO/5BQ32Mu9dBAn4aeH1piUz6Ow=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200428195914.GA24418@ziepe.ca>
References: <20200428195914.GA24418@ziepe.ca>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200428195914.GA24418@ziepe.ca>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: f0abc761bbb9418876cc4d1ebc473e4ea6352e42
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: edb98d162418e90d6d2c1cec42e09be0375cfd88
Message-Id: <158810641295.6200.14784665547268309787.pr-tracker-bot@kernel.org>
Date:   Tue, 28 Apr 2020 20:40:12 +0000
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The pull request you sent on Tue, 28 Apr 2020 16:59:14 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/edb98d162418e90d6d2c1cec42e09be0375cfd88

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
