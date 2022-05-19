Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E5FC433EF
	for <linux-rdma@archiver.kernel.org>; Thu, 19 May 2022 08:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbiESIfP (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 19 May 2022 04:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235514AbiESIfM (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 19 May 2022 04:35:12 -0400
Received: from sender2-op-o12.zoho.com.cn (sender2-op-o12.zoho.com.cn [163.53.93.243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12407892F
        for <linux-rdma@vger.kernel.org>; Thu, 19 May 2022 01:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1652949076;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:From:To:To:Cc:Cc:Message-ID:Subject:Subject:Date:Date:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
        bh=k+vTd23jukR7GeuOew6UY9TjRPjs9OjDlQks6ldQCLk=;
        b=c13vMxC5u/FRZtBEiCz3iCkPTPefF5Hz8pwzjyDb8s3nKs3cC7tQUDKVBn5eSQQG
        LmVjORfcD9A2YbrI6r9jia67AeXqBT8boiB4jvz0cC9LTjP05REgJnGb7iRjK4IO75Y
        EB56vVAuNswneILx1n6mo8O122wUFureVHCa6O/8=
Received: from localhost.localdomain (106.55.170.121 [106.55.170.121]) by mx.zoho.com.cn
        with SMTPS id 1652949075848376.79040338119796; Thu, 19 May 2022 16:31:15 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     zyjzyj2000@gmail.com, jgg@ziepe.ca, leon@kernel.org
Cc:     linux-rdma@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20220519083049.2259564-1-cgxu519@mykernel.net>
Subject: [PATCH] RDMA/rxe: goto error handling when detecting invalid opcode
Date:   Thu, 19 May 2022 16:30:49 +0800
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Currently in rxe_requester() we just skip further operation
instead of going error handling when detecting invalid opcode.

IMO, it should goto error handling just like other errors.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 drivers/infiniband/sw/rxe/rxe_req.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rx=
e/rxe_req.c
index ae5fbc79dd5c..8a1cff80a68e 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -661,7 +661,7 @@ int rxe_requester(void *arg)
 =09opcode =3D next_opcode(qp, wqe, wqe->wr.opcode);
 =09if (unlikely(opcode < 0)) {
 =09=09wqe->status =3D IB_WC_LOC_QP_OP_ERR;
-=09=09goto exit;
+=09=09goto err;
 =09}
=20
 =09mask =3D rxe_opcode[opcode].mask;
--=20
2.27.0


