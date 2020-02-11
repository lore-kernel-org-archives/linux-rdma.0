Return-Path: <SRS0=fYJ1=37=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A61C352A3
	for <linux-rdma@archiver.kernel.org>; Tue, 11 Feb 2020 18:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA3AC206D6
	for <linux-rdma@archiver.kernel.org>; Tue, 11 Feb 2020 18:26:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="QzedAM21"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730296AbgBKS0Z (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 11 Feb 2020 13:26:25 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36897 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730293AbgBKS0Y (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 11 Feb 2020 13:26:24 -0500
Received: by mail-qt1-f195.google.com with SMTP id w47so8707099qtk.4
        for <linux-rdma@vger.kernel.org>; Tue, 11 Feb 2020 10:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BJvL+lmCwMBkncnmlhHwzjHmcm3WzfXNi7nBZlUFk2o=;
        b=QzedAM21SqX2Dnf+y8FuqQPgynmzu5StI/iDexF058v1XivPk7rlW8xPP2Xv0WD2G8
         xR7BcwuG+PhWD707+xB5sb6zaD0zb0uCSXDOdRuibcN9IMw9OSl1ENwXeAP1jz+JliRE
         zWnX0Wk4zyRFbQkin+DrVsVEowsjaCvD0oHDEFelMqwmzYtuScGMvimNyR7wPjI/a6fL
         gsTp0Z1SN5+7zLTzZE9Ga8x5cylnBBV1R67MXV97HS7N+gBmYKvRAr5S3X2SKskNI2qW
         7RNxgKnDV+1aKFiQOFNCCbXLtH94LAhudZscagGFhvSCTL96bcEYY0Fs2/IA8ma/bcj7
         MXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BJvL+lmCwMBkncnmlhHwzjHmcm3WzfXNi7nBZlUFk2o=;
        b=k4tshaRbE0FcUJvBAhPEOJbtFN2OY2doe//Cy8QLujAcJbegloamHhA2pnstO6/3EO
         +nG9OqaI5u8V3+KcfQKtDsp6A1WBr4EvxRrAOKStn9LfOpmgXRmHf4yDXDAaXNUtVUc5
         BLbYfwxXbHY7GzjQxUoHqw61HM9puKnl6NPEVOqsNKAJ6HRlw169uo0ERw2yz0sqd1zf
         rM5xHLYgC9025AP07kf7DJOWyhERpYZSuGNaHqlExivx/CWkNtLMdyI9JMJLYFl4VTa1
         CwSeW+4tMCjNfUPLSpjD4yJN8eM7nk65HYAigsp7YqSfejWMHlMYTY31rnOpDFQ8Aypj
         RBjQ==
X-Gm-Message-State: APjAAAWTcmUQ34iAtlUn7SL9xd/+YcBSgZSbxLzoa4JEX0nDc38ZD1iX
        5xZfN+HEQlJpziV5YqwuCq1x6g==
X-Google-Smtp-Source: APXvYqzi92P1z/EoXjDTJiRnAzFpkUMDdmdBh2TfShZjszn7LPOKGvcNQGprgpIhJwVQPsMYvkwkmg==
X-Received: by 2002:aed:2d67:: with SMTP id h94mr15730967qtd.74.1581445583676;
        Tue, 11 Feb 2020 10:26:23 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id g37sm2675185qte.60.2020.02.11.10.26.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Feb 2020 10:26:23 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j1aEo-0003VR-T7; Tue, 11 Feb 2020 14:26:22 -0400
Date:   Tue, 11 Feb 2020 14:26:22 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Weihang Li <liweihang@huawei.com>
Cc:     dledford@redhat.com, leon@kernel.org, linux-rdma@vger.kernel.org,
        linuxarm@huawei.com
Subject: Re: [PATCH for-next] RDMA/hns: Cleanups of magic numbers
Message-ID: <20200211182622.GA13453@ziepe.ca>
References: <20200126145504.9700-1-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200126145504.9700-1-liweihang@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sun, Jan 26, 2020 at 10:55:04PM +0800, Weihang Li wrote:
> From: Lang Cheng <chenglang@huawei.com>
> 
> Some magic numbers are hard to understand, so replace them with macros
> or add some comments for them.
> 
> Signed-off-by: Lang Cheng <chenglang@huawei.com>
> Signed-off-by: Yixian Liu <liuyixian@huawei.com>
> Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
> Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
> Signed-off-by: Weihang Li <liweihang@huawei.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_device.h |  2 +-
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 10 +++++-----
>  drivers/infiniband/hw/hns/hns_roce_qp.c     | 23 +++++++++++++----------
>  drivers/infiniband/hw/hns/hns_roce_srq.c    |  3 ++-
>  4 files changed, 21 insertions(+), 17 deletions(-)

Applied to for-next, thanks

Jason
