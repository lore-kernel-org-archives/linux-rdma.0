Return-Path: <SRS0=3BW3=YQ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78DCDCA9EB9
	for <linux-rdma@archiver.kernel.org>; Wed, 23 Oct 2019 19:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44D002086D
	for <linux-rdma@archiver.kernel.org>; Wed, 23 Oct 2019 19:09:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Ltd8wuPx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731822AbfJWTJf (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 23 Oct 2019 15:09:35 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42181 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731267AbfJWTJf (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 23 Oct 2019 15:09:35 -0400
Received: by mail-qk1-f196.google.com with SMTP id m4so3980184qke.9
        for <linux-rdma@vger.kernel.org>; Wed, 23 Oct 2019 12:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hbYknmQKutx5eVV9wjJYmszxal9l6dIeQEjgmlvcQ3o=;
        b=Ltd8wuPxBy5li7B+rrO7LTgr7dZwz3acYU+jSZloisMfT2gpxmE04nE5o8nRttFdRu
         yb567EeizxACVmCag1LjLNodxXJ7lyowJnnOd/F+xoxQtGUYEK0gTrdJKa9B6/emyh0l
         khBU5saCAX7tfNhtY63hlQQnEGC3V5W/jDuZC8+gJWUhqTTyIb1l//DLThOLZxdQpdZY
         9MOyACCLh/GHhKPGbzRqo/pRUn9PL+nnWw7YcOQS4b8kAG6apHTuzTG9RVuNsEhbpRsD
         JY8q0GHO6giHDuesYETv3N5KloZSwIDiQMtUxC56JsO57y6lHEndDF8y66uDLsdXgOzk
         Xjag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hbYknmQKutx5eVV9wjJYmszxal9l6dIeQEjgmlvcQ3o=;
        b=BknrGLOgzNP9/QxRHEX7VW182hBEl++KV9+LNxwFaM6zxjtsYL1r4EHq+czNbkLmmv
         oXoyTsJ3j4VuOcD2Rr6pMIuydAPVRibdB8nRVwRZ4AnkQPwZlAWmVO5w9Ci6xHBr0dk1
         ulKkcNK8qkNmy6rW2NQD8X0owM/buG/vEUUTOQXGZtP8YBqfXZIjSlfzCw3FlwiyR8NY
         FWaw4o6neB+T2KUGXnJZZpDMmdtzuHdkkK+41eDX53m3kWOcHTsQoyC/9Y8lofG2oZlU
         XXHf2J8dCEBakRh6EvsuLTxspUWJb82pbiH7gVtiEW/Wu2qZ0l1HFcHWXd9gp629jy8G
         hI3g==
X-Gm-Message-State: APjAAAUD9w186mUo+AQC2yB5SfsAa87CpiBBQQBigoc099ZfB5dsM1fk
        FfgyZtx5ixt6QVcIozj94WOQdg==
X-Google-Smtp-Source: APXvYqzES43rYEnyTM8Ycsh/WVJ/xmuVvnsiYb+QM8awdzgAnXDyIPTmBbtrn64IkQazV+LWDzREMQ==
X-Received: by 2002:a37:5784:: with SMTP id l126mr3305013qkb.373.1571857774345;
        Wed, 23 Oct 2019 12:09:34 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id k199sm10893969qke.0.2019.10.23.12.09.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 23 Oct 2019 12:09:33 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iNM0j-0001Ge-4n; Wed, 23 Oct 2019 16:09:33 -0300
Date:   Wed, 23 Oct 2019 16:09:33 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH rdma-next v1 0/2] Remove PID namespaces support from
 restrack
Message-ID: <20191023190933.GA4836@ziepe.ca>
References: <20191010071105.25538-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010071105.25538-1-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Oct 10, 2019 at 10:11:03AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Changelog
>  v0 -> v1: https://lore.kernel.org/linux-rdma/20191002123245.18153-1-leon@kernel.org
>  * Beatify code as Parav suggested (patch #2)
> 
> Hi,
> 
> Please see individual commit messages for more details.
> 
> Thanks
> 
> Leon Romanovsky (2):
>   RDMA/restrack: Remove PID namespace support
>   RDMA/core: Check that process is still alive before sending it to the
>     users

Applied to for-next, thanks

Jason
