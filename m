Return-Path: <SRS0=tt2b=BD=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 265D8C433E1
	for <linux-rdma@archiver.kernel.org>; Fri, 24 Jul 2020 14:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3C8B21883
	for <linux-rdma@archiver.kernel.org>; Fri, 24 Jul 2020 14:18:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="CbVcBajo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgGXOSr (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 24 Jul 2020 10:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgGXOSr (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 24 Jul 2020 10:18:47 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07316C0619D3
        for <linux-rdma@vger.kernel.org>; Fri, 24 Jul 2020 07:18:47 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id l17so9930694iok.7
        for <linux-rdma@vger.kernel.org>; Fri, 24 Jul 2020 07:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=97Eau43xA83rlvFNofyvOIXATD23u4GkUBeWbIi3frM=;
        b=CbVcBajoW5NC1gRhXLGuo4cbkocuJAcx6sbTAYsD9zO0iKlvfdGgMrX09AZY3u4pbT
         FxxkoAKPDQ7EIxnNKk8bGNQSRLdYdGLhgaYsa49ENEDnmTx6WIza4rVSB/prfADOhKJl
         35egjCCLr/I5haRObW5eYPT+1NVuOZLCb40V/wBN4zWefIZmkXx5ASrmh2lsniKV0yct
         Lfb1g2T92CZySnXZAUSyTiIh2U7qxWi7pGv55jF4G8Q696U7GG6/r5P8BeehJhTH2t2F
         eQO5NXhCxQ/AVssZmqqpCdS2DvzE8z1NpJgGWmZ3FKOnvvDvCDgKjAEErc6nJ7no5nTJ
         q7Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=97Eau43xA83rlvFNofyvOIXATD23u4GkUBeWbIi3frM=;
        b=IByl7DMSS7MZUwfWDEkacm7H6LXAK1VTqH/vafL9rp59LwulGnujRR2eobOzj2W2y7
         Gn1DGaihjXANKsExYLn2DGyDfBRSQ4jvoFzGASisN2DBsMFOeqOYtWCfakxgSQU6j4eX
         O/ypeDCEys0LgqDQ7jx53hA3nUhaCuFcA7FEkI7vd7uJRTMezxvChJm6FDsFZlgCqQpq
         HQp89yu2/WRboUppqNfqXnSes8pzfDI5lGYmmNl3bhijlOzicM+1GOHvLyWBcZjJ6JSY
         E/lN0zZWkKDYBSkyAgI2P+BbRNJpIiinsfjlbz1IfK5eCLuiI+B1OOLUvzcapYUJ3sQy
         usJQ==
X-Gm-Message-State: AOAM532J7Mx9JOTLUcPDgk1W3e59Du/YwpiXU5e+uLZagp7CYk9fUc+E
        2AkTXOuMaUL3A9qqzV8gC16mgA==
X-Google-Smtp-Source: ABdhPJx1NqHOd+CL2UZG4FKWDIBoKooU3hYZM4+wB1xhrb/6gSFPYasbisTr+FpcneUtQBeZZHF4xA==
X-Received: by 2002:a5d:8510:: with SMTP id q16mr10604066ion.81.1595600326357;
        Fri, 24 Jul 2020 07:18:46 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id p9sm3327999ilc.78.2020.07.24.07.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 07:18:45 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1jyyX6-00F4mp-J6; Fri, 24 Jul 2020 11:18:44 -0300
Date:   Fri, 24 Jul 2020 11:18:44 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     =?utf-8?B?5p2o5biG?= <yangfan.fan@bytedance.com>
Cc:     Zhu Yanjun <zyjzyj2000@gmail.com>,
        Zhu Yanjun <yanjunz@mellanox.com>, linux-rdma@vger.kernel.org
Subject: Re: [External] [PATCH] RDMA/rxe: fix retry forever when rnr_retry >=
 7
Message-ID: <20200724141844.GO25301@ziepe.ca>
References: <D1A472F9-6618-41A2-9CA8-B5231BD03D63@bytedance.com>
 <CAD=hENdG_0hdcRQk+sH6HyuOROM-U9_n2QahipgmOdESQDso3g@mail.gmail.com>
 <827596D2-8EB2-4660-9118-70289FCD09AA@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <827596D2-8EB2-4660-9118-70289FCD09AA@bytedance.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Jul 24, 2020 at 10:04:01PM +0800, 杨帆 wrote:
> > 
> > Please read the following from IB specification
> > 
> 
> Oh I see, I missed that part.  Thanks for your explanation.
> 
> 
> > An exception to
> > the following is if the RNR NAK retry counter is set to 7. This value indicates
> > infinite retry and the counter is not decremented.
> 
> I wonder what if the user set RNR retry larger than 7?  Say the user set the RNR
> retry attribute to 10, is he expecting a 10-time retry or an infinite retry?  In
> the current implementation, any larger-than-7 retry count causes infinite retry.
> Is this an expected behavior?

Out of range values should be rejected at modify_qp time

Jason
