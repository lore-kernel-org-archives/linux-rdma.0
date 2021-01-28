Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA72C433DB
	for <linux-rdma@archiver.kernel.org>; Thu, 28 Jan 2021 06:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB22264DD6
	for <linux-rdma@archiver.kernel.org>; Thu, 28 Jan 2021 06:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbhA1Gaj (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:30:39 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12353 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229462AbhA1Gah (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 28 Jan 2021 01:30:37 -0500
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; 
   d="scan'208";a="103928033"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Jan 2021 14:29:49 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id 12D6D48990D2;
        Thu, 28 Jan 2021 14:29:46 +0800 (CST)
Received: from [10.167.220.69] (10.167.220.69) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Thu, 28 Jan 2021 14:29:45 +0800
Message-ID: <601259D7.1040207@cn.fujitsu.com>
Date:   Thu, 28 Jan 2021 14:29:43 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.2; zh-CN; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To:     Leon Romanovsky <leon@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <jgg@nvidia.com>
Subject: Re: [RFC PATCH] RDMA/rxe: Export imm_data to WC when the related
 WR with imm_data finished on SQ
References: <20210127082431.2637863-1-yangx.jy@cn.fujitsu.com> <20210127120427.GJ1053290@unreal>
In-Reply-To: <20210127120427.GJ1053290@unreal>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.220.69]
X-ClientProxiedBy: G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) To
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206)
X-yoursite-MailScanner-ID: 12D6D48990D2.AC4CB
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 2021/1/27 20:04, Leon Romanovsky wrote:
> On Wed, Jan 27, 2021 at 04:24:31PM +0800, Xiao Yang wrote:
>> Even if we enable sq_sig_all or IBV_SEND_SIGNALED, current rxe
>> module cannot set imm_data in WC when the related WR with imm_data
>> finished on SQ.
>>
>> Signed-off-by: Xiao Yang<yangx.jy@cn.fujitsu.com>
>> ---
>>
>> Current rxe module and other rdma modules(e.g. mlx5) only set
>> imm_data in WC when the related WR with imm_data finished on RQ.
>> I am not sure if it is a expected behavior.
> This is IBTA behavior.
>
> 5.2.11 IMMEDIATE DATA EXTENDED TRANSPORT HEADER (ImmDt) - 4 BYTES
> "Immediate Data (ImmDt) contains data that is placed in the receive
>   Completion Queue Element (CQE). The ImmDt is only allowed in SEND or
>   RDMA WRITE packets with Immediate Data."
>
> If I understand the spec, you shouldn't set imm_data in SQ.
Hi Leon,

About the behavior, I have another question:
For send operation with imm_data, we can verify if the delivered 
imm_data is correct by CQE on RQ.
For rdma write operation with imm_data, how to verify if the delivered 
imm_data is correct? :-)

Best Regards,
Xiao Yang
> Thanks
>
>
> .
>



