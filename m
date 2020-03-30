Return-Path: <SRS0=Qv+Y=5P=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F67C43331
	for <linux-rdma@archiver.kernel.org>; Mon, 30 Mar 2020 11:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D091C206F6
	for <linux-rdma@archiver.kernel.org>; Mon, 30 Mar 2020 11:58:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Az4bL9vF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbgC3L6a (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 30 Mar 2020 07:58:30 -0400
Received: from mail-yb1-f173.google.com ([209.85.219.173]:35422 "EHLO
        mail-yb1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729785AbgC3L6a (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 30 Mar 2020 07:58:30 -0400
Received: by mail-yb1-f173.google.com with SMTP id x63so8891659ybx.2
        for <linux-rdma@vger.kernel.org>; Mon, 30 Mar 2020 04:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hZ1K5X1phN7beW28/2naiHUtsnsfPriBuUBHe9LpPRE=;
        b=Az4bL9vFGDr1K4y0hhsFH+xOvKKToQzN7JL9xNDwRlpLGXpvOlPpB5QuA1wpR1IedK
         vOthhhI/WFcAjr7evAevv9avDlMiSQHt/ut1rgvFf2zzr09aAngoh7Av+bVUCAUBQLGM
         0Z2xqetpu9Zg/RbAGAO/fiBnLEBthoNZG2Y1w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hZ1K5X1phN7beW28/2naiHUtsnsfPriBuUBHe9LpPRE=;
        b=ng3GLzcJZyZw8pRKwAb/NbEfMMGHCRk3aGAbQafyMs8MLeM4taNxCCgR6T+ZgMzpan
         f5+I1zzYaPWTyqcGpyruTzvy3ZkNmT1BpQDNjUOP9et4Kbj/hJ08jHVKLZI8VYLFbn04
         dipOJzjpe6I9EKoFfdhuBO9QTiEjNIZjMOcW6VTm5txhpDeVGPLkdysjXre9S6ul9sYt
         2A4vWZEPO39yB8OdZUkdKNBD1aAE+9cypPOoi82J7NnXIo7sRmiDFwmrgGtqZC0ePEH6
         AiqU0aA455/QqdbaV7Ajm0VPILhz1IatuHfVDjZtOneaW5Pw+aSa8uRYWlgZtM4n4ahj
         EaGw==
X-Gm-Message-State: ANhLgQ0IMGpVpWFOKIUasAzmM+KjYQPSqnxV0EGSlwqOye5PIBhLUXj/
        j2JZxgarGm3yY7kSBcRq+p8sa4F/IncXxfdYbD8TRQ==
X-Google-Smtp-Source: ADFU+vtuY4/KkBhkSck5B8WKc6bnlZp4dSirUh6Dci3jP9EzD3+YupYJ9TZ8C7a2KtaygPYZb89xdPw047tuL3S+HFs=
X-Received: by 2002:a5b:447:: with SMTP id s7mr19471531ybp.160.1585569508651;
 Mon, 30 Mar 2020 04:58:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200330110219.24448-1-yuehaibing@huawei.com>
In-Reply-To: <20200330110219.24448-1-yuehaibing@huawei.com>
From:   Selvin Xavier <selvin.xavier@broadcom.com>
Date:   Mon, 30 Mar 2020 17:28:17 +0530
Message-ID: <CA+sbYW1d0GPH+ztur6v-PzPiA4Y-GXf2ptA0hF=U6LgJvaBB9A@mail.gmail.com>
Subject: Re: [PATCH -next] RDMA/bnxt_re: make bnxt_re_ib_init static
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Devesh Sharma <devesh.sharma@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Mar 30, 2020 at 4:33 PM YueHaibing <yuehaibing@huawei.com> wrote:
>
> Fix sparse warning:
>
> drivers/infiniband/hw/bnxt_re/main.c:1313:5:
>  warning: symbol 'bnxt_re_ib_init' was not declared. Should it be static?
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Selvin Xavier <selvin.xavier@broadcom.com>

Thanks,
Selvin Xavier
