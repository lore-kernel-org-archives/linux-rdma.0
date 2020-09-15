Return-Path: <SRS0=Nq8O=CY=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B19FC43461
	for <linux-rdma@archiver.kernel.org>; Tue, 15 Sep 2020 22:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 009FB20B1F
	for <linux-rdma@archiver.kernel.org>; Tue, 15 Sep 2020 22:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgIOWjc (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 15 Sep 2020 18:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727565AbgIOWe4 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 15 Sep 2020 18:34:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFB2C061788;
        Tue, 15 Sep 2020 15:34:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 30E97136A8C1F;
        Tue, 15 Sep 2020 15:18:05 -0700 (PDT)
Date:   Tue, 15 Sep 2020 15:34:49 -0700 (PDT)
Message-Id: <20200915.153449.1384323730053933155.davem@davemloft.net>
To:     oded.gabbay@gmail.com
Cc:     kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, SW_Drivers@habana.ai,
        gregkh@linuxfoundation.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAFCwf10+_hQOSH4Ot+keE9Tc+ybupvp5JyUhFbvfoy6HseVyZg@mail.gmail.com>
References: <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
        <20200915140418.4afbc1eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAFCwf10+_hQOSH4Ot+keE9Tc+ybupvp5JyUhFbvfoy6HseVyZg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 15 Sep 2020 15:18:05 -0700 (PDT)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Oded Gabbay <oded.gabbay@gmail.com>
Date: Wed, 16 Sep 2020 00:20:12 +0300

> I completely understand but you didn't answer my question. How come
> there are drivers which create netdev objects, and specifically sgi-xp
> in misc (but I also saw it in usb drivers) that live outside
> drivers/net ? Why doesn't your request apply to them as well ?

Don't use examples of drivers doing the wrong thing as an excuse for
you to repeat the mistake.

Ok?

That kind of argument doesn't work here.
