Received: from mail-yx1-f98.google.com (mail-yx1-f98.google.com [74.125.224.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDC73A0B3F
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 06:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784615876; cv=none; b=PXuoAVIZnUSFiq1YOoX8cCmo3ZXJA1mCJ0N/wNCW8UWOwgj2OdL9as0xM3u8pMaQtzNiYVX+D3uT/soIx5IjriRqHQkPZ6mOKjU+aDey66SOuXHn/wnXqKItmzK2HVqbd/LQ3uDzF+7RFgy+/RyUPji8p3OyLhgchwHlXIu6VJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784615876; c=relaxed/simple;
	bh=MF356FYmqAPqsnv3R5+XhDjSKOa2Stcr8LVknqps+ps=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kXc6+Trba9v0SD4/RC+bW2DZWudMgL2ZPMTh/LTCAaGAcjO2GNOlTJlDyIaZMqBM+yz5OPXCVtDIfr74ACCl7LpY9V4++8gC1QC6CmBVVd6xmc5pMUOF54H6ae5EagI1Gmn8dqSj32gr8uKHLI8eFHyqSUShO1x1otxPHr5ho0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=VXXrpQ0Q; arc=none smtp.client-ip=74.125.224.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="VXXrpQ0Q"
Received: by mail-yx1-f98.google.com with SMTP id 956f58d0204a3-667b0ced2d3so12218632d50.2
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 23:37:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784615873; x=1785220673;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=k73RfEOQfo4ax6BXcZ6U5eH0rL6RCpzM0IhZ+Cv0T20=;
        b=jEOrPQ/c52mxuchoG6Y16hGXhxcBRtjHZNkA5ywbto38+gnNV+TAhhRpoBc2LUo6sG
         +t/MEOKWnxyrcm7/P1ZLQhb8g5ethDNvvVk6fdHuZqdQVm62dAJDcPq68JzVFl0FN4Hy
         0ugaY5Zkfcm5ZnfN9OKNb8qdXP0tKWhlYwS5+u80/2WW3sC8k8K69s1nrqCC1q9Rnxi2
         ih5Sc3Po5HvRnTcDOXNHSYO62LBCI+3OB4x6to3ooEjXA+UGmnVeggqiGQJltq64iNmA
         hNpOwdRELxwL5F/cp++mnflwyRvUGtJbBde/WzC3pu5PiYgKQ8h12vzJ18d+OCBvSaKa
         nVWg==
X-Forwarded-Encrypted: i=1; AHgh+Rr4y8WR45EndwOSSsH3xRwJT0AHWhHKc4Yzx1hIGwDLo+IjrUeaAJ1cgLHpM/vxTomMJ0LkMGDMq+th@vger.kernel.org
X-Gm-Message-State: AOJu0Yzjz44SU+NmWas2RsotxrqHClo7/F+GqpGSy9IQrkMZvOzaH29L
	12+J8vUdCxUW/W2xDL6ClADHg83AJCZKSlULeKBiGrQbZWxBffVt3eksmLEJd8iFumjCDO+3p6Q
	noc/oiCH1i8GWKRJxpV0utxBMdbQe85bmytApWgl7E8YdiDohCQyeul0OY62KE7uOxjOBUel6zh
	73NbQuqqw27DzYwiCIoqblCEpgAQUksPKICiW0dFfjd7squpvuceuULqrKzISil7m2VJraxUwOy
	Xm16On8oqfLRGg=
X-Gm-Gg: AR+sD104fhJ2nXavRq8AFwIWqINOPHekXyOiJO01RBn3TCZ+A/cDAsjWJjGo5Y2Ndee
	BCQsdcUcoeMkFVXtWbvq+p2RV7ZsycjNVGpPGw+EZtbD8viZsVx0RCMEQBtBXKvnJjYpvFppvjD
	/7e4VkXNdkzqULYfg1lwzuNcVbxSEa7db0epkB3t2LSXlQ3BUl3TkgxanZH29zTj0Ekq/b4TWkl
	xkCSUXgrI/UOlNP+1dJq5cCkQud5Jh+tVuQuuT9OLBUrJpW9OJ/QoKqfIyjQcHxvpKVN+WAmcOF
	lefn1Uo4MUfE86jDMQwCNaq1j5IhSOobflTjF3eEAQ++zxICScPO69xQWD1RQjXA2zZanORonWc
	QYGkRhmRHPjoi2qSiE7cuxMi/DP4C9Te0CYE7iue3r9KOr792b8KHOsPicCUUFlx2xhoMINNQ9g
	ua0vRLseHRdUqCQo39OM80OosPJw+aM8wGhw==
X-Received: by 2002:a05:690c:968b:b0:81e:45a6:bd52 with SMTP id 00721157ae682-81ef2611184mr54742367b3.34.1784615872778;
        Mon, 20 Jul 2026 23:37:52 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-12.dlp.protect.broadcom.com. [144.49.247.12])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-81ef3fcba33sm7086187b3.4.2026.07.20.23.37.52
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2026 23:37:52 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ccb687f82eso156346435ad.3
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 23:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784615871; x=1785220671; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=k73RfEOQfo4ax6BXcZ6U5eH0rL6RCpzM0IhZ+Cv0T20=;
        b=VXXrpQ0QUfjcSixdO9Qia7Su0VGFFBREg8b4agvgcpQFWS+8xbn4CfSaotnh0fQYYd
         0+KncHoJ3aQmpAedmkBColsrH+D4xXp2a9g1KpVGZE8cPnw64oAu8OAiFFJONXtYzTD3
         P2KDJhJDpGJSQGGvliR7nwvHZrdqezSm5HE0s=
X-Forwarded-Encrypted: i=1; AHgh+Rq4RR3kP/Ndo5mAqm/3U9zBlbKzzDZ67J8eZfpQPlPHH/EqsCae73fqqOmaB+VMeSztNnGaR9cnLL8Q@vger.kernel.org
X-Received: by 2002:a17:902:fdae:b0:2ca:ecf6:910e with SMTP id d9443c01a7336-2cf3466a93fmr191626845ad.0.1784615871349;
        Mon, 20 Jul 2026 23:37:51 -0700 (PDT)
X-Received: by 2002:a17:902:fdae:b0:2ca:ecf6:910e with SMTP id d9443c01a7336-2cf3466a93fmr191626545ad.0.1784615870859;
        Mon, 20 Jul 2026 23:37:50 -0700 (PDT)
Received: from localhost.localdomain ([192.19.203.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf346db04csm70094965ad.42.2026.07.20.23.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 23:37:50 -0700 (PDT)
From: Vikas Gupta <vikas.gupta@broadcom.com>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	leonro@nvidia.com,
	jgg@nvidia.com,
	bhargava.marreddy@broadcom.com,
	rahul-rg.gupta@broadcom.com,
	vsrama-krishna.nemani@broadcom.com,
	rajashekar.hudumula@broadcom.com,
	ajit.khaparde@broadcom.com,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Siva Reddy Kallam <siva.kallam@broadcom.com>,
	Dharmender Garg <dharmender.garg@broadcom.com>,
	Yendapally Reddy Dhananjaya Reddy <yendapally.reddy@broadcom.com>
Subject: [PATCH net v3] bnge/bng_re: fix ring ID widths
Date: Tue, 21 Jul 2026 12:07:31 +0530
Message-ID: <20260721063731.2622500-1-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Firmware requires more than 16 bits to address TX ring IDs for its
internal QP management. Widen the associated HSI ring ID fields to
32 bits. The values firmware assigns remain within 24 bits, bounded
by the hardware doorbell XID field.

The fw_ring_id field belongs to bnge_ring_struct, a common struct
shared by all ring types, so widening it to u32 applies uniformly
across TX, RX, CP, and NQ rings but firmware assigns values within
16-bit range for all ring types except TX, which requires the wider
field.

Note that, Thor Ultra hardware has not yet been deployed and no
firmware has been released to field, so backward compatibility
is not a concern.

Fixes: 42d1c54d6248 ("bnge/bng_re: Add a new HSI")
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Siva Reddy Kallam <siva.kallam@broadcom.com>
Reviewed-by: Dharmender Garg <dharmender.garg@broadcom.com>
Reviewed-by: Yendapally Reddy Dhananjaya Reddy <yendapally.reddy@broadcom.com>
---
v3:
- Updated commit message as suggested by Przemek Kitszel.
 https://lore.kernel.org/netdev/73e4895c-4d07-4841-92eb-2bcb61ca4d38@intel.com/
  No code change in this version.

v2:
Sashiko review: 
- Updated commit message only, no code change.
- Sashiko's concern about XID overflow is valid in theory but is
  handled by firmware, which guarantees TX ring IDs stay within the
  24-bit hardware doorbell XID field.
- Backward compatibility with older firmware is not a concern.

 drivers/infiniband/hw/bng_re/bng_dev.c        |  6 +--
 drivers/net/ethernet/broadcom/bnge/bnge.h     |  1 +
 .../ethernet/broadcom/bnge/bnge_hwrm_lib.c    |  8 +--
 .../ethernet/broadcom/bnge/bnge_hwrm_lib.h    |  2 +-
 .../net/ethernet/broadcom/bnge/bnge_netdev.c  | 50 +++++++++----------
 .../net/ethernet/broadcom/bnge/bnge_netdev.h  |  4 +-
 .../net/ethernet/broadcom/bnge/bnge_rmem.h    |  2 +-
 include/linux/bnge/hsi.h                      |  7 ++-
 8 files changed, 39 insertions(+), 41 deletions(-)

diff --git a/drivers/infiniband/hw/bng_re/bng_dev.c b/drivers/infiniband/hw/bng_re/bng_dev.c
index 71a7ca2196ad..311c8bc93160 100644
--- a/drivers/infiniband/hw/bng_re/bng_dev.c
+++ b/drivers/infiniband/hw/bng_re/bng_dev.c
@@ -113,7 +113,7 @@ static void bng_re_fill_fw_msg(struct bnge_fw_msg *fw_msg, void *msg,
 }
 
 static int bng_re_net_ring_free(struct bng_re_dev *rdev,
-				u16 fw_ring_id, int type)
+				u32 fw_ring_id, int type)
 {
 	struct bnge_auxr_dev *aux_dev = rdev->aux_dev;
 	struct hwrm_ring_free_input req = {};
@@ -123,7 +123,7 @@ static int bng_re_net_ring_free(struct bng_re_dev *rdev,
 
 	bng_re_init_hwrm_hdr((void *)&req, HWRM_RING_FREE);
 	req.ring_type = type;
-	req.ring_id = cpu_to_le16(fw_ring_id);
+	req.ring_id = cpu_to_le32(fw_ring_id);
 	bng_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
 			    sizeof(resp), BNGE_DFLT_HWRM_CMD_TIMEOUT);
 	rc = bnge_send_msg(aux_dev, &fw_msg);
@@ -161,7 +161,7 @@ static int bng_re_net_ring_alloc(struct bng_re_dev *rdev,
 			   sizeof(resp), BNGE_DFLT_HWRM_CMD_TIMEOUT);
 	rc = bnge_send_msg(aux_dev, &fw_msg);
 	if (!rc)
-		*fw_ring_id = le16_to_cpu(resp.ring_id);
+		*fw_ring_id = (u16)le32_to_cpu(resp.ring_id);
 
 	return rc;
 }
diff --git a/drivers/net/ethernet/broadcom/bnge/bnge.h b/drivers/net/ethernet/broadcom/bnge/bnge.h
index f21cff651fd4..4479ccd071f5 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge.h
+++ b/drivers/net/ethernet/broadcom/bnge/bnge.h
@@ -36,6 +36,7 @@ struct bnge_pf_info {
 };
 
 #define INVALID_HW_RING_ID      ((u16)-1)
+#define INVALID_HW_RING_ID_32BIT	(U32_MAX)
 
 enum {
 	BNGE_FW_CAP_SHORT_CMD				= BIT_ULL(0),
diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_hwrm_lib.c b/drivers/net/ethernet/broadcom/bnge/bnge_hwrm_lib.c
index 1c9cfec1b633..651c5e783516 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_hwrm_lib.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_hwrm_lib.c
@@ -1283,7 +1283,7 @@ int bnge_hwrm_stat_ctx_alloc(struct bnge_net *bn)
 
 int hwrm_ring_free_send_msg(struct bnge_net *bn,
 			    struct bnge_ring_struct *ring,
-			    u32 ring_type, int cmpl_ring_id)
+			    u32 ring_type, u32 cmpl_ring_id)
 {
 	struct hwrm_ring_free_input *req;
 	struct bnge_dev *bd = bn->bd;
@@ -1295,7 +1295,7 @@ int hwrm_ring_free_send_msg(struct bnge_net *bn,
 
 	req->cmpl_ring = cpu_to_le16(cmpl_ring_id);
 	req->ring_type = ring_type;
-	req->ring_id = cpu_to_le16(ring->fw_ring_id);
+	req->ring_id = cpu_to_le32(ring->fw_ring_id);
 
 	bnge_hwrm_req_hold(bd, req);
 	rc = bnge_hwrm_req_send(bd, req);
@@ -1317,7 +1317,7 @@ int hwrm_ring_alloc_send_msg(struct bnge_net *bn,
 	struct hwrm_ring_alloc_output *resp;
 	struct hwrm_ring_alloc_input *req;
 	struct bnge_dev *bd = bn->bd;
-	u16 ring_id, flags = 0;
+	u32 ring_id, flags = 0;
 	int rc;
 
 	rc = bnge_hwrm_req_init(bd, req, HWRM_RING_ALLOC);
@@ -1401,7 +1401,7 @@ int hwrm_ring_alloc_send_msg(struct bnge_net *bn,
 
 	resp = bnge_hwrm_req_hold(bd, req);
 	rc = bnge_hwrm_req_send(bd, req);
-	ring_id = le16_to_cpu(resp->ring_id);
+	ring_id = le32_to_cpu(resp->ring_id);
 	bnge_hwrm_req_drop(bd, req);
 
 exit:
diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_hwrm_lib.h b/drivers/net/ethernet/broadcom/bnge/bnge_hwrm_lib.h
index 3501de7a89b9..bf452e390d5b 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_hwrm_lib.h
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_hwrm_lib.h
@@ -50,7 +50,7 @@ int bnge_hwrm_cfa_l2_set_rx_mask(struct bnge_dev *bd,
 void bnge_hwrm_stat_ctx_free(struct bnge_net *bn);
 int bnge_hwrm_stat_ctx_alloc(struct bnge_net *bn);
 int hwrm_ring_free_send_msg(struct bnge_net *bn, struct bnge_ring_struct *ring,
-			    u32 ring_type, int cmpl_ring_id);
+			    u32 ring_type, u32 cmpl_ring_id);
 int hwrm_ring_alloc_send_msg(struct bnge_net *bn,
 			     struct bnge_ring_struct *ring,
 			     u32 ring_type, u32 map_index);
diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_netdev.c b/drivers/net/ethernet/broadcom/bnge/bnge_netdev.c
index 70768193004c..6f7ef506d4e1 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_netdev.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_netdev.c
@@ -1327,12 +1327,12 @@ static int bnge_alloc_core(struct bnge_net *bn)
 	return rc;
 }
 
-u16 bnge_cp_ring_for_rx(struct bnge_rx_ring_info *rxr)
+u32 bnge_cp_ring_for_rx(struct bnge_rx_ring_info *rxr)
 {
 	return rxr->rx_cpr->ring_struct.fw_ring_id;
 }
 
-u16 bnge_cp_ring_for_tx(struct bnge_tx_ring_info *txr)
+u32 bnge_cp_ring_for_tx(struct bnge_tx_ring_info *txr)
 {
 	return txr->tx_cpr->ring_struct.fw_ring_id;
 }
@@ -1375,12 +1375,12 @@ static void bnge_init_nq_tree(struct bnge_net *bn)
 		struct bnge_nq_ring_info *nqr = &bn->bnapi[i]->nq_ring;
 		struct bnge_ring_struct *ring = &nqr->ring_struct;
 
-		ring->fw_ring_id = INVALID_HW_RING_ID;
+		ring->fw_ring_id = INVALID_HW_RING_ID_32BIT;
 		for (j = 0; j < nqr->cp_ring_count; j++) {
 			struct bnge_cp_ring_info *cpr = &nqr->cp_ring_arr[j];
 
 			ring = &cpr->ring_struct;
-			ring->fw_ring_id = INVALID_HW_RING_ID;
+			ring->fw_ring_id = INVALID_HW_RING_ID_32BIT;
 		}
 	}
 }
@@ -1637,7 +1637,7 @@ static void bnge_init_one_rx_ring_rxbd(struct bnge_net *bn,
 
 	ring = &rxr->rx_ring_struct;
 	bnge_init_rxbd_pages(ring, type);
-	ring->fw_ring_id = INVALID_HW_RING_ID;
+	ring->fw_ring_id = INVALID_HW_RING_ID_32BIT;
 }
 
 static void bnge_init_one_agg_ring_rxbd(struct bnge_net *bn,
@@ -1647,7 +1647,7 @@ static void bnge_init_one_agg_ring_rxbd(struct bnge_net *bn,
 	u32 type;
 
 	ring = &rxr->rx_agg_ring_struct;
-	ring->fw_ring_id = INVALID_HW_RING_ID;
+	ring->fw_ring_id = INVALID_HW_RING_ID_32BIT;
 	if (bnge_is_agg_reqd(bn->bd)) {
 		type = ((u32)BNGE_RX_PAGE_SIZE << RX_BD_LEN_SHIFT) |
 			RX_BD_TYPE_RX_AGG_BD | RX_BD_FLAGS_SOP;
@@ -1708,7 +1708,7 @@ static void bnge_init_tx_rings(struct bnge_net *bn)
 		struct bnge_tx_ring_info *txr = &bn->tx_ring[i];
 		struct bnge_ring_struct *ring = &txr->tx_ring_struct;
 
-		ring->fw_ring_id = INVALID_HW_RING_ID;
+		ring->fw_ring_id = INVALID_HW_RING_ID_32BIT;
 
 		netif_queue_set_napi(bn->netdev, i, NETDEV_QUEUE_TYPE_TX,
 				     &txr->bnapi->napi);
@@ -1867,7 +1867,7 @@ static int bnge_hwrm_rx_agg_ring_alloc(struct bnge_net *bn,
 		    ring->fw_ring_id);
 	bnge_db_write(bn->bd, &rxr->rx_agg_db, rxr->rx_agg_prod);
 	bnge_db_write(bn->bd, &rxr->rx_db, rxr->rx_prod);
-	bn->grp_info[grp_idx].agg_fw_ring_id = ring->fw_ring_id;
+	bn->grp_info[grp_idx].agg_fw_ring_id = (u16)ring->fw_ring_id;
 
 	return 0;
 }
@@ -1886,7 +1886,7 @@ static int bnge_hwrm_rx_ring_alloc(struct bnge_net *bn,
 		return rc;
 
 	bnge_set_db(bn, &rxr->rx_db, type, map_idx, ring->fw_ring_id);
-	bn->grp_info[map_idx].rx_fw_ring_id = ring->fw_ring_id;
+	bn->grp_info[map_idx].rx_fw_ring_id = (u16)ring->fw_ring_id;
 
 	return 0;
 }
@@ -1916,7 +1916,7 @@ static int bnge_hwrm_ring_alloc(struct bnge_net *bn)
 		bnge_set_db(bn, &nqr->nq_db, type, map_idx, ring->fw_ring_id);
 		bnge_db_nq(bn, &nqr->nq_db, nqr->nq_raw_cons);
 		enable_irq(vector);
-		bn->grp_info[i].nq_fw_ring_id = ring->fw_ring_id;
+		bn->grp_info[i].nq_fw_ring_id = (u16)ring->fw_ring_id;
 
 		if (!i) {
 			rc = bnge_hwrm_set_async_event_cr(bd, ring->fw_ring_id);
@@ -1986,15 +1986,13 @@ void bnge_fill_hw_rss_tbl(struct bnge_net *bn, struct bnge_vnic_info *vnic)
 	tbl_size = bnge_get_rxfh_indir_size(bd);
 
 	for (i = 0; i < tbl_size; i++) {
-		u16 ring_id, j;
+		u32 j;
 
 		j = bd->rss_indir_tbl[i];
 		rxr = &bn->rx_ring[j];
 
-		ring_id = rxr->rx_ring_struct.fw_ring_id;
-		*ring_tbl++ = cpu_to_le16(ring_id);
-		ring_id = bnge_cp_ring_for_rx(rxr);
-		*ring_tbl++ = cpu_to_le16(ring_id);
+		*ring_tbl++ = cpu_to_le16(rxr->rx_ring_struct.fw_ring_id);
+		*ring_tbl++ = cpu_to_le16(bnge_cp_ring_for_rx(rxr));
 	}
 }
 
@@ -2285,7 +2283,7 @@ static void bnge_disable_int(struct bnge_net *bn)
 		nqr = &bnapi->nq_ring;
 		ring = &nqr->ring_struct;
 
-		if (ring->fw_ring_id != INVALID_HW_RING_ID)
+		if (ring->fw_ring_id != INVALID_HW_RING_ID_32BIT)
 			bnge_db_nq(bn, &nqr->nq_db, nqr->nq_raw_cons);
 	}
 }
@@ -2401,7 +2399,7 @@ static void bnge_hwrm_rx_ring_free(struct bnge_net *bn,
 	u32 grp_idx = rxr->bnapi->index;
 	u32 cmpl_ring_id;
 
-	if (ring->fw_ring_id == INVALID_HW_RING_ID)
+	if (ring->fw_ring_id == INVALID_HW_RING_ID_32BIT)
 		return;
 
 	cmpl_ring_id = bnge_cp_ring_for_rx(rxr);
@@ -2409,7 +2407,7 @@ static void bnge_hwrm_rx_ring_free(struct bnge_net *bn,
 				RING_FREE_REQ_RING_TYPE_RX,
 				close_path ? cmpl_ring_id :
 				INVALID_HW_RING_ID);
-	ring->fw_ring_id = INVALID_HW_RING_ID;
+	ring->fw_ring_id = INVALID_HW_RING_ID_32BIT;
 	bn->grp_info[grp_idx].rx_fw_ring_id = INVALID_HW_RING_ID;
 }
 
@@ -2421,14 +2419,14 @@ static void bnge_hwrm_rx_agg_ring_free(struct bnge_net *bn,
 	u32 grp_idx = rxr->bnapi->index;
 	u32 cmpl_ring_id;
 
-	if (ring->fw_ring_id == INVALID_HW_RING_ID)
+	if (ring->fw_ring_id == INVALID_HW_RING_ID_32BIT)
 		return;
 
 	cmpl_ring_id = bnge_cp_ring_for_rx(rxr);
 	hwrm_ring_free_send_msg(bn, ring, RING_FREE_REQ_RING_TYPE_RX_AGG,
 				close_path ? cmpl_ring_id :
 				INVALID_HW_RING_ID);
-	ring->fw_ring_id = INVALID_HW_RING_ID;
+	ring->fw_ring_id = INVALID_HW_RING_ID_32BIT;
 	bn->grp_info[grp_idx].agg_fw_ring_id = INVALID_HW_RING_ID;
 }
 
@@ -2439,14 +2437,14 @@ static void bnge_hwrm_tx_ring_free(struct bnge_net *bn,
 	struct bnge_ring_struct *ring = &txr->tx_ring_struct;
 	u32 cmpl_ring_id;
 
-	if (ring->fw_ring_id == INVALID_HW_RING_ID)
+	if (ring->fw_ring_id == INVALID_HW_RING_ID_32BIT)
 		return;
 
 	cmpl_ring_id = close_path ? bnge_cp_ring_for_tx(txr) :
 		       INVALID_HW_RING_ID;
 	hwrm_ring_free_send_msg(bn, ring, RING_FREE_REQ_RING_TYPE_TX,
 				cmpl_ring_id);
-	ring->fw_ring_id = INVALID_HW_RING_ID;
+	ring->fw_ring_id = INVALID_HW_RING_ID_32BIT;
 }
 
 static void bnge_hwrm_cp_ring_free(struct bnge_net *bn,
@@ -2455,12 +2453,12 @@ static void bnge_hwrm_cp_ring_free(struct bnge_net *bn,
 	struct bnge_ring_struct *ring;
 
 	ring = &cpr->ring_struct;
-	if (ring->fw_ring_id == INVALID_HW_RING_ID)
+	if (ring->fw_ring_id == INVALID_HW_RING_ID_32BIT)
 		return;
 
 	hwrm_ring_free_send_msg(bn, ring, RING_FREE_REQ_RING_TYPE_L2_CMPL,
 				INVALID_HW_RING_ID);
-	ring->fw_ring_id = INVALID_HW_RING_ID;
+	ring->fw_ring_id = INVALID_HW_RING_ID_32BIT;
 }
 
 static void bnge_hwrm_ring_free(struct bnge_net *bn, bool close_path)
@@ -2496,11 +2494,11 @@ static void bnge_hwrm_ring_free(struct bnge_net *bn, bool close_path)
 			bnge_hwrm_cp_ring_free(bn, &nqr->cp_ring_arr[j]);
 
 		ring = &nqr->ring_struct;
-		if (ring->fw_ring_id != INVALID_HW_RING_ID) {
+		if (ring->fw_ring_id != INVALID_HW_RING_ID_32BIT) {
 			hwrm_ring_free_send_msg(bn, ring,
 						RING_FREE_REQ_RING_TYPE_NQ,
 						INVALID_HW_RING_ID);
-			ring->fw_ring_id = INVALID_HW_RING_ID;
+			ring->fw_ring_id = INVALID_HW_RING_ID_32BIT;
 			bn->grp_info[i].nq_fw_ring_id = INVALID_HW_RING_ID;
 		}
 	}
diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_netdev.h b/drivers/net/ethernet/broadcom/bnge/bnge_netdev.h
index f4636b5b0cf3..d177919c2e11 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_netdev.h
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_netdev.h
@@ -630,8 +630,8 @@ struct bnge_l2_filter {
 	refcount_t		refcnt;
 };
 
-u16 bnge_cp_ring_for_rx(struct bnge_rx_ring_info *rxr);
-u16 bnge_cp_ring_for_tx(struct bnge_tx_ring_info *txr);
+u32 bnge_cp_ring_for_rx(struct bnge_rx_ring_info *rxr);
+u32 bnge_cp_ring_for_tx(struct bnge_tx_ring_info *txr);
 void bnge_fill_hw_rss_tbl(struct bnge_net *bn, struct bnge_vnic_info *vnic);
 int bnge_alloc_rx_data(struct bnge_net *bn, struct bnge_rx_ring_info *rxr,
 		       u16 prod, gfp_t gfp);
diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_rmem.h b/drivers/net/ethernet/broadcom/bnge/bnge_rmem.h
index 341c7f81ed09..bb0c79a1ee60 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_rmem.h
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_rmem.h
@@ -184,7 +184,7 @@ struct bnge_ctx_mem_info {
 struct bnge_ring_struct {
 	struct bnge_ring_mem_info	ring_mem;
 
-	u16			fw_ring_id;
+	u32			fw_ring_id;
 	union {
 		u16		grp_idx;
 		u16		map_idx; /* Used by NQs */
diff --git a/include/linux/bnge/hsi.h b/include/linux/bnge/hsi.h
index 8ea13d5407ee..1f7bd96415a5 100644
--- a/include/linux/bnge/hsi.h
+++ b/include/linux/bnge/hsi.h
@@ -8317,8 +8317,7 @@ struct hwrm_ring_alloc_output {
 	__le16	req_type;
 	__le16	seq_id;
 	__le16	resp_len;
-	__le16	ring_id;
-	__le16	logical_ring_id;
+	__le32	ring_id;
 	u8	push_buffer_index;
 	#define RING_ALLOC_RESP_PUSH_BUFFER_INDEX_PING_BUFFER 0x0UL
 	#define RING_ALLOC_RESP_PUSH_BUFFER_INDEX_PONG_BUFFER 0x1UL
@@ -8345,10 +8344,10 @@ struct hwrm_ring_free_input {
 	u8	flags;
 	#define RING_FREE_REQ_FLAGS_VIRTIO_RING_VALID 0x1UL
 	#define RING_FREE_REQ_FLAGS_LAST             RING_FREE_REQ_FLAGS_VIRTIO_RING_VALID
-	__le16	ring_id;
+	__le16	unused_1;
 	__le32	prod_idx;
 	__le32	opaque;
-	__le32	unused_1;
+	__le32	ring_id;
 };
 
 /* hwrm_ring_free_output (size:128b/16B) */
-- 
2.47.1

