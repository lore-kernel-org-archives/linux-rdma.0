Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3037C47092
	for <linux-rdma@archiver.kernel.org>; Tue,  1 Jun 2021 05:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FA8E61396
	for <linux-rdma@archiver.kernel.org>; Tue,  1 Jun 2021 05:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhFAFvt (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 1 Jun 2021 01:51:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233000AbhFAFvr (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 1 Jun 2021 01:51:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 68372613C1;
        Tue,  1 Jun 2021 05:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622526606;
        bh=FlJ3viznYg3tQPzp32cHJMDq0VgTfFhuink3pMVQpak=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j9tCIW2uiXWerpJRpYzOHvPz4Ex2KdW4eTpE865S8wkehL1f+2Wb6gpJ4dodfMxEI
         H4N5s6wPcBLHQ8utwfj/Xl/HQ3y5jTICJHXJZL0TK1nBVBpTLitO2zdNqkToZdBs6Y
         hPmAvc3sCK/WdzFXpgJtX2FOnYS8r+F89kgavCfMO60A8ky1pDfa8klOTEwxSmaa1y
         /mT8pSMhtybzU0ZQx9QtsZnffiqNW+4HVCyRzVCvOdUgW0Od8p4DGVOeZiUjmE0v6j
         96YNIUt2058qGYNbvP0rWwsIGNwuaUqfDnE1IFrNvIDn5lKlIuwl6GjLWsuvp+cZWF
         yaVGqVrHzpkTg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] rds: Fix spelling mistakes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162252660640.4642.2796141808873153557.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 05:50:06 +0000
References: <20210531063617.3018637-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210531063617.3018637-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        santosh.shilimkar@oracle.com
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 31 May 2021 14:36:17 +0800 you wrote:
> Fix some spelling mistakes in comments:
> alloced  ==> allocated
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/rds/ib_ring.c  | 2 +-
>  net/rds/tcp_recv.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] rds: Fix spelling mistakes
    https://git.kernel.org/netdev/net-next/c/379aecbce08f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


