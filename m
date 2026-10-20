Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792465420;
	b=jPpFlyTG4QSAm7kC5JK3TdEOhKKmelkXAIm4RBMyXx4LVus4NWsB6m4tiw/GQI65JVMn
	 BHABD0ZgonyA8X2dJrpv0JXAHRvpD0zyrBxjElJUiy+abpfeDvah7L1r8YtBoGhnbOTH6
	 f5GV2hBHY6lP+A6tJza8EGPtzD/EF0cT5inEOQNbjWMr+zjQ/L/aBoDxg3EH/FfmoewYL
	 ufDghoGln5K7Ygtv7xncUStZunkwovJ4ufOUy/bUBzeoq9L0ctNv+i0W5vXd2iQvF4S4d
	 GnDIpR0eVXVac5j3oFZKCWyRWWSsXeVnML0+HFhejTbdFTdYQOC65c1YoWE2Bhr3g5Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792465420;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Erlc6cYh8XO3PP+6ip90r/fbMGxpD7X3puXEMao1FdE=;
	b=j+Oo8bg3l3L7m35V4muSvlUbuWMRL2QI/vurwUyty3ir+mVqkCBAFUH5NiBfs5m1S3TN
	 +ULk8PZFPtPhQiRzCZgKFJVfnCztfvQmQcA74CUrdlzDC2DH7RnfxrlMqnnQCWi6OXnhz
	 vavr9OjO8nKNmuk+fZlJ0FKR5+aIw4W6jUAy7PdkdbV2gfH8IHzShRNYSbbmGzNY5jxrX
	 OvEVtMd+dIwXoA60XElLCfFmi81yatkz2GKSHhbc2yXUb8y0Ifdvg+vJSX8dbXLrlPdr0
	 wvRMtDNMdH88nGl9uzkfKcZpgUThNwbA6wpsiTdqI3eTy+XOxok0uTycCx3hY0LqiRw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OW3iiOl7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C885D60A2605;
	Tue, 20 Oct 2026 03:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OW3iiOl7
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792465419;
	b=0L11yO8AVkckpU+VEfOetHXLNBjI3A3b628SUgkjg8Z8ikqGkh6cSmZniM+/uq9I1pYb
	 HTHMNizIYWClRHUA4xOLv4AHryYnVre1MIf5zONEcOzM055O+kRFvTuZYoF5JuX4zHoS8
	 ArY5h1GSixbhiCT1dCHl7hhmdN53mjelrwN7EkHO2yjC/DDAGBm2jWqF2jYkr3ydZNJRH
	 YCOQkVH+ujUq2MP5meYi2tyycax8Fx3dmZ3G5deUvpDVKuC/kbRxlI7F5IpHltY5CTpav
	 fBlMU+qeADJ4tRe4qLXC2nhEBXwTYMxwbt+sR+rEYezG0qzzMlF6qyKF1gztNyLtdsA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792465419;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Erlc6cYh8XO3PP+6ip90r/fbMGxpD7X3puXEMao1FdE=;
	b=0nLhq+1u1aPr8UMXD+OG5APVGmm2qJcNysMSoPHo7k3BIOSuztjl9H9NcJXJrVlkSHdY
	 8LfeTRRE8TMkWiSK3A/BHjM85GEtzZ92LGvGWintCo7IMTsXG1x+GRwD1bxLqJ8s49u7H
	 /0ZsRLOuwd8b4HlIHSxxz5JNDnipIuLNSKIqb+VEv1dXt9TSkLbH/OR9+Xh3jmO7oCKM1
	 8IAfDRPlelCMDmU7ucz5oDr4CLTem+gIGO58sTgF/89ZkgXHzfad6a8seyClvdfJPLDeX
	 ZcDMj1fY0tzqSSCc8IWi8sx0nRBM2MUpIW713+7GVgs8tSiu9XH0L7aWF0GdA9z92yQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 79C971F000C7;
	Tue, 20 Oct 2026 03:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792465419;
	bh=Erlc6cYh8XO3PP+6ip90r/fbMGxpD7X3puXEMao1FdE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=OW3iiOl7c17zrExGHxtqGWoO7646lsMh99RGz6R64pizEM6GuEIa7ypecPHCwui0l
	 IMCt9zk72H8jDv1vRrP72FgspePvdOmgL+wPMSrLQuU6Gs3GEeEaTZOHk1Hlwj6KNG
	 yx13TfQpmHAW/gr9vxOp3CODSE7L0zZx0Nm2biTY/AjEYAIZn91jj5IF83FpjW9BTI
	 hsWJfoyO36XKpMfsSV3tWnKDYg5/XWKQmZPqWx1Yvd4n5Koef10PEr5llylEuo2N0+
	 atzAkU5kxEMIDpvax6lK/3M6kr8MT5m2+QSQfMGJBKPOzSlqfI0dlCDrwjGoL/oBYk
	 LSI9WpZ812yug==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 465484071E;
	Tue, 20 Oct 2026 03:03:35 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Mon, 19 Oct 2026 20:03:35 -0700
Subject: [PATCH rdma-next v2 08/13] RDMA/uverbs: factor out the queue pair
 attribute copy
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261019-uet-ib-core-v2-8-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
In-Reply-To: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792465414; l=9598;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=xdXkQszZ/RTpRqAzPH4bgxWH9OY3mxRumMhAV6qaiqs=;
 b=nH3ygd7BHzWRHHp9ZemgtsV/3aM6uLXbyhUR2WrTvPBDSqXGh6ShAMjQQM9/Lp4ztEwz5iasS
 KtHs/ZHKH9LAaDbwmK0lo2MyDJSJtdTUsT2WLBaD93vnXfMlG2yo+xn
X-Developer-Key: i=eric.davis@broadcom.com; a=ed25519;
 pk=uy3oCTOYBipIPjryXGMynBmtPvbO6qN2FOrduzpiI4A=
X-Endpoint-Received: by B4 Relay for eric.davis@broadcom.com/20261014 with
 auth_id=1186
X-Original-From: Eric Davis <eric.davis@broadcom.com>
Reply-To: eric.davis@broadcom.com
Content-Transfer-Encoding: 7bit

From: Eric Davis <eric.davis@broadcom.com>

modify_qp() validates a set of attributes that came from userspace and
copies the ones its mask names into their kernel form. Queue pair
creation needs the same work for a transport that is ready to send as
soon as the pair exists, so move it into ib_uverbs_copy_qp_attr().

No functional change.

Signed-off-by: Eric Davis <eric.davis@broadcom.com>
---
 drivers/infiniband/core/uverbs.h     |   6 ++
 drivers/infiniband/core/uverbs_cmd.c | 191 ++++++++++++++++++-----------------
 2 files changed, 105 insertions(+), 92 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 6bc7cc6621cb..8c461a172217 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -319,6 +319,12 @@ struct ib_uverbs_flow_spec {
 	};
 };
 
+int ib_uverbs_copy_qp_attr(struct uverbs_attr_bundle *attrs,
+			   struct ib_device *device,
+			   struct ib_qp_attr *attr,
+			   const struct ib_uverbs_ex_modify_qp *src,
+			   u32 mask);
+
 int ib_uverbs_kern_spec_to_ib_spec_filter(enum ib_flow_spec_type type,
 					  const void *kern_spec_mask,
 					  const void *kern_spec_val,
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index cca386b2c3f0..a35b743ab9bd 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1779,7 +1779,7 @@ int copy_ah_attr_from_uverbs_ah(struct ib_device *dev,
 
 static void copy_ah_attr_from_uverbs(struct ib_device *dev,
 				     struct rdma_ah_attr *rdma_attr,
-				     struct ib_uverbs_qp_dest *uverb_attr)
+				     const struct ib_uverbs_qp_dest *uverb_attr)
 {
 	rdma_attr->type = rdma_ah_find_type(dev, uverb_attr->port_num);
 	if (uverb_attr->is_global) {
@@ -1800,6 +1800,101 @@ static void copy_ah_attr_from_uverbs(struct ib_device *dev,
 	rdma_ah_set_make_grd(rdma_attr, false);
 }
 
+/* Validate a set of QP attributes that came from userspace and copy the ones
+ * the mask names into their kernel form. Shared by the modify command, and by
+ * queue pair creation which takes the same set of attributes for a transport
+ * that is ready to send as soon as the QP is created.
+ */
+int ib_uverbs_copy_qp_attr(struct uverbs_attr_bundle *attrs,
+			   struct ib_device *device,
+			   struct ib_qp_attr *attr,
+			   const struct ib_uverbs_ex_modify_qp *src,
+			   u32 mask)
+{
+	/* Last bit is reserved for extending the attr_mask by using
+	 * another field.
+	 */
+	if (mask & ~(IB_QP_ATTR_STANDARD_BITS | IB_QP_RATE_LIMIT))
+		return -EOPNOTSUPP;
+
+	if ((mask & IB_QP_PORT) &&
+	    !rdma_is_port_valid(device, src->base.port_num))
+		return -EINVAL;
+
+	if ((mask & IB_QP_AV) &&
+	    !rdma_is_port_valid(device, src->base.dest.port_num))
+		return -EINVAL;
+
+	if ((mask & IB_QP_ALT_PATH) &&
+	    (!rdma_is_port_valid(device, src->base.alt_port_num) ||
+	     !rdma_is_port_valid(device, src->base.alt_dest.port_num) ||
+	     src->base.alt_port_num != src->base.alt_dest.port_num))
+		return -EINVAL;
+
+	if (((mask & IB_QP_CUR_STATE) && src->base.cur_qp_state > IB_QPS_ERR) ||
+	    ((mask & IB_QP_STATE) && src->base.qp_state > IB_QPS_ERR))
+		return -EINVAL;
+
+	if (mask & IB_QP_STATE)
+		attr->qp_state = src->base.qp_state;
+	if (mask & IB_QP_CUR_STATE)
+		attr->cur_qp_state = src->base.cur_qp_state;
+	if (mask & IB_QP_PATH_MTU)
+		attr->path_mtu = src->base.path_mtu;
+	if (mask & IB_QP_PATH_MIG_STATE)
+		attr->path_mig_state = src->base.path_mig_state;
+	if (mask & IB_QP_QKEY) {
+		if (src->base.qkey & IB_QP_SET_QKEY &&
+		    !(rdma_nl_get_privileged_qkey() ||
+		      rdma_uattrs_has_raw_cap(attrs)))
+			return -EPERM;
+		attr->qkey = src->base.qkey;
+	}
+	if (mask & IB_QP_RQ_PSN)
+		attr->rq_psn = src->base.rq_psn;
+	if (mask & IB_QP_SQ_PSN)
+		attr->sq_psn = src->base.sq_psn;
+	if (mask & IB_QP_DEST_QPN)
+		attr->dest_qp_num = src->base.dest_qp_num;
+	if (mask & IB_QP_ACCESS_FLAGS)
+		attr->qp_access_flags = src->base.qp_access_flags;
+	if (mask & IB_QP_PKEY_INDEX)
+		attr->pkey_index = src->base.pkey_index;
+	if (mask & IB_QP_EN_SQD_ASYNC_NOTIFY)
+		attr->en_sqd_async_notify = src->base.en_sqd_async_notify;
+	if (mask & IB_QP_MAX_QP_RD_ATOMIC)
+		attr->max_rd_atomic = src->base.max_rd_atomic;
+	if (mask & IB_QP_MAX_DEST_RD_ATOMIC)
+		attr->max_dest_rd_atomic = src->base.max_dest_rd_atomic;
+	if (mask & IB_QP_MIN_RNR_TIMER)
+		attr->min_rnr_timer = src->base.min_rnr_timer;
+	if (mask & IB_QP_PORT)
+		attr->port_num = src->base.port_num;
+	if (mask & IB_QP_TIMEOUT)
+		attr->timeout = src->base.timeout;
+	if (mask & IB_QP_RETRY_CNT)
+		attr->retry_cnt = src->base.retry_cnt;
+	if (mask & IB_QP_RNR_RETRY)
+		attr->rnr_retry = src->base.rnr_retry;
+	if (mask & IB_QP_ALT_PATH) {
+		attr->alt_port_num = src->base.alt_port_num;
+		attr->alt_timeout = src->base.alt_timeout;
+		attr->alt_pkey_index = src->base.alt_pkey_index;
+	}
+	if (mask & IB_QP_RATE_LIMIT)
+		attr->rate_limit = src->rate_limit;
+
+	if (mask & IB_QP_AV)
+		copy_ah_attr_from_uverbs(device, &attr->ah_attr,
+					 &src->base.dest);
+
+	if (mask & IB_QP_ALT_PATH)
+		copy_ah_attr_from_uverbs(device, &attr->alt_ah_attr,
+					 &src->base.alt_dest);
+
+	return 0;
+}
+
 static int modify_qp(struct uverbs_attr_bundle *attrs,
 		     struct ib_uverbs_ex_modify_qp *cmd)
 {
@@ -1818,18 +1913,7 @@ static int modify_qp(struct uverbs_attr_bundle *attrs,
 		goto out;
 	}
 
-	if ((cmd->base.attr_mask & IB_QP_PORT) &&
-	    !rdma_is_port_valid(qp->device, cmd->base.port_num)) {
-		ret = -EINVAL;
-		goto release_qp;
-	}
-
 	if ((cmd->base.attr_mask & IB_QP_AV)) {
-		if (!rdma_is_port_valid(qp->device, cmd->base.dest.port_num)) {
-			ret = -EINVAL;
-			goto release_qp;
-		}
-
 		if (cmd->base.attr_mask & IB_QP_STATE &&
 		    cmd->base.qp_state == IB_QPS_RTR) {
 		/* We are in INIT->RTR TRANSITION (if we are not,
@@ -1878,80 +1962,10 @@ static int modify_qp(struct uverbs_attr_bundle *attrs,
 		}
 	}
 
-	if ((cmd->base.attr_mask & IB_QP_ALT_PATH) &&
-	    (!rdma_is_port_valid(qp->device, cmd->base.alt_port_num) ||
-	    !rdma_is_port_valid(qp->device, cmd->base.alt_dest.port_num) ||
-	    cmd->base.alt_port_num != cmd->base.alt_dest.port_num)) {
-		ret = -EINVAL;
-		goto release_qp;
-	}
-
-	if ((cmd->base.attr_mask & IB_QP_CUR_STATE &&
-	    cmd->base.cur_qp_state > IB_QPS_ERR) ||
-	    (cmd->base.attr_mask & IB_QP_STATE &&
-	    cmd->base.qp_state > IB_QPS_ERR)) {
-		ret = -EINVAL;
+	ret = ib_uverbs_copy_qp_attr(attrs, qp->device, attr, cmd,
+				     cmd->base.attr_mask);
+	if (ret)
 		goto release_qp;
-	}
-
-	if (cmd->base.attr_mask & IB_QP_STATE)
-		attr->qp_state = cmd->base.qp_state;
-	if (cmd->base.attr_mask & IB_QP_CUR_STATE)
-		attr->cur_qp_state = cmd->base.cur_qp_state;
-	if (cmd->base.attr_mask & IB_QP_PATH_MTU)
-		attr->path_mtu = cmd->base.path_mtu;
-	if (cmd->base.attr_mask & IB_QP_PATH_MIG_STATE)
-		attr->path_mig_state = cmd->base.path_mig_state;
-	if (cmd->base.attr_mask & IB_QP_QKEY) {
-		if (cmd->base.qkey & IB_QP_SET_QKEY &&
-		    !(rdma_nl_get_privileged_qkey() ||
-		      rdma_uattrs_has_raw_cap(attrs))) {
-			ret = -EPERM;
-			goto release_qp;
-		}
-		attr->qkey = cmd->base.qkey;
-	}
-	if (cmd->base.attr_mask & IB_QP_RQ_PSN)
-		attr->rq_psn = cmd->base.rq_psn;
-	if (cmd->base.attr_mask & IB_QP_SQ_PSN)
-		attr->sq_psn = cmd->base.sq_psn;
-	if (cmd->base.attr_mask & IB_QP_DEST_QPN)
-		attr->dest_qp_num = cmd->base.dest_qp_num;
-	if (cmd->base.attr_mask & IB_QP_ACCESS_FLAGS)
-		attr->qp_access_flags = cmd->base.qp_access_flags;
-	if (cmd->base.attr_mask & IB_QP_PKEY_INDEX)
-		attr->pkey_index = cmd->base.pkey_index;
-	if (cmd->base.attr_mask & IB_QP_EN_SQD_ASYNC_NOTIFY)
-		attr->en_sqd_async_notify = cmd->base.en_sqd_async_notify;
-	if (cmd->base.attr_mask & IB_QP_MAX_QP_RD_ATOMIC)
-		attr->max_rd_atomic = cmd->base.max_rd_atomic;
-	if (cmd->base.attr_mask & IB_QP_MAX_DEST_RD_ATOMIC)
-		attr->max_dest_rd_atomic = cmd->base.max_dest_rd_atomic;
-	if (cmd->base.attr_mask & IB_QP_MIN_RNR_TIMER)
-		attr->min_rnr_timer = cmd->base.min_rnr_timer;
-	if (cmd->base.attr_mask & IB_QP_PORT)
-		attr->port_num = cmd->base.port_num;
-	if (cmd->base.attr_mask & IB_QP_TIMEOUT)
-		attr->timeout = cmd->base.timeout;
-	if (cmd->base.attr_mask & IB_QP_RETRY_CNT)
-		attr->retry_cnt = cmd->base.retry_cnt;
-	if (cmd->base.attr_mask & IB_QP_RNR_RETRY)
-		attr->rnr_retry = cmd->base.rnr_retry;
-	if (cmd->base.attr_mask & IB_QP_ALT_PATH) {
-		attr->alt_port_num = cmd->base.alt_port_num;
-		attr->alt_timeout = cmd->base.alt_timeout;
-		attr->alt_pkey_index = cmd->base.alt_pkey_index;
-	}
-	if (cmd->base.attr_mask & IB_QP_RATE_LIMIT)
-		attr->rate_limit = cmd->rate_limit;
-
-	if (cmd->base.attr_mask & IB_QP_AV)
-		copy_ah_attr_from_uverbs(qp->device, &attr->ah_attr,
-					 &cmd->base.dest);
-
-	if (cmd->base.attr_mask & IB_QP_ALT_PATH)
-		copy_ah_attr_from_uverbs(qp->device, &attr->alt_ah_attr,
-					 &cmd->base.alt_dest);
 
 	ret = ib_modify_qp_with_udata(qp, attr,
 				      modify_qp_mask(qp->qp_type,
@@ -1994,13 +2008,6 @@ static int ib_uverbs_ex_modify_qp(struct uverbs_attr_bundle *attrs)
 	if (ret)
 		return ret;
 
-	/*
-	 * Last bit is reserved for extending the attr_mask by
-	 * using another field.
-	 */
-	if (cmd.base.attr_mask & ~(IB_QP_ATTR_STANDARD_BITS | IB_QP_RATE_LIMIT))
-		return -EOPNOTSUPP;
-
 	ret = modify_qp(attrs, &cmd);
 	if (ret)
 		return ret;

-- 
2.56.0


