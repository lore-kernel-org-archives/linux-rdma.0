Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C33C4338F
	for <linux-rdma@archiver.kernel.org>; Sun, 25 Jul 2021 09:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 434BE6056B
	for <linux-rdma@archiver.kernel.org>; Sun, 25 Jul 2021 09:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhGYJJe (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 25 Jul 2021 05:09:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230370AbhGYJJe (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 25 Jul 2021 05:09:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8669A60F26;
        Sun, 25 Jul 2021 09:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627206604;
        bh=U9rECIpUm/XacYfhUYSayFYjKoTXF4eXWtqLVGy/kFc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gIuHj6lRE6tOh8xTqc67m/iNokF5BLs8vMaujKRwQzbTLmhoMgrNJ5Ticvq2YL+Qe
         5H4sQVNc6ZlzRp7fqQZUyglUxVRRGgOnBUR9UxCE15GxwuaccQdXtlA/XoOcuOBHhQ
         f8iUDXRpDd5nzDxhKQxbPYjFCXNIPbUvVTk2liqkqhXDZVVru69LJbDHO/c7OQMV1L
         glp1QzorkjPx+agOnsVFUDtmgEGqRshFqilOASeVR5nq6cFSk12N9AMKtuP+EvqJPF
         3568hkhGgh+k4VV1LsNiUuUeOzcFfXjGhtYN7NIE4o9iwz6C842PLyxWSoFUvDdBjp
         wZee9EtbHfHEQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mlx4: Fix missing error code in mlx4_load_one()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162720660449.12734.8611771205877417069.git-patchwork-notify@kernel.org>
Date:   Sun, 25 Jul 2021 09:50:04 +0000
References: <1627036569-71880-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1627036569-71880-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     tariqt@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 23 Jul 2021 18:36:09 +0800 you wrote:
> The error code is missing in this code scenario, add the error code
> '-EINVAL' to the return value 'err'.
> 
> Eliminate the follow smatch warning:
> 
> drivers/net/ethernet/mellanox/mlx4/main.c:3538 mlx4_load_one() warn:
> missing error code 'err'.
> 
> [...]

Here is the summary with links:
  - mlx4: Fix missing error code in mlx4_load_one()
    https://git.kernel.org/netdev/net/c/7e4960b3d66d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


