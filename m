Return-Path: <SRS0=g7zE=BV=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA25FC433DF
	for <linux-rdma@archiver.kernel.org>; Tue, 11 Aug 2020 09:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EA5920772
	for <linux-rdma@archiver.kernel.org>; Tue, 11 Aug 2020 09:28:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="UKUTCHv3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbgHKJ2I (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 11 Aug 2020 05:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728224AbgHKJ2I (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 11 Aug 2020 05:28:08 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B0EC06174A
        for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2020 02:28:07 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id r11so7282057pfl.11
        for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2020 02:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ceqNjIcffmhOgFoQu+AOFxEqc+9DV/c9FrH0llu2eoM=;
        b=UKUTCHv351UZ92i1RCboLwOdQFQbicCZz6C3It54z84QIUmzVAm48YAQ+7nYwmWNMD
         pHv9XlooWQdbwnMDt4uX4SIA0VloYD27D+vDwksjgTZqm/KmLpB57cXtMsE7mutrqmev
         uuQ3wSgJotA9oKCtiIUfUtxyraLVk+wSMcPvcJcnJA/qLw6W6krC6S+m//O+Ft2SpicB
         PgwHkfCCvtL8J0+yBW9SFYrLa2ntrF2D1j30jgaIaFJBW/XC/L+komKrgdcH0uQWwLRu
         oBAX/50h7u9DwBs1RZJbz4uI8sy+3w+/SHIp8gSkUjPGeMa3BsD+sWbGTuN1jK/oycUm
         47xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ceqNjIcffmhOgFoQu+AOFxEqc+9DV/c9FrH0llu2eoM=;
        b=hMptLTSG6ZLyulBQAQ1Qt8/LWxxaLO1TP6bUQJQgBulSEZ7qa9LMsGA9tF+1El1ZS/
         B1S0qoaYoKfwLGzwF1jKO9geM14QXr+loumog/5kJgsZ/WuZdiyAWONVLY0oUewlTZDc
         plV7ncvwzVV0lak1R8MQOrKiTnhHr6QVCEfDoncxgf7b9JTZ3aoYODplkaHKMn//x8Y4
         IkwTj95zRLdQ/svVJYJpm8oFvsGWrdVb7DALoxSPSm1dI3N4AgM3uaq+c3+Jwae35Vht
         V3G5Io3aazBRueSUSXIMmvWC3GfyINo260MES2fr0eXUKXPZTuWgx7OZepQcJz95UAGz
         /mwQ==
X-Gm-Message-State: AOAM532HjuN+/g/Cl9wvLTDJ9xvQE2e6cLRlWfZpVIjcSv0uZdGTFclI
        zmygGTruA3LNL+X4s2Ej0e4t5w==
X-Google-Smtp-Source: ABdhPJyub/maA7xspvHn9c3mq0AJz4pnxFr2txS95Q8PDzTp1YPpCs9L3tIwEAXwSSCnUBDup3pTOg==
X-Received: by 2002:aa7:8f3a:: with SMTP id y26mr5238163pfr.54.1597138085431;
        Tue, 11 Aug 2020 02:28:05 -0700 (PDT)
Received: from dragon-master.domain.name ([43.224.130.252])
        by smtp.gmail.com with ESMTPSA id b20sm25427444pfp.140.2020.08.11.02.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 02:28:04 -0700 (PDT)
From:   Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
To:     danil.kipnis@cloud.ionos.com, jinpu.wang@cloud.ionos.com,
        linux-rdma@vger.kernel.org, dledford@redhat.com, jgg@ziepe.ca,
        leon@kernel.org
Cc:     Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
Subject: [PATCH] RDMA/rtrs-srv: Replace device_register with device_initialize and device_add
Date:   Tue, 11 Aug 2020 14:57:22 +0530
Message-Id: <20200811092722.2450-1-haris.iqbal@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

There are error cases when we will call free_srv before device kobject is
initialized; in such cases calling put_device generates the following
warning,

kobject: '(null)' (000000009f5445ed): is not initialized, yet
kobject_put() is being called.

It was suggested by Jason to call device_initialize() sooner.

So call device_initialize() only once when the server is allocated. If we
end up calling put_srv() and subsequently free_srv(), our call to
put_device() would result in deletion of the obj. Call device_add() later
when we actually have a connection. Correspondingly, call device_del()
instead of device_unregister() when srv->dev_ref falls to 0.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Signed-off-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c | 8 ++++----
 drivers/infiniband/ulp/rtrs/rtrs-srv.c       | 1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
index 3d7877534bcc..2f981ae97076 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
@@ -182,16 +182,16 @@ static int rtrs_srv_create_once_sysfs_root_folders(struct rtrs_srv_sess *sess)
 	 * sysfs files are created
 	 */
 	dev_set_uevent_suppress(&srv->dev, true);
-	err = device_register(&srv->dev);
+	err = device_add(&srv->dev);
 	if (err) {
-		pr_err("device_register(): %d\n", err);
+		pr_err("device_add(): %d\n", err);
 		goto put;
 	}
 	srv->kobj_paths = kobject_create_and_add("paths", &srv->dev.kobj);
 	if (!srv->kobj_paths) {
 		err = -ENOMEM;
 		pr_err("kobject_create_and_add(): %d\n", err);
-		device_unregister(&srv->dev);
+		device_del(&srv->dev);
 		goto unlock;
 	}
 	dev_set_uevent_suppress(&srv->dev, false);
@@ -216,7 +216,7 @@ rtrs_srv_destroy_once_sysfs_root_folders(struct rtrs_srv_sess *sess)
 		kobject_del(srv->kobj_paths);
 		kobject_put(srv->kobj_paths);
 		mutex_unlock(&srv->paths_mutex);
-		device_unregister(&srv->dev);
+		device_del(&srv->dev);
 	} else {
 		mutex_unlock(&srv->paths_mutex);
 	}
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index a219bd1bdbc2..b61a18e57aeb 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1336,6 +1336,7 @@ static struct rtrs_srv *__alloc_srv(struct rtrs_srv_ctx *ctx,
 	uuid_copy(&srv->paths_uuid, paths_uuid);
 	srv->queue_depth = sess_queue_depth;
 	srv->ctx = ctx;
+	device_initialize(&srv->dev);
 
 	srv->chunks = kcalloc(srv->queue_depth, sizeof(*srv->chunks),
 			      GFP_KERNEL);
-- 
2.25.1

