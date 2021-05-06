Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CDCC433ED
	for <linux-rdma@archiver.kernel.org>; Thu,  6 May 2021 23:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 031C0610FB
	for <linux-rdma@archiver.kernel.org>; Thu,  6 May 2021 23:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhEFXlP (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 6 May 2021 19:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbhEFXlP (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 6 May 2021 19:41:15 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA87C061574
        for <linux-rdma@vger.kernel.org>; Thu,  6 May 2021 16:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=NfDSBX6IPXDCcwgubDjXiXpObAHZuYoajksDZxW1F1g=; b=K6X2ShgP7+7tpFg2+8ZOnCqd75
        MQGDC1osgcCRzDFQs7yJ8Z2G4kW3AazEjy2ScpRmky6i5qeKT/oO9OlWDxYQvTu3ged/6Rv0R0ump
        RocIIuj9SUf23zvkBYPLfEBva4CG7mFa8T4J0dCHtHA04MoPyvkE/Ucngb7l/9fOcmMlXRn80dGIc
        KxxEMjm4jpVipo5Tdgy8AW4jyDRlwz6Vdj6ZDajffSJJHpK9k8AD+G3uCFoZWTLMzSRkGJFKMQF/t
        d1GkhjRXFlPPXuW4f+cAOX7LSAN1sTzx1YEFjEl7nG6W7TAyRuaeGAmi2dK62RTGd8H9gDMblliIc
        BcEoLNQqveoRSSh+QXunEPbJi1M2m1skbhhp3HLhrB7hDpJkZRgGsIwZMRkDjPyAZRMHQgwDGT1oS
        BqgEP80dohxzuAjkQ+VHUuDo6qZVkR3DcDUG45ggKvibgRGBc//06YVGaieHY5xJ59tsY+Q/VboOI
        yqaPKy9yERkCKXJDLboZgUAn;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lenbI-0004P2-Rm; Thu, 06 May 2021 23:40:13 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Bernard Metzler <bmt@zurich.ibm.com>
Cc:     linux-rdma@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 30/31] rdma/siw: make use of __siw_cep_close() in siw_listen_address()
Date:   Fri,  7 May 2021 01:36:36 +0200
Message-Id: <66cf98af9f3cdf3111d79d7e076e3304ff9eb419.1620343860.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1620343860.git.metze@samba.org>
References: <cover.1620343860.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

This is more or less a consistency change, we should always
go via __siw_cep_close() to release the socket in order to
avoid problems in future.

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Cc: Bernard Metzler <bmt@zurich.ibm.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/sw/siw/siw_cm.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index 4b789379f676..49d01264682a 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1972,17 +1972,9 @@ int siw_create_listen(struct iw_cm_id *id, int backlog)
 error:
 	siw_dbg(id->device, "failed: %d\n", rv);
 
-	if (cep->cm_id) {
-		cep->cm_id->rem_ref(cep->cm_id);
-		cep->cm_id = NULL;
-	}
-	cep->sock = NULL;
-	siw_socket_disassoc(s);
-	cep->state = SIW_EPSTATE_CLOSED;
-
+	__siw_cep_close(cep);
 	siw_cep_set_free(cep);
 	siw_cep_put(cep);
-	sock_release(s);
 
 	return rv;
 }
-- 
2.25.1

