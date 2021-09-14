Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 853BDC433EF
	for <linux-rdma@archiver.kernel.org>; Tue, 14 Sep 2021 04:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5914660295
	for <linux-rdma@archiver.kernel.org>; Tue, 14 Sep 2021 04:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhINEXB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 14 Sep 2021 00:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbhINEXB (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 14 Sep 2021 00:23:01 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1206FC061574
        for <linux-rdma@vger.kernel.org>; Mon, 13 Sep 2021 21:21:45 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id w144so17156783oie.13
        for <linux-rdma@vger.kernel.org>; Mon, 13 Sep 2021 21:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=wX1uJC1YI7yo+pDPZ0eAWGs0zhd9YqXeIFeoIaMXbXw=;
        b=hd0zKT2Qj0Nti0aYsOWLY6HRG92if6kHmRSUsfkM2dTzemnzI1Las8HlfzaMOL7LPd
         5+jwqBtMKiot8p3ikLHtea85PM4PRnx5AhJdJ/tkTBzrzbL9KqRuyBWub4MQd+6X4YnC
         XCQQC04j8ac2OOeXmm5Xp4JKOdFYYmJYS/V9bVrvAh0cD58pTmLdyTq1wCnnYiXeCS1O
         nbqieib+n106T6xpioucqNfVOqLQ9ze2xctg7VDYvWf6vD6LnQq0teSUrzo+RDR/QVSF
         c4DExGjrFIAboWvSYlDRVOmo/gMfM1qUz593Ue87xZP4O6W5E9SQXbnXhZKmu8I3sDrY
         RD0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=wX1uJC1YI7yo+pDPZ0eAWGs0zhd9YqXeIFeoIaMXbXw=;
        b=c3YSrbWWmXMihwR5E/3zFsc0Ql58jPDDUU5JD58+F7207vronWiNyrjD2+z/9E8pI6
         YbgC2ZHMvxE8qbGeHkIJftvmTLDghSYhIl24e54IWzfQQlT26cc4Yf5Ao9kIErnhht/s
         gcomRbdFdQu8Z9nCatRp8YSIlU7Jh4TQT4A4aRzZD/0oLcM8lSdWYWSdDZepE8sir6Pg
         yfsn0N+ZCEFKxrhJHzFg8BNqglR1oRhvvnTeOF7aAvBuqdTHWZOSg/yA4J7x1DDcilmn
         ZI7BEHsghwhfhPpj0Z5T2wDQOT9oBiH7K7Z+c5EMNn+cjtIaCTM1u1ScwhXVzYBx2HAc
         mHBQ==
X-Gm-Message-State: AOAM533ASgPE0BxPqOhQ34nXlkcMffelkCo2RZTBGrn0vhyrDJ6/oQGq
        l/w5LEhwVEQN4Gi/YlL9lJw=
X-Google-Smtp-Source: ABdhPJye2tel0Nlj9kCohqdeeH02Je8BQj/ZFfr8+z4SqW5YykQTGqYV5VuifACYJghdIO0zK7008A==
X-Received: by 2002:a05:6808:2116:: with SMTP id r22mr10541996oiw.128.1631593304423;
        Mon, 13 Sep 2021 21:21:44 -0700 (PDT)
Received: from ?IPv6:2603:8081:140c:1a00:d9f3:4e7a:72f1:83fe? (2603-8081-140c-1a00-d9f3-4e7a-72f1-83fe.res6.spectrum.com. [2603:8081:140c:1a00:d9f3:4e7a:72f1:83fe])
        by smtp.gmail.com with ESMTPSA id c37sm2313696otu.60.2021.09.13.21.21.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 21:21:44 -0700 (PDT)
To:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
From:   Bob Pearson <rpearsonhpe@gmail.com>
Subject: _printk not defined???
Message-ID: <82f49163-ef76-ce35-16f5-d0a985ecc3e3@gmail.com>
Date:   Mon, 13 Sep 2021 23:21:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

With 5.15.0-rc1 I am unable to build for-rc because moddep can't find _printk.
Has anyone seen this? I don't use it directly. Just through pr_info, etc.

Bob Pearson
