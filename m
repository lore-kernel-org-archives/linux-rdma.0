Return-Path: <SRS0=5X+a=6C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 342C5C38A30
	for <linux-rdma@archiver.kernel.org>; Sat, 18 Apr 2020 23:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0888A21BE5
	for <linux-rdma@archiver.kernel.org>; Sat, 18 Apr 2020 23:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbgDRXi2 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 18 Apr 2020 19:38:28 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:55449 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgDRXi2 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 18 Apr 2020 19:38:28 -0400
Received: by mail-pj1-f68.google.com with SMTP id a32so2894443pje.5;
        Sat, 18 Apr 2020 16:38:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qZ7CqCDZFa/a0tejdHN9Qn5utmAu/OF2XVMapCkurf8=;
        b=Qv/CPB8YzB6C0HrzmV0qOuhEtDrIBmGWdEHkUBKHzcyiZlksCdhCpk/pTbS8SUGEOQ
         5sGlgNxYceCDlTFVzenP530BG/QYkMW1vTre3DLssvf6YNhHt3LiFx9Kj5bZR7Y8s1mP
         YoR/T1tUyc64DfDGi/Yx+4vTJSGLGGgToZVHoME6OjTuNfJxxl9eexz6aVkumG6JslY3
         8Ra7xODitjchIRLyEfpKPXoUdrfRT+ehUqFQ5xw7dMGJDxAwLlsSBlUKT099KnirXTKw
         uVJoRnMPYyKKKLut8fKwGOvgvPr5KXSqNFcWmDyNLot5Cb0ILBismTTyyYPvjXK3RlM0
         NC2w==
X-Gm-Message-State: AGi0PuZJWbZ0pSoJPMEZuPrE/72cnZexlOjTfrmcWZ7BbrdPOdNw+JEA
        bP6DHWtkoV8zZpwNBMJ7Deg=
X-Google-Smtp-Source: APiQypKPdUoQJ1jULBNSvpDNjpbP66fDFlI+XlMMaXwai6HoE5NkaZlgub4Py4RuCF1fgi88K/h4BA==
X-Received: by 2002:a17:902:be0b:: with SMTP id r11mr1234827pls.310.1587253107495;
        Sat, 18 Apr 2020 16:38:27 -0700 (PDT)
Received: from [100.124.15.238] ([104.129.199.8])
        by smtp.gmail.com with ESMTPSA id g40sm9595153pje.38.2020.04.18.16.38.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 16:38:26 -0700 (PDT)
Subject: Re: [PATCH v12 21/25] block/rnbd: server: functionality for IO
 submission to block dev
To:     Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
Cc:     axboe@kernel.dk, hch@infradead.org, sagi@grimberg.me,
        leon@kernel.org, dledford@redhat.com, jgg@ziepe.ca,
        jinpu.wang@cloud.ionos.com, pankaj.gupta@cloud.ionos.com
References: <20200415092045.4729-1-danil.kipnis@cloud.ionos.com>
 <20200415092045.4729-22-danil.kipnis@cloud.ionos.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d4603c67-ba0c-bb33-51cd-ef454bbb097c@acm.org>
Date:   Sat, 18 Apr 2020 16:38:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200415092045.4729-22-danil.kipnis@cloud.ionos.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 4/15/20 2:20 AM, Danil Kipnis wrote:
> This provides helper functions for IO submission to block dev.

Should "submission" in the patch subject perhaps be changed into 
"submitting"?

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
