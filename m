Return-Path: <SRS0=sHe/=IG=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06726C433E6
	for <linux-rdma@archiver.kernel.org>; Mon,  8 Mar 2021 02:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7A116514A
	for <linux-rdma@archiver.kernel.org>; Mon,  8 Mar 2021 02:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbhCHCsa (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 7 Mar 2021 21:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbhCHCsC (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 7 Mar 2021 21:48:02 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A048C06174A
        for <linux-rdma@vger.kernel.org>; Sun,  7 Mar 2021 18:47:51 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id e45so7809906ote.9
        for <linux-rdma@vger.kernel.org>; Sun, 07 Mar 2021 18:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hHRXAlONfXbOqY1jNxUBmhZcpELlEbXbqZUMBoroz64=;
        b=OZlRm/lTDQqxTobVn/LJab2Hu4ofF/FpeltPwy8bv25jtEgiquY/P+pykW+NxFj3EX
         8vSeSM3hVndoOX0idHHClSCii4lyGHvvDV5s+e6JQzLU8vrOpp1zsvwo5ewwpG8R8W8I
         oUWsfTA255HWwQKda4Swu01REDQzcqTSuJUBJzyFhg5/IL8+XSSnnmp+twJ4KzhRu2W9
         zUVax0TF0mdcxIJXiqqlByZPwixgw9RtkonS6ioiDJedJUh+qr4khhpm0PO+lfXvLVBX
         HjC8NUqW5OyV8uEk9iiOwMgtxof/BP6W2zv0DjourPq2vflfKEPTK7SHtv8vae+dOp8h
         baSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hHRXAlONfXbOqY1jNxUBmhZcpELlEbXbqZUMBoroz64=;
        b=qRBKYavL2Hde6tFLoja7nMxfFg6A+9ZR9XfXE7345cf84u4ruAnUI6xLDnUmyyUGIL
         dVfz2Ba4+t3V0sXK+tq43N6IvvqIyaWZQnghfIlgC1PLmliKPoWkqjIm2DiBY093Zpq6
         5Qne1Qr4D2T3CAni8HB+DaZ5Pk+E+nTJLYUp/9OIYB2g7sJZXs7wgto5S3Gjkaixvbm4
         TTd/lo7fxSx8MDT0ZM8CTXRcvUaqdNul6yVBn9DsKTh8Q8fN+0zU5bS9j+MdpX+CQ5Wz
         ga4ZEHbUVQLCa6wnQPSYIld59qBZfRjVNegQz2GTHIlZ7yypwbcWTdVp5qRz2lS+aOaF
         wR3g==
X-Gm-Message-State: AOAM532GL5bCQGdEgR4EKBBKgjhTd9QgItC3sK2FkBjXCAcMA12vultd
        eoTMFo4XTv1YiVXbFQKQ5b2DStMJqANUwozS9cA=
X-Google-Smtp-Source: ABdhPJxk4X9I4CV12M+m4YH3cOlhuELy6GxB2eAEF7puKeWGCGuK8QW8+Ua1i7tweNxxudlLvBMWiDaFl0NZkxrpvOI=
X-Received: by 2002:a9d:7650:: with SMTP id o16mr9126016otl.278.1615171670838;
 Sun, 07 Mar 2021 18:47:50 -0800 (PST)
MIME-Version: 1.0
References: <20210307221034.568606-1-yanjun.zhu@intel.com> <CAD=hENeqTTmpS5V+G646V0QvJFLVSd3Sq11ffQFcDXU-OSsQEg@mail.gmail.com>
 <20210308004419.GU4247@nvidia.com>
In-Reply-To: <20210308004419.GU4247@nvidia.com>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Mon, 8 Mar 2021 10:47:39 +0800
Message-ID: <CAD=hENcFwiAzgUDjsBK9s4aDLHAEd7skiS_axz0+gPoacysoug@mail.gmail.com>
Subject: Re: Fwd: [PATCH 1/1] RDMA/umem: add back hugepage sg list
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        maorg@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Mar 8, 2021 at 8:44 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Sun, Mar 07, 2021 at 10:28:33PM +0800, Zhu Yanjun wrote:
> > From: Zhu Yanjun <zyjzyj2000@gmail.com>
> >
> > After the commit ("RDMA/umem: Move to allocate SG table from pages"),
> > the sg list from ib_ume_get is like the following:
>
> If you are not getting huge pages then you need to fix
> __sg_alloc_table_from_pages()
>
> But as far as I know it is not buggy like you are describing.

In the same host and the same test, both __sg_alloc_table_from_pages
and ib_umem_add_sg_table
are called at the same time, but the returned sg lists are different.
It is weird.

Zhu Yanjun

>
> > The new function is ib_umem_get to ib_umem_hugepage_get that calls
> > ib_umem_add_sg_table.
>
> Nope
>
> Jason
