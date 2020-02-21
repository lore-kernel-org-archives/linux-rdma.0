Return-Path: <SRS0=JPT9=4J=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43299C35657
	for <linux-rdma@archiver.kernel.org>; Fri, 21 Feb 2020 13:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 125AA24653
	for <linux-rdma@archiver.kernel.org>; Fri, 21 Feb 2020 13:57:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="CajgZpY7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbgBUN51 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 21 Feb 2020 08:57:27 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38101 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728679AbgBUN5X (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 21 Feb 2020 08:57:23 -0500
Received: by mail-qk1-f193.google.com with SMTP id z19so1854223qkj.5
        for <linux-rdma@vger.kernel.org>; Fri, 21 Feb 2020 05:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1dHCKhpjWcC6yrvQ8dvgZTfnaHP/2iubCvXzY1WdDa8=;
        b=CajgZpY7D5ouXsMMkG6nMuVcOUZP8f2Lr3xPY04yzvepWaZ6dFRePegzqcsbqWs6GU
         X5a91lpeojrZnkyDUgDtGXjFQCZm2bKt1JVyIxgYe3iqVZI8n95m6CiowcIyCPI2Cxuh
         wvjknm0lx54PkI0t/tQ1/cjoMMMrrwel28xRmAVx9c1kTUzk4oAl6XwoqHk4jbwfUnke
         CmZnbsjlt9NyBcqcvY7YBg7aX0JxDlCB2UDtqD8IJcW/d0LEK0jV41OyjVn2p3ioT+Qg
         KHVOyNeb9T1lH4P2GCfdyc8R7FA2rAc4Tve9BCHFuR91e0sbM6eDt6NWXLsaTRaWBZ7o
         zneQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1dHCKhpjWcC6yrvQ8dvgZTfnaHP/2iubCvXzY1WdDa8=;
        b=sbwqcOnivOBXRFnafpjUnwPLqoXxn/aMxV694BqbN7J0aPRvP1XUNbJb9vAGkB/PEd
         MmHKKguMF+eeB4N20DwFLIKvq/8ou6lCRIw2++CL7clsazTLUdQL5PR8CKKI70jW5cvf
         fQgyUami5PNonp87dpCy9XzJX9NTCnG51cVNhOEZh+yiS2L2+/lh4AbdGVENaSkdmjyC
         ce3rNCPVBwG9TTOrqeQCNWX0a8Bpj3pDcoya6et6B5TsTR3KPfvq3sqrxB67eMGwJERT
         S4yGVQOP1TALVCnQlZPGXF9qB7+gRo8p1ZT34THIccG2E8gEdgrV+qQV37HdOcyeWGmN
         WYnQ==
X-Gm-Message-State: APjAAAWGA1Rq1h9JFDJHgzSdPacpxootTYzp41iDOmCiGdE/nvSAUfVB
        JJ9wfxY+iTcZrd6CrmA/Ncjmkw==
X-Google-Smtp-Source: APXvYqx88Mq4w0EqcZ7rke98GLpS+jxPX9uLG89xoFtJ2Z1/b7CbweKlw/GnLZeU2ybB4tNG/acf/g==
X-Received: by 2002:a05:620a:542:: with SMTP id o2mr33618465qko.318.1582293441677;
        Fri, 21 Feb 2020 05:57:21 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id a198sm1542777qkg.41.2020.02.21.05.57.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 21 Feb 2020 05:57:20 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j58nw-0000Uc-HN; Fri, 21 Feb 2020 09:57:20 -0400
Date:   Fri, 21 Feb 2020 09:57:20 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: linux-next: Tree for Jan 30 + 20200206
 (drivers/infiniband/hw/mlx5/)
Message-ID: <20200221135720.GI31668@ziepe.ca>
References: <20200130152852.6056b5d8@canb.auug.org.au>
 <df42492f-a57e-bf71-e7e2-ce4dd7864462@infradead.org>
 <ee5f17b6-3282-2137-7e9d-fa0008f9eeb0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee5f17b6-3282-2137-7e9d-fa0008f9eeb0@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Feb 05, 2020 at 09:31:15PM -0800, Randy Dunlap wrote:
> On 1/30/20 5:47 AM, Randy Dunlap wrote:
> > On 1/29/20 8:28 PM, Stephen Rothwell wrote:
> >> Hi all,
> >>
> >> Please do not add any v5.7 material to your linux-next included
> >> branches until after v5.6-rc1 has been released.
> >>
> >> Changes since 20200129:
> >>
> > 
> > on i386:
> > 
> > ERROR: "__udivdi3" [drivers/infiniband/hw/mlx5/mlx5_ib.ko] undefined!
> > ERROR: "__divdi3" [drivers/infiniband/hw/mlx5/mlx5_ib.ko] undefined!
> > 
> > 
> > Full randconfig file is attached.
> > 
> > 
> 
> I am still seeing this on linux-next of 20200206.

FWIW, I am seeing a lot of messages from infradead users in the gmail
spam filter, and didn't see this email. It looks like DKIM is broken
on ifradead. :(

The udiv issue is fixed up now, thanks

Jason
