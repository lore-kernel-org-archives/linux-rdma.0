Return-Path: <SRS0=2Aje=6V=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58875C38A2A
	for <linux-rdma@archiver.kernel.org>; Thu,  7 May 2020 13:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 380462075E
	for <linux-rdma@archiver.kernel.org>; Thu,  7 May 2020 13:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588858842;
	bh=UzgNBysLz9JDcczUZ51lWGSanKbRt1nx1DOdn7L8VLI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=aE11cZv2lemyHKKKG2EojAhexSXqzslXLdur/orMljMXL58k+l10/SlW1VOOab7iM
	 spuTkXxWKSkJ1u4SmxMbc8v/Vm/20Bl6UVTChVtvQhLmjkmgxlwzXD+gwhuDIckAdy
	 ZUC/6cyGgSTGrGmMGI7zrCLSOlSiCZFGPTv2dWv4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgEGNk1 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 7 May 2020 09:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726974AbgEGNk0 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 7 May 2020 09:40:26 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E62F20838;
        Thu,  7 May 2020 13:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588858826;
        bh=UzgNBysLz9JDcczUZ51lWGSanKbRt1nx1DOdn7L8VLI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B8+665/amOfqX+AZzAZpoNB1jVLERWcpZV1jfYbCdHkF+L2aGhzBxVvYSzuKHNeXq
         CCgYJlftZECYx90082DWfC/gKtdtQWHFOYdkuA45fOeWj8NMzpNpvQJnd9+BFI6ZpS
         Ty1hDWHYl/LnL7Px0At+ZxY5H/lmdRwonm7vzaeg=
Date:   Thu, 7 May 2020 16:40:21 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     davem@davemloft.net, saeedm@mellanox.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: Re: [PATCH] net/mlx5e: Use IS_ERR() to check and simplify code
Message-ID: <20200507134021.GC104730@unreal>
References: <20200507115010.10380-1-tangbin@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507115010.10380-1-tangbin@cmss.chinamobile.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, May 07, 2020 at 07:50:10PM +0800, Tang Bin wrote:
> Use IS_ERR() and PTR_ERR() instead of PTR_ZRR_OR_ZERO()
> to simplify code, avoid redundant judgements.
>
> Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
