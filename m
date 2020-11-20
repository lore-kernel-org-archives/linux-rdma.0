Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D30DC64E7C
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Nov 2020 18:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E96A824137
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Nov 2020 18:32:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="dDNZKLx6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730663AbgKTSbp (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 20 Nov 2020 13:31:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:51234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730130AbgKTSbo (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 20 Nov 2020 13:31:44 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D4A824137;
        Fri, 20 Nov 2020 18:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897104;
        bh=2eGFjiWyewYdJs9WHsfiLjzP22DYaqQLj4qoiKEX8Qg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dDNZKLx6ifyMUW6k3oPMC7kVDKrOraVSclNcMirgTi5S0Qo3nN+Net99rUullR4fW
         RcTx37ewFa0V/tktXe9+P4G0cSesxSnmOK3KBgk/DU4HD+y+7O+13sfU1gXgBDl90p
         KxQ//OXIiim8Yk9UVHY9Kxujl+ep+9YpUWxz2RMY=
Date:   Fri, 20 Nov 2020 12:31:49 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 050/141] RDMA/mlx5: Fix fall-through warnings for Clang
Message-ID: <2b0c87362bc86f6adfe56a5a6685837b71022bbf.1605896059.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding the new pseudo-keyword fallthrough; instead of
letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 600e056798c0..ccaa4589331c 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2460,6 +2460,7 @@ static int check_qp_type(struct mlx5_ib_dev *dev, struct ib_qp_init_attr *attr,
 	case IB_QPT_GSI:
 		if (dev->profile == &raw_eth_profile)
 			goto out;
+		fallthrough;
 	case IB_QPT_RAW_PACKET:
 	case IB_QPT_UD:
 	case MLX5_IB_QPT_REG_UMR:
-- 
2.27.0

