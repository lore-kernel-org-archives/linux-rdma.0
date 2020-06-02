Return-Path: <SRS0=kW50=7P=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71DE3C433E1
	for <linux-rdma@archiver.kernel.org>; Tue,  2 Jun 2020 09:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50E0C2072F
	for <linux-rdma@archiver.kernel.org>; Tue,  2 Jun 2020 09:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgFBJpw (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 2 Jun 2020 05:45:52 -0400
Received: from mga03.intel.com ([134.134.136.65]:57489 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbgFBJpw (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 2 Jun 2020 05:45:52 -0400
IronPort-SDR: V2KZU+ZrvMLpaWNMcs4+WJrS/6+9T9hGcNvglLMvLBXIpzdz6xNKJAJ3DyB7Nn8U3BXSNFLfN0
 Mv9UFYF0o82A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2020 02:45:51 -0700
IronPort-SDR: GBrG+F5G1jx/CTfaA23KqXDTULHq5bmL+Kd+eUBrulPbQ9kir//xf+TwlY9tUtxNuQdyZwXE+J
 4m3k7i0X27cA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,463,1583222400"; 
   d="scan'208";a="347353632"
Received: from mhuther1-mobl.ger.corp.intel.com (HELO [10.252.44.107]) ([10.252.44.107])
  by orsmga001.jf.intel.com with ESMTP; 02 Jun 2020 02:45:48 -0700
Subject: Re: [RFC 01/17] dma-fence: add might_sleep annotation to _wait()
To:     =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@intel.com>
References: <20200512085944.222637-1-daniel.vetter@ffwll.ch>
 <20200512085944.222637-2-daniel.vetter@ffwll.ch>
 <0b1c65ec-adc2-9f02-da68-c398cf7ce80b@amd.com>
From:   Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Message-ID: <105c02b5-f18d-cd08-bffa-93033c923365@linux.intel.com>
Date:   Tue, 2 Jun 2020 11:45:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <0b1c65ec-adc2-9f02-da68-c398cf7ce80b@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Op 12-05-2020 om 11:08 schreef Christian König:
> Am 12.05.20 um 10:59 schrieb Daniel Vetter:
>> But only for non-zero timeout, to avoid false positives.
>>
>> One question here is whether the might_sleep should be unconditional,
>> or only for real timeouts. I'm not sure, so went with the more
>> defensive option. But in the interest of locking down the cross-driver
>> dma_fence rules we might want to be more aggressive.
>>
>> Cc: linux-media@vger.kernel.org
>> Cc: linaro-mm-sig@lists.linaro.org
>> Cc: linux-rdma@vger.kernel.org
>> Cc: amd-gfx@lists.freedesktop.org
>> Cc: intel-gfx@lists.freedesktop.org
>> Cc: Chris Wilson <chris@chris-wilson.co.uk>
>> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
>> Cc: Christian König <christian.koenig@amd.com>
>> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
>> ---
>>   drivers/dma-buf/dma-fence.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
>> index 052a41e2451c..6802125349fb 100644
>> --- a/drivers/dma-buf/dma-fence.c
>> +++ b/drivers/dma-buf/dma-fence.c
>> @@ -208,6 +208,9 @@ dma_fence_wait_timeout(struct dma_fence *fence, bool intr, signed long timeout)
>>       if (WARN_ON(timeout < 0))
>>           return -EINVAL;
>>   +    if (timeout > 0)
>> +        might_sleep();
>> +
>
> I would rather like to see might_sleep() called here all the time even with timeout==0.
>
> IIRC I removed the code in TTM abusing this in atomic context quite a while ago, but could be that some leaked in again or it is called in atomic context elsewhere as well. 


Same, glad I'm not the only one who wants it. :)

~Maarten

