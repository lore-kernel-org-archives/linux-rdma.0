Return-Path: <SRS0=uC3E=AQ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82629C433E0
	for <linux-rdma@archiver.kernel.org>; Sun,  5 Jul 2020 14:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BC542073E
	for <linux-rdma@archiver.kernel.org>; Sun,  5 Jul 2020 14:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593961077;
	bh=eLqvufLkKAlGixHcIJ8e3MNRbmmkxXz7qUB8Zfl5Gg8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=tZVZEs/Nk0Zmab2tYtXTrnPbl5cmI75yvV/oHj171L9xlhzMOmPxHCGimuUaW2/MT
	 TSZI/wuLYkIZbpHMN56MVVZdDRojmOD6q8GaaN3hS0qoAlvQIY173Y7rtQKv93hwxl
	 U24+IwOnFYaj44lfmO7L7ymfwr5u5LlzaaOZwnlA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgGEO54 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 5 Jul 2020 10:57:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgGEO54 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 5 Jul 2020 10:57:56 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BD7C20702;
        Sun,  5 Jul 2020 14:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593961076;
        bh=eLqvufLkKAlGixHcIJ8e3MNRbmmkxXz7qUB8Zfl5Gg8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OjcpwUfuvHhHgfPFdfRlpRyD3YiAk0h0Pez82l/jEzBOYrN6agqzPUxcz5tYAHzdi
         T+ipgcXIRcwR0OJ9S1pE9xp7WOxvl/LU7Vc22acbEaXfMP4AO42KpyMmuvVodFZWGC
         t7slkd4HhSsz0kBIOViMvoduJnBG3NpuGkuZkxR8=
Date:   Sun, 5 Jul 2020 17:57:52 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH for-next] RDMA/mlx5: Remove unused to_mibmr function
Message-ID: <20200705145752.GA207186@unreal>
References: <20200705141143.47303-1-galpress@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200705141143.47303-1-galpress@amazon.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sun, Jul 05, 2020 at 05:11:43PM +0300, Gal Pressman wrote:
> The to_mibmr function is unused, remove it.
>
> Signed-off-by: Gal Pressman <galpress@amazon.com>
> ---
>  drivers/infiniband/hw/mlx5/mlx5_ib.h | 5 -----
>  1 file changed, 5 deletions(-)
>

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>
