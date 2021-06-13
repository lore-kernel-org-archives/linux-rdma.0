Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C572C48BDF
	for <linux-rdma@archiver.kernel.org>; Sun, 13 Jun 2021 10:12:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 072E761261
	for <linux-rdma@archiver.kernel.org>; Sun, 13 Jun 2021 10:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhFMKOe (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 13 Jun 2021 06:14:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231277AbhFMKOd (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 13 Jun 2021 06:14:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53AFF6124B;
        Sun, 13 Jun 2021 10:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623579153;
        bh=6sj02lXdIgSqSOetEwdbi+jff5qJmm3JxXGESMeHVjg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OtxDeZUp+KOxn2An8P/TpQ4NxdcctPIP2dsg+SddYPe1HoIFlolqspYiryZ45d1YF
         /unuT3fFbIdo9kg87Dx3zxopkyb633PZPncIOIxSjiN1Lf7PTVMmumzeROUUZe6RtJ
         JGxJMLlGhcjvteIAmYF3RmwXKkjJBNb6M209ObabuO9SzAhNAii0QnPCSN7oxq5jIa
         NPnDOOnrmkKQfBAgG49OOr2fUmFQo4QTn7WRuI0rMZY/co3T+P839OAv4eDmjbILXo
         Y0mrG2bz2GUlShHm0o2k62sEhVfSu1IF8rLW+fTkfWQAhpkjfduudyNQ4VFkjEbKMP
         c7viiVo/D2reg==
Date:   Sun, 13 Jun 2021 09:25:00 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jack Wang <jinpu.wang@ionos.com>
Cc:     linux-rdma@vger.kernel.org, bvanassche@acm.org,
        dledford@redhat.com, jgg@ziepe.ca, haris.iqbal@ionos.com,
        Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Gioh Kim <gi-oh.kim@ionos.com>
Subject: Re: [PATCHv2 for-next 3/5] RDMA/rtrs: RDMA_RXE requires more number
 of WR
Message-ID: <YMWkvJmA3rjfUjoK@unreal>
References: <20210611121034.48837-1-jinpu.wang@ionos.com>
 <20210611121034.48837-4-jinpu.wang@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611121034.48837-4-jinpu.wang@ionos.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Jun 11, 2021 at 02:10:32PM +0200, Jack Wang wrote:
> From: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
> 
> When using rdma_rxe, post_one_recv() returns
> NOMEM error due to the full recv queue.
> This patch increase the number of WR for receive queue
> to support all devices.
> 
> Signed-off-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
> Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> Signed-off-by: Gioh Kim <gi-oh.kim@ionos.com>
> ---
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c | 7 ++++---
>  drivers/infiniband/ulp/rtrs/rtrs-srv.c | 2 +-
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 

NOMEM -> ENOMEM

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
