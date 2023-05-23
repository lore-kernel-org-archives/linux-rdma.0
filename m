Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DEDAC7EE23
	for <linux-rdma@archiver.kernel.org>; Tue, 23 May 2023 04:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbjEWEKh (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 23 May 2023 00:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjEWEKd (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 23 May 2023 00:10:33 -0400
Received: from out-36.mta1.migadu.com (out-36.mta1.migadu.com [IPv6:2001:41d0:203:375::24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1ADF91
        for <linux-rdma@vger.kernel.org>; Mon, 22 May 2023 21:10:31 -0700 (PDT)
Message-ID: <0d515e17-5386-61ba-8278-500620969497@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1684815029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pJXGcOSTog9gvgxkbKUXqU+fyEolnGD+CeGlDmRt/xg=;
        b=XX9ypBxkP96DK4BO0w7PU9i5wbLDn9jXRA5EdXXILcbxEwGsowHmXEExAPZFM6VjKNmUm1
        mR5JTF+qVdYe4zf7Va/KHqFp3V1Sex70vtlAIneM9edUyM5QN3MZImqU7KS1UbhKo3jl9m
        23nV26/ebqtfZ/o+RFBM1aJstaEVvGs=
Date:   Tue, 23 May 2023 12:10:26 +0800
MIME-Version: 1.0
Subject: Re: [syzbot] [rdma?] INFO: trying to register non-static key in
 skb_dequeue (2)
Content-Language: en-US
To:     Zhu Yanjun <zyjzyj2000@gmail.com>
Cc:     syzbot <syzbot+eba589d8f49c73d356da@syzkaller.appspotmail.com>,
        jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000a589d005fc52ee2d@google.com>
 <13528f21-0f36-4fa2-d34f-eecee6720bc1@linux.dev>
 <CAD=hENeCo=-Pk9TWnqxOWP9Pg-JXWk6n6J19gvPo9_h7drROGg@mail.gmail.com>
 <CAD=hENdoyBZaRz7aTy4mX5Kq1OYmWabx2vx8vPH0gQfHO1grzw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <CAD=hENdoyBZaRz7aTy4mX5Kq1OYmWabx2vx8vPH0gQfHO1grzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org



On 5/23/23 12:02, Zhu Yanjun wrote:
> On Tue, May 23, 2023 at 11:47 AM Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
>> On Tue, May 23, 2023 at 10:26 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>>>
>>>
>>> On 5/23/23 10:13, syzbot wrote:
>>>> Hello,
>>>>
>>>> syzbot tried to test the proposed patch but the build/boot failed:
>>>>
>>>> failed to apply patch:
>>>> checking file drivers/infiniband/sw/rxe/rxe_qp.c
>>>> patch: **** unexpected end of file in patch
>> This is not the root cause. The fix is not good.
> This problem is about "INFO: trying to register non-static key. The
> code is fine but needs lockdep annotation, or maybe"

Which is caused by  "skb_queue_head_init(&qp->resp_pkts)" is not called
given rxe_qp_init_resp returns error, but the cleanup still trigger the 
chain.

rxe_qp_do_cleanup -> rxe_completer -> drain_resp_pkts -> 
skb_dequeue(&qp->resp_pkts)

But I might misunderstood it ...

Thanks,
Guoqing
