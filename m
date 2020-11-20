Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAE2AC6379D
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Nov 2020 23:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7929F2240C
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Nov 2020 23:04:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="eSxO+pG+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgKTXEH (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 20 Nov 2020 18:04:07 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12664 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728054AbgKTXEG (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 20 Nov 2020 18:04:06 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb84b690004>; Fri, 20 Nov 2020 15:04:09 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 23:03:56 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Chris Mi <cmi@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
Subject: [PATCH mlx5-next 01/16] net/mlx5: Add sample offload hardware bits and structures
Date:   Fri, 20 Nov 2020 15:03:24 -0800
Message-ID: <20201120230339.651609-2-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201120230339.651609-1-saeedm@nvidia.com>
References: <20201120230339.651609-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605913449; bh=i+YBLZEVEuKJsrwOU88AqGsHpNBmiU+UkmqjGbVowXE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=eSxO+pG+HEe7vvTxf1xL5talp4DJBCf5j/3D/ogy0U96J4G6WuniG55ExcC1X9xKN
         co7PJxjbC6iFKiqla7tD5qVfhZbb3nDDcavpbArMV9PYaqvpiJ+z5Cv8RxFIGL9EDe
         9zm6FGO/eYBKFnocgEK7BtqRXO+u1h9LV7mZ95pVzXhaTAyG0Tvv0oY6Pf9KUJZXz/
         QiwrETwQoeViyST+e07jdT8IpLpSCSF4u4ztDBwPb40gqjD93e+pzEBeUjwePykH+0
         eGBseMOBsSqvew/aK/1o3hjrMevL4hh0v8ATA8lJgoOneGcjpRGS84p/KFlNAFsF40
         EGImnRdg7USmw==
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Hardware introduces flow sampler object for packet sampling.
Add the offload hardware bits and structures.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 651591a2965d..65ea35af0527 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -10657,11 +10657,13 @@ struct mlx5_ifc_affiliated_event_header_bits {
 enum {
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY =3D BIT(0xc),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC =3D BIT(0x13),
+	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER =3D BIT(0x20),
 };
=20
 enum {
 	MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY =3D 0xc,
 	MLX5_GENERAL_OBJECT_TYPES_IPSEC =3D 0x13,
+	MLX5_GENERAL_OBJECT_TYPES_SAMPLER =3D 0x20,
 };
=20
 enum {
@@ -10736,6 +10738,33 @@ struct mlx5_ifc_create_encryption_key_in_bits {
 	struct mlx5_ifc_encryption_key_obj_bits encryption_key_object;
 };
=20
+struct mlx5_ifc_sampler_obj_bits {
+	u8         modify_field_select[0x40];
+
+	u8         table_type[0x8];
+	u8         level[0x8];
+	u8         reserved_at_50[0xf];
+	u8         ignore_flow_level[0x1];
+
+	u8         sample_ratio[0x20];
+
+	u8         reserved_at_80[0x8];
+	u8         sample_table_id[0x18];
+
+	u8         reserved_at_a0[0x8];
+	u8         default_table_id[0x18];
+
+	u8         sw_steering_icm_address_rx[0x40];
+	u8         sw_steering_icm_address_tx[0x40];
+
+	u8         reserved_at_140[0xa0];
+};
+
+struct mlx5_ifc_create_sampler_obj_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits general_obj_in_cmd_hdr;
+	struct mlx5_ifc_sampler_obj_bits sampler_object;
+};
+
 enum {
 	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_128 =3D 0x0,
 	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_256 =3D 0x1,
--=20
2.26.2

