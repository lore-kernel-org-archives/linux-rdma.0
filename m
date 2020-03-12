Return-Path: <SRS0=gJYK=45=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F20C10DCE
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Mar 2020 17:02:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1571B206F1
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Mar 2020 17:02:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="dXd/cahc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgCLRCj (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 12 Mar 2020 13:02:39 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46046 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgCLRCj (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 12 Mar 2020 13:02:39 -0400
Received: by mail-qk1-f193.google.com with SMTP id c145so7382416qke.12
        for <linux-rdma@vger.kernel.org>; Thu, 12 Mar 2020 10:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Xi7vnBGyUQ5Xv4v0XvNzbA+dP/GGqC/hSFwLO7EJg0Q=;
        b=dXd/cahcOWLE4lQgb3IunguCqmbL1n4N/5xy1HFVHfXUL4VejuPmTNxvQ/h6kbaBE1
         BLDDm551I+E08T4tTJj8Io4/kvAa5ljM4NpqSjHSXjg/4f6RhLO1EUQBk57ZudSS4NvK
         PICCIAjGCBHpEgt3ZXOMy6zzuqAdtlpXW1G2L0KS87GhG7XMgmzPVoun2U58L+jkbvUU
         IUDCrchNCrf0WjaY2EoKHftXafb1Xf8BWmxVVTFH62twXrwtV0QLKfoPyF+ooWOCzAcP
         Ul24CqIo2D+0/nGfUPZUbT8hEIAFHzUtc2GQ4+p4egprcuCOeidlWQzyNNTLlCJvV+ki
         0Tkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Xi7vnBGyUQ5Xv4v0XvNzbA+dP/GGqC/hSFwLO7EJg0Q=;
        b=sDMz9ZYp2Z3NXqxO3+P5+4EeNYV5nv858oiuEuYOY7ydVZgeGyTXQoqm5G8enJgUH5
         3RgEPOrhpNdnug1agsWJuEnVpPHAo3LV1tGsuzqTK0fwvYUgxAr9BUgU+VB63tE7ib6J
         YYG6wTeozN8BkK9PJaWPk1S3CMPjt+7bZEJRFgIa+l6vNjCbh/55OXLY1GRSMNxA0JXy
         smaEmCaczLnDXXn5bQFwvfLTI9mhxftIl5dUDjSR47KBOWkd5Yoi4Igof2+ooix7c9k8
         422zVOCCTGZzfrP92l4Hgiw3kpYTBu/11clo5anORdUGawrKeIQWp4SeQIYosf7zm5EG
         8c0A==
X-Gm-Message-State: ANhLgQ226NvO1r5Fq+4XkhX+uXQFSDjpb05tBEusaf2Rc+pomS+lm5tv
        kGG+cJ7W6LnkRFSXFknNv4qjVQ==
X-Google-Smtp-Source: ADFU+vvPT7M/In+SAcTBW/pYi5tierhOwB3h4cyPGqfdquLoS0MdGjVRHhLJMjabo/rhJpvm52aVIA==
X-Received: by 2002:a37:85c2:: with SMTP id h185mr8683953qkd.446.1584032558138;
        Thu, 12 Mar 2020 10:02:38 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id w11sm23770281qti.54.2020.03.12.10.02.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 12 Mar 2020 10:02:37 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jCRED-0000et-4S; Thu, 12 Mar 2020 14:02:37 -0300
Date:   Thu, 12 Mar 2020 14:02:37 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Weihang Li <liweihang@huawei.com>, dledford@redhat.com,
        linux-rdma@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH for-next] RDMA/hns: Add interface to support lock free
Message-ID: <20200312170237.GS31668@ziepe.ca>
References: <1583999290-20514-1-git-send-email-liweihang@huawei.com>
 <20200312092640.GA31504@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312092640.GA31504@unreal>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Mar 12, 2020 at 11:26:40AM +0200, Leon Romanovsky wrote:
> On Thu, Mar 12, 2020 at 03:48:10PM +0800, Weihang Li wrote:
> > From: Jiaran Zhang <zhangjiaran@huawei.com>
> >
> > In some scenarios, ULP can ensure that there is no concurrency when
> > processing io, thus lock free can be used to improve performance.
> >
> > Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
> > Signed-off-by: Yixian Liu <liuyixian@huawei.com>
> > Signed-off-by: Weihang Li <liweihang@huawei.com>
> >  drivers/infiniband/hw/hns/hns_roce_device.h |   1 +
> >  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 112 ++++++++++++++++++++--------
> >  drivers/infiniband/hw/hns/hns_roce_qp.c     |   1 +
> >  3 files changed, 84 insertions(+), 30 deletions(-)
> >
> 
> NAK, everything in this patch is wrong, starting from exposure,
> implementation and description.

Yes, complete no on a module parameter to disable locking.

Jason
