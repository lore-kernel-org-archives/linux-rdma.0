Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9922EC38145
	for <linux-rdma@archiver.kernel.org>; Tue,  6 Sep 2022 07:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbiIFHFK (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 6 Sep 2022 03:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236570AbiIFHFH (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 6 Sep 2022 03:05:07 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19EC2E9C2
        for <linux-rdma@vger.kernel.org>; Tue,  6 Sep 2022 00:05:05 -0700 (PDT)
Subject: Re: [PATCH 0/3] misc changes for rtrs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662447903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vFR1xXK3fUCz89LzOM7rJpkeUsh2OWUvCdb95mVg17E=;
        b=oOrd8/JEHL9qQVBPqdfd1t0ad89BNOQSoSBlu3if7hxB94Q7nFt1ZePWxv+p4JzBEsimPY
        2SDOu21Ben+T/tdY25ze8K6y200ho8rAUwSEt04tEYLdg+/PcJbkYtLplyvyVJtTNuQkq5
        P4ryBpBFfBFDKIH9sJ/Zp8dS0uwC6Bc=
To:     Leon Romanovsky <leon@kernel.org>
Cc:     haris.iqbal@ionos.com, jinpu.wang@ionos.com, jgg@ziepe.ca,
        linux-rdma@vger.kernel.org
References: <20220902101922.26273-1-guoqing.jiang@linux.dev>
 <YxXrf1WKVwlDYgzm@unreal>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <0a170dcd-3665-43d2-8467-7566333d0307@linux.dev>
Date:   Tue, 6 Sep 2022 15:04:50 +0800
MIME-Version: 1.0
In-Reply-To: <YxXrf1WKVwlDYgzm@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi Leon,

On 9/5/22 8:28 PM, Leon Romanovsky wrote:
> On Fri, Sep 02, 2022 at 06:19:19PM +0800, Guoqing Jiang wrote:
>> Hi,
>>
>> Pls review the three patches.
>>
>> Thanks,
>> Guoqing
>>
>> Guoqing Jiang (3):
>>    RDMA/rtrs: Update comments for MAX_SESS_QUEUE_DEPTH
>>    RDMA/rtrs-clt: Break the loop once one path is connected
>>    RDMA/rtrs-clt: Kill xchg_paths
>>
>>   drivers/infiniband/ulp/rtrs/rtrs-clt.c | 18 +++++-------------
>>   drivers/infiniband/ulp/rtrs/rtrs-pri.h |  7 +++----
>>   2 files changed, 8 insertions(+), 17 deletions(-)
> The third patch still generates warnings.

Sorry, I didn't run sparse check, 😅.

> ➜  kernel git:(wip/leon-for-next) mkt ci
> ^[[A^[[A^[[Ad9b137e23d31 (HEAD -> build) RDMA/rtrs-clt: Kill xchg_paths
> WARNING: line length of 81 exceeds 80 columns
> #43: FILE: drivers/infiniband/ulp/rtrs/rtrs-clt.c:2297:
> +		if (try_cmpxchg((typeof(ppcpu_path))ppcpu_path, &clt_path, next))
>
> drivers/infiniband/ulp/rtrs/rtrs-clt.c:2297:21: warning: incorrect type in initializer (different address spaces)
> drivers/infiniband/ulp/rtrs/rtrs-clt.c:2297:21:    expected struct rtrs_clt_path [noderef] __rcu *__new
> drivers/infiniband/ulp/rtrs/rtrs-clt.c:2297:21:    got struct rtrs_clt_path *[assigned] next

Before send new version, could you help to check whether the incremental 
change works or not? Otherwise let's drop the third one.

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c 
b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 0661a4e69fc9..bc3e1722e00d 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -2294,7 +2294,8 @@ static void rtrs_clt_remove_path_from_arr(struct 
rtrs_clt_path *clt_path)
                  * We race with IO code path, which also changes pointer,
                  * thus we have to be careful not to overwrite it.
                  */
-               if (try_cmpxchg((typeof(ppcpu_path))ppcpu_path, 
clt_path, next))
+               if (try_cmpxchg((struct rtrs_clt_path **)ppcpu_path,
+                               clt_path, next))
                         /*
                          * @ppcpu_path was successfully replaced with 
@next,
                          * that means that someone could also pick up the

Thanks,
Guoqing
