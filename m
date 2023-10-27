Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F186FC25B48
	for <linux-rdma@archiver.kernel.org>; Fri, 27 Oct 2023 01:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjJ0BjM (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 26 Oct 2023 21:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjJ0BjL (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 26 Oct 2023 21:39:11 -0400
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [IPv6:2001:41d0:1004:224b::bc])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBCA111
        for <linux-rdma@vger.kernel.org>; Thu, 26 Oct 2023 18:39:09 -0700 (PDT)
Message-ID: <c9a84540-5b8e-4fb8-becd-9a179c383e14@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698370747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8TE2HlxajpHSS9smWq0gCXDrL1KJQzVOHV/5ghUMjqk=;
        b=Jptb7Z3rLCIV0R4gQiFt3GQViEh9T4EtoLNgxaG3o+6LZlFw502K8GP7exqRuz4OxJBf5o
        A6IAC42KO1M77plIBvmT6ROHMe2LXZh6xNmOmDvJP30aFE3QjmupE42lVxahTVmuF6lCI5
        mFlGX93rZmtgZWVEc8u41WGHQWhh3FQ=
Date:   Fri, 27 Oct 2023 09:39:00 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] RDMA/rxe: Fix blktests srp lead kernel panic with 64k
 page size
To:     Bart Van Assche <bvanassche@acm.org>,
        Bob Pearson <rpearsonhpe@gmail.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>,
        Yi Zhang <yi.zhang@redhat.com>,
        "Daisuke Matsuda (Fujitsu)" <matsuda-daisuke@fujitsu.com>,
        Zhu Yanjun <yanjun.zhu@intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "zyjzyj2000@gmail.com" <zyjzyj2000@gmail.com>
References: <20231013011803.70474-1-yanjun.zhu@intel.com>
 <OS3PR01MB98651C7454C46841B8A78F11E5D2A@OS3PR01MB9865.jpnprd01.prod.outlook.com>
 <a6e4efa6-0623-4afa-9b57-969aaf346081@fujitsu.com>
 <20231020140139.GF691768@ziepe.ca>
 <6c57cf0d-c7a7-4aac-9eb2-d8bb1d832232@fujitsu.com>
 <CAHj4cs86fFi+1LMMAzjcdGg1g1gbQwy6QgksC0kYVmNgghLV_w@mail.gmail.com>
 <1ffaeaa4-4ac2-4531-8e0c-586e13c14c97@fujitsu.com>
 <366da960-6036-49c5-ad47-3ae3f4e55452@fujitsu.com>
 <8f705223-6fde-4b29-880b-570349f40db8@fujitsu.com>
 <143f03b7-08ba-411c-a7ad-580141c06cfe@acm.org>
 <20231026134300.GV691768@ziepe.ca>
 <fa4fab22-4d59-43f8-883c-d5a70a69a964@acm.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <fa4fab22-4d59-43f8-883c-d5a70a69a964@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


在 2023/10/27 5:47, Bart Van Assche 写道:
> On 10/26/23 06:43, Jason Gunthorpe wrote:
>> On Thu, Oct 26, 2023 at 06:28:37AM -0700, Bart Van Assche wrote:
>>> If the rxe driver only supports mr.page_size == PAGE_SIZE, does this
>>> mean that RXE_PAGE_SIZE_CAP should be changed from
>>> 0xfffff000 into PAGE_SHIFT?
>>
>> Yes
>
> Bob, do you plan to convert the above change into a patch or do you
> perhaps expect me to do that?


Zhijian has done a lot of work on this problem. And he found out the 
root cause.

Perhaps Zhijian should file a patch for this problem?

Zhu Yanjun


>
> Thanks,
>
> Bart.
>
