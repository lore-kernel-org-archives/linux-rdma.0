Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA00C4338F
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Jul 2021 13:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3455660F02
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Jul 2021 13:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbhGZMuO (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 26 Jul 2021 08:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233194AbhGZMuN (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 26 Jul 2021 08:50:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A02376008E;
        Mon, 26 Jul 2021 13:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627306242;
        bh=FaL9vbBdE3V+biHAq9tmrKS0iFa4UFCe6BoDl6uMk60=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J7qaBEvXhTSI7/DwGfZoarXHYcnw9BzFRju1/kEXS5csUhp01ARF7qCl2r4uY8v4c
         tl4pMfDX1kNSz60NhC91N3kHPBSwytSOQl8Yj8WjiPKd8UyGoF8jsm6sGguXeNsVKe
         bywPeQ7mHjtNj6yFLOf33yHo1oKuBzCP8qx+y+/PMna6MlmfKDDpH2m67yIpZLhqwc
         rzjgmjfBEDPK0nMpK0TsouL/HwhCGix2LnvdqUq8tUeMRr2X1e66B7E1knXN+d9KWA
         wzqiqlYcb6l3hssKKFnWCCqv/2IaVlCuAkgeRa/Azdf9iw8Ti+1+xMJOsYcI014UFE
         tWPXmF8W/bS5w==
Date:   Mon, 26 Jul 2021 16:30:39 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc:     Majd Dibbiny <majd@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: BUG: double free of mlx5_cmd_work_ent during shutdown
Message-ID: <YP64/2PATVW4p0vP@unreal>
References: <YPkU4HZwKMf9kuBH@syu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPkU4HZwKMf9kuBH@syu-laptop>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Jul 22, 2021 at 02:49:04PM +0800, Shung-Hsi Yu wrote:
> Hi,

Thanks a lot for your extensive analysis and report. We will continue
to work internally in order to find a proper solution to this problematic
flow.

Thanks
