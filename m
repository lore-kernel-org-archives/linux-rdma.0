Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C976C433DB
	for <linux-rdma@archiver.kernel.org>; Sun, 27 Dec 2020 07:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A31A221FD
	for <linux-rdma@archiver.kernel.org>; Sun, 27 Dec 2020 07:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgL0HZR (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 27 Dec 2020 02:25:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:33524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbgL0HZQ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 27 Dec 2020 02:25:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D217207FF;
        Sun, 27 Dec 2020 07:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609053876;
        bh=BknoFF8QfpYVaK9Sv6S/OlSfiIbQ2n+LKBGIXhYqYsI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wd9JcyeuQ52X3VxgY0sKuRcaAVfco1f4/gVM+s3mRZ5972G0Itxm4Lgnx6Uek7/O9
         N39kj1HliapNt0ybE8YtPO3EjP4CPzzWpICfCBzWvUM0IDkHV4/MEsgzER9Yw67nz6
         uKwtUBDhgV7dB0BuRbWj7MUX5rASK5jCMpkxZLoVDu8Nb2GraSFMZnQGdrykzlAiCw
         DEKACKE9xTRv/PqC/wJmwS+p6NjTgkxlbrHPWp4V6+8orVL3qfImo7klKcLNnn5nce
         7g9nYORpzaXlfLVM1+ahc4+wQZO7wgOBFatBRYxk7JpboeksN0JM8XkqLFBcLDjioS
         rtaUGwO2UKUNA==
Date:   Sun, 27 Dec 2020 09:24:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/usnic: Fix memleak in find_free_vf_and_create_qp_grp
Message-ID: <20201227072432.GC4457@unreal>
References: <20201226074248.2893-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201226074248.2893-1-dinghao.liu@zju.edu.cn>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sat, Dec 26, 2020 at 03:42:48PM +0800, Dinghao Liu wrote:
> If usnic_ib_qp_grp_create() fails at the first call, dev_list
> will not be freed on error, which leads to memleak.
>
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> ---
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 3 +++
>  1 file changed, 3 insertions(+)
>

Fixes: e3cf00d0a87f ("IB/usnic: Add Cisco VIC low-level hardware driver")

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
