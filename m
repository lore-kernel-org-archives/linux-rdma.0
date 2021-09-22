Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C851C433EF
	for <linux-rdma@archiver.kernel.org>; Wed, 22 Sep 2021 13:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75718611C6
	for <linux-rdma@archiver.kernel.org>; Wed, 22 Sep 2021 13:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbhIVNli (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 22 Sep 2021 09:41:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232677AbhIVNlh (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 22 Sep 2021 09:41:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 03E0E611C9;
        Wed, 22 Sep 2021 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632318007;
        bh=AdtfQG4rLvA8AhCp2uE3qUlCt8ZO8mooGwPnslgZic0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lczqeXZjbdoRqjd1uo83E3tg6MjONWt1GKvVuvQbDAzcnK8zVGvGif32hq32KcuPv
         5Ohx/lnWmg0QE6SEEYai7b/Mj3B8OeFAb17a5EacAoj5OSHd/jxI9jc79Se1Chf85H
         2aYhMA4wsYgilypKNLbr0l7g52G1Xi2m3X7Dv6X2z/9DgZCxt9FQy3upqTKruxsjB+
         4G69x8oTD4+iXAbJn7Egb4pRBRCYiq74NJ0ZkYgWYpBK9nYQlrwjwZnExd/Jbanc5a
         1rXl/CE2uu/QATcQ852hMqojbQqfKL/+Twa9m3I3AUHD+0rs5g6Z/gvUK9odAAqC70
         WFHNX7h3Tg0yQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] qed: rdma - don't wait for resources under hw error
 recovery flow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163231800696.24457.18388174527817340428.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Sep 2021 13:40:06 +0000
References: <20210922105326.10653-1-smalin@marvell.com>
In-Reply-To: <20210922105326.10653-1-smalin@marvell.com>
To:     Shai Malin <smalin@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-rdma@vger.kernel.org, jgg@ziepe.ca, leon@kernel.org,
        aelior@marvell.com, malin1024@gmail.com, mkalderon@marvell.com
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 22 Sep 2021 13:53:26 +0300 you wrote:
> If the HW device is during recovery, the HW resources will never return,
> hence we shouldn't wait for the CID (HW context ID) bitmaps to clear.
> This fix speeds up the error recovery flow.
> 
> Fixes: 64515dc899df ("qed: Add infrastructure for error detection and recovery")
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net,v3] qed: rdma - don't wait for resources under hw error recovery flow
    https://git.kernel.org/netdev/net/c/1ea781232600

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


