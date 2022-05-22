Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA1FC433EF
	for <linux-rdma@archiver.kernel.org>; Sun, 22 May 2022 19:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350654AbiEVTub (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 22 May 2022 15:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350973AbiEVTuT (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 22 May 2022 15:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429263A199;
        Sun, 22 May 2022 12:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE276B80D24;
        Sun, 22 May 2022 19:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74562C34117;
        Sun, 22 May 2022 19:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653249012;
        bh=O7oPe56lE1BfAUYE0LyOBPCGa1awueae9b6gcbWGuTw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fsc9FpwV17AbL36RsW7UvuaklAXWbY9TF34ya1MRsDOMJJI+RKG49WRhMxridutYu
         ctTkdEloz3Q1B1rg8aZOJ5CIp/hKncbDxYW0hPiOuFrspj6gJfyUinNai1CgBmAuEX
         pSWHszjWwRkTVDnSqVbbteHSPQq9/P8JqpcJbURmJRKyylzs01RBebf5/fnbirWhK4
         x2WmV1E1FCBx9wB6DYycjqLX1yP4m+FltUsZfeh2Xxoylh9ZovMOx6GGX0C5wMIzBL
         ZCJMkJCBr2oE+K2rn3UkDGcil+l/3RysAY1Jk57GxZhXf+G0BfMIRt0/K7QtLvZXfG
         3R+qaOwFiPdHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B8F6F0389D;
        Sun, 22 May 2022 19:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/mlx5: fix typo in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165324901237.28407.8956805840962763918.git-patchwork-notify@kernel.org>
Date:   Sun, 22 May 2022 19:50:12 +0000
References: <20220521111145.81697-21-Julia.Lawall@inria.fr>
In-Reply-To: <20220521111145.81697-21-Julia.Lawall@inria.fr>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     saeedm@nvidia.com, kernel-janitors@vger.kernel.org,
        leon@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 21 May 2022 13:10:31 +0200 you wrote:
> Spelling mistake (triple letters) in comment.
> Detected with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> 
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net/mlx5: fix typo in comment
    https://git.kernel.org/netdev/net-next/c/b0ea505ba0d7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


