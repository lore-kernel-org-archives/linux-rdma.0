Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D23BC001B0
	for <linux-rdma@archiver.kernel.org>; Fri, 11 Aug 2023 01:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjHKBPU (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 10 Aug 2023 21:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjHKBPS (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 10 Aug 2023 21:15:18 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADB42D61;
        Thu, 10 Aug 2023 18:15:13 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RMQmP4FJpzrSFV;
        Fri, 11 Aug 2023 09:13:57 +0800 (CST)
Received: from [10.174.179.215] (10.174.179.215) by
 canpemm500007.china.huawei.com (7.192.104.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 11 Aug 2023 09:15:11 +0800
Subject: Re: [PATCH net-next] rds: tcp: Remove unused declaration
 rds_tcp_map_seq()
To:     Simon Horman <horms@kernel.org>
CC:     <santosh.shilimkar@oracle.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <rds-devel@oss.oracle.com>
References: <20230809144148.13052-1-yuehaibing@huawei.com>
 <ZNU/M1Iot28KUYtv@vergenet.net>
From:   Yue Haibing <yuehaibing@huawei.com>
Message-ID: <982cc90a-d45b-ceaa-c1cf-bc2a8e897e01@huawei.com>
Date:   Fri, 11 Aug 2023 09:15:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <ZNU/M1Iot28KUYtv@vergenet.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 2023/8/11 3:49, Simon Horman wrote:
> On Wed, Aug 09, 2023 at 10:41:48PM +0800, Yue Haibing wrote:
>> rds_tcp_map_seq() is never implemented and used since
>> commit 70041088e3b9 ("RDS: Add TCP transport to RDS").
>>
>> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
> 
> Reviewed-by: Simon Horman <horms@kernel.org>
> 
> BTW, I think these rds patches could have been rolled-up
> into a patch-set, or perhaps better still squashed into a single patch.

Thanks, will fold them in v2.
> .
> 
