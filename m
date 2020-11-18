Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40EA8C5519F
	for <linux-rdma@archiver.kernel.org>; Wed, 18 Nov 2020 16:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D895220780
	for <linux-rdma@archiver.kernel.org>; Wed, 18 Nov 2020 16:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbgKRQpT (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 18 Nov 2020 11:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbgKRQpT (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 18 Nov 2020 11:45:19 -0500
X-Greylist: delayed 89446 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 18 Nov 2020 08:45:19 PST
Received: from btbn.de (btbn.de [IPv6:2a01:4f8:162:63a9::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7DFC0613D4
        for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2020 08:45:19 -0800 (PST)
Received: from [IPv6:2001:16b8:646b:3300:90ed:462b:245d:1c3b] (200116b8646b330090ed462b245d1c3b.dip.versatel-1u1.de [IPv6:2001:16b8:646b:3300:90ed:462b:245d:1c3b])
        by btbn.de (Postfix) with ESMTPSA id B1EC0128F49;
        Wed, 18 Nov 2020 17:45:15 +0100 (CET)
Subject: Re: Issue after 5.4.70->5.4.77 update: mlx5_core: reg_mr_callback:
 async reg mr failed. status -11
To:     Eran Ben Elisha <eranbe@nvidia.com>, jgg@ziepe.ca,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     RDMA mailing list <linux-rdma@vger.kernel.org>
References: <53e3f194-fe27-ba79-bcff-6dd1d778ede0@rothenpieler.org>
 <20201117195046.GI244516@ziepe.ca>
 <6cf6f99b-7d12-8964-d044-b11a313a4c26@nvidia.com>
From:   Timo Rothenpieler <timo@rothenpieler.org>
Message-ID: <1c822a6b-400a-0e66-ac5c-71b955821062@rothenpieler.org>
Date:   Wed, 18 Nov 2020 17:45:13 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <6cf6f99b-7d12-8964-d044-b11a313a4c26@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

> linux-5.4.y branch is missing the fixes below:
> 
> 1. 1d5558b1f0de net/mlx5: poll cmd EQ in case of command timeout
> 2. 410bd754cd73 net/mlx5: Add retry mechanism to the command entry ...
> 
> The second fix in particular matches Timo's bug report.
> It does not directly fix the offending commit, however the offending 
> commit raised the probability to bump with this issue.

I applied those two commits, and two commits they depended on, on top of 
my 5.4.77, and now the errors on bootup are gone:

> 0001-net-mlx5-Use-async-EQ-setup-cleanup-helpers-for-mult.patch
> 0002-net-mlx5-poll-cmd-EQ-in-case-of-command-timeout.patch
> 0003-net-mlx5-Fix-a-race-when-moving-command-interface-to.patch
> 0004-net-mlx5-Add-retry-mechanism-to-the-command-entry-in.patch


