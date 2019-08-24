Return-Path: <SRS0=JUPT=WU=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB405C3A59E
	for <linux-rdma@archiver.kernel.org>; Sat, 24 Aug 2019 23:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96D5D2173E
	for <linux-rdma@archiver.kernel.org>; Sat, 24 Aug 2019 23:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbfHXX6w (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 24 Aug 2019 19:58:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48732 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728243AbfHXX6w (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 24 Aug 2019 19:58:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0797A152621F3;
        Sat, 24 Aug 2019 16:58:51 -0700 (PDT)
Date:   Sat, 24 Aug 2019 16:58:51 -0700 (PDT)
Message-Id: <20190824.165851.1817456673626840850.davem@davemloft.net>
To:     yanjun.zhu@oracle.com
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        gerd.rausch@oracle.com
Subject: Re: [PATCHv2 1/1] net: rds: add service level support in rds-info
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566608656-30836-1-git-send-email-yanjun.zhu@oracle.com>
References: <1566608656-30836-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 16:58:52 -0700 (PDT)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>
Date: Fri, 23 Aug 2019 21:04:16 -0400

> diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
> index fd6b5f6..cba368e 100644
> --- a/include/uapi/linux/rds.h
> +++ b/include/uapi/linux/rds.h
> @@ -250,6 +250,7 @@ struct rds_info_rdma_connection {
>  	__u32		rdma_mr_max;
>  	__u32		rdma_mr_size;
>  	__u8		tos;
> +	__u8		sl;
>  	__u32		cache_allocs;
>  };

I'm applying this, but I am once again severely disappointed in how
RDS development is being handled.

From the Fixes: commit:

	Since rds.h in rds-tools is not related with the kernel rds.h,
	the change in kernel rds.h does not affect rds-tools.

This is the height of arrogance and shows a lack of understanding of
what user ABI requirements are all about.

It is possible for other userland components to be built by other
people, outside of your controlled eco-system and tools, that use
these interfaces.

And you cannot control that.

Therefore you cannot make arbitrary changes to UABI data strucures
just because the tool you use and maintain is not effected by it.

Please stop making these incredibly incompatible user interface
changes in the RDS stack.

I am, from this point forward, going to be extra strict on RDS stack
changes especially in this area.

