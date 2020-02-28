Return-Path: <SRS0=r0Ci=4Q=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F158C3F2CD
	for <linux-rdma@archiver.kernel.org>; Fri, 28 Feb 2020 16:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5645D24699
	for <linux-rdma@archiver.kernel.org>; Fri, 28 Feb 2020 16:44:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="D2rlkH59"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgB1QoK (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 28 Feb 2020 11:44:10 -0500
Received: from mail-qk1-f173.google.com ([209.85.222.173]:44065 "EHLO
        mail-qk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgB1QoI (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 28 Feb 2020 11:44:08 -0500
Received: by mail-qk1-f173.google.com with SMTP id f140so3518194qke.11
        for <linux-rdma@vger.kernel.org>; Fri, 28 Feb 2020 08:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CCtY0Qacs9wOnWXud8i9ge7LpLEsLeAVVMXg1sWOnyw=;
        b=D2rlkH59BNrsno4OCSGNHcrjEAEc9dr5OL5Qxmrk0mGVZ34lYCzS5cZTjosC6ZnVAT
         3BFQdQ19TdF4h2LaE8zjalI05AhcG72NHec77qPlHBWRH//SFAx+6Y/5MFykyexwMyTo
         5ehmgBUpXVcOXVyQgB5zYxYRnNPB6qnk1vakhcOAqTDTvuXJORKyj4s7iPsaF7Z9mVvs
         OaLgkjs4jNzhJFyKOy3/54RTg4d+xhP9DVLc9uuRZTvbJuwUXwufSD53LmnE6z252pdA
         kwSOVwoTuMXfzH/TqkKMKz3g/PF439oIoM+KPEmqOG89ccSKJctElfIZLiEFLhjwSLFB
         V6KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CCtY0Qacs9wOnWXud8i9ge7LpLEsLeAVVMXg1sWOnyw=;
        b=UOFyLsldML4GtB793lo5SArI5xQ/kqNmxkyTIepQfUWVHL2A459BRhEiXSSyVAfIjm
         Rsq2/cSS2JrN0co0/LXDjYKQ5OjzDme3LKn/8V2eSXqPBptwElbdA1TfE0nl2Ce04Uqa
         bLX3bxNiRO3ds3y/4sdzLl0tEzoRRl0fOJ8Qeu0UmbsCKV0V7AAprZBW5/BGc8aNnbk+
         OtWNAOkHuggKpUmyoY9ODeKTJNaTEuIq6e0MW72XiSpAnpwWvR/15QoxguHBhrZ2vPZm
         VBNGgeUtoTtbtCVZgV8hfXzcbxidND+5LhJQBo/ctxD/HhB8c7q7vCw9WS4E7TvZah6e
         PTZg==
X-Gm-Message-State: APjAAAXYwK//H0Z/NAGIiNLU+pwDQijdq90KLq3bYcmW5WeLtteMnY02
        Zs0qi+Qu2l/xmPhemS/ggT5yFw==
X-Google-Smtp-Source: APXvYqxfCTu7tTgRtENnzEaKttDXe85vEF0rcY8Ey+zJZn71YPOTRBCqwgqrX+uZgpau/Nsyi1/g3A==
X-Received: by 2002:a37:4d10:: with SMTP id a16mr5155052qkb.325.1582908246112;
        Fri, 28 Feb 2020 08:44:06 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id r10sm5110838qkm.23.2020.02.28.08.44.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Feb 2020 08:44:05 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j7ik9-0001sw-BL; Fri, 28 Feb 2020 12:44:05 -0400
Date:   Fri, 28 Feb 2020 12:44:05 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Selvin Xavier <selvin.xavier@broadcom.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] RDMA/bnxt_re: Remove set but not used variables
 'pg' and 'idx'
Message-ID: <20200228164405.GC7181@ziepe.ca>
References: <20200227064900.92255-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227064900.92255-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Feb 27, 2020 at 06:49:00AM +0000, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/infiniband/hw/bnxt_re/qplib_rcfw.c: In function '__send_message':
> drivers/infiniband/hw/bnxt_re/qplib_rcfw.c:101:10: warning:
>  variable 'idx' set but not used [-Wunused-but-set-variable]
> drivers/infiniband/hw/bnxt_re/qplib_rcfw.c:101:6: warning:
>  variable 'pg' set but not used [-Wunused-but-set-variable]
> 
> commit cee0c7bba486 ("RDMA/bnxt_re: Refactor command queue management code")
> involved this, but not used.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 4 ----
>  1 file changed, 4 deletions(-)

Applied to for-next, thanks

Jason
