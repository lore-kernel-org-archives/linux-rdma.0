Return-Path: <SRS0=eUhC=7S=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1152DC433E0
	for <linux-rdma@archiver.kernel.org>; Fri,  5 Jun 2020 21:15:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5DB9207DF
	for <linux-rdma@archiver.kernel.org>; Fri,  5 Jun 2020 21:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591391731;
	bh=KsA5/eoO5bcA2oE6HJOuUDNy5txaV/ZnJBGEp3uGcK8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=IqAG86WEwlHhckPN9MQfWnEeDqB//57lMjYHCFA0cH1WtovnnKwvo6lMAsL3G3Fw8
	 djGv9RoO788qmvHZ+IcVgYrA1Z/O2FpASL74NnYbcCH0XY/Mm3M4DrWvr+8k6mWEXe
	 TO9jaX9PWjT/SRbDkK9SajBQS/CKI4Y0fIx0pFtk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgFEVPa (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 5 Jun 2020 17:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728533AbgFEVPQ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 5 Jun 2020 17:15:16 -0400
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591391716;
        bh=KsA5/eoO5bcA2oE6HJOuUDNy5txaV/ZnJBGEp3uGcK8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=eY43VEk0m8ZGH1PRELRqwlm9pfYgXissAD96oNb6HMaY97Hzs22xlaIvK2C11ZnRu
         ItO4oofKFTgVCWbemcmDvaKP3oxrNubE+bGjG/0lw9D6M5XwcxDAxPiXzYWgssWhnG
         ZXJkRIJlFhjDWZxHoq0/AHgPz/Y0cCv2o0Ju8iGE=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200604195131.GA362249@ziepe.ca>
References: <20200604195131.GA362249@ziepe.ca>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200604195131.GA362249@ziepe.ca>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus
X-PR-Tracked-Commit-Id: fba97dc7fc76b2c9a909fa0b3786d30a9899f5cf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 242b23319809e05170b3cc0d44d3b4bd202bb073
Message-Id: <159139171609.26946.18224052473915997990.pr-tracker-bot@kernel.org>
Date:   Fri, 05 Jun 2020 21:15:16 +0000
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The pull request you sent on Thu, 4 Jun 2020 16:51:31 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/242b23319809e05170b3cc0d44d3b4bd202bb073

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
