Return-Path: <SRS0=HwpK=7U=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23AB3C433E0
	for <linux-rdma@archiver.kernel.org>; Sun,  7 Jun 2020 06:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E99E6206D5
	for <linux-rdma@archiver.kernel.org>; Sun,  7 Jun 2020 06:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591512021;
	bh=RRwJimd7kmJm6Hg1bzv9pEXiMtElkAwFIGNRS+ev+FI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=NnPU791O6QGIKrrUGbrFsh7Rb9eM4BvJsFHe9ujDGmvX012V4IxUMsS6S1EfTxNmG
	 /0/mDXhscUpBcCNtQpPmaz/NLCZ32TYvYvaxSndsE7CGqUbZbEb6EOVu0mhO9QgX41
	 33Vmw2A50bh0TsJzj5Ks/cpmF3jXktMUBkBZ+0tU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgFGGkU (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 7 Jun 2020 02:40:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbgFGGkU (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 7 Jun 2020 02:40:20 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FF772064C;
        Sun,  7 Jun 2020 06:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591512019;
        bh=RRwJimd7kmJm6Hg1bzv9pEXiMtElkAwFIGNRS+ev+FI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aIwZ768V6HAzoTG12w+rJeiKZBhKuN9t3aMLh3u76ySBgE9VE8BvzPoKaC/0voJzN
         hamT6R1h4P6Zmu39PiJgoqWgB3Qy12z8uRM/vcDPy9VzJVuvOoLDCV8hHmOhB2ZRXy
         +CbhJ5B4CE9BXqnshMxESn6iNQBE70Lk8v6+IVuo=
Date:   Sun, 7 Jun 2020 09:40:16 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] RDMA/mlx5: remove duplicated assignment to
 resp.response_length
Message-ID: <20200607064016.GF164174@unreal>
References: <20200604143902.56021-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604143902.56021-1-colin.king@canonical.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Jun 04, 2020 at 03:39:02PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> The assignment to resp.response_length is never read since it is being
> updated again on the next statement. The assignment is redundant so
> removed it.
>
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/infiniband/hw/mlx5/qp.c | 2 --
>  1 file changed, 2 deletions(-)
>

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>
