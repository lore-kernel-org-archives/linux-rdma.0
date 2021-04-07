Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 625D8C433ED
	for <linux-rdma@archiver.kernel.org>; Wed,  7 Apr 2021 21:10:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D0D361245
	for <linux-rdma@archiver.kernel.org>; Wed,  7 Apr 2021 21:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbhDGVKU (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 7 Apr 2021 17:10:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhDGVKT (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 7 Apr 2021 17:10:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 55A456121E;
        Wed,  7 Apr 2021 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617829809;
        bh=qUpWG+JR+Dljb5RXh4lK++1952pR3aASzw7TtTfx5tA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cgVIjMS0VeEPsAfBEfAK726EDod2XbEwcChYvB4AhUIDjq00kQoF4c6fTBwDvKbfi
         LOTVpPLXB6JNaDP7QxNgHTyMH/Kz/0wU5H1v08hvox8Jh00gZ0CtJc4RCyalVLgHDf
         hQfHagO6L4Ns0v1MHBbXIZUfjazejI53jX0Q/Epw8lv88mTiEOM7ASBYMh2J/nKgUO
         DnEd+vqTVov0jUV0RyiZEgkn1nodLAwBFvl9ucXB6ZgOe/ad3J9fq2kb2sMylJGP0K
         8NGPV91dFDUFqXXEGANIC9wSBZfycmkaQtfpCjyRd1hZhTk1kMDBC1AYDfISl6nlIB
         +4SXu9p6XM6Rg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/rds: Avoid potential use after free in
 rds_send_remove_from_sock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161782980927.12624.5215933274720336913.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 21:10:09 +0000
References: <20210407000913.2207831-1-pakki001@umn.edu>
In-Reply-To: <20210407000913.2207831-1-pakki001@umn.edu>
To:     Aditya Pakki <pakki001@umn.edu>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  6 Apr 2021 19:09:12 -0500 you wrote:
> In case of rs failure in rds_send_remove_from_sock(), the 'rm' resource
> is freed and later under spinlock, causing potential use-after-free.
> Set the free pointer to NULL to avoid undefined behavior.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>  net/rds/message.c | 1 +
>  net/rds/send.c    | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - net/rds: Avoid potential use after free in rds_send_remove_from_sock
    https://git.kernel.org/netdev/net/c/0c85a7e87465

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


