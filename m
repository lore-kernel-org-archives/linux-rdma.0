Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C18BC433EF
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Mar 2022 14:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236818AbiCGOxi (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 7 Mar 2022 09:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243502AbiCGOwm (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 7 Mar 2022 09:52:42 -0500
Received: from sender2-op-o12.zoho.com.cn (sender2-op-o12.zoho.com.cn [163.53.93.243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA3590FCE
        for <linux-rdma@vger.kernel.org>; Mon,  7 Mar 2022 06:51:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1646664660; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=OxdC1s7Yt0yrVFK3sjqubu9Yfy1iEQR7xgrUT5/P8vWmh4hqQ3TinkR3RNk3zc4Iy1zb3wqiBG0Y6IcORU/ZSayDXJgwVIKmlVbdqMP4kW0Ad95L9XR1B0F5U31AxJQsEHLXm45RqhmvKkQodUVD2TULpQR9yszJAX4rpM3v1ik=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1646664660; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=DlcxgSze8oPwcVCYDwxgHwWDpfYCGW4lgRBZTATU2Pc=; 
        b=L0Y9x2Vnp670MrxitkwhlmTanDJlCCY+4N2dz1NCyVUrJ2i0cMsZ7BsN47LhnWQMtmdGpBJz6A4gw19NsMbD3+hezTj6M8963IjhUmCY05czRFGFfRF/RnQkaecNa3pMcve3jvYQHVncRjbQQ4VDkRh/eSnp8oEKWh214ztfRPY=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1646664660;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=DlcxgSze8oPwcVCYDwxgHwWDpfYCGW4lgRBZTATU2Pc=;
        b=GP9RWqV+khBJ2ZjZHtRtP118i7IO4aR60yHMtI1CmI69noRXMAhZG7FLJnSxck0R
        Sr5hw3dSMnoCELBLV0+la8lhiStj7GMW1mZSeLaQSHy2xx+XcXa0WZt74WUdfMGE0ue
        yW7uSss2HH6ck6tZRm+k2pMxqBB3xGjEc8VZxbNo=
Received: from localhost.localdomain (81.71.33.115 [81.71.33.115]) by mx.zoho.com.cn
        with SMTPS id 1646664659479921.1968419886987; Mon, 7 Mar 2022 22:50:59 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     zyjzyj2000@gmail.com, jgg@ziepe.ca
Cc:     leon@kernel.org, linux-rdma@vger.kernel.org,
        Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20220307145047.3235675-1-cgxu519@mykernel.net>
Subject: [PATCH v2 1/2] RDMA/rxe: change variable and function argument to proper type
Date:   Mon,  7 Mar 2022 22:50:46 +0800
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The type of wqe length is u32 so in order to avoid overflow
and shadow casting change variable and relevant function argument to
proper type.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 drivers/infiniband/sw/rxe/rxe_req.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rx=
e/rxe_req.c
index 5eb89052dd66..b28036a7a3b8 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -359,7 +359,7 @@ static inline int get_mtu(struct rxe_qp *qp)
=20
 static struct sk_buff *init_req_packet(struct rxe_qp *qp,
 =09=09=09=09       struct rxe_send_wqe *wqe,
-=09=09=09=09       int opcode, int payload,
+=09=09=09=09       int opcode, u32 payload,
 =09=09=09=09       struct rxe_pkt_info *pkt)
 {
 =09struct rxe_dev=09=09*rxe =3D to_rdev(qp->ibqp.device);
@@ -449,7 +449,7 @@ static struct sk_buff *init_req_packet(struct rxe_qp *q=
p,
=20
 static int finish_packet(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 =09=09       struct rxe_pkt_info *pkt, struct sk_buff *skb,
-=09=09       int paylen)
+=09=09       u32 paylen)
 {
 =09int err;
=20
@@ -497,7 +497,7 @@ static void update_wqe_state(struct rxe_qp *qp,
 static void update_wqe_psn(struct rxe_qp *qp,
 =09=09=09   struct rxe_send_wqe *wqe,
 =09=09=09   struct rxe_pkt_info *pkt,
-=09=09=09   int payload)
+=09=09=09   u32 payload)
 {
 =09/* number of packets left to send including current one */
 =09int num_pkt =3D (wqe->dma.resid + payload + qp->mtu - 1) / qp->mtu;
@@ -540,7 +540,7 @@ static void rollback_state(struct rxe_send_wqe *wqe,
 }
=20
 static void update_state(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
-=09=09=09 struct rxe_pkt_info *pkt, int payload)
+=09=09=09 struct rxe_pkt_info *pkt, u32 payload)
 {
 =09qp->req.opcode =3D pkt->opcode;
=20
@@ -612,7 +612,7 @@ int rxe_requester(void *arg)
 =09struct sk_buff *skb;
 =09struct rxe_send_wqe *wqe;
 =09enum rxe_hdr_mask mask;
-=09int payload;
+=09u32 payload;
 =09int mtu;
 =09int opcode;
 =09int ret;
--=20
2.27.0


