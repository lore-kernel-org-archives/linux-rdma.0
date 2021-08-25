Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7515C432BE
	for <linux-rdma@archiver.kernel.org>; Wed, 25 Aug 2021 16:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAF0F61040
	for <linux-rdma@archiver.kernel.org>; Wed, 25 Aug 2021 16:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhHYQrr (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 25 Aug 2021 12:47:47 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:46822 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbhHYQrr (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 25 Aug 2021 12:47:47 -0400
Received: by mail-pg1-f182.google.com with SMTP id k14so262217pga.13;
        Wed, 25 Aug 2021 09:47:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1UMuzaedawDrJ7sHnjIktSUIvpk6VsWPkXjY/IRHZ3A=;
        b=KtbaY/c5YIaT+5iv2o9d4PkX6B2Gzlk/6EP42tFvA7rNKo+kRVTo64Okcj7L8J/wmV
         76v+xRIFuIZI3pSl+0GmEddJYtLSIyzMJqZNBqCyV0cnOI2M/IhkJcFuYxZ+EqDdQ7Lb
         2bUyvLzqvJ74xCOltSiKJVPyCI/JLI/mCWQuPgSkLeHNfzsnQ1Dx93nLTbNRSZfxNJg/
         pS2hw+UB6nVWEc7tB9hBv904ExjMI1cCnBKFeffM4f4tmS6zhjRVAM9j1/Ix+ISPSgvB
         tumcPe0zbo4HUVALkLCOp0EDeynQ9K7r/WWyUoY5GAfuBWd/WAczbgemrzT+/bc+9Irh
         mhoQ==
X-Gm-Message-State: AOAM531Qvdz64NKmFRbIpw29Xy594lEZgBnAH2Nek9kz2wS/KYIhQjZB
        eBsueTInOR3XleMAK/g5ksZ8OlEbuyg=
X-Google-Smtp-Source: ABdhPJyZTPqR+r8H7dS3kFtMU4hv76aDbhMxlB5PhIx5PM2s0ws5fZ1E/ns+FyqXq7r+qMqvbFf+kg==
X-Received: by 2002:a63:fc20:: with SMTP id j32mr43007431pgi.283.1629910020302;
        Wed, 25 Aug 2021 09:47:00 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5f7b:5bac:8246:4328])
        by smtp.gmail.com with ESMTPSA id n3sm306936pfo.101.2021.08.25.09.46.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 09:46:59 -0700 (PDT)
Subject: Re: v5.14 RXE driver broken?
To:     Zhu Yanjun <zyjzyj2000@gmail.com>
Cc:     Bob Pearson <rpearsonhpe@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <c3d1a966-b9b0-d015-38ec-86270b5045fc@acm.org>
 <CAD=hENcriq-mwnvzY3UdowuGpKb=Uekvk-v8Lj0G=QB-qK0kJg@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <98fb7274-8563-e54b-3c6d-c99d3f3e68bf@acm.org>
Date:   Wed, 25 Aug 2021 09:46:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAD=hENcriq-mwnvzY3UdowuGpKb=Uekvk-v8Lj0G=QB-qK0kJg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 8/24/21 8:02 PM, Zhu Yanjun wrote:
> On Tue, Aug 24, 2021 at 11:02 AM Bart Van Assche <bvanassche@acm.org> wrote:
>>
>> Hi Bob,
>>
>> If I run the following test against Linus' master branch then that test
>> passes (commit d5ae8d7f85b7 ("Revert "media: dvb header files: move some
>> headers to staging"")):
>>
>> # export use_siw=1 && modprobe brd && (cd blktests && ./check -q srp/002)
>> srp/002 (File I/O on top of multipath concurrently with logout and login (mq)) [passed]
>>      runtime    ...  48.849s
>>
>> The following test fails:
>>
>> # export use_siw= && modprobe brd && (cd blktests && ./check -q srp/002)
>> srp/002 (File I/O on top of multipath concurrently with logout and login (mq)) [failed]
>>      runtime  48.849s  ...  15.024s
>>      --- tests/srp/002.out       2018-09-08 19:43:42.291664821 -0700
>>      +++ /home/bart/software/blktests/results/nodev/srp/002.out.bad      2021-08-23 19:51:05.182958728 -0700
>>      @@ -1,2 +1 @@
>>       Configured SRP target driver
>>      -Passed
> 
> Can this commit "RDMA/rxe: Zero out index member of struct rxe_queue"
> in the link https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/?h=wip/jgg-for-rc
> fix this problem?
> 
> And the commit will be merged into linux upstream very soon.

Hi Zhu,

Thanks for having taken a look.

Isn't commit cc4f596cf85e ("RDMA/rxe: Zero out index member of struct
rxe_queue") already in Linus' tree? I think it was merged yesterday (August
24). Unfortunately the test I mentioned still fails on top of that patch.

Thanks,

Bart.

