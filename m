Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD34C433F5
	for <linux-rdma@archiver.kernel.org>; Mon, 28 Feb 2022 12:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiB1MDY (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 28 Feb 2022 07:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236081AbiB1MDX (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 28 Feb 2022 07:03:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFC265D3
        for <linux-rdma@vger.kernel.org>; Mon, 28 Feb 2022 04:02:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 659BEB8110F
        for <linux-rdma@vger.kernel.org>; Mon, 28 Feb 2022 12:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888C5C340E7;
        Mon, 28 Feb 2022 12:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646049761;
        bh=hFLWgK94cXg4Slf9Rj1w8RCAUQVtcScpj2CxkPDy/qY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X5/EnYulP8wjeL0tmujPDd6w3aKIgpAhJQ5s0JfL8WJh7XtCytRB8UE1NPJPyZttd
         7ZAKivo72vIyhS4+xXNxL+9MZseZ21oe+9L5ug/2IO2r06mQtD/3gXCKJbrz+Ro/4q
         aUMBtL1qZRlZSktGjFoMxLW8oJ1/QyqDMf6bH1vWM9sX9VMjRhj723oJJHaegW1PSM
         KL63/NPTn/l4kT2B+RGzP1JhAyHTL+UNhu8rHp800+gyQJEgB8K7hEH9b9vwCa7nZt
         EB5+arPIOJyPQODg6XswRo0AGN3CnyxLF5VVnH+8UHqrx3qEdg80gvDUcEyplEcjUO
         WS7q16iUEfluw==
Date:   Mon, 28 Feb 2022 14:02:36 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Wenpeng Liang <liangwenpeng@huawei.com>
Cc:     jgg@nvidia.com, linux-rdma@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH v2 for-next 9/9] RDMA/hns: Refactor the alloc_cqc()
Message-ID: <Yhy53JD8gHA3r/Dz@unreal>
References: <20220225112559.43300-1-liangwenpeng@huawei.com>
 <20220225112559.43300-10-liangwenpeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225112559.43300-10-liangwenpeng@huawei.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Feb 25, 2022 at 07:25:59PM +0800, Wenpeng Liang wrote:
> Abstract the alloc_cqc() into several parts and separate the process
> unrelated to allocating CQC.
> 
> Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_cq.c | 65 ++++++++++++++-----------
>  1 file changed, 37 insertions(+), 28 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
