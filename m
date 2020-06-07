Return-Path: <SRS0=HwpK=7U=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF7EFC433DF
	for <linux-rdma@archiver.kernel.org>; Sun,  7 Jun 2020 06:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8B89206F6
	for <linux-rdma@archiver.kernel.org>; Sun,  7 Jun 2020 06:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591511896;
	bh=hjgqBKs8I5xfqLOw2CAF9mq9SLkbP+7OE/QANem/4Mk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=mIlqOKHMyhIDaNCH7ofnPFojOL3ymEaf5UYBgencqC5o4Qz2kxL0KtNGoWU3p4AAg
	 ibawyytKGkLB9kefvf3c4yMOVWLmQ7wO94Xcq/amlt51hEjk2Jqg5sQsTib6GowKLL
	 M9BNsmwy6RkGivLNBLZvxT0wrid9Hf8mdI5IiAyg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgFGGiQ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 7 Jun 2020 02:38:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbgFGGiQ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 7 Jun 2020 02:38:16 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9A31206D5;
        Sun,  7 Jun 2020 06:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591511895;
        bh=hjgqBKs8I5xfqLOw2CAF9mq9SLkbP+7OE/QANem/4Mk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YUfdYQYmo5DWw5bY7vgI8wtaqcAWPNx1QvkWUgyJyY8+IYho1V61yrrRNJdF/CTUu
         Ln8GeYRktxvLTQByNjwHQGH9jNMJf5OAm9Aqga7fXjyERmjVlltVOi5T52uF6ZY4GB
         gDz6TPHG+n9N5TMoL6gT7+TP4D33EkUcn+pvzF3E=
Date:   Sun, 7 Jun 2020 09:38:12 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Tom Seewald <tseewald@gmail.com>
Cc:     linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] [next] RDMA/mlx5: Fix -Wformat warning in
 check_ucmd_data()
Message-ID: <20200607063812.GE164174@unreal>
References: <20200605023012.9527-1-tseewald@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605023012.9527-1-tseewald@gmail.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Jun 04, 2020 at 09:30:12PM -0500, Tom Seewald wrote:
> Variables of type size_t should use %zu rather than %lu [1]. The variables
> "inlen", "ucmd", "last", and "size" are all size_t, so use the correct
> format specifiers.
>
> [1] https://www.kernel.org/doc/html/latest/core-api/printk-formats.html
>
> Signed-off-by: Tom Seewald <tseewald@gmail.com>
> ---
>  drivers/infiniband/hw/mlx5/qp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>
