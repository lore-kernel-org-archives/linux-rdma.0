Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07073C432BE
	for <linux-rdma@archiver.kernel.org>; Mon, 23 Aug 2021 11:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB7436136F
	for <linux-rdma@archiver.kernel.org>; Mon, 23 Aug 2021 11:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbhHWLK6 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 23 Aug 2021 07:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234865AbhHWLK5 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 23 Aug 2021 07:10:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4BB2F6136F;
        Mon, 23 Aug 2021 11:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629717015;
        bh=diVsrQ7QHH8aTtcONyWLa4u5SXaOaypgsSkK0i8mBP8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mPdw/Fy+SrzjzKgxzy57hnxrtxEgUht/yoTFYPxjLNBAZizQ/vqmesNdBYYmYvWwB
         eJdu2nkbTtovCI/NHai0hETrHut009JhR0hpcWBzlByyg+LhkaCnovL3b5N1K/eZhm
         V7T/0nkLLhYGOM+e2WoSdJtq1LlNDiCirfO4kcFIaLE6ZdwCBJutm5lK1wTqHNOJBI
         vWnFDhJ3LJ12j7ipTFD0Jo5LG7tp/MBKK+PEfWDUXh+b+VzV9+1aZHn7CpVA6ZaxTv
         dRCumE+9kpIrv8IscGUhhc6spf/aeZ3ZVZehSXy38/JSlWQr41EwkUIYKrcQPeviFo
         zIWoR31dW5SMA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/mellanox: switch from 'pci_' to 'dma_' API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162971701525.8269.6988684791167013796.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Aug 2021 11:10:15 +0000
References: <33167c57d1aaec10f130fe7604d6db3a43cfa381.1629659490.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <33167c57d1aaec10f130fe7604d6db3a43cfa381.1629659490.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     tariqt@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        saeedm@nvidia.com, leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 22 Aug 2021 21:12:41 +0200 you wrote:
> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below.
> 
> It has been hand modified to use 'dma_set_mask_and_coherent()' instead of
> 'pci_set_dma_mask()/pci_set_consistent_dma_mask()' when applicable.
> This is less verbose.
> 
> [...]

Here is the summary with links:
  - net/mellanox: switch from 'pci_' to 'dma_' API
    https://git.kernel.org/netdev/net-next/c/eb9c5c0d3a73

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


