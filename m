Return-Path: <SRS0=LdXM=74=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98925C433E0
	for <linux-rdma@archiver.kernel.org>; Mon, 15 Jun 2020 18:53:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BA2620768
	for <linux-rdma@archiver.kernel.org>; Mon, 15 Jun 2020 18:53:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="bKs8NVLr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730976AbgFOSxJ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 15 Jun 2020 14:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729124AbgFOSxI (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 15 Jun 2020 14:53:08 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688A3C061A0E
        for <linux-rdma@vger.kernel.org>; Mon, 15 Jun 2020 11:53:07 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id y1so13471518qtv.12
        for <linux-rdma@vger.kernel.org>; Mon, 15 Jun 2020 11:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ayg2PAVSdmz/HOuWjmsjRtknRgEi2PoT2Jiq5tkLESY=;
        b=bKs8NVLrmAgH/ZaYWHDU+EKGek1aWcrqpXD0PlUZpXQALE6CFs6rGcHU/BVssPF5Ve
         okM8Gz/G0JL3WnQWVXNqLEIY17Y5crhX2oTRyvfVde1jXzE4yrM//m15FcZfuo9npSYL
         PDDJV5yEM1b7ZdgyUCI4CVm49beS1WgsONfgobvkIeEzWLbyMSSxF/8sAu3iVBHPIT0R
         ntYH0uftulq51nj34p5oJYHWgtB0XC8YEAWaBJzbkDW3uxVGZ5aQbCE1YcCT/7wY2I4N
         efyp7jjSBCdGk5SThCaZ2Cs5EuHYbQbaYbDc4XE9+/Ktz1dDMt+sknTQTAY047Bltgzu
         hg0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ayg2PAVSdmz/HOuWjmsjRtknRgEi2PoT2Jiq5tkLESY=;
        b=EKtg4R1TZP/4AXbHcncH50gIYUb3QC90rRFbiAcEpoHlz75ahY9+w1E9NW4PERkTHN
         jwTN73PUDJMYiWJj+nM+h6p2XXPkjZk/2lp00F3iguRlLOm2KHEdwEk89w6H0irnsv66
         +Hqjl90rPHKauwmNzhm8qlMgyOAEvQV1aBGbQV2QAPwFDD+oTLaAqy+eZK4zhqxPZAzw
         QoGGTct/r5ThCWOwvkzuyTPupA0Ef+4I96RGP3H63WG3GxhOyJu98a0rqkf8itr2BXGu
         7ENE+Y1TqjrgaLlO4SoYdosgD3QNe7sZ7+nnWf+LKigyp3EKsJfAUgfF0ESYyf5CGC2F
         K0cg==
X-Gm-Message-State: AOAM531bHGCkmAvWmiUIaBG6WOy2bSPLEQjX3snUR5qBE29MCTYRq5Dh
        +xrBrjepnpQOQ/F0Op0bcLpzmQ==
X-Google-Smtp-Source: ABdhPJy0NxdkqsFdIXa7ZqslMtxjBjlZ0/L3TKNg3Afl/Ryuh1tnaF0jOJ4s1/e/43z3m5P4tpQpCg==
X-Received: by 2002:aed:3e8f:: with SMTP id n15mr17265955qtf.147.1592247185959;
        Mon, 15 Jun 2020 11:53:05 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id b74sm11341305qkc.17.2020.06.15.11.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 11:53:05 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.93)
        (envelope-from <jgg@ziepe.ca>)
        id 1jkuEC-008j2a-Du; Mon, 15 Jun 2020 15:53:04 -0300
Date:   Mon, 15 Jun 2020 15:53:04 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Tom Seewald <tseewald@gmail.com>
Cc:     linux-rdma@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] [next] RDMA/mlx5: Fix -Wformat warning in
 check_ucmd_data()
Message-ID: <20200615185304.GA2079722@ziepe.ca>
References: <20200605023012.9527-1-tseewald@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605023012.9527-1-tseewald@gmail.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Jun 04, 2020 at 09:30:12PM -0500, Tom Seewald wrote:
> Variables of type size_t should use %zu rather than %lu [1]. The variables
> "inlen", "ucmd", "last", and "size" are all size_t, so use the correct
> format specifiers.
> 
> [1] https://www.kernel.org/doc/html/latest/core-api/printk-formats.html
> 
> Signed-off-by: Tom Seewald <tseewald@gmail.com>
> Acked-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/qp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to for-rc with a Fixes line

Thanks,
Jason
