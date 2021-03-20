Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F18C433C1
	for <linux-rdma@archiver.kernel.org>; Sat, 20 Mar 2021 12:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B827D61967
	for <linux-rdma@archiver.kernel.org>; Sat, 20 Mar 2021 12:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhCTMOM (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 20 Mar 2021 08:14:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhCTMNn (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 20 Mar 2021 08:13:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4DC36195F;
        Sat, 20 Mar 2021 09:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616232874;
        bh=66r+CrmR3fsyUSBE/R/otp+elBpOuGH4d59OERCFndA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DZ/xAGLf3n6LTJ/TWNpyF+n4Zk24neM6Vie1Se4z8SBiArAaXNVCV+X2Y2w33SrDM
         UQOI8bLTjvcgcYcsJI9mjoaT8ONvHoPwST1R2TczquuOhuskgsUj6IBtOqFqCQcQ8t
         ANNgk0iOVOoUpxyOks6XYQLXFABa3pHihDqt2R5QQhZl8AGlS4M8tWTMUCoDuqCshw
         UfJoHwZ4mXsfD7PFboozWey27k2lefeS/qw0zrZiGURfHsG2mu63OCUgO4XO1Jh4/e
         /vNWeOJ5URKgPHGGMGBqLNNVNqqvZBY3xphAEtt682VGwN9aE++7wrSJXhPEjRzmHf
         1KQO2qrA7Eazg==
Date:   Sat, 20 Mar 2021 11:34:30 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Weihang Li <liweihang@huawei.com>
Cc:     dledford@redhat.com, jgg@nvidia.com, linux-rdma@vger.kernel.org,
        linuxarm@huawei.com
Subject: Re: [PATCH for-next] RDMA/core: Check invalid QP state for
 ib_modify_qp_is_ok()
Message-ID: <YFXBprYFmFgHu9Z8@unreal>
References: <1616144545-18159-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1616144545-18159-1-git-send-email-liweihang@huawei.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Mar 19, 2021 at 05:02:25PM +0800, Weihang Li wrote:
> From: Xi Wang <wangxi11@huawei.com>
> 
> Out-of-bounds may occur in 'qp_state_table' when the caller passing wrong
> QP state value.

How is it possible? Do you have call stack to support it?

Thanks

> 
> Signed-off-by: Xi Wang <wangxi11@huawei.com>
> Signed-off-by: Weihang Li <liweihang@huawei.com>
> ---
>  drivers/infiniband/core/verbs.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index 28464c5..66ba4e6 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -1613,6 +1613,10 @@ bool ib_modify_qp_is_ok(enum ib_qp_state cur_state, enum ib_qp_state next_state,
>  	    cur_state != IB_QPS_SQD && cur_state != IB_QPS_SQE)
>  		return false;
>  
> +	if (cur_state >= ARRAY_SIZE(qp_state_table) ||
> +	    next_state >= ARRAY_SIZE(qp_state_table[0]))
> +		return false;
> +
>  	if (!qp_state_table[cur_state][next_state].valid)
>  		return false;
>  
> -- 
> 2.8.1
> 
