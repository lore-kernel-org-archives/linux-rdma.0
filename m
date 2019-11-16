Return-Path: <SRS0=zL3b=ZI=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11768C432C0
	for <linux-rdma@archiver.kernel.org>; Sat, 16 Nov 2019 21:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDFB520729
	for <linux-rdma@archiver.kernel.org>; Sat, 16 Nov 2019 21:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfKPVK7 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 16 Nov 2019 16:10:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53888 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfKPVK7 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 16 Nov 2019 16:10:59 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8FE22151A2092;
        Sat, 16 Nov 2019 13:10:58 -0800 (PST)
Date:   Sat, 16 Nov 2019 13:10:58 -0800 (PST)
Message-Id: <20191116.131058.1856199123293908506.davem@davemloft.net>
To:     lrizzo@google.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, tariqt@mellanox.com
Subject: Re: [PATCH] net/mlx4_en: fix mlx4 ethtool -N insertion
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191115201225.92888-1-lrizzo@google.com>
References: <20191115201225.92888-1-lrizzo@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 13:10:58 -0800 (PST)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Luigi Rizzo <lrizzo@google.com>
Date: Fri, 15 Nov 2019 12:12:25 -0800

> ethtool expects ETHTOOL_GRXCLSRLALL to set ethtool_rxnfc->data with the
> total number of entries in the rx classifier table.  Surprisingly, mlx4
> is missing this part (in principle ethtool could still move forward and
> try the insert).
> 
> Tested: compiled and run command:
> 	phh13:~# ethtool -N eth1 flow-type udp4  queue 4
> 	Added rule with ID 255
> 
> Signed-off-by: Luigi Rizzo <lrizzo@google.com>
> Change-Id: I18a72f08dfcfb6b9f6aa80fbc12d58553e1fda76

Luigi, _always_ CC: the appropriate maintainer when making changes to the
kernel, as per the top-level MAINTAINERS file.

Tariq et al., please review.
