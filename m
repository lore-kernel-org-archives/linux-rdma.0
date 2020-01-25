Return-Path: <SRS0=BhuY=3O=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B5BC35241
	for <linux-rdma@archiver.kernel.org>; Sat, 25 Jan 2020 09:13:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A9F42071A
	for <linux-rdma@archiver.kernel.org>; Sat, 25 Jan 2020 09:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgAYJNO (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 25 Jan 2020 04:13:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48722 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgAYJNO (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 25 Jan 2020 04:13:14 -0500
Received: from localhost (unknown [147.229.117.36])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AEDF115A1AF33;
        Sat, 25 Jan 2020 01:13:12 -0800 (PST)
Date:   Sat, 25 Jan 2020 10:13:11 +0100 (CET)
Message-Id: <20200125.101311.1924780619716720495.davem@davemloft.net>
To:     leon@kernel.org
Cc:     kuba@kernel.org, leonro@mellanox.com, michal.kalderon@marvell.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200123130541.30473-1-leon@kernel.org>
References: <20200123130541.30473-1-leon@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Jan 2020 01:13:14 -0800 (PST)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Thu, 23 Jan 2020 15:05:41 +0200

> From: Leon Romanovsky <leonro@mellanox.com>
> 
> In order to stop useless driver version bumps and unify output
> presented by ethtool -i, let's overwrite the version string.
> 
> Before this change:
> [leonro@erver ~]$ ethtool -i eth0
> driver: virtio_net
> version: 1.0.0
> After this change:
> [leonro@server ~]$ ethtool -i eth0
> driver: virtio_net
> version: 5.5.0-rc6+
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Please respin on current net-next, thank you :)
