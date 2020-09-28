Return-Path: <SRS0=A3Y9=DF=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E4D7C4727F
	for <linux-rdma@archiver.kernel.org>; Mon, 28 Sep 2020 11:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B2262074A
	for <linux-rdma@archiver.kernel.org>; Mon, 28 Sep 2020 11:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601294151;
	bh=QcP0SylU3PMDPmJo4BmXYtealXvTH8RsitnO6xIMnkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=cJx+zu4bUK5ctz2XCVwNQrgb15Ggv1LLhkGTQi2EYPw7u1iD48hKm/kEMhqJzWiws
	 6XTNa6yOUMSaKnYNCpjLSokjfRNl5DX0eUsnzlx09b3HrZFh+oKInpTL+dQrjd6v8q
	 anC0D8M0cUjImwVV26utDH1HhnRgfb+s1cMihXLg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgI1Lzs (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 28 Sep 2020 07:55:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbgI1Lzs (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 28 Sep 2020 07:55:48 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DAC42073A;
        Mon, 28 Sep 2020 11:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601294147;
        bh=QcP0SylU3PMDPmJo4BmXYtealXvTH8RsitnO6xIMnkY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HUPaf0LGx9oz2mBF60I+I7q/vy+iVXE3DTT4JiH0E09wyQSBaLDUjfDQQpUwNfAAK
         qDekmOi3LA8LiU6jfcuLCXTYvaRSSWi3lHFqMpa3Iw64cEpNxbcCNByGnVvy2aK2Ts
         lOUzTnqwovCu5rT5a1KbMlMhFkdXpWxFTzt1l8q4=
Date:   Mon, 28 Sep 2020 14:55:43 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Roi Dayan <roid@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Ariel Levkovich <lariel@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5e: Fix a use after free on error in
 mlx5_tc_ct_shared_counter_get()
Message-ID: <20200928115543.GD3094@unreal>
References: <20200928090556.GA377727@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928090556.GA377727@mwanda>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Sep 28, 2020 at 12:05:56PM +0300, Dan Carpenter wrote:
> This code frees "shared_counter" and then dereferences on the next line
> to get the error code.
>
> Fixes: 1edae2335adf ("net/mlx5e: CT: Use the same counter for both directions")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
