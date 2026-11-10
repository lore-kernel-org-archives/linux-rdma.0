Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794283268;
	b=XFGwQLlCrOn9CD/jRdjGtTNA+y1+d3ltF3UAtZ3mc5XRkI0PfYxGRbfpg5589Ido1EHF
	 Yr1cJRCfAlNEMSKQKzjTPAyPlvJVEjXtuOb0stNCGTPQGUmvQzJ6MxYSH4IVjB00tiazw
	 W0vFmDlMlcYkdv26OU+yciOOXGZgsUOm5dSl231rdHCPYOAT0ncxzWq0Eu7oNnxP4SAhX
	 wOR/vr3s/xi7yr/fXQcu5qB2hZTItCmR0h1L1V1XgsHMaDI+X6ksUEpR+NiF95TU+7HpR
	 3wbskHB2EfbTojMYVV56E9NWEmKpexTCQ6ww5y2Swj7X8GXYZZN9hyQhiIuXyTYptaQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794283268;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=PfP+/nE+Qy16Kl0QSbg1n1VB7S8Aht5hJLsAan2xsxQ=;
	b=bk9XLYP8+BPmbPz9EAwIQG2rrgWaaHlbGZDSlgai2NDrprpHBRyhaCBZqJOmagYZXtXS
	 dfd66j6/MvsW3HM1kGj/Imf1PbQ/5Y6gXFX99EDrIvu8Su6AE+mteWtucvfrTUFNBQooS
	 H8lyTP8Io/nKKfQy15Pq+S5ip1Oor4KMT2s9+bXqLyTwei2k479eoSEAhthJalhNTSRAj
	 ZisLDktZp9WE15rt6YNluEg4KR03YdacrPyUA0P2t9cyb+45Z6/Wtz7B6nByWr/l8iLKr
	 cbaUquVTFuVJbUjVMhfFDQa73BZuRPPYS5qZe1gDGK8SbDgvdLE1+7wngr77srlV1wQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ba0MQ5Zm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE4160A6F41;
	Tue, 10 Nov 2026 04:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ba0MQ5Zm
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794283267;
	b=IjwPAyoJL5p3UEwY8O7QARLQDk2QZqkZYrSk051eOotFC1/CvkIWhN7VS908swThoWcC
	 oe40kOcCk6E0OH4Rm94HnLlqtCynxgunRxgKcxN1F2wiPgq682ZlFIvn8woZZdZGE8eVm
	 6C3qNYSxgqQ+1mgN6qIuByaTKSPaZNREu7h9nGCCLTT5aKgugA0whohnBB4oV/xcKu7eq
	 Fgo+/BkbjN8l99i59O2Z6UrqGpGHSb9C701OfnXq4SHq907Anz0+LFfLJWuS7d+bQKlw6
	 uUAr51A85B6Avfn7FiCx7kZSQ/sOnWzYNe3ZQdZpRvJmvbtcrDQrpwtszIHbNv+7Z0A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794283267;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=PfP+/nE+Qy16Kl0QSbg1n1VB7S8Aht5hJLsAan2xsxQ=;
	b=UtnPddM/t4KXty+T0VlSwcrBV5qT3qsyqwEfwRQgQkOjnLRqH9GeqB/bSVU233nc4qmq
	 9MjSDm9NSJ1/O3xzRjt2EJRZtolhvncWrN+7dH90wJ2G2M3FGPAXMvg20pUCOWDz4la52
	 ygu716Rh2y2wELWgM0p+Q5x8BTfObReyqQjQjdk225M11V2TKUepbjS1Ppk+9suSJ8rP/
	 WiLEF7yEPZa5syHWTVTIP+LYhyO5UaLvA8+EalhVP7lMV6Jc/8myX3evSnq90VZ1UiYbf
	 sKniEI8XBlHU9dLXW9Ta1j6XAmzk+zygKlai5oK7WVx0TiZ002Rm3bSgUXEk1ZILbKQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E70371F008A6;
	Tue, 10 Nov 2026 04:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794283267;
	bh=PfP+/nE+Qy16Kl0QSbg1n1VB7S8Aht5hJLsAan2xsxQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ba0MQ5ZmUMWhGJGHBRm2v3N0/8MYKNE3XZm65CUaRkNbyJ8R2vpNOqOavB/Lo9BLv
	 fg/Tv1dYso7nSkbv3xPpeBftTtegxZD5sPNL4DLm8KTOUtn/Leqv6mButTFLlFwaZQ
	 28Y+mV6ywquguxXZu1Clysu1v5mDx3/XqcozcOBMssUmVZp58MU3o3mmBVwdIFx/iZ
	 Vc/ppa3H+/gru4ai491DBzu/7X+Rj3gy1MEI2WXMar2WRi52W+iWjO55V87XhtTBgl
	 DRcMbLbBTetKplvFG2KSYSD7RbpONLSgeo/IiZzAVSJAVpTkvo6JchyGGo0mkHVFcw
	 6kyqF0JvNzBlA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 22EAB48818;
	Tue, 10 Nov 2026 04:00:52 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Mon, 09 Nov 2026 20:00:41 -0800
Subject: [PATCH rdma-next v3 08/13] RDMA/uverbs: factor out the queue pair
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
Message-Id: <20261109-uet-ib-core-v3-8-3e7e7ffed2e9@broadcom.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
In-Reply-To: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794283250; l=9213;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=kB2CErzfDz0J4odnATPSdxed3K/PaBP4pfJlSmVKizc=;
 b=0Gu6aTQ0MWhCEDaYM/DkV1xOMR7jprQpeqQv8boM51EHPXZC8FpmC45SwystH+ZprvLoVw2kn
 So4MBhkRJ5FDDjiDxZLqEvZqBe5rQ09dnmdEItLQFKW4H05zvABoqk9
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
 drivers/infiniband/core/uverbs_cmd.c | 184 +++++++++++++++++++----------------
 2 files changed, 105 insertions(+), 85 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index e179cd924eba..65a217bf65b5 100644
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
index cca386b2c3f0..140f1cf91527 100644
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

-- 
2.56.0


