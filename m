Return-Path: <SRS0=kLQv=CM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE5DC433E2
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Sep 2020 22:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 425BE20767
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Sep 2020 22:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgICWSu (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 3 Sep 2020 18:18:50 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36037 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728484AbgICWSu (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 3 Sep 2020 18:18:50 -0400
Received: by mail-wm1-f68.google.com with SMTP id z9so4350449wmk.1;
        Thu, 03 Sep 2020 15:18:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9nPeSBhv5CPJdX5Nx81LnVH6ZSc0jJOwp88awu1bp/w=;
        b=ThJRMT43f24a+hQocuQiukcoUTv6gxV2CjpgNEy9iZANDBc/7LzfIkgWIb3b+UtWJL
         yZGz6YaDa+zq3SFS2dPMpodNF13bCvL4I3lswiN23H+hE3igqzDPKDRWm280I3pBY1tH
         2L4fp059tQlUlAY+48OLyWBBdiqEziSkgrylGX7sU1+LEV0d0IV2ISYQUM78mcoqhaQP
         Ne17tZw3J8Si7i3JSaeJ8KMKncYduYoTbhmGJx3fgljvi9l/KIgWtkkWqHKWMPFZdCZl
         xkpwZBDN8/1Y5pPrzcwMkNJFBxTIvnxRBhLjUxo/t5lM00Cio7NJa+f/yJDfotnml2SN
         lwVA==
X-Gm-Message-State: AOAM532T3fFEHlw/6gpjXL/azZApG2qGNAxLqkMX3EVgbbx8ifNb7vbx
        SRz9GzK13CEm/lqicfiGUFxm/i/abdVJ/w==
X-Google-Smtp-Source: ABdhPJzS2Cwp0iSsvn2wAWDvgx+OYMuIMxe8Bw62jIiWMzPvA8yJKVTFUscKH2jaOLZn69hV/+LR0w==
X-Received: by 2002:a05:600c:2257:: with SMTP id a23mr4755130wmm.102.1599171527911;
        Thu, 03 Sep 2020 15:18:47 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:79a5:e112:bd7c:4b29? ([2601:647:4802:9070:79a5:e112:bd7c:4b29])
        by smtp.gmail.com with ESMTPSA id i26sm7120631wmb.17.2020.09.03.15.18.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 15:18:47 -0700 (PDT)
Subject: Re: [RFC] Reliable Multicast on top of RTRS
To:     Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        linux-rdma@vger.kernel.org, linux-block@vger.kernel.org
References: <CAHg0Huzvhg7ZizbCGQyyVNdnAWmQCsypRWvdBzm0GWwPzXD0dw@mail.gmail.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <5438d63e-0879-1d7b-cac1-f20fa24ecedb@grimberg.me>
Date:   Thu, 3 Sep 2020 15:18:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHg0Huzvhg7ZizbCGQyyVNdnAWmQCsypRWvdBzm0GWwPzXD0dw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


> Hi @,
> 
> RTRS allows for reliable transmission of sg lists between two hosts
> over rdma. It is optimised for block io. One can implement a client
> and a server module on top of RTRS which would allow for reliable
> transmission to a group of hosts.
> 
> In the networking world this is called reliable multicast. I think one
> can say that reliable multicast is an equivalent to what is called
> "mirror" in the storage world.

md-raid1

> There is something called XoR network
> coding which seems to be an equivalent of raid5.

md-raid5

> There is also Reed
> Solomon network coding.
> 
> Having a reliable multicast with coding rdma-based transport layer
> would allow for very flexible and scalable designs of distributed
> replication solutions based on different in-kernel transport, block
> and replication drivers.
> 
> What do you think?

You should probably use the device-mapper stack or modify it to fit your
needs.
