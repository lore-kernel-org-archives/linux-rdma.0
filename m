Return-Path: <SRS0=7qKe=CF=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6257FC433DF
	for <linux-rdma@archiver.kernel.org>; Thu, 27 Aug 2020 16:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DFB82177B
	for <linux-rdma@archiver.kernel.org>; Thu, 27 Aug 2020 16:43:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YVuwm6B0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgH0Qnn (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 27 Aug 2020 12:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgH0Qnn (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 27 Aug 2020 12:43:43 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9334C061264
        for <linux-rdma@vger.kernel.org>; Thu, 27 Aug 2020 09:43:42 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id j21so5139780oii.10
        for <linux-rdma@vger.kernel.org>; Thu, 27 Aug 2020 09:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dpLfExUsnx/jfmeJI3q6ngQ1pPrlEUrmQjKYc1Vycn0=;
        b=YVuwm6B0VAsT/XxHNO4114tePWz7wcy3Qo2CN2DXOVZI4OBQZ9ieQPIlvAhs+/BPd2
         IHWdCm11TYZq9etNl8pnDMEC0OaRpjgNfAlVuPukRFkzozluHH3huxNdOFb3MckQ75Nv
         bAbGGQrSDWsTNEZYkXCEsBP4UYYs2vXZmznfECeJb6AXdu3OmunKnexmeA4DwvjOE9sz
         8lWfUg+MskQUS9FbfmcYv5F2LbGpbPO9fJI5lG70t/raQjzH704zLF45LDqtn3RQGHpV
         pbFqYwOFp41Iv14TnvHOyyQ1cdOunZgfQvwP3Q3+xzXJ+fbqsY5x4cjIleMFHay4mLkg
         swOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dpLfExUsnx/jfmeJI3q6ngQ1pPrlEUrmQjKYc1Vycn0=;
        b=kDKTXdQ/Fo2Mm/N/qwifONXqhKKy1MspEPL29CbPsDzNUa93Y0ZputZXWGcgB4SUSg
         +BJf+6reCBmFKyHk6MphlfgVSEiWurlLvlmfYiVCebkMZgUCaGONmBaS8BtvraPlHTQ+
         c9g26z2Av4ucTcgg7/p0g8v2fWgPFW2NhZNi2aCUYppbOYWdujQpetQGce7aRbO5RSTB
         Ljq6LQilhG/1L4iiBGpUs15VfAAB3BWFmuVgSTH4u/m5OrjldfUhFoS6SGXYqiEm5IhP
         pF4j+7YaaSdtIhAX6azm2S+UBqD6368xR5M2bpX+oPLlcvSVDsEjIgjwTwZ5v3BAsVn/
         FYPw==
X-Gm-Message-State: AOAM531ZoFcNxqm5wjq6pTww5zYJalkBbII2LJ4UBJmewRShTV9DyG8L
        6htcTerpoEf3ukgk/rhhCVA=
X-Google-Smtp-Source: ABdhPJzXuZCOpqpWptbWPfF7Vz90yKy9ECnhzlp4aHYbJLH++WPbGLPzS5Bo0W6DpwFo9M0X5j2MFQ==
X-Received: by 2002:aca:480f:: with SMTP id v15mr3752847oia.45.1598546622070;
        Thu, 27 Aug 2020 09:43:42 -0700 (PDT)
Received: from ?IPv6:2605:6000:8b03:f000:4872:b571:a2a4:b341? ([2605:6000:8b03:f000:4872:b571:a2a4:b341])
        by smtp.gmail.com with ESMTPSA id i10sm549958oie.42.2020.08.27.09.43.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 09:43:41 -0700 (PDT)
Subject: Re: [PATCH for-next] rdma_rxe: address an issue with hardened user
 copy
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     leon@kernel.org, zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org,
        Bob Pearson <rpearson@hpe.com>
References: <20200825165836.27477-1-rpearson@hpe.com>
 <20200827135841.GA4033418@nvidia.com>
From:   Bob Pearson <rpearsonhpe@gmail.com>
Message-ID: <8f23b006-f117-0780-81d7-fb272ae5b69a@gmail.com>
Date:   Thu, 27 Aug 2020 11:43:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200827135841.GA4033418@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 8/27/20 8:58 AM, Jason Gunthorpe wrote:
> On Tue, Aug 25, 2020 at 11:58:37AM -0500, Bob Pearson wrote:
>> Change rxe pools to use kzalloc instead of kmem_cache to allocate
>> memory for rxe objects.
>>
>> Signed-off-by: Bob Pearson <rpearson@hpe.com>
>>  drivers/infiniband/sw/rxe/rxe.c      |  8 ----
>>  drivers/infiniband/sw/rxe/rxe_pool.c | 60 +---------------------------
>>  drivers/infiniband/sw/rxe/rxe_pool.h |  7 ----
>>  3 files changed, 2 insertions(+), 73 deletions(-)
> 
> It doesn't apply:
> 
> Applying: rdma_rxe: address an issue with hardened user copy
> error: sha1 information is lacking or useless (drivers/infiniband/sw/rxe/rxe.c).
> error: could not build fake ancestor
> Patch failed at 0001 rdma_rxe: address an issue with hardened user copy
> hint: Use 'git am --show-current-patch=diff' to see the failed patch
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".
> 
> Pleae generate patches against a v5.x tag or rdma for-next
> 
> Jason
> 
I fixed it and sent it again.

Applies to today's for-next branch. It is independent from the SPDX patch but the line numbers will move a bunch. Hope that doesn't break it.
