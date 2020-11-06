Return-Path: <SRS0=fSJB=EM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE03BC2D0A3
	for <linux-rdma@archiver.kernel.org>; Fri,  6 Nov 2020 16:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F10F21556
	for <linux-rdma@archiver.kernel.org>; Fri,  6 Nov 2020 16:39:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="MiFjd5ei"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgKFQjz (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 6 Nov 2020 11:39:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgKFQjz (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 6 Nov 2020 11:39:55 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B590C0613CF
        for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2020 08:39:55 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id 12so1600528qkl.8
        for <linux-rdma@vger.kernel.org>; Fri, 06 Nov 2020 08:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6V7clZhQAMmnpPbxTHFIjFjrz3TNWvnMnGpi4wE2kog=;
        b=MiFjd5eidEgSuTk8BE49VDLRwB7dT/rglcAHo/tv2MrzUsEcSfp/RlJMO4pm/8KFRo
         1HFmNj2EefwqoF5hjflh1bWjprMMl3dJmqz1+4hWR5RyuP6CmrMY/NsBoLlBbPvv1tTA
         VlybEmOkkputMcxJe7TteoW+K3Kd6yl+Hrxk4HhcX5h/codWvjQRD3XCmRPYuBpQbFvk
         jh5u4+mf3qk1AUxQFP6V2L++epigln8ZMwocqp049+jTG6BqvF3hnxTIw8Ud1JQRxD5i
         HTsTals+r5mzd5AzidPO27e2JKBjjrsKwCQCWGko7A7Y6JgK9urIzuXwRo7cTLwfvscc
         fTYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6V7clZhQAMmnpPbxTHFIjFjrz3TNWvnMnGpi4wE2kog=;
        b=W36FyYQ2qYGFXi7vaAYStCUDDv/v3hvQKTGW7WXCzQSBwzZKr3/RGxfkQBTfMuoVVX
         IKp/G6IjLdAuJc6q+zVSU1NaI1+pG+Cz2U8PFpylmc0eyb2lGXGF9RiO6KA5le6zYAEo
         S8sumgYTpTVGqEnstsY18xqO1XAY8QOBDaRfn7kYDoE9jXWjFC4q65R5QvPAt71IvG07
         VcjrSb2oVnuCshmBHHqjQJOGma8/Xgy0yK65FWL7dN+9Scx6MJHEXYcSUsuINNLWPEtV
         WSqLtGcF77IMx8e0IqjW6jsBiOhhsNlRfse8SMYGWBCzv/UNYDwDnJeEbewabE8nhtQs
         QI7g==
X-Gm-Message-State: AOAM533EUfmVKPgpIoiV1bBsxCb6LgYTxQNbIbXam4zAwGSFm1WF5boF
        Dy9neaGOWtMc4ct+1V/IQKVWhmKoGInISWC3
X-Google-Smtp-Source: ABdhPJzw3rNWYSOmevoJiZrNrxTU6VHvIn17N4say8BwYnm+neSM8U/WKJVyk+gduYJ8DKnqX9aLsA==
X-Received: by 2002:a05:620a:5a2:: with SMTP id q2mr2296229qkq.335.1604680794855;
        Fri, 06 Nov 2020 08:39:54 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id 22sm759249qtw.61.2020.11.06.08.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 08:39:54 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kb4mH-000xgU-5p; Fri, 06 Nov 2020 12:39:53 -0400
Date:   Fri, 6 Nov 2020 12:39:53 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Xiong, Jianxin" <jianxin.xiong@intel.com>
Cc:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian Koenig <christian.koenig@amd.com>,
        "Vetter, Daniel" <daniel.vetter@intel.com>
Subject: Re: [PATCH v8 1/5] RDMA/umem: Support importing dma-buf as user
 memory region
Message-ID: <20201106163953.GR36674@ziepe.ca>
References: <1604616489-69267-1-git-send-email-jianxin.xiong@intel.com>
 <1604616489-69267-2-git-send-email-jianxin.xiong@intel.com>
 <20201106000851.GK36674@ziepe.ca>
 <MW3PR11MB45552DC0851F4490B2450EDFE5ED0@MW3PR11MB4555.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW3PR11MB45552DC0851F4490B2450EDFE5ED0@MW3PR11MB4555.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Nov 06, 2020 at 04:34:07PM +0000, Xiong, Jianxin wrote:

> > The user could specify a length that is beyond the dma buf, can
> > the dma buf length be checked during get?
> 
> In order to check the length, the buffer needs to be mapped. That can be done.

Do DMA bufs even have definitate immutable lengths? Going to be a
probelm if they can shrink

> > Also page_size can be 0 because iova is not OK. iova should be
> > checked for alignment during get as well:
> > 
> >   iova & (PAGE_SIZE-1) == umem->addr & (PAGE_SIZE-1)
> 
> If ib_umem_dmabuf_map_pages is called during get this error is automatically caught.

The ib_umem_find_best_pgsz() checks this equation, yes.

So you'd map the sgl before allocating the mkey? This then checks the
length and iova?

Jason
