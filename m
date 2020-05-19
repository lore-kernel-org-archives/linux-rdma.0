Return-Path: <SRS0=kq6t=7B=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1116DC433DF
	for <linux-rdma@archiver.kernel.org>; Tue, 19 May 2020 16:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5D13207D8
	for <linux-rdma@archiver.kernel.org>; Tue, 19 May 2020 16:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589904541;
	bh=u3+jsia5NAW/8Ph5G2JpnG6etn7OX8oeTKdDlKnd0Sc=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=2BgXOoYYCa7D+BH57F/ugoN16G2Nk4e061HjQlYQulyVpyRWlbYu71BQXf5RR5/Kb
	 VN/u9ECWay93Xpa23BAdRZDJ+zVCPsDOji7aj2RoF5vpvuWsO5oDTgs7BDcMHr9mr4
	 /Gm/++V0Rd36GEAjVsy+XanH2THpnHi1cxjUUE7E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgESQJA (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 19 May 2020 12:09:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729055AbgESQI7 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 19 May 2020 12:08:59 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C4302075F;
        Tue, 19 May 2020 16:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589904539;
        bh=u3+jsia5NAW/8Ph5G2JpnG6etn7OX8oeTKdDlKnd0Sc=;
        h=Date:From:To:Cc:Subject:From;
        b=NV4cKwwuBLLyXVatnObrm47KAEk5WfJ8UQC8c3xRc7mAEJpUQF7O+uI0gdsdZq381
         f7BJ3B3WbVujfd3EA2AW0zQN2qdrSxoQ8Yi8dE9iCneCp41e8b4sxb8DwOCwLqgU+L
         6lmnZZOTUAc/Qm7XxCtWaOWhQIzS9A/fzMTzJPEk=
Date:   Tue, 19 May 2020 11:13:45 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] RDMA/rtrs: client: Fix function return on success
Message-ID: <20200519161345.GA3910@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The function should return 0 on success, instead of err.

Addresses-Coverity-ID: 1493753 ("Identical code for different branches")
Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 468fdd0d8713c..465515e46bb1a 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1594,7 +1594,8 @@ static int create_con_cq_qp(struct rtrs_clt_con *con)
 
 	if (err)
 		return err;
-	return err;
+
+	return 0;
 }
 
 static void destroy_con_cq_qp(struct rtrs_clt_con *con)
-- 
2.26.2

