Return-Path: <SRS0=rh+6=6L=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D13FC7C861
	for <linux-rdma@archiver.kernel.org>; Mon, 27 Apr 2020 15:48:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 593DA20738
	for <linux-rdma@archiver.kernel.org>; Mon, 27 Apr 2020 15:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588002482;
	bh=gLowo0HlTN/QzXF1ObkNu+f+Xtbp3wajfEZWbUxRftg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=JzZJqtLA3x9H63c/qLtdMXgrIHESteocXe6XO+PjMLshGn412mDB6YD2ozQvpNWHZ
	 wcMKVR493BcDvqq8VdwMM3tD6TpfhCmUSFwwL5G+RHnnEcgr0Vu0G/tWBuJoqWnVvB
	 q0mPQ+iosY09AEPWwxuIN1JSGAzcpsNqq4IX4+x8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgD0PsB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 27 Apr 2020 11:48:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728318AbgD0PsB (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 27 Apr 2020 11:48:01 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2DFD2064C;
        Mon, 27 Apr 2020 15:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588002480;
        bh=gLowo0HlTN/QzXF1ObkNu+f+Xtbp3wajfEZWbUxRftg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+l2Iis5wVg5NCMeCJcB4/kW3XRfnn41zmW8Qn856uWn4RhIYJ+7LyrmRC9J9GXNv
         Az/54Exuz3hd65Pibc0c7JbEs/HA4+3XJV6dJIHhqBX2Y0pTeg4AfAWm/ozgYtmU37
         Lu9ZR7kkbSinp3iOO+yoVzEejjltgj0ANKR6pq+k=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Aharon Landau <aharonl@mellanox.com>,
        Eli Cohen <eli@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH rdma-next v1 19/36] RDMA/mlx5: Delete unsupported QP types
Date:   Mon, 27 Apr 2020 18:46:19 +0300
Message-Id: <20200427154636.381474-20-leon@kernel.org>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200427154636.381474-1-leon@kernel.org>
References: <20200427154636.381474-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

There is no need to explicitly check unsupported QP types,
rely on  "default" keyword in switch-case to catch them.

Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 2673678f1899..5e156b02816a 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -760,10 +760,7 @@ static int to_mlx5_st(enum ib_qp_type type)
 	case IB_QPT_SMI:		return MLX5_QP_ST_QP0;
 	case MLX5_IB_QPT_HW_GSI:	return MLX5_QP_ST_QP1;
 	case MLX5_IB_QPT_DCI:		return MLX5_QP_ST_DCI;
-	case IB_QPT_RAW_IPV6:		return MLX5_QP_ST_RAW_IPV6;
-	case IB_QPT_RAW_PACKET:
-	case IB_QPT_RAW_ETHERTYPE:	return MLX5_QP_ST_RAW_ETHERTYPE;
-	case IB_QPT_MAX:
+	case IB_QPT_RAW_PACKET:		return MLX5_QP_ST_RAW_ETHERTYPE;
 	default:		return -EINVAL;
 	}
 }
@@ -2282,14 +2279,10 @@ static void get_cqs(enum ib_qp_type qp_type,
 	case IB_QPT_RC:
 	case IB_QPT_UC:
 	case IB_QPT_UD:
-	case IB_QPT_RAW_IPV6:
-	case IB_QPT_RAW_ETHERTYPE:
 	case IB_QPT_RAW_PACKET:
 		*send_cq = ib_send_cq ? to_mcq(ib_send_cq) : NULL;
 		*recv_cq = ib_recv_cq ? to_mcq(ib_recv_cq) : NULL;
 		break;
-
-	case IB_QPT_MAX:
 	default:
 		*send_cq = NULL;
 		*recv_cq = NULL;
@@ -2434,9 +2427,6 @@ static int check_qp_type(struct mlx5_ib_dev *dev, struct ib_qp_init_attr *attr)
 	case IB_QPT_DRIVER:
 	case IB_QPT_GSI:
 		return 0;
-	case IB_QPT_RAW_IPV6:
-	case IB_QPT_RAW_ETHERTYPE:
-	case IB_QPT_MAX:
 	default:
 		goto out;
 	}
-- 
2.25.3

