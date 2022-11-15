Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95585C4332F
	for <linux-rdma@archiver.kernel.org>; Tue, 15 Nov 2022 10:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiKOKbA (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 15 Nov 2022 05:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbiKOKa6 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 15 Nov 2022 05:30:58 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CFA1D0D3
        for <linux-rdma@vger.kernel.org>; Tue, 15 Nov 2022 02:30:58 -0800 (PST)
Subject: Re: [PATCH RFC 10/12] RDMA/rtrs-srv: Remove paths_num
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668508256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=io1NVaNQBQJjAEi/Gg2OzZmTuommTDn2RkXjsWX+MPg=;
        b=eFRR3j8oZtxsGPw2qpEHEw6zYZe2nKFe8UspHkoVfS1AOrtKsNQdfGY1maAPKF2EXgI5mc
        VcCkUg+o8/R2kVyhNRFMUoHC6rpa00K5iXAhL2LUEIH7X/3hNF8YlelmWmkGW41iXh0VEZ
        it3LkJprkicJ8o1+/YuyTC4kBbPgrrQ=
To:     Jinpu Wang <jinpu.wang@ionos.com>,
        Haris Iqbal <haris.iqbal@ionos.com>
Cc:     jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org
References: <20221113010823.6436-1-guoqing.jiang@linux.dev>
 <20221113010823.6436-11-guoqing.jiang@linux.dev>
 <CAJpMwyjkeYj6eVMG+htwHkFVRP6m-tGpyFEaUeSCkXO3u6MqzA@mail.gmail.com>
 <CAMGffEmPd4XjjgATYTNHt0HPCp=B9KNFChzmkh9YLp_S=hzDEw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <feee4146-129e-3cac-85ea-397b9b9e02c8@linux.dev>
Date:   Tue, 15 Nov 2022 18:30:56 +0800
MIME-Version: 1.0
In-Reply-To: <CAMGffEmPd4XjjgATYTNHt0HPCp=B9KNFChzmkh9YLp_S=hzDEw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org



On 11/15/22 6:01 PM, Jinpu Wang wrote:
> On Tue, Nov 15, 2022 at 10:49 AM Haris Iqbal <haris.iqbal@ionos.com> wrote:
>> On Sun, Nov 13, 2022 at 2:08 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>>> The paths_num is only increased by rtrs_rdma_connect -> __alloc_path
>>> which is only one time thing, so is the decreasing of it given only
>>> rtrs_srv_close_work -> del_path_from_srv, which means paths_num should
>>> always be 1.
>> It would actually go up to the number of paths a session will have in
>> a multipath setup. It is the exact counter part of paths_num in the
>> structure rtrs_clt_sess. But whereas on the client side, the number is
>> used to access the path list for making decisions in multipathing IO
>> like round-robin, etc. On the server side, I don't see the use of it.
>> Maybe just for sanity checks.
>>
>> @Jinpu Any thoughts?
> Yes, the idea is RTRS can have many paths, not only one, and you can
> add/remove path at run time,
> so not a one time thing.

Got it, thanks for your review.

Guoqing
