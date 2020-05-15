Return-Path: <SRS0=2Sn3=65=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F79C433E0
	for <linux-rdma@archiver.kernel.org>; Fri, 15 May 2020 22:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AB4220657
	for <linux-rdma@archiver.kernel.org>; Fri, 15 May 2020 22:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgEOWxq (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 15 May 2020 18:53:46 -0400
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:8081 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgEOWxq (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 15 May 2020 18:53:46 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.17]) by rmmx-syy-dmz-app08-12008 (RichMail) with SMTP id 2ee85ebf1d70078-096e9; Sat, 16 May 2020 06:53:40 +0800 (CST)
X-RM-TRANSID: 2ee85ebf1d70078-096e9
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from [192.168.0.101] (unknown[112.1.172.85])
        by rmsmtp-syy-appsvr09-12009 (RichMail) with SMTP id 2ee95ebf1d73562-078b7;
        Sat, 16 May 2020 06:53:40 +0800 (CST)
X-RM-TRANSID: 2ee95ebf1d73562-078b7
Subject: Re: [PATCH] net/mlx5e: Use IS_ERR() to check and simplify code
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200507115010.10380-1-tangbin@cmss.chinamobile.com>
 <20200507.131834.1517984934609648952.davem@davemloft.net>
 <febc1254-ad7f-f564-6607-9ac89f1fcf40@cmss.chinamobile.com>
 <295e31680acd83c4f66b9f928f1cab7e77e97529.camel@mellanox.com>
From:   Tang Bin <tangbin@cmss.chinamobile.com>
Message-ID: <d1dab359-4a2d-91c8-4985-107ae6566bb4@cmss.chinamobile.com>
Date:   Sat, 16 May 2020 06:54:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <295e31680acd83c4f66b9f928f1cab7e77e97529.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi Saeed：

On 2020/5/16 6:28, Saeed Mahameed wrote:
> On Wed, 2020-05-13 at 17:48 +0800, Tang Bin wrote:
>> Hi David:
>>
>> On 2020/5/8 4:18, David Miller wrote:
>>> From: Tang Bin <tangbin@cmss.chinamobile.com>
>>> Date: Thu,  7 May 2020 19:50:10 +0800
>>>
>>>> Use IS_ERR() and PTR_ERR() instead of PTR_ZRR_OR_ZERO()
>                                              ^^^^^^^ typo
Sorry for this mistake, sorry.
>>>> to simplify code, avoid redundant judgements.
>>>>
>>>> Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
>>>> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
>>> Saeed, please pick this up.
>> Does this mean the patch has been received and I just have to wait?
>>
> no, mlx5 patches normally go to net-next-mlx5 branch and usually
> pulled into net-next once a week when i send my pull requests.
>
> i will reply with "applied" when i apply this patch,
> but for now please fix the typo.

Got it, I will send v2 for you.

Thanks,

Tang Bin



