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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95079C8300F
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Nov 2020 23:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 422CE2415A
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Nov 2020 23:04:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="lVUxZiTT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729001AbgKTXE0 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 20 Nov 2020 18:04:26 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1192 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728581AbgKTXEL (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 20 Nov 2020 18:04:11 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb84b5f0005>; Fri, 20 Nov 2020 15:03:59 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 23:04:03 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        Bodong Wang <bodong@nvidia.com>
Subject: [PATCH mlx5-next 13/16] net/mlx5: Make API mlx5_core_is_ecpf accept const pointer
Date:   Fri, 20 Nov 2020 15:03:36 -0800
Message-ID: <20201120230339.651609-14-saeedm@nvidia.com>
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
        t=1605913439; bh=tzFSNlIm/g4KNBfZc8WZsJki++6PI4cu4lGYrS95WD8=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=lVUxZiTTpAratA7ww8KQwi7d7LloEyJSYm/JCVdKbJ+GfX75okhN/bSam0k90nFLH
         K3nsjsG7LQHgr0N4fyJ9KTMufSi8JplufzNS5kzOmT0SaPelI6TGS7ygmFoud/BXUX
         pCTZDE4fo0M052wRvS4IuSeGKNjamtW0ieDaXuzyqAjrU03vVy0LaUzEXYgS4vBGby
         io/WmDqA7zXvSAvNeaBU12VCQBSzY7oGMX4LxGzccHY7fId8MjxHQYI1Epr/WeZjDW
         /k4otjRp3H5YlBl49V4AmAk8mcPX+YrPtLTwlAAFRixyaMpjyJ5tEEsupckwLfDXot
         0mWMeZTJ+jw0w==
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Subsequent patch implements helper API which has mlx5_core_dev
as const pointer, make its caller API too const *.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Bodong Wang <bodong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/driver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 5e84b1d53650..d6ef3068d7d3 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1133,7 +1133,7 @@ static inline bool mlx5_core_is_vf(const struct mlx5_=
core_dev *dev)
 	return dev->coredev_type =3D=3D MLX5_COREDEV_VF;
 }
=20
-static inline bool mlx5_core_is_ecpf(struct mlx5_core_dev *dev)
+static inline bool mlx5_core_is_ecpf(const struct mlx5_core_dev *dev)
 {
 	return dev->caps.embedded_cpu;
 }
--=20
2.26.2

