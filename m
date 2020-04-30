Return-Path: <SRS0=pJc0=6O=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C60C83001
	for <linux-rdma@archiver.kernel.org>; Thu, 30 Apr 2020 05:22:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00E192083B
	for <linux-rdma@archiver.kernel.org>; Thu, 30 Apr 2020 05:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588224124;
	bh=1p0oH7YrVSof02HvpE/Mwk52Jg02jQcL9hzueBwTQjs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=GKVLclt/h379DG6eQWUk4/TL8SXihcRsLm44joQ3QxCVyo9OYWQTQtpIfWZvFJUAp
	 suhpR+YIqvojwP2h4N3wSqFfAAuHE3W95OQFFmsd4Dw4uHEm1nftTHkrhnCEGprX6D
	 tWZjLxGzMvH5zeLZNfB2FqXX/Sx6uki9DoDtbD94=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgD3FWD (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 30 Apr 2020 01:22:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgD3FWD (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 30 Apr 2020 01:22:03 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 095692082E;
        Thu, 30 Apr 2020 05:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588224122;
        bh=1p0oH7YrVSof02HvpE/Mwk52Jg02jQcL9hzueBwTQjs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wFETOcuSpA6cWjmhNxTlbehrldwW6BolQSq4gendapIEf47FUUT3raBVV6Ztkz1TJ
         O3kFOAy5ZNvY6418jydrSdcFWq4Ocw7OudLM5xkyhq/ePOwuRAVcPNHztPGE/U4gaz
         rqBPiRV+POM6K4DJSVmdZ0JKTpFJJBpxLodwckh4=
Date:   Thu, 30 Apr 2020 08:21:57 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Moshe Shemesh <moshe@mellanox.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: reduce stack usage in qp_read_field
Message-ID: <20200430052157.GD432386@unreal>
References: <20200428212357.2708786-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428212357.2708786-1-arnd@arndb.de>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Apr 28, 2020 at 11:23:47PM +0200, Arnd Bergmann wrote:
> Moving the mlx5_ifc_query_qp_out_bits structure on the stack was a bit
> excessive and now causes the compiler to complain on 32-bit architectures:
>
> drivers/net/ethernet/mellanox/mlx5/core/debugfs.c: In function 'qp_read_field':
> drivers/net/ethernet/mellanox/mlx5/core/debugfs.c:274:1: error: the frame size of 1104 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
>
> Revert the previous patch partially to use dynamically allocation as
> the code did before. Unfortunately there is no good error handling
> in case the allocation fails.
>
> Fixes: 57a6c5e992f5 ("net/mlx5: Replace hand written QP context struct with automatic getters")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/debugfs.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)

Thanks Arnd, I'll pick it to mlx5-next.

I was under impression that the frame size was increased a long
time ago. Is this 1K limit still effective for all archs?
Or is it is 32-bit leftover?

Thanks
