Return-Path: <SRS0=cNdp=C2=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E8EC43461
	for <linux-rdma@archiver.kernel.org>; Thu, 17 Sep 2020 10:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C1FA2087D
	for <linux-rdma@archiver.kernel.org>; Thu, 17 Sep 2020 10:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600337428;
	bh=Djf4429iuD41ZbvFSGFovA/lYmcemMUq52Tol+o8Bds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=irF5Px8c8S8wlXi4Lbe4hcmI0KVWlUsHX9BApbIhmDZv+nZHz3mAwq3QVzo0w0f3K
	 8WIM5zrF7JkHIJjQR6YLWi/d/x8VZvsxH6nY08sUmTEF5cnoOfQU6K4oAFNybdpxff
	 hRqvo5rfa4R0LaukKs8TtuHdJ5E85d2T9liFA6qU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgIQKKY (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 17 Sep 2020 06:10:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbgIQKJ7 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 17 Sep 2020 06:09:59 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0226A2083B;
        Thu, 17 Sep 2020 10:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600337398;
        bh=Djf4429iuD41ZbvFSGFovA/lYmcemMUq52Tol+o8Bds=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A3c2YPQf/B+rkP04c+zEZaSm0RGUWxdNkNi2MR6pD0T6scsEwmUXyLmmY0WWhRaof
         p0CXNZTZDeZtlUxRzFoD5kDFOyOJAbjNc7gm6GcrSQkS5jyfeKpH47XXrRl+XxhmF+
         F4D74+QqWjD9j/G9xIPZprmrBN8kB/Xt1CSYgz9o=
Date:   Thu, 17 Sep 2020 13:09:54 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Liu Shixin <liushixin2@huawei.com>
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next v2] RDMA/mlx5: fix type warning of sizeof in
 __mlx5_ib_alloc_counters()
Message-ID: <20200917100954.GD869610@unreal>
References: <20200917090810.GB869610@unreal>
 <20200917095216.2381855-1-liushixin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917095216.2381855-1-liushixin2@huawei.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Sep 17, 2020 at 05:52:16PM +0800, Liu Shixin wrote:
> sizeof() when applied to a pointer typed expression should give the
> size of the pointed data, even if the data is a pointer.
>
> Signed-off-by: Liu Shixin <liushixin2@huawei.com>
> ---
>  drivers/infiniband/hw/mlx5/counters.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Acked-by: Leon Romanovsky <leonro@nvidia.com>
