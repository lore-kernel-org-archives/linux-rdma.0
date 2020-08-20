Return-Path: <SRS0=u/e5=B6=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A4FC433E1
	for <linux-rdma@archiver.kernel.org>; Thu, 20 Aug 2020 14:11:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDD6420724
	for <linux-rdma@archiver.kernel.org>; Thu, 20 Aug 2020 14:11:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mP+zr7hQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbgHTOLq (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 20 Aug 2020 10:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728923AbgHTNxo (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 20 Aug 2020 09:53:44 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3693C061385
        for <linux-rdma@vger.kernel.org>; Thu, 20 Aug 2020 06:53:43 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f7so2139580wrw.1
        for <linux-rdma@vger.kernel.org>; Thu, 20 Aug 2020 06:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qFIRJUobRMxVRLMpP1kU+I58VxFX/YI0iGkLOoQTM2Q=;
        b=mP+zr7hQBzzJpVYpkCprnYdgV4apjFbwQ8cKXAGQe2Jq1WktDWmrZFrSbA6+FQefka
         ozRkimED6G9eaDVo4aSPuQutnynHb1NuBz4VS02+W1tphhNbY+Cp+Er6ID6UnO1VRVcT
         5V2xCbaztNK21Q7K0UUnTwwIrqUdXr2zziVo17tj3NQVVLq3/vUHYy30/kRyOKvyh09A
         qFSNZTfyBil2k+tdhU00R9/mAWdMuJXe9aMETHKQSsmVeqXGo3z5Mw+9KiHCFLAj9/OE
         2P3B7hFGsETCcZaU+eeqXSR35a8OqExxOpbXTmj89jNyKB/CCJwuPKyPZdAqp6qLl2/c
         cEkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qFIRJUobRMxVRLMpP1kU+I58VxFX/YI0iGkLOoQTM2Q=;
        b=COhbChortcj82sn67VdDwmW8phH94BjvBe5iXNgGDbZ+B8qhmjjPgmzU1mpoHGISxx
         XwIugRcU+886kgeqGQOQ9HHp1SBbwibN7Xu8hV/Kjeqs5b23oPfxZD/BI1SFgCl25zo0
         32XrzyzmTnjrnw+UO6e8rvIOGZOqvgk+Ny4pK1ki9rUF4gdpCAHK161QFcXz1wrv9hFP
         qXgq6YPsheey96d2/4Hh6YZamcHw6IHMZvA6KY8Zmifzh6aTp2xTZO3wmJUXutrte9vq
         X/11k5OdN3WC+5kShAiiBzMLDWyBu2WV5A+pAQLeiBV0vAciENpREY8l2HSLvVDzB5dX
         wsgg==
X-Gm-Message-State: AOAM530K4StU7TJLIWylLoF1SlDQp8nRmsgrf9dwieasoT+xNoNz115S
        yxBdI5xUbHKHr6+8+Qko0ro=
X-Google-Smtp-Source: ABdhPJz+y/Qx6bWlUHeRWdQwASd5TWC1Jug1fG9vOw1Uuh8nWpYM+/KEDWqrHCBDBGiuCML/b64FjQ==
X-Received: by 2002:adf:f151:: with SMTP id y17mr3552594wro.179.1597931622014;
        Thu, 20 Aug 2020 06:53:42 -0700 (PDT)
Received: from kheib-workstation ([37.142.0.228])
        by smtp.gmail.com with ESMTPSA id v7sm4098440wmj.28.2020.08.20.06.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 06:53:41 -0700 (PDT)
Date:   Thu, 20 Aug 2020 16:53:38 +0300
From:   Kamal Heib <kamalheib1@gmail.com>
To:     Gal Pressman <galpress@amazon.com>
Cc:     linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Benvenuti <benve@cisco.com>
Subject: Re: [PATCH for-next] RDMA/usnic: Remove the query_pkey callback
Message-ID: <20200820135338.GA114615@kheib-workstation>
References: <20200820125346.111902-1-kamalheib1@gmail.com>
 <efb8ce2b-fb37-2950-36fd-fb45b845632a@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efb8ce2b-fb37-2950-36fd-fb45b845632a@amazon.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Aug 20, 2020 at 04:11:23PM +0300, Gal Pressman wrote:
> On 20/08/2020 15:53, Kamal Heib wrote:
> > Now that the query_pkey() isn't mandatory by the RDMA core, this
> > callback can be removed from the usnic provider.
> 
> Not directly related to this patch, but pyverbs has a test which verifies that
> max_pkeys > 0, maybe this check should be removed.

Or changed to work only for node_type == e.IBV_NODE_CA?

Thanks,
Kamal
