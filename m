Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C84ECAAD5
	for <linux-rdma@archiver.kernel.org>; Thu,  8 Sep 2022 10:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiIHKEd (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 8 Sep 2022 06:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiIHKEc (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 8 Sep 2022 06:04:32 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0939FF0
        for <linux-rdma@vger.kernel.org>; Thu,  8 Sep 2022 03:04:31 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662631469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fb9SEQj3gVaZ5+SsXp8lzTN+YGO2+noEZxqg7OZJxpY=;
        b=XQHS84BrdJD1yhTNFvcN2qdfzDd4OPhFyWzRxtybH0roN3IXpnYisdFPGL4PxCSxLYjK0w
        CJR2v/Rn4INDwRvYK7f+wg47F4Ujno4DtNQxbO8U+s4XcBTkelvVMoSwQVMJQUERaKTK0T
        FSGgko3RAhXjJnhMDGZEwT7R28T6th8=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH V2 3/3] RDMA/rtrs-clt: Kill xchg_paths
To:     Haris Iqbal <haris.iqbal@ionos.com>
Cc:     jinpu.wang@ionos.com, jgg@ziepe.ca, leon@kernel.org,
        linux-rdma@vger.kernel.org, kernel test robot <lkp@intel.com>
References: <20220908094548.4115-1-guoqing.jiang@linux.dev>
 <20220908094548.4115-4-guoqing.jiang@linux.dev>
 <CAJpMwyjzEc0hLbq7x5nQDPGp5Bwaqp4nTwcNBFryW28jKm8+aw@mail.gmail.com>
Message-ID: <be6fca6f-d8a6-660e-dc19-14bac7a8df10@linux.dev>
Date:   Thu, 8 Sep 2022 18:04:17 +0800
MIME-Version: 1.0
In-Reply-To: <CAJpMwyjzEc0hLbq7x5nQDPGp5Bwaqp4nTwcNBFryW28jKm8+aw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org



On 9/8/22 5:55 PM, Haris Iqbal wrote:
> On Thu, Sep 8, 2022 at 11:46 AM Guoqing Jiang<guoqing.jiang@linux.dev>  wrote:
>> Let's call try_cmpxchg directly for the same purpose.
>>
>> Acked-by: Md Haris Iqbal<haris.iqbal@ionos.com>
>> Signed-off-by: Guoqing Jiang<guoqing.jiang@linux.dev>
>> Reported-by: kernel test robot<lkp@intel.com>
> I am not sure whats the correct way of using this. But technically,
> this change was NOT done due to a report from the "kernel test robot".
> It only pointed out the problem in the original patch. To the branch
> maintainers, if its okay to keep this in this scenario, then ignore
> this comment.

Me either, just want to give credit to lkp for previous report, but not sure
if there is a better tag.

Thanks,
Guoqing
