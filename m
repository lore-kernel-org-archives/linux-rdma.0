Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3477C314D37
	for <linux-rdma@vger.kernel.org>; Fri, 10 Apr 2026 00:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775782354; cv=none; b=NMrEKOPDyDLIbfX9BFJeVAeGSfyJzII+3AJEoZxYegANejvOVOhKoXWpZNGYTZaJDZFJ7k5w6hsTHPES3YsykVnRjUt7EM0XQla2SMAOIYSb+hHi06hPFy06DjA2J2QGlcuVHgaoGSuSVasPq/U1h/I8CW8Vfqybl/lcuC2sEX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775782354; c=relaxed/simple;
	bh=5xpLfgmznOqThzhOWpy2txoSbW6meHNUelMnc1s51kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWfKMmGwe/1DNT6+KU3ppaqLESMAcZnIukhb2ZVOqEgWR//BK1yxZ0+p3lhV4zW3bULzZnOx7QTXnTSIBpTjIFGZxsnIPGBUE9/h38qOnPsMJG8fUChToUlSvj0Dp68RvS/ovfSj8FZyYMKSagb1EqHSdOpBFbvKZ/W+iFqKcMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lKpTS/bS; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lKpTS/bS"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso12480185e9.3
        for <linux-rdma@vger.kernel.org>; Thu, 09 Apr 2026 17:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775782351; x=1776387151; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P2lfBh3OiNADt8pKhCYVYWBN8nfUz+AvYZosbodFys0=;
        b=lKpTS/bS8qimSjLPBV0WTODPuNkhuos/1EYvC38edFDU+EedPZEH061lMY0IOslLrC
         AJ5yxCr5rVqecVyD22sjpa/sbzuaSUtT9GBlut1Yib2LJzuPD0CKkKJyTCnwl4sLPrA8
         eT4A0LwId5rPmJGQ8h859O1FcVHZw2l6QBgFvmhuzAsPxYFabRS+3CbaXnB2/UZUo58M
         0b/A/FeCZy348VRlLIwGwr8H+YgQE532KpoJ1o4ywX3DJ+a5ic24dDSFACGNN9bKbuMm
         wq4yFhWYvu9XpJiW/InWqscuXoQfTD1RlpAbeIqIWJGp0Hou+6Z4h3KU8yuQkDa84qaI
         NLaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775782351; x=1776387151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P2lfBh3OiNADt8pKhCYVYWBN8nfUz+AvYZosbodFys0=;
        b=pxwtKz8/mmCnF7g5YWA3g9sUYjDbSfORoWN81SvaDvFWZvaarALg9GK2SLyZGpCZxn
         J+Tl3Y7DJqAO23X205qptvZzH9Xrun/Rz30Hfd5i61QFxfoRaML+yet3VmwDoPY1LbaR
         PTUNHgpb6FX2OVo2YCeMzKPOrt/low7KveQ7pUd92cEb3DC+EBJFwcyhNffpR4ruq2Nt
         YJXEUHVIQOibJe0dKjrwMzQSvNeUN4Ns2Wah0LwsxWVIDZyRh6eA504/VYxwiFrBQ6ON
         jyntA9FVDB+IeOkWunJSj43kjzulhboGUNYhyzyZ/g+tLs+lOSXrWpFlqSUBCLEqOxIf
         756A==
X-Gm-Message-State: AOJu0YxsQDDxIJKuNCrR8B1RzqWcJLusYkzkxPcyb2SnJ+CovvOkzfaI
	6JFn7oi7q5KGb2Eq2/6hb5Rk9zV4VeEgyKhbU9F9MTa41WwgYlALrUn/
X-Gm-Gg: AeBDietyyjrJoBU5POnl+6dCe+UPXVGOhNbxBIA+iQ3Kzh0UPIU4X1vSlVKbsXxzTwU
	VPpXrgTDYoLAL1zdTrxYPglIdbagOIFlRXvgVr+1BM1PsdhCzuIkpNqDnmOYJZd4AskpXX/WVnn
	lrYH7tMp0Fxa68MhF/PqeqCAU9qYLfDNPXwk5khKm6X74CFeFoSnI3PQpDdkAJkK4c2WFPbKd0e
	+a1ALtfk4lDYgUhIwPVb7EkVWf6b2pGETQnBwNwsYfgyu+/P+Mhk3Xki7V7mnSirJqHwyOnVhTX
	tW/LJucgpvahQSWHnd5SYm+ksTIkz7ZaP+V/CzHZNSVREvkYmBX0Wg9mpfaKewGauwLSt7xvqrf
	6sQIoCXV3zJEv8F/P4r2R1Aa2Jky+xEq5kiR31SuSf6vaA8qWTl6yZHxVJG4cMJAh0LEy9vd0ye
	I9XG7XPGIMn8DUWsqW+lsWbJ+vDTHv3IJ93O5vWvmXCnQfJljisCA5fawzAeHX90UA3SsIw/CYf
	tnYiaRcKnXJ9yry0FZ4qwhctPj/Ezb2zaamYJDHH0OmwXqZ
X-Received: by 2002:a05:600c:45c9:b0:480:4a8f:2d5c with SMTP id 5b1f17b1804b1-488d689cf9emr9658985e9.29.1775782351429;
        Thu, 09 Apr 2026 17:52:31 -0700 (PDT)
Received: from DESKTOP-NQ2T5I7.localdomain (heme-13-b2-v4wan-167795-cust403.vm32.cable.virginm.net. [81.108.45.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d67b4903sm8508265e9.5.2026.04.09.17.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 17:52:30 -0700 (PDT)
From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
To: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dledford@redhat.com,
	haggaie@mellanox.com,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Subject: [PATCH v9 1/2] IB/mlx5: Fix transport-domain rollback and initialize lb mutex earlier
Date: Fri, 10 Apr 2026 01:52:17 +0100
Message-ID: <20260410005219.5197-2-prathameshdeshpande7@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260410005219.5197-1-prathameshdeshpande7@gmail.com>
References: <20260410005219.5197-1-prathameshdeshpande7@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mlx5_ib_alloc_transport_domain() allocates a transport domain and then
may fail in mlx5_ib_enable_lb(). In that case, the allocated TD is leaked.

Fix this by deallocating the TD when mlx5_ib_enable_lb() returns an
error. Also return 0 explicitly in the no-loopback-capability success
branch, and move dev->lb.mutex initialization to mlx5_ib_stage_init_init().

Fixes: 146d2f1af324 ("IB/mlx5: Allocate a Transport Domain for each ucontext")
Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
---
 drivers/infiniband/hw/mlx5/main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index e02bfb1479f5..6be198c0651c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2068,9 +2068,13 @@ static int mlx5_ib_alloc_transport_domain(struct mlx5_ib_dev *dev, u32 *tdn,
 	if ((MLX5_CAP_GEN(dev->mdev, port_type) != MLX5_CAP_PORT_TYPE_ETH) ||
 	    (!MLX5_CAP_GEN(dev->mdev, disable_local_lb_uc) &&
 	     !MLX5_CAP_GEN(dev->mdev, disable_local_lb_mc)))
-		return err;
+		return 0;
+
+	err = mlx5_ib_enable_lb(dev, true, false);
+	if (err)
+		mlx5_cmd_dealloc_transport_domain(dev->mdev, *tdn, uid);
 
-	return mlx5_ib_enable_lb(dev, true, false);
+	return err;
 }
 
 static void mlx5_ib_dealloc_transport_domain(struct mlx5_ib_dev *dev, u32 tdn,
@@ -4513,6 +4517,7 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 
 	mutex_init(&dev->cap_mask_mutex);
 	mutex_init(&dev->data_direct_lock);
+	mutex_init(&dev->lb.mutex);
 	INIT_LIST_HEAD(&dev->qp_list);
 	spin_lock_init(&dev->reset_flow_resource_lock);
 	xa_init(&dev->odp_mkeys);
@@ -4786,11 +4791,6 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 	if (err)
 		return err;
 
-	if ((MLX5_CAP_GEN(dev->mdev, port_type) == MLX5_CAP_PORT_TYPE_ETH) &&
-	    (MLX5_CAP_GEN(dev->mdev, disable_local_lb_uc) ||
-	     MLX5_CAP_GEN(dev->mdev, disable_local_lb_mc)))
-		mutex_init(&dev->lb.mutex);
-
 	if (MLX5_CAP_GEN_64(dev->mdev, general_obj_types) &
 			MLX5_GENERAL_OBJ_TYPES_CAP_VIRTIO_NET_Q) {
 		err = mlx5_ib_init_var_region(dev);
-- 
2.43.0

