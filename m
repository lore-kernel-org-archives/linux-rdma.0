Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F09C636CC
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Feb 2023 12:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbjBOM2T (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 15 Feb 2023 07:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjBOM2T (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 15 Feb 2023 07:28:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F85722006;
        Wed, 15 Feb 2023 04:28:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03F3361B4E;
        Wed, 15 Feb 2023 12:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA7DC433D2;
        Wed, 15 Feb 2023 12:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676464097;
        bh=d8yeDKbreQ9sFdZayjUG1UkqQfOJ1M/LMMFgbdobS1E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fd1b+yKl6oqWfgU+GcpjswORXpBfXMzpSUaS2fcMXdVaqj/R+lDA2cvqzW+9mtBlG
         vePbjyJ2YgULWaTB5CN4thmtIGOr3GUXyKSGO70eHP52XRzDHMdQ5Dskm8Ufk7vfsB
         ejkgCFwn6CG0j0YY9IAnCwRVgg/ILEfoKFSmVUNPLJi1voBwO6oXRMeYwzi//LlPJC
         G6PnYyaQXvsRce1JvkhjwqZKB6ZAVpaLxRA0EoiJOvOywRhOHT2RXQvOR6tkklITPA
         FQ5AliojnxkF43/500aEnPHblEmRhGzU2wT8C+sC4sXxI+/6ljaS/5T2Lk+PgZGlLL
         Nm/Qrtg38LbtQ==
Date:   Wed, 15 Feb 2023 14:28:13 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Natalia Petrova <n.petrova@fintech.ru>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] ocrdma: Fix potential null-ptr-deref in
 ocrdma_is_qp_in_rq_flushlist()
Message-ID: <Y+zP3Vkr348ufUhc@unreal>
References: <20230215101045.476291-1-n.petrova@fintech.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215101045.476291-1-n.petrova@fintech.ru>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Feb 15, 2023 at 01:10:45PM +0300, Natalia Petrova wrote:
> The 'qp->rq_cq' pointer can be equal to null in ocrdma_destroy_qp()

How is it possible that we will have valid QP without rq_cq?

Thanks

> function. That's why 'qp->rq_cq' should be checked for null in
> ocrdma_del_flush_qp() before it will be dereferenced in
> ocrdma_is_qp_in_rq_flushlist().
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: fe2caefcdf58 ("RDMA/ocrdma: Add driver for Emulex OneConnect IBoE RDMA adapter")
> Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index dd4021b11963..a3d994ee178c 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -1660,7 +1660,7 @@ void ocrdma_del_flush_qp(struct ocrdma_qp *qp)
>  	found = ocrdma_is_qp_in_sq_flushlist(qp->sq_cq, qp);
>  	if (found)
>  		list_del(&qp->sq_entry);
> -	if (!qp->srq) {
> +	if (!qp->srq && qp->rq_cq) {
>  		found = ocrdma_is_qp_in_rq_flushlist(qp->rq_cq, qp);
>  		if (found)
>  			list_del(&qp->rq_entry);
> -- 
> 2.34.1
> 
