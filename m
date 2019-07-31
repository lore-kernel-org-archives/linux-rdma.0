Return-Path: <SRS0=HDkz=V4=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD6FC32751
	for <linux-rdma@archiver.kernel.org>; Wed, 31 Jul 2019 08:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F908206A3
	for <linux-rdma@archiver.kernel.org>; Wed, 31 Jul 2019 08:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564561722;
	bh=P+FqLRFuaydDbA/lMA+q0xLsglsV3oQXIymgusgk0eQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=09DmXOp3gM5cNmmMUQhiDys0VPOjSgPcRUp/J03/FViRV8VFVRNEHAmJzrMdzcRBf
	 bnG8efuYziCz8CQrS/Mzfx8wABYh1yU/8vIJ3I3aUSwNuruWifaNsAcORdsJMlcDa4
	 XPlz0TJGqFxm8tdCw3ENfkAfaNp76sWKwFUJA1Eg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfGaI2l (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 31 Jul 2019 04:28:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbfGaI2l (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 31 Jul 2019 04:28:41 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8E3D2067D;
        Wed, 31 Jul 2019 08:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564561720;
        bh=P+FqLRFuaydDbA/lMA+q0xLsglsV3oQXIymgusgk0eQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OWKQkXgpOG9l/pE6t1oQ/yQIAI2prg0ghRLlT/4zFLq3/I9JLFbgfNMsPdkCKSCjb
         bYIHmnw9FqhfN2Bi3sJEITbIxm+O14LBpuJ0ZlHQI1nucJZAYRd5Veeu23oqkpGRVB
         L6a4blegPJt0kIBlOcGn1cDfS5EdZ8yROyV4aCjs=
Date:   Wed, 31 Jul 2019 11:28:37 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] RDMA/core: fix spelling mistake "Nelink" ->
 "Netlink"
Message-ID: <20190731082837.GO4878@mtr-leonro.mtl.com>
References: <20190731080144.18327-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731080144.18327-1-colin.king@canonical.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Jul 31, 2019 at 09:01:44AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> There is a spelling mistake in a warning message, fix it.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/infiniband/core/netlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
