Return-Path: <SRS0=YSgg=3U=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5114C2D0DB
	for <linux-rdma@archiver.kernel.org>; Fri, 31 Jan 2020 23:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA095214D8
	for <linux-rdma@archiver.kernel.org>; Fri, 31 Jan 2020 23:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580512228;
	bh=RJ4hEnBKQ4vU2Kc50VpoC/VFHcIqaZKJkDKyXg41Hv8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=zdr761i3NzmzNKugYlPTZPqqhO2csrQwK8GG9enrfH51zmf8s4a0D/cIk6ozihBxm
	 zTda+cg4FfFM8btXVItuXzHenucy5UQvXuBh2fFkbN2ugYWmnb/wDT4sj9KOrKG4SD
	 iyuk+yG22GHfCJfFoYlotwRFYWR6005sfhpcDIKI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbgAaXKT (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 31 Jan 2020 18:10:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727466AbgAaXKT (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 31 Jan 2020 18:10:19 -0500
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580512218;
        bh=RJ4hEnBKQ4vU2Kc50VpoC/VFHcIqaZKJkDKyXg41Hv8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=HB4A+71krCD/8W2n38erwXYKr6/CPs8BjtHu4ZGjKCf/PjT3UU8HM8AkBGDAcWK23
         zeeJnG3myfSWbyfWUbzbzTHiUqGBvXhL/5t7dwO9DjKKgtzQc1xPmAMIVVdhsieNJk
         61zQUR5ASVLWFtu2BeE/1twvOfuGnCiqrSjwi/V8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200131151622.GA1392@ziepe.ca>
References: <20200131151622.GA1392@ziepe.ca>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200131151622.GA1392@ziepe.ca>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: 8889f6fa35884d09f24734e10fea0c9ddcbc6429
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8fdd4019bcb2d824c5ab45c6fc340293cfed843f
Message-Id: <158051221891.10603.16655704288218051509.pr-tracker-bot@kernel.org>
Date:   Fri, 31 Jan 2020 23:10:18 +0000
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The pull request you sent on Fri, 31 Jan 2020 11:16:22 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8fdd4019bcb2d824c5ab45c6fc340293cfed843f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
