Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F8C8C433DB
	for <linux-rdma@archiver.kernel.org>; Sun, 17 Jan 2021 08:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0620B22DA9
	for <linux-rdma@archiver.kernel.org>; Sun, 17 Jan 2021 08:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbhAQIiO (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 17 Jan 2021 03:38:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:52458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728138AbhAQIRZ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 17 Jan 2021 03:17:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B51B22D70;
        Sun, 17 Jan 2021 08:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610871363;
        bh=gVwcAqksC8774I0xStSE+R/m4VUu3bJL+MR3Q0MK8Ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dxi12JnPsmP16a+xx1XmKSQzrAwuuK1WlJ5LXzKwHCGUdDyfaqIDAxN0yLmfcY6tq
         9N1nfFTsN7vkxoYRjfRBKALN8RqcSvSBm3UBRLpdCikAAnRESnqSwv7Q/qdmvWuxWG
         JgTyvvdOC7JwE1KwmkggHKhf9wF0cK1QbnoogRIqj1iUvWaxsGgcmniHVSA7RX6noZ
         RF/zuNHTCDT8m5r2xc4Yzkr2zC4ck1rldzODfymKEvEMxFYFbWQ/W/P/kdQXyvoHdw
         aQkUQuRCfwstqefw0SnZR3cTIZPymLOOJq1qar+TJKl/jfjIR+EgVgxfnUE5jRDOnK
         RIqOsBinJZ/Gw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH mlx5-next v3 3/5] net/mlx5: Add dynamic MSI-X capabilities bits
Date:   Sun, 17 Jan 2021 10:15:46 +0200
Message-Id: <20210117081548.1278992-4-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210117081548.1278992-1-leon@kernel.org>
References: <20210117081548.1278992-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

These new fields declare the number of MSI-X vectors that is
possible to allocate on the VF through PF configuration.

Value must be in range defined by min_dynamic_vf_msix_table_size
and max_dynamic_vf_msix_table_size.

The driver should continue to query its MSI-X table through PCI
configuration header.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 8c5d5fe58051..7ac614bc592a 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1656,7 +1656,16 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8	   reserved_at_6e0[0x10];
 	u8	   sf_base_id[0x10];
 
-	u8	   reserved_at_700[0x80];
+	u8	   reserved_at_700[0x8];
+	u8	   num_total_dynamic_vf_msix[0x18];
+	u8	   reserved_at_720[0x14];
+	u8	   dynamic_msix_table_size[0xc];
+	u8	   reserved_at_740[0xc];
+	u8	   min_dynamic_vf_msix_table_size[0x4];
+	u8	   reserved_at_750[0x4];
+	u8	   max_dynamic_vf_msix_table_size[0xc];
+
+	u8	   reserved_at_760[0x20];
 	u8	   vhca_tunnel_commands[0x40];
 	u8	   reserved_at_7c0[0x40];
 };
-- 
2.29.2

