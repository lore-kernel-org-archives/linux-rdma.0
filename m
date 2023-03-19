Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A8AC6FD1F
	for <linux-rdma@archiver.kernel.org>; Sun, 19 Mar 2023 09:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjCSJCp (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 19 Mar 2023 05:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjCSJCo (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 19 Mar 2023 05:02:44 -0400
Received: from out-11.mta1.migadu.com (out-11.mta1.migadu.com [IPv6:2001:41d0:203:375::b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B7A24736
        for <linux-rdma@vger.kernel.org>; Sun, 19 Mar 2023 02:02:42 -0700 (PDT)
Message-ID: <137f7c3e-7121-f5f0-cbb2-8b27b0ecddfe@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679216560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I3+wFKW7LOBK3oL4BTRlcYppnzJ7+VsJrxjEV4xeaJY=;
        b=T6JQAWSalAmSrD+DXjSrK0+PvUzqXegzBjYo7iIKn+Fx0Gzsv21vLsRRiDJoIROxagh+YZ
        /om+9/sgSkrqmNwrJZ8HS2K4r6Rdxg3MljZpxWmNYGatJut8AijdoOZJGsIys85O1R3Ah7
        S4GUzwoFl6fHmWwc2UW5bQHf88nsITo=
Date:   Sun, 19 Mar 2023 17:02:35 +0800
MIME-Version: 1.0
Subject: Re: question about the completion tasklet in the rxe driver
To:     Bob Pearson <rpearsonhpe@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Bernard Metzler <bmt@zurich.ibm.com>
References: <d61963cf-77ef-ef0a-8c94-2de89cb6a5a6@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <d61963cf-77ef-ef0a-8c94-2de89cb6a5a6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

在 2023/3/16 5:56, Bob Pearson 写道:
> I have a goal of trying to get rid of all the tasklets in the rxe driver and with the replacement of the

If work queue is used, is it possible to distribute the work queue tasks 
to different cpus evenly in the same numa (if numa is consider)?  ^_^

Zhu Yanjun

> three QP tasklets by workqueues the only remaining one is the tasklet that defers the CQ completion
> handler. This has been in there since the driver went upstream so the history of why it is there is lost.
> 
> I notice that the mlx5 driver does have a deferral mechanism for the completion handler but the siw driver
> does not. I really do not see what advantage, if any, this has for the rxe driver. Perhaps there is some
> reason it shouldn't run in hard interrupt context but the CQ tasklet is a soft interrupt so the completion
> handler can't sleep anyway.
> 
> As an experiment I removed the CQ tasklet in the rxe driver and it runs fine. In fact the performance is
> slightly better with the completion handler called inline rather than deferred to another tasklet.
> If we can eliminate this there won't be anymore tasklets in the rxe driver.
> 
> Does anyone know why the tasklet was put in in the first place?
> 
> Thanks,
> 
> Bob

