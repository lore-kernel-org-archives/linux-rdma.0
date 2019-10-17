Return-Path: <SRS0=eF5f=YK=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 184A4ECE58E
	for <linux-rdma@archiver.kernel.org>; Thu, 17 Oct 2019 19:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E59A820869
	for <linux-rdma@archiver.kernel.org>; Thu, 17 Oct 2019 19:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407122AbfJQTYQ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:24:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40864 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407055AbfJQTYQ (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 17 Oct 2019 15:24:16 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5273814047D0B;
        Thu, 17 Oct 2019 12:24:15 -0700 (PDT)
Date:   Thu, 17 Oct 2019 15:24:14 -0400 (EDT)
Message-Id: <20191017.152414.1062784675771205824.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/rds: Remove unnecessary null check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191015114736.16928-1-yuehaibing@huawei.com>
References: <20191015114736.16928-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 12:24:15 -0700 (PDT)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Tue, 15 Oct 2019 19:47:36 +0800

> Null check before dma_pool_destroy is redundant, so remove it.
> This is detected by coccinelle.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
