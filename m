Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27DCEC0502A
	for <linux-rdma@archiver.kernel.org>; Wed, 31 Aug 2022 06:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiHaGaZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 31 Aug 2022 02:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiHaGaY (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 31 Aug 2022 02:30:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6DB5C36A;
        Tue, 30 Aug 2022 23:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62041B81F42;
        Wed, 31 Aug 2022 06:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0E863C43142;
        Wed, 31 Aug 2022 06:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661927418;
        bh=htLQg79mi3SvkoKP5SEjIUC3OCtpqE0sPOEq4nLXHS0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QtCR3Y5RYuUnBjmhDyX8LRveCXYFTG/m9Bk6ARazxCBxysIVT09VZIBrSX8H0JI8i
         ORaU74Q9xDjZ/B/2TCwVetW2tGYy4JCYrr67jLYH3YE1kIGZoDA2fczA9kVj5NZDIo
         XOBP84aQcScsaHqTxEgJ8Za7clV9hTJaFZZBGK02hsfMa7bgCTCEVmSequx9QbxJQu
         noC/KTh5PFdZbAus4JbX+1hAUwWJY6Pdq8XQe/09FWk315mZ9hxEYUfRrDux6xz9NQ
         aSVeOUJA/m20a84WUvKmEaI3NKcpsr7ofraI+3P/myq9XLx2EbQ1SZpsYh4dTOpxzd
         aqFQImSZqSqzg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E8E53C4166F;
        Wed, 31 Aug 2022 06:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx5e: Do not use err uninitialized in
 mlx5e_rep_add_meta_tunnel_rule()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166192741795.4297.2723160789044266807.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 06:30:17 +0000
References: <20220825180607.2707947-1-nathan@kernel.org>
In-Reply-To: <20220825180607.2707947-1-nathan@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ndesaulniers@google.com, trix@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 25 Aug 2022 11:06:07 -0700 you wrote:
> Clang warns:
> 
>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:481:6: error: variable 'err' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>           if (IS_ERR(flow_rule)) {
>               ^~~~~~~~~~~~~~~~~
>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:489:9: note: uninitialized use occurs here
>           return err;
>                 ^~~
>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:481:2: note: remove the 'if' if its condition is always true
>           if (IS_ERR(flow_rule)) {
>           ^~~~~~~~~~~~~~~~~~~~~~~
>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:474:9: note: initialize the variable 'err' to silence this warning
>           int err;
>                 ^
>                   = 0
>   1 error generated.
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx5e: Do not use err uninitialized in mlx5e_rep_add_meta_tunnel_rule()
    https://git.kernel.org/netdev/net-next/c/92f97c00f0ca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


