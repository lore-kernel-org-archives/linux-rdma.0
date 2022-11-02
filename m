Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999AFC433FE
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Nov 2022 16:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiKBQAN (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 2 Nov 2022 12:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiKBP7w (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 2 Nov 2022 11:59:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1766A2B615;
        Wed,  2 Nov 2022 08:59:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7995611AB;
        Wed,  2 Nov 2022 15:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECF9C433C1;
        Wed,  2 Nov 2022 15:59:48 +0000 (UTC)
Date:   Wed, 2 Nov 2022 11:59:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leonid Ravich <leonid.ravich@toganetworks.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yigal Korman <yigal.korman@toganetworks.com>,
        "linux-trace-kernel@vger.kernel.org" 
        <linux-trace-kernel@vger.kernel.org>,
        Leon Ravich <lravich@gmail.com>
Subject: Re: BUG:  ib_mad ftrace event unsupported migration
Message-ID: <20221102115947.000897fa@rorschach.local.home>
In-Reply-To: <Y2J9lAqBvjjPUmJf@ziepe.ca>
References: <VI1PR02MB623706DA8A01842834FC191089399@VI1PR02MB6237.eurprd02.prod.outlook.com>
        <20221102074457.08f538a8@rorschach.local.home>
        <Y2JqX3vC1mG/JDex@ziepe.ca>
        <VI1PR02MB623731066685B6E249F71A3189399@VI1PR02MB6237.eurprd02.prod.outlook.com>
        <Y2J4/NQMhRORqnZ0@ziepe.ca>
        <20221102101719.6cbcca6b@rorschach.local.home>
        <Y2J9lAqBvjjPUmJf@ziepe.ca>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, 2 Nov 2022 11:24:20 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> No, it doesn't muck with preemption, it will have some sleeping lock,
> eg mlx5_ib_query_pkey() does a memory allocation as the first thing
> 
> It seems like a bug that calling kmalloc(GFP_KERNEL)/might_sleep()
> from within a tracepoint doesn't trigger a warning?

Has nothing to do with tracepoints. You could call it a bug that it
doesn't trigger a warning when preemption is disabled. But then again,
it would if you enabled DEBUG_PREEMPT and possibly LOCKDEP too. So, I chalk
this up to a lack of proper testing.

-- Steve
