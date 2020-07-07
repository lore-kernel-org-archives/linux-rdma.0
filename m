Return-Path: <SRS0=ppJa=AS=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C1E5C433E0
	for <linux-rdma@archiver.kernel.org>; Tue,  7 Jul 2020 19:13:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED7D6206E9
	for <linux-rdma@archiver.kernel.org>; Tue,  7 Jul 2020 19:13:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JvaE2sID"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgGGTN3 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 7 Jul 2020 15:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728216AbgGGTN3 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 7 Jul 2020 15:13:29 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78E5C061755
        for <linux-rdma@vger.kernel.org>; Tue,  7 Jul 2020 12:13:28 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a6so46425199wrm.4
        for <linux-rdma@vger.kernel.org>; Tue, 07 Jul 2020 12:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HC7w1qAywAbhIWUjiJ/1PfEAx7bB+LrhKLDm+w4+h14=;
        b=JvaE2sID2ESWE2d7tNPrbvhIf8c8+DSxi07y/C/fVvukwBzX2c61e2d4hX3Of5A+u6
         tA6RW79zuS5/oyDqUHYvEGbcPAtnX9Hpejdvc/W7zRuu9C3NxvG+os8PvAlzI+GuAhqk
         wIsXyPjKSgw0BXaF3e9uMgFQ9WZVejROWcJOjO8G5gSyvAF1ycgZq6zhoySFCeI5juG0
         ziyz2/T3WCgsm8dVH0M5axMnZyw3KoCuQ4I/RryJUvxkGnNGI1rbTEKYxXycZa1xfECO
         My3fNeg/lyGbaPrVEH3sVWmc3y29jgHaudPJxczv0Lo9jbmkN6/s821uqC6E58lPw7JB
         9c3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HC7w1qAywAbhIWUjiJ/1PfEAx7bB+LrhKLDm+w4+h14=;
        b=W27ndgWmO5Mj0Net/4Hsr9LyUFUb2VLN8QM9kpnckbbl1O/t80+Y42E2/Z4n5XjQ1D
         YTtzf0BhFSNj0PjfzbZYkF6/D8O1iezhrCmItFxv6jH/YTVlprtI1T+6Y6A8rMbf5tF1
         oHpLbJBFdY1ZSDj+KC61XgBfgEqvCfx9VXq3z32sO6cxGVzUhZplYevKbhCiQxboNTXs
         0W44KuUGhDMZGvepHNtG68Ql6BT/K2/2DXFnPg/fy8Enr+H7jVd0LHMcCrTjYoauiqSc
         1XgTveFAy9/nsgMfUAK8N3UAr7Nezw/3hezDhFMAmn3gcfG5pdDDQG5vMbrS5UIKNWgB
         J0eQ==
X-Gm-Message-State: AOAM531O0I2l9+xUPgSBnE3M+vShJWqUrq5eLg8mtsBoV99ufZZDSZu0
        uldIEDPqIksB7/nLIJE92bQ=
X-Google-Smtp-Source: ABdhPJyalpRf2UJYPz6dmnB2sXFM4uAadeGnhqfaMw5Yd6YbmG5uCvXiiH7ru/KtoqGicOgI4IC1Fw==
X-Received: by 2002:adf:e701:: with SMTP id c1mr56519949wrm.350.1594149207537;
        Tue, 07 Jul 2020 12:13:27 -0700 (PDT)
Received: from kheib-workstation ([37.142.6.100])
        by smtp.gmail.com with ESMTPSA id u74sm2227827wmu.31.2020.07.07.12.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 12:13:26 -0700 (PDT)
Date:   Tue, 7 Jul 2020 22:13:24 +0300
From:   Kamal Heib <kamalheib1@gmail.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH for-rc v1 0/4] RDMA/providers: Set max_pkey attribute
Message-ID: <20200707191324.GA463589@kheib-workstation>
References: <20200706091119.367697-1-kamalheib1@gmail.com>
 <20200707161247.GA1375440@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707161247.GA1375440@nvidia.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Jul 07, 2020 at 01:12:47PM -0300, Jason Gunthorpe wrote:
> On Mon, Jul 06, 2020 at 12:11:15PM +0300, Kamal Heib wrote:
> > This patch set makes sure to set the max_pkeys attribute to the providers
> > that aren't setting it or not setting it correctly.
> > 
> > v1: Drop the efa patch and target for-rc.
> > 
> > Kamal Heib (4):
> >   RDMA/siw: Set max_pkeys attribute
> >   RDMA/cxgb4: Set max_pkeys attribute
> >   RDMA/i40iw: Set max_pkeys attribute
> >   RDMA/usnic: Fix reported max_pkeys attribute
> 
> Why should iwarp have a 1 pkey value?
> 
> Jason

That is a good question :-)

My Idea in this patchset was to match between the reported pkey_tbl_len and
the max_pkeys attribute that the providers expose.

But after taking a deeper look now, I see that the RDMA core requires
from all providers to implement the query_pkey() callback, which before
[1] commit that will cause the provider driver not to load. For IB
providers the requirement make sense, also for RoCE providers, because
there is a requirement by the RoCE Spec to support the default PKey, For
iwarp providers, This doesn't make sense and I think that they decided to
do the same as RoCE and to avoid the driver load failure.

Probably, The requirement from the RDMA core needs to be changed and
the query_pkey() callback needs to be removed from the iwarp providers,
Thoughts?

------>8------
git grep -n IB_MANDATORY_FUNC drivers/infiniband/ | grep pkey
drivers/infiniband/core/device.c:275:		IB_MANDATORY_FUNC(query_pkey),
------>8------

[1] - 6780c4fa9d6e ("RDMA: Add indication for in kernel API support to IB device")

Thanks,
Kamal
