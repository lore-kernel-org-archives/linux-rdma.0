Return-Path: <SRS0=tA3/=WD=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59121C433FF
	for <linux-rdma@archiver.kernel.org>; Wed,  7 Aug 2019 13:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 261A621E6E
	for <linux-rdma@archiver.kernel.org>; Wed,  7 Aug 2019 13:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565183740;
	bh=aEjS/VHN8i62TUZAJGcza/68NxDbFLH01XgoBEeMQ6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=NPmgikQ0us/ipHHTiCSoJG0kNnZRJLX9gzemWCmJT4CMFqj1OFbSF5p5lWZzsg6Ju
	 mfYHQu1MNu0WgTpEs/BqEvRbAbkWzi3WdUwuIVADU6ilpF9z06+XEjFDsVoduwVhWy
	 RAETgVqQo7C3g3r4lGLClBiwlkAda0wS7DooYK9E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388017AbfHGNPj (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 7 Aug 2019 09:15:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387970AbfHGNPj (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 7 Aug 2019 09:15:39 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D945321E6B;
        Wed,  7 Aug 2019 13:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565183738;
        bh=aEjS/VHN8i62TUZAJGcza/68NxDbFLH01XgoBEeMQ6M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KEvMO6WG6KoWA3pSIHnfMVQhLejzbVv7GrZAV7N4u+JdhV4nOTJ95L9r62N+MOmhf
         HCa6OpXX49Tk+QMwbbtLnj5Pry3GD5caUHFZsqsSWFfWd5UO/2A0bQzEgTsZYPUZ0H
         b7xE81xDtEBP7VdkWeZYwG2+bAXdmQmFWjADXgII=
Date:   Wed, 7 Aug 2019 16:15:34 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Yishai Hadas <yishaih@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] IB/mlx5: Check the correct variable in error handling
 code
Message-ID: <20190807131534.GG32366@mtr-leonro.mtl.com>
References: <20190807123236.GA11452@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807123236.GA11452@mwanda>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Aug 07, 2019 at 03:32:36PM +0300, Dan Carpenter wrote:
> The code accidentally checks "event_sub" instead of "event_sub->eventfd".
>
> Fixes: 759738537142 ("IB/mlx5: Enable subscription for device events over DEVX")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/infiniband/hw/mlx5/devx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>
