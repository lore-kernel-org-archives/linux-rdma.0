Return-Path: <SRS0=BP9/=VO=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E002BC7618F
	for <linux-rdma@archiver.kernel.org>; Wed, 17 Jul 2019 19:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3077217F4
	for <linux-rdma@archiver.kernel.org>; Wed, 17 Jul 2019 19:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfGQTHn (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 17 Jul 2019 15:07:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40980 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfGQTHm (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 17 Jul 2019 15:07:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6107E1475DF83;
        Wed, 17 Jul 2019 12:07:42 -0700 (PDT)
Date:   Wed, 17 Jul 2019 12:07:41 -0700 (PDT)
Message-Id: <20190717.120741.630658660591662244.davem@davemloft.net>
To:     gerd.rausch@oracle.com
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: Re: [PATCH net v3 0/7] net/rds: RDMA fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3fd6ddd1-97e2-2c64-1772-b689eb3ee7ba@oracle.com>
References: <3fd6ddd1-97e2-2c64-1772-b689eb3ee7ba@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 17 Jul 2019 12:07:42 -0700 (PDT)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Gerd Rausch <gerd.rausch@oracle.com>
Date: Tue, 16 Jul 2019 15:28:43 -0700

> A number of net/rds fixes necessary to make "rds_rdma.ko"
> pass some basic Oracle internal tests.

Series applied.
