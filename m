Return-Path: <SRS0=E0T5=XV=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6318AC4360C
	for <linux-rdma@archiver.kernel.org>; Thu, 26 Sep 2019 14:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35E2A222C3
	for <linux-rdma@archiver.kernel.org>; Thu, 26 Sep 2019 14:11:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kVrWy9e1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfIZOLA (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 26 Sep 2019 10:11:00 -0400
Received: from mail-qk1-f179.google.com ([209.85.222.179]:35450 "EHLO
        mail-qk1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbfIZOLA (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 26 Sep 2019 10:11:00 -0400
Received: by mail-qk1-f179.google.com with SMTP id w2so1891029qkf.2
        for <linux-rdma@vger.kernel.org>; Thu, 26 Sep 2019 07:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=ejn3RQBiavyROlimpLJDnLpgq/dCHOCk1q08JU+5Qhs=;
        b=kVrWy9e1xdghfuqabOqJes4od9a6aOH5pyFqZjZeiMG2cq0D9WvtmOKqyzvQ45c9qw
         syXPSJuYOFfOcl7gqain3cm1zxKnjclIDaJnNFInv+NiFqVmErCmRZBhjaZsByTaMzjk
         v5yXWfVlxTBa2z9veqDaBRwNw8aFbMYKrxbyx9Hqp9oKJ4LHGxpdSzKT4S3iCvAtxOWz
         tDU4+CiVn9M5fWZGzdRkB/y3icl91dD7w6ZlO6iUWMqXO17ixdJOfGDzYkMgNDZpoDh9
         +psxpcwyJzMvsnqDDXlM3fGkKfsySH7wt1lAWzQ7L6XY+wa8P2t70hor1nPmVlzDQuwn
         a2UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=ejn3RQBiavyROlimpLJDnLpgq/dCHOCk1q08JU+5Qhs=;
        b=kDXWIivopSZ2yPuRQP9gpUiJ71yLnfiCJ3VjU5jyzhyxvX8TBbWy7X+WO6HETmGiBG
         QnGxkjmLB9kBBkwME2iEMGCVLAgNMky/qxzVitoqi/8e9r/go39heHPadyQOhENQyFPA
         slR+U6t1NpitOI1Ez9TActvPT2nffY5a29hQH0+DQp/0EsPl/e59hRnIPNYry8GpJRhU
         UpzlR9p6E10owX9Z4y4VLepSJVzlA0IHO22T44XKnNUvWzV8aXTjPftiElFtOcU9DxpH
         cfvmrrRRhR2GINXnPWvik6VVazbErLASW2oUYyRYgXE98dEWmWZKtaX20SO20Um9OuA9
         arvg==
X-Gm-Message-State: APjAAAWWMwUB2hpWKkdpdjMa5jWTRbo3Z7LbU622ifARIKQbY0ripgOw
        E1XXzZ0sxDdQOciHyuAigTQ=
X-Google-Smtp-Source: APXvYqznYypVcYAhI1bH5G/MIaXA2MsXWgDzNu8RTRhrNTfJwEYVizzqtxM4dQuzVqijM4v/d0eZoQ==
X-Received: by 2002:a37:be87:: with SMTP id o129mr3482461qkf.254.1569507059167;
        Thu, 26 Sep 2019 07:10:59 -0700 (PDT)
Received: from [10.48.108.64] (DATADIRECT.bear1.Baltimore1.Level3.net. [4.34.0.142])
        by smtp.gmail.com with ESMTPSA id o52sm1339891qtf.56.2019.09.26.07.10.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 07:10:58 -0700 (PDT)
From:   Karandeep Chahal <karandeepchahal@gmail.com>
Subject: SRP subnet timeout
To:     linux-rdma@vger.kernel.org
Cc:     bart.vanassche@wdc.com
Message-ID: <25ca594d-cb80-2796-01f3-50c40155b4de@gmail.com>
Date:   Thu, 26 Sep 2019 10:10:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi All,

I am wondering why SRP REQ CM timeout is "subnet_timeout + 2". What was the
reason behind adding 2 to the subnet timeout? I think it was added by Bart
in commit 4c532d6ce14bb3fb4e1cb2d29fafdd7d6bded51c, but the commit message
does not explain why the 2 is necessary. Would anyone happen to know?

My understanding is that adding 2 causes the CM timeout value to become 
4 times
the subnet_timeout value. Hence, even if you have a reasonable 
subnet_timeout
the CM REQ timeout becomes too high.

Thank
-Karan
