Return-Path: <SRS0=thi4=AV=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C4D9C433DF
	for <linux-rdma@archiver.kernel.org>; Fri, 10 Jul 2020 18:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56A4620720
	for <linux-rdma@archiver.kernel.org>; Fri, 10 Jul 2020 18:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgGJSMa (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 10 Jul 2020 14:12:30 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:41474 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbgGJSMa (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 10 Jul 2020 14:12:30 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 368E2BC070;
        Fri, 10 Jul 2020 18:12:27 +0000 (UTC)
Subject: Re: [PATCH] SCSI RDMA PROTOCOL (SRP) TARGET: Replace HTTP links with
 HTTPS ones
To:     Bart Van Assche <bvanassche@acm.org>, dledford@redhat.com,
        jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200709194820.27032-1-grandmaster@al2klimov.de>
 <3d230abd-752e-8ac1-e18d-b64561b409ff@acm.org>
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
Message-ID: <8fca4633-41ad-7e86-2354-36381bf5c734@al2klimov.de>
Date:   Fri, 10 Jul 2020 20:12:26 +0200
MIME-Version: 1.0
In-Reply-To: <3d230abd-752e-8ac1-e18d-b64561b409ff@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
X-Spamd-Bar: /
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org



Am 10.07.20 um 16:22 schrieb Bart Van Assche:
> On 2020-07-09 12:48, Alexander A. Klimov wrote:
>> diff --git a/drivers/infiniband/ulp/srpt/Kconfig b/drivers/infiniband/ulp/srpt/Kconfig
>> index 4b5d9b792cfa..f63b34d9ae32 100644
>> --- a/drivers/infiniband/ulp/srpt/Kconfig
>> +++ b/drivers/infiniband/ulp/srpt/Kconfig
>> @@ -10,4 +10,4 @@ config INFINIBAND_SRPT
>>   	  that supports the RDMA protocol. Currently the RDMA protocol is
>>   	  supported by InfiniBand and by iWarp network hardware. More
>>   	  information about the SRP protocol can be found on the website
>> -	  of the INCITS T10 technical committee (http://www.t10.org/).
>> +	  of the INCITS T10 technical committee (https://www.t10.org/).
> 
> It is not clear to me how modifying an URL in a Kconfig file helps to
> reduce the attack surface on kernel devs?
Not on all, just on the ones who open it.

> 
> Thanks,
> 
> Bart.
> 
> 
