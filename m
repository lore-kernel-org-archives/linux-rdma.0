Return-Path: <SRS0=IbQ/=42=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC037C10F27
	for <linux-rdma@archiver.kernel.org>; Mon,  9 Mar 2020 20:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D05B62465A
	for <linux-rdma@archiver.kernel.org>; Mon,  9 Mar 2020 20:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgCIUUG (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 9 Mar 2020 16:20:06 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:36910 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgCIUUG (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 9 Mar 2020 16:20:06 -0400
Received: by mail-io1-f72.google.com with SMTP id p4so7402000ioo.4
        for <linux-rdma@vger.kernel.org>; Mon, 09 Mar 2020 13:20:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=gyTYavcaeh0FJZVoSDoUf1t6qJ3EWa/zCCs9/HoGRTA=;
        b=GJ8fN3CtHXDy/ZeQt4bDYJFmxINhGcM8uc8D1kmgZtFkdJMtbzFXLNhsrgoMivzhEt
         M8/n4jPGLC/k/f0pa0l+ykfSiqyMP7ib3UdFxJ3T9hB8ZF2rOvUsrQjsIdNxxFU1c2yU
         TUggF7BOEOioChevqop2DuYhmxfqgfhjNfp6h6pdKbiOOleKI/yD1oMlok94aQ85RaU/
         vG+81ZgDiwXg3e9aMT8xmURItH2IT1qTkjjz6Iw4cKWKex0DOqf+8tFbcRHNaUMQT8oP
         3deHifH4SzRoYCdj3jx3yap6elG1oGKWq/6UU3PME8r0Y4Q5nwXU8Z9E3SuDSirCzA9R
         eNcg==
X-Gm-Message-State: ANhLgQ2RKhmchtQzVB+xPB1w/vbgmh9VfIxPIAdrSgm6nQWv6A1wEf1i
        y91MabycZN48mywQLChoDzQ+MI63yNDL8QJVjHPhmdxhSMt+
X-Google-Smtp-Source: ADFU+vtLpDu+/CtlDbPIe7Sj8SmC+jO0L8zvUKvlPaWQgCfWwBFwahCGzUuo1dV8TUz97cepb2d5B4KrdLVs1thpRVK88iWuf9/Q
MIME-Version: 1.0
X-Received: by 2002:a05:6638:618:: with SMTP id g24mr16405705jar.87.1583785204118;
 Mon, 09 Mar 2020 13:20:04 -0700 (PDT)
Date:   Mon, 09 Mar 2020 13:20:04 -0700
In-Reply-To: <20200309172430.GV31668@ziepe.ca>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007dfeb705a071ba51@google.com>
Subject: Re: BUG: corrupted list in _cma_attach_to_dev
From:   syzbot <syzbot+06b50ee4a9bd73e8b89f@syzkaller.appspotmail.com>
To:     chuck.lever@oracle.com, dledford@redhat.com, jgg@ziepe.ca,
        leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, parav@mellanox.com,
        syzkaller-bugs@googlegroups.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger crash:

Reported-and-tested-by: syzbot+06b50ee4a9bd73e8b89f@syzkaller.appspotmail.com

Tested on:

commit:         0aeb3622 RDMA/hns: fix spelling mistake "attatch" -> "atta..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=b58f96e9824c82cb
dashboard link: https://syzkaller.appspot.com/bug?extid=06b50ee4a9bd73e8b89f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Note: testing is done by a robot and is best-effort only.
