Return-Path: <SRS0=kLQv=CM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2175C433E2
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Sep 2020 07:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96A72207EA
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Sep 2020 07:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599118754;
	bh=CiiGLff/NwwsTdTCRJrhMnUJ5l9H04eJwukFonuKqeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=p+whHSOgxBcEy3cXttDYDf7cbsXMqtNSh2NNOwcLDQlNqaxoNzi4xg+4SiTP9nx6I
	 m7k1pZj7H5+MVyhP0w8sDU7T3HaMJ7SErBpsa3anmP9N0D9wtT5lg9G5x1w1jSRoYK
	 ND4NUaOsLkA4A4cbEX135GqM+hqZlrt3jiL/Xo+k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgICHjK (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 3 Sep 2020 03:39:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgICHjH (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 3 Sep 2020 03:39:07 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EBB720775;
        Thu,  3 Sep 2020 07:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599118746;
        bh=CiiGLff/NwwsTdTCRJrhMnUJ5l9H04eJwukFonuKqeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ReHw8YnHj8evdCIYGJMJ7oQwjM64GgC/jCPB1/B55aSS/QMge2pZU5ozZTqKeJioN
         SGXBzBkfB6CN65oMiLZkCv4Jjm04+E+gosA1Jsa3aZkjG/69cGWxdjSIgWbbukxrKt
         uZjIpdv0TTQELs6A4wN/DBZdRA8/Xnbyh/pJfUhw=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Vesker <valex@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 1/3] RDMA/mlx5: Add sw_owner_v2 bit capability
Date:   Thu,  3 Sep 2020 10:38:55 +0300
Message-Id: <20200903073857.1129166-2-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200903073857.1129166-1-leon@kernel.org>
References: <20200903073857.1129166-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Alex Vesker <valex@nvidia.com>

Added sw_owner_v2 which will be enabled for future devices,
replacing sw_owner bit.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index aee25e4fb2cc..651591a2965d 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -420,7 +420,8 @@ struct mlx5_ifc_flow_table_prop_layout_bits {
 	u8         reserved_at_1a[0x2];
 	u8         ipsec_encrypt[0x1];
 	u8         ipsec_decrypt[0x1];
-	u8         reserved_at_1e[0x2];
+	u8         sw_owner_v2[0x1];
+	u8         reserved_at_1f[0x1];

 	u8         termination_table_raw_traffic[0x1];
 	u8         reserved_at_21[0x1];
--
2.26.2

