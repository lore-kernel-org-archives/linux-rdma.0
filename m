Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B080EC48BDF
	for <linux-rdma@archiver.kernel.org>; Sun, 13 Jun 2021 10:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C45A61279
	for <linux-rdma@archiver.kernel.org>; Sun, 13 Jun 2021 10:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbhFMKOi (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 13 Jun 2021 06:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231277AbhFMKOh (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 13 Jun 2021 06:14:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F20861261;
        Sun, 13 Jun 2021 10:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623579156;
        bh=B3suh4tEl4I+0ZKonhFLOjuiqWnJZ4XI1S3epTCrO94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YWeXy5pg1ZpKcN7upOGkooKm1bBxfQ0iBZHkW33V6QAYx+A7QOqippS0HfCALG6uK
         OddLcYR6rdWYHBYUAvLmhOfUTcBH/Feenx/JM41zSr4bmhlRnhMyKrJUPlBAHDju1w
         w8tR1Yx9Yzmmec/kxIZTxh3xVInTBOriEFFuTHWkgwipeTY1zr7q1pqZS6hhQcZpca
         j3MwFf5NykcizCLwSmroYcq7G6ke+4e0XlqeElr+diJamvCNklKGkzMFgMdOcyzTZ5
         5WJPn6ZEQRHeqT4Oi73mRqoN0Cvkqj/mbolbkMM149Tn8WaWwtPOH+tDZ5ZrisefL2
         DB1CSH+1UMYRQ==
Date:   Sun, 13 Jun 2021 09:32:24 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jack Wang <jinpu.wang@ionos.com>
Cc:     linux-rdma@vger.kernel.org, bvanassche@acm.org,
        dledford@redhat.com, jgg@ziepe.ca, haris.iqbal@ionos.com,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCHv2 for-next 4/5] RDMA/rtrs: Rename some variables to avoid
 confusion
Message-ID: <YMWmeJL3QxN4d8T5@unreal>
References: <20210611121034.48837-1-jinpu.wang@ionos.com>
 <20210611121034.48837-5-jinpu.wang@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611121034.48837-5-jinpu.wang@ionos.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Jun 11, 2021 at 02:10:33PM +0200, Jack Wang wrote:
> From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> 
> Those variables are passed to create_cq, create_qp, rtrs_iu_alloc and
> rtrs_iu_free, so these *_size means the num of unit. And cq_size also
> means number of cq element.
> 
> Also move the setting of cq_num to common path.
> 
> Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> Reviewed-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
> Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c | 18 +++++++++---------
>  drivers/infiniband/ulp/rtrs/rtrs-clt.h |  2 +-
>  drivers/infiniband/ulp/rtrs/rtrs-pri.h | 10 +++++-----
>  drivers/infiniband/ulp/rtrs/rtrs-srv.c |  7 +++----
>  drivers/infiniband/ulp/rtrs/rtrs.c     | 24 ++++++++++++------------
>  5 files changed, 30 insertions(+), 31 deletions(-)
> 

Commit message is worth to rewrite.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
