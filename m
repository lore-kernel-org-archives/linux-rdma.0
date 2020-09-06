Return-Path: <SRS0=8BIe=CP=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D920C433E2
	for <linux-rdma@archiver.kernel.org>; Sun,  6 Sep 2020 07:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7D532080A
	for <linux-rdma@archiver.kernel.org>; Sun,  6 Sep 2020 07:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599377842;
	bh=NVKyACicb1f3yRGWk5C9iVCbe4uQLXaHNFMzXLD2+rY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=R2RSgs6B5P6K7AwDSwADp9DRbUBV6+A+gsuLlKyWcUeIYf8OUupLl0ZNYwv7HDiJY
	 uewZPZMS5WwIKn/wKlG0QRFHMdaGOKI4QgUg0TudtYy74YfUNCKJV8Y4XRoqVC9Ef8
	 fnfrZzu+nQKk1hw+jHO6b33G4Rcto5gM3dYaTTi8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgIFHhV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 6 Sep 2020 03:37:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgIFHhU (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 6 Sep 2020 03:37:20 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE27E20759;
        Sun,  6 Sep 2020 07:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599377840;
        bh=NVKyACicb1f3yRGWk5C9iVCbe4uQLXaHNFMzXLD2+rY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0AwLLrIbp7rdBnbUgRYoEpC40yxX5fworq72tVSFTTGPgP0zZi2VBihO43j0DvJ3c
         wfXZDEjojiWhp65EM1/3YS6QeQJY0v7JTDmNuySbvV7w+oUKk1VYAHKBltnooAGfws
         PD3NPn+EYZt2J/2/6YsBXWoBOrRfGhPp2jaokgJI=
Date:   Sun, 6 Sep 2020 10:37:16 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     selvin.xavier@broadcom.com, devesh.sharma@broadcom.com,
        somnath.kotur@broadcom.com, sriharsha.basavapatna@broadcom.com,
        nareshkumar.pbs@broadcom.com, dledford@redhat.com, jgg@ziepe.ca,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] RDMA/bnxt_re: Remove set but not used variable
 'qplib_ctx'
Message-ID: <20200906073716.GD55261@unreal>
References: <20200905121624.32776-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200905121624.32776-1-yuehaibing@huawei.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sat, Sep 05, 2020 at 08:16:24PM +0800, YueHaibing wrote:
> drivers/infiniband/hw/bnxt_re/main.c:1012:25:
>  warning: variable ‘qplib_ctx’ set but not used [-Wunused-but-set-variable]
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/infiniband/hw/bnxt_re/main.c | 2 --
>  1 file changed, 2 deletions(-)

The patch is for rdma-rc and not for rdma-next.
Fixes: f86b31c6a28f ("RDMA/bnxt_re: Static NQ depth allocation")

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
