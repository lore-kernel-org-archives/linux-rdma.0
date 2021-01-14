Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86229C4332E
	for <linux-rdma@archiver.kernel.org>; Thu, 14 Jan 2021 01:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C924206C0
	for <linux-rdma@archiver.kernel.org>; Thu, 14 Jan 2021 01:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbhANAJB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 13 Jan 2021 19:09:01 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:36607 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729769AbhANAHm (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 13 Jan 2021 19:07:42 -0500
Received: by mail-wr1-f49.google.com with SMTP id t16so3957292wra.3
        for <linux-rdma@vger.kernel.org>; Wed, 13 Jan 2021 16:07:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=ATDZN0WpI8iQ0XdHQo0HCtH54HCpCqOK0Ak6zwQ9dR9frrBcxK28sPoEAybhLWZRRo
         ikrddh4sUoyQVyJdZpqGBVYm5VPkd0l72n4o/z68X4EdUg63LA+hLIqrS47y/CZFh6cH
         wEfhR84H2Fvc+kYJ+GVNSh+6m2G8nHeukdMnK5pwMY+ML1Dl+8uel/GTOGGafASyr2+T
         53Q/8iT9vWp95T5NkTIzd5PAvRKbhclxWBUHZnyASP28SxuFhqmqLpmYSkY5Ok3MwA1t
         nsJHfZswbIoj+1MM8zYNG5a3ALBicB7KTljzdGhIgnOXQ5Sxd80emLMnBX/ed5ABGUIb
         5M8A==
X-Gm-Message-State: AOAM531QP9UmbO6HQF0s+Z417kgNfck1GfiwdpnqIiDc9Vtk7nTs92Fn
        1aGMRcI9TlK9lWGH2OUeMOc=
X-Google-Smtp-Source: ABdhPJw6g2FWib81UhHqE9FxGZmQd7EwNZzXxaCMHqxFqNLrhSQnnilYG5WZbF9GjC9nWN9/V1UCPw==
X-Received: by 2002:a5d:674c:: with SMTP id l12mr4909730wrw.399.1610582820629;
        Wed, 13 Jan 2021 16:07:00 -0800 (PST)
Received: from ?IPv6:2601:647:4802:9070:e70c:620a:4d8a:b988? ([2601:647:4802:9070:e70c:620a:4d8a:b988])
        by smtp.gmail.com with ESMTPSA id t16sm5309534wmi.3.2021.01.13.16.06.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 16:07:00 -0800 (PST)
Subject: Re: [PATCH 1/3] IB/isert: remove unneeded new lines
To:     Max Gurtovoy <mgurtovoy@nvidia.com>, linux-rdma@vger.kernel.org,
        dledford@redhat.com, jgg@nvidia.com, leonro@nvidia.com
Cc:     oren@nvidia.com, Israel Rukshin <israelr@nvidia.com>
References: <20210110111903.486681-1-mgurtovoy@nvidia.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <cffaba7b-dd9c-1ae0-d419-cc2f09ae4731@grimberg.me>
Date:   Wed, 13 Jan 2021 16:06:56 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210110111903.486681-1-mgurtovoy@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
