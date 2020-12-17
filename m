Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9402C0018C
	for <linux-rdma@archiver.kernel.org>; Thu, 17 Dec 2020 00:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D3D12376F
	for <linux-rdma@archiver.kernel.org>; Thu, 17 Dec 2020 00:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgLQAwW (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 16 Dec 2020 19:52:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:47600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbgLQAwW (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 16 Dec 2020 19:52:22 -0500
Date:   Wed, 16 Dec 2020 16:51:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608166301;
        bh=uCTZv7DXr0LdTQFOKkxi/CJL6ZUHauiKogCjuGGFHpo=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=H1HN4UPsMFXuNW6YNAbm4H3FjXINRbhbsKZf95j96+Xv3nCpIS+0XYsT4ylhP3jHW
         3E7n8vovaB+U2vkAIcrq2MKPTO80OdIUPpZ3F2/HUtXq50fkx7De/Vwa5Z+0p7nN6f
         xOwkhL5dHqSVW6N2jhLIDBUY4LxMwQ75DM81cVQ/8JDErdTbaMq63/NOi8xHuHayNQ
         DuVOqbe8fIF6JcGYCOpQSMNtNm3+0SRBCFW9vcMrgPShSR2JRf37AUHTS0KLNHzPYS
         Rjc/djeYWi3LfXNPUt3+Mh27gj6FSQUcKcdsRpVJiq8aUnKFKNdfjRzoAjd3Zg+9Op
         5BGnWpk4QzLrg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: rds: Change PF_INET to AF_INET
Message-ID: <20201216165140.320c68f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201216070620.16063-1-zhengyongjun3@huawei.com>
References: <20201216070620.16063-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, 16 Dec 2020 15:06:20 +0800 Zheng Yongjun wrote:
> By bsd codestyle, change PF_INET to AF_INET.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

# Form letter - net-next is closed

We have already sent the networking pull request for 5.11 and therefore
net-next is closed for new drivers, features, code refactoring and
optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens after 5.11-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
