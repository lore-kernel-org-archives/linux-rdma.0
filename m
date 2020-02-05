Return-Path: <SRS0=jlCf=3Z=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E8DEC35247
	for <linux-rdma@archiver.kernel.org>; Wed,  5 Feb 2020 20:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B18420659
	for <linux-rdma@archiver.kernel.org>; Wed,  5 Feb 2020 20:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgBEUfR (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 5 Feb 2020 15:35:17 -0500
Received: from mga18.intel.com ([134.134.136.126]:42519 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbgBEUfR (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 5 Feb 2020 15:35:17 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 12:35:16 -0800
X-IronPort-AV: E=Sophos;i="5.70,407,1574150400"; 
   d="scan'208";a="235714865"
Received: from ddalessa-mobl.amr.corp.intel.com (HELO [10.254.205.112]) ([10.254.205.112])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Feb 2020 12:35:15 -0800
Subject: Re: [PATCH] kernel-boot: Do not perform device rename on OPA devices
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Goldman, Adam" <adam.goldman@intel.com>
Cc:     linux-rdma@vger.kernel.org, mike.marciniszyn@intel.com
References: <1580824520-38122-1-git-send-email-adam.goldman@intel.com>
 <20200205191227.GE28298@ziepe.ca>
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
Message-ID: <daa60df0-04e1-d33c-fdc9-5a3fea2688cb@intel.com>
Date:   Wed, 5 Feb 2020 15:35:13 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200205191227.GE28298@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 2/5/2020 2:12 PM, Jason Gunthorpe wrote:
> On Tue, Feb 04, 2020 at 08:55:20AM -0500, Goldman, Adam wrote:
>> From: "Goldman, Adam" <adam.goldman@intel.com>
>>
>> PSM2 will not run with recent rdma-core releases. Several tools and
>> libraries like PSM2, require the hfi1 name to be present.
>>
>> Recent rdma-core releases added a new feature to rename kernel devices,
>> but the default configuration will not work with hfi1 fabrics.
>>
>> Related opa-psm2 github issue:
>>    https://github.com/intel/opa-psm2/issues/43
>>
>> Fixes: 5b4099d47be3 ("kernel-boot: Perform device rename to make stable names")
>> Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
>> Signed-off-by: Goldman, Adam <adam.goldman@intel.com>
>>   kernel-boot/rdma-persistent-naming.rules | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel-boot/rdma-persistent-naming.rules b/kernel-boot/rdma-persistent-naming.rules
>> index 9b61e16..95d6851 100644
>> +++ b/kernel-boot/rdma-persistent-naming.rules
>> @@ -25,4 +25,4 @@
>>   #   Device type = RoCE
>>   #   mlx5_0 -> rocex525400c0fe123455
>>   #
>> -ACTION=="add", SUBSYSTEM=="infiniband", PROGRAM="rdma_rename %k NAME_FALLBACK"
>> +ACTION=="add", SUBSYSTEM=="infiniband", KERNEL!="hfi1*", PROGRAM="rdma_rename %k NAME_FALLBACK"
> 
> We are moving to the new names by default slowly, when wrong
> assumptions are found in other packages they need to be updated and
> their fixes pushed out.
> 
> At some point the major distros will default this to On. People using
> leading edge distros can turn it off with the global switch Leon
> mentioned.
> 
> This is the same process netdev went through when they introduced
> persistent names.
> 
> If I recall, hfi was one of the reason this work was done. HFI has
> problems generating consistent names for its multi-function devices in
> various cases and I NAK'd the kernel hack to try and 'fix' that.

So are you saying you won't take this patch then?

I guess we can work with distros to get the right rules in place outside 
of rdma-core so that things continue to work. It would be better though 
in my opinion to just have that be in rdma-core so no one has to worry 
about it and nothing needs to be globally disabled.

You are correct someone tried to put forth a hack for the flip-flop name 
thing [1]. However even if this was used as a solution for that issue we 
would still have the same library looking for hfi1_0 problem.

[1] https://patchwork.kernel.org/patch/9508879/

-Denny





