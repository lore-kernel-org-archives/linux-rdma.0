Return-Path: <SRS0=NVh0=D5=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48BF8C388F2
	for <linux-rdma@archiver.kernel.org>; Thu, 22 Oct 2020 11:49:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD830222E9
	for <linux-rdma@archiver.kernel.org>; Thu, 22 Oct 2020 11:49:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="XNYGhChz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897585AbgJVLtu (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 22 Oct 2020 07:49:50 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:11196 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2897584AbgJVLtu (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 22 Oct 2020 07:49:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1603367390; x=1634903390;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=yTsY3UKyCsatseUdBEbTSpqNhozqkv7ZnrKuYmxhS9I=;
  b=XNYGhChzwcj1Uihvm6QhJCw75OgyAOanUEoXvoR5Z89KJ4aWkqjq5SWT
   4VSv9MBbqBOxYAoAsP3qmTPhzxGX0jPAK5pbq60vgcAhK1LDMNwt0blKR
   BR/weyZr11YsOOuC32yGoPES/krfa1F0L2viMzq51x7lmE8EtrU93GA6A
   g=;
X-IronPort-AV: E=Sophos;i="5.77,404,1596499200"; 
   d="scan'208";a="60774765"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 22 Oct 2020 11:49:43 +0000
Received: from EX13D19EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id B8C62A20E6;
        Thu, 22 Oct 2020 11:49:41 +0000 (UTC)
Received: from 8c85908914bf.ant.amazon.com (10.43.161.237) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 22 Oct 2020 11:49:37 +0000
Subject: Re: New GID query API broke EFA
To:     Leon Romanovsky <leonro@nvidia.com>
CC:     Avihai Horon <avihaih@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, <linux-rdma@vger.kernel.org>,
        "Leybovich, Yossi" <sleybo@amazon.com>
References: <3e956560-3c76-5f4b-b8fa-ad96483cd042@amazon.com>
 <20201022112100.GE2611066@unreal>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <b3eeb7ea-17f7-7a57-aa56-4b19e54a8088@amazon.com>
Date:   Thu, 22 Oct 2020 14:49:32 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.3
MIME-Version: 1.0
In-Reply-To: <20201022112100.GE2611066@unreal>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.237]
X-ClientProxiedBy: EX13P01UWA001.ant.amazon.com (10.43.160.213) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 22/10/2020 14:21, Leon Romanovsky wrote:
> On Thu, Oct 22, 2020 at 01:58:29PM +0300, Gal Pressman wrote:
>> Hi all,
>>
>> The new IOCTL query GID API 9f85cbe50aa0 ("RDMA/uverbs: Expose the new GID query
>> API to user space") currently breaks EFA, as ibv_query_gid() no longer works.
>>
>> The problem is that the IOCTL call checks for:
>>       if (!rdma_ib_or_roce(ib_dev, port_num))
>>               return -EOPNOTSUPP;
>>
>> EFA is neither of these, but it uses GIDs.
>>
>> Any objections to remove the check? Any other solutions come to mind?
> 
> We added this check to protect access to rdma_get_gid_attr() for devices
> without GID table.
>  1234         table = rdma_gid_table(device, port_num);
>  1235         if (index < 0 || index >= table->sz)
>  1236                 return ERR_PTR(-EINVAL);
> 
> So you can extend that function to return for table == NULL an error and
> remove rdma_ib_or_roce()

Thanks Leon, I will send a patch.
