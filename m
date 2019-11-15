Return-Path: <SRS0=H9Qn=ZH=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E2CBC432C3
	for <linux-rdma@archiver.kernel.org>; Fri, 15 Nov 2019 02:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BE05206F0
	for <linux-rdma@archiver.kernel.org>; Fri, 15 Nov 2019 02:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfKOCry (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 14 Nov 2019 21:47:54 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:6230 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726491AbfKOCry (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 14 Nov 2019 21:47:54 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CC3776B310BF2DD23B61
        for <linux-rdma@vger.kernel.org>; Fri, 15 Nov 2019 10:47:51 +0800 (CST)
Received: from [127.0.0.1] (10.61.25.96) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Fri, 15 Nov 2019
 10:47:43 +0800
To:     Jason Gunthorpe <jgg@ziepe.ca>, <nmoreychaisemartin@suse.de>
CC:     linux-rdma <linux-rdma@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
From:   oulijun <oulijun@huawei.com>
Subject: =?UTF-8?B?44CQcXVlc3Rpb27jgJE=?=
Message-ID: <8bc6ad1f-075a-e4d4-e5ac-c14de41c4a47@huawei.com>
Date:   Fri, 15 Nov 2019 10:47:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.61.25.96]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi, Nicolas Morey-Chaisemartin
   I noticed that the rdma-core repository has a suse directory. What is he used for?
If I want to use the suse system directly, there is a user-mode driver for the rdma-core.Can he use it directly?

Thanks
Lijun

