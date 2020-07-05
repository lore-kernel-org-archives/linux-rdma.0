Return-Path: <SRS0=uC3E=AQ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C49F7C433E0
	for <linux-rdma@archiver.kernel.org>; Sun,  5 Jul 2020 13:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E87220747
	for <linux-rdma@archiver.kernel.org>; Sun,  5 Jul 2020 13:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593955261;
	bh=R369+IbP2EcSJwja/iH4mcO9RtEgiYgjihSL2z0DhDc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=OxOupywjgMfNipMCcvJJ9Foke0kA/NfjT0E6EoC1x+0tKO8IP5/LrWkNHrwhG8pXj
	 5dW49fOxuNy2sWD7RD6jD7rZx/kKwYszr7UNf+Ko2q37WLZ6Qh+498i1a9EtHbhPJ4
	 6MOVejo2GKH7MzMQFXjnvJrXvlEulaccp2eWZFjg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgGENVB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 5 Jul 2020 09:21:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbgGENVA (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 5 Jul 2020 09:21:00 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E23892073E;
        Sun,  5 Jul 2020 13:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593955260;
        bh=R369+IbP2EcSJwja/iH4mcO9RtEgiYgjihSL2z0DhDc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hL+ufsFv1yAKlXOSwmm4aYwUXwL4+KVL47fwgsRGag9TOnLo8P2nsq9mKWVIJSc53
         534diDuPUhmGElVO+BV8AmBJGF1yoWdgRg3Lv50A8NiQvvBTo5aOBpD7+wojktVCqE
         qGifW8g+qX1xXMezkVK21UjKWuqwsRY2HNkp4MYQ=
Date:   Sun, 5 Jul 2020 16:20:57 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Kamal Heib <kamalheib1@gmail.com>
Cc:     linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Zhu Yanjun <yanjunz@mellanox.com>
Subject: Re: [PATCH for-next v1 3/4] RDMA/rxe: Return void from
 rxe_mem_init_dma()
Message-ID: <20200705132057.GF5149@unreal>
References: <20200705104313.283034-1-kamalheib1@gmail.com>
 <20200705104313.283034-4-kamalheib1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200705104313.283034-4-kamalheib1@gmail.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sun, Jul 05, 2020 at 01:43:12PM +0300, Kamal Heib wrote:
> The return value from rxe_mem_init_dma() is always 0 - change it to be
> void and fix the callers accordingly.
>
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
> ---
>  drivers/infiniband/sw/rxe/rxe_loc.h   |  4 ++--
>  drivers/infiniband/sw/rxe/rxe_mr.c    |  6 ++----
>  drivers/infiniband/sw/rxe/rxe_verbs.c | 20 +++-----------------
>  3 files changed, 7 insertions(+), 23 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
