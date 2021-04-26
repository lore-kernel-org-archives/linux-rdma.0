Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73961C433ED
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Apr 2021 15:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FF9861078
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Apr 2021 15:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbhDZPhQ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 26 Apr 2021 11:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234120AbhDZPhN (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 26 Apr 2021 11:37:13 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819FAC061574
        for <linux-rdma@vger.kernel.org>; Mon, 26 Apr 2021 08:36:31 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id o21-20020a1c4d150000b029012e52898006so5319821wmh.0
        for <linux-rdma@vger.kernel.org>; Mon, 26 Apr 2021 08:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:reply-to:mime-version
         :content-transfer-encoding;
        bh=bF32FarLk9CvB1PlUh76DjVB3351BBftSmi5xzTQHpw=;
        b=WiHuatv3oYU3qdSsDzzQH1TDV3Tkp9qtRqXw3+6CXHU9M5oL4l6JtYaF/psxydtaLZ
         QcTtd82McF9bLHpafHyZrphFp32RRlcOVNYd+aPd+HB0KkDptCm2kPNxeo4FpHM/WLwd
         O/0Y1UiEhr9Qo6O0KyM3PDrmGB/OHVyBqD+JRHN+4gB3LTcTKy3ekGkaxQ/U/AI5HeuZ
         J93cXcFS2/mHLcW2RhRas/2Tti2rrwkx2WcCyrQ42ax5P9Qf+m0VhkLkY+tCoNGz3QZk
         RvhNbQZcMyaxM3oibspkLWdEn/OT7G/6hFTQhqWcpIZZxY4BssBvGobDnzNuwTxdlPbo
         XKZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :mime-version:content-transfer-encoding;
        bh=bF32FarLk9CvB1PlUh76DjVB3351BBftSmi5xzTQHpw=;
        b=CzEZE9/0zEHUpuotyrQSBC4ClKDJ+hQ9JfIZKbO/Ll5EFBvSd3r4iAKRl5w1DqahNq
         TVX8Sb/UAwTwO9DcJeOM+7pPHpNoTuDSP5S3S1bBeA/mhgHEV/NZyUXHFuxk+GuxaBn9
         vSGXU8Fgf5yD18k3Gac6gfW6tSimGXMqkCkRViG9e9qeMokXo0chTz5aBzVgNFQCQlA2
         TDMI6TlRNeF+XRMrK82hlLbG/o+Zidks8fYy8GJp9AM0i1xY0F4rAh+gz1jucwIQoTjz
         Bba7E4YYlfCd0+PqwvrIA6rdLeiCIZPgPwJvTlNouFhYJ2U2eCNsgirTuro5V15AI0fv
         9XQQ==
X-Gm-Message-State: AOAM532D8cqggDQiojkL2EdST5FDnXe/HU8rm1kPnnZ9CKPGnoVeXXtx
        5YLTChFVwFr+brG9lQieoEpac/P5rxtul/Fk
X-Google-Smtp-Source: ABdhPJzWF2R6Qog92ygaLxZCPwAHalyjm11c7/WNiZ8Dl2u9qWH+HutgmGKj+8W+jzNuOqqdf6SfEw==
X-Received: by 2002:a1c:9854:: with SMTP id a81mr3223188wme.90.1619451390225;
        Mon, 26 Apr 2021 08:36:30 -0700 (PDT)
Received: from localhost (ip5b401b0e.dynamic.kabel-deutschland.de. [91.64.27.14])
        by smtp.gmail.com with ESMTPSA id p18sm425948wrs.68.2021.04.26.08.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 08:36:29 -0700 (PDT)
From:   Benjamin Drung <benjamin.drung@ionos.com>
To:     linux-rdma@vger.kernel.org
Cc:     Benjamin Drung <benjamin.drung@ionos.com>
Subject: [PATCH rdma-core] README: Document supported Debian/Ubuntu releases
Date:   Mon, 26 Apr 2021 17:36:27 +0200
Message-Id: <20210426153627.444061-1-benjamin.drung@ionos.com>
X-Mailer: git-send-email 2.27.0
Reply-To: 20210426124902.GJ2047089@ziepe.ca
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The Debian package in Debian testing/unstable uses a newer debhelper
versions and drops the debug symbol migration. Document which Debian and
Ubuntu release are supported to ensure that the Debian packaging for the
upstream project does not drop support for those old releases.

Signed-off-by: Benjamin Drung <benjamin.drung@ionos.com>
---
 README.md | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/README.md b/README.md
index b649c6f2..48113de7 100644
--- a/README.md
+++ b/README.md
@@ -55,6 +55,11 @@ only load from the system path.
 $ apt-get install build-essential cmake gcc libudev-dev libnl-3-dev libnl-route-3-dev ninja-build pkg-config valgrind python3-dev cython3 python3-docutils pandoc
 ```
 
+Supported releases:
+
+* Debian 9 (stretch) or newer
+* Ubuntu 16.04 LTS (xenial) or newer
+
 ### Fedora
 
 ```sh
-- 
2.27.0

