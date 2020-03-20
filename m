Return-Path: <SRS0=XFIj=5F=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC350C4332B
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Mar 2020 12:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2A7D20754
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Mar 2020 12:17:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="G9BA/sX8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbgCTMRY (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 20 Mar 2020 08:17:24 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34824 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgCTMRX (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 20 Mar 2020 08:17:23 -0400
Received: by mail-wr1-f66.google.com with SMTP id h4so7216549wru.2
        for <linux-rdma@vger.kernel.org>; Fri, 20 Mar 2020 05:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fNwvYHkUpztFH9MuviGFAouBy9cQAXueaLElgP/2A8c=;
        b=G9BA/sX8CI+jLX9Cyt571ZIeG/okPIDYatUj/QARehCNES2E29pPzDXR3NCTjy/etV
         zfZAbOj4ZukO9BLn9UN2UC0+uXK37eeimg8YegIK0RShmgXRJs5xmQ8CuM1Ox7eZMbq4
         DmRoFp9rtH+aQg+tyL2QMSSubtYPgrhvUrwxg/fRGOqvef4zTLshkatrFj1rTE+z0mvc
         4+ArUQP8KNZ+CTF0Pe+H7aofH0AO9h8jFHv1uD1mlv0D7cUAdjt09onl852RIbggCGBl
         o/qXZtApfroxE8c/YR6jkIiToUx1BAVB52Qf0eHVntb7I+bX3VNJN22zlirPN3yyvh4j
         f0hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fNwvYHkUpztFH9MuviGFAouBy9cQAXueaLElgP/2A8c=;
        b=aQymty/NvQEDvOx3u5h+RO+B+5wD0p62oavwMV0QbKRyXW6nsfptR6lQEcxyeXTGEs
         bUfaYxB3zq0meWC+SHvBC057zqG3uJ04zrRmzZzdZdLwvTqUfjLzr2w6ah8685GTkRSI
         bIR/VWPy08zJR7fVGREXNzbnQoRyCTe3Sy8weoHyjPwq9hNdJOFamyXJWhHR1+699NGn
         tzhISjTogFLuqHoiei/W4sFgKDhEYk07PAJ+YY5X6CQ72MoVMyOag14yqHw4CwQXQXRh
         pQkJkXp3YbJLR812+B+QgF05FDPQ8Ui28cgJVpM0O4k58upA5Gwh6s+ZDHYtMg4JHHv/
         XQUw==
X-Gm-Message-State: ANhLgQ0lQPQT75Tr+T+07HQIqdXIkiz6Oetfp4xxMGUEXHQhVd+qErwB
        tPKA/zDxA7zFKkWGUmnGTKEi2w==
X-Google-Smtp-Source: ADFU+vsUgrUe1CGTkNJinn7i6bXZpkWHg8wIl7Vs1mD8p7ip8G7v1/ZY8FDGH3D2AmAzzXmnL5y8ag==
X-Received: by 2002:a5d:44d2:: with SMTP id z18mr10504808wrr.245.1584706641130;
        Fri, 20 Mar 2020 05:17:21 -0700 (PDT)
Received: from jwang-Latitude-5491.fritz.box ([2001:16b8:4927:3900:64cf:432e:192d:75a2])
        by smtp.gmail.com with ESMTPSA id j39sm8593662wre.11.2020.03.20.05.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 05:17:20 -0700 (PDT)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
Cc:     axboe@kernel.dk, hch@infradead.org, sagi@grimberg.me,
        bvanassche@acm.org, leon@kernel.org, dledford@redhat.com,
        jgg@ziepe.ca, danil.kipnis@cloud.ionos.com,
        jinpu.wang@cloud.ionos.com, rpenyaev@suse.de,
        pankaj.gupta@cloud.ionos.com
Subject: [PATCH v11 13/26] RDMA/rtrs: include client and server modules into kernel compilation
Date:   Fri, 20 Mar 2020 13:16:44 +0100
Message-Id: <20200320121657.1165-14-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320121657.1165-1-jinpu.wang@cloud.ionos.com>
References: <20200320121657.1165-1-jinpu.wang@cloud.ionos.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Add rtrs Makefile, Kconfig and also corresponding lines into upper
layer infiniband/ulp files.

Signed-off-by: Danil Kipnis <danil.kipnis@cloud.ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/infiniband/Kconfig           |  1 +
 drivers/infiniband/ulp/Makefile      |  1 +
 drivers/infiniband/ulp/rtrs/Kconfig  | 27 +++++++++++++++++++++++++++
 drivers/infiniband/ulp/rtrs/Makefile | 15 +++++++++++++++
 4 files changed, 44 insertions(+)
 create mode 100644 drivers/infiniband/ulp/rtrs/Kconfig
 create mode 100644 drivers/infiniband/ulp/rtrs/Makefile

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index ade86388434f..477418b37786 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -107,6 +107,7 @@ source "drivers/infiniband/ulp/srpt/Kconfig"
 
 source "drivers/infiniband/ulp/iser/Kconfig"
 source "drivers/infiniband/ulp/isert/Kconfig"
+source "drivers/infiniband/ulp/rtrs/Kconfig"
 
 source "drivers/infiniband/ulp/opa_vnic/Kconfig"
 
diff --git a/drivers/infiniband/ulp/Makefile b/drivers/infiniband/ulp/Makefile
index 437813c7b481..4d0004b58377 100644
--- a/drivers/infiniband/ulp/Makefile
+++ b/drivers/infiniband/ulp/Makefile
@@ -5,3 +5,4 @@ obj-$(CONFIG_INFINIBAND_SRPT)		+= srpt/
 obj-$(CONFIG_INFINIBAND_ISER)		+= iser/
 obj-$(CONFIG_INFINIBAND_ISERT)		+= isert/
 obj-$(CONFIG_INFINIBAND_OPA_VNIC)	+= opa_vnic/
+obj-$(CONFIG_INFINIBAND_RTRS)		+= rtrs/
diff --git a/drivers/infiniband/ulp/rtrs/Kconfig b/drivers/infiniband/ulp/rtrs/Kconfig
new file mode 100644
index 000000000000..9092b62e6dc8
--- /dev/null
+++ b/drivers/infiniband/ulp/rtrs/Kconfig
@@ -0,0 +1,27 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+config INFINIBAND_RTRS
+	tristate
+	depends on INFINIBAND_ADDR_TRANS
+
+config INFINIBAND_RTRS_CLIENT
+	tristate "RTRS client module"
+	depends on INFINIBAND_ADDR_TRANS
+	select INFINIBAND_RTRS
+	help
+	  RDMA transport client module.
+
+	  RDMA Transport (RTRS) client implements a reliable transport layer
+	  and also multipathing functionality and that it is intended to be
+	  the base layer for a block storage initiator over RDMA.
+
+config INFINIBAND_RTRS_SERVER
+	tristate "RTRS server module"
+	depends on INFINIBAND_ADDR_TRANS
+	select INFINIBAND_RTRS
+	help
+	  RDMA transport server module.
+
+	  RDMA Transport (RTRS) server module processing connection and IO
+	  requests received from the RTRS client module, it will pass the
+	  IO requests to its user eg. RNBD_server.
diff --git a/drivers/infiniband/ulp/rtrs/Makefile b/drivers/infiniband/ulp/rtrs/Makefile
new file mode 100644
index 000000000000..3898509be270
--- /dev/null
+++ b/drivers/infiniband/ulp/rtrs/Makefile
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+rtrs-client-y := rtrs-clt.o \
+		  rtrs-clt-stats.o \
+		  rtrs-clt-sysfs.o
+
+rtrs-server-y := rtrs-srv.o \
+		  rtrs-srv-stats.o \
+		  rtrs-srv-sysfs.o
+
+rtrs-core-y := rtrs.o
+
+obj-$(CONFIG_INFINIBAND_RTRS)        += rtrs-core.o
+obj-$(CONFIG_INFINIBAND_RTRS_CLIENT) += rtrs-client.o
+obj-$(CONFIG_INFINIBAND_RTRS_SERVER) += rtrs-server.o
-- 
2.17.1

