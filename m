Return-Path: <SRS0=gJYK=45=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 340C4C4CECE
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Mar 2020 08:03:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1779120650
	for <linux-rdma@archiver.kernel.org>; Thu, 12 Mar 2020 08:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388111AbgCLIDr (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 12 Mar 2020 04:03:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57144 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388171AbgCLIDr (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 12 Mar 2020 04:03:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6ACB214FAFC4B;
        Thu, 12 Mar 2020 01:03:46 -0700 (PDT)
Date:   Thu, 12 Mar 2020 01:03:43 -0700 (PDT)
Message-Id: <20200312.010343.473039511562341234.davem@davemloft.net>
To:     joe@perches.com
Cc:     borisp@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 001/491] MELLANOX ETHERNET INNOVA DRIVERS: Use
 fallthrough;
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cf74e8fdd3ee99aec86cec4abfdb1ce84b7fd90a.camel@perches.com>
References: <605f5d4954fcb254fe6fc5c22dc707f29b3b7405.1583896347.git.joe@perches.com>
        <20200311.232302.1442236068172575398.davem@davemloft.net>
        <cf74e8fdd3ee99aec86cec4abfdb1ce84b7fd90a.camel@perches.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 01:03:46 -0700 (PDT)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 11 Mar 2020 23:26:59 -0700

> I'm not going to hand-edit 500 patches.

Then I'm not applying your stuff, it's as simple as that.
