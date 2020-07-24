Return-Path: <SRS0=tt2b=BD=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A52AAC43461
	for <linux-rdma@archiver.kernel.org>; Fri, 24 Jul 2020 21:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D6812070E
	for <linux-rdma@archiver.kernel.org>; Fri, 24 Jul 2020 21:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595626830;
	bh=QqhCP1nRQIyKkXneM8FbaNyq/f4aKjtxooqH8/BVewE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=dohHdEVIOGE0edEIA24rhveZk+znBWoP7M/fkNz//zpGEOaSqy4E2CgtgGzvN0ZVu
	 qoFx8P6IVmCEN/+jOfIKhYHDPwRhtYGgfEBPC9B3eH7TnZ4rvFKObGwLeZ4wPRyFN7
	 Hi5n2EMURpHoTK3LDDjZqQ/Qm/NS8WsX8gcGEUAU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgGXVk1 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 24 Jul 2020 17:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:48938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbgGXVkG (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 24 Jul 2020 17:40:06 -0400
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595626806;
        bh=QqhCP1nRQIyKkXneM8FbaNyq/f4aKjtxooqH8/BVewE=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=WvCmQI+aTVTUef3lNiKq+yMWxec1gwT0tMoLaZ12GjeWqlhGubawK5lPm+kpb1Nni
         +MCYBXxzLiBvDEAj1pCjefTH17RH98wZzhOrvM+gkMMNM9i1wQCp8Q2tdNy7SrEFbS
         h8SkE39/6R0/MqVkD84ezK391gRFzfgHls1/BqUo=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200724174739.GA3635934@nvidia.com>
References: <20200724174739.GA3635934@nvidia.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200724174739.GA3635934@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: a862192e9227ad46e0447fd0a03869ba1b30d16f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fcef1046eb1b78c98105e9b68e48df6022c23a06
Message-Id: <159562680653.3064.12242876121090229215.pr-tracker-bot@kernel.org>
Date:   Fri, 24 Jul 2020 21:40:06 +0000
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The pull request you sent on Fri, 24 Jul 2020 14:47:39 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fcef1046eb1b78c98105e9b68e48df6022c23a06

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
