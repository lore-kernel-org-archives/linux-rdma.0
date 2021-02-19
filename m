Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA43C433E0
	for <linux-rdma@archiver.kernel.org>; Fri, 19 Feb 2021 23:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40FC564E28
	for <linux-rdma@archiver.kernel.org>; Fri, 19 Feb 2021 23:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhBSXcz (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 19 Feb 2021 18:32:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhBSXcy (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 19 Feb 2021 18:32:54 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13B8C061574;
        Fri, 19 Feb 2021 15:32:28 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id e15so5209995qte.9;
        Fri, 19 Feb 2021 15:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NbsiN2mOIgFrYHoicdtwfPgIlAbigIWiM/ybhi0WMds=;
        b=DdFaizl54sLru+iLJVV5msd7jTcBPmRjPcoIO7Siisb17Msir48LZeQJfdTyFAsNHp
         uYeMd2Am9QkntpRCNEI66FN3zQCSwEba58N8ixzNMf4qlm7YpPMpDBAscJqEz7jT/goj
         o6NDvzSd7rfzBhvdfbDE3JgkObYY2bxnT0QlAjDTqCkdzGva6dbPNadAw4JHKRKQFJL+
         plLUPgG1vgJjjtIYMOJYJ1FOAwpdlcVR1G5VMAlwl0koraTQ1QnbRTZNxO/9TMBvxgCD
         xNkKnLhEXRIl9KIHaMIxQ0tNTs9vXwWa3+pAbU3oC+nzy13z3x1lZY4+eCfgGbt8qTLY
         YdgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=NbsiN2mOIgFrYHoicdtwfPgIlAbigIWiM/ybhi0WMds=;
        b=JTaTHOCW662++5oVrjbkrm69bKtoeRcACc0i/XVHezHjamRe2W4/ix4j1btRhpjj7e
         esRvLWyGo1ZC7zueUQnmDGFqhlRt+SjBg/qMG6C0Yospb46w1hjQE3zo0kv2gqSyDZT9
         NiSSzwMXzstEWg5UISZfH+R3JY7Qo728mJgp3+pGp1L5ypABApHBQxzZ/gfssWrVY43C
         z66/Dv9PdtKXxJt7dHsJmQNOxaW5o08Cj23cJU5xQVz8MQNghFb2Q/bbLmm0xCOhVcHa
         iQdUFmDOJmNm8x0rtfYrWN0FSHKZ3sj9EW1fTg/dvehJzY0XMtVqQUBHYiSeiKKXqRbi
         8jGg==
X-Gm-Message-State: AOAM5321eHS30a4YgLi8+KviC6Ma+74MwWNWveJyfYzwof8Vg4KajCT6
        wLELXkPvW5x2FroyDGF+Thg=
X-Google-Smtp-Source: ABdhPJwFOuVQKvHVIRi+7JqxGldbjMafENc3bpZW4wnTxNZ5b4iWrZYYbiP5t0QGGflSbfS02NGG3g==
X-Received: by 2002:ac8:6f06:: with SMTP id g6mr11083280qtv.360.1613777547936;
        Fri, 19 Feb 2021 15:32:27 -0800 (PST)
Received: from ubuntu-mate-laptop.localnet ([208.64.158.253])
        by smtp.gmail.com with ESMTPSA id 199sm7761763qkj.9.2021.02.19.15.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 15:32:27 -0800 (PST)
Sender: Julian Braha <julian.braha@gmail.com>
From:   Julian Braha <julianbraha@gmail.com>
To:     dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: infiniband: sw: rxe: fix kconfig dependency on CRYPTO
Date:   Fri, 19 Feb 2021 18:32:26 -0500
Message-ID: <21525878.NYvzQUHefP@ubuntu-mate-laptop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

commit 6e61907779ba99af785f5b2397a84077c289888a
Author: Julian Braha <julianbraha@gmail.com>
Date:   Fri Feb 19 18:20:57 2021 -0500

    drivers: infiniband: sw: rxe: fix kconfig dependency on CRYPTO
    
    When RDMA_RXE is enabled and CRYPTO is disabled,
    Kbuild gives the following warning:
    
    WARNING: unmet direct dependencies detected for CRYPTO_CRC32
      Depends on [n]: CRYPTO [=n]
      Selected by [y]:
      - RDMA_RXE [=y] && (INFINIBAND_USER_ACCESS [=y] || !INFINIBAND_USER_ACCESS [=y]) && INET [=y] && PCI [=y] && INFINIBAND [=y] && INFINIBAND_VIRT_DMA [=y]
    
    This is because RDMA_RXE selects CRYPTO_CRC32,
    without depending on or selecting CRYPTO, despite that config option
    being subordinate to CRYPTO.
    
    Signed-off-by: Julian Braha <julianbraha@gmail.com>

diff --git a/drivers/infiniband/sw/rxe/Kconfig b/drivers/infiniband/sw/rxe/Kconfig
index 452149066792..06b8dc5093f7 100644
--- a/drivers/infiniband/sw/rxe/Kconfig
+++ b/drivers/infiniband/sw/rxe/Kconfig
@@ -4,6 +4,7 @@ config RDMA_RXE
        depends on INET && PCI && INFINIBAND
        depends on INFINIBAND_VIRT_DMA
        select NET_UDP_TUNNEL
+      select CRYPTO
        select CRYPTO_CRC32
        help
        This driver implements the InfiniBand RDMA transport over



