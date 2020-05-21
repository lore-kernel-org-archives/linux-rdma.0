Return-Path: <SRS0=17PT=7D=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A05C433DF
	for <linux-rdma@archiver.kernel.org>; Thu, 21 May 2020 17:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D956020759
	for <linux-rdma@archiver.kernel.org>; Thu, 21 May 2020 17:50:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="XZTMa4cm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgEURu7 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 21 May 2020 13:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728022AbgEURu6 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 21 May 2020 13:50:58 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0110FC061A0E
        for <linux-rdma@vger.kernel.org>; Thu, 21 May 2020 10:50:58 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id f13so6647782edr.13
        for <linux-rdma@vger.kernel.org>; Thu, 21 May 2020 10:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c5hk+YvDF+HNcyf9r7puwjNVcCKeuusQ28Ivdswl/wY=;
        b=XZTMa4cmZBy3IafYJoqtED2R8GeVsYhpNul9KMyfu2JfcqXxrLTDs763L54yDeTfbe
         yn9XviBnQKTkOJ6MkE/nQTcMS85uqcodkyiO25PfrTS9f4OpkviuvvJyXid346P7svS2
         Zkcnwtqhq4x63LsWI5tw5dnfetHLKgr8k7c6Ut8rRMC94Sbv2x04eV9c32s89AGBLmoY
         BjhXrZJJhY6Onlf6a2hHKYSxGY2urxrhmFELm5td093zmXU1k6+8ADP1mX6rM4uF3pVg
         hy+1PVDHbwEInAKVpKPUde1VJlQBW6OoJ1FfJ2CmDNpEZqTBNMZDmI40TkA13sZM59Cv
         7cWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c5hk+YvDF+HNcyf9r7puwjNVcCKeuusQ28Ivdswl/wY=;
        b=LF3NjF6tFJi0P8RiJQKsDdgOAc5Q/UaDQp9D6wtvm14/Qb/+xCSTc+/MUtzDydEh+h
         gEVwJkBN48BTshhprB2u1LdCh43bT/bA1VkayGAF0m+xKzdb8xbQCxcS/Cv7NPbXAIo+
         d/oxplx6VWTtQhm0XYzRfb9kd+JcDad7o0k07EwW3jaCezlt2HB0YJpg80RwKle5Zd/X
         sMNrOjqd7Ki8xRPntAE1l39Hd1VHGmuMWWVhrVqSOXV9pcGabj255Hrk+8i4R57aXE/x
         udxXJWYxQw5XQHk1IEf6EUKcCBp81okH+RGMlu6R0ZB2i1ySC/GFkVjL806nzUSi46B6
         G+zw==
X-Gm-Message-State: AOAM532OKQ32DFpvW8pf7aVj9u1SXlYqqBCeou28bDJK0gDQvkbBrKE4
        KpORXUEmsT15HZ+H293MW1sD
X-Google-Smtp-Source: ABdhPJzToo8f9DVO/kSz/quWW8eMz/WF+e6ERpzOVZ6UV+MrK6+EGUGO1015b1B48Aw27ecTnKSrpg==
X-Received: by 2002:a05:6402:c2:: with SMTP id i2mr8768644edu.224.1590083456687;
        Thu, 21 May 2020 10:50:56 -0700 (PDT)
Received: from dkxps.fkb.profitbricks.net (dslb-002-204-227-207.002.204.pools.vodafone-ip.de. [2.204.227.207])
        by smtp.gmail.com with ESMTPSA id z12sm5358700edk.78.2020.05.21.10.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 10:50:55 -0700 (PDT)
From:   Danil Kipnis <danil.kipnis@cloud.ionos.com>
To:     linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
        dledford@redhat.com, jgg@ziepe.ca
Cc:     axboe@kernel.dk, bvanassche@acm.org, leon@kernel.org,
        danil.kipnis@cloud.ionos.com, jinpu.wang@cloud.ionos.com,
        guoqing.jiang@cloud.ionos.com, Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] rnbd: fix compilation error when CONFIG_MODULES is disabled
Date:   Thu, 21 May 2020 19:50:01 +0200
Message-Id: <20200521175001.445208-1-danil.kipnis@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <86962843-e786-4a3f-0b85-1e06fbdbd76a@infradead.org>
References: <86962843-e786-4a3f-0b85-1e06fbdbd76a@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

module_is_live function is only defined when CONFIG_MODULES is enabled.
Use try_module_get instead to check whether the module is being removed.

When module unload and manuall unmapping is happening in parallel, we can
try removing the symlink twice: rnbd_client_exit vs. rnbd_clt_unmap_dev_store.

This is probably not the best way to deal with this race in general, but for
now this fixes the compilation issue when CONFIG_MODULES is disabled and has
no functional impact. Regression tests passed.

Fixes: 1eb54f8f5dd8 block/rnbd: client: sysfs interface functions
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: Danil Kipnis <danil.kipnis@cloud.ionos.com>
---
 drivers/block/rnbd/rnbd-clt-sysfs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-clt-sysfs.c b/drivers/block/rnbd/rnbd-clt-sysfs.c
index a4508fcc7ffe..73d7cb40abb3 100644
--- a/drivers/block/rnbd/rnbd-clt-sysfs.c
+++ b/drivers/block/rnbd/rnbd-clt-sysfs.c
@@ -428,12 +428,14 @@ static struct attribute *rnbd_dev_attrs[] = {
 void rnbd_clt_remove_dev_symlink(struct rnbd_clt_dev *dev)
 {
 	/*
-	 * The module_is_live() check is crucial and helps to avoid annoying
-	 * sysfs warning raised in sysfs_remove_link(), when the whole sysfs
-	 * path was just removed, see rnbd_close_sessions().
+	 * The module unload rnbd_client_exit path is racing with unmapping of the
+	 * last single device from the sysfs manually i.e. rnbd_clt_unmap_dev_store()
+	 * leading to a sysfs warning because of sysfs link already was removed already.
 	 */
-	if (strlen(dev->blk_symlink_name) && module_is_live(THIS_MODULE))
+	if (strlen(dev->blk_symlink_name) && try_module_get(THIS_MODULE)) {
 		sysfs_remove_link(rnbd_devs_kobj, dev->blk_symlink_name);
+		module_put(THIS_MODULE);
+	}
 }
 
 static struct kobj_type rnbd_dev_ktype = {

base-commit: f11e0ec55f0c80ff47693af2150bad5db0e20387
-- 
2.25.1

