Return-Path: <SRS0=EqZ5=VM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE7FC7618A
	for <linux-rdma@archiver.kernel.org>; Mon, 15 Jul 2019 04:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E2622067C
	for <linux-rdma@archiver.kernel.org>; Mon, 15 Jul 2019 04:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbfGOEQV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 15 Jul 2019 00:16:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45094 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbfGOEQV (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 15 Jul 2019 00:16:21 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 42E4E30832C2;
        Mon, 15 Jul 2019 04:16:21 +0000 (UTC)
Received: from localhost (ovpn-12-38.pek2.redhat.com [10.72.12.38])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EB775C231;
        Mon, 15 Jul 2019 04:16:20 +0000 (UTC)
From:   Honggang Li <honli@redhat.com>
To:     bvanassche@acm.org, jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org, Honggang Li <honli@redhat.com>
Subject: [rdma-core patch v3] srp_daemon: improve the debug message for is_enabled_by_rules_file
Date:   Mon, 15 Jul 2019 00:16:14 -0400
Message-Id: <20190715041614.27979-1-honli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Mon, 15 Jul 2019 04:16:21 +0000 (UTC)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

If the target was disallowed by rule file, user can not distinguish that
from the old debug message.

pr_debug("Found an SRP target with id_ext %s - check if it allowed by rules file\n", target->id_ext);

It implicitly implied by the message next to the old debug message.

pr_debug("Found an SRP target with id_ext %s - check if it is already connected\n", target->id_ext);

The improved debug message will feedback the check result of rule file, user
no longer needs to wonder the target is allowed or not.

Signed-off-by: Honggang Li <honli@redhat.com>
---
 srp_daemon/srp_daemon.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index a004f6a4..e85b9668 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -349,10 +349,11 @@ static int is_enabled_by_rules_file(struct target_details *target)
 	int rule;
 	struct config_t *conf = config;
 
-	if (NULL == conf->rules)
+	if (NULL == conf->rules) {
+		pr_debug("Allowing SRP target with id_ext %s because not using a rules file\n", target->id_ext);
 		return 1;
+	}
 
-	pr_debug("Found an SRP target with id_ext %s - check if it allowed by rules file\n", target->id_ext);
 	rule = -1;
 	do {
 		rule++;
@@ -392,6 +393,9 @@ static int is_enabled_by_rules_file(struct target_details *target)
 
 		target->options = conf->rules[rule].options;
 
+		pr_debug("SRP target with id_ext %s %s by rules file\n",
+				target->id_ext,
+				conf->rules[rule].allow ? "allowed" : "disallowed");
 		return conf->rules[rule].allow;
 
 	} while (1);
-- 
2.20.1

