Return-Path: <SRS0=7qKe=CF=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44935C433DF
	for <linux-rdma@archiver.kernel.org>; Thu, 27 Aug 2020 08:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C75620738
	for <linux-rdma@archiver.kernel.org>; Thu, 27 Aug 2020 08:20:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="TFBJ2sId"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgH0IU3 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:20:29 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:49585 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgH0IU3 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 27 Aug 2020 04:20:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598516428; x=1630052428;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Lz1vS4AlJlUYxvFj3eAoB93y/pUldI5wAot1aTLOMFA=;
  b=TFBJ2sIdQzZ7lvyI4aqw9tkRIiGxHly/WPCEh0A+ZCbmCwnG8/1lp+ON
   QCYiqMiRx8uXcXFXa9trtsVhe3plUh4woeXcNyvbryJIiP3+RxT+Leajh
   BM8EHIhcAONexdRalqBaZkAQ+x+Qta0tc4btPvNGZnqd9iSVDxS7ZEam/
   s=;
X-IronPort-AV: E=Sophos;i="5.76,359,1592870400"; 
   d="scan'208";a="51720213"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 27 Aug 2020 08:20:27 +0000
Received: from EX13D19EUB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id D02A4A1B19;
        Thu, 27 Aug 2020 08:20:25 +0000 (UTC)
Received: from 8c85908914bf.ant.amazon.com (10.43.162.55) by
 EX13D19EUB001.ant.amazon.com (10.43.166.229) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 27 Aug 2020 08:20:21 +0000
Subject: Re: [PATCH for-next] RDMA/usnic: Remove the query_pkey callback
To:     Kamal Heib <kamalheib1@gmail.com>
CC:     <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Benvenuti <benve@cisco.com>
References: <20200820125346.111902-1-kamalheib1@gmail.com>
 <efb8ce2b-fb37-2950-36fd-fb45b845632a@amazon.com>
 <20200820135338.GA114615@kheib-workstation>
 <20200827075356.GA394866@kheib-workstation>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <4be87aa7-bc3c-d8f1-05e2-9276125cacc2@amazon.com>
Date:   Thu, 27 Aug 2020 11:20:16 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200827075356.GA394866@kheib-workstation>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.55]
X-ClientProxiedBy: EX13D21UWB003.ant.amazon.com (10.43.161.212) To
 EX13D19EUB001.ant.amazon.com (10.43.166.229)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 27/08/2020 10:53, Kamal Heib wrote:
> On Thu, Aug 20, 2020 at 04:53:38PM +0300, Kamal Heib wrote:
>> On Thu, Aug 20, 2020 at 04:11:23PM +0300, Gal Pressman wrote:
>>> On 20/08/2020 15:53, Kamal Heib wrote:
>>>> Now that the query_pkey() isn't mandatory by the RDMA core, this
>>>> callback can be removed from the usnic provider.
>>>
>>> Not directly related to this patch, but pyverbs has a test which verifies that
>>> max_pkeys > 0, maybe this check should be removed.
>>
>> Or changed to work only for node_type == e.IBV_NODE_CA?
>>
>> Thanks,
>> Kamal
> 
> BTW, do the efa care about pkey?

Depends.. We only support the default pkey so it doesn't do much in terms of
functionality, but we still need to support it as part of the QP state machine
for modify QP.
