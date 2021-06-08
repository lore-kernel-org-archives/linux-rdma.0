Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 699D7C47082
	for <linux-rdma@archiver.kernel.org>; Tue,  8 Jun 2021 11:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5236061358
	for <linux-rdma@archiver.kernel.org>; Tue,  8 Jun 2021 11:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhFHLhc (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 8 Jun 2021 07:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbhFHLhb (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 8 Jun 2021 07:37:31 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7FEC061574
        for <linux-rdma@vger.kernel.org>; Tue,  8 Jun 2021 04:35:38 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id k25so26580336eja.9
        for <linux-rdma@vger.kernel.org>; Tue, 08 Jun 2021 04:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zXjp+FpsOtApIE597LjCfIEr50rMzuemgJVF8Uee7kE=;
        b=FWrwmGYxW3DpjhHS5G3EbNwSGc/Kr06JX2RAzEchq/hW+LoOsRn/cEi1Xgb4VDukFi
         5B0pjTupwqP5QOS29DP13oaWuNMkNdpMcgnaVTPfEoXT88qGhG/X5waV/VZQVlyusmeo
         tsekUMq28swm3tuLBEOZeiUk+aN/Il9k7cYQV3V9sToeCV6Qbh+1t799MO012YLk+7P0
         XI8mPMuJRAJxESH3P48vwyfJfipvaQOFRZ+FYCjUFkjPbYRp4Ih+ivWce8zPoXnxV3WF
         VkcKI8hU1xiRH9mRCJI0UtaGAfgf1VjHt/D+Llpd+pp+KwNZehqxwCMl2MR2OYxaI1fJ
         Ykhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zXjp+FpsOtApIE597LjCfIEr50rMzuemgJVF8Uee7kE=;
        b=X81KJASutkAmfEd8iDjCGLbXcz66Hx4744kZbJy28BGm+9WhKiPHDHlDIZeBb1IdcH
         jRVh8hvHVeDODGfaonaAbIt1pkPBwxDR/tG4BLJWsOmvCh3VQD1GfASmavlbQiYv73y/
         N4teJnAVPzY+llGLelp8vOxNBioDCKT5712AqsoDJa/mBPoOcXSSE4+hE/RA3ukIcaJW
         T88qWAp6eMkKjV6+Ej/vFQPb3O43O/HZ1JnPWy4YCqywgi+keDcMeD0cvjFZbI7UZGOP
         AMvWv9Oulnsb0ky7YZS/Wk1B8bBD7J088WFC+6AGoxuWMC9DD8F0zR2575iR0IDl4vS2
         sqtA==
X-Gm-Message-State: AOAM5335KKR+S1SJPbcuOlsgpqLOhmT2nzmNJlNECCRbo2ECB9sTbA3E
        ap0p+jYDV8hj0WbgjsNWza4Px+F8ujSXgA==
X-Google-Smtp-Source: ABdhPJxHbcfJznLfAjOVp74PQbLZpsGCUQvxcq/YIGvhfiKIyIk0saTeXEZfFASEZtFgG6yLbKgNfw==
X-Received: by 2002:a17:907:3e26:: with SMTP id hp38mr22328070ejc.451.1623152137323;
        Tue, 08 Jun 2021 04:35:37 -0700 (PDT)
Received: from jwang-Latitude-5491.fkb.profitbricks.net ([2001:16b8:4943:5b00:2927:a608:b264:d770])
        by smtp.gmail.com with ESMTPSA id c7sm7675480ejs.26.2021.06.08.04.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 04:35:37 -0700 (PDT)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     linux-rdma@vger.kernel.org
Cc:     bvanassche@acm.org, leon@kernel.org, dledford@redhat.com,
        jgg@ziepe.ca, haris.iqbal@ionos.com, jinpu.wang@ionos.com,
        axboe@kernel.dk
Subject: [PATCH for-next 0/5] RTRS enable write path fast memory regitration
Date:   Tue,  8 Jun 2021 13:35:31 +0200
Message-Id: <20210608113536.42965-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Hi Jason, hi Doug, hi Jens

Please consider to include following changes to the next merge window.

This enables fast memory registration for write IO patch, so rtrs can
support bigger IO than 116k without splitting. With this in place, both
read/write request are more symmetric, and we can also reduce the memory
usage.

The patchset is orgnized as:
- patch1 preparation.
- patch2 implement fast memory registration for write patch.
- patch3 reduce memory usage.
- patch4 raise MAX_SGEMENTs
- patch5 rnbd-clt to query and use the max_sgements setting.

As the main change is in RTRS, so it's easier to go through RDMA tree, hence
send this patchset to linux-rdma.

This patchset depends on: https://lore.kernel.org/linux-rdma/20210608103039.39080-1-jinpu.wang@ionos.com/T/#t

Jack Wang (5):
  RDMA/rtrs: Introduce head/tail wr
  RDMA/rtrs-clt: Write path fast memory registration
  RDMA/rtrs_clt: Alloc less memory with write path fast memory
    registration
  RDMA/rtrs-clt: Raise MAX_SEGMENTS
  rnbd/rtrs-clt: Query and use max_segments from rtrs-clt.

 drivers/block/rnbd/rnbd-clt.c          |   5 +-
 drivers/block/rnbd/rnbd-clt.h          |   5 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 143 ++++++++++++++++---------
 drivers/infiniband/ulp/rtrs/rtrs-clt.h |   1 +
 drivers/infiniband/ulp/rtrs/rtrs-pri.h |   3 +-
 drivers/infiniband/ulp/rtrs/rtrs.c     |  28 ++---
 drivers/infiniband/ulp/rtrs/rtrs.h     |   2 +-
 7 files changed, 119 insertions(+), 68 deletions(-)

-- 
2.25.1

