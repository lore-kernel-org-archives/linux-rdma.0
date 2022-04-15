Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF49EC433EF
	for <linux-rdma@archiver.kernel.org>; Fri, 15 Apr 2022 07:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347084AbiDOIBs (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 15 Apr 2022 04:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbiDOIBr (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 15 Apr 2022 04:01:47 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB29C60DAA
        for <linux-rdma@vger.kernel.org>; Fri, 15 Apr 2022 00:59:19 -0700 (PDT)
Message-ID: <0eaf11a9-7933-8ff9-5c12-94ca6e2df7aa@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1650009558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EH1NVahweurSrKtqwew4Qn7KsWxWjmsMLRT3xmgk/Lw=;
        b=MzU3P97cpV0ss9spI9ImOmi5qKuOASOP7oPBcJ4sD1P54uOqoRlUj5KQ4svB+NEc0fubJp
        syNfMockKRqbzPYUXAHpEeUoNGUtR1Gm/mPBpu9au7ZypT6xOrIY1n6t5BZUwbVAFvRnKT
        r28m5ikq63gzGWb84hUaZekmP7vDQsU=
Date:   Fri, 15 Apr 2022 15:59:13 +0800
MIME-Version: 1.0
Subject: Re: blktest failures
To:     Bob Pearson <rpearsonhpe@gmail.com>,
        Yanjun Zhu <yanjun.zhu@linux.dev>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Yi Zhang <yi.zhang@redhat.com>
References: <533dc3b0-e58a-0bc8-2f07-5dbfb3d1235e@gmail.com>
 <28b4c636-c5a7-451b-965b-6201ac5af460@gmail.com>
 <98f2a27d-7fa6-074f-a3e5-6b172c79ccd7@acm.org>
 <20220409050405.GA17755@lst.de>
 <8ff53db7-137f-8d29-18e7-3926de255deb@gmail.com>
 <d594aef2-7728-d9f3-59eb-148a492ec8af@linux.dev>
 <faacdaa0-849b-e10f-7f27-f63bd203aaed@gmail.com>
 <789cfa63-55f9-0074-1245-ad38a6fe8bf8@linux.dev>
 <2ddef344-5df4-dd7b-08e8-655edf7b3014@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Yanjun Zhu <yanjun.zhu@linux.dev>
In-Reply-To: <2ddef344-5df4-dd7b-08e8-655edf7b3014@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

在 2022/4/15 15:46, Bob Pearson 写道:
> On 4/15/22 02:37, Yanjun Zhu wrote:
>>
>> 在 2022/4/15 15:29, Bob Pearson 写道:
>>> On 4/15/22 02:12, Yanjun Zhu wrote:
>>>> 在 2022/4/10 5:43, Bob Pearson 写道:
>>>>> On 4/9/22 00:04, Christoph Hellwig wrote:
>>>>>> On Fri, Apr 08, 2022 at 04:25:12PM -0700, Bart Van Assche wrote:
>>>>>>> One of the functions in the above call stack is sd_remove(). sd_remove()
>>>>>>> calls del_gendisk() just before calling sd_shutdown(). sd_shutdown()
>>>>>>> submits the SYNCHRONIZE CACHE command. In del_gendisk() I found the
>>>>>>> following comment: "Fail any new I/O". Do you agree that failing new I/O
>>>>>>> before sd_shutdown() is called is wrong? Is there any other way to fix this
>>>>>>> than moving the blk_queue_start_drain() etc. calls out of del_gendisk() and
>>>>>>> into a new function?
>>>>>> That SYNCHRONIZE CACHE is a passthrough command sent on the request_queue
>>>>>> and should not be affected by stopping all file system I/O.
>>>>> When I run check -q srp
>>>>> all the test cases pass but each one stops for 3+ minutes at synchronize cache.
>>>>> The rxe device is still active until sync cache returns when the last QP and the PD
>>>>> are destroyed. It may be that the queues are blocked waiting for something else
>>>>> even though they have reported success??
>>>> If you remove all the xarray patches and use the original source code. This will not occur.
>>>>
>>>> Zhu Yanjun
>>>>
>>> I missed one other point. The 3 minute delay is actually not a rxe bug at all but was recently
>>> caused by a bad scsi patch which has since been reverted.
>>
>> I am not sure about this because wr NULL problem exists with xarray patches.
>>
>> Please let us find the root cause of wr NULL.
>>
>> This can make RXE more stable.
>>
>> Zhu Yanjun
>>
> 
> You mean mr = NULL. And it is not happening in my tree. I have WARN_ONs looking for it

Why you said that you can not reproduce this problem now?

Please check your mail. I remember that you can reproduce this wr NULL 
in your host.

Please focus on this problem. This can make RXE more stable.
Let us find the root cause and fix this problem ASAP.

Thanks.
Zhu Yanjun

> and it isn't happening.

