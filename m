Return-Path: <SRS0=/7et=EE=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 653CBC2D0A3
	for <linux-rdma@archiver.kernel.org>; Thu, 29 Oct 2020 09:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02A6420790
	for <linux-rdma@archiver.kernel.org>; Thu, 29 Oct 2020 09:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603963680;
	bh=9suJHLVl9NEF5Ek1Egq4j7LDtbxbvKc91jIzl6SSqf0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=sf1IWRVYEfQBLWTOCf2ShAOUFFo5a/WMKg57FRRAhcs3eJRtTM7khWBcwimQul1MT
	 nCccfBG3CVJ4aigt5pSPKkI9eS3SrouUw41pFbiINcNHr5utYQl6c+2YWPRHwm9MJW
	 rIo6TDMJD0P9jxfZZjXXB+a372aU+hsF0ltkfOc4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725372AbgJ2J17 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 29 Oct 2020 05:27:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726212AbgJ2J16 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 29 Oct 2020 05:27:58 -0400
Received: from localhost (host-213-179-129-39.customer.m-online.net [213.179.129.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4636D2076B;
        Thu, 29 Oct 2020 09:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603963678;
        bh=9suJHLVl9NEF5Ek1Egq4j7LDtbxbvKc91jIzl6SSqf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c9/3/WHBnsSyoSbJLXpFhX9dneu/YgBhJcbZUypUc79I/1N2DOSMW5GeoLZu+rySy
         e5uFiy+SnETP80/8dTeZgqLWwPtMMyE9ETd5bpByOmKvXGIHaAfnsfn6nJROA0YCQ8
         mKmUNzv2PnTMK3wVBtZPCRLkrDRiyRGq9kIqUF94=
Date:   Thu, 29 Oct 2020 11:27:54 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Bob Pearson <rpearsonhpe@gmail.com>
Cc:     jgg@nvidia.com, zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org,
        Bob Pearson <rpearson@hpe.com>
Subject: Re: [PATCH for-next] RDMA/rxe fixed bug in rxe_requester
Message-ID: <20201029092754.GE114054@unreal>
References: <20201013170741.3590-1-rpearson@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013170741.3590-1-rpearson@hpe.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Oct 13, 2020 at 12:07:42PM -0500, Bob Pearson wrote:
> The code which limited the number of unacknowledged PSNs was incorrect.
> The PSNs are limited to 24 bits and wrap back to zero from 0x00ffffff.
> The test was computing a 32 bit value which wraps at 32 bits so that
> qp->req.psn can appear smaller than the limit when it is actually larger.
>
> Replace '>' test with psn_compare which is used for other PSN comparisons
> and correctly handles the 24 bit size.
>
> Fixes: 8700e3e7c485 ("Soft RoCE (RXE) - The software RoCE driver")
> Signed-off-by: Bob Pearson <rpearson@hpe.com>
> ---
>  drivers/infiniband/sw/rxe/rxe_req.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
> index af3923bf0a36..d4917646641a 100644
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> @@ -634,7 +634,8 @@ int rxe_requester(void *arg)
>  	}
>
>  	if (unlikely(qp_type(qp) == IB_QPT_RC &&
> -		     qp->req.psn > (qp->comp.psn + RXE_MAX_UNACKED_PSNS))) {
> +		psn_compare(qp->req.psn, (qp->comp.psn +
> +				RXE_MAX_UNACKED_PSNS)) > 0)) {

qp->comp.psn is u32, so you are checking that
qp->comp.psn + RXE_MAX_UNACKED_PSNS != 0, am I right?

>  		qp->req.wait_psn = 1;
>  		goto exit;
>  	}
> --
> 2.25.1
>
