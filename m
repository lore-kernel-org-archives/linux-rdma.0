Return-Path: <SRS0=p0Sv=32=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65DBCC352A2
	for <linux-rdma@archiver.kernel.org>; Thu,  6 Feb 2020 05:31:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D35521741
	for <linux-rdma@archiver.kernel.org>; Thu,  6 Feb 2020 05:31:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZmFkwf9v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgBFFbQ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 6 Feb 2020 00:31:16 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:60442 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgBFFbQ (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 6 Feb 2020 00:31:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=RBQoDLMywo6ZPEAl8CBlh/tMYQhZMecgrZIYhakr09k=; b=ZmFkwf9v5Lil9IiLhcNMS8LPhs
        fFR75unRVppEH9r2WxfP68jhAF8yuAqNmJh1AtwM2i+9fXFILXj0sYFp0heKvAVty7wCi66r2ER2w
        los3t8x6oU4cvc4cxRkGwpPER07F1xFYoYGyNDnYtrb7cqrIOpi9hmbZhnFxchK62BBa55ROtmdVJ
        3Z0JtaN5nFrOvcT0v40cfCrAVIEDeDIUtsMyxCtbsdEs6Nq3bW+75z8avjhUG05Nk4LZ7lufEkF2F
        +aXZYosfq9+2xjF4K+A1eAD+ONgQeHsOvmUttwwXVGEIFJSyM+vw3itmpo859JyQI1OoGgTJGc1qi
        tQS0QpKg==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1izZkx-0002L5-Qf; Thu, 06 Feb 2020 05:31:15 +0000
Subject: Re: linux-next: Tree for Jan 30 + 20200206
 (drivers/infiniband/hw/mlx5/)
From:   Randy Dunlap <rdunlap@infradead.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
References: <20200130152852.6056b5d8@canb.auug.org.au>
 <df42492f-a57e-bf71-e7e2-ce4dd7864462@infradead.org>
Message-ID: <ee5f17b6-3282-2137-7e9d-fa0008f9eeb0@infradead.org>
Date:   Wed, 5 Feb 2020 21:31:15 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <df42492f-a57e-bf71-e7e2-ce4dd7864462@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 1/30/20 5:47 AM, Randy Dunlap wrote:
> On 1/29/20 8:28 PM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Please do not add any v5.7 material to your linux-next included
>> branches until after v5.6-rc1 has been released.
>>
>> Changes since 20200129:
>>
> 
> on i386:
> 
> ERROR: "__udivdi3" [drivers/infiniband/hw/mlx5/mlx5_ib.ko] undefined!
> ERROR: "__divdi3" [drivers/infiniband/hw/mlx5/mlx5_ib.ko] undefined!
> 
> 
> Full randconfig file is attached.
> 
> 

I am still seeing this on linux-next of 20200206.

-- 
~Randy

