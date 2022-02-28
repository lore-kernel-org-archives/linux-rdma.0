Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF01C433EF
	for <linux-rdma@archiver.kernel.org>; Mon, 28 Feb 2022 12:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbiB1MFJ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 28 Feb 2022 07:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbiB1MFJ (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 28 Feb 2022 07:05:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DB917E28
        for <linux-rdma@vger.kernel.org>; Mon, 28 Feb 2022 04:04:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 992EB6111E
        for <linux-rdma@vger.kernel.org>; Mon, 28 Feb 2022 12:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A9BC340F3;
        Mon, 28 Feb 2022 12:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646049870;
        bh=pLYdcdfO0UT8u/75ahH5RixQhNCwyi2jilxz+TCyC9A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DJi1MNUkViV6png/lEGissnzsskLWWC2YmkjmS/XjP/dtGfCX9C6RgJj4PdlIE3w+
         QCb9hGgfgOkVYXz2yGyWUqLMQhnCs/kEycTMHaRZulJUqElWqUNcSW7i78+rMTxjTx
         NmDK5BjuUkWFRzGMr4PhcDEBRhKe9pGMFCKql04jw9E3iQ5d4Akr9ZhAo2INfOkDWj
         NraYSyFfbl3pVeloSElcWsGy1+vDb9ztU1pdyp6+dxAAqrdWYcAzoGkCTSiOUV1dWh
         bZ6aLxe4QCYWPs0t2fafVYjmg+GQ+cmGzP+IDZIlGSNk3dZU8JFhD2vN9JrN+sp+tp
         MZS0xTmaZ4qgA==
Date:   Mon, 28 Feb 2022 14:04:25 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Wenpeng Liang <liangwenpeng@huawei.com>
Cc:     jgg@nvidia.com, linux-rdma@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH v2 for-next 8/9] RDMA/hns: Refactor the alloc_srqc()
Message-ID: <Yhy6SZ6QWZCduEBY@unreal>
References: <20220225112559.43300-1-liangwenpeng@huawei.com>
 <20220225112559.43300-9-liangwenpeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225112559.43300-9-liangwenpeng@huawei.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Feb 25, 2022 at 07:25:58PM +0800, Wenpeng Liang wrote:
> From: Chengchang Tang <tangchengchang@huawei.com>
> 
> Abstract the alloc_srqc() into several parts and separate the alloc_srqn()
> from the alloc_srqc().
> 
> Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
> Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_srq.c | 80 +++++++++++++++---------
>  1 file changed, 52 insertions(+), 28 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
