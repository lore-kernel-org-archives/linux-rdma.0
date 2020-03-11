Return-Path: <SRS0=rL3z=44=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A31AC3F2D0
	for <linux-rdma@archiver.kernel.org>; Wed, 11 Mar 2020 05:14:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1F0F2146E
	for <linux-rdma@archiver.kernel.org>; Wed, 11 Mar 2020 05:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgCKFOH (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 11 Mar 2020 01:14:07 -0400
Received: from smtprelay0158.hostedemail.com ([216.40.44.158]:46266 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726865AbgCKFOH (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 11 Mar 2020 01:14:07 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave02.hostedemail.com (Postfix) with ESMTP id 11A721800CFFC;
        Wed, 11 Mar 2020 05:06:48 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 2B8C61800455B;
        Wed, 11 Mar 2020 05:06:46 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: screw25_1dbccd6ba8e10
X-Filterd-Recvd-Size: 6296
Received: from joe-laptop.perches.com (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed, 11 Mar 2020 05:06:44 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH -next 003/491] MELLANOX MLX5 core VPI driver: Use fallthrough;
Date:   Tue, 10 Mar 2020 21:51:17 -0700
Message-Id: <3ce4519315294b9738abe6a78e2737f49af9a653.1583896347.git.joe@perches.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583896344.git.joe@perches.com>
References: <cover.1583896344.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Convert the various uses of fallthrough comments to fallthrough;

Done via script
Link: https://lore.kernel.org/lkml/b56602fcf79f849e733e7b521bb0e17895d390fa.1582230379.git.joe.com/

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h         | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c          | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c      | 2 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c          | 8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/vport.c           | 2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index a226277..2a1cc2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -223,7 +223,7 @@ mlx5e_set_eseg_swp(struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg,
 	switch (swp_spec->tun_l4_proto) {
 	case IPPROTO_UDP:
 		eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L4_UDP;
-		/* fall through */
+		fallthrough;
 	case IPPROTO_TCP:
 		eseg->swp_inner_l4_offset = skb_inner_transport_offset(skb) / 2;
 		break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index f049e0a..f74e50 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -167,11 +167,11 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 		return true;
 	default:
 		bpf_warn_invalid_xdp_action(act);
-		/* fall through */
+		fallthrough;
 	case XDP_ABORTED:
 xdp_abort:
 		trace_xdp_exception(rq->netdev, prog, act);
-		/* fall through */
+		fallthrough;
 	case XDP_DROP:
 		rq->stats->xdp_drop++;
 		return true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 01539b8..8a3376a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -225,7 +225,7 @@ int mlx5e_ethtool_get_sset_count(struct mlx5e_priv *priv, int sset)
 		return MLX5E_NUM_PFLAGS;
 	case ETH_SS_TEST:
 		return mlx5e_self_test_num(priv);
-	/* fallthrough */
+		fallthrough;
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 4b5b661..033454 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2426,7 +2426,7 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 	case MLX5_CAP_INLINE_MODE_NOT_REQUIRED:
 		if (mode == DEVLINK_ESWITCH_INLINE_MODE_NONE)
 			return 0;
-		/* fall through */
+		fallthrough;
 	case MLX5_CAP_INLINE_MODE_L2:
 		NL_SET_ERR_MSG_MOD(extack, "Inline mode can't be set");
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index 416676..a40e43 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -199,13 +199,13 @@ static void mlx5_lag_fib_update(struct work_struct *work)
 	/* Protect internal structures from changes */
 	rtnl_lock();
 	switch (fib_work->event) {
-	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
+	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_DEL:
 		mlx5_lag_fib_route_event(ldev, fib_work->event,
 					 fib_work->fen_info.fi);
 		fib_info_put(fib_work->fen_info.fi);
 		break;
-	case FIB_EVENT_NH_ADD: /* fall through */
+	case FIB_EVENT_NH_ADD:
 	case FIB_EVENT_NH_DEL:
 		fib_nh = fib_work->fnh_info.fib_nh;
 		mlx5_lag_fib_nexthop_event(ldev,
@@ -256,7 +256,7 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 		return NOTIFY_DONE;
 
 	switch (event) {
-	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
+	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_DEL:
 		fen_info = container_of(info, struct fib_entry_notifier_info,
 					info);
@@ -279,7 +279,7 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 		 */
 		fib_info_hold(fib_work->fen_info.fi);
 		break;
-	case FIB_EVENT_NH_ADD: /* fall through */
+	case FIB_EVENT_NH_ADD:
 	case FIB_EVENT_NH_DEL:
 		fnh_info = container_of(info, struct fib_nh_notifier_info,
 					info);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 1faac31f..aea1065 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -125,7 +125,7 @@ void mlx5_query_min_inline(struct mlx5_core_dev *mdev,
 	case MLX5_CAP_INLINE_MODE_VPORT_CONTEXT:
 		if (!mlx5_query_nic_vport_min_inline(mdev, 0, min_inline_mode))
 			break;
-		/* fall through */
+		fallthrough;
 	case MLX5_CAP_INLINE_MODE_L2:
 		*min_inline_mode = MLX5_INLINE_MODE_L2;
 		break;
-- 
2.24.0

