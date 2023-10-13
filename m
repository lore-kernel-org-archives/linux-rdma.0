Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27369CDB482
	for <linux-rdma@archiver.kernel.org>; Fri, 13 Oct 2023 17:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjJMRA2 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 13 Oct 2023 13:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjJMRA1 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 13 Oct 2023 13:00:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2CC95
        for <linux-rdma@vger.kernel.org>; Fri, 13 Oct 2023 10:00:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0049C433C7;
        Fri, 13 Oct 2023 17:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697216426;
        bh=MhQUbmFGLyrxkPtNnh2un2Ap2mrS/cTylgkjo4PwDIs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JRNbU3TiG4Tnj1A6djRdIf8BZT9fCzqs9Y/Q0c3fMgbCPceGLOa+xKkW1Lr65DnzG
         bqlbHlxHr5j2qpp4XnoAV4e+lnPY/vsQ5Ee2ugQAn+xUlcvUfSeWhpOXpFGEig/q1B
         I90XzrBsoubiwfBfErtFwe6UbnoqBijjZ6RKXgK+W+eb4gbpttp562RLwtav3UlcWw
         eLHc5T6NRglW9ECiblhS6ocLMqcK5HvMIewKmp9aYLB6Y1rHwVascoG3NlmIf6m/Dj
         C1IT9aVSG0lJpAVFqFIlmePltMivUUr9gMY0A8kAxK4REigsCyFR0SCvGOU1svU7H8
         DQ+wy8bv84fYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C39F4E1F669;
        Fri, 13 Oct 2023 17:00:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Please pull IPsec packet offload support in multiport RoCE
 devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <169721642579.16770.13380913448246325654.git-patchwork-notify@kernel.org>
Date:   Fri, 13 Oct 2023 17:00:25 +0000
References: <20231002083832.19746-1-leon@kernel.org>
In-Reply-To: <20231002083832.19746-1-leon@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     jgg@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, linux-rdma@vger.kernel.org,
        mbloch@nvidia.com, netdev@vger.kernel.org, phaddad@nvidia.com,
        saeedm@nvidia.com, steffen.klassert@secunet.com, horms@kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  2 Oct 2023 11:38:31 +0300 you wrote:
> Hi,
> 
> This PR is collected from https://lore.kernel.org/all/cover.1695296682.git.leon@kernel.org
> 
> This series from Patrisious extends mlx5 to support IPsec packet offload
> in multiport devices (MPV, see [1] for more details).
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Please pull IPsec packet offload support in multiport RoCE devices
    https://git.kernel.org/netdev/net-next/c/1bc60524ca1a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


