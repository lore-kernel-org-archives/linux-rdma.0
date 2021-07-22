Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC903C4338F
	for <linux-rdma@archiver.kernel.org>; Thu, 22 Jul 2021 19:54:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A223E60EB5
	for <linux-rdma@archiver.kernel.org>; Thu, 22 Jul 2021 19:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbhGVTN5 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 22 Jul 2021 15:13:57 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:36682 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhGVTN5 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 22 Jul 2021 15:13:57 -0400
Received: by mail-wm1-f46.google.com with SMTP id l11-20020a7bc34b0000b029021f84fcaf75so2240862wmj.1
        for <linux-rdma@vger.kernel.org>; Thu, 22 Jul 2021 12:54:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3JobQHdK18zGQ2iPygAVP81myTdaAVg9uL/XgSOhojs=;
        b=uVzQWg5rV/kaXg4puluElyxZ7leuVI+9mV+O4wezI5i2lyS2oG/wimveIHxLwE1/oN
         oPtlCs0vxQAemW8KWA7ER2PtrC68NDLxCTKs5KyQ/1InT8YP7+1WIHOJHqDZfTKkvLZw
         W8qFn9UbRqrp3GixD31AKiHMzL+YGbVTuvmngM50ZCTEOw4tHH3GMzNrv8W95qaQXiqb
         5vz2lUAcAWeyYDL68AZMAJl0hsh7QqOdq7BUvQCvzmr/YpbAWIM9989EyvBcbttEj2MM
         J2A1Dwdu+Dzl3d7W0J8UNvpX4w+jEzOgMI8tPkYhMPBtyyfXW3MAK6NcoFK8LbEjDVLO
         BCnA==
X-Gm-Message-State: AOAM5304C2VycECQ5fBR5opdj+G6PquAoJJCMjUZaFubFVepo+OD+bTo
        PwISK3atiII3UQMG9MdvMUE=
X-Google-Smtp-Source: ABdhPJyalpwun3u6lm9He/Bt6VhnCaGIOSe5Q4bRHpM1ASzA+gXInPIiW5GRS1Xf6cL20pXZHml9rQ==
X-Received: by 2002:a7b:c30f:: with SMTP id k15mr10844062wmj.128.1626983671199;
        Thu, 22 Jul 2021 12:54:31 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:b070:1d59:88d7:1405? ([2601:647:4802:9070:b070:1d59:88d7:1405])
        by smtp.gmail.com with ESMTPSA id w8sm19470155wrk.10.2021.07.22.12.54.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 12:54:30 -0700 (PDT)
Subject: Re: [PATCH 1/1] iser-target: Fix handling of
 RDMA_CV_EVENT_ADDR_CHANGE
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Chesnokov Gleb <Chesnokov.G@raidix.com>,
        "lanevdenoche@gmail.com" <lanevdenoche@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>
References: <20210714182646.112181-1-Chesnokov.G@raidix.com>
 <20210719121302.GA1048368@nvidia.com>
 <2ea098b2bbfc4f5c9e9b590804e0dcb5@raidix.com>
 <0e6e8da9-5d14-92ef-39d9-99d7a0792f62@grimberg.me>
 <20210722142346.GL1117491@nvidia.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <d7cba69f-42f1-c86e-8c01-9ddba87332e8@grimberg.me>
Date:   Thu, 22 Jul 2021 12:54:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210722142346.GL1117491@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


>>>> What is this trying to do anyhow? If the addr has truely changed why
>>>> does the bind fail?
>>>
>>> When the active physical link member of bonding interface in active-standby
>>> mode gets faulty, the standby link will represent the assigned addresses on
>>> behalf of the active link.
>>> Therefore, RDMA communication manager will notify iSER target with
>>> RDMA_CM_EVENT_ADDR_CHANGE.
>>
>> Ah, here is my recollection...
>>
>> However I think that if we move that into a work, we should do it
>> periodically until we succeed or until the endpoint is torn down so
>> we can handle address removed and restore use-cases.
> 
> That soudns better, but still I would say this shouldn't even happen
> in the first place, check the address and don't initiate rebinding if
> it hasn't changed.

But don't you need to setup a new cm_id for the this notification? It
will remain active?

Also it's a bit cumbersome to match addresses in some cases like multi
address interfaces. Almost seems easier to setup a new one...
