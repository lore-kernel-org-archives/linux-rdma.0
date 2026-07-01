Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B36C2AD37
	for <linux-rdma@vger.kernel.org>; Wed,  1 Jul 2026 12:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782909633; cv=none; b=VnxosKSJ7kU54RkcbO6M244rqEJ7yOoEvYNQxRhMONAowVzNpl9d+qWE2w5sXWtSetwSpxUETmP6mboBCTaDioNeeW0xGGQWwsJDm6DYO1SyN5SUha0ibmn2u109/+edXt5LFVdIaenJDOJU4rUPz9xHhmSxP3kx7w0qa01JiIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782909633; c=relaxed/simple;
	bh=tyOjKoXZ0+jA2R9a+gULQ9hJ4l7RptVe3o8ayNR1+OE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyUdivyqoXzQM9pkRvrGdBVzVTuU+WROP6mdAR9LQi1NUSe1ZMCEk42k356stqDV09xBeUnD9nMaSqfKy0rLGdchP/KuMbM+9d+j14D3VDGYUPHDgTDP01xZ0jrX76gEIu4NXiE2iOqnWX/WfS9aBXUK70UkFciIbuH/jwsQhcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=BRsC14qO; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="BRsC14qO"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4629051c9d1so465353f8f.2
        for <linux-rdma@vger.kernel.org>; Wed, 01 Jul 2026 05:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1782909630; x=1783514430; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qiwSVmvKh7lGEElsNNaBw0tehvYFwvEBKphXOQhNERA=;
        b=BRsC14qOLEqZQvZBpmZNcE4fiNYYxjS53RXSHPRixfyYhKu3GSgFxHy1o1MaCdjRfE
         HY+9rLE4Oops0kRgkT0AZz3zdJWVYealdCar+YN877HxZ1qe3Tua32EmZEiI4CmZH2Kz
         5C/16ZqyW2siIOYclC7QJyBrD3QWhCcan/25SEYgE1NmyjQr0p++05Klxr+xTS05EH4S
         2jrHgubpWIcH3XxHLQ6//IJg3moYUuic2AeXoXU+kaZfY/eLjRkzfISi7LAHwK3vRsy5
         PEknVnvxJT9ZSM9YD5mrauDqEz/bbKY5K+7JyfzGQIzMj7ZaQW0cdrvW85mn2d5TKmOx
         Lmbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782909630; x=1783514430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qiwSVmvKh7lGEElsNNaBw0tehvYFwvEBKphXOQhNERA=;
        b=I+hq62AQY2/FouZwlDfpQVpAi5QWviElsCJ3uJlz1IrHUmpZckuDGAlC2EIISIM+qC
         mvgkCltfVge26rsWFZsV0/nBOX201mpAeg2ixbvlljkhSxqso5c7ixaBCbThcbWa2s8O
         qukcOxCPNFSxUPQWaNXwJbGwtoFX6kpNid+5YiHl2+yHeD0tRX0Qal+feI2C4sggD+pt
         UuYOj9uQSKHebD4o5bi1moPJ2YkJFrv2A7fUnfpcy5VLg8Hv6Ets5d1rlnOMe2gOBwGj
         XkNdXH/haR7e6WGA3BzHgnpKKybUhm9kyfKAlYkBs+/E4FkT3zNHmCQu4DXqIVxLhs26
         srCg==
X-Gm-Message-State: AOJu0YwXp22HEVM9ecBSh8Zx/0A0tlObXU7NWqAflfWUg9XkqtkQ021G
	fslbLGO0WzeFcyW5tfZgedaiSwiJktHeJiB5UYkvrQ2lc9V+qOfqZey64Q1f6bEHul1jkP2mPUp
	Zzth4
X-Gm-Gg: AfdE7cmHEQKt7Ez9L6i2J6Mlazse5veSW21NuqZmdCmjJALT9q307w8P9xsPw8FSj1t
	i2RghCSTw+RH5o2Y98WO0A4whWUzKwW2u8kSYgh4+wwfiImrqCGIWLW9yVI6J+/p/lYUptVfk3Q
	Xt3EQ3oFCjo6fyfErj7wmgGSfvLs3SxepKEc87hl5mC8c8H9ERxjufxsVE2BfoNOSs+XmPOe0BB
	ixSHA6kqWDOZb427Of6SQMbmKjtg7vva6H10IkVEMYBQI5YHq4ZyPwMf4QEF9o2ZYNLa/y20gmE
	tg34BqJpwkRY/qPtlR40L24ZPgNKjksPtfAlSyKrIr9gx1VsNdTLzAodmbB3JvCJQ3kHnQ7KgtH
	2g/SVrT2ZM3uK9a+J1zMKrj/BQbry2VlvfHjo7Qtc3zeqAm3fyYiIaT5WlAmSdGbcXHEzhjpLw2
	eFljz3fesGxs4RkNSWPqXiTA==
X-Received: by 2002:a05:6000:114f:b0:475:f0f0:9ed1 with SMTP id ffacd0b85a97d-477b601c230mr394390f8f.60.1782909630001;
        Wed, 01 Jul 2026 05:40:30 -0700 (PDT)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4756636cdccsm15425272f8f.24.2026.07.01.05.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 05:40:29 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: linux-rdma@vger.kernel.org
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	mrgolin@amazon.com
Subject: [PATCH rdma-next v3 3/3] RDMA/mlx5: Use UMEM attribute for SRQ doorbell record
Date: Wed,  1 Jul 2026 14:40:15 +0200
Message-ID: <20260701124015.64350-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260701124015.64350-1-jiri@resnulli.us>
References: <20260701124015.64350-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

Add an optional mlx5 driver-namespace UMEM attribute on SRQ create so
userspace can supply the doorbell record umem explicitly, symmetric to
the CQ and QP sides. Resolve it inside mlx5_ib_db_map_user() and use it
as a private DBR page when present; otherwise take the existing UHW
share-or-pin path that preserves per-page DBR sharing across CQ/QP/SRQ
in the same process.

Add mlx5's first UVERBS_OBJECT_SRQ UAPI definition chain to attach the
new attr.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c        |  1 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h     |  1 +
 drivers/infiniband/hw/mlx5/srq.c         | 19 ++++++++++++++++++-
 include/uapi/rdma/mlx5_user_ioctl_cmds.h |  4 ++++
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 02809114fc79..bdf59537f87b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4477,6 +4477,7 @@ static const struct uapi_definition mlx5_ib_defs[] = {
 	UAPI_DEF_CHAIN(mlx5_ib_dm_defs),
 	UAPI_DEF_CHAIN(mlx5_ib_create_cq_defs),
 	UAPI_DEF_CHAIN(mlx5_ib_create_qp_defs),
+	UAPI_DEF_CHAIN(mlx5_ib_create_srq_defs),
 
 	UAPI_DEF_CHAIN_OBJ_TREE(UVERBS_OBJECT_DEVICE, &mlx5_ib_query_context),
 	UAPI_DEF_CHAIN_OBJ_TREE(UVERBS_OBJECT_MR, &mlx5_ib_reg_dmabuf_mr),
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 522984d958bb..e9ddf2e97a76 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1517,6 +1517,7 @@ extern const struct uapi_definition mlx5_ib_qos_defs[];
 extern const struct uapi_definition mlx5_ib_std_types_defs[];
 extern const struct uapi_definition mlx5_ib_create_cq_defs[];
 extern const struct uapi_definition mlx5_ib_create_qp_defs[];
+extern const struct uapi_definition mlx5_ib_create_srq_defs[];
 
 static inline int is_qp1(enum ib_qp_type qp_type)
 {
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 6fa4c5a9a0d5..a973c1b7515f 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -10,6 +10,9 @@
 #include "mlx5_ib.h"
 #include "srq.h"
 
+#define UVERBS_MODULE_NAME mlx5_ib
+#include <rdma/uverbs_named_ioctl.h>
+
 static void *get_wqe(struct mlx5_ib_srq *srq, int n)
 {
 	return mlx5_frag_buf_get_wqe(&srq->fbc, n);
@@ -78,7 +81,9 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 	}
 	in->umem = srq->umem;
 
-	err = mlx5_ib_db_map_user(ucontext, NULL, 0, ucmd.db_addr, &srq->db);
+	err = mlx5_ib_db_map_user(ucontext, attrs,
+				  MLX5_IB_ATTR_CREATE_SRQ_DBR_BUF_UMEM,
+				  ucmd.db_addr, &srq->db);
 	if (err) {
 		mlx5_ib_dbg(dev, "map doorbell failed\n");
 		goto err_umem;
@@ -466,3 +471,15 @@ int mlx5_ib_post_srq_recv(struct ib_srq *ibsrq, const struct ib_recv_wr *wr,
 
 	return err;
 }
+
+ADD_UVERBS_ATTRIBUTES_SIMPLE(
+	mlx5_ib_srq_create,
+	UVERBS_OBJECT_SRQ,
+	UVERBS_METHOD_SRQ_CREATE,
+	UVERBS_ATTR_UMEM(MLX5_IB_ATTR_CREATE_SRQ_DBR_BUF_UMEM,
+			 UA_OPTIONAL));
+
+const struct uapi_definition mlx5_ib_create_srq_defs[] = {
+	UAPI_DEF_CHAIN_OBJ_TREE(UVERBS_OBJECT_SRQ, &mlx5_ib_srq_create),
+	{},
+};
diff --git a/include/uapi/rdma/mlx5_user_ioctl_cmds.h b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
index ddb898afd813..3528743e3858 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_cmds.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
@@ -281,6 +281,10 @@ enum mlx5_ib_create_qp_attrs {
 	MLX5_IB_ATTR_CREATE_QP_DBR_BUF_UMEM = UVERBS_ID_DRIVER_NS_WITH_UHW,
 };
 
+enum mlx5_ib_create_srq_attrs {
+	MLX5_IB_ATTR_CREATE_SRQ_DBR_BUF_UMEM = UVERBS_ID_DRIVER_NS_WITH_UHW,
+};
+
 enum mlx5_ib_reg_dmabuf_mr_attrs {
 	MLX5_IB_ATTR_REG_DMABUF_MR_ACCESS_FLAGS = (1U << UVERBS_ID_NS_SHIFT),
 };
-- 
2.54.0

