Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FC8FC433FE
	for <linux-rdma@archiver.kernel.org>; Mon, 28 Feb 2022 12:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236208AbiB1MEv (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 28 Feb 2022 07:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234902AbiB1MEt (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 28 Feb 2022 07:04:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C4B673F1
        for <linux-rdma@vger.kernel.org>; Mon, 28 Feb 2022 04:03:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8A5EB81117
        for <linux-rdma@vger.kernel.org>; Mon, 28 Feb 2022 12:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148BFC340F4;
        Mon, 28 Feb 2022 12:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646049833;
        bh=d+Rrbj4VIoJbFEV14TRgylDByOGXSOeFykofHLcSr/s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gst0blPCi8jxR/5n1MRNLfWjj89s+usZ0EG73rwxzWIavjUH0Pr2CaaeEVCbg1rHD
         0fBCJU00N/LK8y1NDfql1151tZVNcQoWEjn0rkToBfA9NXuAnxtVHnuq+T0aQpQtF5
         SNdTIlY+Djo6jaD1zzBPzLzjdh5Xh1KyD+roB2aRuXXXy0NIDHz56rJ8pdgkpFHoe4
         L+UUtvOkZRcZ12bArRgKcywEssLyUITerfjCBD+OAcza0RkWPpcqm9VovsZSYdVyfu
         NIFBng/EwLB1NA2exJIDbkkflgPclbJLLY+73jM5u5BMolEys4UF/nQDsm0I6Rm55O
         w22lwtn6rEEPg==
Date:   Mon, 28 Feb 2022 14:03:49 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Wenpeng Liang <liangwenpeng@huawei.com>
Cc:     jgg@nvidia.com, linux-rdma@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH v2 for-next 7/9] RDMA/hns: Clean up the return value
 check of hns_roce_alloc_cmd_mailbox()
Message-ID: <Yhy6JcVjaaS2AFat@unreal>
References: <20220225112559.43300-1-liangwenpeng@huawei.com>
 <20220225112559.43300-8-liangwenpeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225112559.43300-8-liangwenpeng@huawei.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Feb 25, 2022 at 07:25:57PM +0800, Wenpeng Liang wrote:
> hns_roce_alloc_cmd_mailbox() never returns NULL, so the check should be
> IS_ERR(). Additionally, PTR_ERR() should be used to return an error code.
> 
> Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++--
>  drivers/infiniband/hw/hns/hns_roce_mr.c    | 8 +++-----
>  drivers/infiniband/hw/hns/hns_roce_srq.c   | 4 ++--
>  3 files changed, 7 insertions(+), 9 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
