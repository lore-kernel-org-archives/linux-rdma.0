Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064EAC001DB
	for <linux-rdma@archiver.kernel.org>; Thu, 10 Aug 2023 06:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjHJGvp (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 10 Aug 2023 02:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjHJGvo (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 10 Aug 2023 02:51:44 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BCEE69
        for <linux-rdma@vger.kernel.org>; Wed,  9 Aug 2023 23:51:41 -0700 (PDT)
Received: from kwepemi500006.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RLyDT2q3jzJsYj
        for <linux-rdma@vger.kernel.org>; Thu, 10 Aug 2023 14:48:09 +0800 (CST)
Received: from [10.67.102.17] (10.67.102.17) by kwepemi500006.china.huawei.com
 (7.221.188.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 10 Aug
 2023 14:51:38 +0800
Message-ID: <f6aeac31-89a5-1eeb-11a5-2eb545de116d@hisilicon.com>
Date:   Thu, 10 Aug 2023 14:51:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Content-Language: en-US
From:   Junxian Huang <huangjunxian6@hisilicon.com>
To:     linux-rdma <linux-rdma@vger.kernel.org>
Subject: When should positive and negative error codes be used?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.17]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500006.china.huawei.com (7.221.188.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi all!

I'm wondering if there is a clear rule for the usage of positive and
negative values of error codes.

It seems that negative values are uniformly used in kernel space, but
both positive and negative values are used in user space. When should
positive values be used and when should negative values be used?

Junxian

