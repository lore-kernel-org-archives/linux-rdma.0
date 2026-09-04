Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2956481AA0
	for <linux-rdma@vger.kernel.org>; Fri,  4 Sep 2026 10:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788519182; cv=none; b=FZKmXYl+W9WtsXP/K7sxiNF7tPPyOsHXdAKYKhWma1luYLZUSxD6hqIfqtmZdb/k3bcfYE+nHdA2g1mB9iOgGkHGyoc4KFfNd4G+vAaVBL0wFGvJv3XVVx+JG5cwnsfiB29NyBdKygO1XTGq8qAn9Sdc1wolDv8MqBt688O//wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788519182; c=relaxed/simple;
	bh=MV9tIIWIT/YQfz9uuSgYIm1h9SOD79kb4VSkx0pmjPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMHBgZbvCJ6KEqfX9QFURJuCOZ+KrQm2xknEq0vaXPIFKHIHRa4Mry7wgM1HqPfH3HRs6bDmu2MEpWKtDXBxxGo0gKka7JPUnKCwJA+Ypdg0TwyiKNFaekgFP0u1AbzqLxadDfTLcPq1KwtcWRcTkBFJ1CGyWO2DUKJ0ptMb6kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Gfx+JZ8t; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Gfx+JZ8t"
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so996054a91.0
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 03:52:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788519172; x=1789123972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7yb3VFuLwxBId5gSlWRvWCWhTt6ZcrFM/a0JbdtByiQ=;
        b=aW+m+CyQwAByzl1YIqgr9EhABQH0QgNcLuBHyGW2eOjNVQizzhavf+Gp3tbBCmLOXM
         cqEzyooNEI1zYXWe6mcMffRIfV4RNJ0njCmcmgkiK2I53QwDdIoJ7oc0ziqbGrdAYIFk
         byn/i2pN4cL2/eN6p+VE5GzLVa1sDmKU8hozMePLGyNVfrWezqVI4V1LshXhbWQZXZ3/
         auHapIoSAdJvAhX2hD7lT9L9uGZhIHRd/04ZbEwukD7hV+iOLbm/9jK+v3Lx7eJf0IYH
         GpJlAJdioqzP7Va4eltwvCHWVxiwL+UdIGXLOZyoa9r5VUo6YTNaS5wrdXX6bVgnEeVr
         I9PQ==
X-Forwarded-Encrypted: i=1; AKwUvBw53/67qWAr55bXUe/L3/p8E3zeiLtNYjH5o7ouVDAdRvcn8loRGTAmFMpiYae+IweaeuaNTVv+2qHT@vger.kernel.org
X-Gm-Message-State: AFuF++lk0eXpH4oifedxY+THhedit5d5eXzczRWyNZ2JdQtDLWyevTZW
	FPvaYq6zKZRNLkbOhzWelTk0Wvb7Y24kcZ5h1wvZJGLIa6lRRa+0xE0Fz/4MO9S42vazVDxUIXI
	EPP37B44wm8I/VeAQCMXHjvK1tazm0BQ0KWKf3X//4cKLhuU0McxhnUO2TIpQGOm+RV+DAbxs/6
	myzDlC1TQEIq6P4jmtneJqE8HFnwpbQvk+RlvmsZwkwdg+HYiLYeWLNsDB+LdlVTe4DPmi2do9F
	8c5kVJRmK5SWLM=
X-Gm-Gg: AYBFou0amqJD/zAXlKAc5po48awg96whE7jX2RIkB6TbThqMAPiinElk2L/etxdpyQo
	xree3X8GC93q+1BRmF8Gea43tw7OA0cNrg54DHFwgU5K3FUJlqUIbWVKlpJIl1z3NfQMa9S5Aa8
	oQfY3PZPpkp5+fs0SUFUgvuACL4g6txKBKcyIdw67tIglNd/eCghZ8Qhdm6wxHcwk7+NJl1PptF
	kBDC2FWNwdNaSwqzYofnvYRJ5IzPLijxCYYWok4d/o0mMpjhkZRfQw+0GEKfecYZYUh/hF2233U
	28pb1hfGMhE3H45TxBgPNPw/5oe4+dYX1Dfi+2GQkIOBHgUa1LLKwbfYk+n0cFZqGPr4klBVE1n
	4c3RMMPov1UVpWnP9gyIRIwwuiLx//dYh0Cgfuy20wJk0Nw5IYuc4WMLsq2yySES0GG1m0kQrKW
	vai5vV0dLHJIEneQ7xrog4fXa8yqY6sAlQGQ==
X-Received: by 2002:a17:90b:3d89:b0:398:9be8:ea69 with SMTP id 98e67ed59e1d1-39b262167e7mr8414382a91.22.1788519172091;
        Fri, 04 Sep 2026 03:52:52 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39b260deb5esm1229512a91.3.2026.09.04.03.52.51
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Sep 2026 03:52:52 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-398d0010cfaso1764204a91.3
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 03:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788519170; x=1789123970; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7yb3VFuLwxBId5gSlWRvWCWhTt6ZcrFM/a0JbdtByiQ=;
        b=Gfx+JZ8tdNIjNOppswWSPzHU09KsgXEoDpFu6T0OVD2hYTKd30aIiaUvxG2R5iHEnl
         LpR2+vhb5af8XVl1fbJdfk5FUMinfk1Wv+SGHdOwMrjRhqKv5uQlibBPovuEpqu/oL/v
         LKmqsH1RoP2XLP78NWMxP6APqaotM6N37k40E=
X-Forwarded-Encrypted: i=1; AKwUvBwCUAEA5CoqN/V0jI18dJsLiDnyhhokKDoXFl14JT8MhwTqKuaQwmyFWplA38KWddGPblb4cXOG+kvi@vger.kernel.org
X-Received: by 2002:a17:90b:28ce:b0:38d:fda6:4873 with SMTP id 98e67ed59e1d1-39b26100cbfmr8695184a91.10.1788519169616;
        Fri, 04 Sep 2026 03:52:49 -0700 (PDT)
X-Received: by 2002:a17:90b:28ce:b0:38d:fda6:4873 with SMTP id 98e67ed59e1d1-39b26100cbfmr8695118a91.10.1788519169024;
        Fri, 04 Sep 2026 03:52:49 -0700 (PDT)
Received: from mgmt5.dhcp.broadcom.net ([192.19.222.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339a534d0asm6171170eec.8.2026.09.04.03.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 03:52:48 -0700 (PDT)
From: Siva Reddy Kallam <siva.kallam@broadcom.com>
To: leonro@nvidia.com,
	jgg@nvidia.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Mohammed Faraaz <mohammed.faraaz@broadcom.com>,
	Siva Reddy Kallam <siva.kallam@broadcom.com>
Subject: [PATCH 13/15] RDMA/bng_re: Add AH verbs
Date: Fri,  4 Sep 2026 03:43:21 -0700
Message-ID: <20260904104328.763768-14-siva.kallam@broadcom.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260904104328.763768-1-siva.kallam@broadcom.com>
References: <20260904104328.763768-1-siva.kallam@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Mohammed Faraaz <mohammed.faraaz@broadcom.com>

This patch adds below verbs.
- bng_re_create_ah
- bng_re_destroy_ah
- bng_re_query_ah

Signed-off-by: Mohammed Faraaz <mohammed.faraaz@broadcom.com>
Signed-off-by: Siva Reddy Kallam <siva.kallam@broadcom.com>
---
 drivers/infiniband/hw/bng_re/bng_dev.c      |  16 ++
 drivers/infiniband/hw/bng_re/bng_re.h       |   2 +
 drivers/infiniband/hw/bng_re/bng_roce_hsi.h |  65 ++++++
 drivers/infiniband/hw/bng_re/bng_sp.c       | 120 +++++++++++
 drivers/infiniband/hw/bng_re/bng_sp.h       |  19 ++
 drivers/infiniband/hw/bng_re/bng_verbs.c    | 215 ++++++++++++++++++++
 drivers/infiniband/hw/bng_re/bng_verbs.h    |  29 +++
 include/uapi/rdma/bng_re-abi.h              |   5 +
 8 files changed, 471 insertions(+)

diff --git a/drivers/infiniband/hw/bng_re/bng_dev.c b/drivers/infiniband/hw/bng_re/bng_dev.c
index 978b7efab03e..3ebdd777eca3 100644
--- a/drivers/infiniband/hw/bng_re/bng_dev.c
+++ b/drivers/infiniband/hw/bng_re/bng_dev.c
@@ -64,6 +64,11 @@ static const struct ib_device_ops bng_re_dev_ops = {
 	.destroy_srq		= bng_re_destroy_srq,
 	.alloc_hw_port_stats	= bng_re_alloc_hw_port_stats,
 	.get_hw_stats		= bng_re_ib_get_hw_stats,
+	.create_ah		= bng_re_create_ah,
+	.create_user_ah		= bng_re_create_ah,
+	.destroy_ah		= bng_re_destroy_ah,
+	.query_ah		= bng_re_query_ah,
+	INIT_RDMA_OBJ_SIZE(ib_ah, bng_re_ah, ib_ah),
 	INIT_RDMA_OBJ_SIZE(ib_srq, bng_re_srq, ib_srq),
 	INIT_RDMA_OBJ_SIZE(ib_cq, bng_re_cq, ib_cq),
 	INIT_RDMA_OBJ_SIZE(ib_pd, bng_re_pd, ib_pd),
@@ -333,6 +338,11 @@ static void bng_re_dev_uninit(struct bng_re_dev *rdev)
 {
 	int rc;
 
+	if (rdev->dest_ah_wq) {
+		destroy_workqueue(rdev->dest_ah_wq);
+		rdev->dest_ah_wq = NULL;
+	}
+
 	if (rdev->bng_res.dpi_tbl.max)
 		bng_re_dealloc_dpi(&rdev->bng_res,
 				   &rdev->dpi_privileged);
@@ -504,6 +514,12 @@ static int bng_re_dev_init(struct bng_re_dev *rdev)
 			      rdev, BNG_RE_DPI_TYPE_KERNEL);
 	if (rc)
 		goto deinit_mpc;
+	rdev->dest_ah_wq = alloc_ordered_workqueue("bng_re_dest_ah", 0);
+	if (!rdev->dest_ah_wq) {
+		rc = -ENOMEM;
+		goto deinit_mpc;
+	}
+	refcount_set(&rdev->pos_destah_cnt, 0);
 
 	return 0;
 deinit_mpc:
diff --git a/drivers/infiniband/hw/bng_re/bng_re.h b/drivers/infiniband/hw/bng_re/bng_re.h
index 414768585e67..217383a2b252 100644
--- a/drivers/infiniband/hw/bng_re/bng_re.h
+++ b/drivers/infiniband/hw/bng_re/bng_re.h
@@ -301,6 +301,8 @@ struct bng_re_dev {
 	DECLARE_HASHTABLE(srq_hash, 8);  /* SRQ hash table */
 	struct bng_re_hw_stats		stats;
 	struct bng_re_ctx		ctx;
+	struct workqueue_struct		*dest_ah_wq;
+	refcount_t			pos_destah_cnt;
 };
 
 #define to_bng_re_dev(ptr, member)	\
diff --git a/drivers/infiniband/hw/bng_re/bng_roce_hsi.h b/drivers/infiniband/hw/bng_re/bng_roce_hsi.h
index 6c9d45464ef6..3001b9d4d056 100644
--- a/drivers/infiniband/hw/bng_re/bng_roce_hsi.h
+++ b/drivers/infiniband/hw/bng_re/bng_roce_hsi.h
@@ -6541,4 +6541,69 @@ struct mpc_event_resp_cmpl {
 	__le32	resp_data;
 };
 
+#define AH_MODIFY_DATA_AH_MODIFY_FLAGS_AH_MODIFY_FLAGS_AH_CREATE      0x1UL
+#define AH_MODIFY_DATA_AH_MODIFY_FLAGS_AH_MODIFY_FLAGS_AH_DESTROY     0x2UL
+#define AH_MODIFY_DATA_AH_MODIFY_FLAGS_AH_MODIFY_FLAGS_XID_FIRST_USE  0x4UL
+
+struct ah_modify_data {
+	__le32	ah_modify_flags;
+	__le32	reserved_0;
+	u8	type;
+	u8	unused_1[3];
+	__le32	pd_id;
+	u8	hop_limit;
+	u8	traffic_class;
+	__le16	sgid_index;
+	__le32	dest_vlan_id_flow_label;
+	__le64	ah_handle;
+	__le32	dgid[4];
+	__le16	dest_mac[3];
+	u8	enable_cc;
+	u8	unused_2[1];
+	__le32	xid;
+	__le32	reserved_1;
+};
+
+struct mpc_ah_modify_cmd {
+	u8	req_type;
+	u8	req_subtype;
+	__le16	cookie;
+	__le16	target_id;
+	u8	resp_size;
+	u8	reserved;
+	__le64	resp_addr;
+	__le32	ah_modify_flags;
+	__le32	reserved_0;
+	u8	type;
+	u8	unused_1[3];
+	__le32	pd_id;
+	u8	hop_limit;
+	u8	traffic_class;
+	__le16	sgid_index;
+	__le32	dest_vlan_id_flow_label;
+	__le64	ah_handle;
+	__le32	dgid[4];
+	__le16	dest_mac[3];
+	u8	enable_cc;
+	u8	unused_2[1];
+	__le32	xid;
+	__le32	reserved_1;
+};
+
+struct mpc_ah_modify_cmpl {
+	u8	cmpl_type_reserved;
+	u8	error_code_mp_client;
+	u8	req_type;
+	u8	req_subtype;
+	__le32	opaque;
+	u8	v;
+	u8	reserved_0[7];
+	__le32	xid;
+	__le16	error_code;
+	u8	reserved_1[2];
+	u8	v2;
+	u8	reserved_2[3];
+	__le32	reserved_3;
+};
+
 #endif /* _BNG_RE_HSI_H_ */
diff --git a/drivers/infiniband/hw/bng_re/bng_sp.c b/drivers/infiniband/hw/bng_re/bng_sp.c
index 26435fe4e892..b44af599e675 100644
--- a/drivers/infiniband/hw/bng_re/bng_sp.c
+++ b/drivers/infiniband/hw/bng_re/bng_sp.c
@@ -8,6 +8,8 @@
 #include "bng_sp.h"
 #include "bng_tlv.h"
 #include "bng_re.h"
+#include "bng_re_mpc_roce.h"
+#include "bng_fp.h"
 
 const struct bng_re_gid bng_re_gid_zero = {{0,}};
 
@@ -1104,3 +1106,121 @@ int bng_re_qext_stat(struct bng_re_rcfw *rcfw, u32 fid,
 			  sbuf.sb, sbuf.dma_addr);
 	return rc;
 }
+
+static int bng_sp_fill_mpc_ah_modify_parms(struct bng_re_res *res,
+					   struct ah_modify_data *data,
+					   struct bng_sp_ah *ah,
+					   bool for_destroy)
+{
+	u32 flags = 0;
+
+	if (for_destroy) {
+		flags |= AH_MODIFY_DATA_AH_MODIFY_FLAGS_AH_MODIFY_FLAGS_AH_DESTROY;
+	} else {
+		flags |= AH_MODIFY_DATA_AH_MODIFY_FLAGS_AH_MODIFY_FLAGS_AH_CREATE;
+		flags |= AH_MODIFY_DATA_AH_MODIFY_FLAGS_AH_MODIFY_FLAGS_XID_FIRST_USE;
+	}
+	data->ah_modify_flags = cpu_to_le32(flags);
+	data->ah_handle = cpu_to_le64((u64)ah);
+	data->xid = cpu_to_le32(ah->id);
+
+	if (!for_destroy) {
+		if (ah->pd)
+			data->pd_id = cpu_to_le32(ah->pd->id);
+		data->hop_limit = ah->hop_limit;
+		data->traffic_class = ah->traffic_class;
+		data->sgid_index = cpu_to_le16(ah->sgid_index);
+		data->dest_vlan_id_flow_label = cpu_to_le32(ah->flow_label | (ah->vlan_id << 16));
+		memcpy(data->dgid, ah->dgid.data, sizeof(data->dgid));
+		memcpy(data->dest_mac, ah->dmac, sizeof(ah->dmac));
+	}
+
+	dev_dbg(&res->pdev->dev, "MPC: AH modify params - AH ID=%d, flags=0x%x, for_destroy=%s\n",
+		ah->id, flags, for_destroy ? "true" : "false");
+
+	return 0;
+}
+
+int bng_sp_fill_and_send_mpc_ah_modify(struct bng_re_res *res,
+				       struct bng_sp_ah **ahs,
+				       int num_ahs, bool for_destroy, bool block)
+{
+	struct bng_re_dev *rdev = to_bng_re_dev(res, bng_res);
+	struct mpc_ah_modify_cmpl resp;
+	struct mpc_ah_modify_cmd cmd;
+	struct ah_modify_data *data;
+	struct bng_sp_ah *ah;
+	int rc = 0;
+
+	/* for 1st iteration, don't allow batch */
+	if (num_ahs != 1)
+		return -EINVAL;
+
+	ah = *ahs;
+
+	if (!for_destroy) {
+		if (res->is_vf)
+			return -EOPNOTSUPP;
+
+		if (res->ah_xids) {
+			int xid;
+
+			xid = bng_re_xm_alloc_range(res->ah_xids, 1, 0);
+			if (xid < 0) {
+				dev_err(&res->pdev->dev,
+					"%s - error allocating ah xid\n", __func__);
+				return -ENOMEM;
+			}
+			ah->id = xid;
+		} else {
+			ah->id = 1;
+		}
+	}
+
+	memset(&cmd, 0, sizeof(cmd));
+	memset(&resp, 0, sizeof(resp));
+	data = (struct ah_modify_data *)&cmd.ah_modify_flags;
+
+	bng_sp_fill_mpc_ah_modify_parms(res, data, ah, for_destroy);
+
+	cmd.resp_size = sizeof(resp) / BNG_RE_MPC_CQ_STRIDE;
+
+	/* Set MPC command type based on VF vs PF context */
+	if (res->is_vf) {
+		cmd.req_type = MPC_CMD_HDR_REQ_TYPE_PFVF;
+		cmd.req_subtype = MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_MODIFY;
+		dev_dbg(&res->pdev->dev, "MPC: [%s] VF path\n", __func__);
+	} else {
+		cmd.req_type = MPC_CMD_HDR_REQ_TYPE_RCA;
+		cmd.req_subtype = MPC_CMD_HDR_REQ_SUB_TYPE_RCA_AH_MODIFY;
+		dev_dbg(&res->pdev->dev, "MPC: [%s] PF path\n", __func__);
+	}
+
+	dev_dbg(&res->pdev->dev, "MPC: %s - sending to mpc: AH ID=%d, block=%s\n",
+		__func__, ah->id, block ? "true" : "false");
+
+	if (!rdev) {
+		dev_err(&res->pdev->dev, "%s: no rdev for MPC xmit\n", __func__);
+		return -ENODEV;
+	}
+
+	rc = bng_re_roce_mpc_xmit(rdev, &cmd, sizeof(cmd), &resp, sizeof(resp), block);
+
+	if (rc < 0) {
+		dev_err(&res->pdev->dev, "%s - error sending mpc:%d,%d",
+			__func__, ah->id, rc);
+
+		/* Cleanup on error */
+		if (!res->is_vf && res->ah_xids)
+			bng_re_xm_free_range(res->ah_xids, ah->id, true);
+		return rc;
+	}
+
+	dev_info(&res->pdev->dev, "MPC: AH %s completed for AH ID=%d\n",
+		 for_destroy ? "destroy" : "create", ah->id);
+
+	if (for_destroy && !res->is_vf && res->ah_xids)
+		bng_re_xm_free_range(res->ah_xids, ah->id, true);
+
+	return rc;
+}
diff --git a/drivers/infiniband/hw/bng_re/bng_sp.h b/drivers/infiniband/hw/bng_re/bng_sp.h
index d69d97e1940b..a6f688c0af3d 100644
--- a/drivers/infiniband/hw/bng_re/bng_sp.h
+++ b/drivers/infiniband/hw/bng_re/bng_sp.h
@@ -271,6 +271,22 @@ struct bng_re_hw_stats {
 	struct bng_re_rstat            rstat;
 };
 
+struct bng_sp_ah {
+	struct bng_re_gid			dgid;
+	struct bng_sp_pd			*pd;
+	u32				id;
+	u8				sgid_index;
+	/* For Query AH if the hw table and SW table are different */
+	u8				host_sgid_index;
+	u8				traffic_class;
+	u32				flow_label;
+	u8				hop_limit;
+	u8				sl;
+	u8				dmac[6];
+	u16				vlan_id;
+	u8				nw_type;
+};
+
 int bng_re_get_dev_attr(struct bng_re_rcfw *rcfw);
 int bng_sp_alloc_sgid_tbl(struct bng_re_sgid_tbl *sgid_tbl, u16 size);
 
@@ -312,5 +328,8 @@ int bng_re_qext_stat(struct bng_re_rcfw *rcfw, u32 fid,
 		     struct bng_re_ext_stat *estat);
 int bng_re_get_roce_stats(struct bng_re_rcfw *rcfw,
 		     struct bng_roce_stats *stats);
+int bng_sp_fill_and_send_mpc_ah_modify(struct bng_re_res *res,
+				       struct bng_sp_ah **ahs,
+				       int num_ahs, bool for_destroy, bool block);
 
 #endif
diff --git a/drivers/infiniband/hw/bng_re/bng_verbs.c b/drivers/infiniband/hw/bng_re/bng_verbs.c
index e48caefa64ee..c40f8686b6f6 100644
--- a/drivers/infiniband/hw/bng_re/bng_verbs.c
+++ b/drivers/infiniband/hw/bng_re/bng_verbs.c
@@ -1412,3 +1412,218 @@ int bng_re_destroy_srq(struct ib_srq *ib_srq, struct ib_udata *udata)
 
 	return 0;
 }
+
+void bng_re_posted_destroy_ah(struct work_struct *work)
+{
+	struct bng_destroy_ah *ah = container_of(work, struct bng_destroy_ah, dwork.work);
+	struct bng_re_dev *rdev = ah->rdev;
+	struct bng_sp_ah *ahs[1];
+	u32 ah_ref_cnt = 0;
+	int rc = 0;
+
+	ahs[0] = &ah->sp_ah;
+
+	ah_ref_cnt = refcount_read(ah->ah_ref_cnt);
+	if (rdev->dest_ah_wq && ah_ref_cnt && ah->retry) {
+		ah->retry--;
+		queue_delayed_work(rdev->dest_ah_wq, &ah->dwork, BNG_RE_AH_DEST_DELAY);
+		return;
+	}
+
+	if (!ah->retry)
+		dev_dbg(rdev_to_dev(rdev), "Non-zero AH reference %d for AH id %d\n",
+			ah_ref_cnt, ah->sp_ah.id);
+
+	dev_dbg(&rdev->ibdev.dev,
+		"MPC: %s - sending AH modify(destroy) for: res:%p, ah:%p\n",
+		__func__, &rdev->bng_res, &ah->sp_ah);
+	rc = bng_sp_fill_and_send_mpc_ah_modify(&rdev->bng_res,
+						ahs, 1, true, false);
+	if (rc)
+		dev_err_ratelimited(&rdev->ibdev.dev,
+				    "%s failed to destroy AH id = %d rc = %d",
+				    __func__, ah->sp_ah.id, rc);
+	if (!ah_ref_cnt) {
+		kfree(ah->ah_ref_cnt);
+		ah->ah_ref_cnt = NULL;
+	}
+	kfree(ah);
+	refcount_dec(&rdev->pos_destah_cnt);
+}
+
+static u8 bng_re_stack_to_dev_nw_type(enum rdma_network_type ntype)
+{
+	u8 nw_type;
+
+	switch (ntype) {
+	case RDMA_NETWORK_IPV4:
+		nw_type = CMDQ_CREATE_AH_TYPE_V2IPV4;
+		break;
+	case RDMA_NETWORK_IPV6:
+		nw_type = CMDQ_CREATE_AH_TYPE_V2IPV6;
+		break;
+	default:
+		nw_type = CMDQ_CREATE_AH_TYPE_V1;
+		break;
+	}
+	return nw_type;
+}
+
+int bng_re_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
+		     struct ib_udata *udata)
+{
+	struct ib_pd *ibpd = ibah->pd;
+	struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
+	const struct ib_global_route *grh = rdma_ah_read_grh(ah_attr);
+	struct bng_re_dev *rdev = to_bng_re_dev(ibpd->device, ibdev);
+	struct bng_re_ah *ah = to_bng_re_ah(ibah);
+	const struct ib_gid_attr *sgid_attr;
+	struct bng_re_gid_ctx *ctx;
+	enum rdma_network_type nw_type;
+	int rc;
+
+	if (!(rdma_ah_get_ah_flags(ah_attr) & IB_AH_GRH)) {
+		ibdev_err(&rdev->ibdev, "Failed to create AH: GRH not set");
+		return -EINVAL;
+	}
+
+	ah->rdev = rdev;
+	if (ibpd) {
+		struct bng_re_pd *pd = container_of(ibpd, struct bng_re_pd, ib_pd);
+
+		ah->sp_ah.pd = &pd->sp_pd;
+	}
+
+	/* Supply the configuration for the HW */
+	memcpy(ah->sp_ah.dgid.data, grh->dgid.raw, sizeof(union ib_gid));
+	sgid_attr = grh->sgid_attr;
+	/* Get the HW context of the GID. The reference
+	 * of GID table entry is already taken by the caller.
+	 */
+	ctx = rdma_read_gid_hw_context(sgid_attr);
+	if (!ctx) {
+		ibdev_err(&rdev->ibdev, "Failed to read GID HW context");
+		return -EINVAL;
+	}
+	ah->sp_ah.sgid_index = ctx->idx;
+	ah->sp_ah.host_sgid_index = grh->sgid_index;
+	ah->sp_ah.flow_label = grh->flow_label;
+	ah->sp_ah.hop_limit = grh->hop_limit;
+	ah->sp_ah.traffic_class = grh->traffic_class;
+	ah->sp_ah.sl = rdma_ah_get_sl(ah_attr);
+
+	/* Get network type from GID attribute */
+	nw_type = rdma_gid_attr_network_type(sgid_attr);
+	ah->sp_ah.nw_type = bng_re_stack_to_dev_nw_type(nw_type);
+
+	memcpy(ah->sp_ah.dmac, ah_attr->roce.dmac, ETH_ALEN);
+
+	struct bng_sp_ah *ahp[1] = { &ah->sp_ah };
+
+	dev_dbg(&rdev->ibdev.dev, "MPC: %s - sending AH modify(create) for: res:%p, ah:%p\n",
+		__func__, &rdev->bng_res, &ah->sp_ah);
+	rc = bng_sp_fill_and_send_mpc_ah_modify(&rdev->bng_res,
+						ahp, 1, false, false);
+	if (rc) {
+		ibdev_err(&rdev->ibdev, "Failed to create HW AH");
+		return rc;
+	}
+
+	/* Allocate and initialize reference count for deferred destruction */
+	ah->ref_cnt = kzalloc_obj(*ah->ref_cnt, GFP_KERNEL);
+	if (!ah->ref_cnt) {
+		rc = -ENOMEM;
+		goto fail_destroy;
+	}
+	refcount_set(ah->ref_cnt, 1);
+
+	if (udata) {
+		struct bng_re_ah_resp resp = {};
+
+		resp.ah_id = ah->sp_ah.id;
+		rc = ib_copy_to_udata(udata, &resp,
+				      min(udata->outlen, sizeof(resp)));
+		if (rc) {
+			ibdev_err(&rdev->ibdev, "Failed to copy AH response");
+			goto fail_ref;
+		}
+	}
+
+	ibdev_dbg(&rdev->ibdev, "AH created with ID: %d", ah->sp_ah.id);
+	return 0;
+
+fail_ref:
+	kfree(ah->ref_cnt);
+	ah->ref_cnt = NULL;
+fail_destroy:
+	struct bng_sp_ah *ahs[1] = { &ah->sp_ah };
+
+	bng_sp_fill_and_send_mpc_ah_modify(&rdev->bng_res,
+					   ahs, 1, true, true);
+	return rc;
+}
+
+int bng_re_destroy_ah(struct ib_ah *ib_ah, u32 flags)
+{
+	struct bng_re_ah *ah = to_bng_re_ah(ib_ah);
+	struct bng_re_dev *rdev = ah->rdev;
+	struct bng_destroy_ah *pos_ah;
+	struct bng_sp_ah *ahs[1];
+	bool zero_ref = false;
+	bool block = true;
+	int rc = 0;
+
+	block = !!(flags & RDMA_DESTROY_AH_SLEEPABLE);
+	ahs[0] = &ah->sp_ah;
+
+	zero_ref = refcount_dec_and_test(ah->ref_cnt);
+	if (rdev->dest_ah_wq && (block || !zero_ref)) {
+		pos_ah = kzalloc_obj(*pos_ah, GFP_ATOMIC);
+		if (!pos_ah) {
+			rc = bng_sp_fill_and_send_mpc_ah_modify(&rdev->bng_res,
+								ahs, 1, true, block);
+			if (rc)
+				dev_err_ratelimited(&rdev->ibdev.dev,
+						    "%s id = %d dest_ah failed rc = %d",
+						    __func__, ah->sp_ah.id, rc);
+			if (zero_ref)
+				kfree(ah->ref_cnt);
+		} else {
+			INIT_DELAYED_WORK(&pos_ah->dwork, bng_re_posted_destroy_ah);
+			pos_ah->rdev = rdev;
+			pos_ah->ah_ref_cnt = ah->ref_cnt;
+			pos_ah->retry = BNG_RE_AH_DEST_RETRY;
+			memcpy(&pos_ah->sp_ah, &ah->sp_ah, sizeof(pos_ah->sp_ah));
+			refcount_inc(&rdev->pos_destah_cnt);
+			queue_delayed_work(rdev->dest_ah_wq, &pos_ah->dwork, 0);
+			/* We queued it, do not free ah->ref_cnt yet! */
+		}
+	} else {
+		rc = bng_sp_fill_and_send_mpc_ah_modify(&rdev->bng_res,
+							ahs, 1, true, block);
+		if (rc)
+			dev_err_ratelimited(&rdev->ibdev.dev,
+					    "%s id = %d dest_ah failed rc = %d",
+					    __func__, ah->sp_ah.id, rc);
+		if (zero_ref)
+			kfree(ah->ref_cnt);
+	}
+	return 0;
+}
+
+int bng_re_query_ah(struct ib_ah *ib_ah, struct rdma_ah_attr *ah_attr)
+{
+	struct bng_re_ah *ah = to_bng_re_ah(ib_ah);
+
+	ah_attr->type = ib_ah->type;
+	ah_attr->ah_flags = IB_AH_GRH;
+	rdma_ah_set_sl(ah_attr, ah->sp_ah.sl);
+	memcpy(ah_attr->roce.dmac, ah->sp_ah.dmac, ETH_ALEN);
+	rdma_ah_set_grh(ah_attr, NULL, 0,
+			ah->sp_ah.host_sgid_index,
+			0, ah->sp_ah.traffic_class);
+	rdma_ah_set_dgid_raw(ah_attr, ah->sp_ah.dgid.data);
+	rdma_ah_set_port_num(ah_attr, 1);
+	rdma_ah_set_static_rate(ah_attr, 0);
+	return 0;
+}
diff --git a/drivers/infiniband/hw/bng_re/bng_verbs.h b/drivers/infiniband/hw/bng_re/bng_verbs.h
index dd9fac0f33c0..c5643ee70885 100644
--- a/drivers/infiniband/hw/bng_re/bng_verbs.h
+++ b/drivers/infiniband/hw/bng_re/bng_verbs.h
@@ -75,6 +75,30 @@ struct bng_re_srq {
 	struct hlist_node	hash_entry;
 };
 
+/* Deferred AH destruction constants */
+#define BNG_RE_AH_DEST_DELAY	msecs_to_jiffies(5000)
+#define BNG_RE_AH_DEST_RETRY	10
+
+struct bng_destroy_ah {
+	struct delayed_work	dwork;
+	struct bng_re_dev	*rdev;
+	struct bng_sp_ah	sp_ah;
+	refcount_t		*ah_ref_cnt;
+	u8			retry;
+};
+
+struct bng_re_ah {
+	struct ib_ah		ib_ah;
+	struct bng_re_dev	*rdev;
+	struct bng_sp_ah	sp_ah;
+	refcount_t		*ref_cnt;
+};
+
+static inline struct bng_re_ah *to_bng_re_ah(struct ib_ah *ibah)
+{
+	return container_of(ibah, struct bng_re_ah, ib_ah);
+}
+
 static inline u32 bng_re_init_depth(u32 ent, struct bng_re_ucontext *uctx)
 {
 	/* roundup_pow_of_two(0) is undefined (UBSAN: shift by 64 on 64-bit). */
@@ -147,6 +171,11 @@ int bng_re_modify_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr,
 		      struct ib_udata *udata);
 int bng_re_query_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr);
 int bng_re_destroy_srq(struct ib_srq *ib_srq, struct ib_udata *udata);
+int bng_re_create_ah(struct ib_ah *ib_ah, struct rdma_ah_init_attr *init_attr,
+		     struct ib_udata *udata);
+int bng_re_destroy_ah(struct ib_ah *ib_ah, u32 flags);
+int bng_re_query_ah(struct ib_ah *ib_ah, struct rdma_ah_attr *ah_attr);
+void bng_re_posted_destroy_ah(struct work_struct *work);
 
 #endif /* __BNG_RE_VERBS_H__ */
 
diff --git a/include/uapi/rdma/bng_re-abi.h b/include/uapi/rdma/bng_re-abi.h
index 49931b7c1344..36bc902600be 100644
--- a/include/uapi/rdma/bng_re-abi.h
+++ b/include/uapi/rdma/bng_re-abi.h
@@ -75,4 +75,9 @@ struct bng_re_srq_resp {
 	__aligned_u64 comp_mask;
 };
 
+struct bng_re_ah_resp {
+	__u32 ah_id;
+	__u64 comp_mask;
+} __attribute__((packed));
+
 #endif /* __BNG_RE_UVERBS_ABI_H__*/
-- 
2.43.5

