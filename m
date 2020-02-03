Return-Path: <SRS0=727Q=3X=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD907C35247
	for <linux-rdma@archiver.kernel.org>; Mon,  3 Feb 2020 19:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A8122087E
	for <linux-rdma@archiver.kernel.org>; Mon,  3 Feb 2020 19:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580759180;
	bh=mibpseNa9k1WLE1Rmo2MklCwdk8oR3dthatLFIUNSEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Nj4WT5ZaTdY9OQm2bBY5GRsWUU7XSn1XHbA+jQGr2gg+nM+R6PVZPNusIgaykuE42
	 Da9o32/k2WuyZNWGZUX7gxTtPAZpns6JjTE41sBZZna7CefQhqMuG9puKU8/RmFtfc
	 A3xXniywsaIF4ITyr2ly38TZufLF6yVu67UelpMY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgBCTqU (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 3 Feb 2020 14:46:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgBCTqT (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 3 Feb 2020 14:46:19 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F4BF2051A;
        Mon,  3 Feb 2020 19:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580759179;
        bh=mibpseNa9k1WLE1Rmo2MklCwdk8oR3dthatLFIUNSEU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ff5Y66UcMVdYgs0qocegG8zfAjyZYBqrlUV4XBzAuGjb5eyLGmpl2S4T+YkE0MMQz
         yjCEDZzFvtIzjPIRpmr280gzm5jCQFxGelmq1in6UOg8ap8X6zf74e9vjkF4QiYT2x
         oRq1KhU90T1IKjHamhSoxlSemZQuvjtvsUP/MPho=
Date:   Mon, 3 Feb 2020 21:46:14 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Devesh Sharma <devesh.sharma@broadcom.com>
Cc:     linux-rdma@vger.kernel.org, jgg@mellanox.com
Subject: Re: [PATCH v5] libibverbs: display gid type in ibv_devinfo
Message-ID: <20200203194614.GT414821@unreal>
References: <1580752324-24742-1-git-send-email-devesh.sharma@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580752324-24742-1-git-send-email-devesh.sharma@broadcom.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Feb 03, 2020 at 12:52:04PM -0500, Devesh Sharma wrote:
> It becomes difficult to make out from the output of ibv_devinfo
> if a particular gid index is RoCE v2 or not.
>
> Adding a string to the output of ibv_devinfo -v to display the
> gid type at the end of gid.
>
> The output would look something like below:
> $ ibv_devinfo -v -d bnxt_re2
> hca_id: bnxt_re2
>  transport:             InfiniBand (0)
>  fw_ver:                216.0.220.0
>  node_guid:             b226:28ff:fed3:b0f0
>  sys_image_guid:        b226:28ff:fed3:b0f0
>   .
>   .
>   .
>   .
>        phys_state:      LINK_UP (5)
>        GID[  0]:               fe80::b226:28ff:fed3:b0f0, IB/RoCE v1
>        GID[  1]:               fe80::b226:28ff:fed3:b0f0, RoCE v2
>        GID[  2]:               ::ffff:192.170.1.101, IB/RoCE v1
>        GID[  3]:               ::ffff:192.170.1.101, RoCE v2
> $
> $
>
> Reviewed-by: Jason Gunthrope <jgg@ziepe.ca>
> Reviewed-by: Leon Romanovsky <leon@kernel.org>
> Reviewed-by: Gal Pressman <galpress@amazon.com>
> Reviewed-by: Parav Pandit <parav@mellanox.com>
> Signed-off-by: Devesh Sharma <devesh.sharma@broadcom.com>
> ---
>  libibverbs/driver.h           |  1 +
>  libibverbs/examples/devinfo.c | 35 ++++++++++++++++++++++++-----------
>  2 files changed, 25 insertions(+), 11 deletions(-)
>
> diff --git a/libibverbs/driver.h b/libibverbs/driver.h
> index a0e6f89..fc0699d 100644
> --- a/libibverbs/driver.h
> +++ b/libibverbs/driver.h
> @@ -84,6 +84,7 @@ enum verbs_qp_mask {
>  enum ibv_gid_type {
>  	IBV_GID_TYPE_IB_ROCE_V1,
>  	IBV_GID_TYPE_ROCE_V2,
> +	IBV_GID_TYPE_INVALID
>  };
>

Agree with Gal, this hunk shouldn't be in the patch at all.

Thanks
