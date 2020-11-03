Return-Path: <SRS0=gcIT=EJ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92032C2D0A3
	for <linux-rdma@archiver.kernel.org>; Tue,  3 Nov 2020 22:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A9FD223C6
	for <linux-rdma@archiver.kernel.org>; Tue,  3 Nov 2020 22:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604441606;
	bh=eUvNsMeXHBvQ8YD5aWkOqSEQscgXOowINAXv8BxNRT0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:List-ID:From;
	b=hIb84ZV399A2hsG3toDkNA+9B3pqaRpHwtBIr34mhPLY9xWAhd5QfhlnBNTrsupzQ
	 h0xhG7hTA7mHo19mMeExOXLBEqlgSTQza5QZjN7GzR6W9GgtVGt443jmYOGEYzXbjY
	 S/k3vLp+9P07kyLKPbPCxHP/SS2T3DqgN/qLoPPI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgKCWNZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 3 Nov 2020 17:13:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729828AbgKCWNZ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 3 Nov 2020 17:13:25 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83A98223AC;
        Tue,  3 Nov 2020 22:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604441604;
        bh=eUvNsMeXHBvQ8YD5aWkOqSEQscgXOowINAXv8BxNRT0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uTOCGg3BYhaxTOoMt96rV74ccoltnQMsRTiy3tDjSFIInwBzZPkhOPkUDAVcR93Yu
         fsNX+slT9cXGOfTezY7HZ3+O4cBy0hc3acCXJewaOEycZvTqwdDoAQe5oryuTFRQOV
         k4Y/89a/BLDs5Vr9owyQMWdg3LYxZbYuC/Uc68Jo=
Message-ID: <85854460cc713a1e521eec4a461ac2d2c0194c37.camel@kernel.org>
Subject: Re: [PATCH net-next] net/mlx5e: Remove duplicated include
From:   Saeed Mahameed <saeed@kernel.org>
To:     YueHaibing <yuehaibing@huawei.com>, leon@kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 03 Nov 2020 14:13:23 -0800
In-Reply-To: <20201031025019.21628-1-yuehaibing@huawei.com>
References: <20201031025019.21628-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sat, 2020-10-31 at 10:50 +0800, YueHaibing wrote:
> Remove duplicated include.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index 599f5b5ebc97..58c177756dc4 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -52,7 +52,6 @@
>  #include "en/xsk/rx.h"
>  #include "en/health.h"
>  #include "en/params.h"
> -#include "en/txrx.h"

Applied to net-next-mlx5, 
Thanks !

