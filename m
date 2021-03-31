Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C1BC43600
	for <linux-rdma@archiver.kernel.org>; Wed, 31 Mar 2021 21:30:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3478061073
	for <linux-rdma@archiver.kernel.org>; Wed, 31 Mar 2021 21:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbhCaVaW (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 31 Mar 2021 17:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233302AbhCaVaI (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 31 Mar 2021 17:30:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D4A4B61073;
        Wed, 31 Mar 2021 21:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617226207;
        bh=ja6wIkS8ptibhefhaLH9EIBKhl2lvpF1GyxSpsDEwlA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=faNf2vloN1VMK+CsD0Cl66dmOz4f0GN9p7ZjfxqrPjbaaZXGmycPQy9w15D80MqTr
         XiWFUrxSKUerWIv6HJMBt6T5UA3ph+exBDvxdHiUoJYjjQizLTHsJh1Mln75raFIvp
         0BhTx6WGq7Oh8HEC30EYdBxrIbFenVhFigpS8CMBRh6Ug6FZxzA1NtQMf6oClkKrZu
         f4AwJRHvSERlHL8zben9MbH269+spZULnTiocyKHsT277QiDjPpZFH2WRhXBzWwa5K
         blxzl3oCwo1i0TgXfPGGFQk+NHCdupwM19So7dMa1uSRjdqLsD0Jtay0wko6JPCP9J
         verhdB23kjiog==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net/rds: Fix a use after free in rds_message_map_pages
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161722620780.13975.16375102859564408293.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 21:30:07 +0000
References: <20210331015959.4404-1-lyl2019@mail.ustc.edu.cn>
In-Reply-To: <20210331015959.4404-1-lyl2019@mail.ustc.edu.cn>
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 30 Mar 2021 18:59:59 -0700 you wrote:
> In rds_message_map_pages, the rm is freed by rds_message_put(rm).
> But rm is still used by rm->data.op_sg in return value.
> 
> My patch assigns ERR_CAST(rm->data.op_sg) to err before the rm is
> freed to avoid the uaf.
> 
> Fixes: 7dba92037baf3 ("net/rds: Use ERR_PTR for rds_message_alloc_sgs()")
> Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
> 
> [...]

Here is the summary with links:
  - [v2] net/rds: Fix a use after free in rds_message_map_pages
    https://git.kernel.org/netdev/net/c/bdc2ab5c61a5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


