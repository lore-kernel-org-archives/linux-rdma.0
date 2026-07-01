Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF8248A2C0;
	Wed,  1 Jul 2026 12:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782909950; cv=none; b=SiSusq8U8odu386u/AaDs09n8EsaMncE78RLM2NjkFCsB9HMJJ8UQYrLlBDl+zh5IULPFtkeSeFX5tpW000yo8lZ7ge3XSaY0vNKnA2Br+pOPUB8qZXec9il7VxxzvVXF84EkXnrGrxRbhiBeDfz9isP2pOTbFJnROCUPvntRMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782909950; c=relaxed/simple;
	bh=etax08IrxHyS7AiI+VfRaPR4iQAJGxOw2wmFePh5tdo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BT0HSM5d8DJ4mKycx6jkIwPinez6j1hCAaiqy7PLYkZMtqtes5LfsDcd0qgdfPf2zEfQMJeJzrN5VapgZNzafjYLWiDK2x7FFa+Agg5fA4E5FiMyPZtvJsXELShAOiJal7wFZtxFeAN5u6HT7TfNPjdD5u5yGwKCAqfNdaYf5lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=B95keWCI; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="B95keWCI"
Received: from PC-202605011814.localdomain (unknown [221.228.238.82])
	by smtp.qiye.163.com (Hmail) with ESMTP id 448185dfd;
	Wed, 1 Jul 2026 20:40:34 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: borisp@nvidia.com,
	saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com
Cc: andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	sd@queasysnail.net,
	dtatulea@nvidia.com,
	cjubran@nvidia.com,
	horms@kernel.org,
	jianbol@nvidia.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	runyu.xiao@seu.edu.cn,
	jianhao.xu@seu.edu.cn
Subject: [PATCH net-next] net/mlx5e: MACsec: annotate context list traversals
Date: Wed,  1 Jul 2026 20:40:30 +0800
Message-Id: <20260701124030.3208833-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9f1db2082c03a1kunm39a5032119cafd
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZTB8ZVk5MSkxISEJOS0hPQlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUpVSUlDVUlIQ1VDSVlXWRYaDxIVHRRZQVlPS0hVSktISk
	9ITFVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=B95keWCIdztnQ4neFAQ+mhCHswHGsL1tO1GVGxALWbF7XVdMj7V1ud1P3bdobvl2WQYVJ6DS9PfW/dl4EJAv4nMqa9fLV3x1kBMVnLhG4vIZ21D2+LHtEo8aS04XM4QMiBaywmK1kaSpw0lQE4ixlv+Djn2jCJdzRFbs8hbBGq4=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=d4tdyGU+MiaIXHvHOftM6m6FeoJkbFM5l+zIrOJOj+U=;
	h=date:mime-version:subject:message-id:from;

The MACsec offload control paths take macsec->lock before looking up
MACsec device and RX SC contexts. The lookup helpers walk RCU lists, but
the iterators do not currently pass the mutex condition, so
CONFIG_PROVE_RCU_LIST cannot see the existing writer/control-path
protection.

Pass lockdep_is_held(&macsec->lock) to the list iterators in the MACsec
lookup helpers. The RX SC helper does not otherwise need the MACsec
context, so pass it in only to express the existing lockdep condition.

This was found by our static analysis tool and then manually reviewed
against the current tree. The dynamic triage evidence is a
target-matched CONFIG_PROVE_RCU_LIST warning; the change is limited
to documenting the existing protection contract.

This is a lockdep annotation cleanup. It does not change MACsec context
lifetime or list updates.

Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 .../mellanox/mlx5/core/en_accel/macsec.c      | 23 +++++++++++--------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 528b04d4de41..3028e327e36d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -405,11 +405,13 @@ static int mlx5e_macsec_init_sa(struct macsec_context *ctx,
 }
 
 static struct mlx5e_macsec_rx_sc *
-mlx5e_macsec_get_rx_sc_from_sc_list(const struct list_head *list, sci_t sci)
+mlx5e_macsec_get_rx_sc_from_sc_list(struct mlx5e_macsec *macsec,
+				    const struct list_head *list, sci_t sci)
 {
 	struct mlx5e_macsec_rx_sc *iter;
 
-	list_for_each_entry_rcu(iter, list, rx_sc_list_element) {
+	list_for_each_entry_rcu(iter, list, rx_sc_list_element,
+				lockdep_is_held(&macsec->lock)) {
 		if (iter->sci == sci)
 			return iter;
 	}
@@ -473,14 +475,15 @@ static bool mlx5e_macsec_secy_features_validate(struct macsec_context *ctx)
 }
 
 static struct mlx5e_macsec_device *
-mlx5e_macsec_get_macsec_device_context(const struct mlx5e_macsec *macsec,
+mlx5e_macsec_get_macsec_device_context(struct mlx5e_macsec *macsec,
 				       const struct macsec_context *ctx)
 {
 	struct mlx5e_macsec_device *iter;
 	const struct list_head *list;
 
 	list = &macsec->macsec_device_list_head;
-	list_for_each_entry_rcu(iter, list, macsec_device_list_element) {
+	list_for_each_entry_rcu(iter, list, macsec_device_list_element,
+				lockdep_is_held(&macsec->lock)) {
 		if (iter->netdev == ctx->secy->netdev)
 			return iter;
 	}
@@ -692,7 +695,7 @@ static int mlx5e_macsec_add_rxsc(struct macsec_context *ctx)
 	}
 
 	rx_sc_list = &macsec_device->macsec_rx_sc_list_head;
-	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(rx_sc_list, ctx_rx_sc->sci);
+	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(macsec, rx_sc_list, ctx_rx_sc->sci);
 	if (rx_sc) {
 		netdev_err(ctx->netdev, "MACsec offload: rx_sc (sci %lld) already exists\n",
 			   ctx_rx_sc->sci);
@@ -775,7 +778,7 @@ static int mlx5e_macsec_upd_rxsc(struct macsec_context *ctx)
 	}
 
 	list = &macsec_device->macsec_rx_sc_list_head;
-	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(list, ctx_rx_sc->sci);
+	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(macsec, list, ctx_rx_sc->sci);
 	if (!rx_sc) {
 		err = -EINVAL;
 		goto out;
@@ -853,7 +856,7 @@ static int mlx5e_macsec_del_rxsc(struct macsec_context *ctx)
 	}
 
 	list = &macsec_device->macsec_rx_sc_list_head;
-	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(list, ctx->rx_sc->sci);
+	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(macsec, list, ctx->rx_sc->sci);
 	if (!rx_sc) {
 		netdev_err(ctx->netdev,
 			   "MACsec offload rx_sc sci %lld doesn't exist\n",
@@ -894,7 +897,7 @@ static int mlx5e_macsec_add_rxsa(struct macsec_context *ctx)
 	}
 
 	list = &macsec_device->macsec_rx_sc_list_head;
-	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(list, sci);
+	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(macsec, list, sci);
 	if (!rx_sc) {
 		netdev_err(ctx->netdev,
 			   "MACsec offload rx_sc sci %lld doesn't exist\n",
@@ -978,7 +981,7 @@ static int mlx5e_macsec_upd_rxsa(struct macsec_context *ctx)
 	}
 
 	list = &macsec_device->macsec_rx_sc_list_head;
-	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(list, sci);
+	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(macsec, list, sci);
 	if (!rx_sc) {
 		netdev_err(ctx->netdev,
 			   "MACsec offload rx_sc sci %lld doesn't exist\n",
@@ -1035,7 +1038,7 @@ static int mlx5e_macsec_del_rxsa(struct macsec_context *ctx)
 	}
 
 	list = &macsec_device->macsec_rx_sc_list_head;
-	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(list, sci);
+	rx_sc = mlx5e_macsec_get_rx_sc_from_sc_list(macsec, list, sci);
 	if (!rx_sc) {
 		netdev_err(ctx->netdev,
 			   "MACsec offload rx_sc sci %lld doesn't exist\n",
-- 
2.34.1

