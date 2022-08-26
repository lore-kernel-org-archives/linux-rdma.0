Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9410CECAAA3
	for <linux-rdma@archiver.kernel.org>; Fri, 26 Aug 2022 14:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiHZOCI (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 26 Aug 2022 10:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245361AbiHZOCH (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 26 Aug 2022 10:02:07 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7535B7A9;
        Fri, 26 Aug 2022 07:02:06 -0700 (PDT)
Subject: Re: [PATCH] rnbd-srv: remove 'dir' argument from rnbd_srv_rdma_ev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661522524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8cVFtVUdEAQHRP7RIy5a42M7sSLpdVoeffEDi8QLxtI=;
        b=toSQZxylfd8NB7r9tUMtNlZ8Pbev+jNVTJbTBpY5eXeAYZAg0kOxGcDfkXE1k3d9rJrr0e
        4kQJso9JnV0xngA328VKszi6BhAWAKyiumFOrJcp465Eg3IScFjszK1WljxFG4vvHe9wUG
        kG3hMgfJCV7Ag+jE7FmRxsTX9favwyE=
To:     Jinpu Wang <jinpu.wang@ionos.com>
Cc:     haris.iqbal@ionos.com, axboe@kernel.dk, jgg@ziepe.ca,
        leon@kernel.org, linux-block@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20220826081117.21687-1-guoqing.jiang@linux.dev>
 <CAMGffEku8H3RubkQGq1Cjy8pP8B+95coT+b2J6VxSAQx-kKmmg@mail.gmail.com>
 <aa3a4d50-2e71-a185-09ac-79bd34f9c8e6@linux.dev>
 <CAMGffEkRo104Cp6+KX8NtS0ud+DHM6ftjmHyxjiQa=zJ7tFzog@mail.gmail.com>
 <c4fb6007-91f9-6d2c-4888-d49a08dd297e@linux.dev>
 <CAMGffEkAYOJPAPaHDspk-JfJNNF96pHWnrCwYzROFZxPBBO+Fw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <09317a03-4e29-0f8b-4d7e-a2024c9364f6@linux.dev>
Date:   Fri, 26 Aug 2022 22:01:55 +0800
MIME-Version: 1.0
In-Reply-To: <CAMGffEkAYOJPAPaHDspk-JfJNNF96pHWnrCwYzROFZxPBBO+Fw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org



On 8/26/22 7:58 PM, Jinpu Wang wrote:
>> And I guess we can just pass parameters with register after remove an
>> argument,
>> otherwise need to push/pop stack with more than six parameters for x64.
> I doubt it makes any notable performance change.

I think it is called in the IO path (process_read and process_write) ...

BTW, do you agree if the 'usr' can be dropped from rdma_ev given it is 
always
same as 'data + data_len'?

Thanks,
Guoqing
