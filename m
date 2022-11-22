Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE09C4332F
	for <linux-rdma@archiver.kernel.org>; Tue, 22 Nov 2022 13:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbiKVNGn (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 22 Nov 2022 08:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKVNGm (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 22 Nov 2022 08:06:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35CF61B92;
        Tue, 22 Nov 2022 05:06:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9859AB81B08;
        Tue, 22 Nov 2022 13:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E62CC433C1;
        Tue, 22 Nov 2022 13:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669122399;
        bh=CPsxDryb/dMBKMbXBkNCah1lUZY88ir8mN35n2+eKtA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xqm3F9bfXxdpfJtGBHYcu+3vnTPvqd5lJ75NMMs72Wk5qUcb4tb5wMkYYMsJ4PqzD
         bbk6sMj6HgU7rLq6aNzKNM/fDchWIf2MP/8fEjpK5BrecY1Bbg8q/gAYQU0iXOuouC
         5GmStMjMBc8O0Dy66hAk9xb6USamRsPKXxB7coz9ktzwZbClCoEwijFk7No+RLsqjv
         f8wwyAaXLp9zvYRDsyrd5a6EWw+T3fNbFu6BVyA1nXiADX5afaHwE6du0gMU8Q59pY
         9mAhWgJaLse5DcGG/IA9j8dUuuXQ0qYkFwom5mYaK0QO94Zy3EzBiQWuYXeuVKHNO2
         pT7GXehZYnOhg==
Date:   Tue, 22 Nov 2022 15:06:35 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     saeedm@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, moshe@nvidia.com,
        ogerlitz@mellanox.com, eli@mellanox.com, jackm@dev.mellanox.co.il,
        roland@purestorage.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/mlx5: Fix uninitialized variable bug in
 outlen_write()
Message-ID: <Y3zJW+aFdlJDoRsw@unreal>
References: <20221121112204.24456-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121112204.24456-1-yuehaibing@huawei.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Nov 21, 2022 at 07:22:04PM +0800, YueHaibing wrote:
> If sscanf() return 0, outlen is uninitialized and used in kzalloc(),
> this is unexpected. We should return -EINVAL if the string is invalid.
> 
> Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
