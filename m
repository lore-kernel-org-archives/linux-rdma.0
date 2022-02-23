Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1825C433FE
	for <linux-rdma@archiver.kernel.org>; Wed, 23 Feb 2022 09:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238899AbiBWJGj (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 23 Feb 2022 04:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237097AbiBWJGi (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 23 Feb 2022 04:06:38 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8D97E5AB
        for <linux-rdma@vger.kernel.org>; Wed, 23 Feb 2022 01:06:10 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id x16-20020a6bfe10000000b006409f03e39eso8949512ioh.7
        for <linux-rdma@vger.kernel.org>; Wed, 23 Feb 2022 01:06:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=q0YkTxYcpmtaoWpMFdtnx2zx3UAhtCVdK3pizLCnKyI=;
        b=VD1NzhOupJzUYs/HyV90HUvXB6CPh44avjT9YdzzyIOC0npkiHRMjAYkYHqKHvw46e
         mkn8txvFKPXRnTKjoFLEwwzBmvsr7SiAfcG92nMZ4TsQDboKcVEo92LD3psibQitVwcM
         4ZNCypfXkdijrvyeoDl/lUQL6QURiylCYLBMNjDeR+5fQEdyLEQhL35+jww4XHPeZWDu
         3cXpS7BOYT2W91Us84OoJQCC+6NUVhPqcgqUoWRVs+rm4JIHoSUXZwEBsr4zN7SZkgpb
         IIClEmkaaAm1PwKykitZ55hL9rZMZA+9lrJdkEjcUdhTeHaQnz16kjPN4QhSA63rXhR7
         +vgA==
X-Gm-Message-State: AOAM531vympA+d2gakAWx1K/NikuUuNQaD51El511OB1knD3HrKCAaS4
        BtKRruKJAVSZaSDo+UjUw3h5/5CtZgmDk+5fnCRKWGUydshI
X-Google-Smtp-Source: ABdhPJzJkEweWWeg+j5b0mZtgxR+f/2dB4vaw8LqlRiFh1DcQbvw6IRrxVZ95JjTqacAfWQaHM7ymZlNKnITetZjwM497r4/5fbA
MIME-Version: 1.0
X-Received: by 2002:a6b:7d44:0:b0:641:347:477a with SMTP id
 d4-20020a6b7d44000000b006410347477amr11025632ioq.160.1645607170183; Wed, 23
 Feb 2022 01:06:10 -0800 (PST)
Date:   Wed, 23 Feb 2022 01:06:10 -0800
In-Reply-To: <1810329.tdWV9SEqCh@leap>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d1988005d8abc62e@google.com>
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in smc_pnet_apply_ib
From:   syzbot <syzbot+4f322a6d84e991c38775@syzkaller.appspotmail.com>
To:     fmdefrancesco@gmail.com, jgg@ziepe.ca, liangwenpeng@huawei.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        liweihang@huawei.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tonylu@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

net/smc/smc_pnet.h:32:2: error: unknown type name 'mutex'


Tested on:

commit:         5c1ee569 Merge branch 'for-5.17-fixes' of git://git.ke..
git tree:       upstream
dashboard link: https://syzkaller.appspot.com/bug?extid=4f322a6d84e991c38775
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=116231fe700000

