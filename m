Return-Path: <SRS0=u+Z8=XX=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C08C4360C
	for <linux-rdma@archiver.kernel.org>; Sat, 28 Sep 2019 06:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19E712082F
	for <linux-rdma@archiver.kernel.org>; Sat, 28 Sep 2019 06:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569650869;
	bh=rQNZoB0gH0Aw4WPpOsR6mMz1gOurH2mz6RAHTxynZwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ENmU/IdKSkc1N1wyg1CxNlafYs/II70lT355gDgizA/mVKeNcCPtvJMN7c59QhO6k
	 wPHtZD6H4Gw3wUae8gy7tftvpAYlAu+TAKwRvO8j08dGdtI5yrTbOgXCS1VgXzyDTg
	 FlHgOcCLKQr+dwzZ59KSPWwWYVPTucp2naI4I2Do=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbfI1GHs (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 28 Sep 2019 02:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbfI1GHs (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 28 Sep 2019 02:07:48 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 042AD207E0;
        Sat, 28 Sep 2019 06:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569650867;
        bh=rQNZoB0gH0Aw4WPpOsR6mMz1gOurH2mz6RAHTxynZwc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jB2C4jOUEyYWGZ6i2GJkVSofV3TmAIBo87VqooWRrL+QjVz8YhN2cS8CsR5Hvzb4P
         0MxN2BeVe3ugXAyCJYRRRgu5yoBWhlfL2HTCRRosmRfhlHueoJJJGhNJCmwA42i5/e
         m2229E5DqFW2sN6FfywkXHE8n4Iiupq5mx2x46IU=
Date:   Sat, 28 Sep 2019 09:07:43 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: fix memory leak in mlx5_fw_fatal_reporter_dump
Message-ID: <20190928060743.GK14368@unreal>
References: <20190927223729.18043-1-navid.emamdoost@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927223729.18043-1-navid.emamdoost@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Sep 27, 2019 at 05:37:28PM -0500, Navid Emamdoost wrote:
> In mlx5_fw_fatal_reporter_dump if mlx5_crdump_collect fails the
> allocated memory for cr_data must be released otherwise there will be
> memory leak. To fix this, this commit changes the return instruction
> into goto error handling.
>
> Fixes: 9b1f29823605 ("net/mlx5: Add support for FW fatal reporter dump")
>
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/health.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

General note, if you don't write "To:" in your emails, most probably
your emails will be missed by relevant people.

I assume that Saeed will pick this patch and fix extra line between
Fixes and SOB.

Thanks, for fixing it.
