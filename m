Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE7DEC388F7
	for <linux-rdma@archiver.kernel.org>; Tue, 10 Nov 2020 07:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7793720795
	for <linux-rdma@archiver.kernel.org>; Tue, 10 Nov 2020 07:49:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="SGbl1bcy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgKJHt2 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 10 Nov 2020 02:49:28 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:2417 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgKJHt2 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 10 Nov 2020 02:49:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1604994568; x=1636530568;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=UBnwU438ILgniJ5PsnKac+bR29kDDofdqxAPtSnudOE=;
  b=SGbl1bcygDEv0taM+C1jW69fWMLvMIVg6DN+NfLWnxurKWL/7P3KDMLA
   aM34Blo2Wns0GbKM80NHRfPd9ppKIgPgQnIow7QrXqnNija4spu6QalPx
   ozT2E0eBB9CqFa7pdDQ8q20L4nG/dTRmVNSYY53orxl3ms0agfcANpojS
   w=;
X-IronPort-AV: E=Sophos;i="5.77,465,1596499200"; 
   d="scan'208";a="63361252"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 10 Nov 2020 07:49:21 +0000
Received: from EX13D19EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id CB598A1E04;
        Tue, 10 Nov 2020 07:49:20 +0000 (UTC)
Received: from 8c85908914bf.ant.amazon.com (10.43.160.59) by
 EX13D19EUB001.ant.amazon.com (10.43.166.229) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 10 Nov 2020 07:49:17 +0000
Subject: Re: [PATCH for-next] RDMA/nldev: Add parent bdf to device information
 dump
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        <linux-rdma@vger.kernel.org>
References: <20201103132627.67642-1-galpress@amazon.com>
 <20201103134522.GL36674@ziepe.ca> <20201103135719.GK5429@unreal>
 <0825e1bf-f913-d2c1-ad3f-35ba3d6b75ef@amazon.com>
 <20201103142243.GM36674@ziepe.ca>
 <5e2208ab-9e87-56ae-bc38-5827637eb5be@amazon.com>
 <20201105200005.GJ36674@ziepe.ca>
 <cd3f2926-0491-8540-d6b1-534014190bae@amazon.com>
 <20201108234935.GC244516@ziepe.ca>
 <7a9866b6-fa33-0b95-4bda-4c83112be369@amazon.com>
 <20201109175700.GF244516@ziepe.ca>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <6c77ad03-db3b-a1f8-cd28-a744585ba26d@amazon.com>
Date:   Tue, 10 Nov 2020 09:49:11 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201109175700.GF244516@ziepe.ca>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.160.59]
X-ClientProxiedBy: EX13D30UWC003.ant.amazon.com (10.43.162.122) To
 EX13D19EUB001.ant.amazon.com (10.43.166.229)
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 09/11/2020 19:57, Jason Gunthorpe wrote:
> On Mon, Nov 09, 2020 at 11:03:47AM +0200, Gal Pressman wrote:
> 
>>> The thing is, is is still useless. You have to consult sysfs to
>>> understand what bus it is scoped on to do anything further with
>>> it. Can't just assume it is PCI.
>>
>> This can be solved with Parav's suggestion.
> 
> Now you are adding more stuff.
> 
> What is wrong with reading sysfs? sysfs is where topology information
> lives, why do we need to denormalize things?

And yet you have lspci so you don't have to dig through the sysfs files by hand
for that topology.
Please drop this patch.
