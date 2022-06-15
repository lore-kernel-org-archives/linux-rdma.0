Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22AF1C43334
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Jun 2022 15:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbiFOP25 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 15 Jun 2022 11:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353817AbiFOP17 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 15 Jun 2022 11:27:59 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC4E16595
        for <linux-rdma@vger.kernel.org>; Wed, 15 Jun 2022 08:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=X4yjjgUauZLNVhdKH977DyeFAC1iEOZ232nEBNxdlo8=; b=GwB+lmuEeKLzHGM+uQKuCH3hWT
        RhktaHbF+juBMlnbFrWJ0seADYHKkqtOWANeZdvDecYKYDQx76ozDQsCrAfHSxrZgzmyKc8ioZUPk
        fMU4kdlSLAI9Zs4CHDdXVGSXrNnwn+UgwWvas4ngOIuFkmQfHOWz2FctONr8d8ZCf0Mo/QucgjKew
        Oo+LAJf0SA+KS9jig89XcVKdc4I3pxJu6tZvtkxCrlC7TpXaAFzWTk5bMdjuu3wXAdmA8Z94OWaBT
        bTkoIB8cj483A7pjzM3oyRHAcRZvTN2BFMNctst2o+fUPetI4hFSPe92xwOMBY+Uctlz9bufaUwO0
        4jzzDHdvhoOjKPlfpoImmt5+c0Jt0RPlYlSMdmQWkLE4SqNxaB5wUUSlgCJEdQYjVF63b5px1vP5R
        sIzIGZZcniqhqm0PDHq0k+sq7i9i/nugByP0SjhVtG8/Czui3jOUzQrWhV7MSd5+yvcQYTm8cZOQb
        FHk9eXul6bsj/mpCvYYTx+Hp;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1o1UvZ-005rtZ-SV; Wed, 15 Jun 2022 15:27:29 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Bernard Metzler <bmt@zurich.ibm.com>, linux-rdma@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v2 04/14] rdma/siw: use __siw_cep_terminate_upcall() for indirect SIW_CM_WORK_CLOSE_LLP
Date:   Wed, 15 Jun 2022 17:26:42 +0200
Message-Id: <8cd3dfb0bee64ca1de4157bc6d7c9b1a9602ac31.1655305567.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1655305567.git.metze@samba.org>
References: <cover.1655305567.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Both code paths from siw_qp_cm_drop() should use the same logic.

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Cc: Bernard Metzler <bmt@zurich.ibm.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/sw/siw/siw_cm.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index c5ef5de7e84c..4387cdf99cf9 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1070,11 +1070,7 @@ static void siw_cm_work_handler(struct work_struct *w)
 		/*
 		 * QP scheduled LLP close
 		 */
-		if (cep->qp && cep->qp->term_info.valid)
-			siw_send_terminate(cep->qp);
-
-		if (cep->cm_id)
-			siw_cm_upcall(cep, IW_CM_EVENT_CLOSE, 0);
+		__siw_cep_terminate_upcall(cep, -EINVAL);
 
 		release_cep = 1;
 		break;
-- 
2.34.1

