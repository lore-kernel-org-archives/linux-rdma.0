Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE07C433DB
	for <linux-rdma@archiver.kernel.org>; Tue, 16 Feb 2021 23:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C37164DAF
	for <linux-rdma@archiver.kernel.org>; Tue, 16 Feb 2021 23:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhBPXAu (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 16 Feb 2021 18:00:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:58546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230074AbhBPXAu (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 16 Feb 2021 18:00:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8BA7864E08;
        Tue, 16 Feb 2021 23:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613516409;
        bh=gySbbHCxI3MoBjtyJj9WhEaEgCYpGk38kJXxowW2C14=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vOniwDsR63IYLcj98rPm9d9aqn/2mWQYxgyvenucuzvogKTbe/aiMa6/WEJdk15Jw
         Gr8USVM3HnYsYp726XoPuRVrmnSTrq2Hys1uLTKYpEQeYGD6fLC8YtkMJovJyeHS/b
         6g5wN15GxIr0jL0BYtA/EwpyOMv/NuGfJVd7kr5JAnv7pL9O92Cig8kr8wWOr7H0ZK
         lwpufP8uPdBXo/E7GketU+XtGySxFMhsh2766GeBrB/ouno3uTkpz846i1j8DR6LkC
         0YfmAvyD+0nzH0t4nKHa/Pu+2HZ6wOjqxcY7NTx63I10kjZDCyjchEf9POJhy0bnJJ
         VQtYN/W3ykAFA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mlx5-next 2021-02-16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161351640950.9841.1885063453117608318.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Feb 2021 23:00:09 +0000
References: <20210216222438.51678-1-saeed@kernel.org>
In-Reply-To: <20210216222438.51678-1-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, jgg@nvidia.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Feb 2021 14:24:38 -0800 you wrote:
> Hi Dave, Jakub, Jason
> 
> The patches in this pr are already submitted and reviewed through the
> netdev and rdma mailing lists.
> 
> The series includes mlx5 HW bits and definitions for mlx5 real time clock
> translation and handling in the mlx5 driver clock module to enable and
> support such mode [1]
> 
> [...]

Here is the summary with links:
  - pull-request: mlx5-next 2021-02-16
    https://git.kernel.org/netdev/net-next/c/44c32039751a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


