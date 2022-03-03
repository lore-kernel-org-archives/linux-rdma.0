Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF642C4332F
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Mar 2022 19:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235836AbiCCTB5 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 3 Mar 2022 14:01:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235834AbiCCTBz (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 3 Mar 2022 14:01:55 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2B219F45A;
        Thu,  3 Mar 2022 11:01:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7B672CE283C;
        Thu,  3 Mar 2022 19:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E70AC340EF;
        Thu,  3 Mar 2022 19:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646334066;
        bh=6ZgQZFPjT4ERYD4AAFuJJu62nDV2iPyeqpdTkS/jbPA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LA9aPS607DbiaCU7BdQJAuw9Dv5ntB4rTI+iV7+179CS3sby2VU5KZMwRUf8SuFSp
         56JJMxjvc5rtNAwEBqFtbkQgXvtNKe+gmqzd53BMPlSzQtS7vIyA6IujnN+tikUr+o
         tcV9M+DgqBDLgmb7TZeaQzEXkzMAralMhGi0MwQiiSGAkFFk6mr1fhrvaTZMJjs85A
         zJ+q62IRRqjjrSwA5aduT7qcQMmcZFijZBuIj0zQbfqX42tXi/8qRHeIgggnU1/Dxk
         h8G0xAj811KKPGN0u1K3PGncqr0FU8IH6E9hP51FVnJSTaTQzblHuWBOqRdjoWom3S
         Z1QATBkDUpLow==
Date:   Thu, 3 Mar 2022 20:25:31 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     jgg@nvidia.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-next] RDMA/core: Fix ib_qp_usecnt_dec() called when
 error
Message-ID: <YiEIG4bFVFlEDHML@unreal>
References: <20220303024232.2847388-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303024232.2847388-1-yajun.deng@linux.dev>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Mar 03, 2022 at 10:42:32AM +0800, Yajun Deng wrote:
> ib_destroy_qp() would called by ib_create_qp_user() if error, the former
> contains ib_qp_usecnt_dec(), but ib_qp_usecnt_inc() was not called before.
> 
> So move ib_qp_usecnt_inc() into create_qp().
> 
> Fixes: d2b10794fc13 ("RDMA/core: Create clean QP creations interface for uverbs")
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  drivers/infiniband/core/uverbs_cmd.c          | 1 -
>  drivers/infiniband/core/uverbs_std_types_qp.c | 1 -
>  drivers/infiniband/core/verbs.c               | 3 +--
>  3 files changed, 1 insertion(+), 4 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
