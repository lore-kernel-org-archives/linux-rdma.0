Return-Path: <SRS0=Jfdu=AG=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E7BDC433DF
	for <linux-rdma@archiver.kernel.org>; Thu, 25 Jun 2020 10:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDDB02076E
	for <linux-rdma@archiver.kernel.org>; Thu, 25 Jun 2020 10:54:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="S93QZlL4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403997AbgFYKyV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 25 Jun 2020 06:54:21 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:41616 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403952AbgFYKyV (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 25 Jun 2020 06:54:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1593082461; x=1624618461;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=VLH2UdzyNMfPUgA3BXespiCBGiOBUOSNnbQNG0IX0II=;
  b=S93QZlL4MjMooBaf2+oZMmonO8vVhtlvRFeh5K327GWrt2x8+H7PNmQc
   Q1pI1FiEoA6eeA8ZPwgiG9vVcHhOIWLj1VCFWesMGC798facr0LlK6IzX
   3WkRpgM55MqXnxNFHC/4zfsLvZcE96x+RwJbiJQN/1aKwxmuP2RKWf02a
   U=;
IronPort-SDR: 6uU5mDIo/BSKGtqApGZJdOyhuMt5+shWOwsHldlNoxJU47icJ0Kd46gWbjDod7PxAAcHN+2/9a
 s035sMjbMX6g==
X-IronPort-AV: E=Sophos;i="5.75,278,1589241600"; 
   d="scan'208";a="46835955"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 25 Jun 2020 10:54:05 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id DCD78A2786;
        Thu, 25 Jun 2020 10:54:03 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 25 Jun 2020 10:54:03 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.161.145) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 25 Jun 2020 10:53:59 +0000
Subject: Re: [PATCH for-next] RDMA/efa: Move provider specific attributes to
 ucontext allocation response
To:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>,
        Alexander Matushevsky <matua@amazon.com>,
        Firas JahJah <firasj@amazon.com>,
        Yossi Leybovich <sleybo@amazon.com>
References: <20200615075920.58936-1-galpress@amazon.com>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <b203d932-1fb7-d413-e807-ba12ccb53af2@amazon.com>
Date:   Thu, 25 Jun 2020 13:53:53 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200615075920.58936-1-galpress@amazon.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D27UWB002.ant.amazon.com (10.43.161.167) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 15/06/2020 10:59, Gal Pressman wrote:
> Provider specific attributes which are necessary for the userspace
> functionality should be part of the alloc ucontext response, not query
> device. This way a userspace provider could work without issuing a query
> device verb call. However, the fields will remain in the query device
> ABI in order to maintain backwards compatibility.
> 
> Reviewed-by: Firas JahJah <firasj@amazon.com>
> Reviewed-by: Yossi Leybovich <sleybo@amazon.com>
> Signed-off-by: Gal Pressman <galpress@amazon.com>
> ---
> PR was sent:
> https://github.com/linux-rdma/rdma-core/pull/775

This patch can be dropped following the discussion.
